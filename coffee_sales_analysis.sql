select * from coffee_shop_sales

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

ALTER TABLE coffee_shop_sales
MODIFY transaction_date DATE;

select concat((round(sum(unit_price *transaction_qty)))/1000,"K") as total_sales 
from coffee_shop_sales 
where
month(transaction_date)=3 -- March Month
-- Selected Month/CM-May=5
-- PM - April = 4

update coffee_shop_sales
set transaction_time=str_to_time(transaction_time,'%H-%i-%s');

alter table coffee_shop_sales
modify column transaction_time time;

describe coffee_shop_sales




alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id INT;

SELECT 
    MONTH(transaction_date) AS month, -- Number of Month
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales, -- Total Sales Column
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) -- Month Sales Difference
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- Division by PM Sales
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- Percentage 
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April (PM) and May (CM)
    GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5 -- for month of (CM-May)

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


SELECT
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') AS total_sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1),'K') AS total_quantity_sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1), 'K') AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'
    -- Weekends - Sat and Sun
    -- Weekands - Mon to Fri
    
    Sun = 1
    Mon = 2
    .
    .
    Sat = 7 
    
    SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;
    
    
    SELECT 
	store_location,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =6
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC

SELECT AVG(unit_price * transaction_qty)as Avg_Sales
FROM coffee_shop_sales
where MONTH(transaction_date)=5

SELECT 
CONCAT(ROUND(AVG(total_sales)/1000,1),'K') AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;


SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);


SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;


SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC
SELECT * FROM coffee_shop_sales


SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10


SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);
