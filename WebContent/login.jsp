<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<title>Login Page</title>
</head>
<body>

	<form action="login.jsp" method="post">
		<label>Username: <input type="text" name="username" value="" /></label>
		<br />
		<input type="hidden" name="loggedin" value="yes" />
		<input type="submit" value="Login" />
	</form>
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
        String action = request.getParameter("signedup");
        // Check if an insertion is requested
        if (action != null && action.equals("yes")) {
        	System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            query = conn
            .prepareStatement("SELECT username, role FROM users WHERE username=\"" + request.getParameter("username") + "\"");
            result = query.executeQuery();
            int rowCount = result.size();
            
            if (rowCount == 0){
            	out.println("Sorry, " + request.getParameter("username") + " is not registered. Please sign up.");
            }
            else{
            	out.println("Hello" + rs[0]);
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
    	 System.out.println("In catch");
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        throw new RuntimeException(e);
    }
    finally {
        // Release resources in a finally block in reverse-order of
        // their creation
		System.out.println("In finally");
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