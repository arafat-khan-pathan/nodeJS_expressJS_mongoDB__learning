# Express.js — Folder Structure Guide (MVC Pattern)

> How to organize a real Express project — from a tiny EJS app to a full API — explained simply.

---

## 📌 Why Structure Matters

When your app is small, everything in one `server.js` file is fine. But once you add more routes, more database logic, more pages — one giant file becomes messy and hard to debug.

The fix: **MVC pattern** — split your code by *job*:

| Letter | Stands for | Job |
|---|---|---|
| **M** | Model | Talks to the database (schemas, queries) |
| **V** | View | What the user sees (EJS pages / React frontend) |
| **C** | Controller | The "brain" — decides what happens when a route is hit |

Routes just point traffic to the right controller. Controllers use models to get/save data, then send back a view (or JSON).

```
Request → Route → Controller → Model (database) → Controller → View/Response
```

---

## 🗂️ Recommended Structure (Beginner → Pro friendly)

This merges a simple EJS setup with the standard professional layout — use as much of it as your project needs.

```
project-root/
│
├── src/
│   ├── routes/              # URL paths → which controller handles them
│   │   ├── authRoutes.js
│   │   └── studentRoutes.js
│   │
│   ├── controllers/         # Logic for each route (the "brain")
│   │   ├── authController.js
│   │   └── studentController.js
│   │
│   ├── models/              # Mongoose schemas (talks to MongoDB)
│   │   ├── User.js
│   │   └── Student.js
│   │
│   ├── middlewares/         # Functions that run BEFORE a route (auth check, error handler, etc.)
│   │   ├── authMiddleware.js
│   │   └── errorHandler.js
│   │
│   ├── config/               # Setup/config files
│   │   └── db.js             # MongoDB connection code
│   │
│   └── utils/                 # Small helper functions (reused across the app)
│       └── generateToken.js
│
├── views/                    # EJS templates (what the browser shows)
│   ├── index.ejs
│   ├── login.ejs
│   ├── signup.ejs
│   └── partials/              # Reusable pieces included in multiple pages
│       ├── header.ejs
│       └── footer.ejs
│
├── public/                    # Static files served directly to the browser
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── script.js
│   └── images/
│
├── node_modules/              # Installed packages (auto-generated, never edit)
│
├── .env                        # Secret values (DB password, API keys) — never commit this
├── .gitignore                  # Tells git to ignore node_modules, .env, etc.
├── package.json                # Project info + dependencies list
└── server.js                   # Entry point — starts the app
```

---

## 📁 What Each Folder Actually Does

### `routes/` — the map
Just says **"this URL → go here"**. No logic, no database calls — just routing.

```js
// src/routes/studentRoutes.js
const express = require("express");
const router = express.Router();
const studentController = require("../controllers/studentController");

router.get("/", studentController.getAllStudents);
router.post("/", studentController.createStudent);
router.get("/:id/edit", studentController.editStudentForm);
router.post("/:id/update", studentController.updateStudent);
router.post("/:id/delete", studentController.deleteStudent);

module.exports = router;
```

### `controllers/` — the brain
Contains the actual logic: reads the request, talks to the model, sends a response.

```js
// src/controllers/studentController.js
const Student = require("../models/Student");

exports.getAllStudents = async (req, res) => {
  const students = await Student.find().sort({ createdAt: -1 });
  res.render("index", { students });
};

exports.createStudent = async (req, res) => {
  await Student.create(req.body);
  res.redirect("/students");
};

exports.editStudentForm = async (req, res) => {
  const student = await Student.findById(req.params.id);
  res.render("edit", { student });
};

exports.updateStudent = async (req, res) => {
  await Student.findByIdAndUpdate(req.params.id, req.body);
  res.redirect("/students");
};

exports.deleteStudent = async (req, res) => {
  await Student.findByIdAndDelete(req.params.id);
  res.redirect("/students");
};
```

### `models/` — the database blueprint
Defines what a document looks like and talks to MongoDB via Mongoose.

```js
// src/models/Student.js
const mongoose = require("mongoose");

const studentSchema = new mongoose.Schema({
  name: { type: String, required: true },
  age: { type: Number, required: true },
  email: { type: String, required: true },
  department: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model("Student", studentSchema);
```

### `middlewares/` — the checkpoints
Functions that run **before** your controller — like a security guard checking ID before letting the request through.

```js
// src/middlewares/authMiddleware.js
module.exports = function requireLogin(req, res, next) {
  if (!req.session.userId) {
    return res.redirect("/login");
  }
  next();   // allowed to continue
};
```

Used in routes like:
```js
router.get("/dashboard", requireLogin, dashboardController.show);
```

### `config/` — setup files
Keeps connection/setup code separate and reusable.

```js
// src/config/db.js
const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected ✅");
  } catch (err) {
    console.log("Connection failed ❌", err);
    process.exit(1);
  }
};

module.exports = connectDB;
```

### `utils/` — small reusable helpers
Little functions used in multiple places (token generation, formatting dates, etc.) — kept separate so you don't repeat code.

### `views/` — what the user sees
All `.ejs` template files. Express looks in `views/` by default — no config needed if you name the folder exactly `views`.

`views/partials/` holds reusable page pieces (navbar, footer) that get included in multiple pages:
```html
<!-- included at the top of any page -->
<%- include('partials/header') %>

<h1>Page content here</h1>

<%- include('partials/footer') %>
```

### `public/` — static files
CSS, client-side JS, and images the **browser** loads directly (not through a route). You need one line in `server.js` to enable it:
```js
app.use(express.static("public"));
```
Then in your EJS file:
```html
<link rel="stylesheet" href="/css/style.css">
<script src="/js/script.js"></script>
```

---

## 🚀 `server.js` — Tying It All Together

```js
require("dotenv").config();
const express = require("express");
const connectDB = require("./src/config/db");
const studentRoutes = require("./src/routes/studentRoutes");
const authRoutes = require("./src/routes/authRoutes");

const app = express();

// connect to database
connectDB();

// middleware
app.use(express.urlencoded({ extended: true }));   // read form data
app.use(express.json());                            // read JSON (for APIs)
app.use(express.static("public"));                   // serve CSS/JS/images
app.set("view engine", "ejs");

// routes
app.use("/students", studentRoutes);
app.use("/", authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
```

Notice `server.js` stays **short and clean** — it just wires things together. All the real logic lives in its own folder.

---

## 🧭 Request Flow — Full Example

**User clicks "Delete" on a student:**

```
Browser → POST /students/123/delete
   ↓
routes/studentRoutes.js  →  "this path goes to deleteStudent"
   ↓
controllers/studentController.js  →  deleteStudent() runs
   ↓
models/Student.js  →  findByIdAndDelete(123) removes it from MongoDB
   ↓
controller sends response  →  res.redirect("/students")
   ↓
Browser shows updated list
```

---

## 📏 Simple Rule of Thumb

| If your app is... | Use this structure |
|---|---|
| A tiny practice project (1–2 files) | `server.js` + `views/` + `public/` is enough |
| A real project you'll keep building | Full `src/` MVC structure above |
| An API for a React frontend (real MERN) | Same structure, but controllers use `res.json(data)` instead of `res.render(...)` |

---

## ⚠️ Common Mistakes

- ❌ Putting database queries directly in `routes/` — keep routes "dumb", logic goes in controllers
- ❌ Forgetting `module.exports` at the bottom of a controller/model file — nothing outside the file can use it
- ❌ Naming the views folder anything other than `views` without telling Express (`app.set("views", "myFolderName")`)
- ❌ Not adding `node_modules` and `.env` to `.gitignore` before pushing to GitHub

**`.gitignore` example:**
```
node_modules/
.env
```

---

*Once this structure feels natural, you can build any size Express app — from a small EJS site to a full REST API for your React frontend.* 🚀
