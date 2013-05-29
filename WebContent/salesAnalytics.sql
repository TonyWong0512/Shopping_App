DROP TABLE ProductsPerCustomers, TopCustomers, TopProducts;

CREATE TABLE ProductsPerCustomers
AS (

	SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, 
		    users.age, products.category, users.state
	FROM users, products, sales
	WHERE sales.customerID = users.id AND sales.productID = products.sku
	GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state
	ORDER BY SUM(totalCost) DESC
);
CREATE TABLE TopCustomers
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
);
