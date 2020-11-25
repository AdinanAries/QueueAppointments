<%-- 
    Document   : BlockFutureSpots
    Created on : Jun 3, 2019, 10:13:16 AM
    Author     : aries
--%>

<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="com.arieslab.queue.queue_model.ProviderCustomerData"%>
<%@page import="com.arieslab.queue.queue_model.BookedAppointmentList"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.arieslab.queue.queue_model.ResendAppointmentData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Driver"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Queue | Settings</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
    </head>
    
    <script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
    
    <%
        
        try{
            config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
            config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
            config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
            config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        }catch(Exception e){
    %>
    
        <script>
            if($(window).width() > 1000){

                    let UserName = window.localStorage.getItem("QueueUserName");
                    let UserPassword = window.localStorage.getItem("QueueUserPassword");
                    (function(){
                        //This coinsidentally takes you to login page incase of unavailable login information.
                        document.location.href="LoginControllerMainRedirect?username="+UserName+"&password="+UserPassword;
                        return false;
                    })();

                }else{
                    
                    let UserName2 = window.localStorage.getItem("QueueUserName");
                    let UserPassword2 = window.localStorage.getItem("QueueUserPassword");
                    parent.window.document.location = "LoginControllerMainRedirect?username="+UserName2+"&password="+UserPassword2;
                }
        </script>
    
    <%
        }
        
        int UserID = 0;
        int UserIndex = -1;
        String NameFromList = "";
        String NewUserName = "";
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
         
        try{
            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            NewUserName = request.getParameter("User");
            UserID = Integer.parseInt(request.getParameter("CustomerID"));

            int notiCounter = 0;

            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
    %>
    
        <script>
            if($(window).width() > 1000){

                    let UserName = window.localStorage.getItem("QueueUserName");
                    let UserPassword = window.localStorage.getItem("QueueUserPassword");
                    (function(){
                        //This coinsidentally takes you to login page incase of unavailable login information.
                        document.location.href="LoginControllerMainRedirect?username="+UserName+"&password="+UserPassword;
                        return false;
                    })();

                }else{
                    
                    let UserName2 = window.localStorage.getItem("QueueUserName");
                    let UserPassword2 = window.localStorage.getItem("QueueUserPassword");
                    parent.window.document.location = "LoginControllerMainRedirect?username="+UserName2+"&password="+UserPassword2;
                }
        </script>
    
    <%
        }
        
        ProviderCustomerData eachCustomer = null;
       
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background: none !important; background-color: #333333; padding-bottom: 0; height: auto !important; position: initial !important;">
        
        <style>
            @media only screen and (max-width: 700px){
                .dontShowMobile{
                    display: none;
                } 
            }
            .marginUp20{
                margin-top: 20px;
            }
            
        </style>
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <!--script>
            setTimeout(function(){
                window.location.replace("NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>");
            },6000);
        </script-->
        
        <center><div id='PhoneSettingsPgNav'>
        
        </div></center>
        
        <script>
            $(document).ready(()=>{
                if($(document).width() > 1000){
                    document.getElementById("PhoneSettingsPgNav").innerHTML = `
                        <div style='z-index: 110; width: 99.5%; position: fixed; margin-bottom: 5px; background-color: white; padding: 5px; border-bottom: #eeeeee solid 1px;'>
                            <span style="width: fit-content; margin-left: 40px;">
                                <img id="" src="QueueLogo.png" style="width: 60px; height: 30px; margin-top: 5px;" />
                            </span>

                            <!--p style=''><img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                            <sup>News</sup-->

                            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                                <span style='margin-right: 5px; cursor: pointer; float: right; margin-right: 10px; width: fit-content; background-color: #eeeeee; padding: 3px; border-radius: 3px;'>
                                <img style='' src="icons/icons8-home-50.png" width="25" height="25" alt="icons8-home-50"/>

                                <p style='font-size: 11px; margin-top: -8px; color: black;'>Home</p>
                                </span>
                            </a>
                            <a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" href='CustomerSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=3'>
                                <span style='margin-right: 5px; cursor: pointer; float: right; margin-right: 10px; width: fit-content; background-color: #eeeeee; padding: 3px; border-radius: 3px;'>
                                    <img style='border-radius: 2px;' src="icons/icons8-settings-50.png" width="23" height="22" alt="icons8-settings-50"/>
                                    <p style='font-size: 11px; margin-top: -5px; color: black;'>Settings</p>
                                </span>
                            </a>
                        </div>
                    `;
                }
                       
            });
        </script>
        
    <!--center><div id='PhoneSettingsPgNav' style='z-index: 110; width: 99.5%; position: fixed; margin-bottom: 5px; background-color: #000099; padding: 5px; box-shadow: 4px 4px 4px #334d81;'>
       
            <p style='color: white;'><img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                Queue News Area
            
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                    <span style='margin-right: 5px; cursor: pointer; color: white; float: right; border: 2px solid white; padding: 3px; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                        Home</span></a></p>
             
        </div></center-->
        <div style='display: flex; flex-direction: row; justify-content: center; width: 100vw;'>
        
            <div class='dontShowMobile' style='padding: 0 20px; margin: 10px; margin-top: 65px; background-color: #e6f3f7; height: 1350px; border-radius: 4px; 
             box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33) !important; max-width: 300px;'>
            
            <h1 style='color: orange; font-size: 22px; font-family: serif; text-align: center; margin-top: 40px; margin-bottom: 20px;'>What is Queue Appointments</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto;'>
                        Queue Appointments is a website and app that lets you find medical and beauty places near your location to book appointments.
                        It also provides features for the businesses to post news updates with pictures to keep you informed about their services
                        and products.
                    </p>
            
            <div class='CosmeSectFlex' style='flex-direction: column;'>
                        <div class='eachCSecFlex' style='width: 100%;'>
                            <h1 style="margin-top: 20px; margin-bottom: 20px; color: #3d6999;">Book your doctor's appointment online</h1>
                            <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; border-radius: 4px; overflow: hidden;
                                 background-image: url("./DocAppt.jpg"); background-size: cover; background-position: right;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>It's a fully automated platform for booking appointments. Your doctor's appointment has never been easier.</p>
                            </div>
                        </div>
                        <div class='eachCSecFlex marginUp20' style='width: 100%;'>
                            <h1 style="margin-top: 20px; margin-bottom: 20px; color: #3d6999;">Find barber shops near you</h1>
                            <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; border-radius: 4px; overflow: hidden;
                                 background-image: url("./BarberAppt.jpg"); background-size: cover; background-position: right;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>Our recommendations algorithms make it easier for you to find the best barber shops in town</p>
                            </div>
                        </div>
                        <div class='eachCSecFlex marginUp20' style='width: 100%;'>
                            <h1 style="margin-top: 20px; margin-bottom: 20px; color: #3d6999;">Find your beauty time online</h1>
                            <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; border-radius: 4px; overflow: hidden;
                                 background-image: url("./SpaAppt.jpg"); background-size: cover; background-position: right;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>No more waiting on a line. Your service provider has a queue. Find your spot here.</p>
                            </div>
                        </div>
                </div>
        </div>
                    
        
    <div id="" style='max-width: 600px;'>
            
            <div id='PhoneNews' style='width: 100%; max-width: 600px; padding-top: 60px; margin: auto;' >
            <div id='News' style=''>
            <p style="text-align: center; color: darkblue; font-size: 14px; font-weight: bolder; margin: 10px 0;">News updates from your providers</p>
            <script>
                if($(window).width() < 1000){
                    document.getElementById("PhoneNews").style.paddingTop = "10px";
                }
            </script>
                <div style="overflow-y: auto;">
                    
                    <%
                        int newsItems = 0;
                        String newsQuery = "";
                        //String base64Profile = "";
                        
                        //Using location for querying news for only specific area
                        String IDList = "(";
                        String PCity = "";
                        String PTown = "";
                        String PZipCode = "";
                        try{
                            PCity = session.getAttribute("UserCity").toString().trim();
                            PTown = session.getAttribute("UserTown").toString().trim();
                            PZipCode = session.getAttribute("UserZipCode").toString().trim();
                        }catch(Exception e){
                            PCity = "";
                            PTown = "";
                            PZipCode = "";
                        }

                        try{

                            Class.forName(Driver);
                            Connection conn = DriverManager.getConnection(url, User, Password);
                            String AddressQuery = "Select top 1000 ProviderID from QueueObjects.ProvidersAddress where City like '"+PCity+"%' and Town like '"+PTown+"%' ORDER BY NEWID()";
                             // and Zipcode = "+zipCode;//+" ORDER BY NEWID()"; adding zipcode to search filter is going to narrow down search results. keeping search result up to whole town coverage
                            PreparedStatement AddressPst = conn.prepareStatement(AddressQuery);
                            ResultSet ProvAddressRec = AddressPst.executeQuery();

                            boolean isFirst = true;
                            while(ProvAddressRec.next()){

                                if(!isFirst)
                                    IDList += ",";

                                IDList += ProvAddressRec.getString("ProviderID");
                                //JOptionPane.showMessageDialog(null, ProvAddressRec.getInt("ProviderID"));
                                //ProviderIDsFromAddress.add(ProvAddressRec.getInt("ProviderID"));
                                isFirst = false;
                            }
                            IDList += ")";
                            //JOptionPane.showMessageDialog(null, IDList);

                        }catch(Exception e){}
                        //This code snippet is need to be finished and replicated to all needed pages
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(url, User, Password);
                                String CustQuery = "select top 10 * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
                                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                                CustPst.setInt(1, UserID);
                                ResultSet CustRec = CustPst.executeQuery();
                                
                                while(CustRec.next()){
                                    
                                    String MessageID = CustRec.getString("MessageID").trim();
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                                        newsQuery = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
                                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                                        newsPst.setString(1, MessageID);
                                        ResultSet newsRec = newsPst.executeQuery();

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


                                            }catch(Exception e){}


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

                    <table  id="ExtrasTab" cellspacing="0" style="overflow: hidden; background-color: #eeeeee; margin: 5px; margin-bottom: 10px; border-radius: 4px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33) !important;">
                        <tbody>
                            <tr style="background-color: #eeeeee;">
                                <td>
                                    <div id="ProvMsgBxOne" style=" padding: 10px 0;">
                                        
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
                                            <div style="margin-top: 5px;">
                                                <b>
                                                    <a href="EachSelectedProviderLoggedIn.jsp?UserID=<%=ProvID%>&UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
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
                                <td style="background-color: #eeeeee;">
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

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    //}
                
                    if(newsItems < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(url, User, Password);
                            String newsQuery2 = "Select top 10 * from QueueServiceProviders.MessageUpdates where ProvID in "+IDList+" and VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
                            ResultSet newsRec = newsPst.executeQuery();

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
                
                <table  id="ExtrasTab" cellspacing="0" style="overflow: hidden; background-color: #eeeeee; margin: 5px; margin-bottom: 10px; border-radius: 4px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33) !important;">
                        <tbody>
                            <tr style="background-color: #eeeeee; padding: 10px 0;">
                                <td>
                                    <div id="ProvMsgBxOne" style=" padding: 10px 0;">
                                        
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
                                            <div style="margin-top: 5px;">
                                                <b>
                                                    <a href="EachSelectedProviderLoggedIn.jsp?UserID=<%=ProvID%>&UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
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
                                <td style="background-color: #eeeeee;">
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
            
                }
            %>
               </div> 
            </div>
        </div>
                <%
                    if(newsItems == 0){
                %>

                <p style="font-weight: bolder; margin-top: 50px; text-align: center;"><i class="fa fa-exclamation-triangle" style="color: orange;"></i> No news items found at this time</p>

                <%
                    }
                %>

               <div id='InfiniteScrollContent'>
                   <p style='font-size: 20px; text-align: center; display: none; font-weight: bolder; padding: 40px;' id='loadingMoreNew'><i class="fa fa-spinner" style='color: #06adad' aria-hidden="true"></i> Loading more</p>
               </div>
        </div>
           
        <div class='dontShowMobile' style='padding: 0 20px; margin: 10px; height: 910px; border-radius: 4px; 
             box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33) !important;  margin-top: 65px; background-color: #e6f3f7; max-width: 300px;'>
            <h1 style='color: orange; font-size: 22px; font-family: serif; margin-top: 40px; margin-bottom: 20px; text-align: center;'>We have the best services in your area</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto;'>
                        Your ratings, reviews and feedbacks mean a lot to us. We are constantly watching how well businesses serve their customers in order to ensure that only the best medical and beauty places operate on 
                        our platform. Queue Appointments will eventually disassociate with badly rated businesses.
                    </p>
                    
                    <div class='CosmeSectFlex' style='margin: auto; margin-top: 20px; max-width: 1000px; flex-direction: column;'>
                        <div class='eachCSecFlex' style='width: 100%;'>
                            <h1 style="margin-top: 20px; margin-bottom: 20px; color: #3d6999;">Your reviews make a difference</h1>
                            <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='text-align: center;'><img src='ReviewIcon.png'  style='width: 80px; height: 80px'/></p>
                                <p style='color: #37a0f5; padding: 5px;'>Always feel free to tell us how you were served. You help us keep the platform clean</p>
                            </div>
                        </div>
                        <div class='eachCSecFlex marginUp20' style='width: 100%;'>
                            <h1 style="margin-top: 20px; color: #3d6999;">Fast growing community</h1>
                            <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                 display: flex; flex-direction: column;'>
                                <p style='text-align: center;'><img src='BizGroup.png'  style='width: 80px; height: 80px'/></p>
                                <p style='color: #37a0f5; padding: 5px;'>More and more businesses are signing up on our platform everyday</p>
                            </div>
                        </div>
                        <div class='eachCSecFlex marginUp20' style='width: 100%;'>
                            <h1 style="margin-top: 20px; color: #3d6999;">Our businesses keep you posted</h1>
                            <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='text-align: center;'><img src='NewsPic.png'  style='width: 80px; height: 80px'/></p>
                                <p style='color: #37a0f5; padding: 5px;'>Our integrated news feed feature lets businesses post regular news updates to keep you informed</p>
                            </div>
                        </div>
                    </div>
            </div>
    </div>
               
               <script>
                        //infinite scroll
                        const infiniteDiv = document.getElementById("InfiniteScrollContent");
                        const loadingMoreP = document.getElementById("loadingMoreNew");
                        
                        //scroll event listener
                        window.addEventListener('scroll', () => {
                            //console.log("scrollHieght: " , document.documentElement.scrollHeight);
                            //console.log("Calculated: " , window.scrollY + window.innerHeight);
                            if(window.scrollY + window.innerHeight + 10 >= document.documentElement.scrollHeight){
                                //console.log("bottom reached");
                                loadingMoreP.style.display = "block";
                                $(document).ready(()=>{
                                   $.ajax({
                                       type: "GET",
                                       url: "./LoadMorePublicNews",
                                       success: function(result){
                                           let newsRec = JSON.parse(result);
                                           newsRec.forEach((eachNews)=>{
                                                let news = document.createElement("div");
                                                news.innerHTML = 
                                                '<table  id="ExtrasTab" cellspacing="0" style="overflow: hidden; background-color: #eeeeee; margin: 5px; margin-bottom: 10px; border-radius: 4px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33) !important;">'+
                                                     '<tbody>'+
                                                         '<tr style="background-color: #eeeeee;">'+
                                                             '<td>'+
                                                                '<div id="ProvMsgBxOne" style="padding: 10px 0;">'+
                                                                    '<div style="font-weight: bolder;">'+
                                                                        '<div style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; overflow: hidden;">'+   
                                                                            '<img id="" style="background-color: darkgray; width:35px; height: auto;" src="data:image/jpg;base64,'+eachNews.base64Profile+'"/>'+
                                                                        '</div>'+
                                                                        '<div>'+
                                                                            '<b>'+
                                                                                '<a href="EachSelectedProviderLoggedIn.jsp?UserID='+eachNews.ProvID+'&UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">'+
                                                                                    '<p onclick="document.getElementById(\'PageLoader\').style.display = \'block\';" style="color: #3d6999;">'+
                                                                                        eachNews.ProvFirstName+ 
                                                                                        '<span style="border-radius: 4px; color: white; background-color: #3d6999; padding: 5px; font-size: 12px; font-weight: initial; margin-left: 10px;">'+
                                                                                            'go to profile <i style="color: #ff6b6b; font-weight: initial;" class="fa fa-chevron-right"></i>'+
                                                                                        '</span>'+
                                                                                    '</p>'+
                                                                                '</a>'+
                                                                            '</b>'+
                                                                            '<p style="color: red; margin-top: 5px;">'+eachNews.ProvCompany+'</p>'+
                                                                        '</div>'+
                                                                    '</div>'+
                                                                '</div>'+
                                                            '</td>'+
                                                         '</tr>'+
                                                         '<tr style="background-color: #eeeeee;">'+
                                                             '<td style="padding: 0;">'+
                                                                 '<div style="display: flex; flex-direction: row; justify-content: space-between; padding: 5px; padding-top: 0;">'+
                                                                     '<p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">'+
                                                                         '<a style="color: white;" href="mailto:'+eachNews.ProvEmail+'">'+
                                                                             '<i style="font-size: 20px;" class="fa fa-envelope" aria-hidden="true"></i> Mail'+
                                                                         '</a>'+
                                                                     '</p>'+
                                                                    '<p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">'+
                                                                         '<a style="color: white;" href="tel:'+eachNews.ProvTel+'">'+
                                                                             '<i style="font-size: 20px;" class="fa fa-mobile" aria-hidden="true"></i> Call'+
                                                                         '</a>'+
                                                                     '</p>'+
                                                                     '<p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">'+
                                                                         '<a style="color: white;" href="https://maps.google.com/?q='+eachNews.ProvAddress+'" target="_blank">'+
                                                                             '<i style="font-size: 20px;" class="fa fa-location-arrow" aria-hidden="true"></i> Map'+
                                                                         '</a>'+
                                                                     '</p>'+
                                                                 '</div>'+
                                                             '</td>'+
                                                         '</tr>'+
                                                         '<tr>'+
                                                             '<td style="background-color: #eeeeee;">'+
                                                                 '<p style="font-family: helvetica; text-align: justify; padding: 3px;">'+eachNews.Msg+'</p>'+
                                                             '</td>'+
                                                         '</tr>'+
                                                         '<tr>'+
                                                             '<td style="padding: 0;">'+
                                                                 '<div>'+
                                                                     '<img src="data:image/jpg;base64,'+eachNews.MsgPhoto+'" width="100%" alt="NewsImage"/>'+
                                                                 '</div>'+
                                                             '</td>'+
                                                         '</tr>'+
                                                     '</tbody>'+
                                                 '</table>';
                                                 infiniteDiv.appendChild(news); 
                                            });
                                            loadingMoreP.style.display = "none";
                                       }
                                   }); 
                                });
                            }
                            
                        });
                        
               </script>
           
    </body>
    
    <!--script src="scripts/script.js"></script-->
    <!--script src="scripts/QueueLineDivBehavior.js"></script-->
    
</html>
