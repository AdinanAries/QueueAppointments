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
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        
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
                
                <center><div style="margin-right:3px; max-width: 700px;">
                <h1 style="text-align: center; padding-top: 10px">User Account(s) Already Exist</h1>
                <h3 style="color: black; padding-top: 10px; padding-bottom: 20px;">Please login to your account below</h3>
                
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
                
                <div style="background-color: white; margin: 2px; margin-bottom: 5px; padding: 10px; padding: 5px; display: flex; flex-direction: column; justify-content: center;">
                    <%
                        if(base64Image != ""){
                    %>
                    <p style="text-align: center;"><img class="fittedImg" style="width: 100px; height: 100px; border-radius: 100%; margin-bottom: 10px;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/></p>
                
                    <%}%>
                <p><%=FullName%></p>
                <p><%=Tel%></p>
                <p style="margin-bottom: 5px;"><%=Email%></p>
                
                <form name="login" action="LoginControllerMain" method="POST">
                    
                    <fieldset class="loginInputFld">
                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                        <input placeholder="enter username here" type="text" name="username" value="<%=UserName%>" />
                    </fieldset>
                    <fieldset class="loginInputFld" style="margin-top: 5px;">
                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                        <input class="passwordFld" placeholder="enter password here" type="password" name="password" value="" />
                        <p style="text-align: right; margin-top: -20px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                    </fieldset>
                    <input style="background-color: darkslateblue;  padding: 10px 5px; border-radius: 4px; width: 150px;" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Login" />
                </form>
                
                <p style="clear: both;"></p>
            </div> 
            <%}%>
            </div>
                            
        </div>
        </div>
            
        <div id="newbusiness" style="height: 600px;">
            
            
            
            <!--p id='QShowNews2' onclick='document.getElementById("Extras2").style.display = "block";'
                style='margin-top: 10px; background-color: #334d81; color: white; padding: 5px; cursor: pointer;'>
                <i style='color: white; font-size: 35px;' class="fa fa-newspaper-o" width="28" height="25" ></i>
                <sup> Show News Updates</sup></p-->
            
            
            
            <p id='addBizTxt' style="text-align: center; font-size: 20px;  margin-bottom: 10px; margin-top: -10px;">
                <b>Add your business or create customer account</b>
            </p>
            
            <div id="businessdetails" >
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    <table border="0">
                        <tbody>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                        <input id="signUpFirtNameFld" placeholder="Enter first name here" type="text" name="firstName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                        <input id="sigUpLastNameFld" placeholder="Enter last name here" type="text" name="lastName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                        <input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" id="signUpTelFld" placeholder="Enter mobile here" type="text" name="telNumber" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                        <input id="signUpEmailFld" placeholder="Enter email here" type="text" name="email" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <script>
                        var TelFld = document.getElementById("signUpTelFld");
                        
                        function numberFunc(){
                            
                            var number = parseInt((TelFld.value.substring(TelFld.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFld.value = TelFld.value.substring(0, (TelFld.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFunc, 1);
                        
                        function checkMiddleNumber(){
                            
                            for(var i = 0; i < TelFld.value.length; i++){

                                var middleString = TelFld.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFld.value = TelFld.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <p style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; text-align: center;"><b>Login to view and manage your spots</b></p>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="LoginPageUserNameFld" placeholder="enter username here" type="text" name="username" value="" size="30"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="enter password here" type="password" name="password" value="" size="20"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
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
