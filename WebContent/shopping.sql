/* Shopping.sql
 * Overview: This file sets up the database necessary for the Shopping app.
 * 
 * Database Structure:
 * -Database
 * --Table
 * ----Column
 * 
 * -Store
	--Categories
	----ID
	----Category Name
	----Category Description
	--Products
	----ID
	----Product Name
	----Unique SKU
	----Category (foreign key)
	----Price
	--Users
	----ID
	----Unique Username
	----Role (Owner or Customer)
	----Age
	----State
	--Shopping Cart
	----ID
	----Username (Foreign Key)
	----Product ID (Foreign Key)
	----Product Quantity
 * 
 * 
 */

/* Query to drop all tables */
DROP TABLE categories, products, users, shopping_cart, sales;

CREATE TABLE categories (
    id			SERIAL PRIMARY KEY,
    name		VARCHAR(128),
    description TEXT
);
CREATE TABLE products (
    id      SERIAL UNIQUE,
	sku		SERIAL PRIMARY KEY,
	name	VARCHAR(128),
	category INTEGER references categories(id),
	price	MONEY
);
CREATE TABLE users (
    id	SERIAL PRIMARY KEY,
    username VARCHAR(64) UNIQUE NOT NULL,
    role	VARCHAR(8) NOT NULL,
    age		SMALLINT,
    state	VARCHAR(30)
);
CREATE TABLE shopping_cart (
    id 	SERIAL PRIMARY KEY,
    buyer INTEGER references users(id),
    productID	INTEGER references products(sku),
    quantity	INTEGER
);
CREATE TABLE sales(
    id SERIAL PRIMARY KEY,
    productID INT references products(sku) NOT NULL,
    customerID INT references users(id) NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    quantity INT NOT NULL,
    totalCost INT NOT NULL
);
/*INSERT INTO categories (name, description) values ('WTF TESTING', 'This is test... lololll');
INSERT INTO products (name, category, price) values ('WTF MACHINE', 1, 3.50 );
INSERT INTO users (username, role, age, state) values ('roflcake', 'Owner', 23, 'California');
INSERT INTO shopping_cart (buyer, productID, quantity) values (1, 1, 2);
INSERT INTO sales (productID, customerID, day, month, quantity, totalCost) values (1,1,28,5,8,23);*/

/* Query to clear all tables 
TRUNCATE categories, products, users, shopping_cart, sales;*/
