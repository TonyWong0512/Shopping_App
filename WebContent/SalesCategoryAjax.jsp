<%@page import="java.util.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.postgresql.util.*" %>
<%@ page import="java.sql.*"%>
<%
	application.setAttribute("database","shopping");
	Calendar calendar = Calendar.getInstance();
	int month = calendar.get(Calendar.MONTH) + 1;
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	Connection conn = null;
	//request.getParameter("state")
  try {
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost/" + application.getAttribute("database") + "?" +
        "user=postgres&password=postgres");
    
    conn.setAutoCommit(false);

	JSONObject result = new JSONObject();
	Statement getSales = conn.createStatement();
	String getSalesQ = "SELECT state, total " +
			"FROM todaysorders " + 
			"WHERE category = '" + request.getParameter("category")  +"' " +
			"ORDER BY category ASC";
	//System.out.println(getSalesQ);
	ResultSet rs = getSales.executeQuery(getSalesQ);
	while (rs.next()){
		result.put(rs.getString("state"), rs.getString("total"));
	}
	out.print(result);
	out.flush();
	conn.commit();
    conn.setAutoCommit(true);
    conn.close();
  } catch(SQLException e){
	  //System.out.println("There was an error getting this request.");
	  throw e;
  }
	
%>