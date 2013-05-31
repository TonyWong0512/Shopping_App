<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!--  Include the UserInfo page -->
<jsp:include page="userinfo.jsp" />

<title>Thanks for your business!</title>
</head>
<body>
	<%--------- Displaying products added ---------%>

		<div id="productTable">
		<h2>You have purchased: </h2>
		<table>
			<tr>
				<th>Product Name</th>
				<th>Quantity</th>
				<th>Price</th>
			</tr>


		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     ResultSet result = null;
     double total = 0.0;
     
     try {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/" + application.getAttribute("database") + "?" +
             "user=postgres&password=postgres");
     %>
    <%-- -------- INSERT Code -------- --%>
    <%
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);
            
            Statement statement = conn.createStatement();
            result = statement.executeQuery("SELECT p.name, sc.quantity, p.price, u.id as uID, p.sku as SKU FROM shopping_cart AS sc, products AS p, users AS u WHERE sc.productID=p.sku AND sc.buyer = u.id AND u.username='" + session.getAttribute("user") +"'");
            //result = statement.executeQuery("SELECT p.name, sc.quantity, p.price FROM shopping_cart AS sc, products AS p, users AS u WHERE sc.productID=p.id AND sc.buyer = u.id AND u.username='hi'");

	%>
	<%
			Calendar calendar = Calendar.getInstance();
			while (result.next()){
				String name = result.getString("name");
				int quantity = Integer.parseInt(result.getString("quantity"));
				double price = Double.parseDouble((result.getString("price")).substring(1));
				int customerId = Integer.parseInt(result.getString("uID"));
				int productId = Integer.parseInt(result.getString("SKU"));
				int month = calendar.get(Calendar.MONTH) + 1;
				int day = calendar.get(Calendar.DAY_OF_MONTH);
				

				/*
				Update if there is already something in the database. Else insert
				
				PrepareStatement lol = conn.prepareStatement("INSERT INTO sales(productID, customerID, day, month, quantity, totalCost) VALUES(?,?,?,?,?)");
				productID -- you get from shopping cart (name)
				customerID -- you get from shopping cart 
				month -- java.util.Date().getMonth();
				day -- java.util.Date().getDay();
				quantity -- you get from shopping cart
				totalCost (quantity of 1 product * cost of 1 product) --  quantity * price */
				conn.setAutoCommit(false);
				
				query = conn.prepareStatement("INSERT INTO sales(productID, customerID, day, month, quantity, totalCost) VALUES (?,?,?,?,?,?)");
	            query.setInt(1, productId);
	            query.setInt(2, customerId);
	            query.setInt(3, day);
	            query.setInt(4, month);
	            query.setInt(5, quantity);
	            query.setDouble(6, price);
	            int rowCount = query.executeUpdate();
	            

				total += quantity * price; 

	%>
				<tr>
					<td><%=name%></td>
					<td><%=quantity%></td>
					<td><%=price%></td>
				</tr>
	<%	
			}
			/* UPDATING PRECOMPUTED TABLE */
			//Creating TopProducts and TopCustomer Tables
			try{
				Statement dropPPC = conn.createStatement();
            	dropPPC.executeUpdate("DROP TABLE ProductsPerCustomers");
            	Statement dropSBD = conn.createStatement();
            	dropSBD.executeUpdate("DROP TABLE SalesByDate");
			}
            catch(SQLException e){
            	System.out.println("Table already exists probably");
            }
			String ppcTableQ = "SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, " +
				    "users.age, categories.name as category, users.state, products.price " +
					"FROM users, products, sales, categories " +
					"WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category " +
					"GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, " +
					"users.state, categories.name ORDER BY SUM(totalCost) DESC";
			String sbdTableQ = "SELECT sales.customerID, username, SUM(totalCost) AS totalCost, sales.productID, products.name, SUM(quantity) as quantity, " + 
				    "users.age, categories.name as category, users.state, sales.month, products.price FROM users, products, sales, categories " + 
					"WHERE sales.customerID = users.id AND sales.productID = products.sku AND categories.id = products.category " + 
					"GROUP BY username, sales.customerID, products.name, sales.productID, products.price, users.age, products.category, users.state, categories.name, sales.month";
			Statement createPrecomputedTable1 = conn.createStatement();
            createPrecomputedTable1.executeUpdate("CREATE TABLE ProductsPerCustomers AS(" + ppcTableQ + ")");
            Statement createPrecomputedTable2 = conn.createStatement();
            createPrecomputedTable2.executeUpdate("CREATE TABLE SalesByDate AS(" + sbdTableQ + ")");
			String productsQ = "SELECT name FROM (SELECT name, quantity FROM ProductsPerCustomers) as lol GROUP BY name ORDER BY SUM(quantity) DESC LIMIT 10";
            String customerQ = "SELECT username FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY SUM(totalCost) DESC LIMIT 10";
			Statement dropQ1 = conn.createStatement();
            dropQ1.executeUpdate("DROP TABLE TopCustomers");
            Statement dropQ2 = conn.createStatement();
            dropQ2.executeUpdate("DROP TABLE TopProducts");
            Statement createTable1 = conn.createStatement();
            createTable1.executeUpdate("CREATE TABLE TopCustomers AS("+ customerQ +")");
            Statement createTable2 = conn.createStatement();
            createTable2.executeUpdate("CREATE TABLE TopProducts AS("+ productsQ +")");
			

	%>

			</table>
			</div>

			<h3>You paid: <%=total%></h3>
			<h3>Thanks for your business!</h3>


	<%
			String userID = request.getParameter("userID");
			if ( userID != null ){
				int uID = Integer.parseInt(userID);
				PreparedStatement q = conn.prepareStatement("DELETE FROM shopping_cart AS sc WHERE sc.buyer="+ uID );
				q.executeUpdate();
			}


            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
    %>
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the Connection
        	conn.close();
    %>
    <%-- -------- Error catching ---------- --%>
    <%
     } catch (SQLException e) {
    	 //System.out.println("In catch");
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
    	 out.println("Sorry, something went wrong. ");
    }
    finally {
        // Release resources in a finally block in reverse-order of
        // their creation
		//System.out.println("In finally");
        if (query != null) {
            try {
                query.close();
            } catch (SQLException e) { } // Ignore
            query = null;
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) { } // Ignore
            conn = null;
        }
    }
    %>

</body>
</html>