<html>

<body>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include User Info code -------- --%>
            <jsp:include page="userinfo.jsp" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            
            <form action="products_browsing.jsp" method="post">
		    <p><label>Searching: <input type="text" name="searching" value="" /></label>
		    <br />
		    <input type="hidden" name="searchingin" value="yes" />
		    <input type="submit" value="Search" />
	        </form>
	   </table>
        </td>
    </tr>
</table>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet result = null;
            Statement query = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/"+ application.getAttribute("database") +"?" +
                    "user=postgres&password=postgres");
            %>
            

            <%-- -------- SELECT Statement Code -------- --%>
             <%
             	query = conn.createStatement();
			 	String queryStr;
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                
                if(request.getParameter("searchingin") == "" || request.getParameter("searchingin") == null)
                {
       			 	queryStr = "SELECT id, name, sku, price FROM products ORDER BY category ASC";
         	        result = query.executeQuery(queryStr);	
                }
                else{
                  String match = request.getParameter("searching");
                  String column = request.getParameter("column");
                  result = query.executeQuery("SELECT * FROM products WHERE name LIKE '%" + 
                							match + "%'");
                }
            
            %>
           
			<ul>
			<h3>Products available for purchase:</h3>

    	          	
    	          	<%    	          			
    	          		while (result.next()){
    	          	%>
    	          		<li><a href="products_order.jsp?product=<%=result.getInt("id")%>"><%=result.getString("name")%></a></li>
    	          	<%	
    	          		}
    	          	%>
            </ul>
            

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                result.close();

                // Close the Statement
                query.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
            	 out.println("Sorry, something went wrong. Insert did not work.");
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (result != null) {
                    try {
                        result.close();
                    } catch (SQLException e) { } // Ignore
                    result = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
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

