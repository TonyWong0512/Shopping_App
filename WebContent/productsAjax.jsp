<%@page import="java.util.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.postgresql.util.*" %>
<%@ page import="java.sql.*"%>
<%
	application.setAttribute("database","shopping");
	Calendar calendar = Calendar.getInstance();
	int month = calendar.get(Calendar.MONTH) + 1;
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	Connection conn = null;
	//request.getParameter("state")
  try {
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost/" + application.getAttribute("database") + "?" +
        "user=postgres&password=postgres");
    
    conn.setAutoCommit(false);

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
          
          Statement updateQ = conn.createStatement();
          ResultSet rs = updateQ.executeQuery("SELECT name, sku, price FROM products WHERE sku=" + request.getParameter("sku"));
          JSONObject result = new JSONObject();
          while (rs.next()){
      		result.put(rs.getString("name"), rs.getString("name"));
      		result.put(rs.getString("sku"), rs.getString("sku"));
      		result.put(rs.getString("price"), rs.getString("price"));
      	}
        out.print(result);
      	out.flush();
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
          if ( rowCount > 0 ){
        	  JSONObject result = new JSONObject();
        	  result.put("success", "true");
        	  out.print(result);
            	out.flush();
          }
	  }
	  else if (action != null && action.equals("insertProduct")) {
      	//System.out.println("In Sign up");
          // Begin transaction
          conn.setAutoCommit(false);
          
          Statement statement = conn.createStatement();
          PreparedStatement query = null;
          String prod_name = request.getParameter("product_name");
		  String sku = request.getParameter("sku");
		  String category_name = request.getParameter("category");
		  String price = request.getParameter("price");
		  
          ResultSet result = statement.executeQuery("SELECT id FROM categories WHERE name='"+ request.getParameter("category") + "'");
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
	            
	            Statement updateQ = conn.createStatement();
	            ResultSet rs = updateQ.executeQuery("SELECT name, sku, price FROM products WHERE sku=" + request.getParameter("sku"));
	            JSONObject resultJSON = new JSONObject();
	            while (rs.next()){
	        		resultJSON.put(rs.getString("name"), rs.getString("name"));
	        		resultJSON.put(rs.getString("sku"), rs.getString("sku"));
	        		resultJSON.put(rs.getString("price"), rs.getString("price"));
	        	}
	          out.print(result);
	        	out.flush();
          }
	
	
	  }
	  conn.commit();
      conn.setAutoCommit(true);
	
	/******************** End Update and Delete for Table of Products *************/
  } catch(SQLException e){
	  //System.out.println("There was an error getting this request.");
	  throw e;
  }
	
%>