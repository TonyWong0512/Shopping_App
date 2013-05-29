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
     Statement query = null;
     Statement query2 = null;
     Statement query3 = null;
     ResultSet result = null;
     ResultSet result2 = null;
     ResultSet tableFillResult = null;
     
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
            
            //Getting top 10 customers
            String customerQ = "SELECT username, totalCost FROM TopCustomers LIMIT 10";
            query = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result = query.executeQuery(customerQ);
            
            //Getting top 10 products
            String productsQ = "SELECT name FROM TopProducts LIMIT 10";
            query2 = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result2 = query2.executeQuery(productsQ);
            
            //Getting quantity information
            String q = "SELECT ppc.username, ppc.name, ppc.quantity, totalCost FROM ProductsPerCustomers AS ppc " +
            				"WHERE ppc.productID IN (SELECT productID FROM TopProducts LIMIT 10) AND " +
            				"ppc.customerID IN (SELECT customerID FROM TopCustomers LIMIT 10)" ;
            query3 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tableFillResult = query3.executeQuery(q);
    %>
            
            <table border="1">
          		          		
          		<% 
          		String[] productNames = new String[10];
          		int i = 0;
          		while(result2.next()){
          			productNames[i] = result2.getString("name");
          			i++;
          		}
          		
          		for ( int j = 0; j < 11; ++j ){ // 10 rows
          			%> <tr> <%
          			if ( j == 0 ){ //for first row
          				for ( int k = 0; k < 11; ++k ){ //11 cols
          					if ( k == 0 ){ 
          					%>
          						<th>Customer / Sales Total</th>
          					<%	
          						continue;
          					}
          		%>			
          					<th><%=productNames[k-1]%></th>
          		<%

          				}
          				%></tr><%
          			} //end first row code
          			else{
          				
          				for ( int k = 0; k < 11; ++k ){ //12 cols
          					boolean updatedTable = false;
          					int totalAmount = 0;
	      					if ( k == 0 ){ 
	      						if (!result.next()){
	          						result.first();
	          					}
	      						tableFillResult.beforeFirst();
	      						while ( tableFillResult.next() ){
	      							if ( tableFillResult.getString("username").equals(result.getString("username")) ){
	      								totalAmount += tableFillResult.getInt("totalCost");
	      							}
	      						}
	      					%>
	      						<th><%=result.getString("username")%> / <%=totalAmount%></th>
	      					<%	
	      						continue;
          					}
          						tableFillResult.beforeFirst();
	          					while ( tableFillResult.next() ){
	          						//System.out.println("Pname: " + productNames[k-1] + "; Name: " + tableFillResult.getString("name"));
	          						if ( productNames[k-1].equals(tableFillResult.getString("name"))){
		          						if ( result.getString("username").equals(tableFillResult.getString("username")) ){
		          							%> <th><%=tableFillResult.getInt("quantity")%></th>  <% 
		          							updatedTable = true;
		          						}

		          					}
          						}
	          				if ( !updatedTable ){
          						%> <th>0</th>  <%
	          				}
          				
          		%>
          			
          		<%
          			}	
          		}
          			%> <tr> <%
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