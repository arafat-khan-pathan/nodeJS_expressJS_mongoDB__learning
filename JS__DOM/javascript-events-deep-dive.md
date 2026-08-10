# JavaScript Events — Deep Dive (with Full HTML Examples) 🔔

> Every example here is a **complete, working HTML file**. Copy-paste any block into a `.html` file, open it in your browser, and see it work live. Every line of JS has a comment explaining **what it does** and **why**.

---

## 📚 Table of Contents

1. [What is an Event? (Full Example)](#1-what-is-an-event-full-example)
2. [The Event Object — Deep Dive](#2-the-event-object--deep-dive)
3. [`addEventListener()` — Full Explanation](#3-addeventlistener--full-explanation)
4. [`removeEventListener()` — Full Explanation](#4-removeeventlistener--full-explanation)
5. [DOM Level 0 vs `addEventListener` (Side by Side)](#5-dom-level-0-vs-addeventlistener-side-by-side)
6. [Event Bubbling vs Event Capturing (Full Example)](#6-event-bubbling-vs-event-capturing-full-example)
7. [`stopPropagation()` and `preventDefault()`](#7-stoppropagation-and-preventdefault)
8. [Event Delegation (Bonus — Very Important)](#8-event-delegation-bonus--very-important)
9. [Different Event Types (Mini Examples)](#9-different-event-types-mini-examples)
10. [Final Cheat Sheet](#10-final-cheat-sheet)

---

## 1. What is an Event? (Full Example)

> **Analogy:** A **doorbell**. You don't stand at the door all day watching it. You just **wait** for the "ring" (the event), and only THEN you react (open the door). `addEventListener` is you telling JS: *"Hey, when this ring happens, run this function."*

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>What is an Event</title>
</head>
<body>

  <button id="doorbell">🔔 Ring the bell</button>
  <p id="message">Waiting for someone to ring...</p>

  <script>
    // Step 1: Grab the two elements we need from the DOM.
    const bell = document.getElementById("doorbell");
    const message = document.getElementById("message");

    // Step 2: "Listen" for a click event on the bell.
    // We are NOT running the function now.
    // We are just registering it, so the browser calls it LATER,
    // only when the button is actually clicked.
    bell.addEventListener("click", function () {
      // Step 3: This code runs ONLY when the click happens.
      message.textContent = "🚪 Someone rang the bell! Opening door...";
    });
  </script>

</body>
</html>
```

### How it works, step by step:
1. Page loads → JS runs top to bottom → `addEventListener` just **registers** the function, it does NOT run it yet.
2. Browser now silently **watches** the button in the background.
3. User clicks the button → browser **fires** a `"click"` event → our function finally **runs**.
4. This is called an **event-driven** model — code reacts to actions instead of running everything immediately.

---

## 2. The Event Object — Deep Dive

Every time an event fires, the browser automatically passes an **event object** into your function. It's usually named `e` or `event`, and it carries **details about what just happened**.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Event Object</title>
</head>
<body>

  <button id="myBtn">Click me anywhere on the button</button>
  <p id="output"></p>

  <script>
    const btn = document.getElementById("myBtn");
    const output = document.getElementById("output");

    // The browser automatically gives us "e" (the event object)
    // as soon as the click happens. We didn't create it — JS did.
    btn.addEventListener("click", function (e) {
      output.innerHTML = `
        <b>Event type:</b> ${e.type} <br>
        <b>Target element:</b> ${e.target.tagName} <br>
        <b>Mouse X position:</b> ${e.clientX} <br>
        <b>Mouse Y position:</b> ${e.clientY} <br>
        <b>Time (timestamp):</b> ${e.timeStamp.toFixed(0)}ms
      `;
      // e.type      -> tells us WHICH event happened ("click")
      // e.target    -> tells us WHICH element was actually clicked
      // e.clientX/Y -> tells us WHERE on the screen the click happened
      // e.timeStamp -> tells us WHEN it happened (ms since page loaded)
    });
  </script>

</body>
</html>
```

### How it works, step by step:
- `e` is created **fresh by the browser** every single time the event fires — it's not something you build.
- `e.target` is one of the **most used** properties — it tells you the exact element the user interacted with (super useful when many elements share one listener — see [Event Delegation](#8-event-delegation-bonus--very-important)).

---

## 3. `addEventListener()` — Full Explanation

### Syntax
```js
element.addEventListener(eventType, handlerFunction, useCaptureOrOptions);
```
| Parameter | Meaning |
|---|---|
| `eventType` | A string like `"click"`, `"keydown"`, `"submit"` (no `"on"` prefix!) |
| `handlerFunction` | The function to run when the event fires |
| `useCaptureOrOptions` | Optional. `true`/`false` for capturing, or an options object like `{ once: true }` |

### Full Example — Multiple Listeners on the Same Button
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>addEventListener Explained</title>
</head>
<body>

  <button id="likeBtn">👍 Like</button>
  <p id="log"></p>

  <script>
    const likeBtn = document.getElementById("likeBtn");
    const log = document.getElementById("log");

    // Listener #1: logs a message every time
    likeBtn.addEventListener("click", function () {
      log.innerHTML += "Listener 1 fired! <br>";
    });

    // Listener #2: a COMPLETELY separate listener on the SAME event.
    // This is only possible with addEventListener — you can stack
    // as many listeners as you want on one element/event.
    likeBtn.addEventListener("click", function () {
      log.innerHTML += "Listener 2 fired! <br>";
    });

    // Listener #3: using the "once" option.
    // This listener will run ONLY the first time, then auto-remove itself.
    likeBtn.addEventListener("click", function () {
      log.innerHTML += "Listener 3 (only runs once!) <br>";
    }, { once: true });
  </script>

</body>
</html>
```

### How it works, step by step:
1. Click the button once → **all 3 listeners fire**, in the order they were registered (1 → 2 → 3).
2. Click it again → only **Listener 1 and 2** fire. Listener 3 already removed itself because of `{ once: true }`.
3. This proves `addEventListener` supports **multiple independent handlers** — something the old `onclick =` style cannot do (it would overwrite, not stack).

---

## 4. `removeEventListener()` — Full Explanation

> **Important rule:** To remove a listener later, the function **must be a named function** stored in a variable — NOT an anonymous inline function. JavaScript needs to know exactly *which* function to remove.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>removeEventListener Explained</title>
</head>
<body>

  <button id="startBtn">Start Tracking Clicks</button>
  <button id="stopBtn">Stop Tracking Clicks</button>
  <p id="counter">Clicks: 0</p>

  <script>
    const startBtn = document.getElementById("startBtn");
    const stopBtn = document.getElementById("stopBtn");
    const counter = document.getElementById("counter");

    let clicks = 0;

    // This is a NAMED function (not written inline).
    // Because it has a name/reference, we CAN remove it later.
    function trackClick() {
      clicks++;
      counter.textContent = "Clicks: " + clicks;
    }

    // Clicking "startBtn" attaches the listener to the WHOLE page (document).
    startBtn.addEventListener("click", function () {
      document.addEventListener("click", trackClick);
      // Note: this click on startBtn itself will also count,
      // because the listener is added to "document" which includes startBtn.
    });

    // Clicking "stopBtn" removes that same listener.
    stopBtn.addEventListener("click", function () {
      // We pass the EXACT SAME function reference (trackClick)
      // that we used in addEventListener. This is how JS matches
      // and removes the correct listener.
      document.removeEventListener("click", trackClick);
    });
  </script>

</body>
</html>
```

### How it works, step by step:
1. Click **"Start Tracking Clicks"** → now `trackClick` is attached to the whole `document`.
2. Every click anywhere on the page → `clicks` goes up.
3. Click **"Stop Tracking Clicks"** → `removeEventListener` finds the exact same `trackClick` function reference and **detaches** it.
4. After that, clicking anywhere does **nothing** anymore — the counter stops increasing.

❌ **Common mistake (this will NOT work):**
```js
document.addEventListener("click", function () { clicks++; }); // anonymous
document.removeEventListener("click", function () { clicks++; }); // a DIFFERENT function! Won't remove anything.
```
Even though they look identical, JavaScript treats each `function(){}` as a **brand-new, separate function** in memory. You must use the **same named reference** for removal to work.

---

## 5. DOM Level 0 vs `addEventListener` (Side by Side)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>DOM Level 0 vs addEventListener</title>
</head>
<body>

  <button id="oldStyle">Old Style (DOM Level 0)</button>
  <button id="newStyle">New Style (addEventListener)</button>
  <p id="result"></p>

  <script>
    const oldStyle = document.getElementById("oldStyle");
    const newStyle = document.getElementById("newStyle");
    const result = document.getElementById("result");

    // ---------- DOM LEVEL 0 STYLE ----------
    // Assigning directly to the ".onclick" property.
    oldStyle.onclick = function () {
      result.textContent = "First handler (Level 0)";
    };
    // If we assign ANOTHER function to .onclick, it OVERWRITES the first one.
    oldStyle.onclick = function () {
      result.textContent = "Second handler REPLACED the first one!";
    };
    // Only the second one will ever run. The first is gone completely.

    // ---------- addEventListener STYLE ----------
    newStyle.addEventListener("click", function () {
      result.textContent += " | Handler A fired";
    });
    newStyle.addEventListener("click", function () {
      result.textContent += " | Handler B fired";
    });
    // BOTH handlers run — nothing gets overwritten.
  </script>

</body>
</html>
```

| Feature | DOM Level 0 (`onclick =`) | `addEventListener()` |
|---|---|---|
| Multiple handlers on same event? | ❌ No (overwrites) | ✅ Yes (stacks) |
| Can remove a specific handler? | ❌ Not cleanly | ✅ Yes, with `removeEventListener` |
| Control bubbling/capturing? | ❌ No | ✅ Yes (3rd argument) |
| Recommended for real projects? | ❌ Avoid | ✅ Yes, always use this |

---

## 6. Event Bubbling vs Event Capturing (Full Example)

> **Analogy:** Picture **3 nested boxes**: a small box inside a medium box inside a big box. If you poke the small box:
> - **Bubbling** = the poke "bubbles up" — small box feels it first, then medium, then big (like ripples spreading outward from water).
> - **Capturing** = the opposite direction — big box feels it first, then medium, then small (like a signal traveling INWARD before bubbling back out).

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bubbling vs Capturing</title>
  <style>
    #grandparent { padding: 40px; background: #ffd6d6; }
    #parent      { padding: 40px; background: #d6e4ff; }
    #child       { padding: 40px; background: #d6ffd8; }
  </style>
</head>
<body>

  <div id="grandparent">Grandparent
    <div id="parent">Parent
      <div id="child">Child (click me!)</div>
    </div>
  </div>

  <p id="log"></p>

  <script>
    const grandparent = document.getElementById("grandparent");
    const parent = document.getElementById("parent");
    const child = document.getElementById("child");
    const log = document.getElementById("log");

    function addLog(text) {
      log.innerHTML += text + "<br>";
    }

    // ---------- BUBBLING (default, 3rd argument = false) ----------
    // Event starts at "child" (the actual click target)
    // and travels UP to parent, then grandparent.
    child.addEventListener("click", () => addLog("1️⃣ Child (bubbling)"), false);
    parent.addEventListener("click", () => addLog("2️⃣ Parent (bubbling)"), false);
    grandparent.addEventListener("click", () => addLog("3️⃣ Grandparent (bubbling)"), false);

    // Try clicking "Child" text — watch the log fill in order 1 → 2 → 3.
    // This proves bubbling goes from the INSIDE element OUTWARD.
  </script>

</body>
</html>
```

### Now let's see Capturing (change `false` to `true`):
```html
<script>
  // ---------- CAPTURING (3rd argument = true) ----------
  // Event travels from OUTSIDE (document) INWARD to the target FIRST,
  // before the bubbling phase even starts.
  grandparent.addEventListener("click", () => addLog("1️⃣ Grandparent (capturing)"), true);
  parent.addEventListener("click", () => addLog("2️⃣ Parent (capturing)"), true);
  child.addEventListener("click", () => addLog("3️⃣ Child (capturing)"), true);

  // Now clicking "Child" logs in order: Grandparent → Parent → Child
  // Opposite order compared to bubbling!
</script>
```

### How it works, step by step:
1. Every click event actually happens in **3 phases**: **Capturing phase** (top → down) → **Target phase** (the clicked element itself) → **Bubbling phase** (bottom → up).
2. By default, `addEventListener` listens during the **bubbling phase** (3rd argument `false` or omitted).
3. Passing `true` makes it listen during the **capturing phase** instead.
4. In real projects, you'll use **bubbling (default)** 95% of the time. Capturing is a rare, advanced tool.

---

## 7. `stopPropagation()` and `preventDefault()`

These two are **often confused** — they do **completely different jobs**.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>stopPropagation vs preventDefault</title>
  <style>
    #outer { padding: 30px; background: #ffe9b3; }
    #inner { padding: 20px; background: #b3e0ff; }
  </style>
</head>
<body>

  <div id="outer">Outer box
    <div id="inner">Inner box (click me)</div>
  </div>

  <hr>

  <a id="link" href="https://example.com">Click this link (watch what happens)</a>
  <p id="log2"></p>

  <script>
    const outer = document.getElementById("outer");
    const inner = document.getElementById("inner");

    // ---------- stopPropagation() ----------
    // This STOPS the event from bubbling up further.
    // It does NOT stop the element's default browser behavior.
    outer.addEventListener("click", () => alert("Outer box clicked!"));

    inner.addEventListener("click", function (e) {
      alert("Inner box clicked!");
      e.stopPropagation();
      // Because of this line, the click will NOT bubble up to "outer".
      // So the "Outer box clicked!" alert will NEVER show when
      // you click the inner box directly.
    });

    // ---------- preventDefault() ----------
    // This STOPS the browser's built-in default action.
    // It does NOT stop the event from bubbling.
    const link = document.getElementById("link");
    const log2 = document.getElementById("log2");

    link.addEventListener("click", function (e) {
      e.preventDefault();
      // Normally, clicking a link navigates to the href page.
      // preventDefault() stops that default navigation from happening.
      log2.textContent = "Link click was intercepted — page did NOT navigate!";
    });
  </script>

</body>
</html>
```

| Method | What it stops | What it does NOT stop |
|---|---|---|
| `e.stopPropagation()` | The event from **bubbling/capturing** to other elements | The browser's default action (like link navigation) |
| `e.preventDefault()` | The browser's **default behavior** (navigating, form submitting, checkbox toggling) | The event from bubbling to parent elements |

---

## 8. Event Delegation (Bonus — Very Important)

> **Analogy:** Instead of hiring **one security guard per room** in a building, you hire **ONE guard at the main entrance** who watches everyone coming in — smarter and cheaper. Event delegation = put **ONE listener on the parent**, and use `e.target` to figure out which child was actually clicked.

This is hugely useful for **dynamic lists** (like a to-do list where items get added/removed constantly).

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Event Delegation</title>
</head>
<body>

  <ul id="todoList">
    <li>Buy milk</li>
    <li>Walk the dog</li>
    <li>Learn DOM</li>
  </ul>
  <button id="addBtn">Add New Item</button>

  <script>
    const todoList = document.getElementById("todoList");
    const addBtn = document.getElementById("addBtn");
    let itemCount = 3;

    // Instead of adding a click listener to EVERY <li> one by one
    // (which would also miss any NEW <li> added later),
    // we add ONE listener to the PARENT <ul>.
    todoList.addEventListener("click", function (e) {
      // e.target tells us EXACTLY which <li> was clicked,
      // even though the listener lives on the parent <ul>.
      if (e.target.tagName === "LI") {
        e.target.style.textDecoration = "line-through";
        e.target.style.color = "gray";
      }
    });

    // New items added later are AUTOMATICALLY covered too —
    // because the listener is on the parent, not on each item.
    addBtn.addEventListener("click", function () {
      itemCount++;
      const newItem = document.createElement("li");
      newItem.textContent = "New task #" + itemCount;
      todoList.appendChild(newItem);
      // No need to add a new click listener here — it just works!
    });
  </script>

</body>
</html>
```

### How it works, step by step:
1. We attach **only one** listener — to `todoList` (the `<ul>`), not to each `<li>`.
2. Thanks to **bubbling**, a click on any `<li>` travels up through the `<ul>`, where our listener catches it.
3. `e.target` tells us the **exact** element that was really clicked.
4. Bonus: items added **later** (like "New task #4") are automatically clickable too — no extra code needed. This is impossible with individual listeners unless you re-attach them every time.

---

## 9. Different Event Types (Mini Examples)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Different Event Types</title>
</head>
<body>

  <!-- 1. MOUSE EVENTS -->
  <button id="hoverBox">Hover over me</button>

  <!-- 2. KEYBOARD EVENTS -->
  <input type="text" id="textInput" placeholder="Type something...">

  <!-- 3. FORM EVENTS -->
  <form id="myForm">
    <input type="text" id="username" placeholder="Username" required>
    <button type="submit">Submit</button>
  </form>

  <!-- 4. WINDOW/DOCUMENT EVENTS -->
  <p id="loadStatus">Loading...</p>

  <script>
    // ---------- 1. MOUSE EVENT ----------
    const hoverBox = document.getElementById("hoverBox");
    hoverBox.addEventListener("mouseover", function () {
      hoverBox.textContent = "You're hovering! 🖱️";
    });
    hoverBox.addEventListener("mouseout", function () {
      hoverBox.textContent = "Hover over me";
    });

    // ---------- 2. KEYBOARD EVENT ----------
    const textInput = document.getElementById("textInput");
    textInput.addEventListener("keydown", function (e) {
      console.log("Key pressed:", e.key);
      // e.key tells us EXACTLY which key was pressed, e.g. "a", "Enter", "Backspace"
    });

    // ---------- 3. FORM EVENT ----------
    const myForm = document.getElementById("myForm");
    myForm.addEventListener("submit", function (e) {
      e.preventDefault(); // stop the page from refreshing (default form behavior)
      const username = document.getElementById("username").value;
      alert("Form submitted with username: " + username);
    });

    // ---------- 4. WINDOW/DOCUMENT EVENT ----------
    // Fires when the HTML has been fully parsed
    // (doesn't wait for images/CSS — faster than "load")
    document.addEventListener("DOMContentLoaded", function () {
      document.getElementById("loadStatus").textContent = "✅ DOM fully loaded and ready!";
    });
  </script>

</body>
</html>
```

### Quick notes on each:
- **`mouseover` / `mouseout`** → fire when the cursor enters/leaves an element.
- **`keydown`** → fires while a key is being pressed down (use `e.key` to know which one).
- **`submit`** → fires when a form is submitted; almost always paired with `e.preventDefault()` so the page doesn't reload.
- **`DOMContentLoaded`** → fires as soon as the HTML structure is ready (best place to put your starting JS code, especially if your `<script>` is in the `<head>`).

---

## 10. Final Cheat Sheet

| Concept | Key Idea |
|---|---|
| **Event** | An action that happened (click, keypress, submit, etc.) |
| **Event Object (`e`)** | Auto-given details about the event (`e.type`, `e.target`, `e.key`...) |
| **`addEventListener`** | Modern way to listen; supports multiple handlers + bubbling/capturing control |
| **`removeEventListener`** | Removes a listener — but ONLY if you pass the exact same named function |
| **DOM Level 0 (`onclick =`)** | Old way; only one handler allowed, gets overwritten |
| **Bubbling** | Event travels inside → outward (child → parent → ...) — this is the default |
| **Capturing** | Event travels outside → inward (root → ... → child) — opt-in with `true` |
| **`stopPropagation()`** | Stops the event from bubbling/capturing further |
| **`preventDefault()`** | Stops the browser's default action (link navigation, form reload, etc.) |
| **Event Delegation** | One listener on a parent, using `e.target` to handle all children — even future ones |

---

**Practice challenge:** Build a small **click-to-delete list** using event delegation (topic 8) + `preventDefault()` on a form (topic 9) to add new items without refreshing the page. That single mini-project touches almost every idea in this file.
