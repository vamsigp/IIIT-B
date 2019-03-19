select *
from employee;

select fname, lname
from employee;

select *
from employee
where sex='M' and salary>=30000;

select *
from employee
where sex='M' or salary>=30000;

select fname as "First Name", lname as "Last Name"
from employee;

-- 2. Retrieve the details of all dependents of essn 333445555
-- imp: if selection is of char type use => 'char_value'
select *
from dependent
where essn='333445555';

-- 3. Retrieve details of projects that are based out Houston or Stafford
select * 
from department 
where dnumber=1 or dnumber=4

-- 5. Display the name of the department and the year in which the manager
--    was appointed (Hint: Use the YEAR() function YEAR(mgr_start_date)