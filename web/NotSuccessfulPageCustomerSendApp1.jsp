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
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
<meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
        <title>Queue</title>
        
    </head>
  
    <%
        
        String ProviderID ="";// ResendAppointmentData.ProviderID;
        String OrderedServices ="";// ResendAppointmentData.SelectedServices;
        String Date = ResendAppointmentData.AppointmentDate;
        String Time = ResendAppointmentData.AppointmentTime;
        String PaymentMethod = ResendAppointmentData.PaymentMethod;
        String CreditCardNumber = ResendAppointmentData.CreditCardNumber;
        String Price = ResendAppointmentData.ServicesCost;
        
        //connection arguments
        String Url ="jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String Driver ="com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String user ="sa";
        String password ="Password@2014";
        
          
    %>
    
        <body>
           
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
            
        <div id="PermanentDiv" style="">
            
            <div style="margin-top: 3px; margin-right: 10px; width: fit-content; display: flex;">
                
                <p style="color: white; text-align: justify;">
                    <i style='' class='fa fa-phone'></i>
                    +1 732-799-9546
                    <br />
                    <i class='fa fa-envelope'></i>
                    support@theomotech.com   
                </p>
            </div>
            
            <div id="ExtraDivSearch" style='padding: 3px; margin-right: 20px; margin-left: 20px; margin-top: 1.2px; border-radius: 4px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 5px 7px; font-size: 15px;" 
                           onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Search" />
                </form>
            </div>
            
            <div style="display: flex;">
                <ul style="margin-right: 5px;">
                    <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href="Queue.jsp">
                        <li style='cursor: pointer; background-color: #334d81;' class="active"><!--img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/-->
                        <i class="fa fa-home"></i>
                        Home</li></a>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/-->
                        <i class="fa fa-calendar"></i>
                        Calender</li>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/-->
                        <i class="fa fa-cog"></i>
                        Account</li>
                </ul>
            
                <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href='NewsUpadtesPage.jsp'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-newspaper-o"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">News</span></p>
                    </div>
                </a>
                
                <a href="Queue.jsp" id='ExtraDrpDwnBtn'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-home"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">Home</span></p>
                    </div>
                </a>
                
                <!--div style="">
                        <center><div style="text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                           <i style="font-size: 34px; color: darkgrey;" class="fa fa-user-circle" aria-hidden="true"></i> 
                        </div--></center>
                </div>
            </div>
            
        <div id="container">
            
        <div id="header">
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="PageController" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
        </div>
         
        <div id="Extras">
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 5px;">News Updates from service providers</p></center>
            
            <div style="max-height: 87vh; overflow-y: auto; background-color: #b5cece;">
                <%
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(Url, user, password);
                        String newsQuery = "Select top 10 * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        int newsItems = 0;
                        
                        while(newsRec.next()){
                            
                            String base64Profile = "";
                            newsItems++;
                            
                            String ProvID = newsRec.getString("ProvID");
                            String ProvFirstName = "";
                            String ProvCompany = "";
                            String ProvAddress = "";
                            String ProvTel = "";
                            String ProvEmail = "";
                            
                            String Msg = newsRec.getString("Msg").trim();
                            String MsgPhoto = "";
                            
                            try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob Pic = newsRec.getBlob("MsgPhoto"); 
                                    InputStream inputStream = Pic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                    MsgPhoto = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){

                                }
                            

                                try{
                                    Class.forName(Driver);
                                    Connection ProvConn = DriverManager.getConnection(Url, user, password);
                                    String ProvQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                                    PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                                    ProvPst.setString(1, ProvID);
                                    
                                    ResultSet ProvRec = ProvPst.executeQuery();
                                    
                                    while(ProvRec.next()){
                                        ProvFirstName = ProvRec.getString("First_Name").trim();
                                        ProvCompany = ProvRec.getString("Company").trim();
                                        ProvTel = ProvRec.getString("Phone_Number").trim();
                                        ProvEmail = ProvRec.getString("Email").trim();
                                        
                                        try{    
                                            //put this in a try catch block for incase getProfilePicture returns nothing
                                            Blob Pic = ProvRec.getBlob("Profile_Pic"); 
                                            InputStream inputStream = Pic.getBinaryStream();
                                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                            byte[] buffer = new byte[4096];
                                            int bytesRead = -1;

                                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                outputStream.write(buffer, 0, bytesRead);
                                            }

                                            byte[] imageBytes = outputStream.toByteArray();

                                            base64Profile = Base64.getEncoder().encodeToString(imageBytes);


                                        }catch(Exception e){}
                                    }
                                    
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                                
                                try{
                                    Class.forName(Driver);
                                    Connection ProvLocConn = DriverManager.getConnection(Url, user, password);
                                    String ProvLocQuery = "select * from QueueObjects.ProvidersAddress where ProviderID = ?";
                                    PreparedStatement ProvLocPst = ProvLocConn.prepareStatement(ProvLocQuery);
                                    ProvLocPst.setString(1, ProvID);
                                    
                                    ResultSet ProvLocRec = ProvLocPst.executeQuery();
                                    
                                    while(ProvLocRec.next()){
                                        String HouseNumber = ProvLocRec.getString("House_Number").trim();
                                        String Street = ProvLocRec.getString("Street_Name").trim();
                                        String Town = ProvLocRec.getString("Town").trim();
                                        String City = ProvLocRec.getString("City").trim();
                                        String ZipCode = ProvLocRec.getString("Zipcode").trim();
                                        
                                        ProvAddress = HouseNumber + " " + Street + ", " + Town + ", " + City + " " + ZipCode;
                                    }
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                %>
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 5px;">
                        <tbody>
                            <tr style="background-color: #eeeeee;">
                                <td>
                                    <div id="ProvMsgBxOne">
                                        
                                        <div style='font-weight: bolder;'>
                                            <!--div style="float: right; width: 65px;" -->
                                                <%
                                                    if(base64Profile != ""){
                                                %>
                                                    <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                        <img class="fittedImg" id="" style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    <!--/div></center-->
                                                <%
                                                    }else{
                                                %>

                                                <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                    <img style='margin: 4px; width:35px; height: 35px; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <!--/div></center-->

                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <p><%=ProvFirstName%></p>
                                                <p style='color: red;'><%=ProvCompany%></p>
                                            </div>
                                        </div>
                                    </div>      
                                </td>
                            </tr>
                            <tr style="background-color: #eeeeee;">
                                <td style="padding: 0;">
                                    <div style="display: flex; flex-direction: row; justify-content: space-between; padding: 5px; padding-top: 0;">
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="mailto:<%=ProvEmail%>">
                                                <i style="font-size: 20px;" class="fa fa-envelope" aria-hidden="true"></i> Mail
                                            </a>  
                                        </p>
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="tel:<%=ProvTel%>">
                                                <i style="font-size: 20px;" class="fa fa-mobile" aria-hidden="true"></i> Call
                                            </a>
                                        </p>
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="https://maps.google.com/?q=<%=ProvAddress%>" target="_blank">
                                                <i style="font-size: 20px;" class="fa fa-location-arrow" aria-hidden="true"></i> Map
                                            </a>
                                        </p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p style='font-family: helvetica; text-align: justify; padding: 3px;'><%=Msg%></p>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 0;">
                                    <div>
                                        <%if(MsgPhoto.equals("")){%>
                                        <center><img src="view-wallpaper-7.jpg" width="100%" alt="view-wallpaper-7"/></center>
                                        <%} else{ %>
                                        <center><img src="data:image/jpg;base64,<%=MsgPhoto%>" width="100%" alt="NewsImage"/></center>
                                        <%}%>

                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
            <%
                        if(newsItems > 10)
                            break;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
            %>
            </div>
            </div>
            
        <div id="content" style="">
            
            
            
            <div id="main" style="min-height: 100%;">
                
                <div style="margin-right:3px;">
                <h1 style="text-align: center;">User Account(s) Already Exist</h1>
                <h3 style="color: black; padding-top: 10px; padding-bottom: 20px;">Not Finished. Please login with your account if it is listed below or go back to previous page to finish creating new account</h3>
                
                <%
                    
                            int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
                    
                        ArrayList<ProviderCustomerData> ExistingAccountsList = new ArrayList<>();
                        
                        //ArrayList<ProviderCustomerData> ExistingAccountsList = new ArrayList<>();
                        ArrayList localList = null;
                        try{
                            localList = ExistingProviderAccountsModel.SignupUserList.get(UserIndex).getList();
                        }catch(Exception e){

                        }
                    
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
    </div>                    
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/ActivateBkAppBtn.js"></script>
    
</html>
