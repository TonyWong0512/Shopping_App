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
     ResultSet productSalesR = null;
     ResultSet customerTotalR = null;
     
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
        /******************************* BEGIN IF CUSTOMERS ARE CHOSEN *********************************/
        if ( getNext != null || (action != null && action.equals("yes") )) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            
            
     %>
            
            <table border="1">
          		          		
          		<% 
          		
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
       }
    	 
    	 else{
         	out.println("Sorry, you are not allowed access to this page.");
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
    
</body>
</html>