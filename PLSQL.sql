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
Operators/*
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
SQL | PLQSL/*
single query DML/DDL operations | block of codes(proc,pkg,funct,triggers,seq)
exec as single statement | exec as block
no error handling | error handling available
no condition check | condition check
*/
DELETE | TRUNCATE/*
DML | DDL
commit needed | auto commit
where condition needed | no where condition
slower due to undo | faster
triggers fired | no trgiggers fired
space not removed | space removed
on delete cascade | truncate cascade
*/
/*CASE | DECODE
SQL/PLSQL used | used in SQL
complex logic | simple logic
SELECT OrderID, Quantity, |
CASE |
WHEN Quantity > 30 THEN 'The quantity is greater than 30' |SELECT DECODE(1, 1, 'Equal', 'Not Equal')
WHEN Quantity = 30 THEN 'The quantity is 30' |AS result FROM dual;
ELSE 'The quantity is under 30' |
END AS QuantityText |
FROM OrderDetails; |
Multiple condition check |equality check
easier to maintain |harder to maintain
slower |faster
*/
JOINS /*
union : removes duplicates
union all : no duplicates removed
intersect : common data and sort
minus : data from A ,common removed
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

3) LIMIT clause
select distinct(salary) from employee order by salary desc limit 1,1 ; -- 2nd highest
select distinct(salary) from employee order by salary desc limit 2,1 ; -- 3rd highest*/
ACID - /*
Atomocity
Atomicity means a transaction is all-or-nothing either all its operations succeed, or none are applied. If any part fails, the entire transaction is rolled back to keep the database
consistent.
Consistency
Consistency in transactions means that the database must remain in a valid state before and after a transaction.
Isolation
Isolation ensures that transactions run independently without affecting each other. Changes made by one transaction are not visible to others until they are committed.
Durability
Durability ensures that once a transaction is committed, its changes are permanently saved, even if the system fails. The data is stored in non-volatile memory, so the database can
recover to its last committed state without losing data.
*/
Transaction System/*
batch tranasction (payslip)
real time transaction process (RTLP) (video games)
online transaction process (OLTP) (flight booking, SWAN)
*/
INDEX - faster retieval, data integrity/*
CLUSTERED : Auto created
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
*/
WHERE | Having/*
filters rows | filters groups
before group | after group
select stmt | aggregate function
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
2)user defined
no_data_found
too_many_rows
invalid_number
invalid_cursor
dup_val_on_index
case_not_found
access_into_null
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
increment with 1
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
r_person persons%ROWTYPE;
BEGIN
-- get person data of person id 1
SELECT * INTO r_person
FROM persons
WHERE person_id = 1
-- change the person's last name
r_person.last_name := 'Smith';
-- update the person
UPDATE persons
SET ROW = r_person
WHERE person_id = r_person.person_id;
END;
2) cusrosr based :
CURSOR cursor_name IS SELECT ...;
record_name cursor_name%ROWTYPE;
CURSOR c_product
IS
 SELECT
 product_name, list_price
 FROM
 products
 ORDER BY
 list_price DESC;
BEGIN
FOR r_product IN c_product
LOOP
 dbms_output.put_line( r_product.product_name || ': $' || r_product.list_price );
END LOOP;
END;
3) Programmer defined
 type (type_name) is record
 datatypes
 cursor_name (type_name)

 -- Define a record type
TYPE employee_record_type IS RECORD (
emp_id NUMBER,
emp_name VARCHAR2(100));
-- Declare a record variable
emp_rec employee_record_type;
DECLARE
r_person persons%ROWTYPE;
BEGIN
-- get person data of person id 1
SELECT * INTO r_person
FROM persons
WHERE person_id = 1
-- change the person's last name
r_person.last_name := 'Smith';
-- update the person
UPDATE persons
SET ROW = r_person
WHERE person_id = r_person.person_id;
END;
DECLARE
 TYPE address IS RECORD (
 street_name VARCHAR2(255),
 city VARCHAR2(100),
 state VARCHAR2(100),
 postal_code VARCHAR(10),
 country VARCHAR2(100)
);
TYPE customer IS RECORD(
 customer_name VARCHAR2(100),
 ship_to address,
 bill_to address
);
r_one_time_customer customer;
BEGIN
r_one_time_customer.customer_name := 'John Doe';
-- assign address
r_one_time_customer.ship_to.street_name := '4000 North 1st street';
r_one_time_customer.ship_to.city := 'San Jose';
r_one_time_customer.ship_to.state := 'CA';
r_one_time_customer.ship_to.postal_code := '95134';
r_one_time_customer.ship_to.country := 'USA';
-- bill-to address is same as ship-to address
r_one_time_customer.bill_to := one_time_customer.ship_to;
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
Row level triggers and Statement level triggers
Before and After
Insert and Delete and Update
2*2*3=12
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
 v_ins_name ins_name;
BEGIN
 select insurer_name,insurer_id BULK collect into v_ins_name from insurers; -- BULK COLLECT
 for i in 1..v_ins_name.COUNT
 LOOP
 dbms_output.put_line('Name of Insurer is :' || v_ins_name(i));
 END LOOP;
END;
/
DECLARE
 TYPE insurer_rec IS RECORD ( --Programmer Based RECORD
 insurer_name insurers.insurer_name%TYPE,
 insurer_id insurers.insurer_id%TYPE);
 TYPE insurer_tab IS TABLE OF insurer_rec; -- TYPE declare
 v_insurers insurer_tab;
BEGIN
 SELECT insurer_name, insurer_id BULK COLLECT INTO v_insurers FROM insurers;
 FOR i IN 1 .. v_insurers.COUNT LOOP
 DBMS_OUTPUT.PUT_LINE('Name of Insurer is: ' || v_insurers(i).insurer_name || ' and ID: ' || v_insurers(i).insurer_id);
 END LOOP;
END;
*/
COLLECTION /*
**associative array
DECLARE
 -- declare an associative array type
 TYPE t_capital_type
 IS TABLE OF VARCHAR2(100)
 INDEX BY VARCHAR2(50);
 -- declare a variable of the t_capital_type
 t_capital t_capital_type;
 -- local variable
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
**NESTED TABLE
DECLARE
 -- declare a cursor that return customer name
 CURSOR c_customer IS
 SELECT name FROM customers
 ORDER BY name FETCH FIRST 10 ROWS ONLY;
 -- declare a nested table type
 TYPE t_customer_name_type
IS TABLE OF customers.name%TYPE;
 -- declare and initialize a nested table variable
 t_customer_names t_customer_name_type := t_customer_name_type();
BEGIN
 -- populate customer names from a cursor
 FOR r_customer IN c_customer
 LOOP
 t_customer_names.EXTEND;
t_customer_names(t_customer_names.LAST) := r_customer.name;
 END LOOP;
 -- display customer names
 FOR l_index IN t_customer_names.FIRST..t_customer_names.LAST
 LOOP dbms_output.put_line(t_customer_names(l_index));
 END LOOP;
END;
**VARRAY
DECLARE
 TYPE t_name_type IS VARRAY(2)
 OF VARCHAR2(20) NOT NULL;
 t_names t_name_type := t_name_type('John','Jane');
 t_enames t_name_type := t_name_type();
BEGIN
 -- initialize to an empty array
 dbms_output.put_line("The number of elements in t_enames " || t_enames.COUNT);
 -- initialize to an array of a elements
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
VIEW | MATERILIZED VIEW /*
no data store | stores physical data & updates periodacally
actual data comes from baseline tables | Data Delayed
if data deletes in baseline then removed from view | Data comes from view
no refresh needed | Manual refresh needed ( exec dbms_mview.refresh(view_name))
no STORAGE | need STORAGE
Space not required | Needs Space
CREATE MATERIALIZED VIEW view-name
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE ]
ON [COMMIT | DEMAND ]
[[ENABLE | DISABLE] QUERY REWRITE]
AS
SELECT ...;
EXEC DBMS_MVIEW.refresh('EMP_MV');
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
/* SQL Loader
Reads an external data file (CSV),
Uses a control file to define how to load it,
Generates a log, plus bad and discard files,
Ensures the target table is empty before loading,
Uses SKIP=1 (skip header row) and ERRORS=0 (fail on first error).
If the table must be empty before loading, use TRUNCATE (fast) or REPLACE (delete all rows then load).
-- cntl_file_name.ctl
OPTIONS (
 SKIP = 1, -- Skip header row (first line in data file)
 ERRORS = 0 -- Stop immediately on the first error
)
LOAD DATA
-- Choose ONE of the following (uncomment the one you want):
-- INFILE 'data/filename.txt' -- single data file
-- INFILE 'data/filename.csv' -- if CSV extension
-- INFILE * -- if you plan to inline data in the ctl (not typical)
-- Empty the table before loading:
TRUNCATE
-- Alternatively:
-- REPLACE
-- Output files:
BADFILE 'out/filename.bad' -- rejected records (field/constraint errors)
DISCARDFILE 'out/filename.dsc' -- records that do not meet WHEN criteria (if used)
LOG 'out/filename.log' -- load log
-- Define how fields are parsed in the data file:
FIELDS TERMINATED BY ',' -- CSV
OPTIONALLY ENCLOSED BY '"' -- handle quoted strings like "text, with, commas"
TRAILING NULLCOLS -- missing fields become NULL
-- Target table:
INTO TABLE my_target_table
-- Optional record filter (example). If you use WHEN, unmatched rows go to the DISCARD file:
-- WHEN col1 != BLANKS
-- Column mapping and transformations:
(
 col1 INTEGER EXTERNAL, -- parse numeric from text (e.g., "123")
 col2 CHAR, -- simple text
 col3 DATE "YYYY-MM-DD" -- parse date from text format (e.g., 2025-12-31)
)
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
Use Hints (Only When Required)
Gather Statistics using DBMS_STATS
BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(
ownname => 'SCOTT',
tabname => 'EMP',
cascade => TRUE
 );
END;
SELECT /*+ INDEX(emp idx_emp_deptno) */ FROM emp; INDEXForce index usageNO_INDEXPrevent index usagePARALLELEnable parallel executionALL_ROWSOptimize forthroughputNO_MERGEPrevent view merging
execution PLAN ( v$PLAN) /*
EXPLAIN PLAN FOR
SELECT * FROM emp WHERE deptno = 10;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
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
