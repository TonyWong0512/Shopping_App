<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<!--  Include the UserInfo page -->
<title>Sales Page</title>
</head>
<body>

	<form action="sales.jsp" method="post">
		<select><option>Customer</option><option>States</option></select>
		<input type="hidden" name="rowstatus" value="yes" />
		<input type="submit" value="update" />
	</form>
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     PreparedStatement query2 = null;
     ResultSet result = null;
     ResultSet result2 = null;
     
     try {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/shopping?" +
             "user=postgres&password=postgres");
     %>
    <%-- -------- INSERT Code -------- --%>
    <%
        String action = request.getParameter("rowstatus");
        // Check if an insertion is requested
        if (action != null && action.equals("yes")) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            query = conn
            .prepareStatement("SELECT username, SUM(totalCost) FROM users, sales WHERE sales.customerID = users.id GROUP BY username ORDER BY SUM(totalCost) DESC LIMIT 10");
            result = query.executeQuery();
            query2 = conn
            .prepareStatement("SELECT products.name, SUM(quantity) FROM products, sales WHERE sales.productID = products.id GROUP BY products.name ORDER BY SUM(quantity) DESC LIMIT 10");
            result2 = query2.executeQuery();
            
    %>
            
            <table>
          	<tr>
          		<th>Customer</th>
          		<th>TotalCost</th>
          		
          		<%    	          			
          		while (result2.next()){
          	    %>
          		<th><%=result2.getString(1)%></th>
          		<%	
          		  }
          	    %>
          	</tr>

          	
          	<%    	          			
          		while (result.next()){
          	%>
          	<form action="products_order.jsp" method="POST">
          		<tr>
          			<td><input name="name" disabled = "disabled" value='<%=result.getString(1)%>'></td>
          			<td><input name="totalcost" disabled = "disabled" value='<%=result.getInt(2)%>'></td>
          			<td><input name="product1" disabled = "disabled" value=0></td>
		            <td><input name="product2" disabled = "disabled" value=0></td>
		            <td><input name="product3" disabled = "disabled" value=0></td>
		            <td><input name="product4" disabled = "disabled" value=0></td>
		            <td><input name="product5" disabled = "disabled" value=0></td>
		            <td><input name="product6" disabled = "disabled" value=0></td>
		            <td><input name="product7" disabled = "disabled" value=0></td>
		            <td><input name="product8" disabled = "disabled" value=0></td>
		            <td><input name="product9" disabled = "disabled" value=0></td>
		            <td><input name="product10" disabled = "disabled" value=0></td>
	             </tr>
          	</form>	
          	<%	
          		}
          	%>
          	</table>
          	
    <table>
    
    <% 
            
            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
    %>
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the Connection
        	conn.close();
        }
    %>
    <%-- -------- Error catching ---------- --%>
    <%
     } catch (SQLException e) {
    	 //System.out.println("In catch");
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        throw new RuntimeException(e);
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