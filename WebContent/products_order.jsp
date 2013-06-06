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
                    "jdbc:postgresql://localhost/"+ application.getAttribute("database") +"?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                /*String action = request.getParameter("action");
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
                }*/
            %>
             <%
	            Statement stm = conn.createStatement();
	            rs = stm.executeQuery("SELECT id FROM users WHERE username='"+ session.getAttribute("user") +"'");
	            int userID = 0;
	            if (rs.next())
	            	userID = rs.getInt("id");
            
            	String adding = (String)request.getParameter("adding");
            	if (adding != null && adding.equals("add")){
            		try{
            		PreparedStatement state = conn.prepareStatement("INSERT INTO shopping_cart (buyer, productID, quantity) VALUES (?, ?, ?)");
                            state.setInt(1, userID);
                            state.setInt(2, Integer.parseInt(request.getParameter("id")));
                            state.setInt(3, Integer.parseInt(request.getParameter("quantity")));
                            int rowCount = state.executeUpdate();
            		}
            		catch(SQLException e){
            			out.println("Sorry, the item you would like to add is not available anymore.");
            		}
            	}
      
            %>
            <%-- -------- SELECT Statement Code -------- --%>
            <%
            
                // Create the statement
                if ( request.getParameter("product") != null ){
	                Statement statement = conn.createStatement();
	
	                // Use the created statement to SELECT
	                // the student attributes FROM the Student table.
	                rs = statement.executeQuery("SELECT * FROM products WHERE sku=" + Integer.parseInt(request.getParameter("product")) );
            %>
            

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
    	          		<tr>
    	          			<td><input name="name" disabled = "disabled" value='<%=rs.getString("name")%>' /></td>
    	          			<td><input name="price" disabled = "disabled" value='<%=rs.getString("price")%>' /></td>
    	          			<td><input name="quantity" type="text" value="0" /></td>
				             <input type="hidden" name="adding" value="add" />
				             <input type="hidden" name="id" value='<%=rs.getInt("sku")%>' />
				             <input type="hidden" name="product" value="<%=request.getParameter("product") %>" />;
 				             <td><input type="submit" value="Add to Cart"/></td>
			             </tr>
    	          	</form>	
    	          	<%	
    	          		}
    	          	%>
    	          	</table>
    	          	
            <table>
              <tr>
                <h2>Your Shopping Cart: </h2>
              </tr>
              <tr>
                <th>Product Name</th>
                <th>Quantity</th>
                <th>Price</th>
              </tr>
            
			<%
				
	            Statement query = conn.createStatement();
	            //result = statement.executeQuery("SELECT p.name, sc.quantity, p.price FROM shopping_cart AS sc, products AS p, users AS u WHERE sc.productID=p.id AND sc.buyer = u.id AND u.username='" + session.getAttribute("user") +"'");
	            rs = statement.executeQuery("SELECT p.name, sc.quantity, p.price FROM shopping_cart AS sc, products AS p, users AS u WHERE sc.productID=p.sku AND u.id = "+ userID + " AND sc.buyer = " + userID);
			
			%>
			<%
			while (rs.next()){
				String name = rs.getString("name");
				int quantity = Integer.parseInt(rs.getString("quantity"));
				String price = rs.getString("price"); 
					
			%>
				<tr>
					<td><%=name%></td>
					<td><%=quantity%></td>
					<td><%=price%></td>
				</tr>
			<%	
			}
			
			%>
			</table>
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
            
                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
                }
               else{
               	out.println("No product added. LOL");
               }
            
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
            	 out.println("Sorry, something went wrong. Insert did not work.");
                //throw e;
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

