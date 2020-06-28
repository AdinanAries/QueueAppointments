<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>

<html>
    
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
         <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <!--script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        
        <!-- Zebra Dialog CSS -->
        <link rel="stylesheet" href="dialog_dist/css/flat/zebra_dialog.min.css" type="text/css">

        <!-- Zebra Dialog JS -->
        <script src="dialog_dist/zebra_dialog.min.js"></script>
        
        
        
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
            e.printStackTrace();
        }
        
        if(Message == null)
            Message = "You are not logged in";
        
        String ServiceType = request.getParameter("formsServiceCategory");
        
        String Date = request.getParameter("formsDateValue");
        String Time = request.getParameter("formsTimeValue");
        String OrderedServices = request.getParameter("formsOrderedServices");
        String Price = request.getParameter("TotalToPay");
        
        if(Price.length() > 5)
            Price = Price.substring(0,5);
        
        int CreditCardNumber = 0;
        String PaymentMethod = request.getParameter("payment");
        
        String ProviderID = request.getParameter("ProviderID");
        String ProviderFullName = request.getParameter("ProviderFullName");
        String ProviderCompany = request.getParameter("ProviderCompany");
        
        

    %>  
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        <div id='QShowNews22' style='width: fit-content; bottom: 5px; margin-left: 4px; position: fixed; background-color: #3d6999; padding: 5px 9px; border-radius: 50px;
                 box-shadow: 0 0 5px 1px black;'>
                <center><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp"><p  
                    style='color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0; width:'>
                        <img style='background-color: white; width: 25px; height: 24px; border-radius: 4px;' src="icons/icons8-home-50.png" alt="icons8-home-50-50"/>
                </p>
                <p style='font-size: 15px; color: white; margin-top: -5px;'>Home</p>
                </a></center>
            </div>
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="PermanentDiv" style="">
            
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 70px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: cadetblue; color: white; border-radius: 4px;'>
                        <p><img style='background-color: white; padding: 4px; border-radius: 4px;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                            <sup>Home</sup></p></a>
            
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
                    <li class="active" onclick="" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Home</li></a>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
        
            <div id="ExtraDivSearch" style='background-color: cadetblue; padding: 3px; padding-right: 5px; padding-left: 5px; margin-top: 1.2px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 5px 7px; font-size: 15px;" 
                            type="submit" value="Search" />
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
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 5px;">Updates from service providers</p></center>
            
            <div style="max-height: 87vh; overflow-y: auto; background-color: #b5cece;">
                <%
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
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


                                        }
                                        catch(Exception e){

                                        }
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
                                        String NHouseNumber = ProvLocRec.getString("House_Number").trim();
                                        String NStreet = ProvLocRec.getString("Street_Name").trim();
                                        String NTown = ProvLocRec.getString("Town").trim();
                                        String NCity = ProvLocRec.getString("City").trim();
                                        String NZipCode = ProvLocRec.getString("Zipcode").trim();
                                        
                                        ProvAddress = NHouseNumber + " " + NStreet + ", " + NTown + ", " + NCity + " " + NZipCode;
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
         
        <div id="content" style="min-height: 880px;">
        
            
            <div id="main" style="min-height: 880px;">
                <script>
                    if($(document).width() < 1000){
                        document.getElementById("main").style.minHeight = "initial";
                        document.getElementById("content").style.minHeight = "initial";
                    }
                    </script>
                
                <h4 style="padding: 10px; color: darkblue; text-align: center; margin-bottom: 10px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> <%=Message%></h4>
                <div style="width: 100%; max-width: fit-content; margin: auto; background-color: white; padding: 10px;">
                <h3 style="margin-bottom: 5px; color: darkblue;">Your Spot Details</h3>
                <p style="color: tomato; font-weight: bolder;"><span><%=ProviderFullName.split(" ")[0]%> from <%=ProviderCompany%></span></p>
                    <table border="0" style="border-spacing: 5px; text-align: left;">
                        <tbody>

                            <tr><td style="font-weight: bolder;">Category: </td><td style="padding-left: 20px;"><%=ServiceType%></td></tr>
                            <tr><td style="font-weight: bolder;">Date: </td><td style="padding-left: 20px;"><%=Date%></td></tr>
                            <tr><td style="font-weight: bolder;">Time: </td><td style="padding-left: 20px;"><%=Time%></td></tr>
                            <tr><td style="font-weight: bolder;">Reason: </td><td style="padding-left: 20px;"><%=OrderedServices%></td></tr>
                            <tr><td style="font-weight: bolder;">Total Cost: </td><td style="padding-left: 20px;">$<%=Price%></td></tr>

                        </tbody>
                    </table>
                </div>
                <center><div id ="logindetails"> <!--style="border-bottom: solid darkblue 1px; padding-bottom: 20px;"-->
                        
                        <center><h2 style="margin-top: 30px; margin-bottom: 10px; color: #000099">Login to finish.</h2></center>

                    
                    <form name="login" action="LoginAndSendAppointmentController" method="POST">
                        
                        
                        <input id="SendApptPID" type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                        <input id="formsOrderedServices" type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                        <input id="formsDateValue" type="hidden" name="AppointmentDate" value="<%=Date%>" />
                        <input id="formsTimeValue" type="hidden" name="AppointmentTime" value="<%=Time%>" />
                        <input id="Payment" type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                        <input id="cardNBR" type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                        <input id="TaxedPrice" type="hidden" name="ServiceCost" value="<%=Price%>" />
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="LoginPageUserNameFld" placeholder='Enter username here' type="text" name="username" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="Enter password here" type="password" name="password" value="" size="34"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
                        
                        <!--script>
                                             
                            $(document).ready(function() {                        
                                $('#loginPageBtn').click(function(event) {  
                                                        
                                    var ProviderID = document.getElementById("SendApptPID").value;
                                    var CardNumberr = document.getElementById("cardNBR").value;
                                    var PayMeth = document.getElementById("Payment").value;
                                    var TotalPrice = document.getElementById("TaxedPrice").value;
                                    var ApptDate = document.getElementById("formsDateValue").value;
                                    var ApptTime = document.getElementById("formsTimeValue").value;
                                    var ApptReason = document.getElementById("formsOrderedServices").value;
                                    var UserName = document.getElementById("LoginPageUserNameFld").value;
                                    var Password = document.getElementById("LoginPagePasswordFld").value;
                                    //var PayMeth = $("input:radio[name=payment]:checked").val();
                                                        
                                    alert("ProviderID: "+ProviderID);
                                    alert("CardNumber: "+CardNumberr);
                                    alert("UserName: "+UserName);
                                    alert("Password: "+Password);
                                    alert("TotalPrice: "+TotalPrice);
                                    alert("ApptDate: "+ApptDate);
                                    alert("ApptTime: "+ApptTime);
                                    alert("ApptReason: "+ApptReason);
                                    alert("Payment Method: "+PayMeth);
                                                        
                                                        
                                    $.ajax({  
                                        type: "POST",  
                                        url: "LoginAndSendAppointmentController",  
                                        data: "ProviderID="+ProviderID+"&DebitCreditCard="+CardNumberr+"&ServiceCost="+TotalPrice+"&AppointmentDate="+ApptDate+"&AppointmentTime="+ApptTime+"&OrderedServices="+ApptReason+"&PaymentMethod="+PayMeth+"&username="+UserName+"&password="+Password,  
                                        success: function(result){  
                                            //alert(result);
                                            if(result === "Success"){
                                                window.location.replace("ProviderCustomerPage.jsp?UserIndex="+UserIndex);
                                            }
                                            //document.getElementById("eachClosedDate<>").style.display = "none";
                                        }                
                                    });
                                                        
                                });
                            });
                        </script-->
                        
                    </form>
                    
                </div></center>
            </div>
                
        </div>
                
        <div id="newbusiness">
            
            <h2 style="padding-top: 10px; margin-bottom: 20px; color: #000099; text-align: center;">
                </h2>
            
            <div id="businessdetails">
                <h2 style="color: #000099; text-align: center; margin-bottom: 10px; ">Or sign up to finish.</h2>
                
                <style>
                    @media only screen and (min-width: 1000px){
                        #businessdetails{
                            margin-top: -30px !important;
                        }
                    }
                </style>
                
            <center><form name="AddBusiness" action="SignupAndSendAppointmentController" method="POST">
                    
                        <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                        <input type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                        <input type="hidden" name="AppointmentDate" value="<%=Date%>" />
                        <input type="hidden" name="AppointmentTime" value="<%=Time%>" />
                        <input type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                        <input type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                        <input type="hidden" name="ServicesCost" value="<%=Price%>" />
                        
                    <table border="0">
                        <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                        <input id="SUPfirstName" placeholder='Enter first name here' type="text" name="firstName" value="" size="34"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!--fieldset class="loginInputFld">
                                        <legend>Enter your middle name</legend>
                                        <span class="fa fa-user"></span-->
                                        <input id="SUPmiddleName" placeholder='middlename'  type="hidden" name="middleName" value=" " size="34"/>
                                    <!--/fieldset-->
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                        <input id="SUPlastName" placeholder='Enter last name here'  type="text" name="lastName" value="" size="34"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                        <input id="SUPtelephone" placeholder='Enter mobile here'  type="text" name="telNumber" value="" size="34"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p id='CustEmailStatus' style='color: white; display: none; text-align: center; margin: 10px 0;'></p>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                        <input onchange='CustSetVerifyFalse();' placeholder='Enter email here' onfocusout='CustCloseEmailVerify();' onfocus='CustShowEmailVerify();' type="text" id="visibleEmail" name="email" value="" size="34" />
                                    </fieldset>
                                    <input id="SUPemail"  type="hidden" name="email" value="" size="37"/>
                                    <div id='CustEmailVeriDiv' style='display: none; background-color: #3d6999; padding: 10px; margin: 5px;'>
                                            <div id='CustsendVerifyDiv'>
                                                <center><input id='CustSendverifyEmailBtn' type='button' value='1. Click to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            </div>
                                            <div id='CustverifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='CustvCodeStatus' style='padding-left: 5px; color: white; max-width: 250px; margin: 10px 0;'><span style="color: #ffc700; font-weight: bolder;">2.</span> We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input id="CustEmailConfirm" placeholder="Enter 6-digit code here" type="text" /></p>
                                            </div>
                                            <center><input id='CustverifyEmailBtn' onclick="CustVerifyCode();" type='button' value='3. Click to verify entered code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
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
                                                            //document.getElementById("CustEmailStatus").style.backgroundColor = "green";
                                                            document.getElementById("CustEmailStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Your email has been verified";
                                                            document.getElementById("SUPemail").value = document.getElementById("visibleEmail").value;
                                                            document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                            document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please verify your email";
                                                            document.getElementById("SUPemail").value = "";
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
                                                        document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please enter a valid email";
                                                        //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var CustVeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#CustSendverifyEmailBtn").click(function(event){
                                                        //document.getElementById('PageLoader').style.display = 'block';
                                                        CustVeriCode = Math.floor(100000 + Math.random() * 900000);
                                                        CustVeriCode = CustVeriCode + "";
                                                        
                                                        document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Verification Code has been sent to your Email";
                                                        //document.getElementById("CustvCodeStatus").style.backgroundColor = "green";
                                                        document.getElementById("CustSendverifyEmailBtn").style.display = "none";
                                                        
                                                        var to = document.getElementById("visibleEmail").value;
                                                        var Message = CustVeriCode + ' is your Queue verification code';
                                                        
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "QueueMailer",
                                                            data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                            success: function(result){
                                                                //document.getElementById('PageLoader').style.display = 'none';
                                                            }
                                                        });
                                                        
                                                    });
                                                });
                                                
                                                var CustVerifyCode = function () {
                                                    
                                                    if(document.getElementById("CustEmailConfirm").value === CustVeriCode){
                                                        CustEmailVerified = true;
                                                    }
                                                    else{
                                                        document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Make sure verification code is entered or is correct";
                                                        //document.getElementById("CustvCodeStatus").style.backgroundColor = "red";
                                                    }
                                                        
                                                };
                                            </script>
                                        </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                        
                        <div>
                            <h3 style="color: white; margin-top: 10px;">Add your login information</h3>
                            
                            <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="SUPuserName" onkeyup="setPasswordsZero();" onchange="CustUserNameCheck();" placeholder='Enter username here' type="text" name="username" value="" size="34"/>
                                        </fieldset>
                                        <p id="CustUserNameStatus" style="color: white; text-align: center; max-width: 240px; margin: 10px 0;"></p>
                                    </td>
                                </tr>
                                
                            <script>
                                function setPasswordsZero(){
                                    document.getElementById("SUPconfirm").value = "";
                                    document.getElementById("SUPpassword").value = "";
                                }

                                function CustUserNameCheck(){
                                    
                                    var userName = document.getElementById("SUPuserName").value;

                                    $.ajax({
                                        type: "POST",
                                        url: "CheckCustUserNameExists",
                                        data: "UserName="+userName,
                                        success: function(result){
                                            //alert(result);

                                            if(document.getElementById("SUPuserName").value === ""){

                                                document.getElementById("CustUserNameStatus").innerHTML = "";

                                            }
                                            else if(result === "true"){

                                                document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: red;" class="fa fa-exclamation-triangle"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is not available. Choose a different Username';
                                                //document.getElementById("CustUserNameStatus").style.backgroundColor = "red";
                                                document.getElementById("SUPuserName").value = "";

                                            }else if(result === "false" && document.getElementById("SUPuserName").value !== ""){

                                                document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: #58FA58;" class="fa fa-check"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is available.';
                                                //document.getElementById("CustUserNameStatus").style.backgroundColor = "green";

                                            }
                                        }
                                    });
                                }
                            </script>
                                
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="SUPpassword" placeholder='Enter new password here' type="password" name="password" value="" size="34"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="SUPconfirm" placeholder='Confirm password here' type="password" name="confirm" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                            </table>
                            <p id="SignUpAndBookStatus" style="color: white; width: 200px;"></p>
                            
                        </div>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="SignUpAndBookBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Sign Up" name="submitBtn" />
                </form></center>
                
            </div>
    
            </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
    <script>
        $(document).ready(function() {
            new $.Zebra_Dialog(
                "We are not responsible for any unsatisfied service from a business on our platform. " +
                "<br/><br/>However, we are committed to making sure that you get the best service through our platform. " +
                "<br/><br/>Rating businesses on our platform will help us disassociate with bad businesses.",
                {
                    type: "warning",
                    title: "Disclaimer",
                    //buttons: ["Yes", "No", "Help"],
                    buttons: ["Continue"],
                    onClose: function(caption) {

                        // notice that we use the button's label to determine which button was clicked
                        // "caption" will be empty when the dialog box is closed by pressing ESC, by clicking the
                        // dialog box's close button, or by clicking the overlay
                        /*new $.Zebra_Dialog((caption !== "" ? "\"" + caption + "\"" : "nothing") + " was clicked", {
                            auto_close: 2000,
                            buttons: false,
                            modal: false,
                            position: ["center", "center"]
                        });*/

                    }
                }
            );
        });
    </script>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/SignUpandSendAppointmentBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
</html>
