/*
This file contains a script of Transact SQL (T-SQL) commands to interact with a database named 'Inventory'.
Requirements:
- SQL Server 2022 is installed and running
- referential integrity is enforced
Steps:
- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
- Set the default database to 'Inventory'.
- Create a 'suppliers' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- address: 255 characters, nullable
-- city: 50 characters, not null
-- state: 2 characters, not null
- Create the 'categories' table with a one-to-many relation to the 'suppliers'. Use the following columns:
-- id:  integer, primary key
-- name: 50 characters, not null
-- description:  255 characters, nullable
-- supplier_id: int, foreign key references suppliers(id)
- Create the 'products' table with a one-to-many relation to the 'categories' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- price: decimal (10, 2), not null
-- category_id: int, foreign key references categories(id)
- Populate the 'suppliers' table with sample data.
- Populate the 'categories' table with sample data.
- Populate the 'products' table with sample data.
- Create a view named 'product_list' that displays the following columns:
-- product_id
-- product_name
-- category_name
-- supplier_name
- Create a stored procedure named 'get_product_list' that returns the product list view.
- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
- Create a function that returns the total number of products in a category.
- Create a function that returns the total number of products supplied by a supplier.
*/

-- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Inventory')
BEGIN
    ALTER DATABASE Inventory SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Inventory;
END
GO

CREATE DATABASE Inventory;
GO

-- Set the default database to 'Inventory'.
USE Inventory;
GO

-- Create a 'suppliers' table.
CREATE TABLE suppliers
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL
);
GO

-- Create the 'categories' table with a one-to-many relation to the 'suppliers'.
CREATE TABLE categories
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);
GO

-- Create the 'products' table with a one-to-many relation to the 'categories' table.
CREATE TABLE products
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    -- Add a trigger to update the 'products' table when a 'categories' record is deleted
    CONSTRAINT FK_CategoryID FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
    -- Add a created_at column to track the creation date of the record
    created_at DATETIME DEFAULT GETDATE(),
    -- Add an updated_at column to track the last update date of the record
);
GO

-- Populate the 'suppliers' table with sample data.
INSERT INTO suppliers (id, name, address, city, state)
VALUES
(1, 'Supplier A', '123 Main St', 'City A', 'CA'),
(2, 'Supplier B', '456 Elm St', 'City B', 'NY'),
(3, 'Supplier C', '789 Oak St', 'City C', 'TX'),
(4, 'Supplier D', '101 Pine St', 'City D', 'FL');

-- Populate the 'categories' table with sample data.
INSERT INTO categories (id, name, description, supplier_id)
VALUES
(1, 'Category A', 'Description A', 1),
(2, 'Category B', 'Description B', 2),
(3, 'Category C', 'Description C', 3),
(4, 'Category D', 'Description D', 4);

-- Populate the 'products' table with sample data.
INSERT INTO products (id, name, price, category_id)
VALUES
(1, 'Product A', 10.99, 1),
(2, 'Product B', 20.99, 2),
(3, 'Product C', 30.99, 3),
(4, 'Product D', 40.99, 4);

-- Create a view named 'product_list' that displays the following columns:
CREATE VIEW product_list
AS
SELECT p.id AS product_id, p.name AS product_name, c.name AS category_name, s.name AS supplier_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON c.supplier_id = s.id;

-- Create a stored procedure named 'get_product_list' that returns the product list view.
CREATE PROCEDURE get_product_list
AS
BEGIN
    SELECT * FROM product_list;
END;

-- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
CREATE TRIGGER UpdateProductsOnCategoryDelete
ON categories
AFTER DELETE
AS
BEGIN
    DELETE FROM products WHERE category_id IN (SELECT id FROM DELETED);
END;

-- Create a function that returns the total number of products in a category.
CREATE FUNCTION GetTotalProductsInCategory
(
    @category_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products WHERE category_id = @category_id;
    RETURN @total_products;
END;

-- Create a function that returns the total number of products supplied by a supplier.
CREATE FUNCTION GetTotalProductsBySupplier
(
    @supplier_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE c.supplier_id = @supplier_id;
    RETURN @total_products;
END;

-- Test the functions
SELECT dbo.GetTotalProductsInCategory(1) AS TotalProductsInCategory1;
SELECT dbo.GetTotalProductsBySupplier(1) AS TotalProductsBySupplier1;


