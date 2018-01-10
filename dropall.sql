rem EE 562 Project 2
rem Yen-Sung Chen
rem chen2310@ecn2

DROP table Books;
DROP table Author;
DROP table Borrower;
DROP table Issue;
DROP table Pending_request;

DROP TRIGGER trg_maxbooks;
DROP TRIGGER trg_charge;
DROP TRIGGER trg_notcharge;
DROP TRIGGER trg_renew;

DROP FUNCTION fun_issue_book;
DROP FUNCTION fun_issue_anyedition;
DROP FUNCTION fun_most_popular;
DROP FUNCTION fun_return_book;
DROP FUNCTION fun_MON_to_MM;

DROP PROCEDURE pro_print_borrower;
DROP PROCEDURE pro_print_fine;
DROP PROCEDURE pro_listborr_mon;
DROP PROCEDURE pro_listborr;
DROP PROCEDURE pro_list_popular;
