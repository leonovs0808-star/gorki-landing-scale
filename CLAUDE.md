# Проект: Лендинг "Механика масштабирования" для Школы бизнеса Горки

## Суть проекта
Конвертация React/Lovable лендинга (scale.gorkybusiness.school) в чистый HTML/CSS/JS для Tilda CMS (school-gorki.ru/scale).
Страница разбита на 8 T123 HTML-блоков + 1 Zero Block (дерево), с CSS в блоке 1 и JS в блоке 7.
Цель — pixel-perfect совпадение с оригиналом Lovable, работающее в ограничениях Tilda.

## Живые URL
- **Оригинал (Lovable):** https://scale.gorkybusiness.school
- **Продакшн (Tilda):** https://school-gorki.ru/scale
- **Другой проект Горки (Zero Block импортирован оттуда):** https://gorkybusiness.school/scale/

## Структура файлов

```
tilda-blocks/
  block-01-css.html     — CSS-стили для всей страницы
  block-02-content.html — Герой + Что происходит + Кризисы + О школе + Анти-МВА
  block-03-content.html — Выпускники + Сообщество + Целевая аудитория
  block-04a-content.html — Попечительский совет + Программа (до дерева)
  [Zero Block]          — Дерево методологии (импортирован из другого проекта Tilda)
  block-04b-content.html — Референс-визит + Локация + Преподаватели + Миссия (после дерева)
  block-05-content.html — Карусель отзывов
  block-06-content.html — FAQ + inline Marquiz + Подвал
  block-07-scripts.html — Весь JavaScript
```

## Ключевые технические ограничения Tilda

1. **T123 блоки ≤ 40KB** — HTML разбит на части по границам секций
2. **Каждый T123 блок — независимый HTML-контекст** — теги не переносятся между блоками
3. **Tilda вырезает `<link>` теги** — внешний CSS грузится через `@import url(...)` внутри `<style>`
4. **Tilda переопределяет цвета ссылок** — нужны `!important` оверрайды
5. **React ставил `opacity: 0` и `transform: translateY(...)` на элементы** — снимаем через CSS и JS

## CSS (block-01)

### Tailwind CSS
Загружается через `@import url('https://scale.gorkybusiness.school/assets/index-e29d3z3F.css')` — первая строка в `<style>`. Tilda вырезает `<link>` теги, поэтому `@import` — единственный работающий способ.

### Шрифты
Tilda Sans загружается с CDN Tilda: `static.tildacdn.com/fonts/tildasans/` (веса 400-900).

### Цветовая схема
- Фон: `hsl(160, 55%, 5%)` (очень тёмный teal)
- Акцент: `hsl(160, 60%, 42%)` (зелёный)
- Светлый фон секций: `hsl(155, 35%, 94%)`

### Важные CSS-фиксы
- `opacity: 1 !important` на всех элементах (кроме Marquiz)
- `overflow-y: auto !important` + `touch-action: pan-y pan-x !important` на Tilda-обёртках (`.t-rec`, `.t123`, `.t-body`, `#allrecords`) — fix скролла на мобильных
- `touch-action: pan-y !important` на `.t396__artboard` — Zero Block не блокирует тач-скролл
- Переопределение цвета ссылок Tilda на `color: inherit !important`
- SVG робот: анимации bob, wobble, shadow pulse
- Progress bars: width override через CSS
- Speaker фото: rounded borders, адаптивные размеры

## JavaScript (block-07)

### Marquiz
- ID квиза: `68c3bfd9cb49020019f482c8` (Васильева)
- Все CTA кнопки ("записаться", "получить программу" и т.д.) открывают `Marquiz.showModal(id)` — НЕ через hash (hash вызывает скролл)
- Inline Marquiz встроен в block-06

### Мобильный скролл фикс
При DOMContentLoaded принудительно ставит:
- `overflow-y: auto` на body/html
- `touch-action: pan-y pan-x` на всех Tilda-обёртках
- `touch-action: pan-y` на Zero Block артбордах

### React transform fix
Убирает `transform: translateX/Y` с элементов, но пропускает:
- Marquiz контейнеры
- Карусель
- nav
- Tilda-обёртки (`.t-rec`, `.t123`, `.t-body`)

### Мобильное бургер-меню
Создаёт `position: fixed` меню с навигационными ссылками + CTA "Записаться" (открывает Marquiz popup).

### Speaker hover tooltips
Desktop: показывает при hover. Mobile: показывает при тапе на 4 секунды.

### FAQ аккордеон
Single-open (закрывает остальные при открытии). Анимация max-height + opacity 0.3s.

### Карусель отзывов
Prev/next кнопки, dot-навигация, авто-прокрутка каждые 8 секунд.

### Navbar scroll effect
Фон + backdrop-blur появляются при скролле > 50px.

### Progress bars
JS читает текст процентов и ставит width (React ставил `width: 0px` inline).

### Exit-intent popup
- **Desktop:** mouseout + clientY < 0 + relatedTarget === null → модальное окно
- **Mobile:** 60% скролла ИЛИ 20 секунд (что раньше) → нижний баннер
- Проверяет флаг `marquizFilled` (квиз уже заполнен — не показывать)
- URL статьи: `https://gorkybusiness.school/blog/` (placeholder, нужно обновить)

### Logo click → scroll to top
Плавный скролл наверх при клике на логотип.

## Решённые проблемы (история)

1. **Tilda T123 size limit** → разбиение HTML на блоки по границам секций
2. **Tilda вырезает `<link>` теги** → `@import url(...)` внутри `<style>` (КРИТИЧНО — без этого Tailwind CSS не загружается и адаптация не работает)
3. **Шрифты CORS** → загрузка с CDN Tilda вместо Lovable
4. **Оранжевые/жёлтые ссылки** → `color: inherit !important`
5. **Dot pattern на отзывах** → скрыт через JS
6. **Progress bars пустые** → JS читает % и ставит width
7. **Дерево сломано** → импортирован Zero Block из другого проекта
8. **Скролл при открытии Marquiz** → убран старый scroll-to-form handler, используется только `showModal()`
9. **`transform: none !important` на всех элементах ломал мобильный скролл** → selective JS fix
10. **Градиент на секции программы** → удалён
11. **Мобильный скролл не работает** → `touch-action: pan-y`, `overflow: visible`, убран `stopPropagation()` с CTA

## Нерешённые / в процессе

1. **Проверить, загружается ли Tailwind CSS через @import** — последняя правка, нужно загрузить обновлённый block-01 на Tilda и проверить
2. **URL статьи для exit-intent** — сейчас placeholder `gorkybusiness.school/blog/`, нужен реальный URL
3. **Робот SVG** — анимация через CSS (bob/wobble), но в оригинале была React-анимация
4. **Текст из "Текст ЛЕНДА Интенсива.md"** — замены текста упоминались, но не завершены
5. **Адаптация под мобильные** — после загрузки Tailwind CSS через @import должна заработать, нужна проверка

## Как деплоить на Tilda

1. В Tilda открыть страницу school-gorki.ru/scale
2. Каждый block-XX файл → отдельный T123 блок (Другое → HTML-код)
3. Порядок блоков: 01 → 02 → 03 → 04a → [Zero Block дерево] → 04b → 05 → 06 → 07
4. Zero Block импортирован из gorkybusiness.school/scale/ — не трогать
5. При обновлении: скопировать содержимое файла целиком в соответствующий T123 блок

## Marquiz параметры (inline embed в block-06)
```javascript
{
  id: '68c3bfd9cb49020019f482c8',
  buttonText: '«Старт»',
  bgColor: '#fbcbbc',
  textColor: '#1a2e2a',
  rounded: true,
  shadow: 'rgba(251, 203, 188, 0.5)',
  blicked: true,
  fixed: false,
  buttonOnMobile: true,
  disableOnMobile: false,
  fullWidth: true
}
```
