# SQL & MySQL Notes (organized)

## Table of contents

- [DB Connection (db.js)](#db-connection-dbjs)
- [Using `db` in `app.js`](#using-db-in-appjs)
- [db.query signature](#dbquery-signature)
- [CRUD examples](#crud-examples)
  - [Read (SELECT)](#read-select)
  - [Create (INSERT)](#create-insert)
  - [Update (UPDATE)](#update)
  - [Delete (DELETE)](#delete)
- [EJS rendering example](#ejs-rendering-example)
- [Tips & common errors](#tips--common-errors)

## DB Connection (db.js)

Example `db.js` using `mysql2`:

```js
const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "students_db",
});

db.connect((err) => {
  if (err) {
    console.log("Database connection failed:", err);
    return;
  }
  console.log("MySQL connected successfully");
});

module.exports = db;
```

## Using `db` in `app.js`

Require the connection and use `db.query(...)` in your routes:

```js
const db = require("./db");

// Example: GET /students
app.get("/students", (req, res) => {
  const sql = `SELECT * FROM students ORDER BY id DESC`;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).send("Database error");
    res.render("students", { students: results });
  });
});
```

## db.query signature

db.query takes: SQL, optional values array, and a callback:

```txt
db.query(sql, [values], (err, results) => { ... })

- err: Did the query fail?
- results: What MySQL returned (rows, info)
```

## CRUD examples

### Read (SELECT)

```js
const sql = `
  SELECT *
  FROM students
  ORDER BY id DESC
`;

db.query(sql, (err, results) => {
  if (err) return res.status(500).send("Database error");
  res.render("students", { students: results });
});
```

### Create (INSERT)

```js
const sql = `
  INSERT INTO students (name, email, phone)
  VALUES (?, ?, ?)
`;

const values = [name, email, phone];

db.query(sql, values, (err, result) => {
  if (err) return res.status(500).send("Database error");
  res.redirect("/students");
});
```

### Update (UPDATE)

```js
const sql = `
  UPDATE students
  SET name = ?, email = ?, major = ?
  WHERE id = ?
`;

const values = ["Arafat Khan", "arafat@gmail.com", "CSE", 1];

db.query(sql, values, (err, result) => {
  if (err) return console.error(err);
  console.log("Student updated");
});
```

### Delete (DELETE)

```js
const sql = `DELETE FROM students WHERE id = ?`;
const values = [5];

db.query(sql, values, (err, result) => {
  if (err) return console.error(err);
  console.log("Student deleted");
});
```

## EJS rendering example

Render rows in a table (example for `enrollments`):

```ejs
<% enrollments.forEach(function(e) { %>
  <tr>
    <td><%= e.id %></td>
    <td><%= e.studentName %></td>
    <td><%= e.courseTitle %></td>
    <td><%= e.enrollment_date %></td>
    <td><%= e.grade || '-' %></td>
  </tr>
<% }); %>
```

## Tips & common errors

- Use `?` placeholders and pass values as an array to avoid SQL injection.
- Always check `err` in callbacks and return or respond appropriately.
- Consider using a connection pool (`mysql2/promise` or `createPool`) for production.
- Log full errors while developing; avoid exposing them to users in production.
- When inserting/updating, ensure value order matches the `VALUES`/`SET` placeholders.
- For async/await style use `mysql2/promise` and `async` functions.

---

# Multiple Database Queries in Express.js with MySQL



```js
app.get("/courses", async (req, res) => {
  try {
    const studentSql = `                         // Create SQL query for students
            SELECT *
            FROM students
            ORDER BY id
        `;
    const teacherSql = `                         // Create SQL query for teachers
            SELECT *
            FROM teachers
            ORDER BY id
        `;
    const courseSql = `                          // Create SQL query for courses
            SELECT *
            FROM courses
            ORDER BY id
        `;

    // 1. Sequential Queries
    const [students] = await db.query(studentSql); // Run students query and wait for result
    const [teachers] = await db.query(teacherSql); // Run teachers query and wait for result
    const [courses] = await db.query(courseSql); // Run courses query and wait for result

    // 2. Parallel Queries with Promise.all()
    // const [students, teachers, courses] = await Promise.all([
    //   db.query(studentSql), // Run students query
    //   db.query(teacherSql), // Run teachers query
    //   db.query(courseSql), // Run courses query
    // ]);
 
    // Render courses.ejs and send all data
    res.render("courses", {
      students: students, // Send students data to EJS
      teachers: teachers, // Send teachers data to EJS
      courses: courses, // Send courses data to EJS
      success: null, // Send success message
      error: null, // Send error message
    });
  } catch (err) {
    console.error(err); // Print database error in terminal
    res.status(500).send("Database error"); // Send HTTP 500 error to browser
  }
});
```

## Async/await examples (mysql2/promise)

If you prefer `async/await`, use `mysql2/promise`. Install with:

```bash
npm install mysql2
```

Example `dbAsync.js` (promise wrapper):

```js
const mysql = require("mysql2/promise");

async function getConnection() {
  return mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "students_db",
  });
}

module.exports = { getConnection };
```
### This is better 

```js
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'students_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
});

module.exports = pool;
```
Read (SELECT) using async/await:

```js
const { getConnection } = require("./dbAsync");

app.get("/students", async (req, res) => {
  try {
    const conn = await getConnection();
    const [rows] = await conn.query("SELECT * FROM students ORDER BY id DESC");
    await conn.end();
    res.render("students", { students: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send("Database error");
  }
});
```

Create (INSERT) using async/await:

```js
app.post("/students", async (req, res) => {
  const { name, email, phone } = req.body;
  try {
    const conn = await getConnection();
    const sql = "INSERT INTO students (name, email, phone) VALUES (?, ?, ?)";
    await conn.execute(sql, [name, email, phone]);
    await conn.end();
    res.redirect("/students");
  } catch (err) {
    console.error(err);
    res.status(500).send("Database error");
  }
});
```

Update and Delete follow the same pattern using `execute` and parameter arrays.

## Connection pool example (`dbPool.js`)

Use a pool for better performance in web apps. Example `dbPool.js`:

```js
const mysql = require("mysql2/promise");

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "students_db",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

module.exports = pool;
```

Usage with async/await:

```js
const pool = require("./dbPool");

app.get("/students", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM students ORDER BY id DESC");
    res.render("students", { students: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send("Database error");
  }
});
```
