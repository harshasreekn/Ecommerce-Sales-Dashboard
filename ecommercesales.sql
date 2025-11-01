 -- Create database
CREATE DATABASE EcommerceDB;
GO

-- Use the database
USE EcommerceDB;



select * from ecommerce_sales_data;

ALTER TABLE ecommerce_sales_data
MODIFY COLUMN store_id VARCHAR(10);


ALTER TABLE ecommerce_sales_data
modify COLUMN product_id VARCHAR(10);

update ecommerce_sales_data
set transaction_date = str_to_date(transaction_date , '%Y-%m-%d'); 

alter table ecommerce_sales_data
modify column transaction_date date;

describe ecommerce_sales_data;

update ecommerce_sales_data
set transaction_time = str_to_date(transaction_time , '%H:%i:%s'); 

alter table ecommerce_sales_data
modify column transaction_time time;

describe ecommerce_sales_data;


select ROUND(sum(unit_price*transaction_qty))as Total_sales
from ecommerce_sales_data
where
month(transaction_date) =  6; -- march month

select count(*) from ecommerce_sales_data;
select * from ecommerce_sales_data;

select
month(transaction_date) as month,
round(sum(unit_price*transaction_qty)) as total_sales,
(sum(unit_price*transaction_qty)- lag(sum(unit_price*transaction_qty),1) 
over(order by month(transaction_date))) / lag(sum(unit_price*transaction_qty),1) 
over(order by month (transaction_date))*100 as mon_increase_perecentage

from ecommerce_sales_data
where month (transaction_date) in (1,2)
group by month(transaction_date)
order by month(transaction_date);

select* from ecommerce_sales_data;

select count(*) as Total_orders
from ecommerce_sales_data
where
month(transaction_date) =  5;

select
month(transaction_date) as month,
(count(transaction_id)) as total_orders,
(count(transaction_id)- lag(count(transaction_id),1) 
over(order by month(transaction_date))) / lag(count(transaction_id),1) 
over(order by month (transaction_date))*100 as mon_increase_perecentage

from ecommerce_sales_data
where month (transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);

select sum(transaction_qty) as total_qty_sold
from ecommerce_sales_data
where
month(transaction_date) =  5;


select 
concat(round(sum(unit_price*transaction_qty)/1000,1),"k") as total_sales,
concat(round(sum(transaction_qty)/1000,1),"k") as total_qty_sold,
concat(round(count(transaction_id)/1000,1),"k") as total_orders
from ecommerce_sales_data
where 
transaction_date = '2025-09-24';


-- weekdays and weekends

Sun = 1
Mon = 2
.
.
Sat = 7

select
case when dayofweek(transaction_date) in (1,7) then 'weekends'
else 'weekdays'
end as day_type,
concat(round(sum(unit_price*transaction_qty)/1000,1),"k") as total_sales
from ecommerce_sales_data
where month(transaction_date) = 2
group by case when dayofweek(transaction_date)in (1,7) then 'weekends'
else 'weekdays'
end;


select
Store_location,
concat(round(sum(unit_price*transaction_qty)/1000,2),"k") as total_sales
from ecommerce_sales_data
where month(transaction_date) = 6
group by store_location
order by concat(round(sum(unit_price*transaction_qty)/1000,2),"k") desc;



#select avg(unit_price*transaction_qty) as avg_sales
#from ecommerce_sales_data
#where month(transaction_date) = 5;

select 
concat(round(avg(total_sales)/1000,1),'k') as avg_sales
from
(select sum(transaction_qty*unit_price) as total_sales
from ecommerce_sales_data
where month(transaction_date) = 5
group by transaction_date
)as inner_query;


select
day(transaction_date) as day_of_month,
sum(unit_price*transaction_qty) as total_sales
from ecommerce_sales_data
where month(transaction_date) = 5
group by (transaction_date)
order by (transaction_date);

select
day_of_month,
case 
when total_sales > avg_sales then 'Above average'
when total_sales < avg_sales then 'Below average'
else 'Equal to Average'
end as sales_status,
total_sales
from 
(select day(transaction_date) as day_of_month,
sum(unit_price*transaction_qty) as total_sales,
avg(sum(unit_price*transaction_qty)) over() as avg_sales
from
ecommerce_sales_data
where 
month(transaction_date) = 5
group by 
day(transaction_date)
)
as sales_data
order by
day_of_month;

select
store_location,
concat(round(sum(transaction_qty*unit_price)/1000,1),'k') as total_sales
from ecommerce_sales_data
where month(transaction_date) = 4
group by store_location
order by (sum(transaction_qty*unit_price)) desc;

select
product_type,
concat(round(sum(unit_price*transaction_qty)/1000,1),'k') as total_sales
from ecommerce_sales_data
where month(transaction_date) = 5 and product_category = 'Beauty'
group by product_type
order by sum(unit_price*transaction_qty) desc;

select
concat(round(sum(unit_price*transaction_qty)/1000,1),'k') as total_sales,
sum(transaction_qty) as total_qty_sold,
count(*)
from ecommerce_sales_data
where month(transaction_date) = 5 
and dayofweek(transaction_date) = 1
and hour(transaction_time) = 14;

select
hour(transaction_time),
sum(transaction_qty*unit_price) as total_sales
from ecommerce_sales_data
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time) asc;


SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM ecommerce_sales_data
     
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;