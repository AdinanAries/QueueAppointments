<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
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
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <meta name="viewport" content="width=device-width, initial-scale=1">
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
        
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        String Message = "";
        String Email = "";
        String AccountType = "";
        
        try{
            AccountType = request.getParameter("AccountType");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Email = request.getParameter("Email");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Message = request.getParameter("Message");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(Message == null){
            Message = "Please enter your existing username and your new password";
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
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><a href="LoginPageToQueue"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find Your Spot Now!</h3></center>
            
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
                        <tr style="background-color: #333333;">
                            <td>
                                <div id="ProvMsgBxOne">
                                    <div style='font-weight: bolder; margin-bottom: 4px; color: #eeeeee;'>
                                            <!--div style="float: right; width: 65px;" -->
                                                <%
                                                    if(base64Profile != ""){
                                                %>
                                                    <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                        <img class="fittedImg" id="" style="margin: 4px; width:35px; height: 35px; border-radius: 100%; border: 1px solid green; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    <!--/div></center-->
                                                <%
                                                    }else{
                                                %>

                                                <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                    <img style='margin: 4px; width:35px; height: 35px; border: 1px solid black; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <!--/div></center-->

                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <p><%=ProvFirstName%></p>
                                                <p style='color: violet;'><%=ProvCompany%></p>
                                            </div>
                                        </div>
                                    <!--p style='font-weight: bolder; margin-bottom: 4px;'><span style='color: #eeeeee;'><=ProvFirstName%> - <=ProvCompany%></p></p-->
                                    
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
                
                <h3><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h3>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center>
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 15px;">
                <!--center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: white; background-color: blue; border: 1px solid black; padding: 4px;">Click here to go to Queue home page</a></h2></center>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center-->
                
                <%if(Message != null){%>
                    <center><h4 style="color: white; margin-bottom: 15px; background-color: green; max-width: 350px;"><%=Message%></h4></center>
                <%}%>
                    
                <center><h2 style="margin-bottom: 20px;">Reset Your Password</h2></center>
                
                <%if(AccountType.equals("Both")){%>
                    <p style="color: white; margin-bottom: 10px; max-width: 350px; background-color: red;">Your email is associated with a business and a customer account.
                        Choose which account-type to update
                    </p>
                    <div style="margin-bottom: 10px;">
                        <input id="CustRadio" type="radio" name="accountType" value="Customer"/><label for="CustRadio" style="color: white;">Customer Account</label>
                        <input id="ProvRadio" type="radio" name="accountType" value="Business"/><label for="ProvRadio" style="color: white;">Business Account</label>
                    </div>
                <%  
                    
                    }
                %>
                
                <input id="ResetUserEmail" type="hidden" value="<%=Email%>" />
                <form id="LoginForm" name="login" method="POST">
                    
                    <table border="0" style="border-top: 1px solid darkblue; border-bottom: 1px solid darkblue; padding: 10px;"> 
                            <tbody>
                                <tr>
                                    <center><p id="nameStatus" style="display: none; background-color: red; color: white; margin-bottom: 10px; max-width: 350px;"></p></center>
                                    <td><p>Enter your existing username below</p>
                                        <input id="LoginPageUserNameFld" placeholder="enter your current username here" type="text" name="username" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <center><p id="telStatus" style="display: none; background-color: red; color: white; margin-bottom: 10px; max-width: 350px;"></p></center>
                                        <p>Enter your mobile number below</p>
                                        <input id="LoginPageMobileFld" placeholder='enter your mobile number here' type="text" name="mobileFld" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Enter your new password below</p>
                                        <input id="LoginPagePasswordFld" placeholder='enter your new password here' type="password" name="password" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Confirm your new password below</p>
                                        <input id="LoginConfirmPasswordFld" placeholder='confirm your new password here' type="password" name="confirmPassword" value="" size="37" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <script>
                            setInterval(function() {
                                
                                var UserName = document.getElementById("LoginPageUserNameFld").value;
                                var MobileNumber = document.getElementById("LoginPageMobileFld").value;
                                var Password = document.getElementById("LoginPagePasswordFld").value;
                                var CPassword = document.getElementById("LoginConfirmPasswordFld").value;
                                
                                if(UserName === "" || MobileNumber === "" || Password === "" || CPassword === ""){
                                    document.getElementById("ResetLoginBtn").style.backgroundColor = "darkgrey";
                                    document.getElementById("ResetLoginBtn").style.disabled = true;
                                }else {
                                    document.getElementById("ResetLoginBtn").style.backgroundColor = "pink";
                                    document.getElementById("ResetLoginBtn").style.disabled = false;
                                }
                                
                            }, 1);
                        </script>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn" />
                        <input id="ResetLoginBtn" class="button" type="button" value="Update" name="submitbtn" />
                    </form>
                
                <script>
                    
                    
                    
                    $(document).ready(function(){
                        
                        document.getElementById("LoginPageUserNameFld").value = "";
                        document.getElementById("LoginPagePasswordFld").value = "";
                        
                        $("#ResetLoginBtn").click(function(event){
                            
                            var UserName = document.getElementById("LoginPageUserNameFld").value;
                            var NewPassword = document.getElementById("LoginPagePasswordFld").value;
                            var MobileNumber = document.getElementById("LoginPageMobileFld").value;
                            
                            var Email = '<%=Email%>';
                            var AccountType = '<%=AccountType%>';
                            
                            if(AccountType === 'Both'){
                                
                                if(document.getElementById("CustRadio").checked)
                                    AccountType = document.getElementById("CustRadio").value;
                                else if(document.getElementById("ProvRadio").checked)
                                    AccountType = document.getElementById("ProvRadio").value;
                                else 
                                    AccountType = document.getElementById("CustRadio").value;
                            }
                            
                            /*alert(AccountType);    
                            alert(UserName);
                            alert(NewPassword);
                            alert(MobileNumber);*/
                            
                            //checking if Email matches with telephone number
                            $.ajax({
                                type: "POST",
                                url: "EmailMobileValidation",
                                data: "Email="+Email+"&Mobile="+MobileNumber+"&AccountType="+AccountType,
                                success: function(result){
                                    
                                    var FoundObj = JSON.parse(result);
                                    var UserID = FoundObj.UserID;
                                    
                                    if(FoundObj.Found === "true"){
                                        
                                        //check to see if username is correct
                                        $.ajax({
                                            type: "POST",
                                            url: "CheckLoginNameController",
                                            data: "UserID="+UserID+"&AccountType="+AccountType,
                                            success: function(result){
                                                
                                                //alert(result);
                                                if(result !== "none" && result === UserName){
                                                  
                                                    //Update Password here
                                                    document.getElementById("telStatus").style.display = "none";
                                                    document.getElementById("nameStatus").style.display = "none";
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "PasswordResetController",
                                                        data: "UserID="+UserID+"&Password="+NewPassword+"&AccountType="+AccountType,
                                                        success: function(result){
                                                            window.location.replace("./LogInPage.jsp");

                                                            /*if(AccountType === "Business"){
                                                                $.ajax({
                                                                    type: "POST",
                                                                    url: "",
                                                                    data: "",
                                                                });
                                                            }else if(AccountType === "Customer"){

                                                            }*/
                                                        }
                                                    });
                                                }else {
                                                    document.getElementById("telStatus").style.display = "none";
                                                    document.getElementById("nameStatus").style.display = "block";
                                                    document.getElementById("nameStatus").innerHTML = "User Name provided doesn't match user account information";
                                                    document.getElementById("LoginPageUserNameFld").value = "";
                                                }
                                            }
                                        });
                                    }else {
                                        document.getElementById("telStatus").style.display = "block";
                                        document.getElementById("telStatus").innerHTML = "Mobile number provided doesn't match user account information";
                                        document.getElementById("LoginPageMobileFld").value = "";
                                    }
                                }
                            });
                            
                        });
                    });
                    
                </script>
                
                    
                <!--h5  style = "margin: 10px;" ><a href="SignUpPage.jsp" style="color: white; background-color: blue; padding: 4px; border: 1px solid black;">I don't have a user account. Sign-up now!</a></h5-->
                </div></center>
                <!--center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center-->
            
            </div>
                
        </div>
                
        <div id="newbusiness" style="height: 525px;">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Sign-up to add your business or to find a spot</h2></center>
            
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
                    <input id="loginPageSignUpBtn" class="button" type="submit" value="Submit" name="submitBtn" />
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
