PLSQL Blocks/*
Declare -- optional
Begin -- mandatory
Exception -- optional
End; -- mandatory
*/
DDL-DML-DCL-TCL-DRl/*
DDL (data defination language) create, alter, drop, truncate
DML (data manupalation language) insert, update, delete, merge
DCL (data control language) grant, revoke
TCL (trasaction Control language) commit, rollback
DRL (Data retrival language) select
*/
Constraint/*
NOT NULL - Restricts NULL value from being inserted into a column. :ID int NOT NULL
CHECK - Verifies that all values in a field satisfy a condition. :CONSTRAINT CHK_Person CHECK (Age>=18 AND City='Sandnes')
DEFAULT - Automatically assigns a default value if no value :ALTER TABLE Persons ALTER City SET DEFAULT 'Sandnes'
UNIQUE - Ensures unique values to be inserted into the field. :ID int UNIQUE,
INDEX - Indexes a field providing faster retrieval of records.
PRIMARY KEY - Uniquely identifies each record in a table.(NOT null + Unique) :ID int NOT NULL PRIMARY KEY / CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
FOREIGN KEY - Ensures referential integrity for a record in another table. :FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
*/
Operations/*
Arithmetic : Addition, Subtraction, multiplication, Division
Comparison : Equal to, not equal to , greater than, less than
logical : and, or, not
other : between, IN, Like, Is Null, exists
*/
Functions/*
Numeric : ABS ( 10 -> 10), ROUND(10.78 -> 10.8), CEIL (10.27 -> 11) , FLOOR(10.27 -> 10)
Conversion : to_char, to_date, to_number
Character : upper, lower, concat, length, SUBSTR(VAL,strt_position,length) , INSTR(value,"TO FIND",END) ,initcap, lpad,rpad, ltrim,rtrim
Aggregate : SUM, AVG, MIN, MAX, COUNT
DATE : sysdate, systimestamp, add_months , months_between , next_day(sysdate,'SUNDAY'), last_day(show monthend)
*/
Window /Analytical Functions , calculation based on group , return values for each group /*
Rank : gaps ( skip the same value ) 1 2 2 4 4 6 select name,salary,rank() over (order by salary desc); <--count will be same
Dense rank : NO gaps ( no skip the same value ) 1 2 2 3 3 SELECT Employee,Region,Amount,DENSE_RANK() OVER (PARTITION BY Region ORDER BY Amount DESC) AS RankInRegion
FROM Sales; <--count will not be same
LEAD : LEAD(col,offset,default_val)over(order by col)
LAG : LAG(col,offset,default_val)over(order by col)
ROW_NUMBER
FIRST_value
LAST_value
NTH_value
NTILE
PERCENT_RANK
*/
order of Execution (FJWGHSDOL)/*
from => join => where => group by => having => select => distinct => order by => limit
*/
SQL                             | PLQSL/*
single query DML/DDL operations | block of codes(proc,pkg,funct,triggers,seq)
exec as single statement        | exec as block
no error handling               | error handling available
no condition check              | condition check
*/
DELETE                 | TRUNCATE/*
DML                    | DDL
commit needed          | auto commit
where condition needed | no where condition
slower due to undo     | faster
triggers fired         | no trgiggers fired
space not removed      | space removed
on delete cascade      | truncate cascade
*/
/*CASE                           | DECODE
SQL/PLSQL used                   | used in SQL
complex logic                    | simple logic
SELECT OrderID, Quantity,        |
CASE |
WHEN Quantity > 30 THEN          |SELECT DECODE(1, 1, 'Equal', 'Not Equal')
'The quantity is greater than 30'|AS result FROM dual; 
WHEN Quantity = 30 THEN 
'The quantity is 30'             
ELSE 'The quantity is under 30'  |
END AS QuantityText              |
FROM OrderDetails;               |
Multiple condition check         |equality check
easier to maintain               |harder to maintain
slower                           |faster
*/
OPERATORS  JOINS/*
union     : removes duplicates
union all : no duplicates removed
intersect : common data and sort
minus     : data from A ,common removed

inner : common from both
left : all from left, matching from right : innerjoin + left remaining
right : all from right, matching from left : innerjoin + right remaining
full : innerjoin + left remaining + right remaining
cross : TAB1 * TAB2
left outer : only left remove common
right outer : only right remove common
---------------------
innerjoin|TAB1 |TAB2|
---------|-----|----| inner = 8
 2 |1 |1 | left = inner_join + left rem = 8+3 = 11
 2 |1 |1 | right = inner_join + right rem = 8+2 = 10
 2 |1 |2 | full = inner + left rem + right rem = 8+3+2 = 13
 2 |2 |2 | cross = 7*6 = 42
 |3 |4 |
 |3 |NULL|
 |3 | |
---------------------
total = 8
*/
delete duplicates in table /*
1) using rowid and group by
delete FROM employee where rowid not in --- only delete duplicate
(select max(rowid) from employee group by all columns); --- retain unique rows

2) using min max and subquery
delete from employee a where rowid >
(select min(rowid) from employee b where -- USING MIN
a.col1=b.col1
and a.col2=b.col2
and a.col3=b.col3);
delete from employee a where rowid <
(select max(rowid) from employee b where -- USING MAX
a.col1=b.col1
and a.col2=b.col2
and a.col3=b.col3);

3)using create distinct
create table temp_employee
as select distinct col1,col2,col3,col4 from employee;
drop table employee;
alter table temp_employee rename to employee;

4)using inner join
DELETE t1
FROM your_table t1
INNER JOIN your_table t2
ON t1.column_name = t2.column_name
WHERE t1.id > t2.id;

5)using group by
SELECT Name, Department, COUNT(*)
FROM Employee
GROUP BY Name, Department
HAVING COUNT(*) > 1;

6)with CTE and row_number
WITH CTE AS (
 SELECT EmployeeID, Name, Department,
 ROW_NUMBER() OVER (PARTITION BY Name, Department ORDER BY EmployeeID) AS RowNum
 FROM Employees
)
DELETE FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID FROM CTE WHERE RowNum > 1);
*/
select Nth salary/*
1)SELECT * FROM EMPLOYEE (
SELECT EMP_NAME,EMP_SAL,DENSE_RANK() OVER (ORDER BY EMP_SAL DESC) AS RANKING FROM EMPLOYEE ) WHERE RANKING = 3;

2) using max
select max(salary) from employee where salary <(select max(salary) from employee); -- 2nd highest
select max(salary) from employee where salary <( select max(salary) from employee where salary <(select max(salary) from employee)); -- 3rd highest

3)SELECT DISTINCT salary FROM employee ORDER BY salary DESC OFFSET 1 ROW FETCH NEXT 1 ROW ONLY; -- 2nd Highest Salary
SELECT DISTINCT salary FROM employee ORDER BY salary DESC OFFSET 2 ROW FETCH NEXT 1 ROW ONLY; -- 3rd Highest Salary

3) LIMIT clause
select distinct(salary) from employee order by salary desc limit 1,1 ; -- 2nd highest
select distinct(salary) from employee order by salary desc limit 2,1 ; -- 3rd highest*/
ACID - /*
Atomocity -Atomicity means a transaction is all-or-nothing either all its operations succeed, or none are applied. If any part fails, the entire transaction is rolled back to keep the database
consistent.
Consistency - Consistency in transactions means that the database must remain in a valid state before and after a transaction.
Isolation - Isolation ensures that transactions run independently without affecting each other. Changes made by one transaction are not visible to others until they are committed.
Durability - Durability ensures that once a transaction is committed, its changes are permanently saved, even if the system fails. The data is stored in non-volatile memory, so the database can recover to its last committed state without losing data.
*/
Transaction System/*
batch tranasction (payslip)
real time transaction process (RTLP) (video games)
online transaction process (OLTP) (flight booking, SWAN)
*/
INDEX - faster retieval, data integrity/*
CLUSTERED     : Auto created
NON CLUSTERED : Manually created
1) btree : primary key
2) bitmap : Age, sex
3) functin based: upper,lower
4) reverese key : salary,marks
5) composite

Index Scan
reading significant portion of index, ways the DB optimizer to fetch data while exec query reading index then whole table
1) Full scan index : where clause not used
2) Range scan : where cause used
3) unique scan : primary key
4) Fast full scan
5) skip scan : gender,email ( if gender is 'M' then skips 'F')

INDEX REBUILDING
recreating existing index to remove fragmentation, improve performance, reclaim unused space, compact index structure
why - frequest delete / update, bulk data loads, row movement, table truncation , index become unbalanced

ALTER INDEX ( INDEX_NAME) REBUILD;

*/
WHERE | Having/*
filters rows | filters groups
before group | after group
select stmt  | aggregate function
*/
/*Replace : word by word : hello nitesh -> replace(nitesh,sir) -> hello sir
translate : character by character : hello abc -> translate(abc,123) -> hello 123
*/
NVL : replaces null value with result/*
NVL(A,B) > A
NVL(Null,B) > B
NVL(Null,Null) > NULL
NVL2(A,B,C) > B
NVL2(Null,B,C) > C
NVL2(A,Null,C) > Null
NVL2(Null,B,Null) > Null
NULLIF(A,A) > NULL
NULLIF(A,B) > A
NULLIF(Null,B) > err
NULLIF(A,null) > A
COALESCE(A,B,C,D,E) > A
COALESCE(null,B,C,D,E) > B
COALESCE(null,null,null,null,E) > E
*/
conditions/*
if-then-else-else if-end if
case end case
loops: simple,while,for,nested
control statement : exit,continue,go to
*/
Exception : Error condition during execution/*
1)system defined
		no_data_found
		too_many_rows
		invalid_number
		invalid_cursor
		dup_val_on_index
		case_not_found
		access_into_nullno_data_found
		too_many_rows
		invalid_number
		invalid_cursor
		dup_val_on_index    < UNIQUE EXCEPTION
		case_not_found
		access_into_null
2)user defined 

*/
Pragma exception_init/*
tells compiler to associate declared exception name to error number
exception_name EXCEPTION;
Pragma exception_init (exception_name , -02292)
*/
PRAGMA AUTONOMOUS_TRANSACTION /*
Declares a PL/SQL unit (procedure/function/trigger) as an autonomous transaction, meaning it runs in its own independent transaction separate from the caller.
It can COMMIT/ROLLBACK without affecting the caller’s transaction.
Often used for auditing, logging errors, or side‑effect operations that must persist even if the caller fails.
CREATE OR REPLACE PROCEDURE log_event(p_msg VARCHAR2) IS
 PRAGMA AUTONOMOUS_TRANSACTION; -- declares this unit autonomous
BEGIN
 INSERT INTO app_log(event_time, message)
 VALUES (SYSTIMESTAMP, p_msg);
 COMMIT; -- required to persist changes; autonomous units do NOT inherit caller’s commit
EXCEPTION
 WHEN OTHERS THEN
 -- Optional: ensure no locks are left hanging
 ROLLBACK;
END;
Error logging inside exception handlers
Audit trail recording regardless of caller outcome
Security checks that write to an audit table
Lightweight notifications (e.g., enqueue) that must survive caller rollback
*/
EXECUTE IMMEDIATE (Native Dynamic SQL) /*
Required for:
Dynamic table/column names
DDL statements (CREATE/ALTER/DROP)
ALTER SESSION, GRANT etc.
Queries whose SELECT list or WHERE clause is not known until runtime
EXECUTE IMMEDIATE
 'UPDATE employees SET salary = salary * :1 WHERE deptno = :2'
USING 1.10, 10; -- bind variables to avoid SQL injection & hard parse
DECLARE
 v_new_id NUMBER;
BEGIN
 EXECUTE IMMEDIATE
 'INSERT INTO orders(order_id, amount) VALUES(:1, :2) RETURNING order_id INTO :3'
 USING 1001, 500.00 RETURNING INTO v_new_id;
END;
DECLARE
 v_increase NUMBER := 0.05;
 v_dept NUMBER := 20;
BEGIN
 EXECUTE IMMEDIATE
 'UPDATE employees SET salary = salary * (1 + :inc) WHERE deptno = :dept'
 USING v_increase, v_dept;
END;
DECLARE
 v_sql VARCHAR2(4000);
 v_name employees.ename%TYPE;
 v_sal employees.sal%TYPE;
BEGIN
 v_sql := 'SELECT ename, sal FROM employees WHERE empno = :x';
 EXECUTE IMMEDIATE v_sql INTO v_name, v_sal USING 7369;
END;
*/
Cursors - Holds the data returned by SQL statement/*
implicit : Auto created
explicit : User Defined

Cursors attributes
%found, %notfound ,%rowcount, %isclose ,%isopen

%rowtype - for all column
%type - for selected column
*/
REF_CURSOR - acts as pointer to a query result set, /*
 allowing dynamic and flexible handling of query statement,
associate query while opening cursor
Declare
 type ref_cursor_type is REF_CURSOR;
 rc_ref_cur_list ref_cursor_type;
 v_name varchar2(10);
 v_id number(10);
begin
 open rc_ref_cur_list for (select query);
 fetch rc_ref_cur_list into vname;
 close rc_ref_cur_list;

 (close then open for new query)
end;
STRONGLY TYPED REF CURSOR (must return assigned return)
DECLARE
TYPE customer_t IS REF CURSOR RETURN customers%ROWTYPE;
c_customer customer_t;

WEAKLY TYPED REF CURSOR (must not return)
DECLARE
 TYPE customer_t IS REF CURSOR;
 c_customer customer_t;
*/
SYS REF CURSOR - weakly-typed cursor in Oracle that allows developers to return query results/*
It is used when the structure of the result set is not fixed or known in advance.
declare
 cur_value SYS_REFCURSOR;
 v_name employee.employeename%type;
 v_id employee.employeeid%type;
begin
 open cur_value for (select query);
 fetch cur_value into v_name,v_id;
 close cur_value;
end;
*/
Sequence : DB objet to create unique numbers , generation of primanry key, cntl_lockseq/*
create sequence seq_name
start with 1
increment by 1
(MINVALUE 10 | NOMINVALUE )
(MAXVALUE 100 | NOMAXVALUE )
(CYCLE | NOCYCLE )
(CACHE 2 | NOCACHE );

	seq_name.nextval
	seq_name.currval
*/
Record : Way to store and access values as group/*
1) Table based : (table_name%rowtype )
		DECLARE
			TYPE emp_rec_type IS RECORD (emp_id employees.emp_id%TYPE,
				                         emp_name employees.emp_name%TYPE,
				                         salary employees.salary%TYPE);
		TYPE emp_table_type IS TABLE OF emp_rec_type;
		emp_table emp_table_type;
		BEGIN
			-- Bulk collect multiple rows into table
			SELECT emp_id, emp_name, salary	BULK COLLECT INTO emp_table	FROM employees WHERE salary > 30000;

			-- Loop through collection
			FOR i IN 1 .. emp_table.COUNT LOOP
				DBMS_OUTPUT.PUT_LINE(emp_table(i).emp_name || ' - ' || emp_table(i).salary);
			END LOOP;
		END;
	
2) cursor based :
		DECLARE
			CURSOR emp_cur IS SELECT emp_id, emp_name, salary FROM employees WHERE salary > 45000;
			cursor_emp emp_cur%ROWTYPE;
		BEGIN
			OPEN emp_cur;
            DBMS_OUTPUT.PUT_LINE('---Cursor-Based Records---');
			LOOP
				FETCH emp_cur INTO cursor_emp;     -- Fetch row into record
				EXIT WHEN emp_cur%NOTFOUND;        -- Exit when no more rows

				DBMS_OUTPUT.PUT_LINE(cursor_emp.emp_id || ' - ' ||cursor_emp.emp_name || ' - ' ||cursor_emp.salary);
			END LOOP;
            CLOSE emp_cur;
		END;

3) Programmer defined
		DECLARE
			TYPE emp_record_type IS RECORD (emp_id employees.emp_id%TYPE,
											emp_name employees.emp_name%TYPE,
											salary employees.salary%TYPE);
			emp_rec emp_record_type;
		BEGIN
			-- Fetch a row from employees table
			SELECT emp_id, emp_name, salary
			INTO emp_rec
			FROM employees
			WHERE emp_id = 101;

			DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_rec.emp_name);
		END;
*/
FUNCTION /*
CREATE OR REPLACE function cal_tot_sal(
 p_emp_id IN empy.employee_id%type,
 p_increment IN NUMBER DEFAULT 0.10 )
RETURN NUMBER is
 v_sal empy.salary%type;
 v_tot_salary empy.salary%type;
Begin
 select salary into v_sal from empy
 where Employee_ID = p_emp_id;
 if v_sal is NOT NULL then
 v_tot_salary := v_sal * ( 1 + p_increment );
RETURN v_tot_salary;
 end if;
Exception
 WHEN no_data_found then
 DBMS_OUTPUT.put_line('NO data found for emp : ' || p_emp_id );
 WHEN Others then
 DBMS_OUTPUT.put_line('err occured for emp : ' || p_emp_id );
END as cal_tot_sal ;
*/
PROCEDURE /*
CREATE OR REPLACE PROCEDURE print_contact(
in_customer_id NUMBER
)
IS
r_contact contacts%ROWTYPE;
BEGIN
-- get contact based on customer id
SELECT * INTO r_contact FROM contacts WHERE customer_id = p_customer_id;
-- print out contact's information
dbms_output.put_line( r_contact.first_name || ' ' ||r_contact.last_name || '<' || r_contact.email ||'>' );
EXCEPTION
WHEN OTHERS THEN
 dbms_output.put_line( SQLERRM );
END;
*/
TRIGGER/*
plsql program that get Automatically invoked when event is occured
used : auditing,logging,enforce security, data replication, prevent invalid data
max 12 trigger can be created on a table.

Before trigger – Executes before the event.
After trigger – Executes after the event.
Instead of trigger – Used with views.
Row-level trigger – Executes for each row affected.
Statement-level trigger – Executes once per statement.

Row level triggers and Statement level triggers
Before and After
Insert and Delete and Update
2*2*3=12 triggers can be applied on a table

CREATE OR REPLACE TRIGGER customers_audit_trg
 AFTER
 UPDATE OR DELETE
 ON customers
 FOR EACH ROW
DECLARE
 l_transaction VARCHAR2(10);
BEGIN
 -- determine the transaction type
 l_transaction := CASE
 WHEN UPDATING THEN 'UPDATE'
 WHEN DELETING THEN 'DELETE'
 END;
 -- insert a row into the audit table
 INSERT INTO audits (table_name, transaction_name, by_user, transaction_date) VALUES('CUSTOMERS', l_transaction, USER, SYSDATE);
END;
/
*/
INSTEAD OF TRIGGER /*
An INSTEAD OF trigger fires in place of an INSERT, UPDATE, or DELETE on a view.
It allows you to modify underlying base tables through a view that would otherwise be read-only.

CREATE OR REPLACE TRIGGER new_customer_trg
 INSTEAD OF INSERT ON vw_customers
 FOR EACH ROW
DECLARE
 l_customer_id NUMBER;
BEGIN
 -- insert a new customer first
INSERT INTO customers(name, address, website, credit_limit) VALUES(:NEW.NAME, :NEW.address, :NEW.website, :NEW.credit_limit)
 RETURNING customer_id INTO l_customer_id
 -- insert the contract
INSERT INTO contacts(first_name, last_name, email, phone, customer_id) VALUES(:NEW.first_name, :NEW.last_name, :NEW.email, :NEW.phone, l_customer_id);
END;
*/
BULK COLLECT/*
Context SWITCH - poor performance
binding all data and return to PLSQL at once - Bulk processing
Save Exception to save all exception
SQL%BULL_EXCEPTIONS.count
SQLERRM
for > loops > iterative
forall > loads > declarative
	DECLARE
	 TYPE ins_name IS TABLE of insurers.insurer_name%type; --NESTED TABLE
	 v_ins_name    ins_name;
	BEGIN
	 select insurer_name,insurer_id BULK collect into v_ins_name from insurers; -- BULK COLLECT
	 for i in 1..v_ins_name.COUNT
	 LOOP
		dbms_output.put_line('Name of Insurer is :' || v_ins_name(i));
	 END LOOP;
	END;

	DECLARE
	 TYPE insurer_rec IS RECORD ( insurer_name insurers.insurer_name%TYPE,
	                              insurer_id insurers.insurer_id%TYPE);
	 TYPE insurer_tab IS TABLE OF insurer_rec;
	 v_insurers insurer_tab;
	BEGIN
	 SELECT insurer_name, insurer_id BULK COLLECT INTO v_insurers FROM insurers;
	 FOR i IN 1 .. v_insurers.COUNT 
	 LOOP
		DBMS_OUTPUT.PUT_LINE('Name of Insurer is: ' || v_insurers(i).insurer_name || ' and ID: ' || v_insurers(i).insurer_id);
	 END LOOP;
	END;
*/
BULK EXCEPTION/*
	declare
		cursor c_emp is 
			select id,sal from empy where rownum <= 500;
		type emp_tab is TABLE OF c_emp%rowtype;
		v_emp_data emp_tab;
	Begin
		open c_emp;
		fetch c_emp bulk collect into v_emp_data;
		close c_emp;

		for i in 1..v_emp_data.COUNT SAVE EXCEPTIONS
		 INSERT INTO empy_target(id,sal) values ( v_emp_data(i).id,v_emp_data(i).sal);
		 
	Exception
		WHEN OTHERS then
		IF SQLCODE = -24381 then
			for j in 1..SQL%BULK_EXCEPTIONS.count
			Loop
			   DBMS_OUTPUT.put_line('Érror '|| SQL%BULK_EXCEPTIONS(j).ERROR_INDEX || 'error_code' || SQL%BULK_EXCEPTIONS(j).ERROR_CODE );
			END loop;
		ELSE
			DBMS_OUTPUT.put_line('Érror '|| SQLERRM );
		END IF;
	END;
*/
COLLECTION /*
1)associative array
		DECLARE
		 TYPE t_capital_type IS TABLE OF VARCHAR2(100)
		 INDEX BY VARCHAR2(50);

		 t_capital t_capital_type;

		 l_country VARCHAR2(50);
		BEGIN
		 t_capital('USA') := 'Washington, D.C.';
		 t_capital('United Kingdom') := 'London';
		 t_capital('Japan') := 'Tokyo';
		 l_country := t_capital.FIRST;
		 WHILE l_country IS NOT NULL
			 LOOP
			 dbms_output.put_line('The capital of ' ||
			 l_country || ' is ' || t_capital(l_country));
			 l_country := t_capital.NEXT(l_country);
			 END LOOP;
		END;
		/
2)NESTED TABLE
		DECLARE
		 CURSOR c_customer IS SELECT name FROM customers
		                      ORDER BY name FETCH FIRST 10 ROWS ONLY;
		 TYPE t_customer_name_type IS TABLE OF customers.name%TYPE;
		 t_customer_names t_customer_name_type := t_customer_name_type();
		BEGIN
		 FOR r_customer IN c_customer
		 LOOP
			 t_customer_names.EXTEND;
			 t_customer_names(t_customer_names.LAST) := r_customer.name;
		 END LOOP;
		 FOR l_index IN t_customer_names.FIRST..t_customer_names.LAST
		 LOOP 
		     dbms_output.put_line(t_customer_names(l_index));
		 END LOOP;
		END;
3)VARRAY
		DECLARE
		 TYPE t_name_type IS VARRAY(2) OF VARCHAR2(20) NOT NULL;
		 t_names t_name_type := t_name_type('John','Jane');
		 t_enames t_name_type := t_name_type();
		BEGIN
		 dbms_output.put_line("The number of elements in t_enames " || t_enames.COUNT);
		 dbms_output.put_line("The number of elements in t_names " || t_names.COUNT);
		END;
		
ODCIVARCHAR2LIST is a nested table type defined in the SYS schema.
SYS.ODCIVARCHAR2LIST <-----> (equivalent to ) TABLE OF VARCHAR2(4000)
ODCI → Oracle Data Cartridge Interface
VARCHAR2 → Oracle string data type
LIST → A collection (nested table) of values
/
*/
COLLECTION METHOD /*
EXISTS COUNT LIMIT FIRST LAST
PRIOR NEXT EXTEND DELETE TRIM
*/
VIEW                                               | MATERILIZED VIEW /*
no data store                                      | stores physical data & updates periodacally
actual data comes from baseline tables             | Data Delayed
if data deletes in baseline then removed from view | Data comes from view
no refresh needed                                  | Manual refresh needed ( exec dbms_mview.refresh(view_name))
no STORAGE                                         | need STORAGE
Space not required                                 | Needs Space

CREATE MATERIALIZED VIEW view-name
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;

EXEC DBMS_MVIEW.refresh('EMP_MV');

types of view ----------------
View Type	        Base Tables	        Updatable	                Physical Data Stored?	Usage
Simple View	        Single	            Yes	                        No	                    Column/row restriction
Complex View	    Multiple	        No(use INSTEAD OF trigger)	No	                    Reporting, joins, aggregates
Inline View	        Temporary subquery	N/A	                        No	                    Query simplification
Materialized View	Single/Multiple	    No	                        Yes	                    Performance, summary/ETL

INLINE view 
SELECT columns FROM (SELECT columns FROM table WHERE conditions ) alias_name WHERE outer_conditions;

*/
CTE /*
temporary result that created within single query, same as view but not stored.
Recursive means can call themselves.
can consume memory
WITH DEPTAVGSAL AS (SELECT DEPT,AVG(SAL) AS AVGSAL FROM EMPLOYEES GROUP BY DEPT)
SELECT E.EMPLOYEE,E.NAME,E.DEPT,E.SAL FROM EMPLOYEE E INNER JOIN DEPTAVGSAL D ON E.DEPT=D.DEPT WHERE E.SAL > D.SAL; -- TO GET SALARY ABOVE DEPT AVG
*/
GLOBAL / TEMPORARY TABLE /*
LOCAL
GLOBAL
PRIVATE
*/
/*MERGE
DECLARE
 v_batch_size PLS_INTEGER := 500; -- set to 100 or 500
 v_start PLS_INTEGER := 1;
 v_end PLS_INTEGER;
 v_total PLS_INTEGER;
BEGIN
 SELECT COUNT(*) INTO v_total FROM <source_table>; -- Count total rows in source snapshot
 WHILE v_start <= v_total LOOP
 v_end := v_start + v_batch_size - 1;
 BEGIN
 MERGE INTO <target_table> tgt
 USING (
 SELECT *
 FROM (
 SELECT s.*, ROW_NUMBER() OVER (ORDER BY s.<key_col>) AS rn
 FROM <source_table> s
 -- Optional filter: WHERE s.<some_flag> = 1
 )
 WHERE rn BETWEEN v_start AND v_end
 ) src
 ON (tgt.<key_col> = src.<key_col>)
 WHEN MATCHED THEN
 UPDATE SET
 tgt.<col1> = src.<col1>,
 tgt.<col2> = src.<col2>
 -- etc.
 WHEN NOT MATCHED THEN
 INSERT (<key_col>, <col1>, <col2>)
 VALUES (src.<key_col>, src.<col1>, src.<col2>);
 COMMIT; -- commit after each batch
 EXCEPTION
 WHEN OTHERS THEN
 ROLLBACK;
 RAISE; -- bubble up the error
 END;
 v_start := v_end + 1;
 END LOOP;
END;
*/
/*SQL Loader
Reads an external data file (CSV),
Uses a control file to define how to load it,
Generates a log, plus bad and discard files,
Ensures the target table is empty before loading,

LOAD DATA
INFILE 'employees.csv'
BADFILE 'emp_bad.bad'
DISCARDFILE 'emp_discard.dsc'
LOG 'emp_load.log'
-- Skip first row (header)
SKIP 1
-- Allow up to 100 errors before aborting
ERRORS 100
-- Fields are comma-separated
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
 emp_id,
 emp_name,
 salary,
 dept_id
)

sqlldr username/password@DB control=emp_load.ctl rows=1000

SKIP=1 assumes your first row in the data file is a header: col1,col2,col3.
ERRORS=0 makes the load strict—fail fast on any bad record (good for quality gates).
BADFILE collects rows that violate data type or constraints (e.g., col3 not a valid date).
DISCARDFILE collects rows filtered out by WHEN clauses (if you use one).
TRAILING NULLCOLS prevents errors when the last columns are missing; they’ll be NULL.
Use OPTIONALLY ENCLOSED BY '"' for proper CSV handling when values contain commas.
sqlldr username/username@orcl control=cntl_file_name.ctl
*/
/*Query Performance
Minimize use of Wildcards (%)
Provide Proper Indexes
Use Proper Datatypes
Avoid Unnecessary Subqueries /use joins
Use LIMIT / ROWNUM / FETCH FIRST
Avoid SELECT *
Use EXISTS instead of IN - EXISTS stops searching once a match is found
Use GROUP BY Only When Needed
Use Stored Procedures - Precompiled execution,Reduced network round‑trips
Use Hints (Only When Required) SELECT /+ INDEX(emp idx_emp_deptno) / FROM emp; 
Gather Statistics using DBMS_STATS
		BEGIN
			DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCOTT',
										  tabname => 'EMP',
										  cascade => TRUE);
        END;
execution PLAN ( v$PLAN) /*
EXPLAIN PLAN FOR
	SELECT * FROM emp WHERE deptno = 10;
	SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
SQL_TRACE -  performance diagnostic feature to capture execution stat for SQL/PLSQL
	alter session set sql_trace = TRUE;
	 RUN QUERY
	alter session set sql_trace = FALSE;
*/
PROCEDURE OPTIMIZATION/*
optimize sql first
avoid context switching ( bulk collect )
use forall for bulk dml   
avoid * in sqluse proper datatypes %type, %rowtype
reduce exception overhead ( assigning anything in exception like flags which can be assigned as default 'N' while data not present or use NVL
USE exists instead of count(*)
optimize loops ( i.FIRST..i.LAST)
avoid dynamic SQL unless necessary
DBMS_profiler ( tells which code executes more often and take most of the time )
DBMS_utility.gettime ( elapsed time in 100 of second)
*/
Partitioning /*
Partitioning is a database feature that divides a large table (or index) into smaller, manageable pieces called partitions, based on a key column (such as date, number, or list values),
while appearing as one logical table to users.
Range Partitioning (Most Common) : Data is continuous (dates, numeric ranges)
	CREATE TABLE sales (
	 sale_id NUMBER,
	 sale_date DATE,
	 amount NUMBER
	)
	PARTITION BY RANGE (sale_date) (
	 PARTITION p_2024 VALUES LESS THAN (DATE '2025-01-01'),
	 PARTITION p_2025 VALUES LESS THAN (DATE '2026-01-01'),
	 PARTITION p_max VALUES LESS THAN (MAXVALUE)
	);
List Partitioning : Discrete values (country, region, status)
	CREATE TABLE customers (
	 cust_id NUMBER,
	 country VARCHAR2(20)
	)
	PARTITION BY LIST (country) (
	 PARTITION p_india VALUES ('INDIA'),
	 PARTITION p_usa VALUES ('USA'),
	 PARTITION p_other VALUES (DEFAULT)
	);
	Hash Partitioning
	CREATE TABLE orders (
	 order_id NUMBER,
	 order_date DATE
	)
	PARTITION BY HASH (order_id)
	PARTITIONS 4;
Composite Partitioning
	PARTITION BY RANGE (order_date)
	SUBPARTITION BY HASH (order_id)
	PARTITION BY RANGE (order_date)
	SUBPARTITION BY LIST (region)
	ALTER TABLE sales
	ADD PARTITION p_2026 VALUES LESS THAN (DATE '2027-01-01');
*/
SDLC Phases in PL/SQL /*
Requirement Analysis
Design
Development (Coding)
Testing
Deployment
Maintenance & Support
*/
Temporary Tables (Oracle Global Temporary Tables – GTT) /*
What is a Temporary Table?
A Global Temporary Table (GTT) is a table whose definition is permanent, but data is temporary and session‑specific or transaction‑specific.
CREATE GLOBAL TEMPORARY TABLE temp_txn (
 emp_id NUMBER,
 salary NUMBER
)
ON COMMIT DELETE ROWS;
CREATE GLOBAL TEMPORARY TABLE temp_txn (
 emp_id NUMBER,
 salary NUMBER
)
ON COMMIT DELETE ROWS;
CREATE OR REPLACE PROCEDURE process_salary IS
BEGIN
 INSERT INTO temp_session
 SELECT emp_id, salary FROM employees WHERE deptno = 10;
 FOR rec IN (SELECT * FROM temp_session) LOOP
 DBMS_OUTPUT.PUT_LINE(rec.emp_id || ' - ' || rec.salary);
 END LOOP;
END;
/
*/
ARCHIVAL /*
archival policy defines how old or unused data is moved from active systems to long term storage while ensuring
1) data availabilty
2) compliance with business & legal requirements
3) optional database performance

1) data archival - ( old tranactions, logs)
2) backup archival - ( daily , weekly, monthly backup)
3) archival redo - ( redo logs)

insert into boct_arch_2024 select * from boct where tran_date < ADD_MONTHS( SYSDATE,-24);
delete from boct where  tran_date < ADD_MONTHS( SYSDATE,-24);
commit;
*/
PURGING /*
permanently deleting data 

automation
Begin
dbms_schedular.createjob(job_name => 'PURGE_AUTO_LOG',
						 job_type => 'PLSQL_BLOCK',
						 job_action => 'begin purge_audit_data; end;',
						 start_date => SYSDATE,
						 repeat_interval => 'FREQ=DAILY/MONTHLY/WEEKLY/QUARTERLY,YEARLY',
						 enabled => TRUE );
END;
*/
/*ERD -  Entity-Relationship Diagram
visual representation of Entities (tables),Attributes (columns) and Relationships (foreign keys) (1-1)(1-M)(M-M)

Entities → Tables
Attributes → Columns
Primary Key → PRIMARY KEY
Relationships → FOREIGN KEY
Many-to-Many → Use Junction Table
Optional relationships → NULL allowed in FK
Use constraints names (CONSTRAINT fk_name) for clarity

Go to Tools → Data Modeler → Import → Data Dictionary
Select your database connection
Choose the schema you want to import
Select tables to include in the ERD
Click Next → Finish

Reverse engineering in SQL Developer is the process of importing existing database objects 
(tables, columns, keys, indexes, relationships) into a Data Modeler ERD.

Get all tables
Get columns & data types
Get PKs & FKs
Feed this into diagramming tools (like draw.io, Lucidchart, or SQL Developer) to draw the ERD.

*/
ROW LOCKING /*
Basic Row Lock: FOR UPDATE
	SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE;
FOR UPDATE NOWAIT 
  Attempts to lock the row immediately.
  If the row is already locked, Oracle raises an error instead of waiting.
  SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE NOWAIT;
FOR UPDATE WAIT n
  Attempts to lock the row, waits up to n seconds if locked.
  If row is still locked after n seconds, raises ORA-00054.
  SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE WAIT 10;
FOR UPDATE SKIP LOCKED
  Locks rows that are not already locked.
  Rows that are locked by other sessions are skipped.
  Useful for queue processing, where multiple sessions process rows concurrently.
  SELECT * FROM employees WHERE emp_id = 101 FOR UPDATE SKIP LOCKED;
  
What is MVCC
MVCC = Multiversion Concurrency Control
Oracle uses MVCC to allow multiple transactions to access the same data simultaneously without blocking reads.
Readers never block writers, writers never block readers (except explicit row locks).
MVCC is implemented using undo segments (rollback segments).

How MVCC Works
Each transaction sees a consistent snapshot of the database at the start of the transaction.
When a row is updated, Oracle:
Creates a new version of the row in the data block
Stores old version in undo tablespace
Other transactions continue to see the old version, ensuring consistent reads.

*/
