-- Step 1
CREATE TABLE categories (
    category_id   NUMBER PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL
);

CREATE TABLE members (
    member_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email     VARCHAR2(150),
    phone     VARCHAR2(20),
    city      VARCHAR2(50),
    joined_on DATE DEFAULT SYSDATE,
    points    NUMBER DEFAULT 0
);

CREATE TABLE books (
    book_id          NUMBER PRIMARY KEY,
    title            VARCHAR2(200) NOT NULL,
    author           VARCHAR2(100),
    category_id      NUMBER,
    price            NUMBER(8,2),
    copies_available NUMBER,
    published_year   NUMBER
);

CREATE TABLE loans (
    loan_id   NUMBER PRIMARY KEY,
    member_id NUMBER,
    book_id   NUMBER,
    loaned_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    status    VARCHAR2(20) DEFAULT 'ACTIVE'
);


-- Step 2
INSERT INTO categories VALUES (1, 'Technology');
INSERT INTO categories VALUES (2, 'Fiction');
INSERT INTO categories VALUES (3, 'History');

INSERT INTO members VALUES (1, 'Ahmed Hassan', 'ahmed.hassan@mail.com', '01012345678', 'Cairo', ADD_MONTHS(SYSDATE, -14), 250);
INSERT INTO members VALUES (2, 'Mona Ali', 'mona.ali@mail.com', '01123456789', 'Cairo', ADD_MONTHS(SYSDATE, -9), 120);
INSERT INTO members VALUES (3, 'Youssef Samir', 'youssef@gmail.com', '01234567890', 'Giza', ADD_MONTHS(SYSDATE, -3), 0);
INSERT INTO members VALUES (4, 'Amira Tarek', 'amira@mail.com', '01098765432', 'Alexandria', ADD_MONTHS(SYSDATE, -20), 80);
INSERT INTO members VALUES (5, 'Karim Nabil', 'karim@gmail.com', NULL, 'Cairo', ADD_MONTHS(SYSDATE, -7), 150);
INSERT INTO members VALUES (6, 'Sara Mahmoud', 'sara@mail.com', '01155551234', 'Giza', ADD_MONTHS(SYSDATE, -2), 400);
INSERT INTO members VALUES (7, 'Omar Fathy', 'omar@yahoo.com', '01277778888', 'Cairo', ADD_MONTHS(SYSDATE, -12), 95);
INSERT INTO members VALUES (8, 'Laila Adel', 'laila@mail.com', '01066669999', 'Mansoura', ADD_MONTHS(SYSDATE, -1), 30);

INSERT INTO books VALUES (1, 'Algorithms Made Simple', 'Omar Salem', 1, 450.00, 5, 2020);
INSERT INTO books VALUES (2, 'Ancient Egypt', 'Hana Mostafa', 3, 320.00, 3, 2018);
INSERT INTO books VALUES (3, 'Pocket SQL Guide', 'Nadia Fouad', 1, 85.00, 12, 2022);
INSERT INTO books VALUES (4, 'Spring Boot in Action', 'Tarek Hegazy', 1, 500.00, 4, 2023);
INSERT INTO books VALUES (5, 'Complete Oracle Reference', 'Mina Gerges', 1, 1250.00, 2, 2021);
INSERT INTO books VALUES (6, 'The Desert Night', 'Laila Hamdy', 2, 150.00, 0, 2015);
INSERT INTO books VALUES (7, 'Egyptian History', 'Hana Mostafa', 3, 280.00, 6, 2019);
INSERT INTO books VALUES (8, 'City of Lights', NULL, 2, 199.99, 7, 2017);
INSERT INTO books VALUES (9, 'Clean Code Basics', 'Youssef Anwar', 1, 600.00, 8, 2020);
INSERT INTO books VALUES (10, 'The Last Pharaoh', 'Amr Zaki', 3, 100.00, 1, 2016);

INSERT INTO loans (loan_id, member_id, book_id) VALUES (1, 1, 1);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (2, 2, 3);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (3, 3, 2);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (4, 1, 4);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (5, 6, 5);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (6, 7, 9);


-- Step 3
COMMIT;

ALTER TABLE books ADD (isbn VARCHAR2(20));

ALTER TABLE loans ADD (returned_at TIMESTAMP);


-- Step 4
UPDATE loans
SET status = 'RETURNED',
    returned_at = SYSTIMESTAMP
WHERE loan_id = 1;

UPDATE books
SET price = price * 1.10
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Fiction');

COMMIT;


-- Step 5
DELETE FROM books;

SELECT COUNT(*) AS books_after_delete FROM books;

ROLLBACK;

SELECT COUNT(*) AS books_after_rollback FROM books;

SELECT * FROM books ORDER BY book_id;

-- TRUNCATE is a DDL statement: Oracle commits implicitly before and after it, and it empties the table without
-- generating row-level undo data, so there would be nothing for ROLLBACK to restore.


-- Step 6
SELECT m.member_id, m.full_name
FROM members m
WHERE NOT EXISTS (SELECT 1 FROM loans l WHERE l.member_id = m.member_id);

DELETE FROM members WHERE member_id = 8;

ALTER TABLE loans RENAME TO book_loans;

COMMIT;


-- Step 7
SELECT * FROM members;


-- Step 8
SELECT title AS "Book Title", author AS "Author", price AS "Price"
FROM books;


-- Step 9
SELECT DISTINCT city FROM members;


-- Step 10
SELECT title, price, ROUND(price * 1.14, 2) AS price_with_vat
FROM books;


-- Step 11
SELECT * FROM members WHERE city = 'Cairo';

SELECT * FROM members WHERE city = 'cairo';

-- The second query returns no rows because string comparison in Oracle is case-sensitive: 'cairo' is not equal to 'Cairo'.


-- Step 12
SELECT * FROM books
WHERE price > 300 AND copies_available > 0;


-- Step 13
SELECT * FROM books
WHERE price BETWEEN 100 AND 500;

-- Yes, the book priced at exactly 500 shows up: BETWEEN includes both boundary values.


-- Step 14
SELECT * FROM members
WHERE city = 'Cairo' OR city = 'Giza' OR city = 'Alexandria';

SELECT * FROM members
WHERE city IN ('Cairo', 'Giza', 'Alexandria');

-- The IN version is cleaner: the column name is written once and the list of values is shorter and easier to extend.


-- Step 15
SELECT * FROM books WHERE title LIKE 'A%';

SELECT * FROM books WHERE title LIKE '%y';


-- Step 16
SELECT * FROM members WHERE phone IS NULL;

-- phone = NULL does not work because NULL means "unknown": comparing anything to NULL with = gives UNKNOWN, not TRUE, so no row is returned. IS NULL is required.


-- Step 17
SELECT * FROM books
ORDER BY price DESC, title ASC;


-- Step 18
SELECT full_name AS "Member Name",
       email     AS "Email",
       phone     AS "Phone Number",
       city      AS "City",
       points    AS "Points"
FROM members
WHERE city IN ('Cairo', 'Giza')
  AND phone IS NOT NULL
ORDER BY points DESC;


-- Step 19
SELECT full_name || ' — ' || city AS greeting
FROM members;

SELECT UPPER(full_name) AS upper_name, LENGTH(full_name) AS name_length
FROM members;

SELECT email, SUBSTR(email, 1, INSTR(email, '@') - 1) AS email_username
FROM members;


-- Step 20
SELECT * FROM members
WHERE joined_on < ADD_MONTHS(SYSDATE, -6)
  AND points < 200;


-- Step 21
-- Predictions (based on the members left after Step 6, member 8 deleted):
-- Query 1: 5 rows. AND binds tighter than OR, so it is Cairo (Ahmed, Mona, Karim, Omar) OR (Giza AND points >= 100) (Sara).
-- Query 2: 4 rows. Cairo or Giza with points >= 100: Ahmed, Mona, Karim, Sara.
-- Query 3: 0 rows, no error. BETWEEN needs the lower value first; 500 AND 100 can never be true.
-- Query 4: error ORA-00904: "PRICE_VAT": invalid identifier. WHERE is evaluated before the SELECT list, so the alias price_vat does not exist yet.
SELECT * FROM members
WHERE city = 'Cairo' OR city = 'Giza' AND points >= 100;

SELECT * FROM members
WHERE (city = 'Cairo' OR city = 'Giza') AND points >= 100;

SELECT * FROM books WHERE price BETWEEN 500 AND 100;

SELECT title, price * 1.14 AS price_vat
FROM books WHERE price_vat > 500;
