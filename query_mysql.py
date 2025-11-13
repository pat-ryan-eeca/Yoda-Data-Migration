"""Small helper to query MySQL from Python.

Usage:
  - Set connection info via environment variables (MYSQL_HOST, MYSQL_PORT, MYSQL_USER,
    MYSQL_PASSWORD, MYSQL_DATABASE). Optionally create a `.env` and use python-dotenv.
  - Install driver: `python -m pip install mysql-connector-python`
  - Optional for SQLAlchemy: `python -m pip install sqlalchemy mysql-connector-python`

"""
from __future__ import annotations

import csv
import os
import re
import logging
from typing import Any, Dict, List, Optional, Tuple

try:
    import mysql.connector
    from mysql.connector import Error as MySQLError
except Exception:  # pragma: no cover - helpful for machines without the package
    mysql = None  # type: ignore
    mysql = None
    MySQLError = Exception

# Configure logging
logger = logging.getLogger(__name__)
log_file =  ".\\logs\\query_mysql.log"
log_level = os.environ.get("PYTHON_LOG_LEVEL", "INFO")

# Create logs directory if it doesn't exist
os.makedirs(os.path.dirname(log_file) or ".", exist_ok=True)

# Set up file handler
handler = logging.FileHandler(log_file, encoding="utf-8")
handler.setLevel(getattr(logging, log_level))
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(getattr(logging, log_level))


def get_db_config_from_env() -> Dict[str, Any]:
    """Read DB connection info from env with sane defaults."""
    return {
        "host": os.environ.get("MYSQL_HOST", "localhost"),
        "port": int(os.environ.get("MYSQL_PORT", "3306")),
        "user": os.environ.get("MYSQL_USER", "root"),
        "password": os.environ.get("MYSQL_PASSWORD", ""),
        "database": os.environ.get("MYSQL_DATABASE", None),
    }


def query_mysql(sql: str, params: Optional[Tuple[Any, ...]] = None) -> List[Dict[str, Any]]:
    """Execute a parameterized query using mysql-connector-python.

    Returns rows as list of dicts (column name -> value).

    Raises the underlying connector exception on error.
    """
    if mysql is None:
        raise RuntimeError("mysql-connector-python is not installed. Install with: pip install mysql-connector-python")

    cfg = get_db_config_from_env()
    conn = None
    cursor = None
    try:
        conn = mysql.connector.connect(
            host=cfg["host"],
            port=cfg["port"],
            user=cfg["user"],
            password=cfg["password"],
            database=cfg["database"],
        )
        cursor = conn.cursor(dictionary=True)
        logger.info(f"Executing query: {sql} with params: {params}")

          # Normalize params to a tuple and validate placeholder count
        if params is None:
            params_tuple = ()
        elif isinstance(params, (list, tuple)):
            params_tuple = tuple(params)
        else:
            params_tuple = (params,)

        expected_placeholders = sql.count("%s")
        if expected_placeholders != len(params_tuple):
            raise ValueError(
                f"SQL expects {expected_placeholders} parameter(s) but {len(params_tuple)} provided. "
                f"SQL: {sql!r} params: {params_tuple!r}"
            )

      
        cursor.execute(sql, params or ())
        rows = cursor.fetchall()
        return rows
    except MySQLError:
        # Re-raise so callers can handle/log if they want.
        raise
    finally:
        if cursor is not None:
            try:
                cursor.close()
            except Exception:
                pass
        if conn is not None:
            try:
                conn.close()
            except Exception:
                pass



def record_exists(table: str, field: str, value: Any) -> bool:
    """Return True if exactly one record exists in `table` where `field` = value,
    return False if no records, and raise ValueError if more than one record is found.

    Table and field names are validated to avoid SQL injection.
    """
    # Validate identifiers (allow letters, digits and underscores, must not start with a digit)
    ident_re = r'^[A-Za-z_][A-Za-z0-9_]*$'
    if not re.match(ident_re, table):
        raise ValueError(f"Invalid table name: {table!r}")
    if not re.match(ident_re, field):
        raise ValueError(f"Invalid field name: {field!r}")

    # Use backticks for identifiers and a parameter placeholder for the value
    sql = f"SELECT 1 FROM `{table}` WHERE `{field}` = %s LIMIT 2"

    # query_mysql returns list[dict]; check the number of returned rows
    rows = query_mysql(sql, (value,))
    if len(rows) == 0:
        return False
    if len(rows) == 1:
        return True
    raise ValueError(f"More than one record found in {table} where {field}={value!r}")


record_exists(field="RECORD_ID", table="DIM_CLA_CLIENT_ACCOUNT", value="123")