# Node.js + Express.js — All Code Reference

## Setup Commands

```bash
# create project folder
mkdir express-practice
cd express-practice

# create package.json
npm init     #You answer questions
npm init -y  #Automatically accepts defaults. Means yes to all default questions.

# install express
npm install express

# install nodemon (auto-restart on save) as dev dependency
npm install nodemon            #This installs nodemon as a normal dependency
npm install -g nodemon         #Install nodemon globally
npm install -D nodemon         #-D is short for --save-dev. Install nodemon as a development dependency.
npm install --save-dev nodemon #Install nodemon as a development dependency.
npm install nodemon --save-dev #Install nodemon as a development dependency.

node index.js                  #Run the app normally
nodemon app.js                 #Start app.js with automatic restart. This expects nodemon to be available as a command in your system PATH. if Nodemon was installed globally: (npm install -g nodemon)
npx nodemon index.js           #npx looks for nodemon in your project's local node_modules/.bin first. If it's not found, it will look for it in your system PATH.(npm install --save-dev nodemon) without installing Nodemon globally. Server autometically restarts when change in code.

npx #"npm package runner". It runs a package from my project without needing a global installation.Run a package from my project without needing a global installation."

#Command and Purpose
npm install express	            #Install Express
npm install nodemon	            #Install Nodemon as a normal dependency
npm install --save-dev nodemon	#Install Nodemon as a development dependency
npm run dev	                    #the dev script. Server autometically restarts when change in code.
npm run                         #the start script. Server starts normally. npm run and npm run start same.
nodemon app.js                	#Start app.js with automatic restart
node app.js                   	#Start app.js normally
npx nodemon app.js           	#Start app.js with automatic restart. This expects nodemon to be available as a command in your system PATH. if Nodemon was installed globally: (npm install -g nodemon)
npx nodemon index.js          	#npx looks for nodemon in your project's local node_modules/.bin first. If it's not found, it will look for it in your system PATH.(npm install --save-dev nodemon) without installing Nodemon globally. Server autometically restarts when change in code.
```

---

###### Package.json

```json

{
  "scripts": {
    "dev": "nodemon app.js",
    "start": "node app.js"
  }
}
```

---

## Pure Node.js (No Express) — Basic Server

```js
// import the built-in http module
const http = require('http');

// create a server manually
const server = http.createServer((req, res) => {
  // set response header
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  // send response body
  res.end('Hello from pure Node.js');
});

// start listening on port 3000
server.listen(3000, () => {
  console.log('Node server running on port 3000');
});
```

```js
// pure Node.js - handling different routes manually (no Express)
const http = require('http');

const server = http.createServer((req, res) => {
  if (req.url === '/' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Home Page');
  } else if (req.url === '/about' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('About Page');
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Page not found');
  }
});

server.listen(3000, () => console.log('Server running on port 3000'));
```

```js
// Node.js core modules examples

const fs = require('fs'); // file system module
const path = require('path'); // path handling module
const os = require('os'); // operating system info module

// write a file
fs.writeFileSync('test.txt', 'Hello File');

// read a file
const data = fs.readFileSync('test.txt', 'utf8');
console.log(data);

// join paths safely (works on Windows and Linux both)
const fullPath = path.join(__dirname, 'files', 'test.txt');
console.log(fullPath);

// get OS info
console.log(os.platform()); // e.g. 'win32', 'linux'
```

---

## Express.js — Basic Server

```js
// import express
const express = require('express');
// create app instance
const app = express();

// define a route for GET request to home page
app.get('/', (req, res) => {
  res.send('Hello World'); // send plain text response
});

// start server on port 3000
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
```

---

## Routing

```js
const express = require('express');
const app = express();

// GET route for home page
app.get('/', (req, res) => {
  res.send('Home Page');
});

// GET route for about page
app.get('/about', (req, res) => {
  res.send('About Page');
});

// GET route for contact page
app.get('/contact', (req, res) => {
  res.send('Contact Page');
});

// POST route example
app.post('/submit', (req, res) => {
  res.send('Form submitted');
});

// PUT route example
app.put('/update', (req, res) => {
  res.send('Data updated');
});

// DELETE route example
app.delete('/remove', (req, res) => {
  res.send('Data deleted');
});

app.listen(3000, () => console.log('Server running'));
```

---

## Request & Response Basics

```js
const express = require('express');
const app = express();

app.get('/example', (req, res) => {
  res.send('plain text response'); // sends plain text
});

app.get('/json-example', (req, res) => {
  res.json({ name: 'Pathan', course: 'CSE' }); // sends JSON response
});

app.get('/status-example', (req, res) => {
  res.status(404).send('Not Found'); // custom status code + message
});

app.get('/status-json', (req, res) => {
  res.status(201).json({ message: 'Created successfully' }); // status + JSON
});

app.listen(3000);
```

---

## Middleware

```js
const express = require('express');
const app = express();

// custom middleware - runs on every request
app.use((req, res, next) => {
  console.log(`${req.method} request to ${req.url}`); // log every request
  next(); // pass control to the next middleware/route - REQUIRED
});

app.get('/', (req, res) => {
  res.send('Home');
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

```js
// middleware applied to a SPECIFIC route only
const express = require('express');
const app = express();

// this middleware only runs for requests starting with /admin
const checkAuth = (req, res, next) => {
  const isLoggedIn = false; // pretend auth check
  if (!isLoggedIn) {
    return res.status(401).send('Unauthorized'); // stop request here
  }
  next(); // continue if authorized
};

app.get('/admin', checkAuth, (req, res) => {
  res.send('Welcome Admin');
});

app.listen(3000);
```

---

## Body Parsing (Reading POST Data)

```js
const express = require('express');
const app = express();

// built-in middleware to parse incoming JSON request bodies
app.use(express.json());

// built-in middleware to parse URL-encoded form data (HTML forms)
app.use(express.urlencoded({ extended: true }));

app.post('/user', (req, res) => {
  console.log(req.body); // access the data sent by client
  res.send(`Received: ${req.body.name}`);
});

app.post('/add', (req, res) => {
  const { a, b } = req.body; // destructure values from body
  const sum = a + b;
  res.json({ result: sum });
});

app.listen(3000, () => console.log('Server running'));
```

---

## Route Parameters vs Query Parameters

```js
const express = require('express');
const app = express();

// route parameter - part of the URL path (e.g. /user/5)
app.get('/user/:id', (req, res) => {
  res.send(`User ID is ${req.params.id}`); // access via req.params
});

// multiple route parameters
app.get('/user/:id/order/:orderId', (req, res) => {
  res.send(`User ${req.params.id}, Order ${req.params.orderId}`);
});

// query parameter - after ? in URL (e.g. /search?term=laptop)
app.get('/search', (req, res) => {
  res.send(`Searching for: ${req.query.term}`); // access via req.query
});

// combining route param + query param
app.get('/product/:id', (req, res) => {
  const id = req.params.id;
  const color = req.query.color || 'default'; // optional query param
  res.send(`Product ${id}, Color: ${color}`);
});

app.listen(3000, () => console.log('Server running'));
```

---

## Full CRUD REST API

```js
const express = require('express');
const app = express();
app.use(express.json()); // needed to read JSON body in POST/PUT

// in-memory data store (array acting as fake database)
let users = [
  { id: 1, name: 'Pathan' },
  { id: 2, name: 'Rahim' }
];

// CREATE - add new user
app.post('/users', (req, res) => {
  const newUser = {
    id: users.length + 1, // simple auto-increment id
    name: req.body.name
  };
  users.push(newUser); // add to array
  res.status(201).json(newUser); // 201 = Created
});

// READ - get all users
app.get('/users', (req, res) => {
  res.json(users);
});

// READ - get single user by id
app.get('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
});

// UPDATE - edit existing user by id
app.put('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ error: 'User not found' });
  user.name = req.body.name; // update field
  res.json(user);
});

// DELETE - remove user by id
app.delete('/users/:id', (req, res) => {
  const exists = users.some(u => u.id === parseInt(req.params.id));
  if (!exists) return res.status(404).json({ error: 'User not found' });
  users = users.filter(u => u.id !== parseInt(req.params.id)); // remove from array
  res.json({ message: 'Deleted successfully' });
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

---

## Error Handling

```js
const express = require('express');
const app = express();
app.use(express.json());

let users = [{ id: 1, name: 'Pathan' }];

// route-level error handling with early return
app.get('/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) {
    return res.status(404).json({ error: 'User not found' }); // stop here
  }
  res.json(user);
});

// try-catch for code that might throw an error
app.get('/risky/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id);
    if (isNaN(id)) throw new Error('Invalid ID format');
    res.send(`Valid ID: ${id}`);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 404 handler for routes that don't exist at all - place after all routes
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// global error handler - catches unexpected server crashes
// must have exactly 4 parameters (err, req, res, next) for Express to recognize it
app.use((err, req, res, next) => {
  console.error(err.stack); // log the error for debugging
  res.status(500).json({ error: 'Something went wrong on the server' });
});

app.listen(3000, () => console.log('Server running'));
```

---

## Organizing Code with Routers (Multi-File Structure)

```js
// FILE: routes/users.js
const express = require('express');
const router = express.Router(); // create a mini express app just for routing

let users = [{ id: 1, name: 'Pathan' }];

// note: paths here are relative to wherever this router is mounted
router.get('/', (req, res) => {
  res.json(users);
});

router.get('/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ error: 'Not found' });
  res.json(user);
});

router.post('/', (req, res) => {
  const newUser = { id: users.length + 1, name: req.body.name };
  users.push(newUser);
  res.status(201).json(newUser);
});

module.exports = router; // export so index.js can use it
```

```js
// FILE: index.js (main entry file)
const express = require('express');
const app = express();

const userRoutes = require('./routes/users'); // import the router file

app.use(express.json());

// mount the router - all routes inside userRoutes now start with /users
app.use('/users', userRoutes);

app.listen(3000, () => console.log('Server running on port 3000'));
```

---

## Environment Variables (.env)

```bash
# install dotenv package
npm install dotenv
```

```
# FILE: .env
PORT=3000
DB_URL=mongodb://localhost:27017/mydb
```

```js
// FILE: index.js
require('dotenv').config(); // load variables from .env into process.env
const express = require('express');
const app = express();

// use environment variable instead of hardcoding
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Server is running');
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

---

## Static Files (Serving HTML/CSS/Images)

```js
const express = require('express');
const app = express();
const path = require('path');

// serve everything inside the "public" folder as static files
// e.g. public/style.css becomes accessible at /style.css
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(3000, () => console.log('Server running'));
```

---

## Nodemon Config (Auto-Restart Setup)

```json
// FILE: package.json - add a "scripts" section
{
  "name": "express-practice",
  "version": "1.0.0",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
```

```bash
# run in dev mode (auto-restarts on file save)
npm run dev
```

---

## Complete Working Notes API (Practice Project Solution Reference)

```js
const express = require('express');
const app = express();
app.use(express.json());

// in-memory notes storage
let notes = [];
let nextId = 1; // auto-increment counter

// CREATE a note
app.post('/notes', (req, res) => {
  const { title, content } = req.body;
  const newNote = { id: nextId++, title, content };
  notes.push(newNote);
  res.status(201).json(newNote);
});

// READ all notes
app.get('/notes', (req, res) => {
  res.json(notes);
});

// READ one note
app.get('/notes/:id', (req, res) => {
  const note = notes.find(n => n.id === parseInt(req.params.id));
  if (!note) return res.status(404).json({ error: 'Note not found' });
  res.json(note);
});

// UPDATE a note
app.put('/notes/:id', (req, res) => {
  const note = notes.find(n => n.id === parseInt(req.params.id));
  if (!note) return res.status(404).json({ error: 'Note not found' });
  note.title = req.body.title ?? note.title; // update only if provided
  note.content = req.body.content ?? note.content;
  res.json(note);
});

// DELETE a note
app.delete('/notes/:id', (req, res) => {
  const exists = notes.some(n => n.id === parseInt(req.params.id));
  if (!exists) return res.status(404).json({ error: 'Note not found' });
  notes = notes.filter(n => n.id !== parseInt(req.params.id));
  res.json({ message: 'Note deleted' });
});

app.listen(3000, () => console.log('Notes API running on port 3000'));

```
------


# Express.js — Fresh Code (Work Divide) => Step 01 process

A basic Express server split into three files: `index.js`, `route.js`, and `controller.js`. Separate files for routing and controller logic.

## Folder Structure

```
project/
├── index.js
├── route.js
└── controller.js
```

---

## `index.js`

Entry point of the app — creates the server and starts it.

```javascript
import express from 'express';
import { userLogin, userSignup } from './controller.js';
import router from './route.js';

const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send("Hello, world");
});

app.use('/user', router);

app.listen(PORT, () => {
    console.log('Server Run');
});
```

---

## `route.js`

Defines the routes and connects them to their controller functions.

```javascript
import express from 'express';
import { userLogin, userSignup } from './controller.js';

const router = express.Router();

router.get('/login', userLogin);
router.get('/signup', userSignup);

export default router;
```

---

## `controller.js`

Contains the actual logic that runs when a route is hit.

```javascript
export const userLogin = (req, res) => {
    res.send('this is user login route');
}

export const userSignup = (req, res) => {
    res.send('this is user signup route');
}
```

---

## How it connects

1. **`index.js`** starts the server and imports the router.
2. **`route.js`** maps URL paths (`/login`, `/signup`) to controller functions.
3. **`controller.js`** holds the logic that sends the response.

---

# EJS Setup with Express 

EJS (Embedded JavaScript) is a templating engine that lets you write HTML with plain JS mixed in, so your server can send dynamic pages instead of plain text.


## 1. Install

```bash
npm install ejs
```

You don't `require`/`import` ejs directly in most cases — Express uses it automatically once you set it as the view engine.

---

## 2. Folder Structure

```
project/
├── index.js
├── route.js
├── controller.js
├── views/
│   ├── index.ejs
│   ├── login.ejs
│   ├── signup.ejs
│   └── partials/
│       ├── header.ejs
│       └── footer.ejs
└── public/
    ├── css/
    │   └── style.css
    ├── js/
    │   └── script.js
    └── images/
```

- **`views/`** → all your `.ejs` template files live here (Express looks here by default).
- **`views/partials/`** → reusable chunks (navbar, header, footer) you include in multiple pages.
- **`public/`** → static files (CSS, client-side JS, images) served directly to the browser.

---
# Structuring an Express App

A well-structured Express app follows the **MVC (Model-View-Controller)** pattern.

## Express App Folder Structure

```text
/project-root
│
├── /src
│   ├── /routes          # API routes
│   ├── /controllers     # Handles request logic
│   ├── /models          # Database models
│   ├── /middlewares     # Custom middlewares
│   ├── /config          # Configuration files
│   └── /utils           # Helper functions
│
├── /public               # Static assets (CSS, images)
├── /views                # Views (if using templating engine)
├── /node_modules         # Dependencies
│
├── .env                  # Environment variables
├── package.json          # Project metadata & dependencies
└── server.js             # Entry point

```

## 3. Setup in `index.js`

```javascript
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3000;

// Tell Express to use EJS as the view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files (css, js, images)
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
    res.render('index', { title: 'Home Page' });   //index.ejs file. only file name not extension.
});

app.listen(PORT, () => {
    console.log('Server Run');
});
```

> `__dirname` doesn't exist by default in ES module (`import`) syntax, so the `fileURLToPath` lines above recreate it. If you're using `require()` instead of `import`, you can skip that and use `__dirname` directly.

---

## 4. Example Template — `views/index.ejs`

```html
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <%- include('partials/header') %>

    <h1>Welcome, <%= title %></h1>

    <%- include('partials/footer') %>
</body>
</html>
```

### EJS Tags Cheat Sheet

| Tag | Meaning |
|---|---|
| `<%= value %>` | Output a value, HTML-escaped (safe for text) |
| `<%- value %>` | Output raw HTML (used for includes/partials) |
| `<% code %>` | Run JS logic — no output (loops, if statements) |

---

## 5. Passing Data from Route → Template

```javascript
router.get('/login', (req, res) => {
    res.render('login', { error: null });
});
```

```html
<!-- views/login.ejs -->
<% if (error) { %>
    <p class="error"><%= error %></p>
<% } %>
<form action="/login" method="POST">
    <input type="text" name="username">
    <button type="submit">Login</button>
</form>
```

---

## 6. Quick Recap

1. `npm install ejs`
2. `app.set('view engine', 'ejs')`
3. Put templates in `views/`
4. Put CSS/JS/images in `public/` and serve with `express.static`
5. Use `res.render('filename', { data })` instead of `res.send()`
