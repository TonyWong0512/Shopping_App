DROP TABLE SalesByDate, ProductsPerCustomers, TopCustomers, TopProducts;

CREATE TABLE ProductsPerCustomers
AS (
	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, 
		    users.age, categories.name as category, users.state
	FROM users, products, sales, categories
	WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category
	GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state, categories.name
	ORDER BY SUM(totalCost) DESC
);
/*CREATE TABLE TopCustomers
AS(
	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, users.age, users.state
	FROM users, sales
	WHERE sales.customerID = users.id
	GROUP BY username, sales.customerID, users.age, users.state
	ORDER BY totalCost DESC
);


CREATE TABLE TopProducts
AS(
	SELECT sales.productID, products.name, SUM(quantity), products.price
	FROM products, sales
	WHERE sales.productID = products.sku
	GROUP BY products.name, sales. productID, products.price
	ORDER BY SUM(quantity) DESC
);*/
CREATE TABLE SalesByDate
AS(
	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, 
		    users.age, categories.name as category, users.state, sales.month
	FROM users, products, sales, categories
	WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category
	GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state, categories.name, sales.month
);
CREATE TABLE ProductsPerState
AS (
	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, 
		    users.age, categories.name as category, users.state
	FROM users, products, sales, categories
	WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category
	GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state, categories.name
	ORDER BY SUM(totalCost) DESC
);
CREATE TABLE TopCustomers
AS(
	SELECT username FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY SUM(totalCost) DESC LIMIT 10
);

/*CREATE TABLE TopStates
AS(
	SELECT username FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY SUM(totalCost) DESC LIMIT 10
);

CREATE TABLE TopCustomersPerState
AS(
	SELECT username FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY SUM(totalCost) DESC LIMIT 10
);
*/
CREATE TABLE TopProducts
AS(
	SELECT name FROM (SELECT name, quantity FROM ProductsPerCustomers) as lol GROUP BY name ORDER BY SUM(quantity) DESC LIMIT 10
);
