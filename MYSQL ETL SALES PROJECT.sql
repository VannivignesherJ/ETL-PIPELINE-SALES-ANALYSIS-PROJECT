create database sales_Anlysis;
use sales_Anlysis;

create table product(
id INT PRIMARY KEY,
Name varchar(100),
category varchar(100),
Price decimal(10,2));

create table transcations(
t_id INT PRIMARY KEY,
cust_id INT,
store_id INT,
product_id INT,
FOREIGN KEY (product_id) references product(id),
quantity INT,
t_date DATE,
price decimal(10,2),
total decimal(10,2));


CREATE TABLE customers(
cust_id INT PRIMARY KEY,
Name varchar(100),
Email varchar(100),
location varchar(100),
sign_up_date DATE);

create table stores(
store_id INT primary key,
Store_name varchar(100),
city varchar(100),
opened_Date date);

create table inventory (
store_id Int,
foreign key (store_id) references stores(store_id),
product_id INT,
stocks INT,
last_restocked DATE);

create table returns(
return_id int primary key,
t_id int,
return_date DATE,
reasons varchar(100));

create table feedback(
feed_back_id INT primary key,
cust_id int,
product_id int,
ratints int,
comments varchar(1000),
feedback_date DATE);

#A) customer details:

select * from customers;

#Top 5 locations with most customers
select location ,count(cust_id) as cust_count from customers
group by location order by cust_count desc limit 5;

#customers who signed up earlier
select cust_id,sign_up_date from customers
order by sign_up_date asc limit 5;

# No of customers signed per year and Month
   select date_format(sign_up_date,'%m-%y') AS signup_month_year,
   count(cust_id) as total_customers from customers
   group by signup_month_year order by signup_month_year;
 
 # Acrive customers (made atleast ! transcation in last 3 months)
	select distinct c.cust_id,c.name from customers c 
    join transcations t on c.cust_id = t.cust_id
    where t.t_date>=curdate() -interval 90 day;
    
    #High value customers
	 select distinct c.cust_id,c.Name, t.total from customers c
     join transcations t on c.cust_id=t.cust_id
     having total >3500;
     
     #Inactive customers (No Transcation since last year)
     select distinct c.cust_id,c.Name from customers c 
     join transcations t on c.cust_id=t.cust_id
     where t.t_date>=curdate() -interval 1 year;
     
     #customers who puechase from more than 3 stores
      select c.cust_id,c.Name,count(distinct t.store_id ) As unique_Stores 
      from customers c join transcations t on c.cust_id=t.cust_id
      group by c.cust_id,c.name having unique_stores > 3;
      
      #Average orde value per customer
      select c.cust_id,c.Name,Round(sum(t.total)/count(t.t_id),2) As Average_order_value from customers c
      join transcations t on t.cust_id=c.cust_id group by c.cust_id,c.Name
      order by Average_order_value desc;
      
      #window function for customers
      select c.cust_id,c.Name ,sum(t.total) as total_spend,
      RANK() over (order by sum(t.total) DESC) AS spending_rank from customers c
      join transcations t on c.cust_id=t.cust_id
      group by c.cust_id,c.Name;
 
#B) product table Analysis:
 
 select * from product;
 
 #Top 5  products based on price
 select id, Name,Category,Price from product 
 order by price desc limit 5;
 
 #Best selling products by Quantity
 select p.id,p.category,sum(t.quantity) as Total_qty from product p 
 join transcations t on p.id=t.product_id
 group by p.id,p.category order by Total_qty Desc;
 
 #High selling products
 select distinct(product_id),total from transcations 
 order by total desc;
 
 
 
 
 #c) store Analysis
 
 select * from stores;
 
 #Top 5 cities with most stores
select city ,count(store_id) as Total_Stores from stores
group by city order by Total_Stores desc limit 5;

#stores opened earlier
select Store_id,store_name ,opened_Date from Stores
order by opened_Date asc limit 5;

#stores opened per year
select year(opened_Date)as opened_year,count(store_id) as Total_Stores_opened
from stores group by year(opened_Date) order by Total_Stores_opened desc;

#inventory analysis

select * from inventory;

#performing joins functions (joining stores and inventory table)
select s.store_id,s.store_name,s.city,i.product_id ,i.stocks,i.last_restocked
from stores s  join inventory i on s.store_id=i.store_id;

#identifying top 5 stores that required stocks based on the date
select store_id,last_restocked from inventory
order by last_restocked asc limit 5;

#transcations analysis

select * from transcations;

#Day with more transactions
select monthname(t_date) as Most_transaction_Day,count(t_id) as Count_of_trans
from transcations group by monthname(t_date) order by count_of_trans desc;

#customer and stores with more transcation amount
select cust_id ,store_id,total from transcations
order by total desc limit 5;

#window function for transcation table (customer and stores with max trans_amt)
select cust_id,store_id,max(total) as max_trans,
dense_rank() over (  order by max(total) desc ) as Trans_rank from transcations
group by cust_id,store_id;

select * from feedback;

select product_id,ratints from feedback
order by ratints desc limit 5;

#percentage of positive feedbacks
select round(sum(case when ratints >=4 Then 1 ELSE 0 END)*100.0/count(*),2)
As positive_feedback_per from feedback;

#Avg Rating per product
select p.id,p.category,avg(f.ratints) as Average_Ratings from feedback f 
join product p on p.id=f.product_id
group by product_id order by avg(ratints); 

#categorizing the feedback ratings
select case when ratints >=4 Then "Excellent"
when ratints=3 Then "Good"
ELSE "Poor" END as Ratings_category,count(*) As Total_Count from feedback
group by ratings_category order by total_count desc;

#Returns Analysis
select * from returns;

#identify the most frequent reasons for returning the products
select max(reasons) as Reason from returns
order by max(reasons) ;

#products and stores with most returns
select t.product_id,t.store_id,count(r.return_id) as count_of_retuns from transcations t 
join returns r on r.t_id=t.t_id group by t.product_id,t.store_id order by count(r.return_id) desc;













 

 
 
 

 







 
  












 



 
 



 
 
 
 
 















