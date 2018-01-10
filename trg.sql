rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

-- trg_maxbooks for Rule 3
CREATE TRIGGER trg_maxbooks
BEFORE INSERT ON Issue
FOR EACH ROW

DECLARE
book_count number;
borrower_status varchar2(20);

BEGIN 
	SELECT COUNT(borrower_id) INTO book_count
	FROM Issue
	WHERE borrower_id= :new.borrower_id;
	
	SELECT status INTO borrower_status
	FROM Borrower
	WHERE borrower_id= :new.borrower_id;
	
	IF (borrower_status = 'student' AND book_count >= 2)
	 Then raise_application_error(-20000,'Maximum books (2) issued to a student is reached!');
	ELSIF (borrower_status = 'faculty' AND book_count >= 3)
	 THEN raise_application_error(-20001,'Maximum books (3) issued to a faculty is reached!');
	END IF;
END;
/ 

-- trg_charge 
CREATE TRIGGER trg_charge
AFTER INSERT ON Issue
FOR EACH ROW

BEGIN
	UPDATE Books
	SET status = 'charged'
	WHERE book_id = :new.book_id;
END;
/

-- trg_notcharge
CREATE TRIGGER trg_notcharge
AFTER UPDATE OF return_date ON Issue
FOR EACH ROW

BEGIN
	UPDATE Books
	SET status = 'notcharged'
	WHERE book_id = :new.book_id;
END;
/

-- trg_renew
CREATE TRIGGER trg_renew
BEFORE INSERT ON Pending_request
FOR EACH ROW

DECLARE
book_status varchar2(20);
currently_issued number;
unserved_request number;
unserved_request_same number;
others_pending_request number;

BEGIN
	SELECT status INTO book_status
	FROM Books
	WHERE book_id = :new.book_id;

	SELECT COUNT(*) INTO currently_issued
	FROM ISSUE
        WHERE borrower_id = :new.requester_id AND return_date is NULL;

	SELECT COUNT(*) INTO unserved_request
        FROM Pending_request
        WHERE requester_id = :new.requester_id AND Issue_date is NULL;

	SELECT COUNT(*) INTO unserved_request_same
	FROM Pending_request
	WHERE requester_id = :new.requester_id AND book_id = :new.book_id AND Issue_date is NULL;

	SELECT COUNT(*) INTO others_pending_request
	FROM Issue
	WHERE borrower_id = :new.requester_id AND book_id = :new.book_id AND return_date is NULL;

	IF book_status = 'charged' AND (currently_issued + unserved_request) > 6
	THEN RAISE_APPLICATION_ERROR(-20002, 'The sum of your borrowed and requested books has reached the limit 7!');
	ELSIF book_status = 'charged' AND unserved_request_same != 0
	THEN RAISE_APPLICATION_ERROR(-20003, 'You have requested this book already!');
	ELSIF book_status = 'charged' AND others_pending_request != 0
	THEN RAISE_APPLICATION_ERROR(-20004, 'Someone else is waiting for this book so it cannot be renewed!');
	END IF;
END;
/
