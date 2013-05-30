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
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     Statement query = null;
     Statement query2 = null;
     Statement query3 = null;
     ResultSet result = null;
     ResultSet result2 = null;
     ResultSet tableFillResult = null;
     ResultSet rs = null;
     
     try {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/shopping?" +
             "user=postgres&password=postgres");
     %>
     <!--------------------------- THIS IS THE FORM ------------------------------>
     	<form action="sales.jsp" method="post">
	<div>View by:
		<select name="rowsView">
			<option value="Customer">Customer</option>
			<option value="States">States</option>
		</select>
		<br />
	</div>
		<span>Customer Age:
		<select name="customerAge">
			<option value="all" selected="selected">All Ages</option>
			<option value="0-9">0-9</option>
			<option value="10-19">10-19</option>
			<option value="20-29">20-29</option>
			<option value="30-39">30-39</option>
			<option value="40-49">40-49</option>
			<option value="50-59">50-59</option>
			<option value="60-69">60-69</option>
			<option value="70-79">70-79</option>
			<option value="80-89">80-89</option>
			<option value="90-99">90-99</option>
		</select>
		</span>
		
		<span>Customer's State:
		<select name="customerState">
			<option value="all" selected="selected">All States</option>
			<option value="AL">AL</option>
			<option value="AK">AK</option>
			<option value="AZ">AZ</option>
			<option value="AR">AR</option>
			<option value="CA">CA</option>
			<option value="CO">CO</option>
			<option value="CT">CT</option>
			<option value="DE">DE</option>
			<option value="FL">FL</option>
			<option value="GA">GA</option>
			<option value="HI">HI</option>
			<option value="ID">ID</option>
			<option value="IL">IL</option>
			<option value="IN">IN</option>
			<option value="IA">IA</option>
			<option value="KS">KS</option>
			<option value="KY">KY</option>
			<option value="LA">LA</option>
			<option value="ME">ME</option>
			<option value="MD">MD</option>
			<option value="MA">MA</option>
			<option value="MI">MI</option>
			<option value="MN">MN</option>
			<option value="MS">MS</option>
			<option value="MO">MO</option>
			<option value="MT">MT</option>
			<option value="NE">NE</option>
			<option value="NV">NV</option>
			<option value="NH">NH</option>
			<option value="NY">NY</option>
			<option value="NC">NC</option>
			<option value="ND">ND</option>
			<option value="OH">OH</option>
			<option value="OK">OK</option>
			<option value="OR">OR</option>
			<option value="PA">PA</option>
			<option value="RI">RI</option>
			<option value="SC">SC</option>
			<option value="SD">SD</option>
			<option value="TN">TN</option>
			<option value="TX">TX</option>
			<option value="UT">UT</option>
			<option value="VT">VT</option>
			<option value="VA">VA</option>
			<option value="WA">WA</option>
			<option value="WV">WV</option>
			<option value="WI">WI</option>
			<option value="WY">WY</option>
		</select>
		</span>
		
		<span>Product Categories:
		<select name="categories">
		    <option value="all" selected="selected">All Categories</option>
		<%
		// Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the category attributes FROM the Categories table.
                rs = statement.executeQuery("SELECT * FROM categories");
                
                while (rs.next()){
                	%> <option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option><%
                }
         %>
         </select>
         </span>
         
         <span>Quarter
		<select name="quarter">
			<option value="year" selected="selected">Full Year</option>
			<option value="fall">Fall</option>
			<option value="winter">Winter</option>
			<option value="spring">Spring</option>
			<option value="summer">Summer</option>
         </select>
         </span>
         
		<input type="hidden" name="rowstatus" value="yes" />
		<input type="submit" value="Run Query" />
		<%
			String getNext = request.getParameter("getNext");
			int offsetP = 0;
			int offsetC = 0;
			 //Set of variables for offsetting
	        String offsetCStr = "";
			String offsetPStr = "";
	        if ( getNext != null && getNext.equals("customers") ){
	        	offsetC = Integer.parseInt(request.getParameter("nextSetC"));
	        	offsetP = Integer.parseInt(request.getParameter("nextSetP"));
	        	offsetC += 10;
	    		offsetCStr = "OFFSET " + offsetC;
	    		offsetPStr = "OFFSET " + offsetP;
	    	}
	    	else if ( getNext != null && getNext.equals("products") ){
	    		offsetP = Integer.parseInt(request.getParameter("nextSetP"));
	    		offsetC = Integer.parseInt(request.getParameter("nextSetC"));
	    		offsetP += 10;
	    		offsetPStr = "OFFSET " + offsetP;
	    		offsetCStr = "OFFSET " + offsetC;
	    	}
	        
		%>
		
	</form>
	<form method="POST" action="sales.jsp"> 
		<input type="hidden" name="nextSetC" value="<%=offsetC%>" />
		<input type="hidden" name="nextSetP" value="<%=offsetP%>" />
		<input type="hidden" name="getNext" value="products" />
		<input type="submit" value="Next 10 Products" />
	</form>
	<form method="POST" action="sales.jsp">
		<input type="hidden" name="nextSetP" value="<%=offsetP%>" />
		<input type="hidden" name="nextSetC" value="<%=offsetC%>" />
		<input type="hidden" name="getNext" value="customers" />
		<input type="submit" value="Next 10 Customers" />
	</form>
     <!---------------------------END  THIS IS THE FORM ------------------------------>
    <%-- -------- INSERT Code -------- --%>
    <%
    	/**** GET ALL FILTERS AND SHIT  *****/    
        String action = request.getParameter("rowstatus");
    	String rowsView = request.getParameter("rowsView");
    	String quarter = request.getParameter("quarter");
    	String categories = request.getParameter("categories");
    	String state = request.getParameter("customerState");
    	String age = request.getParameter("customerAge");
    	
    	
    	/**** END GET ALL FILTERS AND SHIT ****/
    
        // Check if an insertion is requested
        /******************************* BEGIN IF CUSTOMERS ARE CHOSEN *********************************/
        if ( getNext != null || (action != null && action.equals("yes") && rowsView.equals("Customer"))) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            
            
            /********* BUILDING QUERIES ************/
           
            
			//This set of variables is for filtering Customers
            String whereClause1 = "";
            String groupClause1 ="";
			String orderBy1 = "";
			String colClause1 = "";
			
			if ( age != null && state != null && (!age.equals("all") || !state.equals("all")) )
				whereClause1 += " WHERE ";
			
			if (age != null && !age.equals("all") ){
				groupClause1 += ", age";
				colClause1 += ", age";
			}
			if (age != null && age.equals("0-9"))
				whereClause1 += " age >=0 AND age <= 9 ";
			else if (age != null && age.equals("10-19"))
				whereClause1 += " age >=10 AND age <= 19 ";
			else if (age != null && age.equals("20-29"))
				whereClause1 += " age >=20 AND age <= 29 ";	
			else if (age != null && age.equals("30-39"))
				whereClause1 += " age >=30 AND age <= 39 ";	
			else if (age != null && age.equals("40-49"))
				whereClause1 += " age >=40 AND age <= 49 ";	
			else if (age != null && age.equals("50-59"))
				whereClause1 += " age >=50 AND age <= 59 ";	
			else if (age != null && age.equals("60-69"))
				whereClause1 += " age >=60 AND age <= 69 ";	
			else if (age != null && age.equals("70-79"))
				whereClause1 += " age >=70 AND age <= 79 ";	
			else if (age != null && age.equals("80-89"))
				whereClause1 += " age >=80 AND age <= 89 ";	
			else if (age != null && age.equals("90-99"))
				whereClause1 += " age >=90 AND age <= 99 ";	
			else
				whereClause1 += " ";
        
       		
			if ( state != null && !state.equals("all")){
				groupClause1 += ", state";
				if (whereClause1.indexOf("=") >= 0 )
					whereClause1 += " AND";
				whereClause1 += " state = '"+ state +"'";
				colClause1 += ", state";
			}
			
            //This set of variables is for filtering products
			String whereClause2 = "";
            String groupClause2 ="";
			String orderBy2 = "";
			String colClause2 = "";
			
			if ( categories != null && !categories.equals("all") )
				whereClause2 += " WHERE ";
			
			if ( categories != null && !categories.equals("all")){
				groupClause2 += ", category";
				if (whereClause2.indexOf("=") >= 0 )
					whereClause2 += " AND";
				whereClause2 += " category = '"+ categories +"'";
				colClause2 += ", category";
			}
			
			//This set of variables is for filtering by date
			String whereClause3 = "";
			String tableName = " ProductsPerCustomers "; //Default table to use
			if (quarter != null && !quarter.equals("year")){
				tableName = " SalesbyDate "; 
				whereClause3 += " AND ";
				if (quarter.equals("fall"))
					whereClause3 += " ppc.month >= 9 AND ppc.month <= 11 ";
				else if (quarter.equals("winter"))
					whereClause3 += " ppc.month >= 1 AND ppc.month <= 3 ";
				else if (quarter.equals("spring"))
					whereClause3 += " ppc.month >= 4 AND ppc.month <= 6 ";
				else if (quarter.equals("summer"))
					whereClause3 += " ppc.month >= 7 AND ppc.month <= 8 ";
			}
			
			String customerQ = "SELECT ppc.username FROM (SELECT username, totalCost " + colClause1 + " FROM ProductsPerCustomers) as ppc " + whereClause1 + " GROUP BY ppc.username "+ groupClause1 +" ORDER BY SUM(totalCost) DESC LIMIT 10 " +offsetCStr;
			System.out.println(customerQ);
			String productsQ = "SELECT name FROM (SELECT name, quantity " + colClause2 +" FROM ProductsPerCustomers) as lol" + whereClause2 + " GROUP BY name " + groupClause2 + " ORDER BY SUM(quantity) DESC LIMIT 10 " + offsetPStr;
            String q = "SELECT ppc.username, ppc.name, ppc.quantity, totalCost FROM " + tableName +
    				"AS ppc WHERE ppc.name IN (SELECT name FROM TopProducts LIMIT 10) AND " +
    				"ppc.username IN (SELECT username FROM TopCustomers LIMIT 10)" + whereClause3;
			//System.out.println(q);
			/********** END BUILDING QUERIES ********/
            
            //Creating TopProducts and TopCustomer Tables
            Statement dropQ1 = conn.createStatement();
            dropQ1.executeUpdate("DROP TABLE TopCustomers");
            Statement dropQ2 = conn.createStatement();
            dropQ2.executeUpdate("DROP TABLE TopProducts");
            Statement createTable1 = conn.createStatement();
            createTable1.executeUpdate("CREATE TABLE TopCustomers AS("+ customerQ +")");
            Statement createTable2 = conn.createStatement();
            createTable2.executeUpdate("CREATE TABLE TopProducts AS("+ productsQ +")");
            
            //Getting top 10 customers
            //String customerQ = "SELECT username, SUM(totalCost) AS totalCost FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY totalCost DESC LIMIT 10;";
            String getCustomersQ = "SELECT username FROM TopCustomers LIMIT 10";
            query = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result = query.executeQuery(getCustomersQ);
            
            //Getting top 10 products
            String getProductsQ = "SELECT name FROM TopProducts LIMIT 10";
            query2 = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result2 = query2.executeQuery(getProductsQ);
            
            //Getting quantity information
            //System.out.println(q);
            query3 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tableFillResult = query3.executeQuery(q);
            
            int resultSize = 0;
            while (result.next()){
            	resultSize+=1;
            }
            result.beforeFirst();
    %>
            
            <table border="1">
          		          		
          		<% 
          		String[] productNames = new String[10];
          		int productSize = 0;
          		while(result2.next() && resultSize > 0){
          			productNames[productSize] = result2.getString("name");
          			productSize++;
          		}
          		
          		for ( int j = 0; j < resultSize+1; ++j ){ // 10 rows
          			%> <tr> <%
          			if ( j == 0 ){ //for first row
          				for ( int k = 0; k < productSize+1; ++k ){ //11 cols
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
	      						int cellQuantity = 0;
          						tableFillResult.beforeFirst();
	          					while ( tableFillResult.next() ){
	          						//System.out.println("Pname: " + productNames[k-1] + "; Name: " + tableFillResult.getString("name"));
	          						if ( productNames[k-1].equals(tableFillResult.getString("name"))){
		          						if ( result.getString("username").equals(tableFillResult.getString("username")) ){
		          							cellQuantity += tableFillResult.getInt("quantity");
		          							updatedTable = true;
		          						}

		          					}
          						}
	          				if ( !updatedTable ){
          						%> <th>0</th>  <%
	          				}
	          				else{
	          					%> <th><%=cellQuantity%></th>  <% 
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
        /******************** END IF CUSTOMERS ARE CHOSEN *************************/
        /******************** BEGIN IF STATES ARE CHOSEN ***************************/
        else if (action != null && action.equals("yes") && rowsView.equals("States")){
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            
            
            /********* BUILDING QUERIES ************/
           
            
			//This set of variables is for filtering Customers
            String whereClause1 = "";
            String groupClause1 ="";
			String orderBy1 = "";
			String colClause1 = "";
			
			if ( age != null && state != null && (!age.equals("all") || !state.equals("all")) )
				whereClause1 += " WHERE ";
			
			if (age != null && !age.equals("all") ){
				groupClause1 += ", age";
				colClause1 += ", age";
			}
			if (age != null && age.equals("0-9"))
				whereClause1 += " age >=0 AND age <= 9 ";
			else if (age != null && age.equals("10-19"))
				whereClause1 += " age >=10 AND age <= 19 ";
			else if (age != null && age.equals("20-29"))
				whereClause1 += " age >=20 AND age <= 29 ";	
			else if (age != null && age.equals("30-39"))
				whereClause1 += " age >=30 AND age <= 39 ";	
			else if (age != null && age.equals("40-49"))
				whereClause1 += " age >=40 AND age <= 49 ";	
			else if (age != null && age.equals("50-59"))
				whereClause1 += " age >=50 AND age <= 59 ";	
			else if (age != null && age.equals("60-69"))
				whereClause1 += " age >=60 AND age <= 69 ";	
			else if (age != null && age.equals("70-79"))
				whereClause1 += " age >=70 AND age <= 79 ";	
			else if (age != null && age.equals("80-89"))
				whereClause1 += " age >=80 AND age <= 89 ";	
			else if (age != null && age.equals("90-99"))
				whereClause1 += " age >=90 AND age <= 99 ";	
			else
				whereClause1 += " ";
        
       		
			if ( state != null && !state.equals("all")){
				groupClause1 += ", state";
				if (whereClause1.indexOf("=") >= 0 )
					whereClause1 += " AND";
				whereClause1 += " state = '"+ state +"'";
				colClause1 += ", state";
			}
			
            //This set of variables is for filtering products
			String whereClause2 = "";
            String groupClause2 ="";
			String orderBy2 = "";
			String colClause2 = "";
			
			if ( categories != null && !categories.equals("all") )
				whereClause2 += " WHERE ";
			
			if ( categories != null && !categories.equals("all")){
				groupClause2 += ", category";
				if (whereClause2.indexOf("=") >= 0 )
					whereClause2 += " AND";
				whereClause2 += " category = '"+ categories +"'";
				colClause2 += ", category";
			}
			
			//This set of variables is for filtering by date
			String whereClause3 = "";
			String tableName = " ProductsPerCustomers "; //Default table to use
			if (quarter != null && !quarter.equals("year")){
				tableName = " SalesbyDate "; 
				whereClause3 += " AND ";
				if (quarter.equals("fall"))
					whereClause3 += " ppc.month >= 9 AND ppc.month <= 11 ";
				else if (quarter.equals("winter"))
					whereClause3 += " ppc.month >= 1 AND ppc.month <= 3 ";
				else if (quarter.equals("spring"))
					whereClause3 += " ppc.month >= 4 AND ppc.month <= 6 ";
				else if (quarter.equals("summer"))
					whereClause3 += " ppc.month >= 7 AND ppc.month <= 8 ";
			}
			
			String customerQ = "SELECT ppc.username FROM (SELECT username, totalCost " + colClause1 + " FROM ProductsPerCustomers) as ppc " + whereClause1 + " GROUP BY ppc.username "+ groupClause1 +" ORDER BY SUM(totalCost) DESC LIMIT 10 " +offsetCStr;
			System.out.println(customerQ);
			String productsQ = "SELECT name FROM (SELECT name, quantity " + colClause2 +" FROM ProductsPerCustomers) as lol" + whereClause2 + " GROUP BY name " + groupClause2 + " ORDER BY SUM(quantity) DESC LIMIT 10 " + offsetPStr;
            String q = "SELECT ppc.username, ppc.name, ppc.quantity, totalCost FROM " + tableName +
    				"AS ppc WHERE ppc.name IN (SELECT name FROM TopProducts LIMIT 10) AND " +
    				"ppc.username IN (SELECT username FROM TopCustomers LIMIT 10)" + whereClause3;
			//System.out.println(q);
			/********** END BUILDING QUERIES ********/
            
            //Creating TopProducts and TopCustomer Tables
            Statement dropQ1 = conn.createStatement();
            dropQ1.executeUpdate("DROP TABLE TopCustomers");
            Statement dropQ2 = conn.createStatement();
            dropQ2.executeUpdate("DROP TABLE TopProducts");
            Statement createTable1 = conn.createStatement();
            createTable1.executeUpdate("CREATE TABLE TopCustomers AS("+ customerQ +")");
            Statement createTable2 = conn.createStatement();
            createTable2.executeUpdate("CREATE TABLE TopProducts AS("+ productsQ +")");
            
            //Getting top 10 customers
            //String customerQ = "SELECT username, SUM(totalCost) AS totalCost FROM (SELECT username, totalCost FROM ProductsPerCustomers) as lol GROUP BY username ORDER BY totalCost DESC LIMIT 10;";
            String getCustomersQ = "SELECT username FROM TopCustomers LIMIT 10";
            query = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result = query.executeQuery(getCustomersQ);
            
            //Getting top 10 products
            String getProductsQ = "SELECT name FROM TopProducts LIMIT 10";
            query2 = conn
            .createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            result2 = query2.executeQuery(getProductsQ);
            
            //Getting quantity information
            //System.out.println(q);
            query3 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tableFillResult = query3.executeQuery(q);
            
            int resultSize = 0;
            while (result.next()){
            	resultSize+=1;
            }
            result.beforeFirst();
    %>
            
            <table border="1">
          		          		
          		<% 
          		String[] productNames = new String[10];
          		int productSize = 0;
          		while(result2.next() && resultSize > 0){
          			productNames[productSize] = result2.getString("name");
          			productSize++;
          		}
          		
          		for ( int j = 0; j < resultSize+1; ++j ){ // 10 rows
          			%> <tr> <%
          			if ( j == 0 ){ //for first row
          				for ( int k = 0; k < productSize+1; ++k ){ //11 cols
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
	      						int cellQuantity = 0;
          						tableFillResult.beforeFirst();
	          					while ( tableFillResult.next() ){
	          						//System.out.println("Pname: " + productNames[k-1] + "; Name: " + tableFillResult.getString("name"));
	          						if ( productNames[k-1].equals(tableFillResult.getString("name"))){
		          						if ( result.getString("username").equals(tableFillResult.getString("username")) ){
		          							cellQuantity += tableFillResult.getInt("quantity");
		          							updatedTable = true;
		          						}

		          					}
          						}
	          				if ( !updatedTable ){
          						%> <th>0</th>  <%
	          				}
	          				else{
	          					%> <th><%=cellQuantity%></th>  <% 
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
        	    	
        	
        	
        	
        }
        /***************************END IF STATES ARE CHOSEN *******************/
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