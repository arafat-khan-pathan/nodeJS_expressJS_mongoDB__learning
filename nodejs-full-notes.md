# 📘 Node.js Full Notes (Beginner Friendly)

> Made for: Learning MERN Stack (MongoDB, Express, React, Node.js) → then Next.js
> Style: Easy English + Comments in every code example

---

## 📑 Table of Contents

1. What is Node.js?
2. How Node.js Works (Important Concept)
3. Installing Node.js
4. Your First Node.js Program
5. Modules (require & module.exports)
6. npm and package.json
7. Core Module: `fs` (File System)
8. Core Module: `path`
9. Core Module: `os`
10. Core Module: `events`
11. Core Module: `http` (Create a Server)
12. Asynchronous JavaScript (Callback, Promise, Async/Await)
13. Error Handling
14. Streams and Buffers
15. Environment Variables
16. Simple REST API (without Express)
17. Intro to Express.js (Next Step)
18. Best Practices
19. Roadmap: What to Learn Next

---

## 1. What is Node.js?

> **Simple definition:** Node.js is NOT a programming language. It is a **runtime environment** that lets you run JavaScript **outside the browser** — for example, on a server or your computer.

Before Node.js, JavaScript could only run inside a web browser (like Chrome). Node.js uses Chrome's **V8 Engine** to run JavaScript anywhere.

**Why Node.js is popular for MERN stack:**
- Same language (JavaScript) for frontend (React) and backend (Node.js)
- Fast and lightweight
- Huge community and npm packages
- Good for building APIs and real-time apps

```js
// This is a normal JavaScript file, but we run it using Node.js
// Save this as app.js and run: node app.js

console.log("Hello, I am running JavaScript outside the browser!");
```

---

## 2. How Node.js Works (Important Concept)

This is the MOST important concept in Node.js. Please understand this carefully.

### Key Points:
- Node.js is **single-threaded** (only one main thread runs your code)
- Node.js is **non-blocking** (it does not wait for slow tasks to finish)
- Node.js uses an **Event Loop** to handle many tasks at the same time

### Simple Example to Understand Non-Blocking Behavior:

```js
// fs = file system module (built-in in Node.js)
const fs = require('fs');

console.log("1. Start reading file..."); 
// Step 1: This runs first

// This is a slow task (reading a file)
// Node.js does NOT wait here. It moves to the next line immediately.
fs.readFile('example.txt', 'utf8', (err, data) => {
  // This function runs LATER, only when file reading is complete
  console.log("3. File data:", data);
});

console.log("2. End of program (but Node.js is still working in background)");

// OUTPUT ORDER will be:
// 1. Start reading file...
// 2. End of program (but Node.js is still working in background)
// 3. File data: ...
```

**Why this matters:** In many languages, the program would STOP and wait for the file to be read (this is called "blocking"). But Node.js continues running other code and comes back later. This makes Node.js very fast for handling many users at once (good for servers).

---

## 3. Installing Node.js

1. Go to https://nodejs.org
2. Download the **LTS version** (LTS = Long Term Support = more stable)
3. Install it like a normal software
4. Check installation using terminal/command prompt:

```bash
# Check Node.js version
node -v

# Check npm version (npm comes automatically with Node.js)
npm -v
```

---

## 4. Your First Node.js Program

```js
// File name: app.js

// console.log() prints text to the terminal (not browser console)
console.log("Hello World from Node.js!");

// You can also do simple calculations
let a = 5;
let b = 10;
console.log("Sum is:", a + b); // Sum is: 15
```

Run it in terminal:
```bash
node app.js
```

---

## 5. Modules (require & module.exports)

> **What is a module?** A module is just a JavaScript file. Node.js lets you split code into multiple files and connect them together. This keeps code organized (very important for big MERN projects).

### Creating and Exporting a Module

```js
// File: math.js

// This function adds two numbers
function add(a, b) {
  return a + b;
}

// This function subtracts two numbers
function subtract(a, b) {
  return a - b;
}

// module.exports lets other files use these functions
// We are exporting an object with 2 functions inside
module.exports = { add, subtract };
```

### Importing (using) that Module

```js
// File: app.js

// require() is used to import another file/module
// './math' means math.js is in the SAME folder
const math = require('./math');

// Now we can use the functions from math.js
console.log(math.add(5, 3));      // 8
console.log(math.subtract(5, 3)); // 2
```

### Built-in Modules Example

```js
// Node.js has many built-in modules, no installation needed
// Example: 'os' module gives info about your computer

const os = require('os');

console.log("Your OS platform:", os.platform()); // e.g. 'win32', 'linux'
console.log("Free memory:", os.freemem());        // free RAM in bytes
```

### Note: CommonJS vs ES Modules
There are 2 ways to write modules in Node.js:

| Style | Import | Export |
|---|---|---|
| CommonJS (older, default in Node.js) | `require('./file')` | `module.exports` |
| ES Modules (modern, same as React uses) | `import x from './file'` | `export default x` |

```js
// ES Module style (needs "type": "module" in package.json)

// Exporting (file: math.js)
export function add(a, b) {
  return a + b;
}

// Importing (file: app.js)
import { add } from './math.js';
console.log(add(2, 3)); // 5
```

> 💡 Tip: For MERN stack projects, many developers now use ES Modules because it matches React's import/export style.

---

## 6. npm and package.json

**npm** = Node Package Manager. It helps you install ready-made code packages (libraries) so you don't have to write everything from scratch.

### Initialize a Project

```bash
# This creates a package.json file for your project
npm init -y
# -y means "yes to all default settings" (skip questions)
```

### package.json (example file)

```json
{
  "name": "my-node-app",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

- `"name"` → project name
- `"main"` → entry file of your app
- `"scripts"` → shortcuts to run commands
- `"dependencies"` → packages your project needs

### Installing Packages

```bash
# Install express package (a framework for building servers)
npm install express

# Install a package only for development (like nodemon)
npm install --save-dev nodemon

# Uninstall a package
npm uninstall express
```

### Running Scripts

```bash
# This runs the "start" script defined in package.json
npm start
```

---

## 7. Core Module: `fs` (File System)

The `fs` module lets you read, write, update, and delete files.

```js
const fs = require('fs');

// ---- WRITE A FILE ----
// fs.writeFile(path, content, callback)
fs.writeFile('notes.txt', 'Hello, this is my note!', (err) => {
  if (err) throw err; // if error happens, stop and show error
  console.log('File created successfully!');
});

// ---- READ A FILE ----
// 'utf8' means we want the text in readable format (not raw bytes)
fs.readFile('notes.txt', 'utf8', (err, data) => {
  if (err) throw err;
  console.log('File content:', data);
});

// ---- APPEND (ADD MORE TEXT) TO A FILE ----
fs.appendFile('notes.txt', '\nThis is a new line.', (err) => {
  if (err) throw err;
  console.log('Text added!');
});

// ---- DELETE A FILE ----
fs.unlink('notes.txt', (err) => {
  if (err) throw err;
  console.log('File deleted!');
});
```

> ⚠️ These are **async** (non-blocking) versions. There are also **sync** versions like `fs.readFileSync()` which WAIT and block the code. Async is preferred for real projects.

```js
// Synchronous version (blocks code until done)
// Use only when necessary, e.g. simple scripts
const data = fs.readFileSync('notes.txt', 'utf8');
console.log(data);
```

---

## 8. Core Module: `path`

The `path` module helps you work with file and folder paths correctly (works on Windows, Linux, Mac all the same way).

```js
const path = require('path');

const filePath = '/users/pathan/projects/app.js';

console.log(path.basename(filePath)); // app.js  → gets file name
console.log(path.dirname(filePath));  // /users/pathan/projects → gets folder path
console.log(path.extname(filePath));  // .js → gets file extension

// path.join() safely combines folder/file names into one path
const fullPath = path.join('folder1', 'folder2', 'file.txt');
console.log(fullPath); // folder1/folder2/file.txt (or folder1\folder2\file.txt on Windows)

// __dirname is a special variable = current folder of this file
console.log('Current folder:', __dirname);
```

---

## 9. Core Module: `os`

The `os` module gives information about the computer running the code.

```js
const os = require('os');

console.log('Platform:', os.platform());       // e.g. linux, win32, darwin
console.log('CPU Architecture:', os.arch());    // e.g. x64
console.log('Total Memory:', os.totalmem());    // in bytes
console.log('Free Memory:', os.freemem());      // in bytes
console.log('Home Directory:', os.homedir());   // user's home folder
```

---

## 10. Core Module: `events`

Node.js has a special class called `EventEmitter`. It lets you create **custom events** — one part of your code "emits" (fires) an event, and another part "listens" for it. This is a core idea behind how Node.js handles things.

```js
// Import the events module
const EventEmitter = require('events');

// Create an object that can emit events
const myEmitter = new EventEmitter();

// Step 1: Set up a "listener" - this waits for the 'greet' event
myEmitter.on('greet', (name) => {
  console.log(`Hello, ${name}! Welcome.`);
});

// Step 2: "Emit" (trigger/fire) the event with data
myEmitter.emit('greet', 'Pathan');
// Output: Hello, Pathan! Welcome.

// You can emit the same event multiple times
myEmitter.emit('greet', 'Student');
// Output: Hello, Student! Welcome.
```

> 💡 Real-life use: Node.js's `http` server, streams, etc. all use EventEmitter internally. Understanding this helps you understand Node.js better.

---

## 11. Core Module: `http` (Create a Server)

This is how you create a web server WITHOUT any framework (before learning Express).

```js
// Import the built-in http module
const http = require('http');

// createServer() takes a function that runs EVERY TIME
// someone visits your server (makes a request)
const server = http.createServer((req, res) => {
  // req = request (data coming FROM the browser/client)
  // res = response (data we SEND BACK to the browser/client)

  console.log('Someone visited:', req.url); // shows the URL path visited

  // Set response header (tells browser what type of content is coming)
  res.writeHead(200, { 'Content-Type': 'text/plain' });

  // Send the actual response text
  res.end('Hello! This is my first Node.js server.');
});

// Start the server and make it "listen" on port 3000
server.listen(3000, () => {
  console.log('Server is running at http://localhost:3000');
});
```

### Handling Different Routes (URLs)

```js
const http = require('http');

const server = http.createServer((req, res) => {
  // Check which URL path the user requested
  if (req.url === '/') {
    res.end('Welcome to Home Page');
  } else if (req.url === '/about') {
    res.end('This is About Page');
  } else {
    // If no route matches, send 404 (not found)
    res.writeHead(404);
    res.end('Page Not Found');
  }
});

server.listen(3000, () => {
  console.log('Server running on port 3000');
});
```

> 💡 Note: Writing routes like this manually is hard for big apps. That's why we use **Express.js** — it makes routing much easier (see Section 17).

---

## 12. Asynchronous JavaScript (Callback, Promise, Async/Await)

This is VERY important for Node.js because most Node.js operations (reading files, database calls, API calls) are asynchronous (they take time and don't block the code).

### A. Callback (Old Style)

```js
// A callback is just a function passed into another function,
// which runs LATER when the task is done.

function getUserData(callback) {
  setTimeout(() => {
    // simulate a slow task (like fetching from database)
    callback('Pathan'); // after 2 seconds, send back the data
  }, 2000);
}

getUserData((name) => {
  console.log('User data received:', name);
});
console.log('This line runs first, before user data arrives!');
```

**Problem with callbacks:** If you have many async tasks one after another, you get "Callback Hell" (deeply nested code, hard to read):

```js
// Example of Callback Hell (avoid this style)
getUser(1, (user) => {
  getPosts(user.id, (posts) => {
    getComments(posts[0].id, (comments) => {
      console.log(comments); // too many nested callbacks!
    });
  });
});
```

### B. Promises (Better Style)

A **Promise** represents a value that will be available LATER (success or failure).

```js
// Creating a Promise
function getUserData() {
  // A promise takes a function with 2 parameters: resolve and reject
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      const success = true;

      if (success) {
        resolve('Pathan'); // task successful, send the result
      } else {
        reject('Error: User not found'); // task failed
      }
    }, 2000);
  });
}

// Using the Promise
getUserData()
  .then((name) => {
    console.log('Success:', name); // runs if resolve() was called
  })
  .catch((error) => {
    console.log('Failed:', error); // runs if reject() was called
  });
```

### C. Async/Await (Best & Most Modern Style)

`async/await` makes asynchronous code LOOK like normal step-by-step code. This is the style used most in real MERN projects.

```js
// Same getUserData() Promise function from above is used here

// "async" keyword before function means this function returns a Promise
async function main() {
  try {
    // "await" pauses this function until the Promise finishes
    // (it does NOT block the whole program, only this function)
    const name = await getUserData();
    console.log('User is:', name);
  } catch (error) {
    // catch any error/rejection here
    console.log('Something went wrong:', error);
  }
}

main();
```

### Comparison Table

| Style | Readability | Error Handling | Used in Modern Code? |
|---|---|---|---|
| Callback | Hard (nested) | Manual check | Rarely |
| Promise | Better | `.catch()` | Sometimes |
| Async/Await | Best (looks like normal code) | `try/catch` | Yes, most common |

---

## 13. Error Handling

Handling errors properly is important so your app doesn't crash.

```js
// Using try/catch with async/await
async function readData() {
  try {
    const fs = require('fs').promises; // fs.promises gives Promise-based methods
    const data = await fs.readFile('notes.txt', 'utf8');
    console.log(data);
  } catch (error) {
    // this runs if readFile fails (e.g. file doesn't exist)
    console.log('Error reading file:', error.message);
  }
}

readData();
```

```js
// Handling errors in normal (non-async) functions
function divide(a, b) {
  if (b === 0) {
    // throw creates a custom error
    throw new Error('Cannot divide by zero!');
  }
  return a / b;
}

try {
  console.log(divide(10, 0));
} catch (error) {
  console.log('Caught an error:', error.message);
}
```

---

## 14. Streams and Buffers

### Buffer
A **Buffer** is how Node.js stores raw binary data (like file data, images) temporarily in memory before it's fully processed.

```js
// Create a buffer from a string
const buf = Buffer.from('Hello');

console.log(buf);          // <Buffer 48 65 6c 6c 6f> (binary data in hex)
console.log(buf.toString()); // 'Hello' (convert back to readable text)
```

### Streams
**Streams** let you process data piece-by-piece (chunk-by-chunk) instead of loading the WHOLE file into memory at once. This is very useful for large files (like videos).

```js
const fs = require('fs');

// Create a "readable stream" to read a large file in small pieces
const readStream = fs.createReadStream('bigfile.txt', 'utf8');

// 'data' event fires every time a new chunk of data is ready
readStream.on('data', (chunk) => {
  console.log('Received a chunk of data:', chunk.length, 'characters');
});

// 'end' event fires when the whole file has been read
readStream.on('end', () => {
  console.log('Finished reading the file.');
});

// 'error' event fires if something goes wrong
readStream.on('error', (err) => {
  console.log('Error:', err.message);
});
```

> 💡 Why streams matter: If a file is 2GB, loading it all at once (`fs.readFile`) can crash your app. Streams read it in small pieces, so memory usage stays low.

---

## 15. Environment Variables

Environment variables store secret/config values (like database passwords, API keys) OUTSIDE your code. This keeps secrets safe and makes config easy to change.

```js
// process.env gives access to environment variables
console.log('Node environment:', process.env.NODE_ENV);
```

### Using the `dotenv` Package (very common in MERN projects)

```bash
# Install dotenv package
npm install dotenv
```

```
# File: .env  (this file stores your secret values)
# NEVER share this file publicly or upload to GitHub!

PORT=3000
DB_PASSWORD=mysecretpassword
```

```js
// File: app.js

// This loads variables from .env into process.env
require('dotenv').config();

// Now we can use them anywhere in our code
const port = process.env.PORT;
console.log('Server will run on port:', port);
```

---

## 16. Simple REST API (without Express)

A REST API lets your frontend (React) talk to your backend (Node.js) using HTTP requests (GET, POST, PUT, DELETE).

```js
const http = require('http');

// Fake database (just an array for now)
let users = [
  { id: 1, name: 'Pathan' },
  { id: 2, name: 'Rahim' }
];

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');

  // GET request to /users → return the list of users
  if (req.method === 'GET' && req.url === '/users') {
    res.writeHead(200);
    res.end(JSON.stringify(users)); // convert JS array to JSON text
  }

  // POST request to /users → add a new user
  else if (req.method === 'POST' && req.url === '/users') {
    let body = '';

    // Data comes in small pieces (chunks), so we collect it
    req.on('data', (chunk) => {
      body += chunk;
    });

    // Once all data is received, process it
    req.on('end', () => {
      const newUser = JSON.parse(body); // convert JSON text back to JS object
      newUser.id = users.length + 1;
      users.push(newUser);

      res.writeHead(201); // 201 = created successfully
      res.end(JSON.stringify(newUser));
    });
  }

  // If no route matches
  else {
    res.writeHead(404);
    res.end(JSON.stringify({ message: 'Route not found' }));
  }
});

server.listen(3000, () => {
  console.log('API server running on http://localhost:3000');
});
```

> 💡 As you can see, doing this with plain `http` module needs a lot of manual code. This is exactly why we use **Express.js** next — it makes REST APIs MUCH simpler.

---

## 17. Intro to Express.js (Next Step)

Express.js is a **framework** built on top of Node.js's `http` module. It makes building servers and APIs much faster and easier.

```bash
npm install express
```

```js
// File: app.js

// Import express
const express = require('express');

// Create an express application
const app = express();

// Middleware: allows our server to understand JSON data sent by client
app.use(express.json());

// Fake database
let users = [{ id: 1, name: 'Pathan' }];

// GET route: /users
app.get('/users', (req, res) => {
  res.json(users); // automatically sends JSON response
});

// POST route: /users
app.post('/users', (req, res) => {
  const newUser = req.body; // express.json() lets us read req.body directly
  newUser.id = users.length + 1;
  users.push(newUser);
  res.status(201).json(newUser);
});

// Start server
app.listen(3000, () => {
  console.log('Express server running on http://localhost:3000');
});
```

**Compare:** Notice how much shorter and cleaner this is compared to Section 16 (plain `http` module)! This is why Express is the "E" in MERN stack.

---

## 18. Best Practices

- ✅ Always use `async/await` with `try/catch` for async code
- ✅ Never hardcode secrets (passwords, API keys) — use `.env` files
- ✅ Use `nodemon` during development (auto-restarts server on file change)
  ```bash
  npm install --save-dev nodemon
  # then run: npx nodemon app.js
  ```
- ✅ Organize your project into folders: `routes/`, `controllers/`, `models/`, `config/`
- ✅ Always handle errors — don't let your app crash silently
- ✅ Validate user input (never trust data from the client directly)
- ✅ Use `.gitignore` to avoid uploading `node_modules` and `.env` to GitHub

```
# Example .gitignore file
node_modules/
.env
```

---

## 19. Roadmap: What to Learn Next (for MERN Stack)

```
Your Learning Path:

1. ✅ JavaScript Basics (variables, functions, arrays, objects)
2. ✅ Node.js (you are here — core modules, async, http)
3. ➡️  Express.js (routing, middleware, REST APIs) — NEXT STEP
4. ➡️  MongoDB + Mongoose (database for storing data)
5. ➡️  Building a full REST API (Node + Express + MongoDB)
6. ➡️  Authentication (JWT, bcrypt for passwords)
7. ➡️  React.js (frontend — you already know this is next)
8. ➡️  Connect React frontend with Node/Express backend
9. ➡️  Full MERN Project (build something real!)
10. ➡️  Next.js (after MERN — for server-side rendering, better routing)
```

> 🎯 **Tip:** Don't just read — type out every example above yourself in VS Code and run it with `node filename.js`. Practice is the fastest way to remember Node.js concepts.

---

*Good luck with your MERN stack journey, Pathan! 🚀*
