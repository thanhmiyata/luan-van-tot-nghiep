"""
Simple LLM-based NL2SQL System Example.

This example demonstrates how to implement a basic NL2SQL system
using the nl2sql-bench framework with a single LLM call.

Usage:
    python simple_llm_system.py

Requirements:
    pip install openai  # or anthropic, google-generativeai
"""

import json
import os
from typing import Optional

from nl2sql_bench import NL2SQLInput, NL2SQLOutput, NL2SQLSystem


class SimpleLLMSystem(NL2SQLSystem):
    """
    Simple single-LLM NL2SQL system.
    
    This is a basic implementation that sends the question and schema
    directly to an LLM and asks for SQL generation.
    
    Example:
        ```python
        system = SimpleLLMSystem(
            provider="openai",
            model="gpt-4o",
            api_key="your-api-key"  # or use OPENAI_API_KEY env var
        )
        
        output = system.predict(nl2sql_input)
        print(output.sql)
        ```
    """
    
    PROMPT_TEMPLATE = """You are an SQL expert. Generate a SQL query for the following question based on the database schema.

DATABASE SCHEMA:
{schema}

QUESTION: {question}

IMPORTANT RULES:
1. Return ONLY the SQL query, nothing else
2. Do not include any explanations or markdown formatting
3. Do not wrap the query in code blocks
4. The query should be valid SQLite syntax
5. Use proper JOIN conditions when multiple tables are needed
6. Handle NULL values appropriately

SQL Query:"""

    def __init__(
        self,
        provider: str = "openai",
        model: str = "gpt-4o",
        api_key: Optional[str] = None,
        temperature: float = 0.0,
    ):
        """
        Initialize the Simple LLM System.
        
        Args:
            provider: LLM provider ("openai", "anthropic", "google").
            model: Model name for the selected provider.
            api_key: API key. If None, uses environment variable.
            temperature: Generation temperature (0.0 for deterministic).
        """
        self._version = "1.0.0"
        self.provider = provider
        self.model = model
        self.api_key = api_key
        self.temperature = temperature
        self._client = None
    
    @property
    def name(self) -> str:
        """System name for reporting."""
        return f"SimpleLLM-{self.model}"
    
    @property
    def version(self) -> str:
        """System version."""
        return self._version
    
    def _get_client(self):
        """Lazy initialize the LLM client."""
        if self._client is not None:
            return self._client
        
        if self.provider == "openai":
            try:
                from openai import OpenAI
                self._client = OpenAI(api_key=self.api_key)
            except ImportError:
                raise ImportError(
                    "openai package required. Install with: pip install openai"
                )
        
        elif self.provider == "anthropic":
            try:
                from anthropic import Anthropic
                self._client = Anthropic(api_key=self.api_key)
            except ImportError:
                raise ImportError(
                    "anthropic package required. Install with: pip install anthropic"
                )
        
        elif self.provider == "google":
            try:
                import google.generativeai as genai
                genai.configure(api_key=self.api_key or os.getenv("GOOGLE_API_KEY"))
                self._client = genai.GenerativeModel(self.model)
            except ImportError:
                raise ImportError(
                    "google-generativeai package required. "
                    "Install with: pip install google-generativeai"
                )
        
        else:
            raise ValueError(f"Unsupported provider: {self.provider}")
        
        return self._client
    
    def _format_schema(self, schema: dict) -> str:
        """Format schema for the prompt."""
        lines = [f"Database: {schema.get('db_id', 'unknown')}"]
        lines.append("")
        
        # Tables
        tables = schema.get("table_names_original", [])
        columns = schema.get("column_names_original", [])
        column_types = schema.get("column_types", [])
        
        for table_idx, table_name in enumerate(tables):
            # Get columns for this table
            table_cols = []
            for col_idx, (tbl_idx, col_name) in enumerate(columns):
                if tbl_idx == table_idx:
                    col_type = column_types[col_idx] if col_idx < len(column_types) else "TEXT"
                    table_cols.append(f"  - {col_name} ({col_type})")
            
            lines.append(f"Table: {table_name}")
            lines.extend(table_cols)
            lines.append("")
        
        # Foreign keys
        foreign_keys = schema.get("foreign_keys", [])
        if foreign_keys:
            lines.append("Foreign Keys:")
            for fk in foreign_keys:
                if len(fk) >= 2:
                    from_col = columns[fk[0]][1] if fk[0] < len(columns) else "?"
                    to_col = columns[fk[1]][1] if fk[1] < len(columns) else "?"
                    lines.append(f"  {from_col} -> {to_col}")
        
        return "\n".join(lines)
    
    def _call_openai(self, prompt: str) -> str:
        """Call OpenAI API."""
        client = self._get_client()
        response = client.chat.completions.create(
            model=self.model,
            messages=[{"role": "user", "content": prompt}],
            temperature=self.temperature,
            max_tokens=512,
        )
        return response.choices[0].message.content.strip()
    
    def _call_anthropic(self, prompt: str) -> str:
        """Call Anthropic API."""
        client = self._get_client()
        response = client.messages.create(
            model=self.model,
            max_tokens=512,
            temperature=self.temperature,
            messages=[{"role": "user", "content": prompt}],
        )
        return response.content[0].text.strip()
    
    def _call_google(self, prompt: str) -> str:
        """Call Google Generative AI API."""
        client = self._get_client()
        response = client.generate_content(prompt)
        return response.text.strip()
    
    def _call_llm(self, prompt: str) -> str:
        """Route to appropriate provider."""
        if self.provider == "openai":
            return self._call_openai(prompt)
        elif self.provider == "anthropic":
            return self._call_anthropic(prompt)
        elif self.provider == "google":
            return self._call_google(prompt)
        else:
            raise ValueError(f"Unknown provider: {self.provider}")
    
    def _clean_sql(self, sql: str) -> str:
        """Clean up LLM response to extract SQL."""
        # Remove markdown code blocks
        sql = sql.replace("```sql", "").replace("```", "")
        
        # Remove common prefixes
        prefixes_to_remove = [
            "SQL Query:", "Query:", "SQL:", "Here is the SQL:",
            "Here's the SQL:", "The SQL query is:",
        ]
        for prefix in prefixes_to_remove:
            if sql.lower().startswith(prefix.lower()):
                sql = sql[len(prefix):]
        
        return sql.strip()
    
    def predict(self, input: NL2SQLInput) -> NL2SQLOutput:
        """
        Generate SQL from natural language question.
        
        Args:
            input: NL2SQLInput with question and schema.
            
        Returns:
            NL2SQLOutput with generated SQL.
        """
        try:
            # Format the prompt
            schema_str = self._format_schema(input.schema)
            prompt = self.PROMPT_TEMPLATE.format(
                schema=schema_str,
                question=input.question,
            )
            
            # Call LLM
            response = self._call_llm(prompt)
            
            # Clean up response
            sql = self._clean_sql(response)
            
            return NL2SQLOutput(
                sql=sql,
                confidence=0.8,
                intermediate_steps=[
                    {"step": "prompt", "output": {"model": self.model}},
                ],
            )
            
        except Exception as e:
            return NL2SQLOutput(
                sql="",
                confidence=0.0,
                error=f"LLM call failed: {str(e)}",
            )


# ============================================================================
# Example Usage
# ============================================================================

def main():
    """Example: Run evaluation with SimpleLLMSystem."""
    from nl2sql_bench import SpiderDataset, Evaluator
    
    # Check for API key
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Warning: OPENAI_API_KEY not set. Set it to run evaluation.")
        print("\nExample usage:")
        print("  export OPENAI_API_KEY='your-key'")
        print("  python simple_llm_system.py")
        return
    
    # Initialize system
    system = SimpleLLMSystem(
        provider="openai",
        model="gpt-4o",
        temperature=0.0,
    )
    
    print(f"System: {system.name} v{system.version}")
    
    # Load dataset (adjust path as needed)
    spider_path = os.getenv("SPIDER_PATH", "./spider_data")
    
    if not os.path.exists(spider_path):
        print(f"\nSpider dataset not found at: {spider_path}")
        print("Set SPIDER_PATH environment variable or download Spider dataset.")
        print("\nTo download Spider:")
        print("  wget https://drive.google.com/...")
        return
    
    # Load dataset
    dataset = SpiderDataset(data_dir=spider_path, split="dev")
    print(f"Dataset: {len(dataset)} questions")
    
    # Initialize evaluator
    evaluator = Evaluator(
        dataset=dataset,
        db_dir=os.path.join(spider_path, "database"),
        output_dir="./results",
    )
    
    # Run evaluation (limit to first 10 for quick test)
    results = evaluator.run(
        system=system,
        verbose=True,
        max_questions=10,  # Remove this limit for full evaluation
    )
    
    # Print results
    print(results.summary())


if __name__ == "__main__":
    main()
