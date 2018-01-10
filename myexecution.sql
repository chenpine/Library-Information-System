rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

-- Populate the Books, Author and Borrower tables
@populate

-- Execute all the triggers
@trg

-- Create all the functions
@fun

-- Create all the procedures 
@pro

-- Use fun_issue_book() to populate the Issue and Pending_request tables
BEGIN
DBMS_OUTPUT.PUT_LINE('======================================================================');
DBMS_OUTPUT.PUT_LINE('Use fun_issue_book() to populate the Issue and Pending_request tables.');
DBMS_OUTPUT.PUT_LINE('======================================================================');
END;
/
@mydata

-- Use fun_issue_anyedition() to insert records for testing. Must take all the four parameters
BEGIN
DBMS_OUTPUT.PUT_LINE('============================================================================================');
DBMS_OUTPUT.PUT_LINE('Use fun_issue_anyedition() to insert records for testing. Must take all the four parameters.');
DBMS_OUTPUT.PUT_LINE('============================================================================================');
END;
/
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(2,'DATA MANAGEMENT','C.J. DATES','3/3/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(4,'CALCULUS','H. ANTON','3/4/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(5,'ORACLE','ORACLE PRESS','3/4/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(10,'IEEE MULTIMEDIA','IEEE','2/27/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(2,'MIS MANAGEMENT','C.J. CATES','5/3/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(4,'CALCULUS II','H. ANTON','3/4/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(10,'ORACLE','ORACLE PRESS','3/4/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(5,'IEEE MULTIMEDIA','IEEE','2/26/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(2,'DATA STRUCTURE','W. GATES','3/3/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(4,'CALCULUS III','H. ANTON','4/4/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(11,'ORACLE','ORACLE PRESS','3/8/05'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_anyedition(6,'IEEE MULTIMEDIA','IEEE','2/17/05'));

-- Execute pro_print_borrower
BEGIN
DBMS_OUTPUT.PUT_LINE('===========================');
DBMS_OUTPUT.PUT_LINE('Execute pro_print_borrower.');
DBMS_OUTPUT.PUT_LINE('===========================');
END;
/
BEGIN
pro_print_borrower;
END;
/

-- Execute pro_print_fine
BEGIN
DBMS_OUTPUT.PUT_LINE('=======================');
DBMS_OUTPUT.PUT_LINE('Execute pro_print_fine.');
DBMS_OUTPUT.PUT_LINE('=======================');
END;
/
BEGIN
pro_print_fine('02/28/03');
END;
/

-- Use fun_return_book() to return books with book_id 1, 2, 4, 10. Specify the returns date as the second parameter
BEGIN
DBMS_OUTPUT.PUT_LINE('=================================================================================================================');
DBMS_OUTPUT.PUT_LINE('Use fun_return_book() to return books with book_id 1, 2, 4, 10. Specify the returns date as the second parameter.');
DBMS_OUTPUT.PUT_LINE('=================================================================================================================');
END;
/
EXEC DBMS_OUTPUT.PUT_LINE(fun_return_book(1,'02/28/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_return_book(2,'02/28/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_return_book(4,'02/28/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_return_book(10,'02/28/03'));

-- Print the Pending_request table and the Issue table
BEGIN
DBMS_OUTPUT.PUT_LINE('====================================================');
DBMS_OUTPUT.PUT_LINE('Print the Pending_request table and the Issue table.');
DBMS_OUTPUT.PUT_LINE('====================================================');
END;
/
SELECT * FROM Pending_request;
SELECT * FROM Issue;

-- Execute pro_listborr_mon for the month of February and March, for a given borrower_id
BEGIN
DBMS_OUTPUT.PUT_LINE('======================================================================================');
DBMS_OUTPUT.PUT_LINE('Execute pro_listborr_mon for the month of February and March, for a given borrower_id.');
DBMS_OUTPUT.PUT_LINE('======================================================================================');
END;
/
BEGIN
pro_listborr_mon(1, 'FEB');
pro_listborr_mon(1, 'MAR');
END;
/

-- Execute pro_list_borr
BEGIN
DBMS_OUTPUT.PUT_LINE('======================');
DBMS_OUTPUT.PUT_LINE('Execute pro_list_borr.');
DBMS_OUTPUT.PUT_LINE('======================');
END;
/
BEGIN
pro_listborr;
END;
/

-- Execute pro_list_popular
BEGIN
DBMS_OUTPUT.PUT_LINE('=========================');
DBMS_OUTPUT.PUT_LINE('Execute pro_list_popular.');
DBMS_OUTPUT.PUT_LINE('=========================');
END;
/
BEGIN
pro_list_popular;
END;
/

-- Print the average time a requester waits in the Pending_request table
BEGIN
DBMS_OUTPUT.PUT_LINE('======================================================================');
DBMS_OUTPUT.PUT_LINE('Print the average time a requester waits in the Pending_request table.');
DBMS_OUTPUT.PUT_LINE('======================================================================');
END;
/
SELECT AVG(Pending_request.Issue_date - Pending_request.request_date)
FROM Pending_request;

-- Print the name and the borrower_id of the person who has waited the longest amount of time for any book
BEGIN
DBMS_OUTPUT.PUT_LINE('========================================================================================================');
DBMS_OUTPUT.PUT_LINE('Print the name and the borrower_id of the person who has waited the longest amount of tine for any book.');
DBMS_OUTPUT.PUT_LINE('========================================================================================================');
END;
/ 
SELECT Borrower.name, Borrower.borrower_id
FROM Pending_request, Borrower
WHERE Pending_request.Issue_date - Pending_request.request_date = (SELECT MAX(Pending_request.Issue_date - Pending_request.request_date)
								   FROM Pending_request)
	AND
      Pending_request.requester_id = Borrower.borrower_id;

-- Drop all the tables, triggers, functions, and procedures
@dropall
