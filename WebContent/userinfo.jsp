<% 
	String str = (String) session.getAttribute("user");
    if (str != null){
      out.println("Hello " + str);
    }
            
%>