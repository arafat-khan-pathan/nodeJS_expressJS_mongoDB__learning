-- ============================================================
-- Student Management System
-- MySQL Database
-- Database Name: students_db
-- ============================================================


-- 1. Create Database
CREATE DATABASE students_db;

USE students_db;


-- ============================================================
-- 2. Create Students Table
-- ============================================================

CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    major VARCHAR(255)
);


-- ============================================================
-- 3. Create Teachers Table
-- ============================================================

CREATE TABLE teachers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    department VARCHAR(255) NOT NULL
);


-- ============================================================
-- 4. Create Courses Table
-- ============================================================

CREATE TABLE courses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    teacher_id BIGINT,

    CONSTRAINT fk_course_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES teachers(id)
);


-- ============================================================
-- 5. Create Enrollments Table
-- ============================================================

CREATE TABLE enrollments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,

    enrollment_date DATE,
    grade VARCHAR(20),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(id),

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
);


-- ============================================================
-- 6. Insert Students
-- ============================================================

INSERT INTO students (name, email, major) VALUES
('Arafat Khan', 'arafat@example.com', 'Computer Science'),
('Rahim Ahmed', 'rahim@example.com', 'Software Engineering'),
('Karim Hasan', 'karim@example.com', 'Information Technology'),
('Nusrat Jahan', 'nusrat@example.com', 'Computer Science'),
('Sadia Islam', 'sadia@example.com', 'Electrical Engineering'),
('Tanvir Hossain', 'tanvir@example.com', 'Computer Science'),
('Mehedi Hasan', 'mehedi@example.com', 'Data Science'),
('Sumaiya Akter', 'sumaiya@example.com', 'Software Engineering'),
('Fahim Rahman', 'fahim@example.com', 'Information Technology'),
('Jannatul Ferdous', 'jannatul@example.com', 'Computer Science'),
('Sakib Ahmed', 'sakib@example.com', 'Cyber Security'),
('Mim Akter', 'mim@example.com', 'Data Science');


-- ============================================================
-- 7. Insert Teachers
-- ============================================================

INSERT INTO teachers (name, email, department) VALUES
('Dr. Hasan Mahmud', 'hasan@example.com', 'Computer Science'),
('Dr. Farhana Rahman', 'farhana@example.com', 'Software Engineering'),
('Prof. Kamal Hossain', 'kamal@example.com', 'Information Technology'),
('Dr. Nusrat Sultana', 'nusrat.teacher@example.com', 'Computer Science'),
('Prof. Rezaul Karim', 'rezaul@example.com', 'Electrical Engineering'),
('Dr. Sharmeen Akter', 'sharmeen@example.com', 'Data Science'),
('Prof. Imran Ahmed', 'imran@example.com', 'Cyber Security'),
('Dr. Rashedul Islam', 'rashedul@example.com', 'Computer Science'),
('Prof. Mahbub Hasan', 'mahbub@example.com', 'Software Engineering'),
('Dr. Sadia Ahmed', 'sadia.teacher@example.com', 'Information Technology');


-- ============================================================
-- 8. Insert Courses
-- ============================================================

INSERT INTO courses (title, credits, teacher_id) VALUES
('Database Management Systems', 3, 1),
('Web Engineering', 3, 2),
('Data Structures and Algorithms', 3, 1),
('Operating Systems', 3, 4),
('Computer Networks', 3, 3),
('Software Engineering', 3, 2),
('Artificial Intelligence', 3, 6),
('Machine Learning', 3, 6),
('Cyber Security', 3, 7),
('Object Oriented Programming', 3, 9),
('Computer Architecture', 3, 5),
('Information Systems', 3, 10),
('Cloud Computing', 3, 3),
('Mobile Application Development', 3, 9),
('Data Mining', 3, 6);


-- ============================================================
-- 9. Insert Enrollments
-- ============================================================

INSERT INTO enrollments
(student_id, course_id, enrollment_date, grade)
VALUES
(1, 1, '2026-01-10', 'A'),
(1, 3, '2026-01-11', 'A-'),
(2, 2, '2026-01-12', 'B+'),
(2, 6, '2026-01-13', 'A'),
(3, 5, '2026-01-14', 'B'),
(3, 12, '2026-01-15', 'B+'),
(4, 1, '2026-01-16', 'A'),
(4, 4, '2026-01-17', 'A-'),
(5, 11, '2026-01-18', 'B+'),
(6, 3, '2026-01-19', 'A'),
(6, 7, '2026-01-20', 'A-'),
(7, 8, '2026-01-21', 'A'),
(8, 6, '2026-01-22', 'B+'),
(9, 9, '2026-01-23', 'A-'),
(10, 10, '2026-01-24', 'A'),
(11, 9, '2026-01-25', 'B'),
(12, 14, '2026-01-26', 'A-'),
(12, 15, '2026-01-27', NULL);


-- ============================================================
-- 10. Check Tables
-- ============================================================

SELECT * FROM students;

SELECT * FROM teachers;

SELECT * FROM courses;

SELECT * FROM enrollments;


-- ============================================================
-- 11. Check Relationships
-- ============================================================

-- Courses with their teachers

SELECT
    c.id,
    c.title,
    c.credits,
    t.name AS teacher,
    t.department
FROM courses c
LEFT JOIN teachers t
    ON c.teacher_id = t.id;


-- Enrollments with student and course information

SELECT
    e.id,
    s.name AS student,
    s.email,
    c.title AS course,
    e.enrollment_date,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.id
JOIN courses c
    ON e.course_id = c.id;


-- ============================================================
-- Database Relationship
-- ============================================================

-- One Teacher
--      |
--      | 1 : Many
--      ↓
-- Many Courses
--
-- One Student
--      |
--      | 1 : Many
--      ↓
-- Many Enrollments
--      ↑
--      | Many : 1
--      |
-- One Course
--
--
-- Student <---> Course
--       Many-to-Many
--       through Enrollments