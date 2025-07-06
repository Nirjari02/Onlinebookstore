CREATE database ONLINEBOOKSTORE;
USE ONLINEBOOKSTORE;

CREATE TABLE Books(
Book_ID Serial primary key,
Title varchar(50),
Genre Varchar(50),
Published_year INT,
Author Varchar(50),
Price Numeric (10,2),
Stock INT);

CREATE TABLE Customers(
Customer_ID serial primary key,
Name varchar(50),
Email varchar(50),
Phone varchar(50),
City varchar(50),
County varchar(50)
);

CREATE TABLE Orders(
Order_Id Serial primary key,
Customer_ID INT,
Book_ID INT,
Order_Date Date,
Quantity INT,
Total_Amount Numeric(10,2)
);
-- (1)Retrive all books in the Fiction genre

SELECT * 
From books
where Genre="Fiction";

-- if find total number of fiction genre 

SELECT COUNT(*)AS TOTAL_Fiction_GENRE
FROM books
WHERE GENRE = 'Fiction';


--   2) Find books published after the year 1950
 SELECT * 
 From books 
 where Published_Year > 1950;
 
 -- if find the books number which are published after 1950
 
 Select count(*)
 from books
 where published_year >1950;
 
 --  3) List all customers from the Canada

Select *
from customers
WHERE county = "Canada";

 -- 4) Show orders placed in November 2023
  Select * from orders
 where Order_Date between '2023-11-01' and '2023-11-30';
 
 /*or  where month(Order_Date)=11
  and year(Order_Date)=2023; */
  
--  5) Retrieve the total stock of books available
  
SELECT SUM(Stock) AS Total_Stock_Available
FROM Books;

--  6) Find the details of the most expensive book
 SELECT MAX(price)
 FROM books;
 
SELECT *
FROM books
WHERE price = (SELECT MAX(price) FROM books);

select*
from books
order by price desc limit 1;

--  7) Show all customers who ordered more than 1 quantity of a book

SELECT customers.Name, orders.Quantity
FROM Orders 
JOIN Customers  ON orders.Customer_ID = Customers.Customer_ID
WHERE Orders.Quantity > 0;

select * from orders
where quantity >1;

--  8) Retrieve all orders where the total amount exceeds $20


SELECT SUM(orders.Quantity * Books.Price) AS Total_Revenue_Above_20
FROM Orders 
JOIN Books ON orders.Book_ID = books.Book_ID
WHERE (orders.Quantity * books.Price) > 20;

--  9) List all genres available in the Books table

SELECT DISTINCT Genre
FROM Books;

-- 10) Find the book with the lowest stock

SELECT *
FROM Books
ORDER BY Stock LIMIT 1;



-- 11) Calculate the total revenue generated from all orders 
 
select sum(orders.quantity*books.Price)
from orders
join books on orders.Book_ID=books.Book_ID;

select sum(Total_Amount)as total_revenue from oreders;
 
-- 1) Retrieve the total number of books sold for each genre

SELECT 
    books.Genre,
    SUM(orders.Quantity) AS Total_Books_Sold
FROM 
    orders
JOIN 
    books ON orders.book_id = books.Book_ID
GROUP BY 
    books.Genre;
    
-- 2) Find the average price of books in the "Fantasy" genre

select 
avg(price) as avg_price
from books
where genre='Fantasy';

	--  3) List customers who have placed at least 2 orders

	select customer_id,
	count(order_id) as order_count
	from orders
	group by Customer_ID
	Having count(Order_ID)>=2;

-- 4) Find the most frequently ordered book
 
   select Book_ID,
   count (order_id) as order_count
   from orders
   group by Book_ID
   order by order_count desc;
   
--  5) Show the top 3 most expensive books of 'Fantasy' Genre 
 
SELECT * 
FROM books
WHERE genre = 'Fantasy'
ORDER BY Price DESC 
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author
 
 select books.author,
 sum(orders.quantity)
 from orders
 join books on orders.Book_ID = books.book_id
 group by
 books.Author;
 
 
 -- 7) List the cities where customers who spent over $30 are located

SELECT 
    customers.City
FROM 
    orders
JOIN 
    customers ON orders.Customer_ID = customers.Customer_ID
GROUP BY 
    customers.Customer_ID, customers.City
HAVING 
    SUM(orders.Total_Amount) > 30;

--  8) Find the customer who spent the most on orders

SELECT customers.Customer_ID,customers.name,
sum(orders.total_amount) as total_spent
FROM ORDERS 
join customers on orders.Customer_ID=customers.Customer_ID
group by customers.Customer_ID,customers.name
order by total_spent desc;

--  9) Calculate the stock remaining after fulfilling all orders

SELECT 
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(b.Stock - SUM(o.Quantity), b.Stock) AS Remaining_Stock
FROM 
    books b
LEFT JOIN 
    orders o ON b.Book_ID = o.Book_ID
GROUP BY 
    b.Book_ID, b.Title, b.Stock;
