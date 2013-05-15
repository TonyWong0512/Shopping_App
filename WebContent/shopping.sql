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
DROP TABLE categories, products, users, shopping_cart;

CREATE TABLE categories (
    id			SERIAL PRIMARY KEY,
    name		VARCHAR(128),
    description TEXT
);
CREATE TABLE products (
	id		SERIAL PRIMARY KEY,
	name	VARCHAR(128),
	sku		INTEGER,
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
    productID	INTEGER references products(id),
    quantity	INTEGER
);

INSERT INTO categories (name, description) values ('WTF TESTING', 'This is test... lololll');
INSERT INTO products (name, sku, category, price) values ('WTF MACHINE', 093240902, 1, 3.50 );
INSERT INTO users (username, role, age, state) values ('roflcake', 'Owner', 23, 'California');
INSERT INTO shopping_cart (buyer, productID, quantity) values (1, 1, 2);

/* Query to clear all tables */
TRUNCATE categories, products, users, shopping_cart;