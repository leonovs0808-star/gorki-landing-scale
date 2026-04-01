#!/bin/bash
# Собирает statya.html из отдельных блоков для GitHub Pages превью
# Отдельные блоки остаются для Tilda T123

cd "$(dirname "$0")"
OUT="statya.html"

cat > "$OUT" << 'HEADER'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Механика масштабирования — Школа бизнеса Горки</title>
  <link rel="preconnect" href="https://static.tildacdn.com">
  <style>
    @font-face {
      font-family: 'TildaSans';
      src: url('https://static.tildacdn.com/fonts/tildasans/TildaSans-VF.woff2') format('woff2');
      font-weight: 100 900;
      font-style: normal;
      font-display: swap;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { background: #08110E; }
    body { font-family: 'TildaSans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }
    .t-body, .t-page, #allrecords { background: #08110E; }
    .t-rec { position: relative; margin: 0; padding: 0; }
    .t123 .t-container { max-width: 100%; padding: 0; }
    a { color: inherit; }
  </style>
  <script>localStorage.setItem('msh_unlocked','99');</script>
</head>
<body class="t-body">
<div id="allrecords" class="t-page">
HEADER

BLOCKS="01-vvedenie.html 02-masshtabirovanie.html 03-pochemu-seichas.html 04-oshibki.html 05-tochka-potentsiala.html 06-kontekst.html 07-lichnost.html 08-delo.html 09-itog.html"

for f in $BLOCKS; do
  echo "<div class=\"t-rec t123\">" >> "$OUT"
  echo "<!-- === $f === -->" >> "$OUT"
  cat "$f" >> "$OUT"
  echo "" >> "$OUT"
  echo "</div>" >> "$OUT"
done

cat >> "$OUT" << 'FOOTER'
</div><!-- /allrecords -->
</body>
</html>
FOOTER

echo "Built: $(wc -c < "$OUT") bytes → $OUT"
