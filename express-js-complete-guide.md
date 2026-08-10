# Express.js — Complete Beginner to Pro Guide

> **Rule while using this file:** Don't just read. After every section, close this file and type the code yourself from memory. Then open it again to check. That's the only way this guide actually works.

---

## Table of Contents
1. [What is Express.js](#1-what-is-expressjs)
2. [Setup (Do This Once)](#2-setup-do-this-once)
3. [Your First Server](#3-your-first-server)
4. [Routing](#4-routing)
5. [Request & Response Objects](#5-request--response-objects)
6. [Middleware (Most Important Concept)](#6-middleware-most-important-concept)
7. [Handling POST Data (Body Parsing)](#7-handling-post-data-body-parsing)
8. [Route Parameters vs Query Parameters](#8-route-parameters-vs-query-parameters)
9. [Building a Real REST API (CRUD)](#9-building-a-real-rest-api-crud)
10. [Error Handling](#10-error-handling)
11. [Organizing Code Properly (Routers)](#11-organizing-code-properly-routers)
12. [Common Problems & How to Solve Them](#12-common-problems--how-to-solve-them)
13. [Final Practice Project](#13-final-practice-project)
14. [What to Learn After This](#14-what-to-learn-after-this)

---

## 1. What is Express.js

Express is a **framework for Node.js** that makes it easy to build servers and APIs.

Without Express, handling web requests in raw Node.js is long and painful. Express gives you simple tools like `app.get()`, `app.post()` to handle requests in a few lines.

**In simple words:** Express = a helper library that makes building a backend server easy.

---

## 2. Setup (Do This Once)

Open your terminal and type:

```bash
mkdir express-practice
cd express-practice
npm init -y
npm install express
```

What each command does:
| Command | What it does |
|---|---|
| `mkdir express-practice` | creates a folder |
| `npm init -y` | creates `package.json` (project info file) |
| `npm install express` | downloads Express into `node_modules` |

Create a file called `index.js` in that folder. All your code goes there.

---

## 3. Your First Server

**Type this yourself. Don't copy-paste.**

```js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
```

Run it:
```bash
node index.js
```

Open browser → `http://localhost:3000` → you should see "Hello World".

**Practice Task:** Change the message to your name. Change the port to `4000`. Restart and check.

---

## 4. Routing

Routing = deciding what happens when someone visits a specific URL.

```js
app.get('/', (req, res) => {
  res.send('Home Page');
});

app.get('/about', (req, res) => {
  res.send('About Page');
});

app.get('/contact', (req, res) => {
  res.send('Contact Page');
});
```

| Method | Used for |
|---|---|
| `GET` | reading/fetching data |
| `POST` | creating new data |
| `PUT` | updating existing data |
| `DELETE` | deleting data |

**Practice Task:** Add a `/services` route that sends `"Our Services"`.

---

## 5. Request & Response Objects

Every route handler gets two objects:

```js
app.get('/example', (req, res) => {
  // req  = information coming FROM the client (browser/user)
  // res  = what you send BACK to the client
});
```

Common `res` methods:
```js
res.send('text or html');
res.json({ name: 'Pathan' });   // sends JSON
res.status(404).send('Not Found'); // sets status code + message
```

**Practice Task:** Make a route `/user` that returns JSON: `{ name: "Pathan", course: "CSE" }`.

---

## 6. Middleware (Most Important Concept)

This is where most beginners get confused. Understand this slowly.

**Middleware = a function that runs BEFORE your route handler finishes the request.**

```js
app.use((req, res, next) => {
  console.log(`${req.method} request to ${req.url}`);
  next(); // IMPORTANT: without next(), the request gets stuck forever
});
```

Think of middleware like **security checkpoints** at an airport. Every request passes through them one by one before reaching the final destination (your route).

### Real Example: Logger Middleware
```js
const express = require('express');
const app = express();

// Middleware
app.use((req, res, next) => {
  console.log(`Incoming: ${req.method} ${req.url}`);
  next();
});

app.get('/', (req, res) => {
  res.send('Home');
});

app.listen(3000);
```

**Golden Rule:** If you forget `next()`, the request hangs forever and the browser keeps loading with no response. This is the #1 beginner mistake — see [Section 12](#12-common-problems--how-to-solve-them).

---

## 7. Handling POST Data (Body Parsing)

To read data sent from a form or API request (JSON), you need this middleware:

```js
app.use(express.json()); // built into Express, no extra install needed
```

Full example:
```js
const express = require('express');
const app = express();

app.use(express.json()); // MUST be added before your routes

app.post('/user', (req, res) => {
  console.log(req.body); // the data sent by the client
  res.send(`Received: ${req.body.name}`);
});

app.listen(3000);
```

**How to test POST routes (browser can't do this):**
Use **Postman** or **Thunder Client** (VS Code extension). Send:
```json
{ "name": "Pathan" }
```
to `http://localhost:3000/user` as a POST request.

**Practice Task:** Make a POST route `/add` that receives `{ "a": 5, "b": 10 }` and responds with the sum.

---

## 8. Route Parameters vs Query Parameters

These two confuse every beginner. Here's the difference, clearly:

### Route Parameters (`:id`) — part of the URL path
```js
app.get('/user/:id', (req, res) => {
  res.send(`User ID is ${req.params.id}`);
});
```
Visit: `http://localhost:3000/user/5` → shows "User ID is 5"

### Query Parameters (`?key=value`) — extra filters after `?`
```js
app.get('/search', (req, res) => {
  res.send(`Searching for: ${req.query.term}`);
});
```
Visit: `http://localhost:3000/search?term=laptop` → shows "Searching for: laptop"

| Type | Example URL | Access with |
|---|---|---|
| Route param | `/user/5` | `req.params.id` |
| Query param | `/search?term=laptop` | `req.query.term` |

**Practice Task:** Make `/product/:id` that shows the ID, AND accepts an optional `?color=red` query too.

---

## 9. Building a Real REST API (CRUD)

CRUD = Create, Read, Update, Delete. This is 90% of what backend developers build.

```js
const express = require('express');
const app = express();
app.use(express.json());

let users = [
  { id: 1, name: 'Pathan' },
  { id: 2, name: 'Rahim' }
];

// READ all
app.get('/users', (req, res) => {
  res.json(users);
});

// READ one
app.get('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).send('User not found');
  res.json(user);
});

// CREATE
app.post('/users', (req, res) => {
  const newUser = { id: users.length + 1, name: req.body.name };
  users.push(newUser);
  res.status(201).json(newUser);
});

// UPDATE
app.put('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).send('User not found');
  user.name = req.body.name;
  res.json(user);
});

// DELETE
app.delete('/users/:id', (req, res) => {
  users = users.filter(u => u.id !== parseInt(req.params.id));
  res.send('Deleted');
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

**Practice Task:** Test all 5 routes in Postman one by one. Add, view, update, delete a user. Watch the array change.

---

## 10. Error Handling

Real servers must not crash when something goes wrong. Use this pattern:

```js
app.get('/user/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.json(user);
});
```

### Global error handler (catches unexpected crashes)
Put this **at the very bottom**, after all routes:
```js
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong' });
});
```

---

## 11. Organizing Code Properly (Routers)

Once your app grows, you don't write everything in one file. You split routes into separate files.

**File: `routes/users.js`**
```js
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('All users');
});

router.get('/:id', (req, res) => {
  res.send(`User ${req.params.id}`);
});

module.exports = router;
```

**File: `index.js`**
```js
const express = require('express');
const app = express();
const userRoutes = require('./routes/users');

app.use(express.json());
app.use('/users', userRoutes); // all routes inside start with /users

app.listen(3000);
```

Now `/users` and `/users/:id` work exactly the same, but the code is clean and organized — this is how real projects are structured.

---

## 12. Common Problems & How to Solve Them

This section exists because **you WILL hit these errors**. Every beginner does. Read this before you panic.

### Problem 1: "Cannot GET /something"
**Cause:** You visited a route that doesn't exist, or you forgot `app.use(express.json())`.
**Fix:** Check your route path spelling matches exactly (case-sensitive).

### Problem 2: Server hangs forever, page keeps loading
**Cause:** You forgot to call `next()` inside a middleware, OR you forgot `res.send()`/`res.json()` in a route.
**Fix:** Every route/middleware must either call `next()` or send a response — never both, never neither.

### Problem 3: `req.body` is `undefined`
**Cause:** You forgot `app.use(express.json())` before your routes.
**Fix:** Add it right after creating `app`, before any `app.get`/`app.post`.

### Problem 4: "EADDRINUSE: address already in use :::3000"
**Cause:** A previous server is still running on that port.
**Fix (Windows):**
```bash
netstat -ano | findstr :3000
taskkill /PID <the_number_you_see> /F
```
**Fix (Mac/Linux):**
```bash
lsof -i :3000
kill -9 <the_number_you_see>
```
Or simpler: just change the port number and restart.

### Problem 5: Changes to code don't show up
**Cause:** You edited the file but didn't restart the server.
**Fix:** Stop server (`Ctrl + C`) and run `node index.js` again.
**Better Fix:** Install `nodemon` so it auto-restarts:
```bash
npm install -D nodemon
```
Then run with:
```bash
npx nodemon index.js
```

### Problem 6: Postman shows "Could not send request" / "ECONNREFUSED"
**Cause:** Your server isn't running, or wrong port.
**Fix:** Check your terminal — is `node index.js` actually running without errors?

### Problem 7: `app.use('/users', userRoutes)` routes not working
**Cause:** Wrong import path, or forgot `module.exports = router;` in the routes file.
**Fix:** Double check the file path in `require()` and the export line.

---

## 13. Final Practice Project

Build this without watching any tutorial. Use only this guide.

**Project: Simple Notes API**

Requirements:
- `GET /notes` → return all notes
- `GET /notes/:id` → return one note
- `POST /notes` → create a note (`{ "title": "...", "content": "..." }`)
- `PUT /notes/:id` → update a note
- `DELETE /notes/:id` → delete a note
- If a note is not found, return status `404` with a proper error message
- Use an array to store notes (no database yet)

Test every route in Postman before you consider it done.

---

## 14. What to Learn After This

Once you're comfortable with everything above:

1. **Connect a real database** — MongoDB (with Mongoose) is the easiest next step
2. **Environment variables** — using `.env` files with `dotenv` package
3. **Authentication** — JWT tokens, login/signup systems
4. **File uploads** — using `multer`
5. **Deployment** — put your Express server live using Render or Railway

Don't move to these until you can build the Notes API above completely from memory, without looking back at this file.

---

## Self-Check: Are You Actually "Pro" at Express Basics?

You're ready to move on only if you can answer YES to all of these:

- [ ] Can I build a GET and POST route without checking notes?
- [ ] Do I understand why `next()` is needed in middleware?
- [ ] Can I explain the difference between `req.params` and `req.query` to someone else?
- [ ] Have I built and fully tested the CRUD Users example myself (typed, not copied)?
- [ ] Have I completed the Notes API project on my own?

If any box is unchecked — don't move to the next stack. Go back and practice that section again.
