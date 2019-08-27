<%-- 
    Document   : ProviderStats
    Created on : Aug 6, 2019, 8:56:28 PM
    Author     : aries
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Your Stats</title>
    </head>
    <%
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; //Driver Class
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue"; //url (database)
        String User = "sa"; //datebase user account
        String Password = "Password@2014"; //database password
        
        //int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        //int ProviderID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        int ProviderID = 1;
        
        String FullName = "";
        String Company = "";
        String base65ProPic = "";
        String Email = "";
        String Tel = "";

        try{
            Class.forName(Driver);
            Connection provConn = DriverManager.getConnection(url, User, Password);
            String provQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement provPst = provConn.prepareStatement(provQuery);
            provPst.setInt(1, ProviderID);
            ResultSet provRec = provPst.executeQuery();
            
            while(provRec.next()){
                
            }
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
    
    <style>
        *{
            padding: 0;
            margin: 0;
        }
    </style>
    <body>
        <div id="wrapper">
            <center><div id="header" style="background-color: #ccccff; padding: 5px; margin: 0;">
                <center><a href="LoginPageToQueue"><image src="QueueLogo.png" style="margin-top: 5px; margin: 0;" width="200px"/></a>
                    <h2 style="color: #000099; margin: 0;">Your Queue Statistics</h2></center>
            </div>
            <div id="content" style="background-color:#6699ff; margin: 0;">
                
                <div style="width: 100%; max-width: 700px;">
                    <h3 style="text-align: left;">Your Bookings</h3>
                    <h3 style="text-align: left;">Your Ratings and Reviews</h3>
                    <h3 style="text-align: left;">Total Working Hours</h3>
                </div>
                
            </div></center>
            
            
        </div>
    </body>
</html>
