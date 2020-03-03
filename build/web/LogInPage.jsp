<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>

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
        
        <title>Queue</title>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ccccff" />
        
    </head>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
        
        try{
            
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
            
        }catch(Exception e){
            response.sendRedirect("Queue.jsp");
        }
        
        String Message = "";
        
        try{
            Message = request.getParameter("Message");
            
        }catch(Exception e){
            /*e.printStackTrace();*/
        }
        
        /*try{
        
        int UserID = 0;
        
        int UserIndex = Integer.parseInt(session.getAttribute("UserIndex").toString());
        
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        if(tempAccountType.equals("CustomerAccount"))
            UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        if(tempAccountType.equals("BusinessAccount")){
            request.setAttribute("UserIndex", UserIndex);
            request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        }
        
        else if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");
        }catch(Exception e){}*/
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
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
                <a onclick="document.getElementById('PageLoader').style.display = 'block';"  href="Queue.jsp">
                    <li onclick="" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Home</li></a>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
        
        </div>
        
        <div id="container">
            
        <div id="header" style='display: block;'>
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="LoginPageToQueue" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
            
            <!--cetnter><p> </p></cetnter>
            <center><a onclick="document.getElementById('PageLoader').style.display = 'block';" href=""><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find A Line Spot Now!</h3></center-->
        </div>
            
            <div id="Extras">
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 5px;">Updates from service providers</p></center>
            
            <div style="max-height: 87vh; overflow-y: auto;">
                <%
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
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
                                    Connection ProvConn = DriverManager.getConnection(url, User, Password);
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
                                    Connection ProvLocConn = DriverManager.getConnection(url, User, Password);
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
            
        <div id="content">
            
            <div id="nav">
                
                <!--h3><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h3>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 15px;">
                <center><div id="LoginHomeBtn" style="margin-bottom: 30px; color: white; background-color: #3d6999; padding: 5px 20px; border-radius: 4px; width: fit-content;"><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="LoginPageToQueue" style=" color: white;">
                            <img src="icons/icons8-home-50.png" alt="" style="width: 40px; height: 40px;"/>
                            <p>Home</p>
                        </a></div></center>
                        
                <center><h4 style = "margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                  
                <form id="LoginForm" name="login" action="LoginControllerMain" method="POST" style="background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 20px; max-width: 300px; min-height: 300px; border: #3d6999 1px solid;"><table border="0"> 
                            <center><h2 style="margin-bottom: 40px;">Login here</h2></center>
                            <%if(Message != null){%>
                                <center><h4 style="color: brown; margin-bottom: 15px; max-width: 350px;"><%=Message%></h4></center>
                            <%}%>
                        <table>
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder='enter your password here' type="password" name="password" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn" />
                        <input id="loginPageBtn" class="button" type="submit" onclick="document.getElementById('PageLoader').style.display = 'block';" value="Login" name="submitbtn" />
                            <center><h5 id="toggleShowFGPassDivLnk" onclick="showForgotPassDiv();" style="width: 200px; color: #254386; cursor: pointer; margin: 10px; padding: 4px; margin-top: 50px;">forgot my password</h5></center>
                
                <h5  style = "margin: 10px;" ><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="SignUpPage.jsp" style="color: #254386; padding: 4px;">I don't have a user account</a></h5>
                
                </form>
                
                <center><div id="forgotPassDiv" style="display: none; background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 20px; max-width: 300px; border: #3d6999 1px solid;">
                    
                    <h2 id="FGPassDivStatusTxt" style="margin-bottom: 15px; font-weight: bolder;">Enter your email below</h2>
                    
                    <input id="forgotPassEmailFld" onmousemove="findAt();" type="text" value="" placeholder="enter you email address" size="30" style="background-color: #6699ff; background-color: #d9e8e8; border-radius: 4px;"/>
                    <p><input id="forgotPassBtn" style="background-color: pink; border: 1px solid black; padding: 10px; border-radius: 4px; margin-bottom: 10px;" type="button" value="send authorization email" /><p>
                    
                    <h2 style="text-align: center; margin-top: 15px; cursor: pointer" onclick="showLogin()">Click here to login</h2>
                        <script>
                            
                            function showLogin(){
                                document.getElementById("forgotPassDiv").style.display = "none";
                                document.getElementById("LoginForm").style.display = "block";
                            }
                            
                            $(document).ready(function(){
                                
                                $("#forgotPassBtn").click(function(event){
                                    document.getElementById('PageLoader').style.display = 'block';
                                    var Email = document.getElementById("forgotPassEmailFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "FGPasswordEmailExists",
                                        data: "Email="+Email,
                                        success: function(result){
                                            //alert(result);
                                            document.getElementById('PageLoader').style.display = 'none';
                                            var JObject = JSON.parse(result);
                                            
                                            if(JObject.Exists !== "false"){
                                                
                                                var AccountType = JObject.AccountType;
                                                
                                                var URLLink = ('http://localhost/QueueWebAppPrototype/ResetPasswordPage.jsp?Email='+Email);    
                                                URLLink = (URLLink + '%26AccountType='+ AccountType);
                                                
                                                var ReportLink = "http://localhost/QueueSpamReport.jsp?UserEmail="+Email;
                                                
                                                var emailMessage = `Warning: This email is sent from your Queue account due to a request to reset your password. If you haven't requested a password update, then click on the following link, ( `+ ReportLink +`) to report this insident as it may be resulting from malicious activities.
                                                                    \n\nImportant Notice: Please delete this email immediately after resetting your password.
                                                                    \n\nClick on the following link to reset your password: `+ URLLink;
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "QueueMailer",
                                                    data: "to="+Email+"&subject=Queue%20Password%20Update&msg="+emailMessage,
                                                    success: function(result){
                                                        
                                                    }
                                                });
                                                
                                                document.getElementById("FGPassDivStatusTxt").innerHTML = "authorization link has been sent to " + Email;
                                                document.getElementById("FGPassDivStatusTxt").style.backgroundColor = "green";
                                                document.getElementById("FGPassDivStatusTxt").style.color = "white";
                                                document.getElementById("forgotPassBtn").style.display = "none";
                                                document.getElementById("forgotPassEmailFld").style.display = "none";
                                                
                                            }else{
                                                document.getElementById("FGPassDivStatusTxt").innerHTML = "this email is not associated with any Queue account";
                                                document.getElementById("FGPassDivStatusTxt").style.backgroundColor = "red";
                                                document.getElementById("FGPassDivStatusTxt").style.color = "white";
                                            }
                                        }
                                    });
                                    
                                });
                            });
                        </script>
                        
                        
                        <script>
                            
                                var AtFound = false;
                                var DotFound = false;

                                function findAt(){
                                    
                                    var email = document.getElementById("forgotPassEmailFld").value;
                                    
                                    if(email.includes('@')){
                                        AtFound = true;
                                    }else{
                                        AtFound = false;
                                    }
                                    if(email.includes('.')){
                                        DotFound = true;
                                    }else{
                                        DotFound = false;
                                    }
                                }
                            
                            setInterval(function(){
                                
                                if(document.getElementById("forgotPassEmailFld").value === ""){
                                    document.getElementById("forgotPassBtn").style.backgroundColor = "darkgrey";
                                    document.getElementById("forgotPassBtn").disabled = true;
                                    AtFound = false;
                                    DotFound = false;
                                }else{
                                    if(AtFound && DotFound){
                                        document.getElementById("forgotPassBtn").style.backgroundColor = "pink";
                                        document.getElementById("forgotPassBtn").disabled = false;
                                        //document.getElementById("FGPassDivStatusTxt").innerHTML = "you may send verification code";
                                    }else{
                                        document.getElementById("FGPassDivStatusTxt").innerHTML = "this email must be associated to your queue account";
                                        document.getElementById("forgotPassBtn").style.backgroundColor = "darkgrey";
                                        document.getElementById("forgotPassBtn").disabled = true;
                                    }
                                    
                                }
                                
                            },1);
                            
                            function showForgotPassDiv(){
                                if(document.getElementById("forgotPassDiv").style.display === "none"){
                                    document.getElementById("LoginForm").style.display = "none";
                                    document.getElementById("forgotPassDiv").style.display = "block";
                                }else{
                                    document.getElementById("LoginForm").style.display = "block";
                                    document.getElementById("forgotPassDiv").style.display = "none";
                                    document.getElementById("toggleShowFGPassDivLnk").innerHTML = "forgot my password";
                                }
                            }
                            
                        </script>
                        
                    </div></center>
                
                </div></center>
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
            
            </div>
                
        </div>
                
        <div id="newbusiness" style="height: 525px;">
            
            <center><h2 style="padding-top: 30px; margin-bottom: 20px; color: #000099">Sign-up to add your business or to find a spot</h2></center>
            
            <div id="businessdetails">
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    
                    <table border="0">
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
                                <td><input onclick='checkMiddleNumber()' onkeydown="checkMiddleNumber()" id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="37"/></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Submit" name="submitBtn" />
                </form></center>
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
                        
                </script>
            </div>
            
            </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
