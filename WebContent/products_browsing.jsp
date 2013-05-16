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
                    "jdbc:postgresql://localhost/shopping?" +
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
           
			<table>
    	          	<tr>
    	          		<th>Name</th>
    	          		<th>SKU</th>
    	          		<th>Price</th>
    	          	</tr>

    	          	
    	          	<%    	          			
    	          		while (result.next()){
    	          	%>
    	          	<form action="products_order.jsp" method="POST">
                    <input type="hidden" name="id" value="<%=result.getInt("id")%>"/>
    	          		<tr>
    	          			<td><input name="name" value='<%=result.getString("name")%>'></td>
    	          			<td><input name="sku" value='<%=result.getInt("sku")%>'></td>
    	          			<td><input name="price" value='<%=result.getDouble("price")%>'></td>
	    	          		<form action="products.jsp" method="POST">
			                    <input type="hidden" name="action" value="add"/>
			                    <input type="hidden" name="id" value='<%=result.getInt("id")%>' />
			                <td><input type="submit" value="Add"/></td>
			                </form>
			             </tr>
    	          	</form>	
    	          	<%	
    	          		}
    	          	%>
    	          	</table>
            
            

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
                throw new RuntimeException(e);
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
        </table>
        </td>
    </tr>
</table>
</body>

</html>

