
import sys, json
from pathlib import Path

# ensure repo root is on sys.path so "from query_mysql import records_exist_batch" works
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

try:
    from query_mysql import records_exist_batch
except Exception as e:
    print(json.dumps({"error": f"import error: {e}"}))
    sys.exit(1)

if len(sys.argv) != 4:
    print(json.dumps({"error": "usage: call_record_exists.py <table> <field> <id_list_comma_separated>"}))
    sys.exit(2)

table, field, id_list = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    existing_ids = records_exist_batch(table, field, id_list)
    print(json.dumps(existing_ids))
    sys.exit(0)
except Exception as e:
    print(json.dumps({"error": str(e)}))
    sys.exit(3)
