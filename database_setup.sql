-- 1. DATA DEFINITION (TABLE CREATION)
-- Creating the Customer Table
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Phone_Number VARCHAR(15),
    Address VARCHAR(100)
);

-- Creating the Restaurant Table
CREATE TABLE Restaurant (
    Restaurant_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Location VARCHAR(50),
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 1.0 AND 5.0)
);

-- Creating the Menu_Item Table
CREATE TABLE Menu_Item (
    Item_ID INT PRIMARY KEY,
    Restaurant_ID INT,
    Item_Name VARCHAR(50),
    Price DECIMAL(10,2),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID)
);

-- Creating the OrderTable
CREATE TABLE OrderTable (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_ID INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID)
);

-- Creating the Review Table
CREATE TABLE Review (
    Review_ID INT PRIMARY KEY,
    Customer_ID INT,
    Restaurant_ID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES Restaurant(Restaurant_ID)
);

-- 2. DATA MANIPULATION (SAMPLE DATA)
-- Inserting values into Customer
INSERT INTO Customer VALUES (1, 'Fayiz Ahmed', 'fayiz@example.com', '0501234567', 'Dubai');
INSERT INTO Customer VALUES (2, 'Sara Khan', 'sara@example.com', '0507654321', 'Sharjah');

-- Inserting values into Restaurant
INSERT INTO Restaurant VALUES (101, 'Burger King', 'Al Quoz', 4.2);
INSERT INTO Restaurant VALUES (102, 'Pizza Hut', 'Marina', 4.5);

-- 3. DATA RETRIEVAL (LOGISTICS & ANALYTICS QUERIES)

-- JOIN: Connecting Customers to their specific Orders
SELECT c.Name, o.Order_ID, o.Total_Amount
FROM Customer c
INNER JOIN OrderTable o ON c.Customer_ID = o.Customer_ID;

-- LEFT JOIN: Identifying menu items across all restaurants
SELECT r.Name AS Restaurant, m.Item_Name
FROM Restaurant r
LEFT JOIN Menu_Item m ON r.Restaurant_ID = m.Restaurant_ID;

-- AGGREGATION: Finding Average Restaurant Ratings
SELECT Restaurant_ID, AVG(Rating) AS Avg_Rating
FROM Review
GROUP BY Restaurant_ID;

-- SUBQUERY: Finding high-value customers (Spending above average)
SELECT Name, Customer_ID
FROM Customer
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM OrderTable
    WHERE Total_Amount > (SELECT AVG(Total_Amount) FROM OrderTable)
);

-- ADVANCED LOGIC: Categorizing Order Values (The "Novelty" requirement)
SELECT Order_ID, Total_Amount,
CASE 
    WHEN Total_Amount > 100 THEN 'High Value'
    WHEN Total_Amount BETWEEN 50 AND 100 THEN 'Mid Value'
    ELSE 'Low Value'
END AS Order_Category
FROM OrderTable;