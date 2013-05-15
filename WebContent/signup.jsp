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

<title>Sign-up</title>
</head>
<body>

	<form action="signup.jsp" method="post">
		<label>Username: <input type="text" name="username" value="" /></label>
		<br />
		<label>Role: 
			<select name="role">
				<option value="Owner">Owner</option>
				<option value="Customer">Customer</option>
			</select>
		</label>
		<br />
		<label>Age: <input type="text" name="age" value="" /></label>
		<br />
		<label>State: 
			<select name="state">
				<option value="California">California</option>
				<option value="Colorado">Colorado</option>
				<option value="Connecticut">Connecticut</option>
				<option value="Florida">Florida</option>
				<option value="Missouri">Missouri</option>
			</select>
		</label>
		<br />
		<input type="hidden" name="signedup" value="yes" />
		<input type="submit" value="Sign Up" />
	</form>
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     
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
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            query = conn
            .prepareStatement("INSERT INTO users (username, role, age, state) VALUES (?, ?, ?, ?)");

            query.setString(1, request.getParameter("username"));
            query.setString(2, request.getParameter("role"));
            query.setInt(3, Integer.parseInt(request.getParameter("age")));
            query.setString(4, request.getParameter("state"));
            int rowCount = query.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
            
            out.println("Thank you, " + request.getParameter("username"));
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