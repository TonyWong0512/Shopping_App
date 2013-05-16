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
	
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
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
                String action = request.getParameter("action");
                // Check if an insertion is requested

                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO  shopping_cart (productid, quantity) VALUES (?, ?)");
                    
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("quantity")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    pstmt.close();
                }
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM products ");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table>
              <tr>
                <td></td>
                <td></td>
                <td></td>
              </tr>
            </table>
            
            
			<table>
    	          	<tr>
    	          		<th>Name</th>
    	          		<th>Price</th>
    	          		<th>Quantity</th>
    	          	</tr>

    	          	
    	          	<%    	          			
    	          		while (rs.next()){
    	          	%>
    	          	<form action="products_order.jsp" method="POST">
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
    	          		<tr>
    	          			<td><input name="name" disabled = "disabled" value='<%=rs.getString("name")%>'></td>
    	          			<td><input name="price" disabled = "disabled" value='<%=rs.getDouble("price")%>'></td>
    	          			<td><input name="quantity" type="text" value=0 ></td>
	    	          		<form action="products.jsp" method="POST">
			                    <input type="hidden" name="action" value="add"/>
			                    <input type="hidden" name="id" value='<%=rs.getInt("id")%>' />
			                <td><input type="submit" value="Add to Cart"/></td>
			                </form>
			             </tr>
    	          	</form>	
    	          	<%	
    	          		}
    	          	%>
    	          	</table>


            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="products_order.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

                <%-- Get the id --%>
                <td>
                    <%=rs.getInt("id")%>
                </td>

                <%-- Get the product ID --%>
                <td>
                    <input value="<%=rs.getInt("productid")%>" name="productID" size="15"/>
                </td>

                <%-- Get the quantity --%>
                <td>
                    <input value="<%=rs.getInt("quantity")%>" name="quantity" size="15"/>
                </td>

            </tr>

            <%
                }
            %>
            
            

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
            
                // Close the Statement
                statement.close();

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

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
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

