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
        
        <!--script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        
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
        String ControllerResult = "";
        
        //put this in a try{}catch(){} for incase the current request has no such parameter
        try{
            ControllerResult = request.getParameter("result");
        }catch(Exception e){}
        
       try{
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
       }catch(Exception e){
           response.sendRedirect("Queue.jsp");
       }
        
        String ProviderID = request.getAttribute("ProviderID").toString();
        String ProviderFullName = "";
        String ProviderCompany = "";
        String serviceType = "";
        
        String Message = "";
        try{
            Message = request.getParameter("Message");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection ProviderInfoConn = DriverManager.getConnection(url, User, Password);
            String ProviderInfoString = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement ProviderInfoPst = ProviderInfoConn.prepareStatement(ProviderInfoString);
            ProviderInfoPst.setString(1, ProviderID);
            
            ResultSet ProviderRec = ProviderInfoPst.executeQuery();
            
            while(ProviderRec.next()){
                
                String FirstName = ProviderRec.getString("First_Name");
                String MiddleName = ProviderRec.getString("Middle_Name");
                String LastName = ProviderRec.getString("Last_Name");
                ProviderFullName = FirstName + " " + MiddleName + " " + LastName;
                ProviderCompany = ProviderRec.getString("Company");
                
                serviceType = ProviderRec.getString("Service_Type");
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        //request.setAttribute("OrderedServices",OrderedServices);
        //request.setAttribute("AppointmentDate",AppointmentDate);
        //request.setAttribute("AppointmentTime",AppointmentTime);
        //request.setAttribute("PaymentMethod",PaymentMethod);
        //request.setAttribute("DebitCreditCard",DebitCreditCardNumber);
        
        String ServiceType = serviceType;
        
        String Date = request.getAttribute("AppointmentDate").toString();
        String Time = request.getAttribute("AppointmentTime").toString();
        String OrderedServices = request.getAttribute("OrderedServices").toString();
        String Price = request.getAttribute("ServiceCost").toString();
        
        if(Price.length() > 5)
            Price = Price.substring(0,5);
        
        int CreditCardNumber = 0;
        String PaymentMethod = request.getAttribute("PaymentMethod").toString();
        
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
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 7px; font-size: 15px;" 
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
                
                <cetnter><h4 style="color: darkblue; margin-bottom: 10px; padding: 10px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> <%=Message%></h4></cetnter>
                <h3 style="margin-top: 20px; margin-bottom: 5px;">Your Spot Details Provided Below</h3>
                <p style="color: seashell;"><span><%=ProviderFullName%> from <%=ProviderCompany%></span></p>
                <center><table border="0">
                <tbody>
                    
                <tr><td>Category: </td><td style="color: white;"><%=ServiceType%></td></tr>
                <tr><td>Date: </td><td style="color: white;"><%=Date%></td></tr>
                <tr><td>Time: </td><td style="color: white;"><%=Time%></td></tr>
                <tr><td>Reason: </td><td style="color: white;"><%=OrderedServices%></td></tr>
                <tr><td>Total Cost: </td><td style="color: white;"><%=Price%></td></tr>
                
                </tbody>
                </table></center>
                
                <center><div id ="logindetails"> <!--style="border-bottom: solid darkblue 1px; padding-bottom: 20px;"-->
                        
                        <center><h2 style="margin-top: 30px; margin-bottom: 10px; color: #000099">Login to finish.</h2></center>

                    
                    <form name="login" action="LoginAndSendAppointmentController" method="POST">
                        
                        
                        <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                        <input type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                        <input type="hidden" name="AppointmentDate" value="<%=Date%>" />
                        <input type="hidden" name="AppointmentTime" value="<%=Time%>" />
                        <input type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                        <input type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                        <input type="hidden" name="ServiceCost" value="<%=Price%>" />
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your user name</legend>
                                            <span class="fa fa-user"></span>
                                            <input id="LoginPageUserNameFld" placeholder='username' type="text" name="username" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your password</legend>
                                            <span class="fa fa-key"></span>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="Password" type="password" name="password" value="" size="34"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input onclick="document.getElementById('PageLoader').style.display = 'block';" id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
                        
            </div>
                
        </div>
                
        <div id="newbusiness">
            
            <center><h2 style="padding-top: 10px; margin-bottom: 20px; color: #000099">
                </h2></center>
            
            <div id="businessdetails">
                
                <center><h2 style="color: #000099; margin-bottom: 10px; ">Or sign up to finish.</h2></center>

                
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
                        <tbody>
                            
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your first name</legend>
                                        <span class="fa fa-user"></span>
                                        <input id="SUPfirstName" placeholder='firstname' type="text" name="firstName" value="" size="34"/>
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
                                        <legend>Enter your last name</legend>
                                        <span class="fa fa-user"></span>
                                        <input id="SUPlastName" placeholder='lastname'  type="text" name="lastName" value="" size="34"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your mobile</legend>
                                        <i class="fa fa-mobile" style="font-size: 24px"></i>
                                        <input id="SUPtelephone" placeholder='mobile'  type="text" name="telNumber" value="" size="34"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <center><p id='CustEmailStatus' style='color: white; display: none; text-align: center;'></p></center>
                                    <fieldset class="loginInputFld">
                                        <legend>Enter your email</legend>
                                        <span class="fa fa-envelope"></span>
                                        <input onchange='CustSetVerifyFalse();' placeholder='email' onfocusout='CustCloseEmailVerify();' onfocus='CustShowEmailVerify();' type="text" id="visibleEmail" name="email" value="" size="34" />
                                    </fieldset>
                                    <input id="SUPemail" type="hidden" name="email" value="" size="37"/>
                                    <div id='CustEmailVeriDiv' style='display: none; background-color: blue; padding: 10px; margin: 5px;'>
                                            <div id='CustsendVerifyDiv'>
                                                <center><input id='CustSendverifyEmailBtn' type='button' value='1. Click to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            </div>
                                            <div id='CustverifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='CustvCodeStatus' style='padding-left: 5px; color: white; max-width: 250px;'><span style="color: #ffc700; font-weight: bolder;">2.</span> We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input placeholder="Enter 6-digit code here" id="CustEmailConfirm" type="text" /></p>
                                            </div>
                                            <center><input id='CustverifyEmailBtn' onclick="CustVerifyCode();" type='button' value='3. Click to verify entered code ' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            <script>
                                                
                                                var CustEmailVerified = false; //main controller for all verification related operations. This flag switches to true or false in order to determine what actions to be taken by the verification algorithm
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
                                                            document.getElementById("SUPemail").value = document.getElementById("visibleEmail").value;
                                                            document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                            document.getElementById("CustEmailStatus").innerHTML = "Please verify your email";
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
                                                        document.getElementById("CustEmailStatus").innerHTML = "Please enter a valid email";
                                                        document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var CustVeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#CustSendverifyEmailBtn").click(function(event){
                                                        //document.getElementById('PageLoader').style.display = 'block';
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
                                                                //document.getElementById('PageLoader').style.display = 'none';
                                                            }
                                                        });
                                                        //document.getElementById("CustEmailConfirm").value = CustVeriCode;
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
                        </tbody>
                    </table>
                        
                        <div>
                            <h3 style="color: white; margin-top: 10px;">Add your login information</h3>
                            
                            <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your user name</legend>
                                            <span class="fa fa-user"></span>
                                            <input id="SUPuserName" placeholder='username' type="text" name="username" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <legend>Enter your password</legend>
                                            <span class="fa fa-key"></span>
                                            <input class="passwordFld" id="SUPpassword" placeholder='Password' type="password" name="password" value="" size="34"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <legend>Confirm your password</legend>
                                            <span class="fa fa-key"></span>
                                            <input class="passwordFld" id="SUPconfirm" placeholder='Password' type="password" name="confirm" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                            </table>
                            <p id="SignUpAndBookStatus" style="color: white; background-color: red; width: 200px;"></p>
                            
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
                
    </body>
    <script>
        var ControllerResult = "<%=ControllerResult%>";
        if(ControllerResult !== "null")
            alert(ControllerResult);
    </script>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/SignUpandSendAppointmentBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
</html>
