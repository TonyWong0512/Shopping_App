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
<title>Products Page</title>
</head>
<body>


	<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     Statement query = null;
     ResultSet result = null;
     
     try {
         if (session.getAttribute("role") == "Owner") {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/shopping?" +
             "user=postgres&password=postgres");
     %>
    <%-- -------- INSERT Code -------- --%>
    <%
        // Check if an insertion is requested
       	//System.out.println("In Sign up");
           // Begin transaction
           conn.setAutoCommit(false);

           // Create the prepared statement and use it to
           // INSERT student values INTO the students table.
           query = conn.createStatement();
           result = query.executeQuery("SELECT name FROM categories");
    %>
    	<div id="menu">
	    	<h2>Menu</h2>	
	    	<ul>
	        	<% //Start of While Loop
					while (result.next()){
						String categoryName = result.getString("name");
		    	%>
				<li><a href="products.jsp?category=<%= categoryName %>"><%= categoryName %></a></li>
				<% //End of While loop	
					}
	        		result = query.executeQuery("SELECT name FROM categories");
          		%>
          		<li><a href="products.jsp?category=allproducts">All Products</a></li>
	    	</ul>
    	</div>
    
    	<form action="confirmAdd.jsp" method="post">
		<label>Product Name: <input type="text" name="product_name" value="" /></label>
		<br />
		<label>SKU: <input type="text" name="sku" value="" /></label>
		<br />
		<label>Category:
		<select name="category">
		
           <% //Start of While Loop
			while (result.next()){
				String categoryName = result.getString("name");
		    %>
			<option value="<%= categoryName %>"><%= categoryName %></option>
			<% //End of While loop	
			}
            %>
          </select>
		</label>
		<br />
		<label>Price: <input type="text" name="price" value="" /></label>
		<br />
		<input type="hidden" name="action" value="insertProduct" />
		<input type="submit" value="Add Product" />
	</form>
           
    <%
    	  /******************** Begin Displaying Table of Products **************************/
    	  //Checking for Category parameter
    	  String category = request.getParameter("category");
    	  String search = request.getParameter("search");
    			  
    	  if ( category != null || search != null ){
    		  try{
    			  query = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    			  String queryStr;
    			  if (category.equals("allproducts") ){
    				  queryStr = "SELECT id, name, sku, price FROM products ORDER BY category ASC";
    			  }
    			  else if (category == null && search != null ){
    				  queryStr = "SELECT id, name, sku, price FROM products WHERE products.name = '" + search + "'";
    			  }
    			  else{
	    			  queryStr = "SELECT p.id, p.name, p.sku, p.price " + 
	   			  					"FROM products AS p, categories AS c " +
	   			  					"WHERE p.category = c.id AND c.name = '"+category+"'";
    			  }
    	          result = query.executeQuery(queryStr);
    	          int size = 0;
    	          if (result != null){
    	        	  result.last();
    	        	  size = result.getRow();
    	        	  result.beforeFirst();
    	          }
    	      %>
    	          	<%
    	          		if ( size < 1 ){
    	          			if (category != null)
	          	  	  		   out.println("Sorry, there are no items in " + category);
    	          			if ( search != null )
    	          				out.println("Sorry, the item you are looking for is not in the database.");
	          	  	    }
    	          		else{
    	          	%>
    	          		<table>
    	          	<tr>
    	          		<th>Name</th>
    	          		<th>SKU</th>
    	          		<th>Price</th>
    	          		<th>Action</th>
    	          	</tr>
    	          	
    	          	<%    	          			
    	          		}
    	          		while (result.next()){
    	          	%>
    	          	<form action="products.jsp" method="POST">
                    <input type="hidden" name="id" value="<%=result.getInt("id")%>"/>
    	          		<tr>
    	          			<td><input name="name" value='<%=result.getString("name")%>'></td>
    	          			<td><input name="sku" value='<%=result.getInt("sku")%>'></td>
    	          			<td><input name="price" value='<%=result.getDouble("price")%>'></td>
    	          			<td><input type="submit" name="action" value="Update"></td>
			               	<td><input type="submit" name="action" value="Delete"/></td>
			             </tr>
    	          	</form>	
    	          	<%	
    	          		}
    	          	%>
    	          	</table>
    	      <%    
    		  } finally{
    			  
    		  }
    	  }
    	/***************** End Displaying Table of Products *********************/
    	/****************** Begin Update and Delete For Table of Products ****************/
    	String action = request.getParameter("action");
    	  if ( action != null && action.equals("Update") ){
    		// Begin transaction
              conn.setAutoCommit(false);

              // Create the prepared statement and use it to
              // UPDATE student values in the Students table.
              PreparedStatement statement = conn
                  .prepareStatement("UPDATE products SET name = ?, sku = ?, "
                      + "price =" + request.getParameter("price") + "WHERE id = ?");

              statement.setString(1, request.getParameter("name"));
              statement.setInt(2, Integer.parseInt(request.getParameter("sku")));
              //statement.setString(3, request.getParameter("price"));
              statement.setInt(3, Integer.parseInt(request.getParameter("id")));
              int rowCount = statement.executeUpdate();
    		  
    	  }
    	  else if ( action != null && action.equals("Delete") ){
    		// Begin transaction
              conn.setAutoCommit(false);

              // Create the prepared statement and use it to
              // DELETE students FROM the Students table.
               PreparedStatement statement = conn
                  .prepareStatement("DELETE FROM products WHERE id = ?");

              statement.setInt(1, Integer.parseInt(request.getParameter("id")));
              int rowCount = statement.executeUpdate();

    	  }
    	
    	
    	
    	
    	
    	/******************** End Update and Delete for Table of Products *************/
    %>
    <!--  Search Box -->
    <form action="products.jsp" method="POST">
   	 <input type="text" name="search" value="" />
   	 <input type="submit" value="Search" />
    </form>
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
         else{ // if not Owner
        	 out.println("Sorry, You are not allowed access to this page.");
         }
    %>
    <%-- -------- Error catching ---------- --%>
    <%
     } catch (SQLException e) {
    	 //System.out.println("In catch");
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        out.println("Sorry, something went wrong.");
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