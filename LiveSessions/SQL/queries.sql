show tables in sys;

desc sys.customer1;

create table sys.customer1 
select * from sys.customer;

drop table if exists sys.customer1;
#truncate
truncate table sys.customer1 ;
select * from sys.customer1 ;

set sql_safe_updates=0;

delete from sys.customer1 where id=1;

drop table if exists sys.customer;
create table sys.customer1 (
ID INT NOT NULL,
FirstName Varchar(255),
LastName Varchar(255),
city varchar(255),
Country Varchar(255),
Phone Varchar(255));

INSERT INTO sys.Customer
VALUES(1,'Maria','Anders','Berlin','Germany','030-0074321');
INSERT INTO sys.Customer (Id,FirstName,LastName,City,Country,Phone)VALUES(2,'Ana','Trujillo','México D.F.','Mexico','(5) 555-4729');
INSERT INTO sys.Customer (Id,FirstName,LastName,City,Country,Phone)VALUES(3,'Antonio','Moreno','México D.F.','Mexico','(5) 555-3932');

#supplier data
create table sys.Supplier (
ID INT NOT NULL,
CompanyName Varchar(255),
ContactName Varchar(255),
city varchar(255),
Country Varchar(255),
Phone Varchar(255),
Fax Varchar(255));


INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(1,'Exotic Liquids','Charlotte Cooper','London','UK','(171) 555-2222',NULL);
INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(2,'New Orleans Cajun Delights','Shelley Burke','New Orleans','USA','(100) 555-4822',NULL);
INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(3,'Grandma Kelly''s Homestead','Regina Murphy','Ann Arbor','USA','(313) 555-5735','(313) 555-3349');

select distinct * from sys.supplier limit 10;

#product data
create table sys.Product (
ID INT NOT NULL,
ProductName Varchar(255),
SupplierId INT,
UnitPrice FLOAT,
Package Varchar(255),
IsDiscontinued INT
);


INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(1,'Chai',1,18.00,'10 boxes x 20 bags',0);
INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(2,'Chang',1,19.00,'24 - 12 oz bottles',0);
INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(3,'Aniseed Syrup',1,10.00,'12 - 550 ml bottles',0);

select * from sys.Product a inner join sys.supplier b on a.supplierid=b.id;

#order data
drop table if exists sys.order;
create table sys.order (
#Id,OrderDate,CustomerId,TotalAmount,OrderNumber
ID INT NOT NULL,
OrderDate varchar(255),
CustomerId INT,
TotalAmount FLOAT,
OrderNumber INT
);



INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(1,'Jul  4 2012 12:00:00:000AM',85,440.00,'542378');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(705,'Mar 16 2014 12:00:00:000AM',1,493.2,'543082');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(2,'Jul  5 2012 12:00:00:000AM',79,1863.40,'542379');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(3,'Jul  8 2012 12:00:00:000AM',34,1813.00,'542380');


#orderitem

drop table if exists sys.orderitem;
create table sys.orderitem (
#Id,OrderId,ProductId,UnitPrice,Quantity
ID INT NOT NULL,
OrderId INT,
ProductId INT,
UnitPrice FLOAT,
Quantity FLOAT
);

INSERT INTO sys.OrderItem (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(1,1,11,14.00,12);
INSERT INTO sys.OrderItem  (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(2,1,42,9.80,10);
INSERT INTO sys.OrderItem  (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(3,1,72,34.80,5);

show indexes from sys.order;

#top 10 rows in customer table
select * from sys.customer limit 10;
select * from sys.order limit 10;

#indexing...always first crete the index and then sub query
alter table sys.customer add index idx_id(id);
show index from sys.customer;
show index from sys.order;
alter table sys.order add index idx_order_id (id) ;
alter table sys.order add index idx_ordernumber (ordernumber) ;



select * from sys.order;


#having function
#number of orders createed by an individual customer and total amount proessed till date
select 
a.id,count(distinct b.id) as total_orders, sum(totalamount) as totalamount
 from sys.customer a inner join sys.order b on a.id=b.customerid
 #where count(distinct b.id)>10
 group by a.id
 #total_order>10
 having count(distinct b.id)>10
 ;

#sub-queries...
select * from 
(select 
a.id,count(distinct b.id) as total_orders, sum(totalamount) as totalamount
 from sys.customer a inner join sys.order b on a.id=b.customerid
 #where count(distinct b.id)>10
 group by a.id )  ordr_bk
 #total_order>10
 where ordr_bk.total_orders>10
 ;

#rank & dense_rank

select * from sys.order order by totalamount desc limit 3;

#rank..top 3 order in descending order

select * from
(select a.*,rank() over (order by totalamount desc) as ranking 
from sys.order a order by totalamount desc) a
where ranking<=3
;

#rank..all the customers who have ordered from my website and I want to see top 3 orders

select * from
(select a.*,rank() over (partition by customerid order by totalamount desc) as ranking 
from sys.order a order by customerid,totalamount desc) a 
where ranking<=3
;

#rank and dense_rank
select a.*,rank() over (partition by customerid order by totalamount desc) as ranking 
from sys.order a 
where customerid in (1,2)
order by customerid,totalamount desc
;

select * from sys.order where customerid in (1,2) order by customerid;

#join
#inner, left, right, full outer, cross join
select * from sys.customer limit 10;
select * from sys.order limit 10;
select * from sys.orderitem where orderid=54 limit 10;

#inner join
select a.id as cust_id,a.firstname,b.id as orderid,c.productid,unitprice*quantity as totalamountspent
from sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
inner join sys.order b on a.id=b.customerid 
#b.id i.e. orderid from order table is primary key whereas orderid in orderitem is foreign key
inner join sys.orderitem c on b.id=c.orderid
where a.id=86
;

#inner join ...2nd way...self join 
select a.id as cust_id,a.firstname,b.id as orderid,c.productid,unitprice*quantity as totalamountspent
from sys.customer a , sys.order b ,sys.orderitem c 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
where a.id=b.customerid and
#b.id i.e. orderid from order table is primary key whereas orderid in orderitem is foreign key
b.id=c.orderid
and a.id=86
;

#left join

select a.id as cust_id,a.firstname,b.id as orderid
from sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
left join sys.order b on a.id=b.customerid 
where b.customerid is null
;

#right join

select a.id as cust_id,a.firstname,b.id as orderid
from sys.order b
right join sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
on a.id=b.customerid 
where b.customerid is null
;

#cross join
select * from sys.customer a cross join sys.order b
on a.id=b.id;


select * from sys.customer where id=22;
select * from sys.order where customerid=22;






#CREATE INDEX id_index ON lookup (id) USING BTREE;