<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<!--  Include the UserInfo page -->
<jsp:include page="userinfo.jsp" />

<title>Confirm Add</title>
</head>
<body>
	<%--------- Displaying products added ---------%>
			<%
				String prod_name = request.getParameter("product_name");
				String sku = request.getParameter("sku");
				String category_name = request.getParameter("category");
				String price = request.getParameter("price");
			
				if ( prod_name == null || sku == null || category_name == null || price == null ){
					String errorStr = "Sorry, your ";
					if (prod_name == null)
						errorStr += "product name, ";
					if (category_name == null)
						errorStr += "category name, ";
					if ( sku == null)
						errorStr += "sku, ";
					if ( price == null)
						errorStr += "price, ";
					errorStr += "are not valid. Please re-add those values.";
					out.println(errorStr);
				}
				else{
			%>
		<div id="productTable">
		<h2>You have added: </h2>
		<table>
			<tr>
				<th>Product Name</th>
				<th>SKU</th>
				<th>Category</th>
				<th>Price</th>
			</tr>
			<tr>
				<td><%=request.getParameter("product_name")%></td>
				<td><%=request.getParameter("sku")%></td>
				<td><%=request.getParameter("category")%></td>
				<td><%=request.getParameter("price")%></td>
			</tr>
		</table>
	</div>
		<%
				}
        %>
	
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     ResultSet result = null;
     
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
        String action = request.getParameter("action");
        // Check if an insertion is requested
        if (action != null && action.equals("insertProduct")) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);
            
            Statement statement = conn.createStatement();
            result = statement.executeQuery("SELECT id FROM categories WHERE name='"+ request.getParameter("category") + "'");
            if (result.next()){
	            int categoryId = result.getInt("id");
	            
	            // Create the prepared statement and use it to
	            // INSERT student values INTO the students table.
	            query = conn
	            .prepareStatement("INSERT INTO products (name, sku, category, price) VALUES (?, ?, ?,"+ price +")");
	            	
	            query.setString(1, prod_name);
	            query.setInt(2, Integer.parseInt(sku));
	            query.setInt(3, categoryId);
	            //query.setDouble(4, Double.parseDouble(request.getParameter("price")));
	            int rowCount = query.executeUpdate();
            }
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
    	 out.println("Sorry, something went wrong. Insert did not work.");
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