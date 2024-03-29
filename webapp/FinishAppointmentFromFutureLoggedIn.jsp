<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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

<!DOCTYPE html>

<html>
    
    <head>    
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue</title>
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

        
    </head>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        //connection arguments
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        String PCity = session.getAttribute("UserCity").toString();
        String PTown = session.getAttribute("UserTown").toString();
        String PZipCode = session.getAttribute("UserZipCode").toString();
        
        int UserID = 0;
        String Base64Pic = "";
        boolean isSameSessionData = true;
        boolean isUserIndexInList = true;
        String NewUserName = "";
        int UserIndex = 0;
        
        try{
            NewUserName = request.getParameter("User");

            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));

            String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

            if(tempAccountType.equals("CustomerAccount"))
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();

            if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }

            //else if(UserID == 0)
                //response.sendRedirect("LogInPage.jsp");
        }catch(Exception e){
            isUserIndexInList = false;
        }
        
        String SessionID = request.getRequestedSessionId();
        String DatabaseSession = "";
        //JOptionPane.showMessageDialog(null, SessionID);
        
        //getting session data from database
        try{
            Class.forName(Driver);
            Connection SessionConn = DriverManager.getConnection(url, User, Password);
            String SessionString = "Select * from QueueObjects.UserSessions where UserIndex = ?";
            PreparedStatement SessionPst = SessionConn.prepareStatement(SessionString);
            SessionPst.setInt(1, UserIndex);
            ResultSet SessionRec = SessionPst.executeQuery();
            
            while(SessionRec.next()){
                
                DatabaseSession = SessionRec.getString("SessionNo").trim();
            }
            
        }catch(Exception e){}
        
        //JOptionPane.showMessageDialog(null, DatabaseSession);
        if(!SessionID.equals(DatabaseSession)){
            
            try{
                Class.forName(Driver);
                Connection DltSesConn = DriverManager.getConnection(url, User, Password);
                String DltSesString = "delete from QueueObjects.UserSessions where UserIndex = ?";
                PreparedStatement DltSesPst = DltSesConn.prepareStatement(DltSesString);
                DltSesPst.setInt(1, UserIndex);
                DltSesPst.executeUpdate();
                
            }
            catch(Exception e){}
            
            isSameSessionData = false;
            //response.sendRedirect("LogInPage.jsp");
        }
        
        if(!isSameSessionData || UserID == 0 || !isUserIndexInList)
            response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
        
        try{
            
            Class.forName(Driver);
            Connection PicConn = DriverManager.getConnection(url, User, Password);
            String PicQuery = "Select Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
            PreparedStatement PicPst = PicConn.prepareStatement(PicQuery);
            PicPst.setInt(1, UserID);
            
            ResultSet PicRec = PicPst.executeQuery();
            
            while(PicRec.next()){
                
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob profilepic = PicRec.getBlob("Profile_Pic"); 
                    InputStream inputStream = profilepic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                     Base64Pic = Base64.getEncoder().encodeToString(imageBytes);


                }
                catch(Exception e){}
                
            }
            
        }catch(Exception e){e.printStackTrace();}
        
    %>
    
    <%!
        
       class getUserDetails{
           
           //class fields
           private Connection conn;
           private ResultSet records;
           private String Driver;
           private String url;
           private String User;
           private String Password;
           
           public void initializeDBParams(String driver, String url, String user, String password){
               
               this.Driver = driver;
               this.url = url;
               this.User = user;
               this.Password = password;
           }
           
           public ResultSet getRecords(String ID){
               
               try{
                   
                    Class.forName(Driver);
                    conn = DriverManager.getConnection(url,User,Password);
                    String  select = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement pst = conn.prepareStatement(select);
                    pst.setString(1,ID);
                    records = pst.executeQuery();

               }
               catch(Exception e){
                  e.printStackTrace();
                }
               
                return records;
            }
       }
       
        %>
        
        <%
            
            ResendAppointmentData.AppointmentTime = request.getParameter("AppointmentTime");
            String AppointmentTime = ResendAppointmentData.AppointmentTime;
            String FormattedAppointmentTime = " ";
            
            try{
                //formatting the time for user convenience
                FormattedAppointmentTime = AppointmentTime;
                
                if(FormattedAppointmentTime.length() == 4)
                    FormattedAppointmentTime = "0" + FormattedAppointmentTime;
                
                int x = Integer.parseInt(FormattedAppointmentTime.substring(0,2));
                String y = FormattedAppointmentTime.substring(3,5);

               /*
                   if(y.length() < 2){

                       y = "0" + y;
                   }
               */

                   if( x > 12)
                   {
                       int TempHour = x - 12;
                       FormattedAppointmentTime = Integer.toString(TempHour) + ":" +  y + " pm";
                   }
                   else if(x == 0){
                       FormattedAppointmentTime = "12" + ":" + y + " am";
                   }
                   else if(x == 12){
                       FormattedAppointmentTime = AppointmentTime + " pm";
                   }
                   else{
                       FormattedAppointmentTime = AppointmentTime +" am";
                   }
            }catch(Exception e){
                
                FormattedAppointmentTime = " ";
                
            }
           
            String ID = ResendAppointmentData.ProviderID;
            
            getUserDetails details = new getUserDetails();
            details.initializeDBParams(Driver, url, User, Password);
            
            ArrayList <ProviderInfo> providersList = new ArrayList<>();
            ResultSet rows = details.getRecords(ID);
            
            try{
                
                ProviderInfo eachrecord;
                
                while(rows.next()){
                    eachrecord = new ProviderInfo(rows.getInt("Provider_ID"),rows.getString("First_Name"), rows.getString("Middle_Name"), rows.getString("Last_Name"), rows.getDate("Date_Of_Birth"), rows.getString("Phone_Number"),
                                                    rows.getString("Company"), rows.getInt("Ratings"), rows.getString("Service_Type"), rows.getString("First_Name") + " - " +rows.getString("Company"),rows.getBlob("Profile_Pic"), rows.getString("Email"));
                    
                    providersList.add(eachrecord);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            
        %>
        
        <%
            //getting cancellation policy data
            boolean hasCancellation = false;
            int CancelElapse = 0;
            int ChargePercent = 0;
            
            try{
                Class.forName(Driver);
                Connection CnclPlcyConn = DriverManager.getConnection(url, User, Password);
                String CnclPlcyString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyTimeElapse%' ";
                PreparedStatement CnclPlcyPst = CnclPlcyConn.prepareStatement(CnclPlcyString);
                CnclPlcyPst.setString(1,ID);
                ResultSet CnclRow = CnclPlcyPst.executeQuery();
                
                while(CnclRow.next()){
                    
                    if(!CnclRow.getString("CurrentValue").trim().equals("0")){
                        
                        hasCancellation = true;
                        CancelElapse = Integer.parseInt(CnclRow.getString("CurrentValue").trim());
                        
                        try{
                            Class.forName(Driver);
                            Connection CnclPlcyConn2 = DriverManager.getConnection(url, User, Password);
                            String CnclPlcyString2 = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyChargeCost%' ";
                            PreparedStatement CnclPlcyPst2 = CnclPlcyConn2.prepareStatement(CnclPlcyString2);
                            CnclPlcyPst2.setString(1,ID);
                            ResultSet CnclRow2 = CnclPlcyPst2.executeQuery();
                            
                            while(CnclRow2.next()){
                                ChargePercent = Integer.parseInt(CnclRow2.getString("CurrentValue").trim());
                            }
                            
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }
                        
                    }
                    //JOptionPane.showMessageDialog(null, ChargePercent);
                    //JOptionPane.showMessageDialog(null, CancelElapse);
                    //JOptionPane.showMessageDialog(null, hasCancellation); 
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        %>
        
    <body  onload="document.getElementById('PageLoader').style.display = 'none';">
        
        <div id="PermanentDiv" style="">
            
            <div id="PageLoader" class="QueueLoader" style="display: block;">
                <div class="QueueLoaderSpinner"></div>
                <img src="icons/Logo.png" alt=""/>
            </div>
            
            <a href="PageController?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 80px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>
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
                <%
                    if(Base64Pic != ""){
                %>
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                        <img class="fittedImg" id="" style="border-radius: 100%; border: 2px solid green; margin-bottom: 20px; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64Pic%>" width="30" height="30"/>
                    </div></center>
                <%
                    }else{
                %>
                
                        <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" width="30" height="30" alt="icons8-user-filled-100"/>
                            </div></center>
                
                <%}%>
            </div>
            
            <ul>
                <a  href="PageController?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                    <li onclick="" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Home</li></a>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
            <div id="ExtraDivSearch" style='background-color: #334d81; padding: 3px; padding-right: 5px; padding-left: 5px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>
                <form action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #3d6999; color: #eeeeee; height: 30px; border: 1px solid darkblue; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; border: 1px solid white; background-color: navy; color: white; border-radius: 4px; padding: 7px; font-size: 15px;" 
                            type="submit" value="Search" />
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <input type='hidden' name='User' value='<%=NewUserName%>' />
                </form>
            </div>
                <p style='clear: both;'></p>
        </div>
        
        <div id="container">
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <!--a href="PageController?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><li><img src="icons/icons8-home-24.png" width="24" height="24" alt="icons8-home-24"/>
                            </li></a-->
                        <li onclick="scrollToTop()" style="padding-left: 2px; padding-right: 2px;"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                            <input type='hidden' name='UserIndex' value='<%=UserIndex%>' />
                            <input style="margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;"
                                   placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                            <input style="margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;" 
                                   type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><a href="PageController?UserIndex=<%=Integer.toString(UserIndex)%>&User=<%=NewUserName%>" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            
        </div>
            
        <div id="Extras">
            
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 5px;">Updates from your providers</p></center>
            
                <div style="max-height: 87vh; overflow-y: auto;">
                    
                    <%
                        int newsItems = 0;
                        String newsQuery = "";
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(url, User, Password);
                                String CustQuery = "select * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
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

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    //}
                
                    if(newsItems < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(url, User, Password);
                            String newsQuery2 = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
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
            
                }
            %>
               </div>
            </div>
        
            
        <div id="content">
            
            <div id="nav">
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4-->
                <!--h3>Your Dashboard</a></h3-->
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" />
                     </form> 
                        
                </div></center> 
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                <center><div id="providerlist">
                <h4 style="color: black; padding-top: 5px;">Finish Here</h4>
                
                <center><table id="providerdetails" style="">
                        
                    <%
                        
                        for(int i = 0; i < providersList.size(); i++){ 
                            
                            String fullName = providersList.get(i).getFirstName() + " " + providersList.get(i).getMiddleName() + " " + providersList.get(i).getLastName();
                            String Company = providersList.get(i).getCompany();
                            String Email = providersList.get(i).getEmail();
                            String phoneNumber = providersList.get(i).getPhoneNumber();
                            
                                                    
                            String base64Image = "";
                            String base64Cover = "";

                            try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = providersList.get(i).getProfilePicture(); 
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
                            
                            int PID = providersList.get(i).getID();
                            
                            try{
                                
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String selectAddress = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                                PreparedStatement pst = conn.prepareStatement(selectAddress);
                                pst.setInt(1,PID); //seting value for query place holder to selected provider's ID
                                ResultSet address = pst.executeQuery();

                                while(address.next()){
                                    
                                    providersList.get(i).setAddress(address.getInt("House_Number"), address.getString("Street_Name"), address.getString("Town"),address.getString("City"),address.getString("Country"),address.getInt("Zipcode"));
                                    
                                }
                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            String fullAddress = "address data not found";
                            
                            try{
                                
                                int hNumber = providersList.get(i).Address.getHouseNumber(); 
                                String sName = providersList.get(i).Address.getStreet().trim(); //trimming records to clean records
                                String tName = providersList.get(i).Address.getTown().trim();
                                String cName = providersList.get(i).Address.getCity().trim();
                                String coName = providersList.get(i).Address.getCountry().trim();
                                int zCode = providersList.get(i).Address.getZipcode();
                                fullAddress = Integer.toString(hNumber) + " " + sName + ", " + tName + ", " + cName + ", " + coName + " " + Integer.toString(zCode);

                            }catch(Exception e){}
                            int ratings = providersList.get(i).getRatings();
                            String ServiceCategory = providersList.get(i).getServiceType().trim();

                            /*
                            int totalList = Integer.parseInt(request.getParameter("totallist"));
                            double TotalPrice = 0; //initializing variable with a temporary value for incase loop condition is never met
                            double TaxedPrice = 0;
                            double Tax = 0;
                            
                            String SelectedServicesList = "";
                            
                            for(int w = 1; w <= totalList; w++ ){ //comparison operator (<=) so that loop can reach last ArrayList element
                                
                                String StringW = Integer.toString(w);
                                String getParamString = "CheckboxOfServiceNo"+StringW; 
                                String SelectedService = request.getParameter(getParamString); //check box returns null when not checked and returns its value(Checked) when Checked.
                                String ServiecNameParam = "NameOfServiceNo"+StringW;
                                String ServicePriceParam = "PriceOfServiceNo"+StringW; //concatenate string with integer value to make up the parameter name
                                
                                if(SelectedService != null){
                                    
                                    if(SelectedServicesList == "")
                                        SelectedServicesList += " " + request.getParameter(ServiecNameParam) //don't include a comma for the first round around the loop
                                                + "-$" + request.getParameter(ServicePriceParam);
                                    else
                                        SelectedServicesList += ", "  + request.getParameter(ServiecNameParam) 
                                                + "-$" + request.getParameter(ServicePriceParam);
                                    double eachPrice = Double.parseDouble(request.getParameter(ServicePriceParam));
                                    TotalPrice += eachPrice; //adding each price item to running total(self-assigned)
                                    
                                }
                            }
                            
                            Tax = TotalPrice *(8.45/100); //returns non-rounded values
                            TaxedPrice = (TotalPrice * (8.45/100)) + TotalPrice; //tax percentage to change soon
                            */
                            
                            //allways do this first to reset Cost
                            Double TaxedPrice = Double.parseDouble(ResendAppointmentData.ServicesCost);
                            
                            ProcedureClass.Cost = 0;
                            ProcedureClass.OrderedServices = "";
                            
                            ProcedureClass.Cost = Double.parseDouble(ResendAppointmentData.ServicesCost);
                            ProcedureClass.OrderedServices = ResendAppointmentData.SelectedServices;
                            
                    %>
                    
                    <%
                        
                                    int IntervalsValue = 30;
        
                                    try{

                                        Class.forName(Driver);
                                        Connection intervalsConn = DriverManager.getConnection(url, User, Password);
                                        String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                                        PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

                                        intervalsPst.setInt(1, PID);

                                        ResultSet intervalsRec = intervalsPst.executeQuery();

                                        while(intervalsRec.next()){
                                            IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
                                        }
                                    }catch(Exception e){
                                        e.printStackTrace();
                                    }

                        
                                    //getting all the time available to availble times list
                                    //getting all the time available to availble times list
                        
                                        Date CurrentDate = new Date();
                                        String DayOfWeek = CurrentDate.toString().substring(0,3);
                                        SimpleDateFormat CurrentDateSdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDate = CurrentDateSdf.format(CurrentDate);
                                        String CurrentTime = CurrentDate.toString().substring(11,16);
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                        
                                        String DailyStartTime = "";
                                        String DailyClosingTime = "";
                                        //String FormattedStartTime = "";
                                        //String FormattedClosingTime = "";
                                        
                                        int startHour = 0;
                                        int startMinute = 0;
                                        int closeHour = 0;
                                        int closeMinute = 0;
                                        
                                        String MonDailyStartTime = "";
                                        String MonDailyClosingTime = "";
                                        String TueDailyStartTime = "";
                                        String TueDailyClosingTime = "";
                                        String WedDailyStartTime = "";
                                        String WedDailyClosingTime = "";
                                        String ThursDailyStartTime = "";
                                        String ThursDailyClosingTime = "";
                                        String FriDailyStartTime = "";
                                        String FriDailyClosingTime = "";
                                        String SatDailyStartTime = "";
                                        String SatDailyClosingTime = "";
                                        String SunDailyStartTime = "";
                                        String SunDailyClosingTime = "";
                                        
                                        //getting starting and closing hours for eah day
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection hoursConn = DriverManager.getConnection(url, User, Password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setInt(1, PID);
                                            ResultSet hourRow = hourPst.executeQuery();
                                            
                                            while(hourRow.next()){
                                                
                                                
                                                MonDailyStartTime = hourRow.getString("MondayStart");
                                                MonDailyClosingTime = hourRow.getString("MondayClose");
                                                
                                                TueDailyStartTime = hourRow.getString("TuesdayStart");
                                                TueDailyClosingTime = hourRow.getString("TuesdayClose");
                                                
                                                WedDailyStartTime = hourRow.getString("WednessdayStart");
                                                WedDailyClosingTime = hourRow.getString("WednessdayClose");
                                               
                                                ThursDailyStartTime = hourRow.getString("ThursdayStart");
                                                ThursDailyClosingTime = hourRow.getString("ThursdayClose");
                                               
                                                FriDailyStartTime = hourRow.getString("FridayStart");
                                                FriDailyClosingTime = hourRow.getString("FridayClose");
                                                
                                                SatDailyStartTime = hourRow.getString("SaturdayStart");
                                                SatDailyClosingTime = hourRow.getString("SaturdayClose");
                                                
                                                SunDailyStartTime = hourRow.getString("SundayStart");
                                                SunDailyClosingTime = hourRow.getString("SundayClose");
                                                
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                        try{
                                                if(DayOfWeek.equalsIgnoreCase("Mon")){
                                                    DailyStartTime = MonDailyStartTime.substring(0,5);
                                                    DailyClosingTime = MonDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Tue")){
                                                    DailyStartTime = TueDailyStartTime.substring(0,5);
                                                    DailyClosingTime = TueDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Wed")){
                                                    
                                                    DailyStartTime = WedDailyStartTime.substring(0,5);
                                                    DailyClosingTime = WedDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Thu")){
                                                    DailyStartTime = ThursDailyStartTime.substring(0,5);
                                                    DailyClosingTime = ThursDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Fri")){
                                                    DailyStartTime = FriDailyStartTime.substring(0,5);
                                                    DailyClosingTime = FriDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sat")){
                                                    DailyStartTime = SatDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SatDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sun")){
                                                    DailyStartTime = SunDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SunDailyClosingTime.substring(0,5);
                                                }
                                                
                                                
                                                
                                                startHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                                startMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                                        
                                                        /*formatting the time for user convenience
                                                        if( startHour > 12)
                                                        {
                                                             int TempHour = startHour - 12;
                                                             FormattedStartTime = Integer.toString(TempHour) + ":" +  DailyStartTime.substring(3,5) + " pm";
                                                        }
                                                        else if(startHour == 0){
                                                            FormattedStartTime = "12" + ":" + DailyStartTime.substring(3,5) + " am";
                                                        }
                                                        else if(startHour == 12){
                                                            FormattedStartTime = DailyStartTime + " pm";
                                                        }
                                                        else{
                                                            FormattedStartTime = DailyStartTime +" am";
                                                        }*/
                                               
                                                closeHour = Integer.parseInt(DailyClosingTime.substring(0,2));
                                                closeMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
                                                        
                                                        /*formatting the time for user convenience
                                                        if( closeHour > 12)
                                                        {
                                                             int TempHour = closeHour - 12;
                                                             FormattedClosingTime = Integer.toString(TempHour) + ":" +  DailyClosingTime.substring(3,5) + " pm";
                                                        }
                                                        else if(closeHour == 0){
                                                            FormattedClosingTime = "12" + ":" + DailyClosingTime.substring(3,5) + " am";
                                                        }
                                                        else if(closeHour == 12){
                                                            FormattedClosingTime = DailyClosingTime + " pm";
                                                        }
                                                        else{
                                                            FormattedClosingTime = DailyClosingTime +" am";
                                                        }*/
                                            }
                                            catch(Exception e){}
                                        
                                        
                                    %>
                      
                                    <%
                                        //getting the closed days data
                                        ArrayList<String> ClosedDates = new ArrayList<>();
                                        ArrayList<Integer> ClosedIDs = new ArrayList<>();
                                        boolean isTodayClosed = false;
                                        
                                       
                                        
                                        Date DateForClosedCompare = new Date();
                                        SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare);
                                        
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection CloseddConn = DriverManager.getConnection(url, User, Password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setInt(1, PID);
                                            
                                            ResultSet ClosedRec = CloseddPst.executeQuery();
                                            
                                            while(ClosedRec.next()){
                                                
                                                ClosedDates.add(ClosedRec.getString("DateToClose").trim());
                                                ClosedIDs.add(ClosedRec.getInt("closedID"));
                                                
                                                if(StringDateForCompare.equals(ClosedRec.getString("DateToClose").trim())){
                                                    isTodayClosed = true;
                                                }
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                    %>
                                   
                    <%
                        
                        int TimeBookedFlag = 0;
                        
                        if (CurrentTime.length() == 4)
                            CurrentTime = "0" + CurrentTime;
                        
                        //int CurrentHour = Integer.parseInt(CurrentTime.substring(0,2));
                        //int CurrentMinute = Integer.parseInt(CurrentTime.substring(3,5));
                        
                        //String CurrentStringMinute = Integer.toString(CurrentMinute);
                        //if(Integer.toString(CurrentMinute).length() < 2)
                        //CurrentStringMinute = "0" + CurrentMinute;
                        
                        //if(CurrentHour < StartTimeHour)
                               //CurrenTime = StartHour + CurrentStringMinute;
                               
                        int LastAppointmentTime = 23;
                        
                        if(closeHour != 0)
                            LastAppointmentTime = closeHour;
                        
                            String TimeAfter30Mins = "";
                            String TimeBefore30Mins = "";
                            String TempAppointmentTime = CurrentTime;
                            
                            int TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            
                            if(DailyStartTime != ""){
                                
                                if(TempHour < startHour)
                                    TempAppointmentTime = DailyStartTime;
                            }
                            
                            int TempMinute = 0;
                            
                            if(isTodayClosed == true){
                                                
                                DailyStartTime = "00:00";
                                DailyClosingTime = "00:00";
                                                
                            }

                        while(TempHour < LastAppointmentTime){
                            
                            if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                break;
                            
                            if(TempAppointmentTime.length() == 4)
                               TempAppointmentTime = "0" + TempAppointmentTime;

                            TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            TempMinute = Integer.parseInt(TempAppointmentTime.substring(3,5));

                            TempMinute += IntervalsValue;

                            while(TempMinute >= 60){

                                TempHour++;

                                if(TempMinute > 60 && TempMinute != 60)
                                    TempMinute -= 60;

                                else if(TempMinute == 60)
                                    TempMinute = 0;

                                if(TempHour > 23)
                                    TempHour = 23;

                            }
                            
                            String SMinute = Integer.toString(TempMinute);
                            
                            if(Integer.toString(TempMinute).length() < 2)
                                SMinute = "0" + TempMinute;

                            TimeAfter30Mins = TempHour + ":" + SMinute;

                            //JOptionPane.showMessageDialog(null, TimeAfter30Mins);

                            //the original algo here is go back an hour and start counting up till its about 30 mins before current time
                            int TempHour2 = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            int TempMinute2 = Integer.parseInt(TempAppointmentTime.substring(3,5));

                            TempHour2 -= 5; //turning this into 300 minutes
                            

                            TempMinute2 += 300; //this makes TempMinute2 greater than IntervalsValue according to the prio algo (30 mins algo)
                            
                            //make TempMinute2 greater the the value of IntervalsValue so you can subtract IntervalsValue from it
                            TempMinute2 -= IntervalsValue;
                            
                            while(TempMinute2 >= 60){
                                
                                /*Avoid incrementing the hour hand as it will skip the start of the day
                                if(DailyStartTime != ""){
                                                
                                    if(TempHour2 == startHour){
                                        break;
                                    }
                                                    
                                }else if(TempHour2 == 1){
                                    break;
                                }*/

                                TempHour2++;

                                if(TempMinute2 > 60 && TempMinute2 != 60)
                                    TempMinute2 -= 60;

                                else if(TempMinute2 == 60)
                                    TempMinute2 = 0;

                                if(TempHour2 > 23)
                                    TempHour2 = 23;
                            }
                            
                             //do this to avoid TempMinute2 being over the normal 60 mins per hour
                            // and also to avoid TempHour2 being lses then the providers opening time is there is
                            // and if there isn't, avoid it being less than at least 1am;
                            if(DailyStartTime != ""){
                                            
                                if(TempHour2 < startHour){
                                    TempHour2 = startHour;
                                    TempMinute2 = startMinute;
                                }
                            }else if(TempHour2 < 1){
                                TempHour2 = 1;
                                TempMinute2 = Integer.parseInt(CurrentTime.substring(3,5));
                            }
                            
                            String SMinute2 = Integer.toString(TempMinute2);
                            
                            if(Integer.toString(TempMinute2).length() < 2)
                                SMinute2 = "0" + TempMinute2;

                            TimeBefore30Mins = TempHour2 + ":" + SMinute2;
                            //JOptionPane.showMessageDialog(null, TimeBefore30Mins);
                            
                            try{
            
                                Class.forName(Driver);
                                Connection TimeRangeConn = DriverManager.getConnection(url, User, Password);
                                String TimeRangeString = "Select * from QueueObjects.BookedAppointment where "
                                        + "(ProviderID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))"
                                        + " or (CustomerID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))";

                                PreparedStatement TimeRangePst = TimeRangeConn.prepareStatement(TimeRangeString);
                                TimeRangePst.setInt(1, PID);
                                TimeRangePst.setString(2, StringDate);
                                TimeRangePst.setString(3, TimeBefore30Mins);
                                TimeRangePst.setString(4, TimeAfter30Mins);
                                TimeRangePst.setInt(5, UserID);
                                TimeRangePst.setString(6, StringDate);
                                TimeRangePst.setString(7, TimeBefore30Mins);
                                TimeRangePst.setString(8, TimeAfter30Mins);

                                ResultSet TimeRangeRow = TimeRangePst.executeQuery();
                                while(TimeRangeRow.next()){
                                    
                                    TimeBookedFlag = 1;
                                    String ThisAppointmentTime = TimeRangeRow.getString("AppointmentTime");
                                    
                                    int ThisAppointmentMinute = Integer.parseInt(ThisAppointmentTime.substring(3,5));
                                    int ThisAppointmentHour = Integer.parseInt(ThisAppointmentTime.substring(0,2));
                                    
                                    //ThisAppointmentHour++;
                                    ThisAppointmentMinute += (IntervalsValue + 1);
                                    
                                    while(ThisAppointmentMinute >= 60){
                                        
                                        ThisAppointmentHour++;
                                        
                                        if(ThisAppointmentMinute > 60 && ThisAppointmentMinute != 60)
                                            ThisAppointmentMinute -= 60;
                                        else if(ThisAppointmentMinute == 60)
                                            ThisAppointmentMinute = 0;
                                        
                                    }
                                    
                                    String ThisAppointmentStringMinute = Integer.toString(ThisAppointmentMinute);
                                    
                                    if(ThisAppointmentStringMinute.length() < 2)
                                        ThisAppointmentStringMinute = "0" + ThisAppointmentStringMinute;
                                    
                                    TempAppointmentTime = ThisAppointmentHour + ":" + ThisAppointmentStringMinute;
                                    break;
                                }

                            }catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            if(TimeBookedFlag == 0){
                            
                                AllAvailableTimeList.add(TempAppointmentTime);
                                TempAppointmentTime = TimeAfter30Mins;
                                
                            }
                            
                            TimeBookedFlag = 0;
                            
                        }

                        
                    %>
                    
                    <%
                        //getting coverdata
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,PID);
                            ResultSet cover = coverPst.executeQuery();
                            
                            while(cover.next()){
                                
                                 try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob profilepic = cover.getBlob("CoverPhoto"); 
                                    InputStream inputStream = profilepic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                    base64Cover = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){

                                }
                                 
                                if(!base64Cover.equals(""))
                                    break;

                            }
                            
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    %>
                    
                    
                    <tbody>
                        <tr>
                            <td>
                                <center><div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                    <img class="fittedImg" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                                </div></center>
                    
                                <div class="proinfo">
                                    
                                 <table id="ProInfoTable" style="width: 100%; border-spacing: 0; box-shadow: 0; margin-left: 0;">
                                <tbody>
                                <tr>
                                    <td><b><p style="font-size: 20px; text-align: center;"><span><!--img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/-->
                                            <%=fullName%></span></p></b></td>
                                </tr>
                                <tr>
                                    <td><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                        <%=Company%> <span style="color: blue; font-size: 25px;">
                                        <%
                                            if(ratings ==5){
                                        
                                        %> 
                                        ★★★★★
                                        <%
                                             }else if(ratings == 4){
                                        %>
                                        ★★★★☆
                                        <%
                                             }else if(ratings == 3){
                                        %>
                                        ★★★☆☆
                                        <%
                                             }else if(ratings == 2){
                                        %>
                                        ★★☆☆☆
                                        <%
                                             }else if(ratings == 1){
                                        %>
                                        ★☆☆☆☆
                                        <%}%></span>
                                        </td>
                                </tr>
                                <tr>
                                    <td><img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                        <%=Email%>, <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                        <%=phoneNumber %> </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td><img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                        <%=fullAddress%> </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                </tr>
                                </tbody>
                                </table>
                                
                                </div>
                                    
                                <form >
                                    
                                    <%
                                        if(FormattedAppointmentTime != " "){
                                            
                                    %>
                                    
                                    <p id="ShowThisAppointmentTimeForFinishAppointmentWindow" style="color: red;">This line spot is for <%=ResendAppointmentData.AppointmentDate%> at <%=FormattedAppointmentTime%></p>
                                    
                                    <%}%>
                                    
                                    <p id="showCustomizeTimeBtn" onclick="showCustomizeDate()" style="text-align: center; border: 1px solid black; background-color: pink; padding: 5px; cursor: pointer;">Customize Your Spot</p>
                                    
                                    <div id="customizeAppointmentTime" style="background-color: #eeeeee;">
                                        
                                    <div id="serviceslist">
                                        
                                       <p style="color: tomato;">Select Date</p>
                                       <p>Click on date field below to set date</p>
                                       
                                       <p><input onclick="initializeDate()" style = "background-color: white; border: 1px solid black; padding: 5px;" type="text" id="datepicker" name="chooseDate" value="<%=ResendAppointmentData.AppointmentDate%>" readonly></p>
                                       <p id="datepickerStatus" style="text-align: center; color: white; background-color: red;"></p>
                                       <p id="DateStatus" style="color: white; background-color: green; text-align: center;"></p>
                                    </div> 
                                        
                                    <div id="serviceslist">
                                        
                                        <p style="color: tomato;">Select Time</p>
                                    
                                        <center><p><span><select onclick ="showTime()" id="HHSelector" name="hourOptions" 
                                                                         style="">
                                                                 <option>HH</option>
                                                                 <option>01</option>
                                                                 <option>02</option>
                                                                 <option>03</option>
                                                                 <option>04</option>
                                                                 <option>05</option>
                                                                 <option>06</option>
                                                                 <option>07</option>
                                                                 <option>08</option>
                                                                 <option>09</option>
                                                                 <option>10</option>
                                                                 <option>11</option>
                                                                 <option>12</option>
                                                                 </select></span>
                                                <span><select onclick="showTime()" id="MMSelector" name="minuteOptions" 
                                                                         style="">
                                                                 <option>MM</option>
                                                                 <option>01</option>
                                                                 <option>02</option>
                                                                 <option>03</option>
                                                                 <option>04</option>
                                                                 <option>05</option>
                                                                 <option>06</option>
                                                                 <option>07</option>
                                                                 <option>08</option>
                                                                 <option>09</option>
                                                                 <option>10</option>
                                                                 <option>11</option>
                                                                 <option>12</option>
                                                                 <option>13</option>
                                                                 <option>14</option>
                                                                 <option>15</option>
                                                                 <option>16</option>
                                                                 <option>17</option>
                                                                 <option>18</option>
                                                                 <option>19</option>
                                                                 <option>20</option>
                                                                 <option>21</option>
                                                                 <option>22</option>
                                                                 <option>23</option>
                                                                 <option>24</option>
                                                                 <option>25</option>
                                                                 <option>26</option>
                                                                 <option>27</option>
                                                                 <option>28</option>
                                                                 <option>29</option>
                                                                 <option>30</option>
                                                                 <option>31</option>
                                                                 <option>32</option>
                                                                 <option>33</option>
                                                                 <option>34</option>
                                                                 <option>35</option>
                                                                 <option>36</option>
                                                                 <option>37</option>
                                                                 <option>38</option>
                                                                 <option>39</option>
                                                                 <option>40</option>
                                                                 <option>41</option>
                                                                 <option>42</option>
                                                                 <option>43</option>
                                                                 <option>44</option>
                                                                 <option>45</option>
                                                                 <option>46</option>
                                                                 <option>47</option>
                                                                 <option>48</option>
                                                                 <option>49</option>
                                                                 <option>50</option>
                                                                 <option>51</option>
                                                                 <option>52</option>
                                                                 <option>53</option>
                                                                 <option>54</option>
                                                                 <option>55</option>
                                                                 <option>56</option>
                                                                 <option>57</option>
                                                                 <option>58</option>
                                                                 <option>59</option>
                                                                 <option>00</option>
                                                                 <option></option>
                                                                 </select></span>
                                                <span><select onclick="showTime()" id="AmPmSelector" name="AmPmOptions" 
                                                                         style="">
                                                                 <option>am</option>
                                                                 <option>pm</option>
                                                                 </select></span>
                                                                 
                                            </p></center>
                                        <p id="timeStatus" style="color: white; background-color: green; text-align: center;"></p>
                                        <p id="HideSuggestedTimeDivStatus" style="color: white; background-color: green; text-align: center;"></p>
                                    
                                    </div>
                                        
                                    </div>
                                    
                                    <div id="QueuLineDiv">
                                        
                                        <p style="color: tomato;">Suggested Spots Listed Below</p> 
                                      
                                        <center><p>You may also choose a spot from suggested list below</p></center>
                                        
                                        <p id="showAllSuggestedTimeBtn" onclick="showSuggestedTime()" style="text-align: center; border: 1px solid black; background-color: pink; padding: 5px; cursor: pointer;">Show All Suggested Spots</p>
                                        
                                        <center><p id="SuggestedTimeDivStatus" style="color: white; background-color: green; text-align: center;"></p></center>
                                   
                                    <center><div id="AllSuggestedTimeDiv" style="display: none;">
                                       
                                    <%
                                        String FormattedAvailableTime = "";
                                        int HourForFormattedTimedAvail = 0;
                                        int MinuteFroFormattedTimeAvail = 0;
                                        
                                        for(int q = 0; q < AllAvailableTimeList.size(); q++){
                                            
                                            FormattedAvailableTime = AllAvailableTimeList.get(q);
                                            HourForFormattedTimedAvail = Integer.parseInt(FormattedAvailableTime.substring(0,2));
                                            MinuteFroFormattedTimeAvail = Integer.parseInt(FormattedAvailableTime.substring(3,5));
                                                        
                                            //formatting the time for user convenience
                                            if( HourForFormattedTimedAvail > 12)
                                            {
                                                int TempHourAvail = HourForFormattedTimedAvail - 12;
                                                FormattedAvailableTime = Integer.toString(TempHourAvail) + ":" +  FormattedAvailableTime.substring(3,5) + " pm";
                                            }
                                            else if(HourForFormattedTimedAvail == 0){
                                                FormattedAvailableTime = "12" + ":" + FormattedAvailableTime.substring(3,5) + " am";
                                            }
                                            else if(HourForFormattedTimedAvail == 12){
                                                FormattedAvailableTime = FormattedAvailableTime + " pm";
                                            }
                                            else{
                                                FormattedAvailableTime = FormattedAvailableTime +" am";
                                            }
                                                        
                                            //if(AllAvailableTimeList.get(q) == CurrentTime)
                                                //continue;
                                        
                                    %>
                                   
                                        <div class="SuggestedTime" onclick="setSuggestedTime(<%=q%>)" id="AvailableTimeDiv<%=q%>" style="cursor: pointer; margin: 2px; margin-bottom: 10px; padding-left: 1px; padding-right: 1px; width: 70px; border: 1px solid black; float: left;">
                                            <p id="FormattedTimeAvalible<%=q%>" style="color: blue; font-size: 13px; font-weight: bold; text-align: center;"><%=FormattedAvailableTime%></p>
                                            <p id="TimeAvailable<%=q%>" style="display: none;"><%=AllAvailableTimeList.get(q)%></p>
                                            <center><img src="icons/icons8-schedule-50.png" width="50" height="50" alt="icons8-schedule-50"/></center>
                                        </div>
                                              
                                    <%}%> 
                                    
                                    </div></center>
                                    
                                    <%
                                        if(AllAvailableTimeList.size() == 0){
                                    %>
                                    
                                        <p style="background-color: red; color: white; text-align: center;">No available spot suggestions at this time</p>
                                    
                                    <%}%>
                                    <p style="clear: both;"></p>         
                                    </div>
                                    
                                     <% 
                                        //calculating cancellation charge
                                        DecimalFormat decformat = new DecimalFormat("#.00");
                                        double CnclCharge = 0;
                                        if(hasCancellation){
                                            CnclCharge = ((ChargePercent * TaxedPrice) / 100);
                                            CnclCharge = Double.parseDouble(decformat.format(CnclCharge));
                                        }
                                        String tempdouble = "";
                                        tempdouble = decformat.format(TaxedPrice);
                                        TaxedPrice = Double.parseDouble(tempdouble);
                                        
                                    %>
                                    
                                    <div id="serviceslist" style="clear: both;">
                                        
                                        <div id="reviewsheet">
                                        
                                        <p style="color: tomato;">Review Spot Details</p>
                                        
                                        <p> Type: <span style="color: red; float: right;"><%=ServiceCategory%></span></p>
                                        <p><input id="formsServiceCategory" type="hidden" name="formsServiceCategory" value="<%=ServiceCategory%>" /></p>
                                        <p> Date: <span id="dateDisplay" style="color: red; float: right;"></span></p>
                                        <p><input id="formsDateValue" type="hidden" name="formsDateValue" value="" /></p>
                                        <p> Time: <span id="displayTime" style="color: red; float: right;"><%=FormattedAppointmentTime%></span></p>
                                        <p><input id="formsTimeValue" type="hidden" name="formsTimeValue" value="<%=AppointmentTime%>" /></p>
                                        <p> Reason: <span style="color: red; float: right;"><%=ResendAppointmentData.SelectedServices%></span>
                                        <input id="formsOrderedServices" type="hidden" name="formsOrderedServices" value="<%=ResendAppointmentData.SelectedServices%>" />
                                            
                                            <%
                                                if(ResendAppointmentData.SelectedServices == ""){
                                            
                                            %><span style="color: red; float: right;">None(Go to previous page)</span> 
                                            
                                            <%  }   //end of condition%>
                                            
                                            </p>
                                        <p> Payment:<span style="color: red; float: right;">
                                                <%
                                                    if(!hasCancellation){
                                                %>
                                                <span onclick="toggleHideCardDetailsDiv()"><input id="Cash" type="radio" name="payment" value="Cash" style="background-color: white;"/><label for="Cash" style="margin-right: 5px">Later</label></span>
                                                /<%}%> <span onclick="toggleShowCardDetailsDiv()"><input onclick="toggleShowCardDetailsDiv()" id="Credit/Debit" type="radio" name="payment" value="Debit/Credit Card" style="background-color: white;"/><label for="Credit/Debit">Now</label></span></span></p>
                                       <p style="clear: both;"></p>
                                        <p> Total: <span style="color: red; float: right;">$<%=TaxedPrice%></span></p>
                                        <%
                                            if(hasCancellation){
                                        %>
                                        <p> Cancellation Charge: <span style="color: red; float: right;">$<%=CnclCharge%></span></p>
                                        <%}%>
                                        <input id="TaxedPrice" type="hidden" name="TotalPrice" value="<%=TaxedPrice%>" />
                                        
                                        <input id="SendApptPID" type="hidden" name="ProviderID" value="<%=PID%>" />
                                        <input id="SendApptCustID" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                        <input id="SendApptUserIndex" type="hidden" name="UserIndex" value="<%=UserIndex%>"/>
                                        <input id="SendApptUser" type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                        </div>
                                        
                                    </div>
                                        
                                    <center>
                                        
                                        <%
                                            if(hasCancellation == true){
                                        %>
                                        <p style="background-color: red; text-align: center; color: white;"><%=fullName%> has a cancellation policy.</p>
                                        <%}%>
                                        
                                        <p id="ConfirmAppointmentStatusTxt" style="text-align: center; background-color: red; color: white;"></p>
                                        <input id="submitAppointment" style="border: black solid 1px; background-color: red; border-radius: 5px; color: white;
                                                   padding: 5px;"
                                                   type="button" value="Confirm" />
                                    </center>
                                        
                                        <script>
                                            
                                            $(document).ready(function(){
                                                
                                                $("#submitAppointment").click(function(even){
                                                 
                                                    var ProviderID = document.getElementById("SendApptPID").value;
                                                        var CustomerID = document.getElementById("SendApptCustID").value;
                                                        var UserIndex = document.getElementById("SendApptUserIndex").value;
                                                        var NewUserName = document.getElementById("SendApptUser").value;
                                                        var TotalPrice = document.getElementById("TaxedPrice").value;
                                                        var ApptDate = document.getElementById("formsDateValue").value;
                                                        var ApptTime = document.getElementById("formsTimeValue").value;
                                                        var ApptReason = document.getElementById("formsOrderedServices").value;
                                                        var PayMeth = $("input:radio[name=payment]:checked").val();
                                                        
                                                        /*alert("ProviderID: "+ProviderID);
                                                        alert("CustomerID: "+CustomerID);
                                                        alert("UserIndex: "+UserIndex);
                                                        alert("TotalPrice: "+TotalPrice);
                                                        alert("ApptDate: "+ApptDate);
                                                        alert("ApptTime: "+ApptTime);
                                                        alert("ApptReason: "+ApptReason);
                                                        alert("Payment Method: "+PayMeth);*/
                                                        
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "SendAppointmentControl",  
                                                            data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&TotalPrice="+TotalPrice+"&formsDateValue="+ApptDate+"&formsTimeValue="+ApptTime+"&formsOrderedServices="+ApptReason+"&payment="+PayMeth,  
                                                            success: function(result){  
                                                              //alert(result);
                                                              if(result === "Success"){
                                                                  alert("You've been enqueued successfully!");
                                                                  if($(window).width() > 1000){
                                                                    window.location.replace("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
                                                                  }
                                                              }else{
                                                                  alert(result);
                                                              }
                                                              //document.getElementById("eachClosedDate<>").style.display = "none";
                                                            }
                                                        });
                                                });
                                            });
                                            
                                        </script>
                                </form>
                                        
                                        <center><div id="CreditDebitCardDetails" style="padding: 10px; background-color: darkgray;">
                                            <p style="color: white; text-align: center;">Add Your Debit/Credit Card</p>
                                            
                                                    
                                            <form name="PaymentForm" action="PayAndSubmitQueueLoggedIn.jsp" method="POST">
                                                
                                                <input type='hidden' name="ProviderID" value="<%=PID%>" />
                                                <input type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                                <input type="hidden" name="OrderedServices" value="<%=ResendAppointmentData.SelectedServices%>" />
                                                <input id="PayFormAppointmentDate" type="hidden" name="AppointmentDate" value="" />
                                                <input id="PayFormAppointmentTime" type="hidden" name="AppointmentTime" value="" />
                                                <input type="hidden" name="ServicesCost" value="<%=TaxedPrice%>" />
                                                <input type="hidden" name="CancellationCharge" value="<%=CnclCharge%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                
                                                <script>
                                                    
                                                    setInterval(function(){
                                                            var AppointmentDate = document.getElementById("formsDateValue").value;
                                                            var AppointmentTime = document.getElementById("formsTimeValue").value;
                                                            
                                                            document.getElementById("PayFormAppointmentDate").value = AppointmentDate;
                                                            document.getElementById("PayFormAppointmentTime").value = AppointmentTime;
                                                            
                                                        }, 1);                                     
                                                    
                                                    
                                                </script>
                                                
                                                
                                            <%
                                                if(hasCancellation){
                                            %>
                                            <p style="color: #ffffff; background-color: red; text-align: center; padding: 5px;">This service provider has a cancellation policy of <span style=""><%=ChargePercent%>%</span> of total service cost</p>
                                            <p style="color: #ffffff; background-color: red; text-align: center; padding: 5px;">You may cancel your spot <%=CancelElapse%> minutes before spot due time to avoid cancellation charges</p>
                                            <%}%>
                                                
                                                <table id="paymentDetailsTable">
                                                    <tbody>
                                                    
                                                        <tr><td style="border-radius: 0; padding: 4px;">Card Number: </td><td style="border-radius: 0; padding: 4px;"><input onclick="checkMiddleCardNumber();" onkeydown="checkMiddleCardNumber();" id="cardNumber" style="background-color: #eeeeee;" type="text" name="C/DcardNumber" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Card Holder's Name: </td><td style="border-radius: 0; padding: 4px;"><input id="cardName" style="background-color: #eeeeee;" type="text" name="holdersName" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Expiration Date: </td><td style="border-radius: 0; padding: 4px;"><input id="cardDate" style="background-color: #eeeeee; max-width: 100px;" type="text" name="cardExpDate" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Security Code: </td><td style="border-radius: 0; padding: 4px;"><input id="cardCVV" style="background-color: #eeeeee; max-width: 100px;" type="text" name="secCode" value="" /></td></tr>
                                                        
                                                    </tbody>
                                                </table>
                                            
                                                <script>
                                                    var cardNumber = document.getElementById("cardNumber");

                                                    function numberFuncCardNumber(){

                                                        var number = parseInt((cardNumber.value.substring(cardNumber.value.length - 1)), 10);

                                                        if(isNaN(number)){
                                                            cardNumber.value = cardNumber.value.substring(0, (cardNumber.value.length - 1));
                                                        }

                                                    }

                                                    setInterval(numberFuncCardNumber, 1);

                                                    function checkMiddleCardNumber(){

                                                        for(var i = 0; i < cardNumber.value.length; i++){

                                                            var middleString = cardNumber.value.substring(i, (i+1));
                                                            //window.alert(middleString);
                                                            var middleNumber = parseInt(middleString, 10);
                                                            //window.alert(middleNumber);
                                                            if(isNaN(middleNumber)){
                                                                cardNumber.value = cardNumber.value.substring(0, i);
                                                            }
                                                        }
                                                    }

                                                    //setInterval(checkMiddleNumber, 1000);
                                                </script>
                                                
                                                <script>
                                                    var ExpDateFld = document.getElementById("cardDate");
                                                         
                                                         setInterval(function(){
                                                             
                                                            if(ExpDateFld.value !== ""){
                                                                
                                                               if(ExpDateFld.value.length === 2){
                                                                   
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,2) + "/" + ExpDateFld.value.substring(2);
                                                                  
                                                                   if(ExpDateFld.value === "///" || ExpDateFld.value.substring(1,3) === "//" || ExpDateFld.value.substring(0,1) === "/"){
                                                                       ExpDateFld.value = "";
                                                                   }
                                                                   
                                                               }
                                                               //checking if month is greater than 12
                                                               var month = parseInt((ExpDateFld.value.substring(0,2)), 10);
                                                               var month1 = parseInt((ExpDateFld.value.substring(0,1)), 10);
                                                               var month2 = parseInt((ExpDateFld.value.substring(1,2)), 10);
                                                               var year = parseInt((ExpDateFld.value.substring(3,5)), 10);
                                                               var year1 = parseInt((ExpDateFld.value.substring(3,4)), 10);
                                                               var year2 = parseInt((ExpDateFld.value.substring(4,5)), 10);
                                                               
                                                               if(month !== null){
                                                                    if(month > 12){
                                                                        ExpDateFld.value = "12" + ExpDateFld.value.substring(2,5);
                                                                    }
                                                                }
                                                                //checking if entered date is more than 5 characters
                                                               if(ExpDateFld.value.length > 5){
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,5);
                                                               }
                                                               //checking is what's entered is is not a number 
                                                               if(isNaN(month1))
                                                                   ExpDateFld.value = "";
                                                               if(isNaN(month2))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,1) + "";
                                                               if(isNaN(year1))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,3) + "";
                                                               if(isNaN(year2))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,4) + "";
                                                              
                                                            }
                                                         },1);
                                                </script>
                                            
                                                <p id="paymentBtnStatus" style="background-color: green; color: white; text-align: center;"></p>
                                                <input id="submitPaymentBtn" style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;" type="submit" value="Submit Payment" name="paymentBtn" />
                                                
                                            </form>
                                                  
                                        <%
                                            if(hasCancellation == true){
                                        %>
                                        
                                        <script>
                                             document.getElementById("Credit/Debit").checked = true;
                                             document.getElementById("submitAppointment").style.display = "none";
                                             document.getElementById("CreditDebitCardDetails").style.display = "block";
                                        </script>
                                        <%}%>
                                            
                                            <script>
                                                    
                                                        var cardNumber = document.getElementById("cardNumber");
                                                        var cardName = document.getElementById("cardName");
                                                        var cardDate = document.getElementById("cardDate");
                                                        var cardCVV = document.getElementById("cardCVV");
                                                        var formsDateValue = document.getElementById("formsDateValue");
                                                        var formsTimeValue = document.getElementById("formsTimeValue");
                                                        var submitPaymentBtn = document.getElementById("submitPaymentBtn");
                                                        var paymentBtnStatus = document.getElementById("paymentBtnStatus");
                                                        
                                                        function checksubmitPaymentBtn(){
                                                            
                                                            if(formsDateValue.value === "" || formsTimeValue.value === "" || formsDateValue.value === " " || formsTimeValue.value === " "
                                                                    || cardNumber.value === "" || cardName.value === "" || cardDate.value === "" || cardCVV.value === ""){
                                                                submitPaymentBtn.style.backgroundColor = "darkgrey";
                                                                submitPaymentBtn.disabled = true;
                                                                paymentBtnStatus.innerHTML = "Please set date or time. Or enter all card information in form above";
                                                            }else{
                                                                submitPaymentBtn.style.backgroundColor = "pink";
                                                                submitPaymentBtn.disabled = false;
                                                                paymentBtnStatus.innerHTML = "";
                                                            }
                                                                
                                                            
                                                        }
                                                        
                                                        setInterval(checksubmitPaymentBtn, 1);
                                                    
                                                </script> 
                                                
                                        </div></center>
                            </td> 
                        </tr>
                    </tbody>
                    
                    <%}//end of for loop%>
                    
                    </table></center>
                    
                </div></center>
                
            </div>
                    
        </div>
                    
        <div id="newbusiness">
            
            <div id="ExtraproviderIcons" style="margin-top: -13px;">
             
                <div id="SearchDivNB">
                <center><form action="ByAddressSearchResultLoggedIn.jsp" method="POST" style="background-color: #6699ff; border: 1px solid buttonshadow; padding: 5px; border-radius: 5px; width: 90%;">
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <input type="hidden" name="User" value="<%=NewUserName%>" />
                    <p style="color: #000099;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                        Find services at location below</p>
                    <p>City: <input style="width: 80%; background-color: #6699ff;" type="text" name="city4Search" placeholder="" value="<%=PCity%>"/></p> 
                    <p>Town: <input style="background-color: #6699ff; width: 40%" type="text" name="town4Search" value="<%=PTown%>"/> Zip Code: <input style="width: 19%; background-color: #6699ff;" type="text" name="zcode4Search" value="<%=PZipCode%>" /></p>
                    <p><input type="submit" style="background-color: #6699ff; color: white; padding: 5px; border-radius: 5px; border: 1px solid white; width: 95%;" value="Search" /></p>
                    </form></center>
                </div>
                
             <center><h4 style="margin: 5px; margin-top: 15px;">Explore Service Providers</h4></center>
                
                <div id="firstSetProvIcons">
                <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectPodiatryLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PodiatrySelect">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHairSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMassageLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MassageSelect">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHolisticMedicineLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-pill-filled-70.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMedAesthetLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MedEsthSelect">Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectDentistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                            </a></center></td>
                        </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Next</p></center>
                
                </div>
                
                <div id="secondSetProvIcons" style="display: none;">
                    <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBrowLashLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="EyebrowsSelect">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                            </a></center></td>
                             <td style="width: 33.3%;"><center><a href="QueueSelectDieticianLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="DieticianSelect">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectPetServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PetServicesSelect">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHomeServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPiercingLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectTattooLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                            </a></center></td>
                        <tr>
                            <td><center><a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPersonalTrainerLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPhysicalTherapyLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                            </a></center></td>
                        </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p style="margin-bottom: 7px; margin-top: 10px;"><span onclick="showFirstSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; cursor: pointer; border-radius: 4px;">Previous</span>
                            <span onclick="showThirdSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; padding-left: 17px; padding-right: 18px; width: 50px; cursor: pointer; border-radius: 4px;">Next</span></p></center>
                
                </div>
                
                <div id="thirdSetProvIcons" style="display: none;">
                        <center><table id="providericons">
                        <tbody>
                            <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectHairRemovalLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            </tr> 
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                                </a></center></td>
                            </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondFromThirdProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Previous</p></center>

                </div>
            </div>
            
        </div>
                    
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                    
    </div>
                    
    </body>
    
    <script>
    
    document.getElementById("showAllSuggestedTimeBtn").style.display = "none";
    //document.getElementById("showCustomizeTimeBtn").style.display = "none";
    
    window.scrollTo(0,document.body.scrollHeight);
    //document.getElementById("customizeAppointmentTime").style.display = "block";
    document.getElementById("AllSuggestedTimeDiv").style.display = "block";
            
            
    </script>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/appointmentDateBehaviors.js"></script>
    <script src="scripts/CreditDebitCardBehavior.js"></script>
    <script src="scripts/SuggestedTime.js"></script>
    <script src='scripts/QueueLineDivBehavior.js'></script>
        
</html>
