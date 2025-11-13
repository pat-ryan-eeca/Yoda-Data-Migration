import sys, json
from pathlib import Path

# ensure repo root is on sys.path so "from query_mysql import record_exists" works
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

try:
    from query_mysql import record_exists
except Exception as e:
    print(json.dumps({"error": f"import error: {e}"}))
    sys.exit(1)

if len(sys.argv) != 4:
    print(json.dumps({"error": "usage: call_record_exists.py <table> <field> <value>"}))
    sys.exit(2)

table, field, value = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    out = record_exists(table, field, value)
    print(json.dumps(out))
    sys.exit(0)
except Exception as e:
    print(json.dumps({"error": str(e)}))
    sys.exit(3)