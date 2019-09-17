<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.io.OutputStream"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.sql.Statement"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>

<!DOCTYPE html>

<html>
    
    <head>      
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <title>Queue</title>
        
    </head>
  
    <%
          
    %>
    
        <body>
            
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image src="QueueLogo.png" style="margin-top: 5px;"/></center>
            
        </div>
            
        <div id="content" style="">
            
            
            
            <div id="main" style="min-height: 100%;">
                
                <center><div style="margin-right:3px; max-width: 700px;">
                <h1 style="text-align: center;">User Account(s) Already Exist</h1>
                <h3 style="color: black; padding-top: 10px; padding-bottom: 20px;">Not Finished. Please login with your account if it is listed below or go back to previous page to finish creating new account</h3>
                
                <%
                    
                    //connection arguments
                    String Url = config.getServletContext().getAttribute("DBUrl").toString();
                    String Driver = config.getServletContext().getAttribute("DBDriver").toString();
                    String user = config.getServletContext().getAttribute("DBUser").toString();
                    String password = config.getServletContext().getAttribute("DBPassword").toString();
                            
                    int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
                    ArrayList<ProviderInfo> ExistingAccountsList = new ArrayList<>();
                    ArrayList localList = ExistingProviderAccountsModel.SignupUserList.get(UserIndex).getList();
                    //JOptionPane.showMessageDialog(null, localList);
                    
                        for(int i = 0; i < localList.size(); i++){
                            
                            int ExistingAccountID = (int)localList.get(i);
                            
                            
                            try{
                                
                                Class.forName(Driver);
                                Connection existingAccountConn = DriverManager.getConnection(Url, user, password);
                                String existingAccountString = "select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                                PreparedStatement existingAccountPst = existingAccountConn.prepareStatement(existingAccountString);
                                existingAccountPst.setInt(1,ExistingAccountID);
                                ResultSet existingAccountRows = existingAccountPst.executeQuery();
                                
                                ProviderInfo eachProviderInfo;
                                
                                while(existingAccountRows.next()){
                                    
                                    eachProviderInfo = new ProviderInfo(existingAccountRows.getInt("Provider_ID"),existingAccountRows.getString("First_Name"), existingAccountRows.getString("Middle_Name"), existingAccountRows.getString("Last_Name"), existingAccountRows.getDate("Date_Of_Birth"), existingAccountRows.getString("Phone_Number"),
                                                    existingAccountRows.getString("Company"), existingAccountRows.getInt("Ratings"), existingAccountRows.getString("Service_Type"), existingAccountRows.getString("First_Name") + " - " + existingAccountRows.getString("Company"), existingAccountRows.getBlob("Profile_Pic"), existingAccountRows.getString("Email"));
                                    
                                    ExistingAccountsList.add(eachProviderInfo);
                                   
                                }
                            
                            }catch(Exception e){
                                e.printStackTrace();
                            }
                            
                        }
                %>
                
                <%
                    for(int j = 0; j < ExistingAccountsList.size(); j++){
                        
                        int ProviderID = ExistingAccountsList.get(j).getID();
                        String FirstName = ExistingAccountsList.get(j).getFirstName();
                        String MiddleName = ExistingAccountsList.get(j).getMiddleName();
                        String LastName = ExistingAccountsList.get(j).getLastName();
                        String FullName = FirstName + " " + MiddleName + " " + LastName;
                        String Company = ExistingAccountsList.get(j).getCompany();
                        String Tel = ExistingAccountsList.get(j).getPhoneNumber();
                        String Email = ExistingAccountsList.get(j).getEmail();
                        String base64Image = "";
                        
                        try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = ExistingAccountsList.get(j).getProfilePicture(); 
                                InputStream inputStream = profilepic.getBinaryStream();
                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead = -1;

                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    outputStream.write(buffer, 0, bytesRead);
                                }

                                byte[] imageBytes = outputStream.toByteArray();

                                base64Image = Base64.getEncoder().encodeToString(imageBytes);


                            }
                            catch(Exception e){

                            }
                        
                            String UserName = "";
                            
                            try{
                                
                                Class.forName(Driver);
                                Connection ExistingUserName = DriverManager.getConnection(Url, user, password);
                                String ExistingUserNameString = "Select UserName from QueueServiceProviders.UserAccount where Provider_ID = ?";
                                PreparedStatement ExistingUserNamePst = ExistingUserName.prepareStatement(ExistingUserNameString);
                                ExistingUserNamePst.setInt(1, ProviderID);
                                ResultSet UserAccountRow = ExistingUserNamePst.executeQuery();
                                
                                while(UserAccountRow.next()){
                                    
                                    UserName = UserAccountRow.getString("UserName").trim();
                                    
                                }
                                
                                
                            }catch(Exception e){
                                e.printStackTrace();
                            }
                        

                        
                   
                %>
                
                <div style="background-color: white; width: 100%; max-height: 600px; margin: 2px; margin-bottom: 10px; padding-top: 5px;">
                    <%
                        if(base64Image != ""){
                    %>
                    <img style="float: left;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                
                    <%}%>
                <p><%=FullName%></p>
                <p><%=Company%></p>
                <p><%=Tel%></p>
                <p><%=Email%></p>
                
                <p style="margin-top: 10px; color: tomato;">Login</p>
                
                <form name="login" action="LoginControllerMain" method="POST">
                    <input style="background-color: white; border: 1px solid black; padding: 2px;" placeholder="enter user name here" type="hidden" name="username" value="<%=UserName%>" />
                    <input style="background-color: white; border: 1px solid black; padding: 2px; width: 50%;" placeholder="enter password here" type="password" name="password" value="" />
                    <input style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;" type="submit" value="Login" />
                </form>
                
                <p style="clear: both;"></p>
            </div> 
            <%}%>
            </div>
             
        </div>
                            
        
                            
        <div id="footer" style="clear: both;">
            <p>AriesLab &copy;2019</p>
        </div>
                            
    </div>
                            
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/ActivateBkAppBtn.js"></script>
    
</html>
