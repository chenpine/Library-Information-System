rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

--Add records into Books table
INSERT INTO Author VALUES (1, 'C.J. DATES');
INSERT INTO Author VALUES (2, 'H. ANTON');
INSERT INTO Author VALUES (3, 'ORACLE PRESS');
INSERT INTO Author VALUES (4, 'IEEE');
INSERT INTO Author VALUES (5, 'C.J. CATES');
INSERT INTO Author VALUES (6, 'W. GATES');
INSERT INTO Author VALUES (7, 'CLOIS KICKLIGHTER');
INSERT INTO Author VALUES (8, 'J.R.R. TOLKIEN');
INSERT INTO Author VALUES (9, 'TOM CLANCY');
INSERT INTO Author VALUES (10, 'ROGER ZELAZNY');

--Add records into Book table
INSERT INTO Books VALUES (1, 'DATA MANAGEMENT', 1, 1998, 3, 'not charged');
INSERT INTO Books VALUES (2, 'CALCULUS', 2, 1995, 7, 'not charged');
INSERT INTO Books VALUES (3, 'ORACLE', 3, 1999, 8, 'not charged');
INSERT INTO Books VALUES (4, 'IEEE MULTIMEDIA', 4, 2001, 1, 'not charged');
INSERT INTO Books VALUES (5, 'MIS MANAGEMENT', 5, 1990, 1, 'not charged');
INSERT INTO Books VALUES (6, 'CALCULUS II', 2, 1997, 3, 'not charged');
INSERT INTO Books VALUES (7, 'DATA STRUCTURE', 6, 1992, 1, 'not charged');
INSERT INTO Books VALUES (8, 'CALCULUS III', 2, 1999, 1, 'not charged');
INSERT INTO Books VALUES (9, 'CALCULUS III', 2, 2000, 2, 'not charged');
INSERT INTO Books VALUES (10, 'ARCHITECTURE', 7, 1977, 1, 'not charged');
INSERT INTO Books VALUES (11, 'ARCHITECTURE', 7, 1980, 2, 'not charged');
INSERT INTO Books VALUES (12, 'ARCHITECTURE', 7, 1985, 3, 'not charged');
INSERT INTO Books VALUES (13, 'ARCHITECTURE', 7, 1990, 4, 'not charged');
INSERT INTO Books VALUES (14, 'ARCHITECTURE', 7, 1995, 5, 'not charged');
INSERT INTO Books VALUES (15, 'ARCHITECTURE', 7, 2000, 6, 'not charged');
INSERT INTO Books VALUES (16, 'THE HOBBIT', 8, 1960, 1, 'not charged');
INSERT INTO Books VALUES (17, 'THE BEAR AND THE DRAGON', 9, 2000, 1, 'not charged');
INSERT INTO Books VALUES (18, 'NINE PRINCES IN AMBER', 10, 1970, 1, 'not charged');

--Add records into Borrower table
INSERT INTO Borrower values(1, 'BRAD KICKLIGHTER', 'student');
INSERT INTO Borrower values(2, 'JOE STUDENT', 'student');
INSERT INTO Borrower values(3, 'GEDDY LEE', 'student');
INSERT INTO Borrower values(4, 'JOE FACULTY', 'faculty');
INSERT INTO Borrower values(5, 'ALBERT EINSTEIN', 'faculty');
INSERT INTO Borrower values(6, 'MIKE POWELL', 'student');
INSERT INTO Borrower values(7, 'DAVID GOWER', 'faculty');
INSERT INTO Borrower values(8, 'ALBERT SUNARTO', 'student');
INSERT INTO Borrower values(9, 'GEOFFERY BYCOTT', 'faculty');
INSERT INTO Borrower values(10, 'JOHN KACSZYCA', 'student');
INSERT INTO Borrower values(11, 'IAN LAMB', 'faculty');
INSERT INTO Borrower values(12, 'ANTONIO AKE', 'student');

ALTER SESSION SET NLS_DATE_FORMAT='MM/DD/YY';
