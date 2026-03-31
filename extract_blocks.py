import json, sys, os

# Read blocks from stdin (JSON)
data = json.load(sys.stdin)
outdir = os.path.join(os.path.dirname(__file__), "tilda-blocks")
os.makedirs(outdir, exist_ok=True)

prefix = "https://scale.gorkybusiness.school"

for name, html in data.items():
    # Fix relative paths
    html = html.replace('src="/assets/', f'src="{prefix}/assets/')
    html = html.replace('href="/assets/', f'href="{prefix}/assets/')
    
    filepath = os.path.join(outdir, f"{name}.html")
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Saved {name}: {len(html)} bytes -> {filepath}")

