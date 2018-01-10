rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

ALTER SESSION SET NLS_DATE_FORMAT='MM/DD/YY';
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(1,1,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(2,2,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(3,3,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(4,4,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(5,5,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(6,6,'02/10/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(7,1,'02/11/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(8,2,'02/12/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(9,3,'02/13/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(10,4,'02/14/03'));
EXEC DBMS_OUTPUT.PUT_LINE(fun_issue_book(11,10,'02/15/03'));
