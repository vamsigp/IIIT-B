-- 0. Retrieve all rows and all columns of employee table
select *
from employee;

-- 0. Retrieve First name and last name of ALL employees
select fname as "First Name", lname as "Last Name"
from employee;



-- 1. Retrieve details of all male employees who draw a salary which is at least 30000
select *
from employee
where sex = 'M' and salary >= 30000;

-- 2. Retrieve the details of all dependents of essn 333445555
select *
from dependent
where essn = '333445555';

-- 3. Retrieve details of projects that are based out Houston or Stafford

-- 4. Retrieve details of projects that are based out Houston or belongs
--    to deptartment 4

-- 5. Display the name of the department and the year in which the manager
--    was appointed (Hint: Use the YEAR() function YEAR(mgr_start_date)
select dname, YEAR(mgr_start_date)
from department;

-- 6. Display the SSN of all employees who live in Houston
--    (Hint: use LIKE() function as in address LIKE '%Houston'
-- 6. Display employees whose name begins with J

select fname
from employee
where fname like 'J%';

-- 7. Display details of all (male employee who earn more than 30000) or female employees who earn less than 30000)

-- 8. Display the essn of employees who have worked betwen 25 and 50 hours
--      a) Use AND clause
--      b) use BETWEEN clause  as in Hours between 25 and 30

select essn, hours
from works_on
where hours >= 25 and hours <= 30;

select essn, hours
from works_on
where hours between 25 and 30;



-- 9. Display the names of projects that are based out of houston or stafford
--      a) Use OR clause
--      b) Use IN clause as in Plocation in ('Houston', 'Stafford')

select * from dept_locations
where dlocation in ('Houston','Stafford');

-- 10. Display the names of the project that are neither based out of houston nor out of stafford
--      a) Use AND/OR clause
--      b) use NOT IN clause as in Plocation NOT IN ('Houston','Stafford')


-- 11. Display the ssn and fully concatenated name of all employees
-- 	Use CONCAT function as in CONCAT(fname, ' ', minit, ' ', lname)


-- 12. Display the employee details who does not have supervisor
-- 	Use IS NULL as in super_ssn IS NULL

select * from employee where super_ssn is null;

-- 13. Display the ssn of employees sorted by their salary in ascending mode
-- 	Use ORDER by SALARY

select ssn, salary, dno
from employee
where dno = 5
order by salary asc;

-- 14. Sort the works_on table based on Pno and Hours



-- 15. Display the average project hours 

select avg(hours) as 'Average Hours'
from works_on;



-- 16. Display the number of employees who do not have a manager

select count(*)
from employee
where super_ssn IS NULL;

select count(super_ssn)
from employee;



-- 17. What is the average salary of employees who do not have a manager




-- 18. What is the highest salary of female employees



-- 19. What is the least salary of male employees



-- 20. Display the number of employees in each department

select dno, count(*) as 'Number of employees'
from employee
group by dno;





select dno, count(*) as 'Number of employees'
from employee
group by dno
order by dno;






-- 21. Display the average salary of employees (department-wise and gender-wise)
-- 	GROUP BY Dno, Sex

select dno, sex, avg(salary)
from employee
where super_ssn = '333445555'
group by dno, sex;


-- 22. Display the number of male employees in each department

-- 23. Display the average, minimum, maximum hours spent in each project

select pno, avg(hours), min(hours), max(hours)
from works_on
group by pno;


-- 24. Display the year-wise count of employees based on their year of birth

select year(bdate), count(*)
from employee
group by year(bdate)
order by year(bdate);

-- 25. Dipslay the number of projects each employee is working on

-- 26. Display the Dno of those departments that has at least 3 employees
select dno, count(*)
from employee
group by dno
having count(*) >= 3;






-- 27. Among the people who draw at least 30000 salary, what is the department-wise average?

select dno, avg(salary)
from employee
where salary >= 30000
group by dno;

-- 27b. Instead of dno, display dname
select dname, avg(salary) from employee inner join department on dno=dnumber where salary >= 30000 group by dname order by dname;

-- 28. Display the fname of employees working in the Research department
select fname
from employee
where dno = (select Dnumber from department where dname = 'Research')
order by fname;


-- 29. Display the fname and salary of employees whose salary is more than the average salary of all the employees
select fname, salary
from employee
where salary >= (select avg(salary) from employee);


-- 30. Which project(s) have the least number of employees?
select pno, count(*) numemps 
from works_on 
group by pno 
having numemps = 
	(select min(nemps) 
	from (
		select pno, count(*) nemps 
		from works_on group by pno
	     ) tempproj
	 );


-- 31. Display the fname of those employees who work for at least 20 hours

-- 32. What is the average salary of those employees who have at least one
--     dependent

-- JOIN Examples

select * 
from employee inner join department on employee.dno = department.dnumber;

select *
from employee e inner join department d on e.dno = d.dnumber;

select e.fname, e.lname, d.dname
from employee e inner join department d on e.dno = d.dnumber;




-- 33. Display the ssn, lname and the name of the department of all the employees
select ssn, lname, dname 
from employee inner join department on dno=dnumber 
order by ssn;



-- 34. Display the ssn, lname, name of project of all the employees

select e.ssn, e.lname, p.pname
from employee e inner join works_on w on e.ssn = w.essn 
	inner join project p on w.pno = p.pnumber;





-- 35a. Display the ssn, their department, the project they work on and
--     the name of the department which runs that project
-- 	Hint: Needs a 5 table join
-- 	Output heading: ssn, emp-dept-name, pname, proj-dept-no

select e.fname, ed.dname 'employee-department', p.pname, pd.dname
from employee e inner join department ed on e.dno=ed.dnumber
    inner join works_on w on w.essn = e.ssn
    inner join project p on w.pno = p.pnumber
	inner join department pd on p.dnum = pd.dnumber ;

-- 35b. Display the deptname, the project the department runs
-- 	Output heading: dept-name, pname



-- SOME COMPLICATED SQL Queries for Self-Study

-- 36. What is the name of the department that has least number of 
--     employees?

-- select dname 
-- from employee e, department d 
-- where e.dno=d.dnumber 
-- group by dno having count(ssn) =
--     (select min(mycount) 
--      from (select count(ssn) as mycount 
--            from employee
--            group by dno
--           ) mytable
--     );

-- 37. What is the name of the department whose employees have the highest
--     average salary?

-- 38. Display the fname of the employee along with the fname of the manager
-- 	select e.fname 'EmpName', m.fname 'MgrName'
-- 	from employee e, employee m
-- 	where e.super_ssn = m.ssn;

-- 39. Which employees work on projects belonging to departments other
--     than departments they belong to
-- 	Output: ssn, pname, emp-dept-name, proj-dept-name

-- select e.ssn, pname, ed.dname 'emp-dept-name', pd.dname 'project-dept-name' 
-- from employee e,  works_on w,  project p,  department ed,  department pd 
-- where e.ssn = w.essn 
-- 	and w.pno = p.pnumber 
-- 	and e.dno = ed.dnumber 
-- 	and p.dnum = pd.dnumber 
-- 	and e.dno <> p.dnum;
-- ==============================================

-- LEFT OUTER JOIN

-- Inner join between employee and dependent
select e.ssn, e.fname, d.dependent_name
from employee e inner join dependent d on e.ssn = d.essn;

-- Left Outer join between employee and dependent
select e.ssn, e.fname, d.dependent_name
from employee e left join dependent d on e.ssn = d.essn;

-- Right out joint between dependent and employee
select e.ssn, e.fname, d.dependent_name
from deparment d right join employee e on e.ssn = d.essn;
