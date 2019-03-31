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
where dnumber=1 or dnumber=4;

-- 5. Display the name of the department and the year in which the manager
--    was appointed (Hint: Use the YEAR() function YEAR(mgr_start_date)


select ssn, salary, dno
from employee
where dno = 5
order by salary asc;

-- 14. Sort the works_on table based on Pno and Hours
select *
from works_on
order by Pno,Hours desc;


select dno, count(*) as 'Number of employees'
from employee
group by dno;

select dno, max(salary) as 'Max Salary of employees'
from employee
group by dno;

select dno, count(*) as 'Number of employees'
from employee
group by dno
order by dno;


select dno, sex, avg(salary)
from employee
where super_ssn = '333445555'
group by dno, sex;


select dno, sex, avg(salary), super_ssn
from employee
group by sex, super_ssn
order by avg(salary) desc;


-- 22. Display the number of male employees in each department
select dno, count(*)
from employee
where Sex ='M'
group by dno;