# MongoDB — Complete Notes (Beginner to Pro)

> Made for Pathan — MERN stack learner. Simple language, real examples, everything in one file.

---

## 📌 Table of Contents

1. [What is MongoDB](#1-what-is-mongodb)
2. [Setup — Install & Run](#2-setup--install--run)
3. [VS Code Extensions](#3-vs-code-extensions)
4. [Core Concepts](#4-core-concepts)
5. [Connecting with mongosh](#5-connecting-with-mongosh)
6. [Database & Collection Commands](#6-database--collection-commands)
7. [CREATE (Insert Data)](#7-create--insert-data)
8. [READ (Find Data)](#8-read--find-data)
9. [UPDATE (Edit Data)](#9-update--edit-data)
10. [DELETE (Remove Data)](#10-delete--remove-data)
11. [Query Operators (Cheat Sheet)](#11-query-operators-cheat-sheet)
12. [Sorting, Limiting, Pagination](#12-sorting-limiting-pagination)
13. [Indexing](#13-indexing)
14. [Aggregation Framework](#14-aggregation-framework)
15. [Schema Design Rules](#15-schema-design-rules)
16. [MongoDB with Node.js (Mongoose) — MERN](#16-mongodb-with-nodejs-mongoose--mern)
17. [MongoDB Atlas (Cloud)](#17-mongodb-atlas-cloud)
18. [Common Mistakes (Beginner Traps)](#18-common-mistakes-beginner-traps)
19. [Quick Revision Sheet](#19-quick-revision-sheet)

---

## 1. What is MongoDB

MongoDB is a **NoSQL, document-based database**. Instead of tables and rows (like MySQL), it stores data as **documents** (like JSON objects) inside **collections**.

| SQL (MySQL)  | MongoDB      |
|--------------|--------------|
| Database     | Database     |
| Table        | Collection   |
| Row          | Document     |
| Column       | Field        |
| Primary Key  | `_id`        |

**Example document:**
```json
{
  "_id": "64f1a2b3c4d5e6f7a8b9c0d1",
  "name": "Pathan",
  "age": 21,
  "skills": ["React", "Node", "MongoDB"],
  "isStudent": true
}
```

> 💡 Why MongoDB is good for MERN: JavaScript objects and MongoDB documents look almost the same (JSON-like), so it fits naturally with Node.js/Express/React.

---

## 2. Setup — Install & Run

### Option A: Local Install (Windows/Mac/Linux)

1. Download **MongoDB Community Server** from mongodb.com
2. Install it (Windows: use the `.msi` installer, keep default settings)
3. It installs as a **service** — runs automatically as `mongod`
4. Install **MongoDB Shell (mongosh)** separately — this is how you type commands

**Check it's running:**
```bash
mongosh
```
If it connects, you're done ✅

### Option B: MongoDB Atlas (Cloud — Recommended for beginners)

No installation needed. Free cloud database.

1. Go to https://cloud.mongodb.com and sign up
2. Create a **Free Cluster** (M0)
3. Add a database user (username + password)
4. Add your IP to **Network Access** (or allow `0.0.0.0/0` for testing)
5. Click **Connect** → copy the connection string:
```
mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/
```
6. Use this string in `mongosh` or in your Node.js app

> 💡 For MERN projects, Atlas is easier — no local setup needed, and it works the same when you deploy your app.

---

## 3. VS Code Extensions

Install these from the VS Code Extensions tab (`Ctrl+Shift+X`):

| Extension | Why |
|---|---|
| **MongoDB for VS Code** (official) | Connect to your database, browse collections, run playgrounds — directly inside VS Code |
| **Prettier** | Auto-formats your `.js` files that use MongoDB queries |
| **DotENV** | Highlights `.env` files where you store your connection string safely |
| **Thunder Client** | Test your Express API routes that use MongoDB (like Postman, but inside VS Code) |

**How to use MongoDB for VS Code extension:**
1. Install it → click the leaf 🍃 icon on the sidebar
2. Click **Add Connection** → paste your connection string (local or Atlas)
3. You can browse databases, collections, and documents visually
4. You can also create a **Playground** (`.mongodb.js` file) to write and run queries right there

---

## 4. Core Concepts

- **Database** → holds multiple collections
- **Collection** → holds multiple documents (like a folder of JSON files)
- **Document** → a single record, written in **BSON** (Binary JSON — supports extra types like Date, ObjectId)
- **`_id`** → every document automatically gets a unique `_id` (type `ObjectId`) unless you set your own
- **Schema-less** → different documents in the same collection can have different fields (flexible, but be careful — plan your structure anyway)

---

## 5. Connecting with mongosh

```bash
# connect to local MongoDB
mongosh

# connect to Atlas
mongosh "mongodb+srv://cluster0.xxxxx.mongodb.net/" --username yourUser
```

Inside `mongosh`, you type JavaScript-like commands.

---

## 6. Database & Collection Commands

```js
show dbs                  // list all databases
use myShop                // switch to (or create) database "myShop"
db                         // shows current database name
show collections          // list collections in current db
db.createCollection("users")   // manually create a collection
db.users.drop()            // delete a collection
db.dropDatabase()          // delete the current database
```

> 💡 MongoDB **creates the database and collection automatically** the first time you insert data into them — you don't have to create them first.

---

## 7. CREATE — Insert Data

```js
// Insert ONE document
db.users.insertOne({
  name: "Pathan",
  age: 21,
  email: "pathan@example.com"
})

// Insert MANY documents
db.users.insertMany([
  { name: "Rafi", age: 22 },
  { name: "Nabila", age: 20 }
])
```

✅ MongoDB auto-generates `_id` if you don't provide one.

---

## 8. READ — Find Data

```js
// Find ALL documents
db.users.find()

// Find with a condition
db.users.find({ name: "Pathan" })

// Find ONE document only
db.users.findOne({ name: "Pathan" })

// Pretty print (readable format)
db.users.find().pretty()

// Select specific fields only (projection)
// 1 = include, 0 = exclude
db.users.find({}, { name: 1, email: 1, _id: 0 })
```

---

## 9. UPDATE — Edit Data

```js
// Update ONE matching document
db.users.updateOne(
  { name: "Pathan" },           // filter (which document)
  { $set: { age: 22 } }         // what to change
)

// Update MANY matching documents
db.users.updateMany(
  { age: { $lt: 18 } },
  { $set: { isMinor: true } }
)

// Replace ENTIRE document (all old fields gone)
db.users.replaceOne(
  { name: "Pathan" },
  { name: "Pathan", age: 22, city: "Dhaka" }
)

// Increase/decrease a number field
db.users.updateOne({ name: "Pathan" }, { $inc: { age: 1 } })

// Add item to an array
db.users.updateOne({ name: "Pathan" }, { $push: { skills: "MongoDB" } })

// Remove item from an array
db.users.updateOne({ name: "Pathan" }, { $pull: { skills: "PHP" } })
```

> ⚠️ Beginner trap: If you forget `$set` and write `db.users.updateOne({name:"Pathan"}, {age: 22})`, it will **replace the whole document** with just `{age: 22}`! Always use `$set` for partial updates.

---

## 10. DELETE — Remove Data

```js
// Delete ONE matching document
db.users.deleteOne({ name: "Pathan" })

// Delete MANY matching documents
db.users.deleteMany({ age: { $lt: 18 } })

// Delete ALL documents in a collection (collection itself stays)
db.users.deleteMany({})
```

---

## 11. Query Operators (Cheat Sheet)

### Comparison
| Operator | Meaning | Example |
|---|---|---|
| `$eq` | equal | `{ age: { $eq: 20 } }` |
| `$ne` | not equal | `{ age: { $ne: 20 } }` |
| `$gt` | greater than | `{ age: { $gt: 18 } }` |
| `$gte` | greater or equal | `{ age: { $gte: 18 } }` |
| `$lt` | less than | `{ age: { $lt: 18 } }` |
| `$lte` | less or equal | `{ age: { $lte: 18 } }` |
| `$in` | value in a list | `{ age: { $in: [18, 20, 22] } }` |
| `$nin` | value not in list | `{ age: { $nin: [18, 20] } }` |

### Logical
```js
// AND (default when you list multiple fields)
db.users.find({ age: { $gt: 18 }, city: "Dhaka" })

// OR
db.users.find({ $or: [{ age: 18 }, { city: "Dhaka" }] })

// NOT
db.users.find({ age: { $not: { $gt: 18 } } })

// AND explicitly
db.users.find({ $and: [{ age: { $gt: 18 } }, { city: "Dhaka" }] })
```

### Element & Array
```js
db.users.find({ email: { $exists: true } })      // field exists
db.users.find({ skills: { $size: 3 } })           // array has exactly 3 items
db.users.find({ skills: "React" })                // array contains "React"
db.users.find({ skills: { $all: ["React", "Node"] } })  // contains both
```

### Text / Pattern
```js
// regex — case-insensitive search for names starting with "P"
db.users.find({ name: { $regex: "^P", $options: "i" } })
```

---

## 12. Sorting, Limiting, Pagination

```js
db.users.find().sort({ age: 1 })     // ascending
db.users.find().sort({ age: -1 })    // descending

db.users.find().limit(5)             // only 5 results
db.users.find().skip(10)             // skip first 10 (for pagination)

// Pagination example: page 2, 10 items per page
db.users.find().skip(10).limit(10)

db.users.countDocuments({ city: "Dhaka" })   // count matching documents
```

---

## 13. Indexing

Indexes make searches **much faster** on large collections (like a book's index page).

```js
db.users.createIndex({ email: 1 })         // ascending index
db.users.createIndex({ email: 1 }, { unique: true })  // must be unique (no duplicates)
db.users.getIndexes()                      // list all indexes
db.users.dropIndex("email_1")              // remove an index
```

> 💡 Without an index, MongoDB scans **every document** (slow). With an index, it jumps straight to the match (fast). Add indexes on fields you search/filter often (like `email`, `username`).

---

## 14. Aggregation Framework

Aggregation = a **pipeline** of steps to transform/summarize data (like Excel pivot tables).

```js
db.orders.aggregate([
  { $match: { status: "delivered" } },        // step 1: filter
  { $group: {                                  // step 2: group + calculate
      _id: "$customerId",
      totalSpent: { $sum: "$amount" },
      orderCount: { $sum: 1 }
    }
  },
  { $sort: { totalSpent: -1 } },               // step 3: sort
  { $limit: 5 }                                // step 4: top 5 only
])
```

### Common Stages
| Stage | Purpose |
|---|---|
| `$match` | filter documents (like `find`) |
| `$group` | group by a field + calculate (`$sum`, `$avg`, `$max`, `$min`, `$count`) |
| `$sort` | order results |
| `$project` | reshape/select fields |
| `$limit` / `$skip` | pagination |
| `$lookup` | JOIN data from another collection |

**`$lookup` example (like SQL JOIN):**
```js
db.orders.aggregate([
  {
    $lookup: {
      from: "users",          // collection to join
      localField: "userId",   // field in orders
      foreignField: "_id",    // field in users
      as: "userInfo"          // output array field name
    }
  }
])
```

---

## 15. Schema Design Rules

MongoDB is flexible, but good design still matters.

### Embedding vs Referencing

**Embed** (put related data inside the same document) when:
- Data is always accessed together
- The related data is small and doesn't change often
- Example: a blog post with its comments (if comments are few)

```json
{
  "title": "My Post",
  "comments": [
    { "user": "Rafi", "text": "Nice post!" }
  ]
}
```

**Reference** (store an `_id` and keep data in a separate collection) when:
- Related data is large or grows unbounded
- Data is reused across many documents
- Example: users and their orders (orders collection has a `userId` field)

```json
// orders collection
{ "userId": "64f1a2...", "product": "Laptop", "amount": 500 }
```

> 💡 Rule of thumb: **"Data that is accessed together should be stored together."** — but don't let embedded arrays grow unlimited (like thousands of comments in one document).

---

## 16. MongoDB with Node.js (Mongoose) — MERN

Since you're doing MERN, you'll mostly use **Mongoose** (an ODM — Object Data Modeling library) instead of raw `mongosh` commands.

### Install
```bash
npm install mongoose
```

### Connect
```js
const mongoose = require("mongoose");

mongoose.connect("mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/myShop")
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));
```

### Define a Schema + Model
```js
const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  age: { type: Number, default: 18 }
}, { timestamps: true });   // adds createdAt, updatedAt automatically

const User = mongoose.model("User", userSchema);
```

### CRUD with Mongoose
```js
// CREATE
const newUser = await User.create({ name: "Pathan", email: "p@x.com" });

// READ
const allUsers = await User.find();
const oneUser  = await User.findOne({ email: "p@x.com" });
const byId     = await User.findById("64f1a2b3c4d5e6f7a8b9c0d1");

// UPDATE
await User.updateOne({ email: "p@x.com" }, { $set: { age: 22 } });
await User.findByIdAndUpdate(id, { age: 22 });

// DELETE
await User.deleteOne({ email: "p@x.com" });
await User.findByIdAndDelete(id);
```

> 💡 In Express routes, wrap these in `try/catch` (or use `async` handlers) since database calls can fail (bad connection, validation errors, etc.).

---

## 17. MongoDB Atlas (Cloud)

- Free tier (M0) is enough for learning and small projects
- Store your connection string in a `.env` file — **never** commit it to GitHub:
```
MONGO_URI=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/myShop
```
```js
require("dotenv").config();
mongoose.connect(process.env.MONGO_URI);
```
- Use **Atlas UI** to visually browse your data, or the MongoDB for VS Code extension

---

## 18. Common Mistakes (Beginner Traps)

- ❌ Forgetting `$set` in `updateOne` → replaces the whole document
- ❌ Using `find()` when you need only one result → use `findOne()` (faster, cleaner)
- ❌ Not adding indexes on frequently searched fields → slow queries as data grows
- ❌ Storing passwords in plain text → always hash with `bcrypt` before saving
- ❌ Committing `.env` file (with DB password) to GitHub → add it to `.gitignore`
- ❌ Unlimited array growth (e.g., pushing thousands of comments into one document) → use a separate collection instead
- ❌ Confusing `_id` (auto ObjectId) with your own custom IDs — you *can* set your own `_id`, but it must stay unique

---

## 19. Quick Revision Sheet

```js
// CRUD in one glance
db.col.insertOne({...})              // Create
db.col.find({...})                   // Read
db.col.updateOne({...}, {$set:{...}}) // Update
db.col.deleteOne({...})              // Delete

// Common query
db.col.find({ field: { $gt: 10 } }).sort({ field: -1 }).limit(5)

// Aggregation skeleton
db.col.aggregate([
  { $match: {...} },
  { $group: {...} },
  { $sort: {...} }
])
```

---

## 20. 🎓 Full Practical Example — Student CRUD App (Node + Express + MongoDB + Form)

This is a **complete mini project**: a form where you type student info, it gets **added** to MongoDB, shows in a **list**, and you can **edit** or **delete** each student. Built with Express + Mongoose + EJS (simple HTML forms — no React needed yet, since you're still learning Node/Express).

### 📁 Folder Structure
```
student-app/
 ├── models/
 │    └── Student.js
 ├── views/
 │    ├── index.ejs      (list + add form)
 │    └── edit.ejs       (edit form)
 ├── .env
 ├── server.js
 └── package.json
```

### Install
```bash
mkdir student-app && cd student-app
npm init -y
npm install express mongoose ejs dotenv
```

### `.env`
```
MONGO_URI=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/studentDB
PORT=3000
```

### `models/Student.js` — the Schema (blueprint of a student document)
```js
const mongoose = require("mongoose");

const studentSchema = new mongoose.Schema({
  name:  { type: String, required: true },
  age:   { type: Number, required: true },
  email: { type: String, required: true },
  department: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model("Student", studentSchema);
```

### `server.js` — Express app with all CRUD routes
```js
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const Student = require("./models/Student");

const app = express();

// middleware — lets us read form input (req.body)
app.use(express.urlencoded({ extended: true }));
app.set("view engine", "ejs");

// connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected ✅"))
  .catch((err) => console.log("Connection error ❌", err));

// ---------- READ: show all students + the add-form ----------
app.get("/", async (req, res) => {
  const students = await Student.find().sort({ createdAt: -1 });
  res.render("index", { students });
});

// ---------- CREATE: handle form submission ----------
app.post("/students", async (req, res) => {
  const { name, age, email, department } = req.body;
  await Student.create({ name, age, email, department });
  res.redirect("/");   // go back to list after adding
});

// ---------- READ ONE: show edit form pre-filled ----------
app.get("/students/:id/edit", async (req, res) => {
  const student = await Student.findById(req.params.id);
  res.render("edit", { student });
});

// ---------- UPDATE: handle edit form submission ----------
app.post("/students/:id/update", async (req, res) => {
  const { name, age, email, department } = req.body;
  await Student.findByIdAndUpdate(req.params.id, { name, age, email, department });
  res.redirect("/");
});

// ---------- DELETE ----------
app.post("/students/:id/delete", async (req, res) => {
  await Student.findByIdAndDelete(req.params.id);
  res.redirect("/");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
```

### `views/index.ejs` — the ADD form + student LIST (with Edit/Delete buttons)
```html
<!DOCTYPE html>
<html>
<head>
  <title>Student Manager</title>
</head>
<body>
  <h1>🎓 Add Student</h1>

  <!-- ADD FORM: user types input here -->
  <form action="/students" method="POST">
    <input type="text"   name="name"       placeholder="Name" required>
    <input type="number" name="age"        placeholder="Age" required>
    <input type="email"  name="email"      placeholder="Email" required>
    <input type="text"   name="department" placeholder="Department" required>
    <button type="submit">Add Student</button>
  </form>

  <hr>

  <h2>📋 Student List</h2>
  <table border="1" cellpadding="8">
    <tr>
      <th>Name</th><th>Age</th><th>Email</th><th>Department</th><th>Actions</th>
    </tr>

    <% students.forEach(student => { %>
      <tr>
        <td><%= student.name %></td>
        <td><%= student.age %></td>
        <td><%= student.email %></td>
        <td><%= student.department %></td>
        <td>
          <!-- EDIT: goes to edit page for this student's _id -->
          <a href="/students/<%= student._id %>/edit">Edit</a>

          <!-- DELETE: sends POST request for this student's _id -->
          <form action="/students/<%= student._id %>/delete" method="POST" style="display:inline">
            <button type="submit">Delete</button>
          </form>
        </td>
      </tr>
    <% }) %>
  </table>
</body>
</html>
```

### `views/edit.ejs` — the EDIT form (pre-filled with existing data)
```html
<!DOCTYPE html>
<html>
<head>
  <title>Edit Student</title>
</head>
<body>
  <h1>✏️ Edit Student</h1>

  <form action="/students/<%= student._id %>/update" method="POST">
    <input type="text"   name="name"       value="<%= student.name %>" required>
    <input type="number" name="age"        value="<%= student.age %>" required>
    <input type="email"  name="email"      value="<%= student.email %>" required>
    <input type="text"   name="department" value="<%= student.department %>" required>
    <button type="submit">Update</button>
  </form>

  <a href="/">⬅ Back to list</a>
</body>
</html>
```

### 🧠 What's happening — step by step

| Action | Flow |
|---|---|
| **Add** | Form → `POST /students` → `Student.create()` → redirect to `/` |
| **Read** | `GET /` → `Student.find()` → loop through in EJS with `<% %>` |
| **Edit (open form)** | Click "Edit" → `GET /students/:id/edit` → `findById()` → pre-fills form |
| **Edit (save)** | Submit edit form → `POST /students/:id/update` → `findByIdAndUpdate()` |
| **Delete** | Click "Delete" button (inside its own mini-form) → `POST /students/:id/delete` → `findByIdAndDelete()` |

> 💡 **Why does Delete use a `<form>` and not just a link?** Browsers send `GET` when you click a link — but deleting data should never happen on a simple `GET` (a bot/crawler could accidentally trigger it). So Delete is wrapped in its own tiny form that POSTs.

> 💡 **Run it:**
> ```bash
> node server.js
> ```
> Open `http://localhost:3000` → type student info → Add → see it in the list → click Edit or Delete.

### 🔜 Next Step (once this feels easy)
Replace EJS views with a **React frontend** that calls these same routes as a **JSON API** (`res.json(students)` instead of `res.render`) — that's the real MERN pattern (React talks to Express via `fetch`/`axios`, Express talks to MongoDB via Mongoose).

---

### 🎯 Practice Plan (Suggested Order)
1. Install MongoDB Atlas + VS Code extension
2. Practice `insertOne`, `find`, `updateOne`, `deleteOne` in `mongosh`
3. Learn all query operators (`$gt`, `$in`, `$regex`, etc.) with a sample `users` collection
4. Learn aggregation (`$match`, `$group`) with a sample `orders` collection
5. Connect MongoDB to a small Express app using Mongoose
6. Build a mini CRUD API (Create/Read/Update/Delete users) — this alone will make you comfortable with 90% of real-world MongoDB usage

---

*Good luck, Pathan! Practice each command yourself in `mongosh` — typing it yourself sticks way better than just reading.* 🚀
