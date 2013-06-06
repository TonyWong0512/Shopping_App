<%@page import="java.util.*" %>
<% 
	application.setAttribute("database","shopping");
    if ( application.getAttribute("todaysOrderChanged") == null ){
    	application.setAttribute("todaysOrderChanged", new ArrayList<String>());
    }
	String user = (String) session.getAttribute("user");
    if (user != null){
      out.println("Hello " + user);
    }
    
    String role = (String) session.getAttribute("role");
    if (role != null && role.equals("Owner")){
%>
	<ul>
		<h2>Pages:</h2>
	    <li><a href="categories.jsp">Add/View Categories</a></li>
	    <li><a href="products.jsp">Add/View Products</a></li>
	    <li><a href="sales.jsp">Sales Analytics</a></li>
	    <li><a href="StateCategorySales.jsp">State/Category LIVE Analytics</a></li>
	</ul>
<%
    }
    else{
%>
	<ul>
		<h2>Pages:</h2>
	    <li><a href="products_browsing.jsp">Browse Products</a></li>
	    <li><a href="shoppingCart.jsp">View your Shopping Cart</a></li>
	</ul>

<%    	
    }
%>