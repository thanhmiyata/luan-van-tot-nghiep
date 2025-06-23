"""
Interactive SQL Generator GUI
Giao diện đơn giản để gõ câu hỏi và nhận SQL
"""
import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
import threading
import os
import json
import time
import psycopg2
import openai
from dotenv import load_dotenv

# Load environment
load_dotenv()


class SQLGeneratorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Single-Agent Text-to-SQL Generator")
        self.root.geometry("900x700")
        self.root.configure(bg='#f0f0f0')

        # Initialize backend
        self.init_backend()

        # Create GUI elements
        self.create_widgets()

        # Load schema once at startup
        self.schema_context = None
        self.load_schema_async()

    def init_backend(self):
        """Initialize database and OpenAI connections"""
        try:
            # Database config
            self.db_config = {
                'host': os.getenv('DB_HOST', 'localhost'),
                'port': int(os.getenv('DB_PORT', 5432)),
                'user': os.getenv('DB_USER', 'postgres'),
                'password': os.getenv('DB_PASSWORD', ''),
                'database': os.getenv('DB_NAME', 'dvdrental')
            }

            # OpenAI client
            self.openai_client = openai.OpenAI(
                api_key=os.getenv('OPENAI_API_KEY')
            )

            # Test connections
            self.test_connections()

        except Exception as e:
            messagebox.showerror("Initialization Error",
                                 f"Failed to initialize: {e}")

    def test_connections(self):
        """Test database and OpenAI connections"""
        # Test database
        conn = psycopg2.connect(**self.db_config)
        conn.close()

        # Test OpenAI (simple call)
        response = self.openai_client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": "Hi"}],
            max_tokens=5
        )

    def create_widgets(self):
        """Create GUI elements"""
        # Title
        title_label = tk.Label(
            self.root,
            text="🤖 Single-Agent Text-to-SQL Generator",
            font=("Arial", 16, "bold"),
            bg='#f0f0f0',
            fg='#2c3e50'
        )
        title_label.pack(pady=10)

        # Status label
        self.status_label = tk.Label(
            self.root,
            text="🔄 Loading database schema...",
            font=("Arial", 10),
            bg='#f0f0f0',
            fg='#7f8c8d'
        )
        self.status_label.pack(pady=5)

        # Main frame
        main_frame = tk.Frame(self.root, bg='#f0f0f0')
        main_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

        # Question input section
        question_frame = tk.LabelFrame(
            main_frame,
            text="📝 Nhập câu hỏi của bạn (Tiếng Việt hoặc English)",
            font=("Arial", 12, "bold"),
            fg='#2c3e50',
            bg='#f0f0f0'
        )
        question_frame.pack(fill=tk.X, pady=(0, 10))

        self.question_text = scrolledtext.ScrolledText(
            question_frame,
            height=4,
            font=("Arial", 11),
            wrap=tk.WORD,
            bg='#ffffff',
            fg='#2c3e50'
        )
        self.question_text.pack(fill=tk.X, padx=10, pady=10)

        # Example questions
        examples_text = "💡 Ví dụ: 'Có bao nhiêu phim trong database?', 'Show me top 5 film categories', 'Tìm phim có từ love'"
        example_label = tk.Label(
            question_frame,
            text=examples_text,
            font=("Arial", 9),
            fg='#7f8c8d',
            bg='#f0f0f0',
            wraplength=800
        )
        example_label.pack(padx=10, pady=(0, 10))

        # Generate button
        self.generate_button = tk.Button(
            main_frame,
            text="🚀 Generate SQL",
            font=("Arial", 12, "bold"),
            bg='#3498db',
            fg='white',
            command=self.generate_sql_async,
            cursor='hand2',
            relief=tk.FLAT,
            padx=30,
            pady=10
        )
        self.generate_button.pack(pady=10)

        # Results section
        results_frame = tk.LabelFrame(
            main_frame,
            text="📊 Kết quả",
            font=("Arial", 12, "bold"),
            fg='#2c3e50',
            bg='#f0f0f0'
        )
        results_frame.pack(fill=tk.BOTH, expand=True, pady=(10, 0))

        # SQL output
        sql_label = tk.Label(
            results_frame,
            text="🔧 SQL Query:",
            font=("Arial", 10, "bold"),
            fg='#2c3e50',
            bg='#f0f0f0'
        )
        sql_label.pack(anchor=tk.W, padx=10, pady=(10, 5))

        self.sql_text = scrolledtext.ScrolledText(
            results_frame,
            height=6,
            font=("Consolas", 10),
            wrap=tk.WORD,
            bg='#2c3e50',
            fg='#ecf0f1'
        )
        self.sql_text.pack(fill=tk.X, padx=10, pady=(0, 10))

        # Copy SQL button
        copy_frame = tk.Frame(results_frame, bg='#f0f0f0')
        copy_frame.pack(fill=tk.X, padx=10)

        self.copy_button = tk.Button(
            copy_frame,
            text="📋 Copy SQL",
            font=("Arial", 9),
            bg='#95a5a6',
            fg='white',
            command=self.copy_sql,
            cursor='hand2',
            relief=tk.FLAT
        )
        self.copy_button.pack(side=tk.LEFT)

        self.execute_button = tk.Button(
            copy_frame,
            text="⚡ Execute Query",
            font=("Arial", 9),
            bg='#27ae60',
            fg='white',
            command=self.execute_sql_async,
            cursor='hand2',
            relief=tk.FLAT
        )
        self.execute_button.pack(side=tk.LEFT, padx=(10, 0))

        # Explanation
        explanation_label = tk.Label(
            results_frame,
            text="💡 Giải thích:",
            font=("Arial", 10, "bold"),
            fg='#2c3e50',
            bg='#f0f0f0'
        )
        explanation_label.pack(anchor=tk.W, padx=10, pady=(10, 5))

        self.explanation_text = scrolledtext.ScrolledText(
            results_frame,
            height=4,
            font=("Arial", 10),
            wrap=tk.WORD,
            bg='#ffffff',
            fg='#2c3e50'
        )
        self.explanation_text.pack(fill=tk.X, padx=10, pady=(0, 10))

        # Info label
        info_label = tk.Label(
            self.root,
            text="🎯 DVD Rental Database | 💻 Windows 11 | 🤖 OpenAI GPT-3.5",
            font=("Arial", 8),
            fg='#95a5a6',
            bg='#f0f0f0'
        )
        info_label.pack(side=tk.BOTTOM, pady=5)

    def load_schema_async(self):
        """Load database schema in background"""
        def load_schema():
            try:
                self.schema_context = self.get_schema_context()
                self.root.after(0, lambda: self.status_label.config(
                    text="✅ Sẵn sàng! Hãy nhập câu hỏi của bạn",
                    fg='#27ae60'
                ))
                self.root.after(
                    0, lambda: self.generate_button.config(state=tk.NORMAL))
            except Exception as e:
                self.root.after(0, lambda: self.status_label.config(
                    text=f"❌ Lỗi tải schema: {e}",
                    fg='#e74c3c'
                ))

        self.generate_button.config(state=tk.DISABLED)
        thread = threading.Thread(target=load_schema)
        thread.daemon = True
        thread.start()

    def get_schema_context(self):
        """Get database schema information"""
        conn = psycopg2.connect(**self.db_config)
        cursor = conn.cursor()

        cursor.execute("""
            SELECT 
                t.table_name,
                c.column_name,
                c.data_type,
                c.is_nullable
            FROM information_schema.tables t
            JOIN information_schema.columns c ON t.table_name = c.table_name
            WHERE t.table_schema = 'public' 
            AND t.table_type = 'BASE TABLE'
            ORDER BY t.table_name, c.ordinal_position
        """)

        results = cursor.fetchall()

        schema_info = {}
        for table_name, column_name, data_type, is_nullable in results:
            if table_name not in schema_info:
                schema_info[table_name] = []
            schema_info[table_name].append({
                'column': column_name,
                'type': data_type,
                'nullable': is_nullable
            })

        cursor.close()
        conn.close()

        # Format schema
        context = "DVD Rental Database Schema:\n\n"
        for table_name, columns in schema_info.items():
            context += f"Table: {table_name}\n"
            for col in columns:
                nullable = "NULL" if col['nullable'] == 'YES' else "NOT NULL"
                context += f"  - {col['column']} ({col['type']}) {nullable}\n"
            context += "\n"

        context += """
Key Business Info:
- film: Movie catalog with title, description, rating, length
- actor: Actor information with first_name, last_name
- customer: Customer details and contact info
- rental: Rental transactions linking customers to inventory
- payment: Payment records for rentals
- category: Film categories (Action, Comedy, Drama, etc.)
- inventory: Available film copies in stores
- staff: Store employees
"""
        return context

    def generate_sql_async(self):
        """Generate SQL in background thread"""
        question = self.question_text.get("1.0", tk.END).strip()

        if not question:
            messagebox.showwarning("Warning", "Vui lòng nhập câu hỏi!")
            return

        if not self.schema_context:
            messagebox.showerror("Error", "Schema chưa được tải!")
            return

        def generate():
            try:
                # Update UI
                self.root.after(0, lambda: self.status_label.config(
                    text="🤖 Đang generate SQL...",
                    fg='#f39c12'
                ))
                self.root.after(
                    0, lambda: self.generate_button.config(state=tk.DISABLED))

                # Clear previous results
                self.root.after(0, lambda: self.clear_results())

                # Generate SQL
                sql, explanation, tokens = self.generate_sql_query(question)

                # Update UI with results
                self.root.after(0, lambda: self.update_results(
                    sql, explanation, tokens))

            except Exception as e:
                self.root.after(0, lambda: self.status_label.config(
                    text=f"❌ Lỗi: {e}",
                    fg='#e74c3c'
                ))
            finally:
                self.root.after(
                    0, lambda: self.generate_button.config(state=tk.NORMAL))

        thread = threading.Thread(target=generate)
        thread.daemon = True
        thread.start()

    def generate_sql_query(self, question):
        """Generate SQL using OpenAI"""
        system_prompt = f"""You are an expert PostgreSQL developer. Convert natural language questions to SQL queries.

{self.schema_context}

Rules:
1. Generate ONLY valid PostgreSQL syntax
2. Use proper table/column names from schema
3. Always use table aliases to avoid ambiguous column references
4. Handle both Vietnamese and English questions
5. Return JSON format:
{{
    "sql_query": "your SQL query here",
    "explanation": "explanation in same language as question"
}}

Be precise and accurate."""

        response = self.openai_client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": question}
            ],
            temperature=0.1,
            max_tokens=800
        )

        content = response.choices[0].message.content

        # Parse JSON response
        result = json.loads(content)
        sql_query = result.get("sql_query", "").strip()
        explanation = result.get("explanation", "")

        tokens_used = response.usage.total_tokens

        return sql_query, explanation, tokens_used

    def clear_results(self):
        """Clear previous results"""
        self.sql_text.delete("1.0", tk.END)
        self.explanation_text.delete("1.0", tk.END)

    def update_results(self, sql, explanation, tokens):
        """Update UI with results"""
        self.sql_text.delete("1.0", tk.END)
        self.sql_text.insert("1.0", sql)

        self.explanation_text.delete("1.0", tk.END)
        self.explanation_text.insert("1.0", explanation)

        self.status_label.config(
            text=f"✅ SQL generated! Tokens: {tokens}",
            fg='#27ae60'
        )

    def copy_sql(self):
        """Copy SQL to clipboard"""
        sql = self.sql_text.get("1.0", tk.END).strip()
        if sql:
            self.root.clipboard_clear()
            self.root.clipboard_append(sql)
            self.status_label.config(
                text="📋 SQL copied to clipboard!",
                fg='#3498db'
            )

    def execute_sql_async(self):
        """Execute SQL in background thread"""
        sql = self.sql_text.get("1.0", tk.END).strip()

        if not sql:
            messagebox.showwarning("Warning", "Không có SQL để execute!")
            return

        def execute():
            try:
                self.root.after(0, lambda: self.status_label.config(
                    text="⚡ Executing SQL...",
                    fg='#f39c12'
                ))

                conn = psycopg2.connect(**self.db_config)
                cursor = conn.cursor()

                start_time = time.time()
                cursor.execute(sql)
                execution_time = time.time() - start_time

                results = cursor.fetchall()
                columns = [desc[0] for desc in cursor.description]

                cursor.close()
                conn.close()

                # Show results in popup
                self.root.after(0, lambda: self.show_results_popup(
                    results, columns, execution_time))

            except Exception as e:
                self.root.after(0, lambda: messagebox.showerror(
                    "SQL Error", f"Error executing SQL:\n{e}"))
                self.root.after(0, lambda: self.status_label.config(
                    text=f"❌ SQL execution failed",
                    fg='#e74c3c'
                ))

        thread = threading.Thread(target=execute)
        thread.daemon = True
        thread.start()

    def show_results_popup(self, results, columns, execution_time):
        """Show query results in popup window"""
        popup = tk.Toplevel(self.root)
        popup.title("Query Results")
        popup.geometry("600x400")
        popup.configure(bg='#f0f0f0')

        # Title
        title = tk.Label(
            popup,
            text=f"📊 Query Results ({len(results)} rows, {execution_time:.3f}s)",
            font=("Arial", 12, "bold"),
            bg='#f0f0f0',
            fg='#2c3e50'
        )
        title.pack(pady=10)

        # Results text
        results_text = scrolledtext.ScrolledText(
            popup,
            font=("Consolas", 9),
            bg='#ffffff',
            fg='#2c3e50'
        )
        results_text.pack(fill=tk.BOTH, expand=True, padx=20, pady=(0, 20))

        # Format results
        if results:
            # Headers
            headers = " | ".join(f"{col:15}" for col in columns)
            results_text.insert(tk.END, headers + "\n")
            results_text.insert(tk.END, "-" * len(headers) + "\n")

            # Data (limit to 100 rows)
            for i, row in enumerate(results[:100]):
                row_text = " | ".join(f"{str(val)[:15]:15}" for val in row)
                results_text.insert(tk.END, row_text + "\n")

            if len(results) > 100:
                results_text.insert(
                    tk.END, f"\n... and {len(results)-100} more rows")
        else:
            results_text.insert(tk.END, "No data returned")

        self.status_label.config(
            text=f"✅ Query executed successfully! {len(results)} rows",
            fg='#27ae60'
        )


def main():
    """Main function"""
    try:
        root = tk.Tk()
        app = SQLGeneratorGUI(root)
        root.mainloop()
    except Exception as e:
        print(f"Error starting GUI: {e}")
        messagebox.showerror(
            "Startup Error", f"Failed to start application:\n{e}")


if __name__ == "__main__":
    main()
