/* LESSON 3 — MICROSOFT SQL SERVER (T-SQL)
   Run in SQL Server Management Studio (SSMS) or Azure Data Studio.
   Demonstrates the topics in Lesson 3: DDL, DML, CRUD, constraints,
   NULL/NOT NULL, ALTER, SELECT, WHERE, DISTINCT, TOP, string functions,
   CONCAT, and ORDER BY. GO is an SSMS batch separator.
   This is a practice database. Do not run against production data.
*/

-- 1. DDL: create a database and select it
IF DB_ID(N'Lesson3Practice') IS NULL
    CREATE DATABASE Lesson3Practice;
GO
USE Lesson3Practice;
GO

-- 2. DDL: create tables, data types, identity, primary key, constraints
-- Drop the practice tables so the script can be rerun from scratch.
DROP TABLE IF EXISTS dbo.Books;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Students;
GO
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT CK_Products_Price CHECK (Price >= 0)
);

CREATE TABLE dbo.Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Age INT NULL,                    -- NULL means missing/unknown
    Grade NVARCHAR(10) NOT NULL,
    CONSTRAINT CK_Students_Age CHECK (Age IS NULL OR Age > 0)
);
GO

-- 3. DML / CRUD: CREATE rows using INSERT
INSERT INTO dbo.Products (Name, Price)
VALUES (N'Laptop', 999.99), (N'Mouse', 25.50), (N'Keyboard', 45.00);

INSERT INTO dbo.Students (FirstName, LastName, Age, Grade)
VALUES (N'Alice', N'Smith', 18, N'A'),
       (N'Bob', N'Jones', 19, N'B'),
       (N'Carol', N'Smith', 18, N'A'),
       (N'David', N'Brown', NULL, N'C');
GO

-- 4. CRUD: READ rows with SELECT; * means all columns
SELECT * FROM dbo.Products;
SELECT FirstName, Age, Grade FROM dbo.Students;

-- 5. WHERE: filter rows (including price greater than 40)
SELECT * FROM dbo.Products WHERE Price > 40;
SELECT * FROM dbo.Students WHERE Age = 18;
SELECT * FROM dbo.Students WHERE Age IS NULL; -- not Age = NULL

-- 6. DISTINCT: unique values
SELECT DISTINCT Age FROM dbo.Students;

-- 7. TOP: first two rows by a specified, predictable order
SELECT TOP (2) FirstName, Grade
FROM dbo.Students
ORDER BY StudentID;

-- 8. String functions in Microsoft SQL Server
SELECT FirstName, UPPER(LastName) AS UpperLastName FROM dbo.Students;
SELECT FirstName, LOWER(LastName) AS LowerLastName FROM dbo.Students;
SELECT LastName, LEN(LastName) AS LastNameLength FROM dbo.Students;
SELECT CONCAT(FirstName, N' (', StudentID, N')') AS StudentLabel
FROM dbo.Students;

-- 9. ORDER BY: without it, row order is NOT guaranteed
SELECT FirstName, LastName, Age
FROM dbo.Students
ORDER BY LastName ASC, FirstName ASC;

-- 10. CRUD: UPDATE existing data; WHERE avoids updating every row
UPDATE dbo.Products SET Price = 899.99 WHERE Name = N'Laptop';
SELECT * FROM dbo.Products WHERE Name = N'Laptop';

-- 11. CRUD: DELETE selected data; WHERE avoids deleting every row
DELETE FROM dbo.Products WHERE Name = N'Mouse';
SELECT * FROM dbo.Products;
GO

-- 12. ALTER TABLE: change an existing table's structure
ALTER TABLE dbo.Students ADD Email NVARCHAR(100) NULL;
GO
-- Add a named UNIQUE constraint (multiple NULL values are restricted
-- in SQL Server under a single-column UNIQUE constraint).
ALTER TABLE dbo.Students
ADD CONSTRAINT UQ_Students_Email UNIQUE (Email);
GO
UPDATE dbo.Students SET Email = N'alice@example.com' WHERE FirstName = N'Alice';
SELECT * FROM dbo.Students;

-- Alter a column's nullability (all existing values must be compatible)
ALTER TABLE dbo.Students ALTER COLUMN Grade NVARCHAR(10) NULL;
GO
-- Demonstrate dropping a column safely after dropping its constraint
ALTER TABLE dbo.Students DROP CONSTRAINT UQ_Students_Email;
ALTER TABLE dbo.Students DROP COLUMN Email;
GO

-- 13. BOOKSTORE TASK FROM SLIDES 15–16
-- Create an independent bookstore database and use it.
IF DB_ID(N'bookstore') IS NULL
    CREATE DATABASE bookstore;
GO
USE bookstore;
GO
DROP TABLE IF EXISTS dbo.books;
GO
CREATE TABLE dbo.books (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
INSERT INTO dbo.books (title, price)
VALUES (N'The Great Adventure', 15.99),
       (N'Old Tales', 9.50),
       (N'Learning SQL', 29.99);
SELECT * FROM dbo.books;
UPDATE dbo.books SET price = 19.99 WHERE title = N'The Great Adventure';
DELETE FROM dbo.books WHERE title = N'Old Tales';
SELECT * FROM dbo.books ORDER BY id;
GO

/* EXAM RECAP
   DDL = Data Definition Language: CREATE, ALTER, DROP.
   DML = Data Manipulation Language: INSERT, UPDATE, DELETE (SELECT is
         commonly grouped with DML in introductory materials).
   CRUD = Create (INSERT), Read (SELECT), Update (UPDATE), Delete (DELETE).
   SQL Server uses TOP, LEN, and IDENTITY; not LIMIT, LENGTH, AUTO_INCREMENT.
   SQL keywords are generally case-insensitive; identifiers/data comparison
   sensitivity can depend on database collation.
   Semicolons terminate SQL statements; GO separates SSMS batches.
*/
