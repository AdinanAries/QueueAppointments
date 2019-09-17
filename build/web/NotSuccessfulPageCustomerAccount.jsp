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
            
        <div id="PermanentDiv" style="">
            
            <a href="Queue.jsp" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 70px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>
                        <p><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                            Home</p></a>
            
            <div style="float: left; width: 350px; margin-top: 5px; margin-left: 10px;">
                <p style="color: white;"><img style="background-color: white; padding: 1px;" src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                    tech.arieslab@outlook.com | 
                    <img style="background-color: white; padding: 1px;" src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                    (1) 732-799-9546
                </p>
            </div>
            
            <div style="float: right; width: 50px;">
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                        <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" width="30" height="30" alt="icons8-user-filled-100"/>
                    </div></center>
            </div>
        
            <ul>
                <a  href="Queue.jsp">
                    <li onclick="" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Home</li></a>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
        
            <div id="ExtraDivSearch" style='background-color: #334d81; padding: 3px; padding-right: 5px; padding-left: 5px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #3d6999; color: #eeeeee; height: 30px; border: 1px solid darkblue; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; border: 1px solid white; background-color: navy; color: white; border-radius: 4px; padding: 7px; font-size: 15px;" 
                            type="submit" value="Search" />
                </form>
            </div>
                <p style='clear: both;'></p>
            
        </div>

            
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
                    
                    ArrayList<ProviderCustomerData> ExistingAccountsList = new ArrayList<>();
                    ArrayList localList = ExistingProviderAccountsModel.SignupUserList.get(UserIndex).getList();
                    //JOptionPane.showMessageDialog(null, localList);
                    
                        for(int i = 0; i < localList.size(); i++){
                            
                            int ExistingAccountID = (int)localList.get(i);
                            
                            
                            try{
                                
                                Class.forName(Driver);
                                Connection existingAccountConn = DriverManager.getConnection(Url, user, password);
                                String existingAccountString = "select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                                PreparedStatement existingAccountPst = existingAccountConn.prepareStatement(existingAccountString);
                                existingAccountPst.setInt(1,ExistingAccountID);
                                ResultSet existingAccountRows = existingAccountPst.executeQuery();
                                
                                ProviderCustomerData eachCustomerInfo;
                                
                                while(existingAccountRows.next()){
                                    
                                    eachCustomerInfo = new ProviderCustomerData(existingAccountRows.getInt("Customer_ID"), existingAccountRows.getString("First_Name"), existingAccountRows.getString("Middle_Name"), 
                                                existingAccountRows.getString("Last_Name"), existingAccountRows.getBlob("Profile_Pic"), existingAccountRows.getString("Phone_Number"), existingAccountRows.getDate("Date_Of_Birth"), existingAccountRows.getString("Email"));
                                    ExistingAccountsList.add(eachCustomerInfo);
                                   
                                }
                            
                            }catch(Exception e){
                                e.printStackTrace();
                            }
                            
                        }
                %>
                
                <%
                    for(int j = 0; j < ExistingAccountsList.size(); j++){
                        
                        int CustomerID = ExistingAccountsList.get(j).getUserID();
                        String FirstName = ExistingAccountsList.get(j).getFirstName();
                        String MiddleName = ExistingAccountsList.get(j).getMiddleName();
                        String LastName = ExistingAccountsList.get(j).getLastName();
                        String FullName = FirstName + " " + MiddleName + " " + LastName;
                        String Tel = ExistingAccountsList.get(j).getPhoneNumber();
                        String Email = ExistingAccountsList.get(j).getEmail();
                        String base64Image = "";
                        
                        try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = ExistingAccountsList.get(j).getProfilePic(); 
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
                        
                            //getting login name
                            String UserName = "";
                            
                            try{
                                
                                Class.forName(Driver);
                                Connection ExistingUserName = DriverManager.getConnection(Url, user, password);
                                String ExistingUserNameString = "Select UserName from ProviderCustomers.UserAccount where CustomerId = ?";
                                PreparedStatement ExistingUserNamePst = ExistingUserName.prepareStatement(ExistingUserNameString);
                                ExistingUserNamePst.setInt(1, CustomerID);
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
