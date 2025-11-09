-- E-Commerce Sales Analytics - Project

create database project;
use project;

CREATE TABLE Customers (customer_id INT PRIMARY KEY AUTO_INCREMENT,
customer_name VARCHAR(50), city VARCHAR(50), email VARCHAR(50)); 

CREATE TABLE Products (product_id INT PRIMARY KEY AUTO_INCREMENT, 
product_name VARCHAR(50), category VARCHAR(30), price DECIMAL(10,2));

CREATE TABLE Orders (order_id INT PRIMARY KEY AUTO_INCREMENT, customer_id INT, 
order_date DATE, FOREIGN KEY(customer_id) REFERENCES Customers(customer_id));

CREATE TABLE OrderDetails (order_detail_id INT PRIMARY KEY AUTO_INCREMENT, order_id INT, 
product_id INT, quantity INT, FOREIGN KEY (order_id) REFERENCES Orders(order_id), 
FOREIGN KEY (product_id) REFERENCES Products(product_id));

INSERT INTO Customers (customer_name, city, email) VALUES 
('Sumanth', 'Nizamabad', 'gadesumanth410@gmail.com'), ('Vikas', 'Visakapatnam', 'vikas@gmail.com'), 
('Bharath', 'Bangalore', 'bharath@gmail.com'), ('Sai', 'Hyderabad', 'sai@gmail.com');

INSERT INTO Products (product_name, category, price) VALUES 
('Laptop', 'Electronics', 65000), ('Mobile', 'Electronics', 45000),
('Headphones', 'Accessories', 2000), ('Shoes', 'Fashion', 4000), 
('Watch', 'Fashion', 3500);

INSERT INTO Orders (customer_id, order_date) VALUES 
(1, '2025-10-01'), (2, '2025-10-03'), (3,'2025-10-05'), (4, '2025-10-07'), (1, '2025-10-10'); 

INSERT INTO OrderDetails (order_id, product_id, quantity) 
VALUES (1, 1, 1), (1, 3, 2), (2, 2, 1), (2, 4, 1), (3, 5, 3), (4, 1, 1), (5, 2, 2);

-- QUERIES 

-- 1. Show all orders with customer names 
SELECT o.order_id, c.customer_name, o.order_date FROM Orders o 
JOIN Customers c ON o.customer_id = c.customer_id;

-- 2. List each order with product names and quantities
SELECT o.order_id, c.customer_name, p.product_name, od.quantity FROM Orders o 
JOIN Customers c ON o.customer_id = c.customer_id 
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id;

-- 3. Total spending per customer
SELECT c.customer_name, SUM(p.price * od.quantity) AS total_spent FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id GROUP BY c.customer_name;

-- 4. Find top 3 customers by total spending
SELECT c.customer_name, SUM(p.price * od.quantity) AS total_spent FROM Customers c 
JOIN Orders o ON c.customer_id = o.customer_id 
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id 
GROUP BY c.customer_name ORDER BY total_spent DESC LIMIT 3;

-- 5. Best-selling product by quantity
SELECT p.product_name, SUM(od.quantity) AS total_sold FROM Products p 
JOIN OrderDetails od ON p.product_id = od.product_id 
GROUP BY p.product_name ORDER BY total_sold DESC LIMIT 1;

-- 6. Revenue by category
SELECT p.category, SUM(p.price * od.quantity) AS total_revenue FROM Products p 
JOIN OrderDetails od ON p.product_id = od.product_id GROUP BY p.category;

-- 7. Count total number of orders placed by each customer
SELECT c.customer_name, COUNT(o.order_id) AS total_orders FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- 8. Find customers who placed more than 1 order
SELECT c.customer_name, COUNT(o.order_id) AS total_orders FROM Customers c JOIN Orders
o ON c.customer_id = o.customer_id GROUP BY c.customer_name HAVING total_orders > 1;

-- 9. Total revenue per day
SELECT o.order_date, SUM(p.price * od.quantity) AS daily_revenue FROM Orders o 
JOIN OrderDetails od ON o.order_id = od.order_id 
JOIN Products p ON od.product_id = p.product_id
GROUP BY o.order_date ORDER BY o.order_date;

-- 10. Show orders for customers in a specific city ('Hyderabad')
SELECT o.order_id, c.customer_name, o.order_date FROM Orders o JOIN Customers c ON
o.customer_id = c.customer_id WHERE c.city = 'Hyderabad';
