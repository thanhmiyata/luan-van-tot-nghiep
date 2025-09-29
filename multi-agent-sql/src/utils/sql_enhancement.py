"""
SQL enhancement and formatting utilities
"""

import re
import sqlparse
from typing import Optional, Dict, Any, List
from loguru import logger


class SQLEnhancer:
    """Utility class for SQL formatting and enhancement"""

    @staticmethod
    def format_sql(sql: str, reindent: bool = True, strip_comments: bool = False) -> str:
        """
        Format SQL query for better readability

        Args:
            sql: Raw SQL query
            reindent: Whether to reindent the SQL
            strip_comments: Whether to remove comments

        Returns:
            Formatted SQL query
        """
        try:
            if not sql or not sql.strip():
                return sql

            # Use sqlparse to format the SQL
            formatted = sqlparse.format(
                sql,
                reindent=reindent,
                keyword_case='upper',
                identifier_case='lower',
                strip_comments=strip_comments,
                use_space_around_operators=True
            )

            return formatted.strip()

        except Exception as e:
            logger.warning(f"Failed to format SQL: {e}")
            return sql

    @staticmethod
    def validate_sql_syntax(sql: str) -> Dict[str, Any]:
        """
        Validate SQL syntax using sqlparse

        Args:
            sql: SQL query to validate

        Returns:
            Dictionary with validation results
        """
        result = {
            'is_valid': False,
            'error': None,
            'parsed_tokens': [],
            'statement_type': None
        }

        try:
            if not sql or not sql.strip():
                result['error'] = "Empty SQL query"
                return result

            # Parse the SQL
            parsed = sqlparse.parse(sql)

            if not parsed:
                result['error'] = "Could not parse SQL"
                return result

            # Get the first statement
            statement = parsed[0]
            result['parsed_tokens'] = [str(token)
                                       for token in statement.tokens]

            # Determine statement type
            first_token = statement.token_first(skip_ws=True, skip_cm=True)
            if first_token:
                result['statement_type'] = first_token.ttype or str(
                    first_token).upper()

            # Basic validation checks
            sql_upper = sql.upper().strip()

            # Check for common SQL keywords
            sql_keywords = ['SELECT', 'INSERT', 'UPDATE',
                            'DELETE', 'CREATE', 'DROP', 'ALTER']
            has_keyword = any(sql_upper.startswith(keyword)
                              for keyword in sql_keywords)

            if not has_keyword:
                result['error'] = "SQL does not start with a valid keyword"
                return result

            # Check for balanced parentheses
            open_parens = sql.count('(')
            close_parens = sql.count(')')
            if open_parens != close_parens:
                result['error'] = f"Unbalanced parentheses: {open_parens} open, {close_parens} close"
                return result

            # Check for balanced quotes
            single_quotes = sql.count("'") - sql.count("\\'")
            double_quotes = sql.count('"') - sql.count('\\"')
            if single_quotes % 2 != 0:
                result['error'] = "Unbalanced single quotes"
                return result
            if double_quotes % 2 != 0:
                result['error'] = "Unbalanced double quotes"
                return result

            result['is_valid'] = True

        except Exception as e:
            result['error'] = f"Validation error: {str(e)}"

        return result

    @staticmethod
    def extract_table_names(sql: str) -> List[str]:
        """
        Extract table names from SQL query

        Args:
            sql: SQL query

        Returns:
            List of table names found in the query
        """
        table_names = []

        try:
            parsed = sqlparse.parse(sql)
            if not parsed:
                return table_names

            statement = parsed[0]

            # Look for FROM and JOIN clauses
            from_seen = False
            join_keywords = ['JOIN', 'INNER JOIN',
                             'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN']

            for token in statement.flatten():
                if token.ttype is sqlparse.tokens.Keyword:
                    token_upper = str(token).upper()
                    if token_upper == 'FROM':
                        from_seen = True
                    elif any(token_upper.endswith(join) for join in join_keywords):
                        from_seen = True
                elif from_seen and token.ttype is None and str(token).strip():
                    # Potential table name
                    table_name = str(token).strip()
                    if table_name and not table_name.upper() in ['ON', 'WHERE', 'GROUP', 'ORDER', 'HAVING']:
                        # Clean table name (remove aliases, schema prefixes)
                        table_name = table_name.split()[0]  # Remove alias
                        if '.' in table_name:
                            table_name = table_name.split(
                                '.')[-1]  # Remove schema
                        table_names.append(table_name)
                        from_seen = False

        except Exception as e:
            logger.warning(f"Failed to extract table names: {e}")

        return list(set(table_names))  # Remove duplicates

    @staticmethod
    def clean_sql(sql: str) -> str:
        """
        Clean SQL query by removing extra whitespace and comments

        Args:
            sql: Raw SQL query

        Returns:
            Cleaned SQL query
        """
        if not sql:
            return sql

        try:
            # Remove extra whitespace
            sql = re.sub(r'\s+', ' ', sql.strip())

            # Remove line comments
            sql = re.sub(r'--.*$', '', sql, flags=re.MULTILINE)

            # Remove block comments
            sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)

            # Clean up again after comment removal
            sql = re.sub(r'\s+', ' ', sql.strip())

            return sql

        except Exception as e:
            logger.warning(f"Failed to clean SQL: {e}")
            return sql

    @staticmethod
    def add_semicolon(sql: str) -> str:
        """
        Add semicolon to SQL query if missing

        Args:
            sql: SQL query

        Returns:
            SQL query with semicolon
        """
        if not sql:
            return sql

        sql = sql.strip()
        if sql and not sql.endswith(';'):
            sql += ';'

        return sql

    @staticmethod
    def remove_semicolon(sql: str) -> str:
        """
        Remove semicolon from SQL query

        Args:
            sql: SQL query

        Returns:
            SQL query without semicolon
        """
        if not sql:
            return sql

        sql = sql.strip()
        if sql.endswith(';'):
            sql = sql[:-1].strip()

        return sql

    @staticmethod
    def normalize_sql(sql: str) -> str:
        """
        Normalize SQL query for comparison purposes

        Args:
            sql: SQL query to normalize

        Returns:
            Normalized SQL query
        """
        if not sql:
            return sql

        try:
            # Clean the SQL
            normalized = SQLEnhancer.clean_sql(sql)

            # Convert to uppercase for keywords
            normalized = sqlparse.format(
                normalized,
                keyword_case='upper',
                identifier_case='lower',
                strip_comments=True
            )

            # Remove extra whitespace again
            normalized = re.sub(r'\s+', ' ', normalized.strip())

            # Remove semicolon for comparison
            normalized = SQLEnhancer.remove_semicolon(normalized)

            return normalized

        except Exception as e:
            logger.warning(f"Failed to normalize SQL: {e}")
            return sql


# Convenience functions
def format_sql(sql: str, reindent: bool = True) -> str:
    """Convenience function to format SQL"""
    return SQLEnhancer.format_sql(sql, reindent=reindent)


def validate_sql_syntax(sql: str) -> Dict[str, Any]:
    """Convenience function to validate SQL syntax"""
    return SQLEnhancer.validate_sql_syntax(sql)
