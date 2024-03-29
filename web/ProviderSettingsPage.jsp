<%-- 
    Document   : BlockFutureSpots
    Created on : Jun 3, 2019, 10:13:16 AM
    Author     : aries
--%>

<%@page import="java.io.InputStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.util.Base64"%>
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
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <title>Queue | Settings</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        
        <!--script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
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
        
        int UserID = 0;
        int UserIndex = -1;
        String NameFromList = "";
        String NewUserName = "";
        String Settings = "";
        
        try{
            Settings = request.getParameter("Settings");
        }catch(Exception e){
            
        }
        
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

            if(tempAccountType.equals("BusinessAccount")){
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
                NameFromList = UserAccount.LoggedInUsers.get(UserIndex).getName();
            }
                
            //incase of array flush
            if(!NewUserName.equals(NameFromList)){
                response.sendRedirect("LogInPage.jsp");
            }
            
            /*if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }*/

            if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");
            
        }catch(Exception e){
            response.sendRedirect("LogInPage.jsp");
        }
        
        
        int notiCounter = 0;
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
            System.out.println(e.getMessage());
        }
        
        String FirstName = "";
        String MiddleName = "";
        String LastName = "";
        String Email = "";
        String PhoneNumber = "";
        String thisUserName = "";
        String UserName = "";
        
        //------------------------------------------------------------------------------------------------------------------------------------------    
        //Getting Notifications data
        ArrayList<String> Notifications = new ArrayList<>();
        String NotiIDs = "{\"Data\" : [ ";
        
        try{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Class.forName(Driver);
            Connection NotiConn = DriverManager.getConnection(url, User, Password);
            String NotiQuery = "Select Noti_Type, What, Noti_Status, ID from QueueServiceProviders.Notifications where (ProvID = ? and Noti_Type not like 'Today%')"
                    + "or (ProvID = ? and Noti_Date = ? and Noti_Type like 'Today%') order by ID desc";
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
    
        
        String AppointmentDateValue = "";
        
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, User, Password);
            String Query = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setInt(1,UserID);
            ResultSet userData = pst.executeQuery();
            
            while(userData.next()){
                
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
            String Select = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ?";
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
                
                int CustomerID = Appointments.getInt("CustomerID");
                AppointmentDateValue = Appointments.getString("AppointmentDate");
                
                String CustomerName = "";
                String CustomerEmail = "";
                String CustomerTel = "";
                Blob CustDisplayPic = null;
                
                try{
                    
                    Class.forName(Driver);
                    Connection providerConn = DriverManager.getConnection(url, User, Password);
                    String providerQuery = "Select *  from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement providerPst = providerConn.prepareStatement(providerQuery);
                    providerPst.setInt(1, CustomerID);
                    
                    ResultSet providerRecord = providerPst.executeQuery();
                    
                    while(providerRecord.next()){
                        
                        CustomerName = providerRecord.getString("First_Name");
                        CustomerTel = providerRecord.getString("Phone_Number");
                        CustomerEmail = providerRecord.getString("Email");
                        CustDisplayPic = providerRecord.getBlob("Profile_Pic");
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                int AppointmentID = Appointments.getInt("AppointmentID");
                Date AppointmentDate = Appointments.getDate("AppointmentDate");
                String AppointmentTime = Appointments.getString("AppointmentTime");
                
                eachAppointmentItem = new BookedAppointmentList(AppointmentID, CustomerID, CustomerName, null, CustomerTel, CustomerEmail, AppointmentDate, AppointmentTime, CustDisplayPic);
                eachAppointmentItem.setAppointmentReason(Reason);
                AppointmentListExtra.add(eachAppointmentItem);
                
            }
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection UsrAccntConn = DriverManager.getConnection(url, User, Password);
            String UsrAccntString = "select * from QueueServiceProviders.UserAccount where Provider_ID = ?";
            PreparedStatement UsrAccntPst = UsrAccntConn.prepareStatement(UsrAccntString);
            UsrAccntPst.setInt(1, UserID);
            ResultSet UsrAccntRec = UsrAccntPst.executeQuery();
            
            while(UsrAccntRec.next()){
                UserName = UsrAccntRec.getString("UserName").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        String LastNewsID = "view-wallpaper-7.jpg";
        String lastNewsMsg = "Use Queue upates to advertise your products and services and also to keep customer's informed";
        String NewsPicSrc = "";
        
        try{
            Class.forName(Driver);
            Connection lastNewsConn = DriverManager.getConnection(url, User, Password);
            String lastNewsString = "Select * from QueueServiceProviders.MessageUpdates where ProvID = ? order by MsgID desc";
            PreparedStatement lastNewsPst = lastNewsConn.prepareStatement(lastNewsString);
            lastNewsPst.setInt(1, UserID);
            
            ResultSet lastNewsRec = lastNewsPst.executeQuery();
            while(lastNewsRec.next()){
                LastNewsID = lastNewsRec.getString("MsgID").trim();
                lastNewsMsg = lastNewsRec.getString("Msg").trim();
                
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob lastNPic = lastNewsRec.getBlob("MsgPhoto"); 
                    InputStream inputStream = lastNPic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                    String Pic = Base64.getEncoder().encodeToString(imageBytes);
                    
                    NewsPicSrc = "data:image/jpg;base64,"+Pic;

                }catch(Exception e){}
                
                break;
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(NewsPicSrc.equals("")){
            NewsPicSrc = "view-wallpaper-7.jpg";
        }
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background: none !important; background-color: #e1e1e1 !important; padding-bottom: 0;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id='QShowNews22' style='display: block; width: fit-content; bottom: 5px; margin-left: 4px; position: fixed; background-color: #3d6999; padding: 5px 9px; border-radius: 50px;
                 box-shadow: 0 0 5px 1px black;'>
            <center><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ServiceProviderPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>"><p  
                    style='color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0; width:'>
                        <img style='background-color: white; width: 25px; height: 24px; border-radius: 4px;' src="icons/icons8-home-50.png" alt="icons8-home-50"/>
                </p>
                <p style='font-size: 15px; color: white; margin-top: -5px;'>Home</p>
            </a></center>
        </div>
        
    <center><div id='PhoneSettingsPgNav' style='z-index: 1000; margin-bottom: 5px; background-color: white; padding: 5px; border-bottom: #ccc 1px solid; position: fixed; width: 100%; max-height: 33px; border-bottom: 1.3px solid #ccc'>
            <ul> 
                <textarea style="display: none;" id="NotiIDInput" rows="4" cols="20"><%=NotiIDs%>
                    </textarea>    
            
            <li onclick="showPCustExtraNews();" id='' style="width: 50px;"><div onclick="IndicateNews();">
                <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="35" height="28" alt="icons8-google-news-50"/>
                <p id="NewsIndicator" style="margin-top: 5px; background-color: darkgray; height: 2px;"></p>
                </div>
            </li>
            <li onclick="showPCustExtraNotification();" id='PhPermDivNotiBtn' style="width: 50px;"><div onclick="IndicateNoti();">
                    <img src="icons/icons8-notification-50.png" width="36" height="29" alt="icons8-notification-50"/>
                    <span id='notiCounterSup' style='color: white; background-color: red; padding: 2px 5px; margin-left: -16px; border-radius: 100%; font-size: 11px;'><%=notiCounter%></span></p></div>
                    <p id="NotiIndicator" style="margin-top: 5px; background-color: darkgrey; height: 2px;"></p>
            </li>
            <li onclick='showPCustExtraCal();' id='' style="width: 50px;"><div onclick="IndicateCal();">
                <img style='background-color: white;' src="icons/icons8-calendar-50.png" width="28" height="25" alt="icons8-calendar-50"/>
                <p id="CalIndicator" style="margin-top: 5px; background-color: darkgrey; height: 2px;"></p>
                </div>
            </li>
            <li onclick='showPCustExtraUsrAcnt();' id='' style="width: 50px;"><div onclick="IndicateSettings();">
                <img style='background-color: white;' src="icons/icons8-settings-50.png" width="30" height="28" alt="icons8-settings-50"/>
                <p id="SettingIndicator" style="margin-top: 5px; background-color: darkgrey; height: 2px;"></p>
                </div>
            </li>
            <script>
                function IndicateSettings(){
                    document.getElementById("NewsIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("NotiIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("CalIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("SettingIndicator").style.backgroundColor = "#334d81";
                }
                
                function IndicateNoti(){
                    document.getElementById("NewsIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("NotiIndicator").style.backgroundColor = "#334d81";
                    document.getElementById("CalIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("SettingIndicator").style.backgroundColor = "darkgrey";
                }
                
                function IndicateNews(){
                    document.getElementById("NewsIndicator").style.backgroundColor = "#334d81";
                    document.getElementById("NotiIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("CalIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("SettingIndicator").style.backgroundColor = "darkgrey";
                }
                
                function IndicateCal(){
                    document.getElementById("NewsIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("NotiIndicator").style.backgroundColor = "darkgrey";
                    document.getElementById("CalIndicator").style.backgroundColor = "#334d81";
                    document.getElementById("SettingIndicator").style.backgroundColor = "darkgrey";
                }
            </script>
        </ul>
        
        <!--ul>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href='ServiceProviderPage.jsp?User=<=NewUserName%>&UserIndex=<=UserIndex%>'><li  style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="28" height="25" alt="icons8-home-50"/>
                
                </li></a>
            <li onclick="showPCustExtraNews();" id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'>
                <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                
            </li>
            <li onclick="showPCustExtraNotification();" id='PermDivNotiBtn' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><p><img style='background-color: white; margin-right: 0;' src="icons/icons8-notification-50.png" width="28" height="25" alt="icons8-notification-50"/>
                 <span id='notiCounterSup' style='color: red; background-color: white; margin-left: 0; padding-left: 2px; padding-right: 2px;'><%=notiCounter%></span></p>
            </li>
            <li onclick='showPCustExtraCal();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="28" height="25" alt="icons8-calendar-50"/>
                
            </li>
            <li onclick='showPCustExtraUsrAcnt();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="28" height="25" alt="icons8-user-50 (1)"/>
                
            </li>
        </ul-->
        
        <script>
                    $(document).ready(function(){
                        $("#PhPermDivNotiBtn").click(function(event){
                            document.getElementById('PageLoader').style.display = 'block';
                            var NotiIDs = document.getElementById("NotiIDInput").value;
                            var NotiJSON = JSON.parse(NotiIDs);
                            
                            for(i in NotiJSON.Data){
                                //alert(NotiJSON.Data[i].ID);
                                var ID = NotiJSON.Data[i].ID;
                                $.ajax({
                                    type: "POST",
                                    url: "SetProvNotificationAsSeen",
                                    data: "ID="+ID,
                                    success: function(result){
                                        document.getElementById("notiCounterSup").innerHTML = " 0 ";
                                        document.getElementById('PageLoader').style.display = 'none';
                                    }
                                });
                            }
                            
                        });
                    });
                </script>
            
        </div></center>
        <p style="padding-top: 60px;"></p>
    <center><div id="PhoneExtras" style="padding-bottom: 50px;">
            
            <div id='PhoneNews' style='width: 100%;' >
             
            <form method="POST" enctype="multipart/form-data">
                
            <p style="color: darkblue; font-weight: bolder; margin-bottom: 10px; font-size: 16px;">Update your clients on whats new</p>
                
                <table id="PhoneExtrasTab" style='padding: 4px; width: 100%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p style='color: red; font-weight: bolder; margin-bottom: 5px;'>Add News Updates</p>
                                <textarea onfocusout="checkEmptyNewTxt();" id="NewsMessageFld" name="TellCustomersMsgBx" style="width: 100%; border: 0; background-color: #bce9fc;" rows="5">
                                </textarea>
                                
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p style='margin-bottom: 4px;'>Add photo to this message</p>
                                <div id="MsgPhotoDisplay"></div>
                                
                                <input style="background-color: white; border: 0; width: 95%;" id="NewsPhotoFld" style="width: 95%;" type="file" name="MsgformPhoto" />
                                
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                
                                <p>Make news visible to: </p>
                                    <input id="VPublicRd" type="radio" name="NewsVisibility" value="Public" checked="checked" /><label for="VPublicRd">Public</label>
                                    <input id="VCustomersRd" type="radio" name="NewsVisibility" value="Customer" /><label  for="VCustomersRd">Only customers</label>
                                
                                <center><input id="SaveNewsBtn" style="border-radius: 4px; border: 0; color: white; background-color: darkslateblue; padding: 5px; width: 95%;" type="button" value="Save" /></center>
                            </td>
                            
                            <script>
                        
                                document.getElementById("NewsMessageFld").value = "What should your clients know about?";
                                
                                function checkEmptyNewTxt(){
                                    if(document.getElementById("NewsMessageFld").value === "")
                                        document.getElementById("NewsMessageFld").value = "What should your clients know about?";
                                }
                                
                                setInterval(function(){
                                    
                                    var SaveNewsBtn = document.getElementById("SaveNewsBtn");

                                    var NewsMessageFld = document.getElementById("NewsMessageFld");
                                    var VPublicRd = document.getElementById("VPublicRd");
                                    var VCustomersRd = document.getElementById("VCustomersRd");

                                    if((NewsMessageFld.value === "What should your clients know about?") || 
                                            (VPublicRd.checked ===  false && VCustomersRd.checked === false) || (document.getElementById("NewsPhotoFld").value === "")){
                                        if(SaveNewsBtn){
                                            SaveNewsBtn.style.backgroundColor = "darkgrey";
                                            SaveNewsBtn.disabled = true;
                                        }
                                    }else{
                                        if(SaveNewsBtn){
                                            SaveNewsBtn.style.backgroundColor = "darkslateblue";
                                            SaveNewsBtn.disabled = false;
                                        }
                                    }


                                }, 1);

                        </script>
                            
                        </tr>
                        <%
                            Date UpdDate = new Date();
                            String UpdSDate = UpdDate.toString();
                            SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
                            String UpdMDate = NotiDformat.format(UpdDate);
                            String UpdTime = UpdSDate.substring(11,16);
                        %>
                        <script>
                            $(document).ready(function(){
                                $("#SaveNewsBtn").click(function(event){
                                    document.getElementById('PageLoader').style.display = 'block';
                                    var ProviderID = "<%=UserID%>";
                                    var UpdDate = "<%=UpdMDate%>";
                                    var UpdTime = "<%=UpdTime%>";
                                    
                                    var Message = document.getElementById("NewsMessageFld").value;
                                    
                                    var Visibility = "";
                                    if(document.getElementById("VCustomersRd").checked === true){
                                        Visibility = "Customer";
                                    }else if(document.getElementById("VPublicRd").checked === true){
                                        Visibility = "Public";
                                    }else{
                                        Visibility = "Public";
                                    }
                                    
                                    var fileInput = document.getElementById("NewsPhotoFld");
                                    
                                    var file = fileInput.files[0];
                                    
                                    var formData = new FormData();
                                    formData.append('Photo', file);
                                    formData.append('Message', Message);
                                    formData.append('NewsVisibility',Visibility);
                                    formData.append('Date',UpdDate);
                                    formData.append('Time',UpdTime);
                                    formData.append('ProviderID',ProviderID);
                                    
                                    $.ajax({
                                        data: formData,
                                        url: 'PostProvNews',
                                        type: 'POST',
                                        processData: false,
                                        contentType: false,
                                        success:function (data)
                                        {
                                            document.getElementById('PageLoader').style.display = 'none';
                                            $.ajax({
                                                type:"POST",
                                                data:"MessageID="+data,
                                                url:"getLastProvNews",
                                                success: function(result){
                                                    
                                                    var MessageData = JSON.parse(result);
                                                    
                                                    var MessagePic = MessageData.Photo;
                                                    var MessageID = MessageData.ID;
                                                    var Message = MessageData.Message;
                                                    
                                                    if(MessagePic !== ""){
                                                        document.getElementById("defaultPic").setAttribute("src", "data:image/jpg;base64,"+MessagePic);
                                                       
                                                    }
                                                    document.getElementById("MessageP").innerHTML = Message;
                                                    document.getElementById("RecentMessageID").value = MessageID;
                                                    document.getElementById("NewsMessageFld").value = "What should your clients know about?";
                                                }
                                            });
                                        }
                                    });
                                    
                                    
                                });
                            });
                        </script>
                        
                        <tr style="">
                            <td>
                                <div style='margin-bottom: 10px; overflow-y: auto; padding: 2px;'>
                                    <div style="background-color: white; padding: 4px;">
                                        <p style='font-weight: bolder; margin-bottom: 3px;'>Recent News</p>
                                        
                                        <center><img id="defaultPic" src="<%=NewsPicSrc%>" width="100%" alt="view-wallpaper-7"/></center>
                                        
                                    </div>
                                <p id="MessageP" style=''><%=lastNewsMsg%></p>
                                
                                <input id="RecentMessageID" type="hidden" value="<%=LastNewsID%>" />
                                
                                <img style="float: right;" id="DltRecentNewsBtn" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/>
                                
                                <script>
                                    $(document).ready(function(){
                                        $("#DltRecentNewsBtn").click(function(event){
                                            document.getElementById('PageLoader').style.display = 'block';
                                            var MessageID = document.getElementById("RecentMessageID").value;
                                            
                                            $.ajax({
                                                type: "POST",
                                                url: "DltProvNews",
                                                data: "MessageID="+MessageID,
                                                success: function(result){
                                                    document.getElementById('PageLoader').style.display = 'none';
                                                    //alert(result);
                                                    
                                                    $.ajax({
                                                        type:"POST",
                                                        data:"MessageID="+result,
                                                        url:"getLastProvNews",
                                                        success: function(result){

                                                            var MessageData = JSON.parse(result);

                                                            var MessagePic = MessageData.Photo;
                                                            var MessageID = MessageData.ID;
                                                            var Message = MessageData.Message;
                                                            
                                                            if(MessagePic !== ""){
                                                                document.getElementById("defaultPic").setAttribute("src", "data:image/jpg;base64,"+MessagePic);
                                                            }
                                                            
                                                            document.getElementById("MessageP").innerHTML = Message;
                                                            document.getElementById("RecentMessageID").value = MessageID;
                                                            document.getElementById("NewsMessageFld").value = "What should your clients know about?";
                                                        }
                                                        
                                                    });
                                                }
                                            });
                                        });
                                    });
                                </script>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            </div>
            
                                
            <div id='PhoneCalender' style='display: none; margin-top: 5px; width: 100%;'>
                <center><p style="color: darkblue; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Your Calender</p></center>
            
                <table  id="PhoneExtrasTab" style='padding: 4px; width: 100%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <div id="DateChooserDiv" style=''>
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Pick a date below</p>
                                    <% SimpleDateFormat CalDateFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");%>
                                    <p style='text-align: center;'><input id="CalDatePicker" style='cursor: pointer; width: 90%; 
                                                                          font-weight: bolder; border: 0; background-color: #ccc; padding: 5px;' type="button" name="CalDateVal" 
                                                                          value="<%= new Date().toString().substring(0,3) + ", " +CalDateFormat.format(new Date())%>" readonly onkeydown="return false"/></p>
                                    <script>
                                    $(function() {
                                        $("#CalDatePicker").datepicker();
                                      });
                                    </script>
                                </div>
                                    
                            </td>
                        </tr>
                        <tr id='AppointmentsTr' style='display: none; background-color: #eeeeee;'>
                            <div style='padding-bottom: 5px; background-color: white; padding: 5px;  max-width: 590px;'>
                                    <div onclick="showEventsTr();" id='EventsTrBtn' style='padding: 5px; cursor: pointer; border-radius: 4px; border: 0; color: darkslateblue; background-color: #eeeeee; width: 46%; float: right;'>Events</div>
                                    <div onclick="showAppointmentsTr();" id='AppointmentsTrBtn' style='padding: 5px; cursor: pointer; border-radius: 4px; border: 0; color: darkslateblue; background-color: #ccc; width: 46%; float: left;'>Appointments</div>
                                    <p style='clear: both;'></p>
                                </div>
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Appointments</p>
                                
                                <input type="hidden" id="CalApptUserID" value="<%=UserID%>" />
                                
                                <div id='CalApptListDiv' style='height: 290px; overflow-y: auto;'>
                                    
                                    <%
                                        int count = 1;
                                        
                                        for(int aptNum = 0; aptNum < AppointmentListExtra.size(); aptNum++ ){
                                            
                                            
                                            
                                            int AptID = AppointmentListExtra.get(aptNum).getAppointmentID();
                                            String ProvName = AppointmentListExtra.get(aptNum).getProviderName();
                                            String ApptReason = AppointmentListExtra.get(aptNum).getReason().trim();
                                            //if(ApptReason.length() > 13)
                                                //ApptReason = ApptReason.substring(0, 12) + "...";
                                            String AptTime = AppointmentListExtra.get(aptNum).getTimeOfAppointment();
                                            if(AptTime.length() > 5)
                                                AptTime = AptTime.substring(0,5);
                                    %>
                                    
                                    <p style="background-color: #ffc700; margin-bottom: 2px;"><%=count%>. <span style="color: white; font-weight: bolder;"><%=ProvName%></span>: <span style="color: darkblue; font-weight: bolder;"><%=ApptReason%></span> at <span style="color: darkblue; font-weight: bolder;"><%=AptTime%></span></p>
                                    
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
                                                var ProviderID = document.getElementById("CalApptUserID").value;
                                                //alert(ProviderID);
                                                //alert(date);
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetProvApptForExtra",
                                                    data: "Date="+date+"&ProviderID="+ProviderID,
                                                    success: function(result){
                                                        
                                                        //alert(result);
                                                        
                                                        var ApptData = JSON.parse(result);
                                                        
                                                        var aDiv = document.createElement('div');
                                                        
                                                        for(i in ApptData.Data){
                                                            
                                                            var number = parseInt(i, 10) + 1;
                                                            
                                                            var name = ApptData.Data[i].CustName;
                                                            var service = ApptData.Data[i].Service;
                                                            //if(comp.length > 13)
                                                                //comp = comp.substring(0,12) + "...";
                                                            
                                                            var time = ApptData.Data[i].ApptTime;
                                                            
                                                            aDiv.innerHTML += '<p style="background-color: #ffc700; margin-bottom: 2px;">'+number+'. <span style="color: white; font-weight: bolder;">'+name+'</span>: <span style="color: darkblue; font-weight: bolder;">'+service+'</span> at <span style="color: darkblue; font-weight: bolder;">'+time+'<span></p>';
                                                            
                                                        }
                                                        
                                                        document.getElementById("CalApptListDiv").innerHTML = aDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetProvEvntAjax",
                                                    data: "Date="+date+"&ProviderID="+ProviderID,
                                                    success: function(result){
                                                        //alert(result);
                                                        document.getElementById('PageLoader').style.display = 'none';
                                                        var EvntsData = JSON.parse(result);
                                                        
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
                                            String EventsQuery = "Select * from QueueServiceProviders.CalenderEvents where ProvID = ? and EventDate = ?";
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
                                                EventTitle = EventTitle.replaceAll("\\s", " ");
                                                String EventDesc = EventsRec.getString("EventDesc").trim();
                                                EventDesc = EventDesc.replace("\"", "");
                                                EventDesc = EventDesc.replace("'", "");
                                                EventDesc = EventDesc.replaceAll("\\s", " ");
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
                                    <p><input placeholder="pick event time" id="DisplayedAddEvntTime" style='background-color: white; width: 300px;' type="text" name="" value="" readonly onkeydown="return false"/></p>
                                        <input id="AddEvntTime" style='background-color: white;' type="hidden" name="EvntTime" value="" />
                                    <p><input placeholder="pick event date" id='EvntDatePicker' style='background-color: white; width: 300px;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p><input placeholder="add event title" id="AddEvntTtle" style='background-color: white; width: 300px;' type="text" name="EvntTitle" value="" /></p>
                                    <p><textarea onfocusout="checkEmptyEvntDesc();" id="AddEvntDesc" name="EvntDesc" rows="4" style='width: 99%; border: 0; background-color: #ccc;'>Describe this event here
                                        </textarea></p>
                                </div>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <input type="hidden" id="EvntIDFld" value=""/>
                                <center><input id="CalSaveEvntBtn" style='border: 0; color: white; border-radius: 4px; padding: 5px; background-color: darkslateblue; width: 95%;' type='button' value='Save' /></center>
                                <center><input onclick="" id="CalDltEvntBtn" style='color: white; padding: 5px; border: 0; float: right; display: none; border-radius: 4px; background-color: darkslateblue; width: 46%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate();" id="CalUpdateEvntBtn" style='border: 0; float: left; display: none; border-radius: 4px; padding: 5px; color: white; background-color: darkslateblue; width: 46%;' type='button' value='Change' /></center>
                            </td>
                            
                            <script>
                        
                                document.getElementById("AddEvntDesc").value = "Add event description here...";

                                function checkEmptyEvntDesc(){
                                    if(document.getElementById("AddEvntDesc").value === "")
                                        document.getElementById("AddEvntDesc").value = "Add event description here...";
                                }

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
                                            CalSaveEvntBtn.style.backgroundColor = "darkslateblue";
                                            CalSaveEvntBtn.disabled = false;
                                        }
                                        if(CalUpdateEvntBtn){
                                            CalUpdateEvntBtn.style.backgroundColor = "darkslateblue";
                                            CalUpdateEvntBtn.disabled = false;
                                        }
                                        if(CalDltEvntBtn){
                                            CalDltEvntBtn.style.backgroundColor = "darkslateblue";
                                            CalDltEvntBtn.disabled = false;
                                        }
                                    }


                                }, 1);
                                
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

                        </script>
                            
                        </tr>
                        
                        <script>
                            $(document).ready(function(){
                                
                                $("#CalDltEvntBtn").click(function(event){
                                    
                                    document.getElementById('PageLoader').style.display = 'block';
                                    var EventID = document.getElementById("EvntIDFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltProvEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            if(result === "success")
                                                alert(result);
                                                document.getElementById('PageLoader').style.display = 'none';
                                                document.getElementById("CalUpdateEvntBtn").style.display = "none";
                                                document.getElementById("CalDltEvntBtn").style.display = "none";
                                                document.getElementById("CalSaveEvntBtn").style.display = "block";
                                                document.getElementById("AddEvntTtle").value = "";
                                                document.getElementById("AddEvntDesc").value = "";
                                                document.getElementById("EvntDatePicker").value = "";
                                                document.getElementById("AddEvntTime").value = "";
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
                                        url: "UpdateProvEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&EventID="+EvntId,
                                        success: function(result){
                                            
                                            document.getElementById('PageLoader').style.display = 'none';
                                            //alert(result);
                                            
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
                                    
                                    var ProvID = document.getElementById("CalApptUserID").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "AddEventProv",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&ProviderID="+ProvID,
                                        success: function(result){
                                            
                                            document.getElementById('PageLoader').style.display = 'none';
                                            //alert(result);
                                            
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
                                    document.getElementById("EvntIDFld").value = "";
                                    
                                });
                            });
                        </script>
                    </tbody>
                </table>
            </div>
                             
        <div id='PhoneExtrasUserAccountDiv' style='width: 100%; display: none;'>
            <center><p style="color: darkblue; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Your Account</p></center>
            
                <table  id="PhoneExtrasTab" style='padding: 4px; width: 100%; max-width: 600px;' cellspacing="0">
                    <tbody>
                        <tr style="">
                            <td>
                                <div style="background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; width: 280px; border: #3d6999 1px solid; margin: auto;">
                                <p style='margin-bottom: 5px; color: white;'>Edit Your Personal Info</p>
                                <p>First Name: <input id="ExtProvFNameFld" style='background-color: #9bb1d0; border-radius: 4px; border: 0; text-align: left; color: white;' type="text" name="ExtfName" value="<%=FirstName%>" /></p>
                                <p>Middle Name: <input id="ExtProvMNameFld" style='background-color: #9bb1d0; border-radius: 4px; border: 0; text-align: left; color: white;' type="text" name="ExtmName" value="<%=MiddleName%>" /></p>
                                <p>Last Name: <input id="ExtProvLNameFld" style='background-color: #9bb1d0; border-radius: 4px; border: 0; text-align: left; color: white;' type="text" name="ExtlName" value="<%=LastName%>" /></p>
                                <p>Email: <input id="ExtProvEmailFld" style='background-color: #9bb1d0; border-radius: 4px; border: 0; text-align: left; color: white;' type="text" name="ExtEmail" value="<%=Email%>" /></p>
                                <p>Phone: <input onclick="checkExtMiddlePhoneNumberEdit();"  onkeydown="checkExtMiddlePhoneNumberEdit();"id="ExtProvPhnNumberFld"
                                        style='background-color: #9bb1d0; border: 0; text-align: left; color: white;' type="text" name="EvntTime" value="<%=PhoneNumber%>" /></p>
                                <center><input id="ExtUpdateProvPerBtn" style='background-color: darkslateblue; border-radius: 4px; width: 95%; padding: 5px;' type="submit" value="Change" /></center>
                                </div>
                            </td>
                            <script>
                                                        var ExtProvPhnNumberFld = document.getElementById("ExtProvPhnNumberFld");

                                                        function numberExtFuncPhoneNumberEdit(){

                                                            var number = parseInt((ExtProvPhnNumberFld.value.substring(ExtProvPhnNumberFld.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                ExtProvPhnNumberFld.value = ExtProvPhnNumberFld.value.substring(0, (ExtProvPhnNumberFld.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberExtFuncPhoneNumberEdit, 1);

                                                        function checkExtMiddlePhoneNumberEdit(){

                                                            for(var i = 0; i < ExtProvPhnNumberFld.value.length; i++){

                                                                var middleString = ExtProvPhnNumberFld.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    ExtProvPhnNumberFld.value = ExtProvPhnNumberFld.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                    
                                                    <input id="ExtProvIDforPerDetails" type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                                   
                                                <script>
                                                    $(document).ready(function(){
                                                        $("#ExtUpdateProvPerBtn").click(function(event){
                                                            
                                                            document.getElementById('PageLoader').style.display = 'block';
                                                            var FirstName = document.getElementById("ExtProvFNameFld").value;
                                                            var MiddleName = document.getElementById("ExtProvMNameFld").value;
                                                            var LastName = document.getElementById("ExtProvLNameFld").value;
                                                            var PerEmail = document.getElementById("ExtProvEmailFld").value;
                                                            var PerTel = document.getElementById("ExtProvPhnNumberFld").value;
                                                            var ProviderID = document.getElementById("ExtProvIDforPerDetails").value;
                                                                
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "UpdateProvPerInfoController",
                                                                data: "ProviderID="+ProviderID+"&FirstNameFld="+FirstName+"&MiddleNameFld="+MiddleName+"&LastNameFld="+LastName+"&EmailFld="+PerEmail+"&MobileNumberFld="+PerTel,
                                                                success: function(result){
                                                                    document.getElementById('PageLoader').style.display = 'none';
                                                                   $.ajax({
                                                                        type: "POST",
                                                                        url: "GetProvPerInfo",
                                                                        data: "ProviderID="+ProviderID,
                                                                        success: function(result){
                                                                            //alert(result);
                                                                            
                                                                            var PerInfo = JSON.parse(result);
                                                                            
                                                                            document.getElementById("ExtProvFNameFld").value = PerInfo.FirstName;
                                                                            document.getElementById("ExtProvMNameFld").value = PerInfo.MiddleName;
                                                                            document.getElementById("ExtProvLNameFld").value = PerInfo.LastName;
                                                                            document.getElementById("ExtProvEmailFld").value = PerInfo.Email;
                                                                            document.getElementById("ExtProvPhnNumberFld").value = PerInfo.Mobile;
                                                                            
                                                                            var FullName = PerInfo.FirstName + " " + PerInfo.MiddleName + " " + PerInfo.LastName;
                                                                            var Company = PerInfo.Company;
                                                                            
                                                                            document.getElementById("FullNameDetail").innerHTML = FullName;
                                                                            document.getElementById("EmailDetail").innerHTML = PerInfo.Email;
                                                                            document.getElementById("PhoneDetail").innerHTML = PerInfo.Mobile;
                                                                            document.getElementById("LoginNameDisplay").innerHTML = "Logged in as " +PerInfo.FirstName+ " - " + Company;
                                                                            
                                                                        }
                                                                    });
                                                                    
                                                                }
                                                                

                                                            });
                                                           
                                                        });
                                                    });
                                                    
                                                </script>
                                                
                                                <script>
                                                    
                                                    var ExtProvFNameFld = document.getElementById("ExtProvFNameFld");
                                                    var ExtProvMNameFld = document.getElementById("ExtProvMNameFld");
                                                    var ExtProvLNameFld = document.getElementById("ExtProvLNameFld");
                                                    var ExtProvPhnNumberFld2 = document.getElementById("ExtProvPhnNumberFld");
                                                    var ExtProvEmailFld = document.getElementById("ExtProvEmailFld");
                                                    var ExtUpdateProvPerBtn = document.getElementById("ExtUpdateProvPerBtn");
                                                    
                                                    function CheckExtUpdateProvPerBtn(){
                                                        
                                                        if(ExtProvFNameFld.value === "" || ExtProvMNameFld.value === "" || ExtProvLNameFld.value === ""
                                                                || ExtProvPhnNumberFld2.value === "" || ExtProvEmailFld.value === ""){
                                                            ExtUpdateProvPerBtn.style.backgroundColor = "darkgrey";
                                                            ExtUpdateProvPerBtn.disabled = true;
                                                        }else{
                                                            ExtUpdateProvPerBtn.style.backgroundColor = "darkslateblue";
                                                            ExtUpdateProvPerBtn.disabled = false;
                                                        }
                                                            
                                                        
                                                    }
                                                    setInterval(CheckExtUpdateProvPerBtn,1);
                                                    
                                                </script>
                        </tr>
                        <tr>
                            <td>
                                <div id="ExtrasFeedbackDiv" style="background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; width: 280px; border: #3d6999 1px solid; margin: auto; margin-top: 5px;">
                                    <p style='margin-bottom: 5px; color: white;'>Send Feedback</p>
                                    <form id="ExtrasFeedBackForm" style="width: 95%;" >
                                            <center><div id='ExtLastReviewMessageDiv' style='display: none; background-color: white; width: 100%;'>
                                                <p id='ExtLasReviewMessageP' style='text-align: left; padding: 5px; color: darkgray; font-size: 13px;'></p>
                                                <p id="ExtFeedBackDate" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td><textarea id="ExtFeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" style='width: 270px; background-color: #d9e8e8; border-radius: 4px;'>Compose Feedback Message Here...
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='ExtFeedBackUserID' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="ExtSendFeedBackBtn" style="color: white; width: 100%; border-radius: 4px; padding: 5px; background-color: darkslateblue;" type="button" value="Send" /></center>
                                                <script>
                                                    $(document).ready(function() {                        
                                                         $('#ExtSendFeedBackBtn').click(function(event) {  

                                                            document.getElementById('PageLoader').style.display = 'block';
                                                             var feedback = document.getElementById("ExtFeedBackTxtFld").value;
                                                             var ProviderID = document.getElementById("ExtFeedBackUserID").value;

                                                             $.ajax({  
                                                             type: "POST",  
                                                             url: "SendProvFeedbackMsg",  
                                                             data: "FeedBackMessage="+feedback+"&ProviderID="+ProviderID,  
                                                             success: function(result){ 
                                                                 
                                                               document.getElementById('PageLoader').style.display = 'none';
                                                               document.getElementById("ExtFeedBackTxtFld").innerHTML = "Add your message here...";
                                                               document.getElementById("ExtLastReviewMessageDiv").style.display = "block";
                                                               document.getElementById("ExtLasReviewMessageP").innerHTML = "You've Sent: "+ "<p style='color: green; font-size: 15px;'>" +feedback+ "</p>";

                                                               $.ajax({  
                                                                    type: "POST",  
                                                                    url: "getProvFeedbackDate",  
                                                                    data: "CustomerID="+ProviderID,  
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
                        <tr >
                            <td>
                                <div style="background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; width: 280px; border: #3d6999 1px solid; margin: auto; margin-top: 5px;">
                                <p style='margin-bottom: 5px; color: white;'>Update Your Login</p>
                                <P>User Name: <input id="ExtUsrNamefld" style='background-color: #d9e8e8; border-radius: 4px; text-align: left; color: cadetblue; font-weight: bolder; text-align: center;' type='text' name='ExtUserName' value='<%=UserName%>'/></p>
                                <P><input id="ExtcompareOldPassfld" style='background-color: #d9e8e8; border-radius: 4px;; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter Current Password' type='password' name='ExtOldPass' value=''/></p>
                                <P><input id="ExtnewPassfld" style='background-color: #d9e8e8; border-radius: 4px; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter New Password' type='password' name='ExtNewPass' value=''/></p>
                                <P><input id="ExtcompareNewPassfld" style='background-color: #d9e8e8; border-radius: 4px; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Confirm New Password' type='password' name='ExtConfirmPass' value=''/></p>
                                <center><input id="ExtupdateUsrAcntBtn" style='background-color: darkslateblue; border-radius: 4px; padding: 5px; width: 95%;' type="submit" value="Change" /></center>
                                <p id="ExtWrongPassStatus" style="display: none; background-color: red; color: white; text-align: center;">You have entered wrong current password</p>
                                <p id='ExtUpdatePassStatus' style='text-align: center; color: white;'></p>
                                </div>
                            </td>
                            <input type='hidden' id='ExtoldPassfld' value='' />
                            <input type="hidden" id="ExtProviderIDforUpdateLogin" value="<%=UserID%>" />
                            <input type="hidden" id="ExtUserIndexforUpdateLogin" value="<%=UserIndex%>" />
                            <script>
                                                        $(document).ready(function(){
                                                            $("#ExtupdateUsrAcntBtn").click(function(event){
                                                                
                                                                document.getElementById('PageLoader').style.display = 'block';
                                                                var ProviderID = document.getElementById("ExtProviderIDforUpdateLogin").value;
                                                                var UserIndex = document.getElementById("ExtUserIndexforUpdateLogin").value;
                                                                var UserName = document.getElementById("ExtUsrNamefld").value;
                                                                var NewPassword = document.getElementById("ExtnewPassfld").value;
                                                                var oldPassword = document.getElementById("ExtcompareOldPassfld").value;
                                                                
                                                                /*alert(ProviderID);
                                                                alert(UserName);
                                                                alert(NewPassword);
                                                                alert(oldPassword);
                                                                alert(UserIndex);*/
                                                                
                                                                $.ajax({
                                                                    method: "POST",
                                                                    url: "updateProvLoginInfo",
                                                                    data: "ProviderID="+ProviderID+"&UserIndex="+UserIndex+"&UserNameFld="+UserName+"&NewPasswordFld="+NewPassword+"&OldPasswordFld="+oldPassword,
                                                                    success: function(result){
                                                                        document.getElementById('PageLoader').style.display = 'none';
                                                                        //alert(result);
                                                                        
                                                                        if(result === "fail"){
                                                                            
                                                                            document.getElementById("ExtWrongPassStatus").style.display = "block";
                                                                            document.getElementById("ExtcompareOldPassfld").value = "";
                                                                            document.getElementById("ExtcompareOldPassfld").style.backgroundColor = "red";
                                                                            
                                                                            //document.getElementById("changeUserAccountStatus").innerHTML = "Enter your old password correctly";
                                                                            //document.getElementById("changeUserAccountStatus").style.backgroundColor = "red";
                                                                            //document.getElementById("LoginFormBtn").disabled = true;
                                                                            //document.getElementById("LoginFormBtn").style.backgroundColor = "darkgrey";
                                                                        }
                                                                        if(result === "success"){
                                                                            document.getElementById("ExtnewPassfld").value = "";
                                                                            document.getElementById("ExtcompareOldPassfld").value = "";
                                                                            document.getElementById("ExtcompareOldPassfld").style.backgroundColor = "white";
                                                                            document.getElementById("ExtcompareNewPassfld").value = "";
                                                                            document.getElementById("ExtWrongPassStatus").style.display = "none";
                                                                            
                                                                            //getUserAccountNameController
                                                                            $.ajax({
                                                                                method: "POST",
                                                                                url: "getProvUserAccountName",
                                                                                data: "ProviderID="+ProviderID,
                                                                                
                                                                                success: function(result){

                                                                                    document.getElementById("ExtUsrNamefld").value = result;


                                                                                }

                                                                            });
                                                                        }
                                                                    }
                                                                    
                                                                });
                                                                
                                                            });
                                                        });
                                                    </script>
                                               
                                    <script>
                                        
                                        var ExtUsrNamefld = document.getElementById("ExtUsrNamefld");
                                        var ExtoldPassfld = document.getElementById("ExtoldPassfld");
                                        var ExtcompareOldPassfld = document.getElementById("ExtcompareOldPassfld");
                                        var ExtnewPassfld = document.getElementById("ExtnewPassfld");
                                        var ExtcompareNewPassfld = document.getElementById("ExtcompareNewPassfld");
                                        var ExtupdateUsrAcntBtn = document.getElementById("ExtupdateUsrAcntBtn");
                                        var ExtUpdatePassStatus = document.getElementById("ExtUpdatePassStatus");
                                        
                                        function CheckExtUpdateUsrAcntBtn(){
                                            
                                            if(ExtUsrNamefld.value === "" || ExtcompareOldPassfld.value === "" || ExtnewPassfld.value === "" || ExtcompareNewPassfld.value === ""){
                                                ExtUpdatePassStatus.style.backgroundColor = "green";
                                                ExtUpdatePassStatus.innerHTML = "Uncompleted Form";
                                                ExtupdateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                ExtupdateUsrAcntBtn.disabled = true;
                                            }else if(ExtnewPassfld.value.length < 8){ //.length is a property not a function (like .length();)
                                                   ExtUpdatePassStatus.style.backgroundColor = "red";
                                                   ExtUpdatePassStatus.innerHTML = "Password Too Short";
                                                   ExtupdateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                   ExtupdateUsrAcntBtn.disabled = true;
                                               }
                                               else if(ExtnewPassfld.value !== ExtcompareNewPassfld.value){
                                                   ExtUpdatePassStatus.style.backgroundColor = "red";
                                                   ExtUpdatePassStatus.innerHTML = "New Passwords Don't Match";
                                                   ExtupdateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                   ExtupdateUsrAcntBtn.disabled = true;
                                               }else{

                                                   ExtUpdatePassStatus.style.backgroundColor = "green";
                                                   ExtUpdatePassStatus.innerHTML = "OK";
                                                   ExtupdateUsrAcntBtn.style.backgroundColor = "darkslateblue";
                                                   ExtupdateUsrAcntBtn.disabled = false;
                                               }
                                               
                                            
                                        }
                                        
                                        setInterval(CheckExtUpdateUsrAcntBtn, 1);
                            </script>
                                                    
                        </tr>
                        <tr>
                            <td>
                                
                                <script>
                                    function LogoutMethod(){
                                        document.getElementById('PageLoader').style.display = 'block';
                                        window.localStorage.removeItem("ProvQueueUserName");
                                        window.localStorage.removeItem("ProvQueueUserPassword");
                                    }
                                </script>
                                
                                <form action = "LogoutController" name="LogoutForm" method="POST"> 
                                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                    <center><input onclick="LogoutMethod();" style='width: 95%; max-width: 300px; margin: auto;' type="submit" value="Logout" class="button" /></center>
                                </form>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
                                
            <div id='PhoneExtrasNotificationDiv' style='width: 100%; display: none;'>
            <center><p style="color: darkblue; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Notifications</p></center>
            
                <table  id="PhoneExtrasTab" style='width: 100%; background-color: white; max-width: 600px;' cellspacing="0">
                    <tbody>
                        
                    <%
                        
                        boolean isTrWhite = false;
                        
                        for(int notify = 0 ; notify < Notifications.size(); notify++){
                    
                        if(!isTrWhite){
                            
                    %>
                    
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p style='text-align: justify; padding: 3px;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%
                                isTrWhite = true;
                            }else{
                            
                    %>
                    
                        <tr>
                            <td>
                                <p style='text-align: justify; padding: 3px;'><%=Notifications.get(notify)%></p>
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
                        </tr-->
                        
                    <%
                            if(notiCounter > 7){
                    %>
                    
                        <tr style="background-color: #eeeeee;">
                            <td>
                            </td>
                        </tr>
                        
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div></center>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    <script>
            var Settings = "<%=Settings%>";
               //alert(Settings);
            if(Settings === "1"){
                showPCustExtraNews();
                document.getElementById("NewsIndicator").style.backgroundColor = "#334d81";
            }else if(Settings === "2"){
                showPCustExtraNotification();
                document.getElementById("NotiIndicator").style.backgroundColor = "#334d81";
               
                var NotiIDs = document.getElementById("NotiIDInput").value;
                var NotiJSON = JSON.parse(NotiIDs);
                            
                for(i in NotiJSON.Data){
                    //alert(NotiJSON.Data[i].ID);
                    var ID = NotiJSON.Data[i].ID;
                    $.ajax({
                        type: "POST",
                        url: "SetProvNotificationAsSeen",
                        data: "ID="+ID,
                        success: function(result){
                            document.getElementById("notiCounterSup").innerHTML = " 0 ";
                        }
                    });
                }
                            
             
                
            }else if(Settings === "3"){
                showPCustExtraCal();
                document.getElementById("CalIndicator").style.backgroundColor = "#334d81";
            }else if(Settings === "4"){
                showPCustExtraUsrAcnt();
                document.getElementById("SettingIndicator").style.backgroundColor = "#334d81";
            }else{
                //do nothing
            }
        </script>
</html>
