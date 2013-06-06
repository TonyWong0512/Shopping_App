/*DROP TABLE StateCategories

CREATE TABLE StateCategories
AS (
	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, 
		    users.age, categories.name as category, users.state, products.price
	FROM users, products, sales, categories
	WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category
	GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state, categories.name
	ORDER BY SUM(totalCost) DESC
);*/

CREATE TABLE TodaysOrders(
	id SERIAL PRIMARY KEY,
    category VARCHAR(128) NOT NULL,
    state VARCHAR(30) NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    total INT NOT NULL
);