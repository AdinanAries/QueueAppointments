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
        
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        
        <title>Queue</title>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
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
            
        <div id="header" style='display: block;'>
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="LoginPageToQueue" style=" color: black;"><image class='mobileLogo' src="QueueLogo.png" style="margin-top: 5px;"/></a>
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
                <div style="text-align: center;"><div id="LoginHomeBtn" style="margin: auto; margin-bottom: 30px; color: white; padding: 5px 20px; border-radius: 4px; width: fit-content;"><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="LoginPageToQueue" style=" color: white;">
                            <p style="color: white;">
                                <i class="fa fa-home" style="font-size: 20px; color: green;"></i>
                                Go to home page
                            </p>
                        </a></div></div>
                        
                <center><h4 style = "margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                  
                <form id="LoginForm" name="login" action="LoginControllerMain" method="POST" style="border-radius: 4px; width: fit-content; padding: 20px; padding-left: 5px; padding-right: 5px; max-width: 310px; min-height: 300px;"><table border="0"> 
                            <center><h2 style="margin-bottom: 40px;">Login here</h2></center>
                            <%if(Message != null){%>
                            <p style="margin: auto; max-width: 350px; margin-bottom: 15px;"><i class="fa fa-exclamation-triangle" style="color: orange;"></i> <span style="margin: auto;"><%=Message%></span></p>
                            <%}%>
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="LoginPageUserNameFld" placeholder="Enter username here" type="text" name="username" value="" size="29" style=" border-radius: 4px;"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder='Enter password here' type="password" name="password" value="" size="28" style=" border-radius: 4px;"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn" />
                        <input id="loginPageBtn" class="button" type="submit" onclick="document.getElementById('PageLoader').style.display = 'block';" value="Login" name="submitbtn" />
                            <center><h5 id="toggleShowFGPassDivLnk" onclick="showForgotPassDiv();" style="width: 200px; color: darkblue; cursor: pointer; margin: 10px; padding: 4px; margin-top: 50px;">forgot my password</h5></center>
                
                <h5  style = "margin: 10px;" ><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="SignUpPage.jsp" style="color: darkblue; padding: 4px;">I don't have a user account</a></h5>
                
                </form>
                
                <center><div id="forgotPassDiv" style="display: none; border-radius: 4px; width: fit-content; padding: 20px; padding-left: 5px; padding-right: 5px; max-width: 310px;">
                    
                    <h2 id="FGPassDivStatusTxt" style="margin-bottom: 15px; font-weight: bolder;">Enter your email below</h2>
                    
                    <fieldset class="loginInputFld">
                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                        <input id="forgotPassEmailFld" onkeyup="findAt();" type="text" value="" placeholder="Enter your email here" size="30" style="background: none; border-radius: 4px;"/>
                    </fieldset>
                    <p><input id="forgotPassBtn" style="background-color: darkslateblue; color: white; border: none; padding: 10px 5px; border-radius: 4px; margin-bottom: 10px;" type="button" value="send authorization email" /><p>
                    
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
                                                
                                                var emailMessage = `Warning: This email is sent from your Queue account due to a request to reset your password. If you haven't requested a password update, click on the following link, ( `+ ReportLink +`) to report this insident as it may be resulting from malicious activities.
                                                                    \n\nImportant Notice: It is recommended that you delete this email immediately after resetting your password.
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
                                        document.getElementById("forgotPassBtn").style.backgroundColor = "darkslateblue";
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
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                        <input id="signUpFirtNameFld" placeholder="Enter first name here" type="text" name="firstName" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                        <input id="sigUpLastNameFld" placeholder="Enter last name here" type="text" name="lastName" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                        <input onclick='checkMiddleNumber()' onkeydown="checkMiddleNumber()" id="signUpTelFld" placeholder="Enter mobile here" type="text" name="telNumber" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                        <input id="signUpEmailFld" placeholder="Enter email here" type="text" name="email" value="" size="32"/>
                                    </fieldset>
                                </td>
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
