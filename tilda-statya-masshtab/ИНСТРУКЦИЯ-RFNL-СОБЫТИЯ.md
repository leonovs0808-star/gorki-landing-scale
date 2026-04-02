# Как добавить событие Refunnels на кнопку «Читать дальше»

## Предусловия
- Пиксель Refunnels (`clarity.js` с `ukgc.ru`) уже подключён в настройках Tilda — в код блока его добавлять НЕ нужно
- Каждая кнопка «Читать дальше» получает свой уникальный ID события из Refunnels

## Два шага в коде

### Шаг 1. В HTML кнопки — короткий onclick
```html
<button class="msh-btn" onclick="mshReadMoreX()">
```
Где X — номер блока (без номера для блока 01, с цифрой для остальных).

НЕ писать rfnl(...) прямо в onclick — Tilda ломает кавычки в длинных onclick.

### Шаг 2. В `<script>` того же блока — функция
```javascript
window.mshReadMoreX = function(){
  window.mshScrollTo(НОМЕР_СЛЕДУЮЩЕЙ_СЕКЦИИ);
  try { window.rfnl('ID_СОБЫТИЯ'); } catch(e) { console.log('rfnl not loaded, retrying...'); }
  setTimeout(function(){ try { window.rfnl('ID_СОБЫТИЯ'); } catch(e){} }, 1500);
};
```

## Текущий статус

| Блок | Файл | Функция | Скролл к | ID события | Статус |
|------|------|---------|----------|-----------|--------|
| 01 | 01-vvedenie.html | mshReadMore() | секция 2 | U0xqvaUDzi | ✅ готово |
| 02 | 02-masshtabirovanie.html | mshReadMore2() | секция 3 | — | ⏳ нужен ID |
| 03 | 03-pochemu-seichas.html | mshReadMore3() | секция 4 | — | ⏳ нужен ID |
| 04 | 04-oshibki.html | mshReadMore4() | секция 5 | — | ⏳ нужен ID |
| 05 | 05-tochka-potentsiala.html | mshReadMore5() | секция 6 | — | ⏳ нужен ID |
| 06 | 06-kontekst.html | mshReadMore6() | секция 7 | — | ⏳ нужен ID |
| 07 | 07-lichnost.html | mshReadMore7() | секция 8 | — | ⏳ нужен ID |
| 08 | 08-delo.html | mshReadMore8() | секция 9 | — | ⏳ нужен ID |
| 09 | 09-itog.html | — | — | — | ⏳ нужен ID (CTA кнопка) |

## Порядок действий Claude при добавлении

1. Получить ID события от пользователя
2. git checkout main && git pull origin main
3. Открыть нужный файл блока
4. Найти кнопку «Читать дальше», заменить onclick на `onclick="mshReadMoreX()"`
5. В `<script>` блока добавить функцию `window.mshReadMoreX` с правильным ID и номером следующей секции
6. cd tilda-statya-masshtab && bash build.sh
7. git add tilda-statya-masshtab/БЛОК.html tilda-statya-masshtab/statya.html
8. git commit -m "add rfnl event to block XX button"
9. git push -u origin main
10. Сказать пользователю: скопируй код блока с GitHub (Raw) → вставь в T123 на Tilda → опубликуй

## Как пользователь обновляет на Tilda

1. Открыть файл блока на GitHub: https://github.com/leonovs0808-star/gorki-landing-scale/blob/main/tilda-statya-masshtab/ФАЙЛ.html
2. Нажать Raw
3. Ctrl+A → Ctrl+C
4. В Tilda: открыть T123 блок → удалить старое → вставить новое
5. Опубликовать страницу
