# Understanding `require("./greet")` in Node.js

Many beginners get confused by this line:

```javascript
const greet = require("./greet");
```

You may think:

> ❓ `greet` is a **folder**, not a file.  
> How does Node.js know to load `index.js`?

Don't worry! This is a built-in feature of Node.js.

---

# Project Structure

```
project/
│
├── app.js
│
└── greet/
    ├── index.js
    ├── english.js
    └── hindi.js
```

---

# Step 1: `english.js`

```javascript
function english() {
    console.log("Hello");
}

module.exports = english;
```

### Explanation

- Create a function named `english`
- Export the function

This file exports **one function**.

---

# Step 2: `hindi.js`

```javascript
function hindi() {
    console.log("Namaste");
}

module.exports = hindi;
```

### Explanation

- Create a function named `hindi`
- Export the function

This file also exports **one function**.

---

# Step 3: `index.js`

```javascript
const english = require("./english");
const hindi = require("./hindi");

module.exports = {
    english,
    hindi
};
```

## What happens here?

### Line 1

```javascript
const english = require("./english");
```

Node loads

```
english.js
```

and returns

```javascript
function english() {
    console.log("Hello");
}
```

So now

```javascript
english
```

contains the function.

---

### Line 2

```javascript
const hindi = require("./hindi");
```

Node loads

```
hindi.js
```

and returns

```javascript
function hindi() {
    console.log("Namaste");
}
```

---

### Line 3

```javascript
module.exports = {
    english,
    hindi
};
```

This exports **one object**.

It is exactly the same as

```javascript
module.exports = {
    english: english,
    hindi: hindi
};
```

The exported object looks like this:

```javascript
{
    english: function english(){},
    hindi: function hindi(){}
}
```

---

# Step 4: `app.js`

```javascript
const greet = require("./greet");
```

Here comes the confusing part.

`greet` is a folder.

How does this work?

---

# Node.js Module Resolution Rule

When Node sees

```javascript
require("./greet")
```

it follows these steps.

## Step 1

Is `greet` a file?

```
No
```

↓

## Step 2

Is `greet` a folder?

```
Yes
```

↓

## Step 3

Look for

```
greet/index.js
```

↓

## Step 4

Load `index.js`

↓

## Step 5

Return whatever `index.js` exports

---

# Node.js Does This Automatically

You write

```javascript
require("./greet");
```

Node internally treats it like

```javascript
require("./greet/index.js");
```

These are all equivalent:

```javascript
require("./greet");
```

```javascript
require("./greet/index");
```

```javascript
require("./greet/index.js");
```

---

# What Does `greet` Contain?

Remember,

`index.js` exports

```javascript
{
    english,
    hindi
}
```

So

```javascript
const greet = require("./greet");
```

becomes

```javascript
const greet = {
    english: function(){},
    hindi: function(){}
};
```

---

# Calling Functions

```javascript
greet.english();
```

means

```javascript
greet["english"]();
```

which calls

```javascript
function english() {
    console.log("Hello");
}
```

Similarly,

```javascript
greet.hindi();
```

calls

```javascript
function hindi() {
    console.log("Namaste");
}
```

---

# Complete Example

## english.js

```javascript
function english() {
    console.log("Hello");
}

module.exports = english;
```

---

## hindi.js

```javascript
function hindi() {
    console.log("Namaste");
}

module.exports = hindi;
```

---

## index.js

```javascript
const english = require("./english");
const hindi = require("./hindi");

module.exports = {
    english,
    hindi
};
```

---

## app.js

```javascript
const greet = require("./greet");

greet.english();
greet.hindi();
```

### Output

```
Hello
Namaste
```

---

# Object Destructuring

Instead of

```javascript
const greet = require("./greet");

greet.english();
greet.hindi();
```

You can write

```javascript
const { english, hindi } = require("./greet");

english();
hindi();
```

Why?

Because

```javascript
require("./greet")
```

returns

```javascript
{
    english,
    hindi
}
```

Object destructuring

```javascript
const { english, hindi } = object;
```

is exactly the same as

```javascript
const english = object.english;
const hindi = object.hindi;
```

Now you can directly call

```javascript
english();
hindi();
```

without writing

```javascript
greet.
```

---

# Visual Flow

```
app.js

require("./greet")

        │
        ▼

Is greet a file?

        │
        ▼

No

        │
        ▼

Is greet a folder?

        │
        ▼

Yes

        │
        ▼

Look for

greet/index.js

        │
        ▼

Load index.js

        │
        ▼

index.js

require("./english")
require("./hindi")

        │
        ▼

Create Object

{
    english,
    hindi
}

        │
        ▼

Return Object

        │
        ▼

app.js receives

const greet = {
    english,
    hindi
}
```

---

# House Analogy

Imagine this folder:

```
greet/
```

is a house.

Inside the house are two rooms:

```
english.js

hindi.js
```

When someone visits the house, they don't directly enter a room.

They first enter through the **main door**.

The main door is

```
index.js
```

`index.js` decides which functions, variables, or objects are available to the outside world.

So,

```
require("./greet")
```

means

```
Go to the greet house

↓

Open the main door (index.js)

↓

Return whatever the main door gives you
```

---

# Summary

✅ `greet` is a folder.

✅ Node.js automatically looks for `index.js` inside the folder.

✅ `index.js` imports `english.js` and `hindi.js`.

✅ `index.js` exports an object.

✅ `require("./greet")` returns that object.

✅ `greet.english()` calls the `english()` function.

✅ `greet.hindi()` calls the `hindi()` function.

---

# Key Points to Remember

- `require("./folder")` automatically loads `folder/index.js`
- `module.exports` determines what is returned by `require()`
- A folder itself is **never executed**
- `index.js` acts as the **entry point** (main file) of the folder
- Object destructuring lets you extract exported properties directly
