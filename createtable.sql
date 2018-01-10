rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

DROP TABLE Books;
DROP TABLE Author;
DROP TABLE Borrower;
DROP TABLE Issue;
DROP TABLE Pending_request;

CREATE TABLE Books
(book_id NUMBER,
book_title VARCHAR2(50),
author_id NUMBER,
year_of_publication NUMBER,
edition NUMBER,
status VARCHAR2(20),
CONSTRAINT Books_PK PRIMARY KEY (book_id)
);

CREATE TABLE Author
(author_id NUMBER,
Name VARCHAR2(30),
CONSTRAINT Author_PK PRIMARY KEY (author_id)
);

CREATE TABLE Borrower
(borrower_id NUMBER,
name VARCHAR2(30),
status VARCHAR2(20),
CONSTRAINT Borrower_PK PRIMARY KEY (borrower_id)
);

CREATE TABLE Issue
(book_id NUMBER,
borrower_id NUMBER,
issue_date date,
return_date date,
CONSTRAINT Issue_PK PRIMARY KEY (book_id, borrower_id, issue_date)
);

CREATE TABLE Pending_request
(book_id NUMBER,
requester_id NUMBER,
request_date date,
Issue_date date,
CONSTRAINT Pending_request_PK PRIMARY KEY (book_id, requester_id, request_date)
);

