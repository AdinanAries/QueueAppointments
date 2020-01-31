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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Queue | Settings</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <!--script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script-->
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
        <meta name="apple-mobile-web-app-status-bar" content="#ccccff" />
        
    </head>
    
    <script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl",config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver",config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser",config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword",config.getInitParameter("password"));
        
        int UserID = 0;
        int UserIndex = -1;
        String NameFromList = "";
        String NewUserName = "";
        
        boolean isTrySuccess = true;
        boolean isSameUserName = true;
        
        int Settings = Integer.parseInt(request.getParameter("Settings"));
        
        try{
            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        }catch(Exception e){}
        
        try{
            NewUserName = request.getParameter("User");
        }catch(Exception e){}
        
        try{
            NewUserName = request.getAttribute("UserName").toString();
        }catch(Exception e){}
       
        
        try{
            String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

            if(tempAccountType.equals("CustomerAccount")){
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
                NameFromList = UserAccount.LoggedInUsers.get(UserIndex).getName();
            }
                
            //incase of array flush
            if(!NewUserName.equals(NameFromList)){
                isSameUserName = false;
               // response.sendRedirect("LogInPage.jsp");
            }
            
            /*if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }*/

            
        }catch(Exception e){
            isTrySuccess = false;
            //response.sendRedirect("LogInPage.jsp");
        }
        
        if(!isSameUserName || !isTrySuccess || UserID == 0){
            response.sendRedirect("LogInPage.jsp");
        }
        
        
        int notiCounter = 0;
        
        //connection arguments
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        ProviderCustomerData eachCustomer = null;
        
        String FirstName = "";
        String MiddleName = "";
        String LastName = "";
        String Email = "";
        String PhoneNumber = "";
        String thisUserName = "";
        
        String AppointmentDateValue = "";
        
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, User, Password);
            String Query = "Select * from ProviderCustomers.CustomerInfo where Customer_ID=?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setInt(1,UserID);
            ResultSet userData = pst.executeQuery();
            
            while(userData.next()){
                
                eachCustomer = new ProviderCustomerData(userData.getInt("Customer_ID"), userData.getString("First_Name"), userData.getString("Middle_Name"), 
                        userData.getString("Last_Name"), userData.getBlob("Profile_Pic"), userData.getString("Phone_Number"), userData.getDate("Date_Of_Birth"), userData.getString("Email"));
                
                FirstName = userData.getString("First_Name");
                MiddleName = userData.getString("Middle_Name");
                LastName = userData.getString("Last_Name");
                Email = userData.getString("Email");
                PhoneNumber = userData.getString("Phone_Number");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        ArrayList<BookedAppointmentList> AppointmentListExtra = new ArrayList<>();
        
        //Getting Appointments for Extra Div
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StringCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, User, Password);
            String Select = "Select * from QueueObjects.BookedAppointment where CustomerID = ? and AppointmentDate = ?";
            PreparedStatement pst = conn.prepareStatement(Select);
            pst.setInt(1, UserID);
            pst.setString(2, StringCurrentdate);
            ResultSet Appointments = pst.executeQuery();
            
            BookedAppointmentList eachAppointmentItem;
            
            while(Appointments.next()){
                
                String Reason = Appointments.getString("OrderedServices").trim();
                if(Reason.equals("Blocked Time")){
                    
                    continue;
                    
                }
                
                int ProviderID = Appointments.getInt("ProviderID");
                AppointmentDateValue = Appointments.getString("AppointmentDate");
                
                String ProviderName = "";
                String ProviderCompany = "";
                String ProviderEmail = "";
                String ProviderTel = "";
                Blob ProviderDisplayPic = null;
                
                try{
                    
                    Class.forName(Driver);
                    Connection providerConn = DriverManager.getConnection(url, User, Password);
                    String providerQuery = "Select First_Name, Company, Phone_Number, Email, Profile_Pic  from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement providerPst = providerConn.prepareStatement(providerQuery);
                    providerPst.setInt(1, ProviderID);
                    
                    ResultSet providerRecord = providerPst.executeQuery();
                    
                    while(providerRecord.next()){
                        
                        ProviderName = providerRecord.getString("First_Name");
                        ProviderCompany = providerRecord.getString("Company");
                        ProviderTel = providerRecord.getString("Phone_Number");
                        ProviderEmail = providerRecord.getString("Email");
                        ProviderDisplayPic = providerRecord.getBlob("Profile_Pic");
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                int AppointmentID = Appointments.getInt("AppointmentID");
                Date AppointmentDate = Appointments.getDate("AppointmentDate");
                String AppointmentTime = Appointments.getString("AppointmentTime");
                
                eachAppointmentItem = new BookedAppointmentList(AppointmentID, ProviderID, ProviderName, ProviderCompany, ProviderTel, ProviderEmail, AppointmentDate, AppointmentTime, ProviderDisplayPic);
                eachAppointmentItem.setAppointmentReason(Reason);
                AppointmentListExtra.add(eachAppointmentItem);
                
            }
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
    //------------------------------------------------------------------------------------------------------------------------------------------    
        //Getting Notifications data
        ArrayList<String> Notifications = new ArrayList<>();
        String NotiIDs = "{\"Data\" : [ ";
        
        try{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Class.forName(Driver);
            Connection NotiConn = DriverManager.getConnection(url, User, Password);
            String NotiQuery = "Select Noti_Type, What, Noti_Status, ID from ProviderCustomers.Notifications where (CustID = ? and Noti_Type not like 'Today%')"
                    + "or (CustID = ? and Noti_Date = ? and Noti_Type like 'Today%') order by ID desc";
            PreparedStatement NotiPst = NotiConn.prepareStatement(NotiQuery);
            NotiPst.setInt(1, UserID);
            NotiPst.setInt(2, UserID);
            NotiPst.setString(3, sdf.format(new Date()));
            
            ResultSet NotiRec = NotiPst.executeQuery();
            boolean isFirst = true;
            
            while(NotiRec.next()){
                
                if(isFirst == false)
                    NotiIDs += ", ";
                
                if(NotiRec.getString("Noti_Status") == null){
                    notiCounter++;
                    NotiIDs += "{ \"ID\":\"" +(NotiRec.getInt("ID")) + "\" }";
                    Notifications.add("<span style='color: red; font-weight: bolder;'>"+NotiRec.getString("Noti_Type")+"</span>: "+NotiRec.getString("What")+"<sub style='color: red;'> - new</sub>");
                }else{
                    NotiIDs += "{ \"ID\":\"" +(NotiRec.getInt("ID")) + "\" }";
                    Notifications.add("<span style='color: blue; font-weight: bolder;'>"+NotiRec.getString("Noti_Type")+"</span>: "+NotiRec.getString("What")+"<sub style='color: blue;'> - seen</sub>");
                }
                
                isFirst = false;
                if(Notifications.size() > 10)
                    break;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        NotiIDs += " ] }";
        //JOptionPane.showMessageDialog(null, NotiIDs);
       
     //----------------------------------------------------------------------------------------------------------------------   
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background-color: #ccccff; padding-bottom: 0;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
    <center><div id='PhoneSettingsPgNav' style='margin-bottom: 5px; background-color: #000099; padding: 5px; box-shadow: 4px 4px 4px #334d81;'>
        <ul>
            
            <textarea style="display: none;" id="NotiIDInput" rows="4" cols="20"><%=NotiIDs%>
            </textarea>
            
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href='ProviderCustomerPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>'><li  style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="28" height="25" alt="icons8-home-50"/>
                
                </li></a>
            <li onclick="showPCustExtraNews();" id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'>
                <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                
            </li>
            <li onclick="showPCustExtraNotification();" id='PhPermDivNotiBtn' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><p><img style='background-color: white; margin-right: 0;' src="icons/icons8-notification-50.png" width="28" height="25" alt="icons8-notification-50"/>
                 <span id='notiCounterSup' style='color: red; background-color: white; padding: 2px; margin-left: 0;'><%=notiCounter%></span></p>
            </li>
            <li onclick='showPCustExtraCal();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="28" height="25" alt="icons8-calendar-50"/>
                
            </li>
            <li onclick='showPCustExtraUsrAcnt();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="28" height="25" alt="icons8-user-50 (1)"/>
                
            </li>
        </ul>
            
            <script>
                    $(document).ready(function(){
                        $("#PhPermDivNotiBtn").click(function(event){
                            
                            var NotiIDs = document.getElementById("NotiIDInput").value;
                            var NotiJSON = JSON.parse(NotiIDs);
                            
                            for(i in NotiJSON.Data){
                                //alert(NotiJSON.Data[i].ID);
                                var ID = NotiJSON.Data[i].ID;
                                $.ajax({
                                    type: "POST",
                                    url: "SetNotificationAsSeen",
                                    data: "ID="+ID,
                                    success: function(result){
                                        document.getElementById("notiCounterSup").innerHTML = " 0 ";
                                    }
                                });
                            }
                            
                        });
                    });
                </script>
            
        </div></center>
        
    <center><div id="PhoneExtras" style="">
            
            <div id='PhoneNews' style='width: 100%;' >
                <script>
                    document.getElementById("PhoneNews").style.display = "none";
                </script>
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Updates from your providers</p></center>
            
               <div style="max-height: 100%; overflow-y: auto;">
                    
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

                    <table  id="PhoneExtrasTab" cellspacing="0" style="margin-bottom: 3px; padding: 4px; width: 90%; background-color: white; max-width: 600px;">
                        <tbody>
                            <tr style="background-color: #333333;">
                                <td>
                                    <div id="ProvMsgBxOne">
                                        <p style='font-weight: bolder; margin-bottom: 4px;'>
                                            <div style="float: right; width: 65px;">
                                                <%
                                                    if(base64Profile != ""){
                                                %>
                                                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                                        <img class="fittedImg" id="" style="width:50px; height: 50px; border-radius: 100%; border: 2px solid green; margin-bottom: 20px; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    </div></center>
                                                <%
                                                    }else{
                                                %>

                                                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                                        <img style='width:50px; height: 50px; border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                    </div></center>

                                                <%}%>
                                            </div>
                                            <span style='color: #eeeeee;'><%=ProvFirstName%> - <%=ProvCompany%></span>
                                        </p>

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
                
                <table  id="PhoneExtrasTab" cellspacing="0" style="margin-bottom: 3px; padding: 4px; width: 90%; background-color: white; max-width: 600px;">
                    <tbody>
                        <tr style="background-color: #333333;">
                            <td>
                                <div id="ProvMsgBxOne">
                                    <p style='font-weight: bolder; margin-bottom: 4px;'>
                                        <div style="float: right; width: 65px;">
                                            <%
                                                if(base64Profile != ""){
                                            %>
                                                <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                                    <img class="fittedImg" id="" style="width:50px; height: 50px; border-radius: 100%; border: 2px solid green; margin-bottom: 20px; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                </div></center>
                                            <%
                                                }else{
                                            %>

                                            <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                                <img style='width:50px; height: 50px; border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                            </div></center>

                                            <%}%>
                                        </div>
                                        <span style='color: #eeeeee;'><%=ProvFirstName%> - <%=ProvCompany%></span>
                                    </p>
                                    
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
            
            <div id='PhoneCalender' style='display: none; margin-top: 5px; width: 100%;'>
                <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Your Calender</p></center>
            
                <table  id="PhoneExtrasTab" style='padding: 4px; width: 90%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <div id="DateChooserDiv" style=''>
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Pick a date below</p>
                                    <% SimpleDateFormat CalDateFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");%>
                                    <p style='text-align: center;'><input id="CalDatePicker" style='cursor: pointer; width: 90%; 
                                                                          font-weight: bolder; border: 1px solid white; background-color: #eeeeee; padding: 5px;' type="text" name="CalDateVal" 
                                                                          value="<%= new Date().toString().substring(0,3) + ", " +CalDateFormat.format(new Date())%>" readonly onkeydown="return false"/></p>
                                    <script>
                                    $(function() {
                                        $("#CalDatePicker").datepicker();
                                      });
                                    </script>
                                </div>
                                    
                                <div style='border-bottom: 1px #7e7e7e solid; padding-bottom: 4px;'>
                                    <div onclick="showEventsTr();" id='EventsTrBtn' style='cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: #eeeeee; width: 49%; float: right;'>Events</div>
                                    <div onclick="showAppointmentsTr();" id='AppointmentsTrBtn' style='cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: #ccc; width: 49%; float: left;'>Appointments</div>
                                    <p style='clear: both;'></p>
                                </div>
                                    
                            </td>
                        </tr>
                        <tr id='AppointmentsTr' style='display: none; background-color: #eeeeee;'>
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Appointments</p>
                                
                                <input type="hidden" id="CalApptUserID" value="<%=UserID%>" />
                                
                                <div id='CalApptListDiv' style='height: 290px; overflow-y: auto;'>
                                    
                                    <%
                                        int count = 1;
                                        
                                        for(int aptNum = 0; aptNum < AppointmentListExtra.size(); aptNum++ ){
                                            
                                            
                                            
                                            int AptID = AppointmentListExtra.get(aptNum).getAppointmentID();
                                            String ProvName = AppointmentListExtra.get(aptNum).getProviderName();
                                            String ProvComp = AppointmentListExtra.get(aptNum).getProviderCompany();
                                            if(ProvComp.length() > 13)
                                                ProvComp = ProvComp.substring(0, 12) + "...";
                                            String AptTime = AppointmentListExtra.get(aptNum).getTimeOfAppointment();
                                            if(AptTime.length() > 5)
                                                AptTime = AptTime.substring(0,5);
                                    %>
                                    
                                    <p style="background-color: #ffc700; margin-bottom: 2px;"><%=count%>. <span style="color: white; font-weight: bolder;"><%=ProvName%></span> of <span style="color: darkblue; font-weight: bolder;"><%=ProvComp%></span> at <span style="color: darkblue; font-weight: bolder;"><%=AptTime%></span></p>
                                    
                                    <%
                                            count++;
                                        }
                                    %>
                                    
                                    <script>
                                        var updtCounter = 0;
                                        
                                        $(document).ready(function(){
                                            
                                            $("#CalDatePicker").change(function(event){
                                                
                                                document.getElementById('PageLoader').style.display = 'block';
                                                var date = document.getElementById("CalDatePicker").value;
                                                var CustomerID = document.getElementById("CalApptUserID").value;
                                                //alert(CustomerID);
                                                //alert(date);
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetApptForExtra",
                                                    data: "Date="+date+"&CustomerID="+CustomerID,
                                                    success: function(result){
                                                        
                                                        //alert(result);
                                                        
                                                        var ApptData = JSON.parse(result);
                                                        
                                                        var aDiv = document.createElement('div');
                                                        
                                                        for(i in ApptData.Data){
                                                            
                                                            var number = parseInt(i, 10) + 1;
                                                            
                                                            var name = ApptData.Data[i].ProvName;
                                                            var comp = ApptData.Data[i].ProvComp;
                                                            if(comp.length > 13)
                                                                comp = comp.substring(0,12) + "...";
                                                            
                                                            var time = ApptData.Data[i].ApptTime;
                                                            
                                                            aDiv.innerHTML += '<p style="background-color: #ffc700; margin-bottom: 2px;">'+number+'. <span style="color: white; font-weight: bolder;">'+name+'</span> of <span style="color: darkblue; font-weight: bolder;">'+comp+'</span> at <span style="color: darkblue; font-weight: bolder;">'+time+'<span></p>';
                                                            
                                                        }
                                                        
                                                        document.getElementById("CalApptListDiv").innerHTML = aDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetCustEvntAjax",
                                                    data: "Date="+date+"&CustomerID="+CustomerID,
                                                    success: function(result){
                                                        //alert(result);
                                                        document.getElementById('PageLoader').style.display = 'none';
                                                        var EvntsData = JSON.parse(result);
                                                        //alert(EvntsData);
                                                        var bDiv = document.createElement('div');
                                                        
                                                        for(i in EvntsData.Data){
                                                            
                                                            
                                                            var ID = EvntsData.Data[i].EvntID;
                                                            var Date = EvntsData.Data[i].EvntDate;
                                                            var Time = EvntsData.Data[i].EvntTime;
                                                            var Title = EvntsData.Data[i].EvntTtle;
                                                            var Desc = EvntsData.Data[i].EvntDesc;
                                                            
                                                            
                                                            updtCounter = parseInt(updtCounter, 10) + 1;
                                                            
                                                            bDiv.innerHTML += '<div id="Cupdt'+updtCounter+'" ' +
                                                                    'onclick=\'updateEvent("'+ID+'", "'+Title+'","'+Desc+'", "'+Date+'","' +Time+'", "Cupdt'+updtCounter+'");\' ' +
                                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +

                                                                    '<p><span style="font-weight: bolder; color: white;">'+Title+'</span> - <span style="color: darkblue; font-weight: bolder;">'+Date+'</span> - <span style="color: darkblue; font-weight: bolder;">'+Time+'</span></p>'+
                                                                    '<P style="color: #334d81;">'+Desc+'</p>'+
                                                                '</div>';
                                                            
                                                        }
                                                        
                                                        document.getElementById("EventsListDiv").innerHTML = bDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                            });
                                            
                                        });
                                    </script>
                                </div>
                            </td>
                        </tr>
                        <tr id='EventsTr' style="background-color: #eeeeee;">
                            <td>
                                
                                <p style='margin-bottom: 5px; color: #ff3333;'>Events</p>
                                
                                <div id='EventsListDiv' style='height: 290px; overflow-y: auto;'>
                                    
                                    <%
                                        try{
                                            
                                             SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                             String SDate = sdf.format(new Date());
                                            
                                            Class.forName(Driver);
                                            Connection EventsConn = DriverManager.getConnection(url, User, Password);
                                            String EventsQuery = "Select * from ProviderCustomers.CalenderEvents where CustID = ? and EventDate = ?";
                                            PreparedStatement EventsPst = EventsConn.prepareStatement(EventsQuery);
                                            EventsPst.setInt(1, UserID);
                                            EventsPst.setString(2, SDate);
                                            
                                            ResultSet EventsRec = EventsPst.executeQuery();
                                            
                                            int counter = 0;
                                            
                                            while(EventsRec.next()){
                                                counter++;
                                                String EventID = EventsRec.getString("EvntID").trim();
                                                String EventTitle = EventsRec.getString("EventTitle").trim();
                                                EventTitle = EventTitle.replace("\"", "");
                                                EventTitle = EventTitle.replace("'", "");
                                                EventTitle = EventTitle.replaceAll("\\s+", " ");
                                                EventTitle = EventTitle.replaceAll("( )+", " ");
                                                String EventDesc = EventsRec.getString("EventDesc").trim();
                                                EventDesc = EventDesc.replace("\"", "");
                                                EventDesc = EventDesc.replace("'", "");
                                                EventDesc = EventDesc.replaceAll("\\s+", " ");
                                                EventDesc = EventDesc.replaceAll("( )+", " ");
                                                String EventDate = EventsRec.getString("EventDate").trim();
                                                String EventTime = EventsRec.getString("EventTime").trim();
                                                if(EventTime.length() > 5)
                                                EventTime = EventTime.substring(0,5);
                                            
                                    %>
                                    
                                                <div id="PgLdupdt<%=counter%>"
                                                    onclick='updateEvent("<%=EventID%>", "<%=EventTitle%>", "<%=EventDesc%>", "<%=EventDate%>", "<%=EventTime%>", "PgLdupdt<%=counter%>");' 
                                                    style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">
                                                    
                                                    <p><span style="font-weight: bolder; color: white;"><%=EventTitle%></span> - <span style="color: darkblue; font-weight: bolder;"><%=EventDate%></span> - <span style="color: darkblue; font-weight: bolder;"><%=EventTime%></span></p>
                                                    <P style="color: #334d81;"><%=EventDesc%></p>
                                                </div>
                                    
                                    <%
                                            
                                            }
                                            
                                        }catch(Exception e){}
                                    %>
                                    
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Add/Change Event</p>
                                <div>
                                    <p>Time: <input id="DisplayedAddEvntTime" style='background-color: white;' type="text" name="" value="" readonly onkeydown="return false"/></p>
                                    <input id="AddEvntTime" style='background-color: white;' type="hidden" name="EvntTime" value="" />
                                    <p>Date: <input id='EvntDatePicker' style='background-color: white;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p>Title: <input id="AddEvntTtle" style='background-color: white;' type="text" name="EvntTitle" value="" /></p>
                                    <p><textarea  onfocusout="checkEmptyEvntDesc();" id="AddEvntDesc" name="EvntDesc" rows="7" style='width: 98%;'>
                                        </textarea></p>
                                </div>
                            </td>
                            
                    <script>
                        
                        document.getElementById("AddEvntDesc").value = "Add event description here...";
                        
                        function checkEmptyEvntDesc(){
                            if(document.getElementById("AddEvntDesc").value === "")
                                document.getElementById("AddEvntDesc").value = "Add event description here...";
                        }
                        
                        function SetTimetoHiddenEventInput(){
                            var EventTime = document.getElementById("DisplayedAddEvntTime").value;
                                    
                            if(EventTime.length < 8){
                                EventTime = "0" + EventTime;
                                //alert(EventTime);
                            }
                                    
                            if(EventTime.substring(6,8) === "PM"){
                                if(parseInt(EventTime.substring(0,2), 10) === 12){
                                    EventTime = EventTime.substring(0,5);
                                }else{
                                    EventTime = (parseInt(EventTime.substring(0,2),10) + 12) + ":" + EventTime.substring(3,5);
                                }
                            }else if(EventTime.substring(6,8) === "AM"){
                                if(parseInt(EventTime.substring(0,2), 10) === 12){
                                    EventTime = "00:" + EventTime.substring(3,5);
                                }else{
                                    EventTime = EventTime.substring(0,5);
                                }
                            }
                                    
                            document.getElementById("AddEvntTime").value = EventTime;
                            //alert(document.getElementById("AddEvntTime").value);
                        }
                                
                        $('#DisplayedAddEvntTime').timepicker({
                            timeFormat: 'hh:mm p',
                            interval: 10,
                            minTime: '00',
                            maxTime: '23:59',
                            defaultTime: '12',
                            startTime: '00',
                            dynamic: false,
                            dropdown: true,
                            scrollbar: true,
                            change: function(){
                                SetTimetoHiddenEventInput();
                            }
                                        
                        });

                        SetTimetoHiddenEventInput();
                                
                        setInterval(function(){
                            var CalSaveEvntBtn = document.getElementById("CalSaveEvntBtn");
                            var CalUpdateEvntBtn = document.getElementById("CalUpdateEvntBtn");
                            var CalDltEvntBtn = document.getElementById("CalDltEvntBtn");
                            
                            var AddEvntTtle = document.getElementById("AddEvntTtle");
                            var AddEvntDesc = document.getElementById("AddEvntDesc");
                            var EvntDatePicker = document.getElementById("EvntDatePicker");
                            var AddEvntTime = document.getElementById("AddEvntTime");
                            
                            if(AddEvntTtle.value === "" || AddEvntDesc.value === "Add event description here..." || EvntDatePicker.value === "" || AddEvntTime.value === ""){
                                if(CalSaveEvntBtn){
                                    CalSaveEvntBtn.style.backgroundColor = "darkgrey";
                                    CalSaveEvntBtn.disabled = true;
                                }
                                if(CalUpdateEvntBtn){
                                    CalUpdateEvntBtn.style.backgroundColor = "darkgrey";
                                    CalUpdateEvntBtn.disabled = true;
                                }
                                if(CalDltEvntBtn){
                                    CalDltEvntBtn.style.backgroundColor = "darkgrey";
                                    CalDltEvntBtn.disabled = true;
                                }
                            }else{
                                if(CalSaveEvntBtn){
                                    CalSaveEvntBtn.style.backgroundColor = "pink";
                                    CalSaveEvntBtn.disabled = false;
                                }
                                if(CalUpdateEvntBtn){
                                    CalUpdateEvntBtn.style.backgroundColor = "pink";
                                    CalUpdateEvntBtn.disabled = false;
                                }
                                if(CalDltEvntBtn){
                                    CalDltEvntBtn.style.backgroundColor = "pink";
                                    CalDltEvntBtn.disabled = false;
                                }
                            }
                            
                            
                        }, 1);
                        
                    </script>
                            
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <input type="hidden" id="EvntIDFld" value=""/>
                                <center><input id="CalSaveEvntBtn" style='border: 1px solid black; background-color: pink; width: 95%;' type='button' value='Save' /></center>
                                <center><input onclick="" id="CalDltEvntBtn" style='float: right; display: none; border: 1px solid black; background-color: pink; width: 46%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate();" id="CalUpdateEvntBtn" style='float: left; display: none; border: 1px solid black; background-color: pink; width: 46%;' type='button' value='Change' /></center>
                            </td>
                        </tr>
                        
                        <script>
                            $(document).ready(function(){
                                
                                $("#CalDltEvntBtn").click(function(event){
                                    
                                    document.getElementById('PageLoader').style.display = 'block';
                                    
                                    document.getElementById('PageLoader').style.display = 'block';
                                    var EventID = document.getElementById("EvntIDFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            document.getElementById('PageLoader').style.display = 'none';
                                            if(result === "success")
                                                alert("Event Deleted Successfully");
                                                document.getElementById("CalUpdateEvntBtn").style.display = "none";
                                                document.getElementById("CalDltEvntBtn").style.display = "none";
                                                document.getElementById("CalSaveEvntBtn").style.display = "block";
                                                document.getElementById("AddEvntTtle").value = "";
                                                document.getElementById("AddEvntDesc").value = "";
                                                document.getElementById("EvntDatePicker").value = "";
                                                document.getElementById("AddEvntTime").value = "";
                                                document.getElementById("DisplayedAddEvntTime").value = "";
                                                document.getElementById("EvntIDFld").value = "";
                                        }
                                        
                                    });
                                });
                            });
                        </script>
                        
                        <script>
                            var updateCounter = 0;
                            
                            function updateEvent(pEvntID, pEvntTtle, pEvntDesc, pEvntDate, pEvntTime, element){
                                
                                document.getElementById(element).style.display = "none";
                                document.getElementById("CalSaveEvntBtn").style.display = "none";
                                document.getElementById("CalUpdateEvntBtn").style.display = "block";
                                document.getElementById("CalDltEvntBtn").style.display = "block";
                                
                                document.getElementById("AddEvntTtle").value = pEvntTtle.toString();
                                document.getElementById("AddEvntDesc").value = pEvntDesc.toString();
                                document.getElementById("EvntDatePicker").value = pEvntDate.toString();
                                document.getElementById("AddEvntTime").value = pEvntTime.toString();
                                document.getElementById("EvntIDFld").value = pEvntID.toString();
                            }  
                            
                            function SendEvntUpdate(){
                                document.getElementById('PageLoader').style.display = 'block';
                                var EvntTtle = document.getElementById("AddEvntTtle").value;
                                EvntTtle = EvntTtle.replace("\"","");
                                var EvntDesc = document.getElementById("AddEvntDesc").value;
                                EvntDesc = EvntDesc.replace("\"","");
                                var EvntDate = document.getElementById("EvntDatePicker").value;
                                var EvntTime = document.getElementById("AddEvntTime").value;
                                var EvntId = document.getElementById("EvntIDFld").value;
                                
                                var CalDate = document.getElementById("CalDatePicker").value;
                                    
                                    //alert(CalDate);
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "UpdateEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&EventID="+EvntId,
                                        success: function(result){
                                            
                                            alert("Event Updated Successfully");
                                            document.getElementById('PageLoader').style.display = 'none';
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            //alert(Evnt.EvntID);
                                            //alert(Evnt.JQDate);
                                            
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter = parseInt(updateCounter, 10) + 1;
                                                document.getElementById("EventsListDiv").innerHTML += '<div id="updt'+updateCounter+'" ' +
                                                    'onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' +
                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +
                                                    
                                                    '<p><span style="font-weight: bolder; color: white;">'+EvntTtle+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntDate+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntTime+'</span></p>'+
                                                    '<P style="color: #334d81;">'+EvntDesc+'</p>'+
                                                '</div>';
                                        
                                            }
                                        }
                                    });
                                    
                                    document.getElementById("CalUpdateEvntBtn").style.display = "none";
                                    document.getElementById("CalDltEvntBtn").style.display = "none";
                                    document.getElementById("CalSaveEvntBtn").style.display = "block";
                                    document.getElementById("AddEvntTtle").value = "";
                                    document.getElementById("AddEvntDesc").value = "";
                                    document.getElementById("EvntDatePicker").value = "";
                                    document.getElementById("AddEvntTime").value = "";
                                    document.getElementById("DisplayedAddEvntTime").value = "";
                                    document.getElementById("EvntIDFld").value = "";
                                
                            }
                        </script>
                        
                        <script>
                            
                            $(document).ready(function(){
                                
                                $("#CalSaveEvntBtn").click(function(event){
                                    
                                    document.getElementById('PageLoader').style.display = 'block';
                                    
                                    var EvntTtle = document.getElementById("AddEvntTtle").value;
                                    EvntTtle = EvntTtle.replace("\"","");
                                    var EvntDesc = document.getElementById("AddEvntDesc").value;
                                    EvntDesc = EvntDesc.replace("\"","");
                                    var EvntDate = document.getElementById("EvntDatePicker").value;
                                    var EvntTime = document.getElementById("AddEvntTime").value;
                                    //alert(EvntTime);
                                    
                                    var CalDate = document.getElementById("CalDatePicker").value;
                                    //alert(CalDate);
                                    
                                    var CustID = document.getElementById("CalApptUserID").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "AddEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&CustomerID="+CustID,
                                        success: function(result){
                                            
                                            alert("Event Added Successfully");
                                            document.getElementById('PageLoader').style.display = 'none';
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            //alert(Evnt.EvntID);
                                            //alert(Evnt.JQDate);
                                            
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter = parseInt(updateCounter, 10) + 1;
                                                document.getElementById("EventsListDiv").innerHTML += '<div id="updt'+updateCounter+'" ' +
                                                    'onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' +
                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +
                                                    
                                                    '<p><span style="font-weight: bolder; color: white;">'+EvntTtle+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntDate+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntTime+'</span></p>'+
                                                    '<P style="color: #334d81;">'+EvntDesc+'</p>'+
                                                '</div>';
                                        //alert('onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle+'","'+EvntDesc+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' );
                                        
                                            }
                                        }
                                    });
                                    
                                    document.getElementById("AddEvntTtle").value = "";
                                    document.getElementById("AddEvntDesc").value = "";
                                    document.getElementById("EvntDatePicker").value = "";
                                    document.getElementById("AddEvntTime").value = "";
                                    document.getElementById("DisplayedAddEvntTime").value = "";
                                    document.getElementById("EvntIDFld").value = "";
                                    
                                });
                            });
                        </script>
                    </tbody>
                </table>
            </div>
                             
        <div id='PhoneExtrasUserAccountDiv' style='width: 100%; display: none;'>
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Your Account</p></center>
            
                <table  id="PhoneExtrasTab" style='padding: 4px; width: 90%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p id='UpdateStatusMsg' style='color: white; background-color: green; text-align: center;'></p>
                                <input type='hidden' id='ExtraUpdPerUserID' value='<%=UserID%>' />
                                <p style='margin-bottom: 5px; color: #ff3333;'>Edit Your Personal Info</p>
                                <p>First Name: <input id='fNameExtraFld' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtfName" value="<%=FirstName%>" /></p>
                                <p>Middle Name: <input id='mNameExtraFld' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtmName" value="<%=MiddleName%>" /></p>
                                <p>Last Name: <input id='lNameExtraFld' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtlName" value="<%=LastName%>" /></p>
                                <p>Email: <input id='EmailExtraFld' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtEmail" value="<%=Email%>" /></p>
                                <p>Phone: <input id='PhoneExtraFld' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="EvntTime" value="<%=PhoneNumber%>" /></p>
                                <center><input id='UpdtPerInfExtraBtn' style='background-color: pink; border: 1px solid black; width: 95%;' type="submit" value="Change" /></center>
                            </td>
                            
                            <script>
                                
                                setInterval(function(){
                                    
                                    var fNameExtraFld = document.getElementById("fNameExtraFld");
                                    var mNameExtraFld = document.getElementById("mNameExtraFld");
                                    var lNameExtraFld = document.getElementById("lNameExtraFld");
                                    var EmailExtraFld = document.getElementById("EmailExtraFld");
                                    var PhoneExtraFld = document.getElementById("PhoneExtraFld");
                                    var UpdtPerInfExtraBtn = document.getElementById("UpdtPerInfExtraBtn");
                                    
                                    if(fNameExtraFld.value === "" || mNameExtraFld.value === "" || lNameExtraFld.value === "" || 
                                        EmailExtraFld.value === "" || PhoneExtraFld.value === "" ){
                                    
                                        UpdtPerInfExtraBtn.style.backgroundColor = "darkgrey";   
                                        UpdtPerInfExtraBtn.disabled = true;
                                    }else{
                                        UpdtPerInfExtraBtn.style.backgroundColor = "pink";
                                        UpdtPerInfExtraBtn.disabled = false;
                                    }
                                    
                                }, 1);
                                
                            </script>
                            
                            <script>
                                $(document).ready(function(){
                                    $("#UpdtPerInfExtraBtn").click(function(){
                                        
                                        document.getElementById('PageLoader').style.display = 'block';
                                        
                                        var FirstName = document.getElementById("fNameExtraFld").value;
                                        var MiddleName = document.getElementById("mNameExtraFld").value;
                                        var LastName = document.getElementById("lNameExtraFld").value;
                                        var Email = document.getElementById("EmailExtraFld").value;
                                        var Phone = document.getElementById("PhoneExtraFld").value;
                                        var CustomerID = document.getElementById("ExtraUpdPerUserID").value;
                                        
                                        $.ajax({
                                            type: "POST",
                                            url: "updtPerInfoExtraAjax",
                                            data: "FirstName="+FirstName+"&MiddleName="+MiddleName+"&LastName="+LastName+"&Email="+Email+"&Phone="+Phone+"&CustomerID="+CustomerID,
                                            success: function(result){
                                                
                                                document.getElementById('PageLoader').style.display = 'none';
                                                
                                                if(result === "success"){
                                                    //alert(result);
                                                    
                                                    document.getElementById("UpdateStatusMsg").innerHTML = "Personal information updated"
                                                    //var FullName = FirstName + " " + MiddleName + " " + LastName;
                                                    
                                                                            
                                                }
                                                
                                            }
                                        });
                                        
                                    });
                                });
                                
                            </script>
                            
                        </tr>
                        <tr>
                            <td>
                                <div id="ExtrasFeedbackDiv">
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Send Feedback</p>
                                    <form id="ExtrasFeedBackForm" style="width: 95%;" >
                                            <center><div id='ExtLastReviewMessageDiv' style='display: none; background-color: white; width: 100%;'>
                                                <p id='ExtLasReviewMessageP' style='text-align: left; padding: 5px; color: darkgray; font-size: 13px;'></p>
                                                <p id="ExtFeedBackDate" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td><textarea id="ExtFeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" style='width: 270px;'>Compose Feedback Message Here...
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='ExtFeedBackUserID' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="ExtSendFeedBackBtn" style="width: 100%; border: 1px solid black; background-color: pink;" type="button" value="Send" /></center>
                                                <script>
                                                    $(document).ready(function() {                        
                                                         $('#ExtSendFeedBackBtn').click(function(event) {
                                                             
                                                             document.getElementById('PageLoader').style.display = 'block';

                                                             var feedback = document.getElementById("ExtFeedBackTxtFld").value;
                                                             var CustomerID = document.getElementById("ExtFeedBackUserID").value;

                                                             $.ajax({  
                                                             type: "POST",  
                                                             url: "SendProvCustFeedBackController",  
                                                             data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                             success: function(result){ 
                                                               alert(result);
                                                               document.getElementById('PageLoader').style.display = 'none';
                                                               
                                                               document.getElementById("ExtFeedBackTxtFld").innerHTML = "Add your message here...";
                                                               document.getElementById("ExtLastReviewMessageDiv").style.display = "block";
                                                               document.getElementById("ExtLasReviewMessageP").innerHTML = "You've Sent: "+ "<p style='color: green; font-size: 15px;'>" +feedback+ "</p>";

                                                               $.ajax({  
                                                             type: "POST",  
                                                             url: "getCustFeedbackDate",  
                                                             data: "CustomerID="+CustomerID,  
                                                             success: function(result){  
                                                                 //alert(result);
                                                                 document.getElementById("ExtFeedBackDate").innerHTML = result +" ";
                                                             }                
                                                           });
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                </div>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Update Your Login</p>
                                <P>User Name: <input id="ExtraUpdateLoginNameFld" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; text-align: center;' type='text' name='ExtUserName' value='<%=thisUserName%>'/></p>
                                <P><input id="ExtraCurrentPasswordFld" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter Current Password' type='password' name='ExtOldPass' value=''/></p>
                                <P><input id="ExtraNewPasswordFld" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter New Password' type='password' name='ExtNewPass' value=''/></p>
                                <P><input id="ExtraConfirmPasswordFld" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Confirm New Password' type='password' name='ExtConfirmPass' value=''/></p>
                                <center><input id="ExtraLoginFormBtn" style='background-color: pink; border: 1px solid black; width: 95%;' type="submit" value="Change" /></center>
                                <p id="ExtraWrongPassStatus" style="display: none; background-color: red; color: white; text-align: center;">You have entered wrong current password</p>
                                <p id='ExtrachangeUserAccountStatus' style='text-align: center; color: white;'></p>
                            </td>
                            <input type='hidden' id='ExtraThisPass' value='' />
                            <input type="hidden" id="ExtraUserIDforLoginUpdate" value="<%=UserID%>" />
                            <input type="hidden" id="ExtraUserIndexforLoginUpdate" value="<%=UserIndex%>" />
                            
                            <script>
                                    function checkExtraLogInFormFieldsStatus() {
                                    var changeUserAccountStatus = document.getElementById("ExtrachangeUserAccountStatus");
                                    var LoginFormBtn = document.getElementById("ExtraLoginFormBtn");
                                    var NewPasswordFld = document.getElementById("ExtraNewPasswordFld");
                                    var CurrentPasswordFld = document.getElementById("ExtraCurrentPasswordFld");
                                    var ConfirmPasswordFld = document.getElementById("ExtraConfirmPasswordFld");
                                    var UpdateLoginNameFld = document.getElementById("ExtraUpdateLoginNameFld");
                                    var ThisPass = document.getElementById("ExtraThisPass");

                                    LoginFormBtn.disabled = true;
                                    LoginFormBtn.style.backgroundColor = "darkgrey";

                                    if (
                                      NewPasswordFld.value === "" ||
                                      CurrentPasswordFld.value === "" ||
                                      ConfirmPasswordFld.value === "" ||
                                      UpdateLoginNameFld.value === ""
                                    ) {
                                      changeUserAccountStatus.innerHTML = "Uncompleted Form";
                                      changeUserAccountStatus.style.backgroundColor = "green";
                                      LoginFormBtn.disabled = true;
                                      LoginFormBtn.style.backgroundColor = "darkgrey";
                                    } else if (
                                      /*else if (ThisPass.value === "WrongPass"){

                                                          changeUserAccountStatus.innerHTML = "Enter your old password correctly";
                                                          changeUserAccountStatus.style.backgroundColor = "red";
                                                          //LoginFormBtn.disabled = true;
                                                          //LoginFormBtn.style.backgroundColor = "darkgrey";

                                                  }*/
                                      NewPasswordFld.value !== ConfirmPasswordFld.value ||
                                      (NewPasswordFld.value === "" && ConfirmPasswordFld.value === "")
                                    ) {
                                      changeUserAccountStatus.innerHTML = "New Passwords don't match";
                                      changeUserAccountStatus.style.backgroundColor = "red";
                                      LoginFormBtn.disabled = true;
                                      LoginFormBtn.style.backgroundColor = "darkgrey";
                                    } else if (NewPasswordFld.value.length < 8) {
                                      changeUserAccountStatus.innerHTML = "New password too short";
                                      changeUserAccountStatus.style.backgroundColor = "red";
                                      LoginFormBtn.disabled = true;
                                      LoginFormBtn.style.backgroundColor = "darkgrey";
                                    } else {
                                      changeUserAccountStatus.innerHTML = "OK";
                                      changeUserAccountStatus.style.backgroundColor = "green";
                                      LoginFormBtn.disabled = false;
                                      LoginFormBtn.style.backgroundColor = "pink";
                                    }
                                  }
                                  if (document.getElementById("ExtraLoginFormBtn")) {
                                    setInterval(checkExtraLogInFormFieldsStatus, 1);
                                  }
                            </script>
                            
                            <script>
                                $(document).ready(function(){
                                    $("#ExtraLoginFormBtn").click(function(event){
                                        
                                        document.getElementById('PageLoader').style.display = 'block';
                                        var CustomerID = document.getElementById("ExtraUserIDforLoginUpdate").value;
                                        var UserIndex = document.getElementById("ExtraUserIndexforLoginUpdate").value;
                                        var UserName = document.getElementById("ExtraUpdateLoginNameFld").value;
                                        var NewPassword = document.getElementById("ExtraNewPasswordFld").value;
                                        var oldPassword = document.getElementById("ExtraCurrentPasswordFld").value;
                                                                
                                        $.ajax({
                                            method: "POST",
                                            url: "updateLoginController",
                                            data: "CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&userName="+UserName+"&newPassword="+NewPassword+"&currentPassword="+oldPassword,
                                            success: function(result){
                                                                        
                                                //alert(result);
                                                document.getElementById('PageLoader').style.display = 'none';
                                                
                                                if(result === "fail"){
                                                                            
                                                    document.getElementById("ExtraWrongPassStatus").style.display = "block";
                                                    document.getElementById("ExtraCurrentPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.backgroundColor = "red";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.color = "white";

                                                    //document.getElementById("changeUserAccountStatus").innerHTML = "Enter your old password correctly";
                                                    //document.getElementById("changeUserAccountStatus").style.backgroundColor = "red";
                                                    //document.getElementById("LoginFormBtn").disabled = true;
                                                    //document.getElementById("LoginFormBtn").style.backgroundColor = "darkgrey";
                                                }
                                                if(result === "success"){
                                                    alert("Update Successful");
                                                    document.getElementById("ExtraNewPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.backgroundColor = "#eeeeee";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.color = "cadetblue";
                                                    document.getElementById("ExtraConfirmPasswordFld").value = "";
                                                    document.getElementById("ExtraWrongPassStatus").style.display = "none";
                                                    document.getElementById("UpdateStatusMsg").innerHTML = "Login information updated"
                                                                            
                                                    //getUserAccountNameController
                                                    $.ajax({
                                                        method: "POST",
                                                        url: "getUserAccountNameController",
                                                        data: "CustomerID="+CustomerID,
                                                                                
                                                        success: function(result){

                                                            document.getElementById("ExtraUpdateLoginNameFld").value = result;

                                                        }

                                                    });
                                                }
                                            }
                                                                    
                                        });
                                                                
                                    });
                                });
                            </script>
                                                    
                        </tr>
                        <tr>
                            <td>
                                <form style="margin-top: 10px;" action="LogoutController" name="LogoutForm" method="POST"> 
                                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                    <center><input style='width: 100%; background-color: red; color: white; border: 0; padding: 4px; border-radius: 0; margin-left: 0;' type="submit" value="Logout" class="button" /></center>
                                </form>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
                                
            <div id='PhoneExtrasNotificationDiv' style='width: 100%; display: none;'>
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Notifications</p></center>
            
                <table  id="PhoneExtrasTab" style='padding: 4px; width: 90%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        
                    <%
                        
                        boolean isTrWhite = false;
                        
                        for(int notify = 0 ; notify < Notifications.size(); notify++){
                    
                        if(!isTrWhite){
                            
                    %>
                    
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p style='text-align: left; border: 1px solid #d8d8d8; padding: 3px; font-family: helvetica; color: darkblue;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%
                                isTrWhite = true;
                                
                            }else{
                            
                                
                    %>
                    
                        <tr>
                            <td>
                                <p style='text-align: left; border: 1px solid #d8d8d8; padding: 3px; font-family: helvetica; color: darkblue;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%      
                                isTrWhite = false;
                            }
                        }
                    %>
                        <!--tr style="background-color: #eeeeee;">
                            <td>
                                <p style='text-align: justify; border: 1px solid #d8d8d8; padding: 3px;'>third notification here</p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style='text-align: justify; border: 1px solid #d8d8d8; padding: 3px;'>fourth notification here</p>
                            </td>
                        </tr>
                    
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <p><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Previous'><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Next' /></p>
                            </td>
                        </tr-->
                        
                    </tbody>
                </table>
            </div>
        </div></center>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    
    <script>
            var Settings = '<%=Settings%>';
            
            if(Settings === '1')
                showPCustExtraNotification();
            else if(Settings === '2')
                showPCustExtraCal();
            else if(Settings === '3')
                showPCustExtraUsrAcnt();
    </script>
    
</html>
