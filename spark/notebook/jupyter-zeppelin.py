import json
import sys

try:
    import nbformat as nbf
except ImportError:
    print("Please run: pip install nbformat")
    sys.exit(1)


def tsv_to_html(tsv_data):
    """Converts Zeppelin tab-separated result data to an HTML table."""
    lines = tsv_data.strip().split('\n')
    if not lines:
        return ""

    html = ['<div style="overflow-x: auto">', '<table border="1">']

    headers = lines[0].split('\t')
    html.append('<thead><tr>' + ''.join(f'<th>{h}</th>' for h in headers) + '</tr></thead>')

    html.append('<tbody>')
    for line in lines[1:]:
        row = line.split('\t')
        html.append('<tr>' + ''.join(f'<td>{c}</td>' for c in row) + '</tr>')
    html.append('</tbody></table></div>')

    return ''.join(html)


def convert_zpln(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8-sig') as f:
        zpln = json.load(f)

    nb = nbf.v4.new_notebook()
    nb.metadata = {
        "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3"
        }
    }

    cells = []

    for paragraph in zpln.get('paragraphs', []):
        source_code = paragraph.get('text', '')

        if not source_code.strip():
            continue

        stripped = source_code.strip()

        # ---------------------------
        # CREATE CELL TYPE
        # ---------------------------
        if stripped.startswith('%md'):
            clean_source = source_code.replace('%md', '', 1).strip()
            cell = nbf.v4.new_markdown_cell(clean_source)
            is_code_cell = False

        else:
            # Keep SQL / Spark / Python as code
            cell = nbf.v4.new_code_cell(source_code)
            cell.outputs = []  # ✅ FIX 2: initialize outputs
            is_code_cell = True

        # ---------------------------
        # PROCESS OUTPUTS (ONLY FOR CODE)
        # ---------------------------
        if is_code_cell and 'results' in paragraph and 'msg' in paragraph['results']:
            for msg in paragraph['results']['msg']:
                msg_type = msg.get('type')
                data = msg.get('data', '')

                try:
                    if msg_type == 'TABLE':
                        html_table = tsv_to_html(data)
                        output = nbf.v4.new_output(
                            output_type='display_data',
                            data={'text/html': html_table}
                        )
                        cell.outputs.append(output)

                    elif msg_type == 'HTML':
                        output = nbf.v4.new_output(
                            output_type='display_data',
                            data={'text/html': data}
                        )
                        cell.outputs.append(output)

                    elif msg_type == 'TEXT':
                        output = nbf.v4.new_output(
                            output_type='stream',
                            name='stdout',
                            text=data
                        )
                        cell.outputs.append(output)

                except Exception as e:
                    print(f"Warning: Skipping output due to error: {e}")

        cells.append(cell)

    nb.cells = cells

    with open(output_path, 'w', encoding='utf-8') as f:
        nbf.write(nb, f)

    print(f"✅ Success! Converted '{input_path}' → '{output_path}'")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 jupyter-zeppelin.py <input.zpln> <output.ipynb>")
    else:
        convert_zpln(sys.argv[1], sys.argv[2])