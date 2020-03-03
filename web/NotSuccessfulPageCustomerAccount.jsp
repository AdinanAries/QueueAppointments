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
        <meta name="apple-mobile-web-app-status-bar" content="#ccccff" />
        
        <title>Queue</title>
        
    </head>
  
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
      
        String Url = "";
        String Driver = "";
        String user = "";
        String password = "";
        
        //connection arguments
        try{
            Url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            user = config.getServletContext().getAttribute("DBUser").toString();
            password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            response.sendRedirect("SignUpPage.jsp");
        }
    %>
    
        <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0;">
            
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
            
        <div id="PermanentDiv" style="">
            
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 70px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>
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
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0; padding-left: 10px;">
                        <img style='background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" width="30" height="30" alt="icons8-user-filled-100"/>
                    </div></center>
            </div>
        
            <ul>
                <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp">
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
                           onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Search" />
                </form>
            </div>
                <p style='clear: both;'></p>
            
        </div>

            
        <div id="container">
            
        <div id="header">
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="PageController" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
        </div>
         
        <div id="Extras">
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 5px;">News Updates from service providers</p></center>
            
            <div style="max-height: 87vh; overflow-y: auto;">
                <%
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(Url, user, password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
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
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 3px;">
                    <tbody>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <div id="ProvMsgBxOne">
                                    
                                    <div style='font-weight: bolder; margin-bottom: 4px;'>
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
                                    
                                    <%if(MsgPhoto.equals("")){%>
                                    <center><img src="view-wallpaper-7.jpg" width="100%" alt="view-wallpaper-7"/></center>
                                    <%} else{ %>
                                    <center><img src="data:image/jpg;base64,<%=MsgPhoto%>" width="100%" alt="NewsImage"/></center>
                                    <%}%>
                                    
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style='font-family: helvetica; text-align: justify; padding: 3px;'><%=Msg%></p>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <p style="color: seagreen;"><img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                    <%=ProvEmail%></p>
                                <p style="color: seagreen;"><img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                    <%=ProvTel%></p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style="color: seagreen;"><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                    <%=ProvCompany%></p>
                                <p style="color: seagreen;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                                    <%=ProvAddress%></p>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <!--p><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Previous'><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Next' /></p-->
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
                
                <center><div style="margin-right:3px; max-width: 700px;">
                <h1 style="text-align: center;">User Account(s) Already Exist</h1>
                <h3 style="color: black; padding-top: 10px; padding-bottom: 20px;">Not Finished. Please login with your account if it is listed below or go back to previous page to finish creating new account</h3>
                
                <%
                    
                    int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
                    
                    ArrayList<ProviderCustomerData> ExistingAccountsList = new ArrayList<>();
                    ArrayList localList = null;
                    try{
                        localList = ExistingProviderAccountsModel.SignupUserList.get(UserIndex).getList();
                    }catch(Exception e){
                        
                    }
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
                    <img class="fittedImg" style="float: left;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                
                    <%}%>
                <p><%=FullName%></p>
                <p><%=Tel%></p>
                <p><%=Email%></p>
                
                <p style="margin-top: 10px; color: tomato;">Login</p>
                
                <form name="login" action="LoginControllerMain" method="POST">
                    <input style="background-color: white; border: 1px solid black; padding: 2px;" placeholder="enter user name here" type="hidden" name="username" value="<%=UserName%>" />
                    <input style="background-color: white; border: 1px solid black; padding: 2px; width: 50%;" placeholder="enter password here" type="password" name="password" value="" />
                    <input style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Login" />
                </form>
                
                <p style="clear: both;"></p>
            </div> 
            <%}%>
            </div>
                            
        </div>
        </div>
            
        <div id="newbusiness">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Sign-up with Queue to add your business or to find a line spot</h2></center>
            
            <div id="businessdetails">
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST"><table border="0">
                        <tbody>
                            <tr>
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input id="signUpFirtNameFld" placeholder="enter your first name" type="text" name="firstName" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="sigUpLastNameFld" placeholder="enter your last name" type="text" name="lastName" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="37"/></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
                    <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Already with Queue (Login to view and manage your spots)</h2></center>
                    
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="37"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="enter your password" type="password" name="password" value="" size="37"/></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
            
        </div>
                           
        <div id="footer" style="clear: both;">
            <p>AriesLab &copy;2019</p>
        </div>
                            
    </div>               
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/ActivateBkAppBtn.js"></script>
    
</html>
