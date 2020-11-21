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
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
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
            
            <cetnter><p> </p></cetnter>
            <center><a href="LoginPageToQueue"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find Your Spot Now!</h3></center>
            
        </div>
            
        <div id="main_body_flex">
            
            <div id="Extras">

            <div id="ExtrasInnerContainer">
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
                                                    <div style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; overflow: hidden;">    
                                                        <img id="" style="background-color: darkgray; width:35px; height: auto;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    </div>
                                                <%
                                                    }else{
                                                %>
                                                    <img style='margin: 4px; width:35px; height: 35px; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <b>
                                                    <a href="EachSelectedProvider.jsp?UserID=<%=ProvID%>">
                                                        <p onclick="document.getElementById('PageLoader').style.display = 'block';" style="color: #3d6999;">
                                                            <%=ProvFirstName%> 
                                                            <span style="border-radius: 4px; color: white; background-color: #3d6999; padding: 5px; font-size: 12px; font-weight: initial; margin-left: 10px;">
                                                                go to profile <i style="color: #ff6b6b; font-weight: initial;" class="fa fa-chevron-right"></i>
                                                            </span>
                                                        </p>
                                                    </a>
                                                </b>
                                                <p style='color: red; margin-top: 5px;'><%=ProvCompany%></p>
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
            
            <div id="content">
            
            <div id="nav">
                
                <!--h3><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h3-->
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 15px;">
                <!--center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: white; background-color: blue; border: 1px solid black; padding: 4px;">Click here to go to Queue home page</a></h2></center>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center-->
                
                <%if(Message != null){%>
                    <center><h4 style="color: #334d81; margin-bottom: 15px; max-width: 350px;"><i style="color: orange;" class="fa fa-exclamation-triangle"></i> <%=Message%></h4></center>
                <%}%>
                    
                <center><h2 style="margin-bottom: 20px;">Reset Your Password</h2></center>
                
                <%if(AccountType.equals("Both")){%>
                    <p style="color: white; margin-bottom: 10px; max-width: 350px; margin: 20px 0;"><i style="color: orange;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> Your email is associated with a business and a customer account.
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
                    
                    <table border="0" style="border-top: 1px solid darkblue; border-bottom: 1px solid darkblue; max-width: 300px; padding: 10px 0;"> 
                            <tbody>
                                <tr>
                                    <center><p id="nameStatus" style="display: none; background-color: red; color: white; margin-bottom: 10px; max-width: 350px;"></p></center>
                                    <td><p style="margin-top: 10px;"></p>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your existing username below</legend>
                                            <span class="fa fa-user"></span>
                                            <input id="LoginPageUserNameFld" placeholder="username" type="text" name="username" value="" size="32"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <center><p id="telStatus" style="display: none; background-color: red; color: white; margin-bottom: 10px; max-width: 350px;"></p></center>
                                        <p style="margin-top: 10px;"></p>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your mobile number below</legend>
                                            <span class="fa fa-phone"></span>
                                            <input id="LoginPageMobileFld" placeholder='mobile' type="text" name="mobileFld" value="" size="32"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="margin-top: 10px;"></p>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your new password below</legend>
                                            <span class="fa fa-key"></span>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="password" type="password" name="password" value="" style="margin: 0;"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="margin-top: 10px;"></p>
                                        <fieldset class="loginInputFld">
                                            <legend>Confirm your new password below</legend>
                                            <span class="fa fa-key"></span>
                                            <input class="passwordFld" id="LoginConfirmPasswordFld" placeholder="password"  type="password" name="confirmPassword" value="" style="margin: 0;"/>
                                        </fieldset>
                                    </td>
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
                                    document.getElementById("ResetLoginBtn").style.backgroundColor = "darkslateblue";
                                    document.getElementById("ResetLoginBtn").style.disabled = false;
                                }
                                
                            }, 1);
                        </script>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn" />
                        <input id="ResetLoginBtn" class="button" type="button" value="Update" name="submitbtn" style="color: white; border: none;"/>
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
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your first name</legend>
                                        <span class="fa fa-user"></span>
                                        <input id="signUpFirtNameFld" placeholder="firstname" type="text" name="firstName" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your last name</legend>
                                        <span class="fa fa-user"></span>
                                        <input id="sigUpLastNameFld" placeholder="lastname" type="text" name="lastName" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your mobile</legend>
                                        <span class="fa fa-mobile" style="font-size: 25px;"></span>
                                        <input onclick='checkMiddleNumber()' onkeydown="checkMiddleNumber()" id="signUpTelFld" placeholder="mobile" type="text" name="telNumber" value="" size="32"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your email</legend>
                                        <span class="fa fa-envelope"></span>
                                        <input id="signUpEmailFld" placeholder="email" type="text" name="email" value="" size="32"/>
                                    </fieldset>
                                </td>
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
                            
        </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
