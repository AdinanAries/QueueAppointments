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
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <title>Queue</title>
        
    </head>
  
    <%
        
        String ProviderID = ResendAppointmentData.ProviderID;
        String OrderedServices = ResendAppointmentData.SelectedServices;
        String Date = ResendAppointmentData.AppointmentDate;
        String Time = ResendAppointmentData.AppointmentTime;
        String PaymentMethod = ResendAppointmentData.PaymentMethod;
        String CreditCardNumber = ResendAppointmentData.CreditCardNumber;
        String Price = ResendAppointmentData.ServicesCost;
        
          
    %>
    
        <body>
            
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image src="QueueLogo.png" style="margin-top: 5px;"/></center>
            
        </div>
            
        <div id="content" style="">
            
            
            
            <div id="main" style="min-height: 100%;">
                
                <div style="margin-right:3px;">
                <h1 style="text-align: center;">User Account(s) Already Exist</h1>
                <h3 style="color: black; padding-top: 10px; padding-bottom: 20px;">Not Finished. Please login with your account if it is listed below or go back to previous page to finish creating new account</h3>
                
                <%
                    
                            //connection arguments
                            String Url ="jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
                            String Driver ="com.microsoft.sqlserver.jdbc.SQLServerDriver";
                            String user ="sa";
                            String password ="Password@2014";
                    
                    ArrayList<ProviderCustomerData> ExistingAccountsList = new ArrayList<>();
                    
                        for(int i = 0; i < ExistingProviderAccountsModel.AccountsList.getAccountListSize(); i++){
                            
                            int ExistingAccountID = ExistingProviderAccountsModel.AccountsList.getAccountFromList(i);
                            
                            
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
                
                <form name="login" action="LoginAndSendAppointmentController" method="POST">
                    
                    <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                    <input type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                    <input type="hidden" name="AppointmentDate" value="<%=Date%>" />
                    <input type="hidden" name="AppointmentTime" value="<%=Time%>" />
                    <input type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                    <input type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                    <input type="hidden" name="ServiceCost" value="<%=Price%>" />
                    
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
