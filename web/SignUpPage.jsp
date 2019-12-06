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
        <title>Queue</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link rel="stylesheet" href="/resources/demos/style.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
       
         
    </head>
    
    <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String Driver = "";
        String User = "";
        String url = "";
        String Password = "";
        
        try{
            Driver = config.getInitParameter("databaseDriver");
            url = config.getInitParameter("databaseUrl");
            User = config.getInitParameter("user");
            Password = config.getInitParameter("password");
        }catch(Exception e){
            response.sendRedirect("Queue.jsp");
        }
        
        String fName = "";
        String lName = "";
        String telNumber = "";
        String email = "";
        
        try{
            
            fName = request.getParameter("firstName");
            lName = request.getParameter("lastName");
            telNumber = request.getParameter("telNumber");
            email = request.getParameter("email");
            
        }
        catch(Exception e){
            
        }
        
        if(fName == null || fName.equalsIgnoreCase("enter your first name")){
            fName = "";
        }
        if(lName == null || lName.equalsIgnoreCase("enter your last name")){
            lName = "";
        }
        if(telNumber == null || telNumber.equalsIgnoreCase("enter your telephone/mobile number here")){
            telNumber = "";
        }
        if(email == null || email.equalsIgnoreCase("enter your email address here")){
            email = "";
        }
        
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
        
        </div>
        
        <div id="container">
            
        <div id="header" style='display: block;'>
            
            <cetnter><p> </p></cetnter>
            <center><a href="LoginPageToQueue" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find A Line Spot Now!</h3></center>
            
        </div>
         
        <div id="Extras">
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Updates from service providers</p></center>
            
            <div style="max-height: 600px; overflow-y: auto;">
                <%
                    String base64Profile = "";
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        int newsItems = 0;
                        
                        while(newsRec.next()){
                            
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
                        <tr style="background-color: #333333;">
                            <td>
                                <div id="ProvMsgBxOne">
                                    
                                    <div style='font-weight: bolder; margin-bottom: 4px; color: #eeeeee;'>
                                            <!--div style="float: right; width: 65px;" -->
                                                <%
                                                    if(base64Profile != ""){
                                                %>
                                                    <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                        <img id="" style="margin: 4px; width:35px; height: 35px; border-radius: 100%; border: 1px solid green; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    <!--/div></center-->
                                                <%
                                                    }else{
                                                %>

                                                <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                    <img style='width:35px; height: 35px; border: 1px solid black; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <!--/div></center-->

                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <p><%=ProvFirstName%></p>
                                                <p style='color: violet;'><%=ProvCompany%></p>
                                            </div>
                                        </div>
                                    
                                    <%if(MsgPhoto.equals("")){%>
                                    <center><img src="view-wallpaper-7.jpg" width="98%" alt="view-wallpaper-7"/></center>
                                    <%} else{ %>
                                    <center><img src="data:image/jpg;base64,<%=MsgPhoto%>" width="98%" alt="NewsImage"/></center>
                                    <%}%>
                                    
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style='font-family: helvetica; text-align: justify; border: 1px solid #d8d8d8; padding: 3px;'><%=Msg%></p>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Contact:</p>
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
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 10px;">
                        
                <center><h2 style="margin-bottom: 20px;">Sign-up Here</h2></center>
                
                <center><div id="accountTypeOptions">
                <center><h3 style="color: white; margin-bottom: 10px; ">Choose account type</h3></center>
                <table>
                    <tbody>
                        <tr>
                            <td id="ShowBizForm" onclick="toggleHideAddBusinessForm()" style="padding-right: 45px; border-right: 1px solid black; cursor: pointer;"><center><img src="icons/icons8-business-50.png" width="50" height="50" alt="icons8-business-50"/><p>Business</p>
                                </center></td>
                        
                            <td id="ShowCustForm" onclick="toggleHideAddCustomerForm()" style="padding-left: 45px; cursor: pointer;" ><center><img src="icons/icons8-user-50 (1).png" width="50" height="50" alt="icons8-user-50 (1)"/><p>Customer</p>

                                </center></td>
                        </tr>
                    </tbody>
                </table>
                </div><center>
                    
                <div class="scrolldiv" style=" height: 450px; overflow-y: auto; width: auto;">
                    
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px; border-bottom: 1px solid aqua;"></h4></center>
                
                <center><h3 style="color: white; margin-bottom: 15px; background-color: red;"></h3></center>
                
                <form style="display: none;" name="customerForm" id="customerForm" action="CustomoerSignUpController" method="POST">
                    <p style="color: white; font-size: 20px;">Add Customer Account<p>
                    <center><h2 style="margin-bottom: 20px;">Provide your information below</h2></center>
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input type="text" id="firstName" name="firstName" value="<%=fName%>" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Middle Name</p><input type="text" id="middleName" name="middleName" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input type="text" id="lastName" name="lastName" value="<%=lName%>" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <center><p id='CustEmailStatus' style='color: white; display: none; text-align: center;'></p></center>
                                        <p>Email</p><input onchange='CustSetVerifyFalse();' onfocusout='CustCloseEmailVerify();' onfocus='CustShowEmailVerify();' type="text" id="visibleEmail" name="email" value="<%=email%>" size="37" style="background-color: #6699ff;"/>
                                        <input id='email' type='hidden' value=''/>
                                        <div id='CustEmailVeriDiv' style='display: none; background-color: blue; padding: 10px; margin: 5px;'>
                                            <div id='CustsendVerifyDiv'>
                                                <center><input id='CustSendverifyEmailBtn' type='button' value='Click here to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; height: 20px;'/></center>
                                            </div>
                                            <div id='CustverifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='CustvCodeStatus' style='padding-left: 5px; color: white; max-width: 250px;'>We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input id="CustEmailConfirm" type="text" style="border: 1px solid black;" /></p>
                                            </div>
                                            <center><input id='CustverifyEmailBtn' onclick="CustVerifyCode();" type='button' value='Enter verification code and click here' style='color: white; background-color: #334d81; border: 0; width: 95%; height: 20px;'/></center>
                                            <script>
                                                
                                                var CustEmailVerified = false;
                                                var CustPageJustLoaded = true;
                                                
                                                if(document.getElementById("visibleEmail").value !== ""){
                                                    //Execute this code when page loads with information from prio page
                                                    CustPageJustLoaded = false;
                                                }
                                                
                                                setInterval(function(){
                                                    
                                                    if(!CustPageJustLoaded){
                                                        
                                                        if(CustEmailVerified){
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            document.getElementById("CustEmailStatus").style.backgroundColor = "green";
                                                            document.getElementById("CustEmailStatus").innerHTML = "Your email has been verified";
                                                            document.getElementById("email").value = document.getElementById("visibleEmail").value;
                                                            document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                            document.getElementById("CustEmailStatus").innerHTML = "Plase verify your email";
                                                            document.getElementById("email").value = "";
                                                        }
                                                    }
                                                    
                                                }
                                                ,1);
                                                
                                                var CustSetVerifyFalse = function(){
                                                    CustEmailVerified = false;
                                                    document.getElementById("CustSendverifyEmailBtn").style.display = "block";
                                                };
                                                var CustShowEmailVerify = function(){
                                                    document.getElementById("CustEmailVeriDiv").style.display = "block";
                                                    //document.getElementById("provSignUpBtn").style.display = "none";
                                                };
                                                var CustCloseEmailVerify = function(){
                                                    CustPageJustLoaded = false;
                                                    if(document.getElementById("visibleEmail").value === ""){
                                                        document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        document.getElementById("CustEmailStatus").innerHTML = "Please enter a valid email";
                                                        document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var CustVeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#CustSendverifyEmailBtn").click(function(event){
                                                        
                                                        CustVeriCode = Math.floor(100000 + Math.random() * 900000);
                                                        CustVeriCode = CustVeriCode + "";
                                                        
                                                        document.getElementById("CustvCodeStatus").innerHTML = "Verification Code has been sent to your Email";
                                                        document.getElementById("CustvCodeStatus").style.backgroundColor = "green";
                                                        document.getElementById("CustSendverifyEmailBtn").style.display = "none";
                                                        
                                                        var to = document.getElementById("visibleEmail").value;
                                                        var Message = CustVeriCode + ' is your Queue verification code';
                                                        
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "QueueMailer",
                                                            data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                            success: function(result){
                                                                
                                                            }
                                                        });
                                                        
                                                    });
                                                });
                                                
                                                var CustVerifyCode = function () {
                                                    
                                                    if(document.getElementById("CustEmailConfirm").value === CustVeriCode){
                                                        CustEmailVerified = true;
                                                    }
                                                    else{
                                                        document.getElementById("CustvCodeStatus").innerHTML = "Make sure verification code is entered or is correct";
                                                        document.getElementById("CustvCodeStatus").style.backgroundColor = "red";
                                                    }
                                                        
                                                };
                                            </script>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><p>Phone Number</p><input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" type="text" id="phoneNumber" name="phoneNumber" value="<%=telNumber%>" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                    <script>
                        var TelFld = document.getElementById("phoneNumber");
                        
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
                    
                    <h2 style="margin: 5px; margin-top: 30px; ">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>User Name</p><input onkeyup="setPasswordsZero();" onchange="CustUserNameCheck();" type="text" id="userName" name="userName" value="" size="37" style="background-color: #6699ff;"/>
                                        <center><p id="CustUserNameStatus" style="color: white; background-color: red; text-align: center; max-width: 250px;"></p></center></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input type="password" id="firstPassword" name="firstPassword" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password (Again)</p><input type="password" id="secondPassword" name="secondPassword" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="width: 180px; background-color: red; color: white;" id="passwordStatus"></p></center>
                        <center><p style="width: 180px; background-color: green; color: white;" id="formStatus"></p></center>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input class="button" id="AddUserSignUpBtn" type="submit" value="Signup" name="submitbtn" />
                    </form>
                                
                    <script>
                                    
                        function setPasswordsZero(){
                            document.getElementById("secondPassword").value = "";
                            document.getElementById("firstPassword").value = "";
                        }
                                    
                        function CustUserNameCheck(){
                            
                            var userName = document.getElementById("userName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckCustUserNameExists",
                                data: "UserName="+userName,
                                success: function(result){
                                    if(result === "true"){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = 'Username: <span style="color: blue;">"' + userName + '"</span> is not available. Choose a different Username';
                                        document.getElementById("CustUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("userName").value = "";
                                        
                                    }else if(result === "false" && document.getElementById("userName").value !== ""){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = 'Username: <span style="color: orange;">"' + userName + '"</span> is available.';
                                        document.getElementById("CustUserNameStatus").style.backgroundColor = "green";
                                        
                                    }else if(document.getElementById("userName").value === ""){
                                        
                                        //document.getElementById("CustUserNameStatus").innerHTML = "";
                                        
                                    }
                                }
                            });
                        }  
                        
                    </script>
                    
                    <form style="overflow-x: hidden; display: none;" name="businessForm" id="businessForm" action="ProviderSignUpController" method="POST">
                    
                    <p style="color: white; font-size: 20px;">Add Business Account<p>
                    <center><h2 style="margin-bottom: 20px;">Provide your personal information below</h2></center>
                        
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input id="firstProvName" type="text" name="firstProvName" value="<%=fName%>" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Middle Name</p><input id="middleProvName" type="text" name="middleProvName" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input id="lastProvName" type="text" name="lastProvName" value="<%=lName%>" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <center><p id='BizEmailStatus' style='color: white; display: none; text-align: center;'></p></center>
                                        <p>Email</p><input onchange='SetVerifyFalse();' onfocusout='CloseEmailVerify();' onfocus='ShowEmailVerify();' id="visibleProvEmail" type="text" name="provEmail" value="<%=email%>" size="37" style="background-color: #6699ff;"/>
                                        <input id='provEmail' type='hidden' value='' />
                                        <div id='BizEmailVeriDiv' style='display: none; background-color: blue; padding: 10px; margin: 5px;'>
                                            <div id='sendVerifyDiv'>
                                                <center><input id='SendverifyEmailBtn' type='button' value='Click here to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; height: 20px;'/></center>
                                            </div>
                                            <div id='verifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='vCodeStatus' style='padding-left: 5px; color: white; max-width: 250px;'>We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input id="BizEmailConfirm" type="text" style="border: 1px solid black;" /></p>
                                            </div>
                                            <center><input id='verifyEmailBtn' onclick="VerifyCode();" type='button' value='Enter verification code and click here' style='color: white; background-color: #334d81; border: 0; width: 95%; height: 20px;'/></center>
                                            <script>
                                                
                                                var EmailVerified = false;
                                                var PageJustLoaded = true;
                                                
                                                if(document.getElementById("visibleProvEmail").value !== ""){
                                                    PageJustLoaded = false;
                                                }
                                                
                                                setInterval(function(){
                                                    
                                                    if(!PageJustLoaded){
                                                        
                                                        if(EmailVerified){
                                                            document.getElementById("BizEmailStatus").style.display = "block";
                                                            document.getElementById("BizEmailStatus").style.backgroundColor = "green";
                                                            document.getElementById("BizEmailStatus").innerHTML = "Your email has been verified";
                                                            document.getElementById("provEmail").value = document.getElementById("visibleProvEmail").value;
                                                            document.getElementById("BizEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("BizEmailStatus").style.display = "block";
                                                            document.getElementById("BizEmailStatus").style.backgroundColor = "red";
                                                            document.getElementById("BizEmailStatus").innerHTML = "Plase verify your email";
                                                            document.getElementById("provEmail").value = "";
                                                        }
                                                    }
                                                    
                                                }
                                                ,1);
                                                
                                                var SetVerifyFalse = function(){
                                                    EmailVerified = false;
                                                    document.getElementById("SendverifyEmailBtn").style.display = "block";
                                                };
                                                var ShowEmailVerify = function(){
                                                    document.getElementById("BizEmailVeriDiv").style.display = "block";
                                                    //document.getElementById("provSignUpBtn").style.display = "none";
                                                };
                                                var CloseEmailVerify = function(){
                                                    PageJustLoaded = false;
                                                    if(document.getElementById("visibleProvEmail").value === ""){
                                                        document.getElementById("BizEmailVeriDiv").style.display = "none";
                                                        document.getElementById("BizEmailStatus").innerHTML = "Please enter a valid email";
                                                        document.getElementById("BizEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var VeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#SendverifyEmailBtn").click(function(event){
                                                        
                                                        VeriCode = Math.floor(100000 + Math.random() * 900000);
                                                        VeriCode = VeriCode + "";
                                                        
                                                        document.getElementById("vCodeStatus").innerHTML = "Verification Code has been sent to your Email";
                                                        document.getElementById("vCodeStatus").style.backgroundColor = "green";
                                                        document.getElementById("SendverifyEmailBtn").style.display = "none";
                                                        
                                                        var to = document.getElementById("visibleProvEmail").value;
                                                        var Message = VeriCode + ' is your Queue verification code';
                                                        
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "QueueMailer",
                                                            data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                            success: function(result){
                                                                
                                                            }
                                                        });
                                                        
                                                    });
                                                });
                                                
                                                var VerifyCode = function () {
                                                    
                                                    if(document.getElementById("BizEmailConfirm").value === VeriCode){
                                                        EmailVerified = true;
                                                    }
                                                    else{
                                                        document.getElementById("vCodeStatus").innerHTML = "Make sure verification code is entered or is correct";
                                                        document.getElementById("vCodeStatus").style.backgroundColor = "red";
                                                    }
                                                        
                                                };
                                            </script>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p>Phone Number</p><input onclick="checkMiddleNumberProPer();" onkeydown="checkMiddleNumberProPer();" id="provPhoneNumber" type="text" name="provPhoneNumber" value="<%=telNumber%>" size="37" style="background-color: #6699ff;"/>
                                        
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                                
                        <script>
                        var TelFldProPer = document.getElementById("provPhoneNumber");
                        
                        function numberFuncProvPer(){
                            
                            var number = parseInt((TelFldProPer.value.substring(TelFldProPer.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProPer.value = TelFldProPer.value.substring(0, (TelFldProPer.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProvPer, 1);
                        
                        function checkMiddleNumberProPer(){
                            
                            for(var i = 0; i < TelFldProPer.value.length; i++){

                                var middleString = TelFldProPer.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProPer.value = TelFldProPer.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <center><h2 style="margin: 5px; margin-top: 30px;">Add your business information below</h2></center>
                        
                    <center><table border="0">
                            <tbody>
                                <tr>
                                    <td style="padding-bottom: 10px;"><p>Business Name</p><input id="businessName" type="text" name="businessName" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                
                                <tr>
                                    <td  style="padding-top: 15px; padding-left: 5px; padding-bottom: 15px; border-top: 1px solid white; border: 1px solid white;">
                                        
                                        <p style="color: white;">Business Location (Address)</p>
                                        
                                        <p style="margin: 5px; text-align: center;">Providing accurate address information<br/>will help customers locate your business</p>
                                        
                                        <h3 style="text-align: center; color: #000099;">Enter your address below</h3>
                                        
                                        <p> House<input onkeydown="checkMiddleNumberHNumber();" onclick="checkMiddleNumberHNumber();" id="HouseNumber" type="text" name="HouseNumber" placeholder='123...' value="" size="5" style="background-color: #6699ff;"/>
                                           Street:<input id="Street" type="text" name="Street" placeholder='street/avenue' value="" size="18" style="background-color: #6699ff;"/></p>
                                        <p>Town:<input id="Town" type="text" name="Town" placeholder='town' value="" size="32" style="background-color: #6699ff;"/></p>
                                        <p>City:<input id="City" type="text" name="City" placeholder='city' value="" size="18" style="background-color: #6699ff;"/>
                                            Zip Code:<input onclick="checkMiddleNumberZCode();" onkeydown="checkMiddleNumberZCode();" id="ZCode" type="text" name="ZCode" placeholder='123...' value="" size="5" style="background-color: #6699ff;"/></p>
                                        <p>Country:<input id="Country" type="text" name="Country" placeholder='country' value="" size="30" style="background-color: #6699ff;"/></p>
                                        
                                        <p><input id="businessLocation" type="text" name="businessLocation" value="" readonly size="37" style="background-color: #6699ff; border: 1px solid black;"/></p>
                                       </td>
                                </tr>
                                
                                <script>
                                    var HouseNumber = document.getElementById("HouseNumber");

                                    function numberFuncHNumber(){

                                        var number = parseInt((HouseNumber.value.substring(HouseNumber.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            HouseNumber.value = HouseNumber.value.substring(0, (HouseNumber.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncHNumber, 1);

                                    function checkMiddleNumberHNumber(){

                                        for(var i = 0; i < HouseNumber.value.length; i++){

                                            var middleString = HouseNumber.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                HouseNumber.value = HouseNumber.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <script>
                                    var ZCode = document.getElementById("ZCode");

                                    function numberFuncZCode(){

                                        var number = parseInt((ZCode.value.substring(ZCode.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            ZCode.value = ZCode.value.substring(0, (ZCode.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncZCode, 1);

                                    function checkMiddleNumberZCode(){

                                        for(var i = 0; i < ZCode.value.length; i++){

                                            var middleString = ZCode.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                ZCode.value = ZCode.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <tr>
                                    <td style="padding-top: 10px;"><p>Business Email</p><input id="businessEmail" type="text" name="businessEmail" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Business Telephone</p><input onclick="checkMiddleNumberProBiz();" onkeydown="checkMiddleNumberProBiz();" id="businessTel" type="text" name="businessTel" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><select id="businessType" name="businessType">
                                            <option>Business Type</option>
                                            <option>Barber Shop</option>
                                            <option>Beauty Salon</option>
                                            <option>Day Spa</option>
                                            <option>Dentist</option>
                                            <option>Dietician</option>
                                            <option>Eyebrows and Eyelashes</option>
                                            <option>Hair Removal</option>
                                            <option>Hair Salon</option>
                                            <option>Holistic Medicine</option>
                                            <option>Home Services</option>
                                            <option>Makeup Artist</option>
                                            <option>Massage</option>
                                            <option>Medical Aesthetician</option>
                                            <option>Medical Center</option>
                                            <option>Nail Salon</option>
                                            <option>Personal Trainer</option>
                                            <option>Pet Services</option>
                                            <option>Physical Therapy</option>
                                            <option>Piercing</option>
                                            <option>Podiatry</option>
                                            <option>Tattoo Shop</option>
                                            <option>Other</option>
                                        </select></td>
                                </tr>
                                <tr>
                                    <td><input id="otherBusinessType" type="text" name="otherBusinessType" value="Specify business type here if not in categories" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table></center>
                    
                    <script>
                        var TelFldProBiz = document.getElementById("businessTel");
                        
                        function numberFuncProBiz(){
                            
                            var number = parseInt((TelFldProBiz.value.substring(TelFldProBiz.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProBiz.value = TelFldProBiz.value.substring(0, (TelFldProBiz.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProBiz, 1);
                        
                        function checkMiddleNumberProBiz(){
                            
                            for(var i = 0; i < TelFldProBiz.value.length; i++){

                                var middleString = TelFldProBiz.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProBiz.value = TelFldProBiz.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>

                    <h2 style="margin: 5px; margin-top: 30px; ">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>User Name</p><input onkeyup="setProvPasswordsZero();" onchange="ProvUserNameCheck();" id="provUserName" type="text" name="provUserName" value="" size="37" style="background-color: #6699ff;"/>
                                        <center><p id="provUserNameStatus" style="background-color: red; color: white; text-align: center; max-width: 250px;"></center></p></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input id="firstProvPassword" type="password" name="firstProvPassword" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password (Again)</p><input id="secondProvPassword" type="password" name="secondProvPassword" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="width: 180px; background-color: red; color: white;" id="provPasswordStatus"></p></center>
                        <center><p style="width: 180px; background-color: green; color: white;" id="provFormStatus"></p></center>
                        
                        <p style='min-width: 350px;'><input class="button" type="reset" value="Reset" name="resetbtn"/>
                            <input id="provSignUpBtn" class="button" type="submit" value="Sign up" name="provSignUpBtn" /></p>
                    </form>
                                
                    <script>
                        
                        function setProvPasswordsZero(){
                            document.getElementById("secondProvPassword").value = "";
                            document.getElementById("firstProvPassword").value = "";
                        }
                        
                        function ProvUserNameCheck(){
                            
                            var userName = document.getElementById("provUserName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckProvUserNameExist",
                                data: "UserName="+userName,
                                success: function(result){
                                    if(result === "true"){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = 'Username: <span style="color: blue;">"' + userName + '"</span> is not available. Choose a different Username';
                                        document.getElementById("provUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("provUserName").value = "";
                                        
                                        
                                    }else if(result === "false" && document.getElementById("provUserName").value !== ""){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = 'Username: <span style="color: orange;">"' + userName + '"</span> is available.';
                                        document.getElementById("provUserNameStatus").style.backgroundColor = "green";
                                        
                                    }else if(document.getElementById("provUserName").value === ""){
                                        
                                        //document.getElementById("provUserNameStatus").innerHTML = "";
                                        
                                    }
                                    
                                }
                            });
                        }  
                        
                    </script>
                
                <!--center><h4 style="margin-top: 15px;">Click here to go to Queue home page</a></h4></center-->
                </div>
                </div></center>
                
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px; border-bottom: 1px solid aqua;"></h4></center>
                <center><p id="alreadyAccountStatus" ><a style="color: #000099;" href="LogInPage.jsp">Already have an account? <span style="color: #ffffff">Login now.</span></a></p></center>
            </div>
            
        </div>
                
        <div id="newbusiness" style=" height: 73%;">
            
        <center><div id ="logindetailsSignUP" style="padding-top: 60px;">
                <center><h1 style='color: darkblue; margin-bottom: 40px;'>Already have an account</h1></center>
                
                <center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: white; background-color: blue; border: 1px solid black; padding: 4px;">Click here to go to Queue home page</a></h2></center>
                
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px; border-bottom: 1px solid mediumblue;"></h4></center>
                  
                <center><h2 style="margin-bottom: 20px;">Login here</h2></center>
                
                <form name="login" action="LoginControllerMain" method="POST"><table border="0"> 
                        
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="40" style="background-color: #ccccff;"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder='enter your password here' type="password" name="password" value="" size="40" style="background-color: #ccccff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px; border-bottom: 1px solid mediumblue;"></h4></center>
                </div></center>
            
            </div>
        </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/signUpPageScript.js"></script>
    <script src="scripts/script.js"></script>
    <script src="scripts/CollectAddressInfo.js"></script>
    
</html>
