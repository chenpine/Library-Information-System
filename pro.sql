rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

SET SERVEROUTPUT ON

-- pro_print_borrower
CREATE PROCEDURE pro_print_borrower IS

CURSOR print_borrower IS
	SELECT Borrower.name, Books.book_title, Issue.issue_date
	FROM Borrower, Books, Issue
	WHERE Issue.return_date is NULL 
		AND Borrower.borrower_id = Issue.borrower_id AND Issue.book_id = Books.book_id;

borrowername varchar2(30);
booktitle varchar2(50);
issuedate date;
duration number;

BEGIN 
	OPEN print_borrower;
	DBMS_OUTPUT.PUT_LINE('  Borrower Name   |   Book title   | <=5 days | <= 10 days| <= 15 days| > 15 days');
	DBMS_OUTPUT.PUT_LINE('-----------------  ---------------- ----- ------- ------- ------');
	LOOP
		FETCH print_borrower INTO borrowername, booktitle, issuedate;
		EXIT WHEN print_borrower%NOTFOUND;
		-- Using System date
		duration := trunc(sysdate) - to_date(issuedate, 'MM/DD/YY');
		
		-- Using the date in the provided Output.txt as today!
		-- duration := to_date('02/28/03', 'MM/DD/YY')-to_date(issuedate, 'MM/DD/YY');
		IF (duration <= 5)
			THEN DBMS_OUTPUT.PUT_LINE(borrowername||'   '||booktitle||' '||duration);
		ELSIF (duration between 6 AND 10)
			THEN DBMS_OUTPUT.PUT_LINE(borrowername||'   '||booktitle||'      '||duration);
		ELSIF (duration between 11 AND 15)
			THEN DBMS_OUTPUT.PUT_LINE(borrowername||'   '||booktitle||'           '||duration);
		ELSIF (duration > 15)
			THEN DBMS_OUTPUT.PUT_LINE(borrowername||'   '||booktitle||'               '||duration);
		END IF;
	END LOOP;
	CLOSE print_borrower;
END;
/

-- pro_print_fine
CREATE PROCEDURE pro_print_fine(currentdate IN date) IS

CURSOR print_fine IS
	SELECT Borrower.name, Issue.book_id, Issue.issue_date, Issue.return_date
	FROM Issue, Borrower
	WHERE (Issue.return_date - Issue.issue_date > 5 AND Issue.borrower_id = Borrower.borrower_id) 
		OR (currentdate - Issue.issue_date > 5 AND Issue.return_date is NULL AND Issue.borrower_id = Borrower.borrower_id);

borrowername varchar2(30);
bookid number;
issuedate date;
returndate date;

BEGIN
	OPEN print_fine;
	LOOP
		FETCH print_fine INTO borrowername, bookid, issuedate, returndate;
		EXIT WHEN print_fine%NOTFOUND;
		IF returndate IS NULL
			THEN DBMS_OUTPUT.PUT_LINE('  Borrower  | Book ID |  Issue Date  | Fine ');
			     DBMS_OUTPUT.PUT_LINE(' ----------- --------- -------------- ------');
			     DBMS_OUTPUT.PUT_LINE(borrowername||'  '||bookid||'     '||issuedate||'     '||(currentdate-issuedate)*5);
		ELSE DBMS_OUTPUT.PUT_LINE('  Borrower  | Book ID |  Issue Date  | FINE ');
		     DBMS_OUTPUT.PUT_LINE(' ----------- --------- -------------- ------');
		     DBMS_OUTPUT.PUT_LINE(borrowername||'  '||bookid||'     '||issuedate||'     '||(returndate-issuedate)*5);
		END IF;
	END LOOP;
	CLOSE print_fine;
END;
/

-- pro_listborr_mon
CREATE PROCEDURE pro_listborr_mon(ber_id IN Number, MON IN varchar2) IS 

MM Number := fun_MON_to_MM(MON);
borrowerid Number;
borrowername varchar2(30);
bookid Number;
booktitle varchar2(50);
issuedate date;
returndate date;

CURSOR listborr_mon IS
	SELECT Issue.borrower_id, Borrower.name, Issue.book_id, Books.book_title, Issue.issue_date, Issue.return_date
	FROM Issue, Borrower, Books
	WHERE EXTRACT(month FROM Issue.issue_date) = MM AND Issue.borrower_id = Borrower.borrower_id AND Issue.book_id = Books.book_id;

BEGIN
	OPEN listborr_mon;
	DBMS_OUTPUT.PUT_LINE('Borrower ID |  Borrower Name  | Book ID |    Book Title    | Issue Date | Return Date ');
	DBMS_OUTPUT.PUT_LINE('------------ ----------------- --------- ------------------ ------------ -------------');
	LOOP
		FETCH listborr_mon INTO borrowerid, borrowername, bookid, booktitle, issuedate, returndate;
		EXIT WHEN listborr_mon%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(borrowerid||'        '||borrowername||'  '||bookid||'     '||booktitle||'  '||issuedate||'  '||returndate);
	END LOOP;
	CLOSE listborr_mon;
END;
/

-- pro_listborr
CREATE PROCEDURE pro_listborr IS

borrowername varchar2(30);
bookid number;
issuedate date;

CURSOR listborr IS
	SELECT Borrower.name, Issue.book_id, Issue.issue_date
	FROM Borrower, Issue
	WHERE Issue.borrower_id = Borrower.borrower_id AND Issue.return_date IS NULL;

BEGIN
	OPEN listborr;
	DBMS_OUTPUT.PUT_LINE('Borrower Name | Book ID | Issue Date ');
	DBMS_OUTPUT.PUT_LINE('-------------- --------- ------------');
	LOOP
		FETCH listborr INTO borrowername, bookid, issuedate;
		EXIT WHEN listborr%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(borrowername||'  '||bookid||'   '||issuedate);
	END LOOP;
	CLOSE listborr;
END;
/

-- pro_list_popular
CREATE PROCEDURE pro_list_popular IS
bookid Number;
m Number;
y Number;
authorname varchar2(30);
edition Number;

l_return SYS_REFCURSOR;

BEGIN
     -- January
	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 1 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 1)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 1 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- February
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 2 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 2)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 2 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- March
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 3 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 3)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 3 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;
	
     -- April
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 4 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 4)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 4 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- May
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 5 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 5)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 5 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- June
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 6 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 6)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 6 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- July
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 7 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 7)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 7 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- August
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 8 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 8)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 8 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- September
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 9 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 9)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 9 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- October
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 10 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 10)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 10 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- November
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 11 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 11)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 11 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;

     -- December
 	OPEN l_return FOR
		SELECT Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Author.Name, Books.edition 
		FROM Issue, Books, Author
		WHERE EXTRACT(month FROM Issue.issue_date) = 12 
			AND (EXTRACT(year FROM Issue.issue_date) 
				IN (SELECT EXTRACT(year FROM I2.issue_date)
		    		    FROM Issue I2						
		    		    WHERE EXTRACT(month FROM I2.issue_date) = 12)) AND Books.book_id = Issue.book_id AND Books.author_id = Author.author_id
		GROUP BY Issue.book_id, EXTRACT(month FROM Issue.issue_date), EXTRACT(year FROM Issue.issue_date), Books.edition, Author.Name
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = 12 AND EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM Issue.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM Issue.issue_date);
	LOOP
		FETCH l_return INTO bookid, m, y, authorname, edition;
		EXIT WHEN l_return%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Book ID: '||bookid||'  month/year: '||m||'/'||y||' Author: '||authorname||' Edition: '||edition);
	END LOOP;
END;
/



