<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%@ page import="org.postgresql.util.*" %>
<!--  Include the UserInfo page -->
<jsp:include page="userinfo.jsp" />
<title>Products Page</title>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script> 
</head>
<body>


	<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     Statement query = null;
     ResultSet result = null;
     
     try {
         if (session.getAttribute("role") != null && session.getAttribute("role").equals("Owner")) {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/"+ application.getAttribute("database") +"?" +
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
		<input type="button" value="Add Product" />
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
    	          			PGmoney priceObj = new PGmoney(result.getString("price"));
    	          	%>
    	          	<form action="products.jsp" method="POST">
    	          		<tr>
    	          			<td><input name="name" value='<%=result.getString("name")%>'></td>
    	          			<td><input name="sku" value='<%=result.getInt("sku")%>'></td>
    	          			<td><input name="price" value='<%=priceObj.val%>'></td>
    	          			<td><input type="button" name="action" value="Update" class="update" /></td>
			               	<td><input type="button" name="action" value="Delete" class ="delete" /></td>
			               	<td><input type="hidden" name="id" value="<%=result.getInt("id")%>"/></td>
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
	<script type="text/javascript">
		$(".update").bind("click", function(){
			var name = $(this).parent().siblings().children('[name="name"]').attr("value");
			var sku = $(this).parent().siblings().children('[name="sku"]').attr("value");
			var price = $(this).parent().siblings().children("[name='price']").attr("value");
			var id = $(this).parent().siblings().children("[name='id']").attr("value");
			var dataStr = "name=" + name + "&sku=" + sku + "&price=" + price + "&id=" + id + "&action=Update";
			console.log(dataStr);
			
			$.ajax({
				type: "POST",
				url: "productsAjax.jsp",
				data: dataStr,
	  			  beforeSend:function(){
	  				//Update Stats
	  				console.log('Request Sent');
	  			  },
	  			  success:function(result){
	  				console.log("SUCESS");
	  				var response = $.parseJSON(result);

	  				$(this).parent().siblings().children("[name='name']").attr("value", response["name"] );
	  				$(this).parent().siblings().children("[name='sku']").attr("value", response["sku"]);
	  				$(this).parent().siblings().children("[name='price']").attr("value", response["price"]);
	  			  },
	  			  error:function(){
	  				// Failed request
	  				console.log("FAIL");
	  			  }	
			});
		});
		$(".insertProduct").bind("click", function(){
			var name = $(this).parent().siblings().children('[name="name"]').attr("value");
			var sku = $(this).parent().siblings().children('[name="sku"]').attr("value");
			var price = $(this).parent().siblings().children("[name='price']").attr("value");
			var id = $(this).parent().siblings().children("[name='id']").attr("value");
			var dataStr = "name=" + name + "&sku=" + sku + "&price=" + price + "&id=" + id + "&action=Update";
			console.log(dataStr);
			
			$.ajax({
				type: "POST",
				url: "productsAjax.jsp",
				data: dataStr,
	  			  beforeSend:function(){
	  				//Update Stats
	  				console.log('Request Sent');
	  			  },
	  			  success:function(result){
	  				console.log("SUCESS");
	  				var response = $.parseJSON(result);

	  				$(this).parent().siblings().children("[name='name']").attr("value", response["name"] );
	  				$(this).parent().siblings().children("[name='sku']").attr("value", response["sku"]);
	  				$(this).parent().siblings().children("[name='price']").attr("value", response["price"]);
	  			  },
	  			  error:function(){
	  				// Failed request
	  				console.log("FAIL");
	  			  }	
			});
		});
	
	
	</script>
</body>
</html>