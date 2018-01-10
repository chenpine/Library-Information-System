rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

SET SERVEROUTPUT ON
-- fun_issue_book
CREATE FUNCTION fun_issue_book(borrowerid IN number, bookid IN number, currentdate IN date)
Return Number IS book_status varchar2(20);

BEGIN
	SELECT status INTO book_status
	FROM Books
	WHERE book_id = bookid;
	
	IF (book_status = 'not charged')
	THEN
	 INSERT INTO Issue values (bookid, borrowerid, currentdate, NULL);
	 RETURN 1;
	ELSIF (book_status = 'charged')
	THEN 
	 INSERT INTO Pending_request values (bookid, borrowerid, currentdate, NULL);
	 RETURN 0;
	END IF;
END;
/

-- fun_issue_anyedition
CREATE FUNCTION fun_issue_anyedition(borrowerid IN number, booktitle IN varchar2, authorname IN varchar2, currentdate IN date)
Return Number IS 
Books_bid NUMBER;
Available_Issue_bid NUMBER;
book_status NUMBER;

BEGIN 
	BEGIN
		SELECT B1.book_id INTO Books_bid
		FROM Books B1, Author A1
 		WHERE B1.status = 'not charged' AND B1.book_title = booktitle AND A1.Name = authorname
			AND B1.author_id = A1.author_id AND edition = (SELECT MAX(B2.edition)
									FROM Books B2, Author A2
									WHERE B2.status = 'not charged' 
										AND B2.book_title = booktitle 
										AND A2.Name = authorname			
										AND B2.author_id = A2.author_id);
	EXCEPTION
	WHEN NO_DATA_FOUND THEN Books_bid := NULL;
	END;
	
	BEGIN
		SELECT MAX(I1.book_id) INTO Available_Issue_bid
		FROM Issue I1, Books B1, Author A1
		WHERE B1.book_title = booktitle AND A1.Name = authorname AND I1.book_id = B1.book_id AND B1.author_id = A1.author_id 
			AND I1.return_date is NULL AND I1.issue_date <= ALL (SELECT I2.issue_date
										FROM Issue I2, Books B2, Author A2
										WHERE B2.book_title = booktitle
											AND A2.Name = authorname
											AND B2.author_id = A2.author_id
											AND B2.book_id = I2.book_id AND I2.return_date is NULL);
	EXCEPTION
	WHEN NO_DATA_FOUND THEN Available_Issue_bid := NULL;
	END;

	IF Books_bid is NULL THEN book_status := fun_issue_book(borrowerid, Available_Issue_bid, currentdate);
	Return 0;
	ELSIF Books_bid is not NULL THEN INSERT INTO Issue VALUES(Books_bid, borrowerid, currentdate, NULL);
	Return 1;
	END if;
END;
/

-- fun_MON_to_MM
CREATE FUNCTION fun_MON_to_MM(MON IN varchar2)
RETURN NUMBER is 

BEGIN
	IF MON = 'JAN' THEN RETURN 01;
	ELSIF MON = 'FEB' THEN RETURN 02;
	ELSIF MON = 'MAR' THEN RETURN 03;
	ELSIF MON = 'APR' THEN RETURN 04;
	ELSIF MON = 'MAY' THEN RETURN 05;
	ELSIF MON = 'JUN' THEN RETURN 06;
	ELSIF MON = 'JUL' THEN RETURN 07;
	ELSIF MON = 'AUG' THEN RETURN 08;
	ELSIF MON = 'SEP' THEN RETURN 09;
	ELSIF MON = 'OCT' THEN RETURN 10;
	ELSIF MON = 'NOV' THEN RETURN 11;
	ELSIF MON = 'DEC' THEN RETURN 12;
	END IF;
END;
/


-- fun_return_book
CREATE FUNCTION fun_return_book(bookid number, returndate date)
Return NUMBER is requesterid NUMBER;
BEGIN 
	BEGIN
	SELECT P1.requester_id INTO requesterid
	FROM Pending_request P1
	WHERE P1.book_id = bookid AND P1.Issue_date is NULL 
		AND P1.request_date = (SELECT MIN(P2.request_date) 
				       FROM Pending_request P2
				       WHERE P2.book_id = bookid AND P2.Issue_date is NULL);
	EXCEPTION
	WHEN NO_DATA_FOUND THEN requesterid := NULL;
	END;
	
	IF requesterid is NULL 
	THEN UPDATE Issue SET return_date = returndate 
		WHERE book_id = bookid AND return_date is NULL;
		RETURN 1;
	ELSIF requesterid is not NULL
	THEN UPDATE Issue SET return_date = returndate
		WHERE book_id = bookid AND return_date is NULL;
		INSERT INTO Issue values (bookid, requesterid, returndate, NULL);
		UPDATE Pending_request SET Issue_date = returndate
		WHERE requester_id = requesterid AND book_id = bookid AND Issue_date is NULL;
		RETURN 0;
	END IF;
END;
/


-- fun_most_popular
CREATE FUNCTION fun_most_popular(MON IN varchar2)
RETURN Number is 
MM Number := fun_MON_to_MM(MON);
hot_bookid NUMBER;
hot_year NUMBER;

l_return SYS_REFCURSOR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Most popular book: ');
	OPEN l_return for 
		SELECT I1.book_id, EXTRACT(year FROM I1.issue_date) AS year
		FROM Issue I1
		WHERE EXTRACT(month FROM I1.issue_date) = MM 
			AND
		      (EXTRACT(year FROM I1.issue_date) IN (SELECT EXTRACT(year FROM I2.issue_date)
							    FROM Issue I2
							    WHERE EXTRACT(month FROM I2.issue_date) = MM))
		GROUP BY I1.book_id, EXTRACT(year FROM I1.issue_date)
		HAVING COUNT(*) >= ALL (SELECT COUNT(*)
					FROM Issue I3
					WHERE EXTRACT(month FROM I3.issue_date) = MM
						AND
					      EXTRACT(year FROM I3.issue_date) = EXTRACT(year FROM I1.issue_date)
					GROUP BY I3.book_id)
		ORDER BY EXTRACT(year FROM I1.issue_date);
	LOOP
	fetch l_return INTO hot_bookid, hot_year;
	EXIT WHEN l_return%notfound;
	DBMS_OUTPUT.PUT_LINE('Book ID: '||hot_bookid||' '||MON||' '||hot_year);
	END LOOP;
	RETURN 0;
END;
/

