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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
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
        
            <div id="ExtraDivSearch" style='background-color: #334d81; padding: 3px; padding-right: 5px; padding-left: 5px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #3d6999; color: #eeeeee; height: 30px; border: 1px solid darkblue; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; border: 1px solid white; background-color: navy; color: white; border-radius: 4px; padding: 7px; font-size: 15px;" 
                            type="submit" value="Search" />
                </form>
            </div>
                <p style='clear: both;'></p>
            
        </div>
        
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image src="QueueLogo.png" style="margin-top: 5px;"/></center>
            
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
        
            
            <div id="main">
                
                <cetnter><h4 style="color: white; background-color: red; margin-bottom: 10px; padding: 10px;"><%=Message%></h4></cetnter>
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
            </div>
                
        </div>
                
        <div id="newbusiness">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">
                </h2></center>
            
            <div id="businessdetails">
                
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
                                    <td><input id="LoginPageUserNameFld" placeholder='enter your Queue user name here' type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="Password" type="password" name="password" value="" size="51"/></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
                        <center><h1 style="margin-top: 15px;">OR</h1></center>
                
                <center><h2 style="margin-top: 20px; color: white; background-color: red;">Don't have user account</h2></center>
                <center><h2 style="color: #000099; margin-bottom: 10px; ">Sign up to finish.</h2></center>

                
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
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input id="SUPfirstName" placeholder='enter your first name' type="text" name="firstName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPmiddleName" placeholder='enter your middle name'  type="text" name="middleName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPlastName" placeholder='enter your last name'  type="text" name="lastName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPtelephone" placeholder='enter your telephone/mobile number here'  type="text" name="telNumber" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPemail" placeholder='enter your email address here'  type="text" name="email" value="" size="50"/></td>
                            </tr>
                        </tbody>
                    </table>
                        
                        <div>
                            <h3 style="color: white; margin-top: 10px;">Add your login information</h3>
                            
                            <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="SUPuserName" placeholder='enter login user name here' type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input id="SUPpassword" placeholder='Password' type="password" name="password" value="" size="51"/></td>
                                </tr>
                                <tr>
                                    <td><p>Confirm Password</p><input id="SUPconfirm" placeholder='Re-enter Password' type="password" name="confirm" value="" size="51"/></td>
                                </tr>
                            </tbody>
                            </table>
                            <p id="SignUpAndBookStatus" style="color: white; background-color: red; width: 200px;"></p>
                            
                        </div>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="SignUpAndBookBtn" class="button" type="submit" value="Sign Up" name="submitBtn" />
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
