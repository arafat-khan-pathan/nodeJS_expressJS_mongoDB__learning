const express = require('express');
const path = require('path');
const db = require('./db');

// Initialize Express
const app = express();

// EJS Configuration
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use((req, res, next) => {

    // Ignore static files. this is to avoid logging static files in the console.
    if (
        req.url.endsWith('.css') ||
        req.url.endsWith('.js') ||
        req.url.endsWith('.png') ||
        req.url.endsWith('.jpg') ||
        req.url.endsWith('.jpeg') ||
        req.url.endsWith('.gif')
    ) {
        return next();
    }

    // Show only application routes. request routes are logged in the console.
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();

});

// Body Parser Middleware
// const bodyParser = require('body-parser');
// app.use(bodyParser.urlencoded({ extended: true }));
// app.use(bodyParser.json());

app.use(express.urlencoded({ extended: true })); // Parse form data from HTML forms into req.body object for POST requests .
app.use(express.json());  // Parse JSON data
app.use(express.static(path.join(__dirname, 'public'))); // Serve static files (CSS, JavaScript, images, etc.) from the "public" directory

// Home Route
app.get('/', (req, res) => {

    res.render('index', {
        success: null,
        error: null
    });
});
// Student Routes
// app.get('/students', (req, res) => {
//     res.render('students', {
//         students: [],
//         success: null,
//         error: null
//     });
// });

app.get('/students', async (req, res) => {

    try {

        const sql = `
            SELECT *
            FROM students
            ORDER BY id 
        `;

        const [results] = await db.query(sql);

        res.render('students', {
            students: results,
            success: null,
            error: null
        });

    } catch (err) {

        console.error(err);
        return res.status(500).send('Database error');
    }
});

// Teacher Routes
app.get('/teachers', async (req, res) => {

    try {

        const sql = `
            SELECT *
            FROM teachers
            ORDER BY id 
        `;

        const [results] = await db.query(sql);

        res.render('teachers', {
            teachers: results,
            success: null,
            error: null
        });
    } catch (err) {

        console.error(err);
        return res.status(500).send('Database error');
    }
});

// Course Routes
app.get("/courses", async (req, res) => {

    try {

        const studentSql = "SELECT * FROM students ORDER BY id";
        const teacherSql = "SELECT * FROM teachers ORDER BY id";
        const courseSql = "SELECT * FROM courses ORDER BY id";

        const [students] = await db.query(studentSql);
        const [teachers] = await db.query(teacherSql);
        const [courses] = await db.query(courseSql);

        res.render("courses", {

            students: students,
            teachers: teachers,
            courses: courses,
            success: null,
            error: null,
        });

    } catch (err) {

        console.error(err); // Print database error in terminal
        res.status(500).send("Database error"); // Send HTTP 500 error to browser
    }
});

// Enrollment Routes
app.get('/enrollments', async (req, res) => {

    try {
        const studentSql = "SELECT * FROM students ORDER BY id";
        const teacherSql = "SELECT * FROM teachers ORDER BY id";
        const courseSql = "SELECT * FROM courses ORDER BY id";
        const enrollmentSql = `
        SELECT
            s.id AS student_id,
            s.name AS student_name,
            c.title AS course_title,
            e.enrollment_date,
            e.grade
        FROM enrollments e
        JOIN students s
            ON e.student_id = s.id
        JOIN courses c
            ON e.course_id = c.id
        ORDER BY e.id
    `;

        // const [students] = await db.query(studentSql);
        // const [teachers] = await db.query(teacherSql);
        // const [courses] = await db.query(courseSql);
        // const [enrollments] = await db.query(enrollmentSql);

        const [[students], [teachers], [courses], [enrollments]] = await Promise.all([
            db.query(studentSql), // Run students query
            db.query(teacherSql), // Run teachers query
            db.query(courseSql), // Run courses query
            db.query(enrollmentSql), // Run enrollments query
        ]);

        res.render('enrollments', {

            enrollments: enrollments,
            students: students,
            courses: courses,
            success: null,            // No success message.
            error: null             // No error message.
        });
    } catch (err) {

        console.error(err);
        return res.status(500).send('Database error');
    }
});



app.post('/students/save', async (req, res) => {

    try {
        const { name, email, major } = req.body;

        // Format the name: trim, lowercase, and capitalize the first letter of each word
        const formattedName = name  
            .trim()
            .toLowerCase()  
            .split(' ')
            .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
            .join(' ');  

        const sql = "INSERT INTO students (name, email, major) VALUES (?, ?, ?)";
        await db.query(sql, [formattedName, email, major]);
        res.redirect('/students');

    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});

app.post('/students/delete/:id', async (req, res) => {

    try {
        const { id } = req.params;
        const sql = "DELETE FROM students WHERE id = ?";
        await db.query(sql, [id]);
        res.redirect('/students');

    } catch (err) {
        console.error(err);
        res.status(500).send('Database error');
    }
});







//test error
app.get('/test-error', (req, res, next) => {
    const error = new Error('Database connection failed');
    next(error);
});

// 404 Route
app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).render('error', {
        message: 'Something went wrong!',
        error: err
    });
});

// Start the Serve. this goes to server.js file
// app.listen(3000, () => {
//     console.log('Server started on port 3000');
//     console.log('[http://localhost:3000](http://localhost:3000)');
// })

// Export App
module.exports = app;