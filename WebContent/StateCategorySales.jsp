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
<title>Sales Page</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script> 
    <script type="text/javascript">
    	function updateTable( category ){
    		$.ajax({
    			  type: 'POST',
    			  url: "SalesCategoryAjax.jsp" ,
    			  data: "category=" + category,
    			  beforeSend:function(){
    				//Update Stats
    				//console.log('Request Sent');
    			  },
    			  success:function(result){
    			  
    			  var response = $.parseJSON(result);
    			  
    			  var i = Object.keys(response).length-1;
    			  while ( i >= 0 ){
    				  var keyStr = Object.keys(response)[i];
    				  //console.log("#" + category + " ." + keyStr);
    				  $("#" + category + " ." + keyStr).html("$" + response[keyStr]);
    				  i--;
    			  }
    			  //console.log(Object.keys(response)[0]);
    			  	
    			  },
    			  error:function(){
    				// Failed request
    				console.log("FAIL")
    			  }
    			});
    	}
    	
    </script>
</head>
<body>
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     Statement query = null;
     Statement query2 = null;
     Statement query3 = null;
     ResultSet categoriesR = null;
     
     try {
    	 //if (session.getAttribute("role") != null && session.getAttribute("role").equals("Owner")){
    	if (true){
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/" + application.getAttribute("database") + "?" +
             "user=postgres&password=postgres");
         
     	/**** GET ALL FILTERS AND SHIT  *****/    
         String action = request.getParameter("rowstatus");
     	String rowsView = request.getParameter("rowsView");
     	String quarter = request.getParameter("quarter");
     	String categories = request.getParameter("categories");
     	String state = request.getParameter("customerState");
     	String age = request.getParameter("customerAge");
     	
     	boolean rowsAreCustomers = true;
     	if (rowsView != null && rowsView.equals("States")){
     		rowsAreCustomers = false;
     	}
     	
     	/**** END GET ALL FILTERS AND SHIT ****/
     %>
    

    <%-- -------- INSERT Code -------- --%>
    <%
    
        // Check if an insertion is requested
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            Statement categoriesQ = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            categoriesR = categoriesQ.executeQuery("SELECT name FROM categories ORDER BY name ASC");
            String[] states = {"AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA", "KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"};
     %>
            
            <table border="1">
            	<tr>
            		<th>Categories</th>	          		
          	<% 
          			for ( int i = 0 ; i < states.length; ++i ){
          				%> <th><%=states[i]%></th><%
          			}
          	%>
				</tr>
				<% 
	        		while ( categoriesR.next() ){
	        			%> <tr id="<%=categoriesR.getString("name")%>">
	        				<td><%=categoriesR.getString("name")%></td>
	        			<%
	        			for ( int i = 0; i < states.length; ++i ){ //individual cells with totals
	        				%><td class="<%=states[i]%>">0</td><%
	        			}
	        			%></tr><%
	        		}
	        	%>
          	</table>
          	
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
	<script type="text/javascript">
		<% categoriesR.beforeFirst(); 
			while (categoriesR.next()){
				%>updateTable("<%=categoriesR.getString("name")%>");<%
			}%>
			function getChanges(){
				<% 
				categoriesR.beforeFirst(); 
				while (categoriesR.next()){
					%>updateTable("<%=categoriesR.getString("name")%>");<%
	    	}%>
			}
			setInterval(getChanges,2000);
	</script>
</body>
</html>