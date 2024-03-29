<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="org.apache.catalina.Session"%>
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
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page import="com.arieslab.queue.queue_model.ProviderCustomerData"%>

<!DOCTYPE html>

<html>
    
    <head>       
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue  | Customer</title>
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        
    </head>
    
    <script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
    
    <%
        
        //resetting ResendAppointmentData data feilds
        ResendAppointmentData.CustomerID = "";
        ResendAppointmentData.ProviderID = "";
        ResendAppointmentData.SelectedServices = "";
        ResendAppointmentData.AppointmentDate = "";
        ResendAppointmentData.AppointmentTime = "";
        ResendAppointmentData.PaymentMethod = "";
        ResendAppointmentData.ServicesCost = "";
        ResendAppointmentData.CreditCardNumber = "";
        
        int notiCounter = 0;
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        //connection arguments
        String Url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String user = config.getServletContext().getAttribute("DBUser").toString();
        String password = config.getServletContext().getAttribute("DBPassword").toString();
        
        
        Date ThisDate = new Date();//default date constructor returns current date 
        String CurrentTime = ThisDate.toString().substring(11,16);
        
        //UserAccount.UserID stores UserID after Login Successfully
        ProviderCustomerData.eachCustomer = null;
        int JustLogged = 0;
        boolean isSameUserName = true;
        boolean isSameSessionData = true;
        boolean isUserIndexInList = true;
        int UserID = 0;
        String NewUserName = "";
        String NameFromList = "";
        String ControllerResult = "";
        
        try{
            ControllerResult = request.getParameter("result");
        }catch(Exception e){}
        
        int UserIndex = -1;
        
        try{
            
            UserIndex = Integer.parseInt(request.getAttribute("UserIndex").toString());
            JustLogged = 1;
            
        }catch(Exception e){}
        
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
                //response.sendRedirect("LogInPage.jsp");
            }
            
            /*if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }*/

            /*if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");*/
            
        }catch(Exception e){
            isUserIndexInList = false;
            //response.sendRedirect("LogInPage.jsp");
        }
        
        String SessionID = request.getRequestedSessionId();
        String DatabaseSession = "";
        //JOptionPane.showMessageDialog(null, SessionID);
        
        //getting session data from database
        try{
            Class.forName(Driver);
            Connection SessionConn = DriverManager.getConnection(Url, user, password);
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
                Connection DltSesConn = DriverManager.getConnection(Url, user, password);
                String DltSesString = "delete from QueueObjects.UserSessions where UserIndex = ?";
                PreparedStatement DltSesPst = DltSesConn.prepareStatement(DltSesString);
                DltSesPst.setInt(1, UserIndex);
                DltSesPst.executeUpdate();
            }
            catch(Exception e){}
            
            isSameSessionData = false;
            //response.sendRedirect("LogInPage.jsp");
        }
        
        if(!isSameSessionData || !isSameUserName || UserID == 0 || !isUserIndexInList)
            response.sendRedirect("Queue.jsp");
        else if(JustLogged == 1){
            response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
        }
        
        String AppointmentDateValue = "";
        
        ProviderCustomerData eachCustomer = null;
        
        //ArrayList to store all appointments list (made global for global access)
        ArrayList<BookedAppointmentList> AppointmentList = new ArrayList<>();
        ArrayList<BookedAppointmentList> AppointmentHistory = new ArrayList<>();
        ArrayList<BookedAppointmentList> FutureAppointmentList = new ArrayList<>();
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Query = "Select * from ProviderCustomers.CustomerInfo where Customer_ID=?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setInt(1,UserID);
            ResultSet userData = pst.executeQuery();
            
            while(userData.next()){
                
                eachCustomer = new ProviderCustomerData(userData.getInt("Customer_ID"), userData.getString("First_Name"), userData.getString("Middle_Name"), 
                        userData.getString("Last_Name"), userData.getBlob("Profile_Pic"), userData.getString("Phone_Number"), userData.getDate("Date_Of_Birth"), userData.getString("Email"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        String thisUserName = "";
        String ThisPassword = "";
                                                        
        try{
            Class.forName(Driver);
            Connection AccountConn = DriverManager.getConnection(Url, user, password);
            String AccountString = "Select * from ProviderCustomers.UserAccount where CustomerId = ?";
            PreparedStatement AccountPst = AccountConn.prepareStatement(AccountString);
            AccountPst.setInt(1, UserID);
                                                            
            ResultSet AccountUserName = AccountPst.executeQuery();
                                                            
            while(AccountUserName.next()){
                thisUserName = AccountUserName.getString("UserName").trim();
                //ThisPassword = AccountUserName.getString("Password");
            }
                                                            
                                                            
        }catch(Exception e){
            e.printStackTrace();
        }
                                                        
                                                    
        
    
        //Getting Current Appointments
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StringCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            
            //the original algo here is go back an hour and start counting up till its about 30 mins before current time
            if(CurrentTimeForAppointment.length() < 5)
                CurrentTimeForAppointment = "0" + CurrentTimeForAppointment;
            
            int TempHour2 = Integer.parseInt(CurrentTimeForAppointment.substring(0,2));
            int TempMinute2 = Integer.parseInt(CurrentTimeForAppointment.substring(3,5));

            TempHour2 -= 5; //turning this into 300 minutes
            
            if(TempHour2 < 1){
                TempHour2 = 1;
                TempMinute2 = 1;
                
            }
               
            String SMinute2 = Integer.toString(TempMinute2);
                            
            if(Integer.toString(TempMinute2).length() < 2)
                SMinute2 = "0" + TempMinute2;

            CurrentTimeForAppointment = TempHour2 + ":" + SMinute2;
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Select = "Select * from QueueObjects.BookedAppointment where CustomerID = ? and AppointmentDate = ? and AppointmentTime >= ? order by AppointmentTime asc";
            PreparedStatement pst = conn.prepareStatement(Select);
            pst.setInt(1, UserID);
            pst.setString(2, StringCurrentdate);
            pst.setString(3, CurrentTimeForAppointment);
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
                    Connection providerConn = DriverManager.getConnection(Url, user, password);
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
                AppointmentList.add(eachAppointmentItem);
                
            }
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //Getting future appointments
        
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StringCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Select = "Select * from QueueObjects.BookedAppointment where CustomerID = ? and AppointmentDate > ?  order by AppointmentDate asc";
            PreparedStatement pst = conn.prepareStatement(Select);
            pst.setInt(1,UserID);
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
                    Connection providerConn = DriverManager.getConnection(Url, user, password);
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
                FutureAppointmentList.add(eachAppointmentItem);
                
                if(FutureAppointmentList.size() > 5)
                    break;
                
            }
            
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        //Getting AppointmentHistory
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StrinCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection historyConn = DriverManager.getConnection(Url, user, password);
            String appointmentHistoryQuery = "Select * from QueueObjects.BookedAppointment where CustomerID = ? and AppointmentDate < ? or (CustomerID = ? and AppointmentDate = ? and AppointmentTime < ?) order by AppointmentDate desc";
            PreparedStatement appointmentHistoryPst = historyConn.prepareStatement(appointmentHistoryQuery);
            appointmentHistoryPst.setInt(1,UserID);
            appointmentHistoryPst.setString(2, StrinCurrentdate);
            appointmentHistoryPst.setInt(3,UserID);
            appointmentHistoryPst.setString(4, StrinCurrentdate);
            appointmentHistoryPst.setString(5, CurrentTimeForAppointment);
            ResultSet historyRecords = appointmentHistoryPst.executeQuery();
            
            BookedAppointmentList eachHistoryRecord;
            
            while(historyRecords.next()){
                
                String Reason = historyRecords.getString("OrderedServices").trim();
                if(Reason.equals("Blocked Time")){
                    
                    continue;
                    
                }
                
                int ProviderID = historyRecords.getInt("ProviderID");
                               
                String ProviderName = "";
                String ProviderCompany = "";
                String ProviderEmail = "";
                String ProviderTel = "";
                Blob ProviderDisplayPic = null;
                
                try{
                    
                    Class.forName(Driver);
                    Connection providerConn = DriverManager.getConnection(Url, user, password);
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
                
                int AppointmentID = historyRecords.getInt("AppointmentID");
                Date AppointmentDate = historyRecords.getDate("AppointmentDate");
                String AppointmentTime = historyRecords.getString("AppointmentTime");
                
                
                
                eachHistoryRecord = new BookedAppointmentList(AppointmentID, ProviderID ,ProviderName, ProviderCompany, ProviderTel, ProviderEmail, AppointmentDate, AppointmentTime, ProviderDisplayPic);
                eachHistoryRecord.setAppointmentReason(Reason);
                AppointmentHistory.add(eachHistoryRecord);
                
                if(AppointmentHistory.size() > 5)
                    break;
            
            }
        }
        catch(Exception e){
            
            e.printStackTrace();
            
        }

        
    %>
    
    <body style="background-color: #ccccff;">
        
        <div style="background-color: #ccccff;">
                                        
                                        <center><table id="selectCustSpttabs" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateAppTab()" id="AppointmentsTab" style="padding: 5px; cursor: pointer; border-top: 1px solid black; width: 33.3%;  background-color: #ccccff;">
                                                        Your Spots
                                                    </td>
                                                    <td onclick="activateHistory()" id="HistoryTab" style="padding: 5px; cursor: pointer; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                        History
                                                    </td>
                                                    <td style="display: none;" onclick="activateFavTab()" id="FavoritesTab" style="padding: 5px; cursor: pointer; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                       
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table></center>
                                        
            <center><div class="scrolldiv" style=" height: 87%; overflow-y: auto;">
                                   
                                   <script>
                                        function showselectCustSpttabs(){
                                            document.getElementById("selectCustSpttabs").scrollIntoView();
                                        }
                                    </script>
                                        
                                <div id="serviceslist" style="padding-bottom: 0; border-top: 0;" class="AppListDiv">
                                    
                                    <p style="color: tomato; margin-top: 10px;">Today's Spots</p>
                                   
                                    <script>
                                    
                                                        var currentDate = new Date();
                                                        var currentTime = '<%=CurrentTime%>';
                                                        
                                                        var currentHour = currentTime.substring(0,2);
                                                        var currentMinute = currentTime.substring(3,5);

                                                         var currentMonth = currentDate.getMonth();
                                                                 currentMonth += 1;
                                                                 currentMonth += "";

                                                                 if(currentMonth.length < 2)
                                                                         currentMonth = "0" + currentMonth;

                                                         var currentDay = currentDate.getDate() + "";

                                                                 if(currentDay.length < 2)
                                                                         currentDay = "0" + currentDay;

                                                         var currentYear = currentDate.getFullYear();

                                                         currentDate = currentMonth + "/" + currentDay + "/" + currentYear;
                                                         //var anotherDate = currentYear + "-" + currentMonth + "-" + currentDay;
                                                         
                                    </script>

                                    
                                    <% 
                                        
                                        String JString = "";
                                        int appointmentItemCounter = 0;
                                        
                                        for(int j = 0; j < AppointmentList.size(); j++){
                                            
                                            boolean isCurrentSpot = false;
                                            boolean isSpotNow = false;
                                            
                                            JString = Integer.toString(j);
                                            String AppointmentTime = AppointmentList.get(j).getTimeOfAppointment().substring(0,5);
                                            
                                            String TimeToUse = "";
                                            int Hours = Integer.parseInt(AppointmentTime.substring(0,2));
                                            String Minutes = AppointmentTime.substring(2,5);
                                            String Base64ProvPic = "";
                                            
                                            try{    
                                              //put this in a try catch block for incase getProfilePicture returns nothing
                                              Blob profilepic = AppointmentList.get(j).getDisplayPic(); 
                                              InputStream inputStream = profilepic.getBinaryStream();
                                              ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                              byte[] buffer = new byte[4096];
                                              int bytesRead = -1;

                                              while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                  outputStream.write(buffer, 0, bytesRead);
                                              }

                                              byte[] imageBytes = outputStream.toByteArray();

                                               Base64ProvPic = Base64.getEncoder().encodeToString(imageBytes);


                                          }
                                          catch(Exception e){}
                                            
                                            if( Hours > 12)
                                            {
                                                 int TempHour = Hours - 12;
                                                 TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                                            }
                                            else if(Hours == 0){
                                                TimeToUse = "12" + Minutes + "am";
                                            }
                                            else if(Hours == 12){
                                                TimeToUse = AppointmentTime + "pm";
                                            }
                                            else{
                                                TimeToUse = AppointmentTime +"am";
                                            }
                                            
                                            int AppointmentID = AppointmentList.get(j).getAppointmentID();
                                            Date AppointmentDate = AppointmentList.get(j).getDateOfAppointment();
                                            
                                            SimpleDateFormat appointmentSDF = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMM dd, yyyy");
                                            String AppointmentFormattedDate = appointmentSDF.format(AppointmentDate);
                                            
                                            int ProviderID = AppointmentList.get(j).getProviderID();
                                            String ProviderName = AppointmentList.get(j).getProviderName();
                                            String ProviderCompany = AppointmentList.get(j).getProviderCompany();
                                            String ProviderTel = AppointmentList.get(j).getProviderTel();
                                            String ProviderEmail = AppointmentList.get(j).getProviderEmail();
                                            String AppointmentReason = AppointmentList.get(j).getReason().trim();
                                            
                                        //--------------------------------------------------------------------------------    
                                            
                                            //checking to see if AppointmentTime is now;
                                            if(AppointmentTime.length() < 5)
                                                AppointmentTime = "0" + AppointmentTime;

                                            String Now = new Date().toString().substring(11,16);

                                            if(Now.length() < 5)
                                                Now = "0" + Now;
                                            
                                            if(Integer.parseInt(AppointmentTime.substring(0,2)) < Integer.parseInt(Now.substring(0,2))){
                                                isSpotNow = true;
                                            }else if(Integer.parseInt(AppointmentTime.substring(0,2)) == Integer.parseInt(Now.substring(0,2))){
                                                if(Integer.parseInt(AppointmentTime.substring(3,5)) <= Integer.parseInt(Now.substring(3,5)))
                                                    isSpotNow = true;
                                            }
                                            
                                                //getting intervals value for this provider
                                                int IntervalsValue = 30;

                                                try{
                                                    Class.forName(Driver);
                                                    Connection IntervalsConn = DriverManager.getConnection(Url, user, password);
                                                    String IntervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                                                    PreparedStatement IntervalsPst = IntervalsConn.prepareStatement(IntervalsString);
                                                    IntervalsPst.setInt(1,ProviderID);

                                                    ResultSet IntervalsRec = IntervalsPst.executeQuery();

                                                    while(IntervalsRec.next()){
                                                        IntervalsValue = Integer.parseInt(IntervalsRec.getString("CurrentValue").trim());
                                                    }


                                                }catch(Exception e){
                                                    e.printStackTrace();
                                                }

                                                //----------------------------------------------------------------------------------
                                                    //the original algo here is go back an hour and start counting up till its about 30 mins before current time
                                                    int TempHour2 = Integer.parseInt(Now.substring(0,2));
                                                    int TempMinute2 = Integer.parseInt(Now.substring(3,5));

                                                    TempHour2 -= 5; //turning this into 300 minutes


                                                    TempMinute2 += 300; //this makes TempMinute2 greater than IntervalsValue according to the prio algo (30 mins algo)

                                                    TempMinute2 -= IntervalsValue;
                                           
                                                    while(TempMinute2 >= 60){
                                                        
                                                        /*if(TempHour2 == 1)
                                                            break;*/
                                                        
                                                        TempHour2++;

                                                        if(TempMinute2 > 60 && TempMinute2 != 60)
                                                            TempMinute2 -= 60;

                                                        else if(TempMinute2 == 60)
                                                            TempMinute2 = 0;

                                                        if(TempHour2 > 23)
                                                            TempHour2 = 23;
                                                    }
                                                    
                                                    if(TempHour2 < 1){
                                                        TempHour2 = 1;
                                                        TempMinute2 = 1;
                                                    }

                                                    String SMinute2 = Integer.toString(TempMinute2);

                                                    if(Integer.toString(TempMinute2).length() < 2)
                                                        SMinute2 = "0" + TempMinute2;

                                                    String ExpectedAppointmentExpire = TempHour2 + ":" + SMinute2;
                                                    
                                                    //checking to make sure time is not after ExpectedExpire;
                                                    if(ExpectedAppointmentExpire.length() < 5)
                                                        ExpectedAppointmentExpire = "0" + ExpectedAppointmentExpire;

                                                    if(Integer.parseInt(AppointmentTime.substring(0,2)) > Integer.parseInt(ExpectedAppointmentExpire.substring(0,2))){
                                                        isCurrentSpot = true;
                                                    }else if(Integer.parseInt(AppointmentTime.substring(0,2)) == Integer.parseInt(ExpectedAppointmentExpire.substring(0,2))){
                                                        if(Integer.parseInt(AppointmentTime.substring(3,5)) >= Integer.parseInt(ExpectedAppointmentExpire.substring(3,5)))
                                                            isCurrentSpot = true;
                                                    }
                                                //----------------------------------------------------------------------------------
                                            //}
                                            //if isCurrentSpot is true and isSpotFuture is true then show the div for the ongoing spot.
                                                
                                            if(isCurrentSpot && isSpotNow){
                                            
                                    %>
                                    
                                    <div style="margin-top: 5px; margin-bottom: 5px; padding-top: 5px; padding-bottom: 5px; background-color: #ffc700; border-bottom: 1px solid darkgray; border-right: 1px solid darkgray; max-width: 700px;">
                                     
                                    <%
                                        if(Base64ProvPic != ""){
                                    %>
                                    <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                     <img class="fittedImg" style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
                                        </div></center>
                                    <%
                                        }
                                    %>
                                       
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                                <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                
                                                <P>This spot with <span style = "color: blue;"><input style="background-color: #ffc700; color: blue; border:0; font-weight: bolder; margin: 0;" type='submit' value="<%= ProviderName%>"/>
                                                </span><span> started at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                        
                                                <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                    <span style = "color: blue;"><input style="background-color: #ffc700; color: blue; border: 0; font-weight: bolder; margin: 0;" type='submit' value="<%= ProviderCompany%>"/></span></span></p>
                                            
                                        </form>
                                        <p><span> <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %> - <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %></span></p>
                                        <p style="color: darkgray; text-align: center;">- <%=AppointmentReason%> -</p>
                                        <p></P>
                                        
                                    </div>
                                    
                                    <%      }
                                            if(Integer.parseInt(AppointmentTime.substring(0,2)) < Integer.parseInt(Now.substring(0,2))){

                                                continue;

                                            }else if(Integer.parseInt(AppointmentTime.substring(0,2)) == Integer.parseInt(Now.substring(0,2)) && Integer.parseInt(AppointmentTime.substring(3,5)) < Integer.parseInt(Now.substring(3,5))){
                                                
                                                continue;

                                            }else{
                                                appointmentItemCounter++;
                                            }
                                    %>
                                    
                                    <div id="AppointmentDiv<%=JString%>" style="margin-top: 5px; margin-bottom: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white; border-bottom: 1px solid darkgray; border-right: 1px solid darkgray; max-width: 700px;">
                                    
                                    <%
                                        if(Base64ProvPic != ""){
                                    %>
                                    <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                     <img class="fittedImg" style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
                                        </div></center>
                                    <%
                                        }
                                    %>
                                        
                                        
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                                <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                
                                                <P>You are on <span style = "color: blue;"><input style="background-color: white; color: blue; border:0; font-weight: bolder; margin: 0;" type='submit' value="<%= ProviderName%>'s"/>
                                                </span><span> line at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                        
                                                <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                    <span style = "color: blue;"><input style="background-color: white; color: blue; border: 0; font-weight: bolder; margin: 0;" type='submit' value="<%= ProviderCompany%>"/></span></span></p>
                                            
                                        </form>
                                        <p><span> <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %> - <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %></span></p>
                                        <p style="color: darkgray; text-align: center;">- <%=AppointmentReason%> -</p>
                                        <p></P>
                                        
                                        <form style=" display: none;" id="changeBookedAppointmetForm<%=JString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                            
                                            <p style="color: tomato; margin-top: 5px;">Set new time or date to change this spot</p>
                                            <input  id="datepicker<%=JString%>" class="datepicker<%=JString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=AppointmentDate%>" />
                                            <input id="timeFld<%=JString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=AppointmentTime%>" />
                                            <input id="timePicker<%=JString%>" style="background-color: white;" type="text" name="ApointmentTimePicker" value="<%=AppointmentTime%>" />
                                            <p id="timePickerStatus<%=JString%>" style="margin-bottom: 3px; background-color: red; color: white; text-align: center;"></p>
                                            <p id="datePickerStatus<%=JString%>" style="background-color: red; color: white; text-align: center;"></p>
                                            <input id="ChangeAppointmentID<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <input id="changeAppointmentBtn<%=JString%>" style="background-color: pink; border: 1px solid black; color: black; padding: 3px;" name="<%=JString%>changeAppointment" type="button" value="Change" />
                                        
                                            <script>
                                                
                                                $( 
                                                    function(){
                                                        $("#datepicker<%=JString%>").datepicker();
                                                    } 
                                                );
                                                
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var AppointmentID = document.getElementById("ChangeAppointmentID<%=JString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFld<%=JString%>").value;
                                                        var AppointmentDate = document.getElementById("datepicker<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById("changeBookedAppointmetForm<%=JString%>").style.display = "none";
                                                          
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetUpdateSpotInfo",
                                                              data: "AppointmentID="+AppointmentID,
                                                              success: function(result){
                                                                  //alert(result);
                                                                  var AppointmentData = JSON.parse(result);
                                                                  document.getElementById("ApptTimeSpan<%=JString%>").innerHTML = AppointmentData.AppointmentTime;
                                                                  //document.getElementById("ApptDateSpan").innerHTML = AppointmentData.AppointmentDate;
                                                              }
                                                          });
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                            
                                            <script>
                                               
                                                    $('#timePicker<%=JString%>').timepicker({
                                                         timeFormat: 'h:mm p',
                                                         interval: 15,
                                                         minTime: '00',
                                                         maxTime: '11:59pm',
                                                         defaultTime: '00',
                                                         startTime: '00',
                                                         dynamic: false,
                                                         dropdown: true,
                                                         scrollbar: true
                                                     });

                                                     function CheckCurrentTimeChooser(){
                                                         
                                                         var tempTime = document.getElementById("timePicker<%=JString%>").value;
                                                         var tempDate = document.getElementById("datepicker<%=JString%>").value;

                                                         if(tempTime.length === 7)
                                                              tempTime = "0" + tempTime;

                                                          var tempHour = "";
                                                          var tempMinute = tempTime.substring(2,5);
                                                         
                                                         if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) !== '12'){
                                                             document.getElementById("timeFld<%=JString%>").value = tempTime.substring(0,5);
                                                         }
                                                         else if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) === '12'){
                                                             document.getElementById("timeFld<%=JString%>").value = "00" + tempMinute;
                                                         }
                                                         else{


                                                             tempHour = parseInt(tempTime.substring(0,2),10) + 12;
                                                             if(tempHour === 24)
                                                                 tempHour = 12;
                                                             
                                                             document.getElementById("timeFld<%=JString%>").value = tempHour + tempMinute;
                                                             
                                                         }
                                                         
                                                        if( currentDate === tempDate ){
                                                            
                                                            if( (parseInt(document.getElementById("timeFld<%=JString%>").value.substring(0,2), 10)) < (parseInt(currentHour, 10)) ){
                                                                document.getElementById("timeFld<%=JString%>").value = currentTime;
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").disabled = true;
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("timePickerStatus<%=JString%>").innerHTML = "Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFld<%=JString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFld<%=JString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFld<%=JString%>").value = currentTime;
                                                                        document.getElementById("changeAppointmentBtn<%=JString%>").disabled = true;
                                                                        document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatus<%=JString%>").innerHTML = "Time cannot be in the past";
                                                            }else{
                                                                
                                                                document.getElementById("timePickerStatus<%=JString%>").innerHTML = "";
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").disabled = false;
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "pink";
                                                                
                                                            }
                                                        
                                                        }else{
                                                            
                                                            document.getElementById("timePickerStatus<%=JString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=JString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "pink";
                                                            
                                                        }

                                                     }

                                                     setInterval(CheckCurrentTimeChooser,1);
                                                     
                                                 </script>
                                            
                                            
                                            <script>
                                                
                                                            
                                                            
                                                        //---------------------------------------------
                                                         //var datepicker = document.getElementById("datepicker<%=JString%>");
                                                         //var datePickerStatus = document.getElementById("datePickerStatus<%=JString%>");

                                                         
                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "";


                                                         function checkDateUpdateValue(){

                                                                 if((new Date(document.getElementById("datepicker<%=JString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepicker<%=JString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatus<%=JString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatus<%=JString%>").innerHTML = "Today's Date: " + currentDate;
                                                                                                 document.getElementById("datePickerStatus<%=JString%>").style.backgroundColor = "green";
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "Only today's date or future date allowed";
                                                                                         document.getElementById("datePickerStatus<%=JString%>").style.backgroundColor = "red";
                                                                                         document.getElementById("datepicker<%=JString%>").value = currentDate;
                                                                                 }
                                                                 }
                                                                 else{

                                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "";
                                                                         //datePickerStatus.innerHTML = "Chosen Date: " + datepicker.value;
                                                                         //datePickerStatus.style.backgroundColor = "green";
                                                                 }

                                                         }

                                                         setInterval(checkDateUpdateValue, 1);                                        
                                                             
                                            </script>
                                            
                                        </form>
                                        
                                        <form style=" display: none;" id="deleteAppointmentForm<%=JString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment">
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to cancel this spot</p>
                                            <p><input id="DeleteAppointmentBtn<%=JString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px;; cursor: pointer;" name="<%=JString%>deleteAppointment" type="button" value="Yes" />
                                                <span onclick = "hideDelete(<%=JString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="AppointmentID<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteAppointmentBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentID<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById("AppointmentDiv<%=JString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                         
                                        <form style=" display: none;" id="addFavProvForm<%=JString%>" class="addFavProvForm" name="addFavProvForm" action="addFavProvController" method="POST">
                                            <input id="CustIDatAddFav<%=JString%>" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                            <input id="ProvIDatAddFav<%=JString%>" type="hidden" name="ProviderID" value="<%=ProviderID%>"/>
                                            <input id="addProvtoFavBtn<%=JString%>" style="margin: 10px; background-color: pink; border: 1px solid black; padding: 5px;" type="button" value="Add this provider to your favorite providers" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addProvtoFavBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var ProviderID = document.getElementById("ProvIDatAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustIDatAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){
                                                            
                                                         if(result === "NewAdded"){
                                                             alert("Provider added to your favorites");
                                                            $.ajax({

                                                                type: "POST",
                                                                url: "GetLastFavProv",
                                                                data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                success: function(result){
                                                                    
                                                                    var favProv = JSON.parse(result);
                                                                    
                                                                    var provName = favProv.Name;
                                                                    var provCoverPic = favProv.CoverPic;
                                                                    var provProPic = favProv.ProfilePic;
                                                                    var provRating = parseInt(favProv.Rating, 10);
                                                                    
                                                                    var UserIndex = "<%=UserIndex%>";
                                                                    var UserName = "<%=NewUserName%>";
                                                                    
                                                                    var ratingStars;
                                                                    if(provRating === 5){
                                                                        ratingStars = '★★★★★';
                                                                    }
                                                                    else if(provRating === 4){
                                                                        ratingStars = '★★★★☆';
                                                                    }
                                                                    else if(provRating === 3){
                                                                        ratingStars = '★★★☆☆';
                                                                    }
                                                                    else if(provRating === 2){
                                                                        ratingStars = '★★☆☆☆';
                                                                    }
                                                                    else{
                                                                        ratingStars = '★☆☆☆☆';
                                                                    }
                                                                    //alert(ratingStars);
                                                                    
                                                                    var provCompany = favProv.Company;
                                                                    
                                                                    var LastFavDiv = document.getElementById("LastFavDiv");
                                                                    var Divv = document.createElement('div');
                                                                    
                                                                    Divv.innerHTML = '<div id="" style="background-color: white; border-right: darkgray 1px solid; border-bottom: darkgrey 1px solid; margin-bottom: 5px; padding: 2px;">' +
                                    
                                                                                    '<div class="propic" style="background-image: url(\'data:image/jpg;base64,'+provCoverPic+'\');">' +
                                                                                    '<img class="fittedImg" style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;"><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>' +
                                                                                     provCompany +
                                                                                    '<span style="color: blue;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" />' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: pink; border: 1px solid black; padding: 5px;" type="submit" value="Find a Spot" />' +
                                                                                        '</form></center>' +
                                                                                    '</div>' +
                                                                                    '</div>' +       
                                                                                    '</div>';
                                                                            
                                                                            //alert('im here');
                                                                    
                                                                            LastFavDiv.appendChild(Divv);

                                                                            if(document.getElementById("noFavProvStatus"))
                                                                                document.getElementById("noFavProvStatus").style.display = "none";
                                                                    
                                                                }
                                                            });
                                                         }else{
                                                            alert(result);
                                                         }
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                        
                                        <div style="text-align: right;  margin-right: 39px; margin-top: 10px;">
                                           
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick="showAddFavProvFromCurrentAppointment(<%=JString%>)" src="icons/icons8-heart-20.png" width="20" height="20" alt="icons8-heart-20"/></p>
                                                <p class="tooltiptext">add provider to favorites<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick = "toggleChangeAppointment(<%=JString%>)" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></p>
                                                <p class="tooltiptext">edit date or time<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="cursor: pointer;" onclick = "toggleHideDelete(<%=JString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></p>
                                                <p class="tooltiptext">cancel<br></p>
                                            </div>
                                            
                                        </div>
                                        

                                    </div>
                                    
                                    <%  }// end of for loop  
                                    %>
                                       
                                    <!--input type="hidden" name="TotalBookedAppointments" value="<=JString%>" /-->
                                    
                                    <%
                                        if(AppointmentList.size() == 0 || appointmentItemCounter == 0){
                                    
                                    %>
                                    
                                    <center><p style="background-color: red; color: white; margin-top: 30px; margin-bottom: 30px;">You don't have any current spots</p></center>
                                    
                                    <%} //end of if block%>
                                    
                                    <!--------------------------------------------------------------------------------------------------------------------------------------------->
                                    
                                    <p style="color: tomato; margin-top: 10px; width: 100%; max-width: 500px;">Future Spots</p>
                                    
                                    <%
                                        
                                    String QString = "";
                                        
                                        for(int j = 0; j < FutureAppointmentList.size(); j++){
                                            
                                            QString = Integer.toString(j);
                                            String AppointmentTime = FutureAppointmentList.get(j).getTimeOfAppointment().substring(0,5);
                                            
                                            String TimeToUse = "";
                                            int Hours = Integer.parseInt(AppointmentTime.substring(0,2));
                                            String Minutes = AppointmentTime.substring(2,5);
                                            String Base64ProvPic = "";

                                            try{    
                                              //put this in a try catch block for incase getProfilePicture returns nothing
                                              Blob profilepic = FutureAppointmentList.get(j).getDisplayPic(); 
                                              InputStream inputStream = profilepic.getBinaryStream();
                                              ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                              byte[] buffer = new byte[4096];
                                              int bytesRead = -1;

                                              while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                  outputStream.write(buffer, 0, bytesRead);
                                              }

                                              byte[] imageBytes = outputStream.toByteArray();

                                               Base64ProvPic = Base64.getEncoder().encodeToString(imageBytes);


                                          }
                                          catch(Exception e){}
                                            
                                            if( Hours > 12)
                                            {
                                                 int TempHour = Hours - 12;
                                                 TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                                            }
                                            else if(Hours == 0){
                                                TimeToUse = "12" + Minutes + "am";
                                            }
                                            else if(Hours == 12){
                                                TimeToUse = AppointmentTime + "pm";
                                            }
                                            else{
                                                TimeToUse = AppointmentTime +"am";
                                            }
                                            
                                            int AppointmentID = FutureAppointmentList.get(j).getAppointmentID();
                                            Date AppointmentDate = FutureAppointmentList.get(j).getDateOfAppointment();
                                            
                                            SimpleDateFormat appointmentSDF = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMM dd, yyyy");
                                            String AppointmentFormattedDate = appointmentSDF.format(AppointmentDate);
                                            
                                            int ProviderID = FutureAppointmentList.get(j).getProviderID();
                                            String ProviderName = FutureAppointmentList.get(j).getProviderName();
                                            String ProviderCompany = FutureAppointmentList.get(j).getProviderCompany();
                                            String ProviderTel = FutureAppointmentList.get(j).getProviderTel();
                                            String ProviderEmail = FutureAppointmentList.get(j).getProviderEmail();
                                            String AppointmentReason = FutureAppointmentList.get(j).getReason();
                                        
                                    %>
                                    
                                    <div id="FutureAppointmentDiv<%=QString%>" style="margin-top: 5px; margin-bottom: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white; border-bottom: 1px solid darkgray; border-right: 1px solid darkgray; max-width: 700px;">
                                    
                                        <%
                                            if(Base64ProvPic != ""){
                                        %>
                                        <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                         <img class="fittedImg" style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
                                            </div></center>
                                        <%
                                            }
                                        %>
                                        
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                            
                                            <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                            <P>You will be on <span style = "color: blue;"><input style="background-color: white; border: 0; margin: 0; font-weight: bolder; color: blue;" type="submit"  value="<%= ProviderName%>'s" /></span><span> line</p>
                                            <p>on <span id="FutureDateSpan<%=QString%>" style ="color: red;"> <%= AppointmentFormattedDate%></span>, at <span id="FutureTimeSpan<%=QString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                            <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                <span style = "color: blue;"><input style="background-color: white; border: 0; margin: 0; font-weight: bolder; color: blue;" type="submit" value="<%= ProviderCompany%>" /></span></span></p>
                                        
                                        </form>
                                                
                                        <p><span> <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %> - <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %></span></p>
                                        <p style="color: darkgray; text-align: center;">- <%=AppointmentReason%> -</p>
                                        
                                        <form style=" display: none;" id="changeFutureAppointmetForm<%=QString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                            
                                            <p style="color: tomato; margin-top: 5px;">Set new time or date to change this spot</p>
                                            <input  id="datepickerFuture<%=QString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=AppointmentDate%>" />
                                            <input id="timeFldFuture<%=QString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=AppointmentTime%>" />
                                            <input id="timePickerFuture<%=QString%>"  style="background-color: white;" type="text" name="ApointmentTimePicker" value="" />
                                            <p id="timePickerStatusFuture<%=QString%>" style="margin-bottom: 3px; background-color: red; color: white; text-align: center;"></p>
                                            <p id="datePickerStatusFuture<%=QString%>" style="background-color: red; color: white; text-align: center;"></p>
                                            <input id="UpdateAppointmentID<%=QString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <input id="changeAppointmentBtnFuture<%=QString%>" style="background-color: pink; border: 1px solid black; color: black; padding: 3px;" name="<%=QString%>changeAppointment" type="button" value="Change" />
                                           
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtnFuture<%=QString%>').click(function(event) {  
                                                        
                                                        var AppointmentID = document.getElementById("UpdateAppointmentID<%=QString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFldFuture<%=QString%>").value;
                                                        var AppointmentDate = document.getElementById("datepickerFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById("changeFutureAppointmetForm<%=QString%>").style.display = "none";
                                                          
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetUpdateSpotInfo",
                                                              data: "AppointmentID="+AppointmentID,
                                                              success: function(result){
                                                                  //alert(result);
                                                                  var AppointmentData = JSON.parse(result);
                                                                  document.getElementById("FutureTimeSpan<%=QString%>").innerHTML = AppointmentData.AppointmentTime;
                                                                  document.getElementById("FutureDateSpan<%=QString%>").innerHTML = AppointmentData.AppointmentDate;
                                                              }
                                                          });
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                            
                                            <script>
                                               
                                               $('#timePickerFuture<%=QString%>').timepicker({
                                                    timeFormat: 'h:mm p',
                                                    interval: 15,
                                                    minTime: '00',
                                                    maxTime: '11:59pm',
                                                    defaultTime: '00',
                                                    startTime: '00',
                                                    dynamic: false,
                                                    dropdown: true,
                                                    scrollbar: true
                                                });
                                                
                                                function CheckTimeChooser(){
                                                    
                                                    var tempTime = document.getElementById("timePickerFuture<%=QString%>").value;
                                                    var tempDate = document.getElementById("datepickerFuture<%=QString%>").value;
                                                    
                                                    
                                                    if(tempTime.length === 7)
                                                         tempTime = "0" + tempTime;
                                                     
                                                     var tempHour = "";
                                                     var tempMinute = tempTime.substring(2,5);
                                                    
                                                    if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) !== '12'){
                                                        document.getElementById("timeFldFuture<%=QString%>").value = tempTime.substring(0,5);
                                                    }
                                                    else if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) === '12'){
                                                        document.getElementById("timeFldFuture<%=QString%>").value = "00" + tempMinute;
                                                    }
                                                    else{
                                                        
                                                        
                                                        tempHour = parseInt(tempTime.substring(0,2),10) + 12;
                                                        if(tempHour === 24)
                                                            tempHour = 12;
                                                        
                                                        
                                                        document.getElementById("timeFldFuture<%=QString%>").value = tempHour + tempMinute;
                                                       
                                                    }
                                                    
                                                    if( currentDate === tempDate ){
                                                        
                                                            if( (parseInt(document.getElementById("timeFldFuture<%=QString%>").value.substring(0,2), 10)) < (parseInt(currentHour, 10)) ){
                                                                document.getElementById("timeFldFuture<%=QString%>").value = currentTime;
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = true;
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFldFuture<%=QString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFldFuture<%=QString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFldFutureFuture<%=QString%>").value = currentTime;
                                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = true;
                                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "Time cannot be in the past";
                                                            }else{
                                                                document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "";
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = false;
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "pink";
                                                            }
                                                            
                                                    }else{
                                                        
                                                        document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "";
                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = false;
                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "pink";
                                                    }
                                                    
                                                    
                                                }
                                                
                                                setInterval(CheckTimeChooser,1);
                                               
                                            </script>
                                            
                                            
                                            <script>
                                                
                                                            $( 
                                                                    function(){
                                                                            $( "#datepickerFuture<%=QString%>" ).datepicker();
                                                                    } 
                                                             );
                                                            
                                                        //---------------------------------------------
                                                        // var datepicker = document.getElementById("datepicker<%=QString%>");
                                                         //var datePickerStatus = document.getElementById("datePickerStatus<%=QString%>");

                                                         
                                                         document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "";


                                                         function checkDateUpdateValueFuture(){

                                                                 if((new Date(document.getElementById("datepickerFuture<%=QString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepickerFuture<%=QString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "Today's Date: " + currentDate;
                                                                                                 document.getElementById("datePickerStatusFuture<%=QString%>").style.backgroundColor = "green";
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "Only today's date or future date allowed";
                                                                                         document.getElementById("datePickerStatusFuture<%=QString%>").style.backgroundColor = "red";
                                                                                         document.getElementById("datepickerFuture<%=QString%>").value = currentDate;
                                                                                 }
                                                                 }
                                                                 else{

                                                                         document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "";
                                                                         //datePickerStatus.innerHTML = "Chosen Date: " + datepicker.value;
                                                                         //datePickerStatus.style.backgroundColor = "green";
                                                                 }

                                                         }

                                                         setInterval(checkDateUpdateValueFuture, 1);                                        
                                                             
                                            </script>
                                            
                                        </form>
                                        
                                        <form style=" display: none;" id="deleteFutureAppointmentForm<%=QString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment">
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to cancel this spot</p>
                                            <p><input id="DeleteAppointmentFutureBtn<%=QString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=QString%>deleteAppointment" type="button" value="Yes" />
                                                <span onclick = "hideFutureDelete(<%=QString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="AppointmentIDFuture<%=QString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteAppointmentFutureBtn<%=QString%>').click(function(event) {  
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentIDFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById("FutureAppointmentDiv<%=QString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                         
                                        <form style=" display: none;" id="addFutureFavProvForm<%=QString%>" class="addFavProvForm" name="addFavProvForm">
                                            <input id="CustIDforAddFav<%=QString%>" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                            <input id="ProvIDforAddFav<%=QString%>" type="hidden" name="ProviderID" value="<%=ProviderID%>"/>
                                            <input id="addFavtoProvBtn<%=QString%>" style="margin: 10px; background-color: pink; border: 1px solid black; padding: 5px;" type="button" value="Add this provider to your favorite providers" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addFavtoProvBtn<%=QString%>').click(function(event) {  
                                                        
                                                        var ProviderID = document.getElementById("ProvIDforAddFav<%=QString%>").value;
                                                        var CustomerID = document.getElementById("CustIDforAddFav<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          
                                                         if(result === "NewAdded"){
                                                             alert("Provider added to your favorites");
                                                             
                                                            $.ajax({

                                                                type: "POST",
                                                                url: "GetLastFavProv",
                                                                data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                success: function(result){
                                                                    //alert(result);
                                                                    
                                                                    var favProv = JSON.parse(result);
                                                                    
                                                                    var UserIndex = "<%=UserIndex%>";
                                                                    var UserName = "<%=NewUserName%>";
                                                                    var provName = favProv.Name;
                                                                    var provCoverPic = favProv.CoverPic;
                                                                    var provProPic = favProv.ProfilePic;
                                                                    var provRating = parseInt(favProv.Rating, 10);
                                                                    //alert(provRating);
                                                                    
                                                                    var ratingStars;
                                                                    if(provRating === 5){
                                                                        ratingStars = '★★★★★';
                                                                    }
                                                                    else if(provRating === 4){
                                                                        ratingStars = '★★★★☆';
                                                                    }
                                                                    else if(provRating === 3){
                                                                        ratingStars = '★★★☆☆';
                                                                    }
                                                                    else if(provRating === 2){
                                                                        ratingStars = '★★☆☆☆';
                                                                    }
                                                                    else{
                                                                        ratingStars = '★☆☆☆☆';
                                                                    }
                                                                    //alert(ratingStars);
                                                                    
                                                                    var provCompany = favProv.Company;
                                                                    
                                                                    var LastFavDiv = document.getElementById("LastFavDiv");
                                                                    var Divv = document.createElement('div');
                                                                    
                                                                    Divv.innerHTML = '<div id="" style="background-color: white; border-right: darkgray 1px solid; border-bottom: darkgrey 1px solid; margin-bottom: 5px; padding: 2px;">' +
                                    
                                                                                    '<div class="propic" style="background-image: url(\'data:image/jpg;base64,'+provCoverPic+'\');">' +
                                                                                    '<img class="fittedImg" style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;"><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>' +
                                                                                     provCompany +
                                                                                    '<span style="color: blue;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" />' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +

                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: pink; border: 1px solid black; padding: 5px;" type="submit" value="Find a Spot" />' +
                                                                                        '</form></center>' +
                                                                                    '</div>' +
                                                                                    '</div>' +       
                                                                                    '</div>';
                                                                            
                                                                            //alert('im here');
                                                                    
                                                                            LastFavDiv.appendChild(Divv);

                                                                            if(document.getElementById("noFavProvStatus"))
                                                                                document.getElementById("noFavProvStatus").style.display = "none";
                                                                    
                                                                }
                                                            });
                                                         }else{
                                                          alert(result);
                                                         }
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                        
                                        <div style="text-align: right;  margin-right: 39px; margin-top: 10px;">
                                           
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick="showAddFavProvFromFutureAppointment(<%=QString%>)" src="icons/icons8-heart-20.png" width="20" height="20" alt="icons8-heart-20"/></p>
                                                <p class="tooltiptext">add provider to favorites<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick = "toggleChangeFutureAppointment(<%=QString%>)" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></p>
                                                <p class="tooltiptext">edit date or time<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="cursor: pointer;" onclick = "toggleFutureHideDelete(<%=QString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></p>
                                                <p class="tooltiptext">cancel<br></p>
                                            </div>
                                            
                                        </div>
                                        

                                    </div>
                                    
                                    <%  }// end of for loop  
                                    %>
                                       
                                    <!--input type="hidden" name="TotalBookedAppointments" value="<%=JString%>" /-->
                                    
                                    <%
                                        if(FutureAppointmentList.size() == 0){
                                    
                                    %>
                                    
                                    <center><p style="background-color: red; color: white; margin-top: 30px; margin-bottom: 30px;">You don't have any future spots</p></center>
                                    
                                    <%} //end of if block%>
                                   
                                    
                                </div> 
                                        
                                <div id="serviceslist" class="AppHistoryDiv" style="border-top: 0;">
                                    
                                    <p style="color: tomato; margin: 10px;">Your Past Spots</p>
                                    
                                    <% 
                                        
                                        for(int j = 0; j < AppointmentHistory.size(); j++){
                                            
                                            JString = Integer.toString(j);
                                            String AppointmentTime = AppointmentHistory.get(j).getTimeOfAppointment().substring(0,5);
                                            
                                            String TimeToUse = "";
                                            int Hours = Integer.parseInt(AppointmentTime.substring(0,2));
                                            String Minutes = AppointmentTime.substring(2,5);
                                            String Base64ProvPic = "";

                                            try{    
                                              //put this in a try catch block for incase getProfilePicture returns nothing
                                              Blob profilepic = AppointmentHistory.get(j).getDisplayPic(); 
                                              InputStream inputStream = profilepic.getBinaryStream();
                                              ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                              byte[] buffer = new byte[4096];
                                              int bytesRead = -1;

                                              while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                  outputStream.write(buffer, 0, bytesRead);
                                              }

                                              byte[] imageBytes = outputStream.toByteArray();

                                               Base64ProvPic = Base64.getEncoder().encodeToString(imageBytes);


                                          }
                                          catch(Exception e){}
                                            
                                            if( Hours > 12)
                                            {
                                                 int TempHour = Hours - 12;
                                                 TimeToUse = Integer.toString(TempHour) + Minutes + " pm";
                                            }
                                            else if(Hours == 0){
                                                TimeToUse = "12" + Minutes + " am";
                                            }
                                            else if(Hours == 12){
                                                TimeToUse = AppointmentTime + " pm";
                                            }
                                            else{
                                                TimeToUse = AppointmentTime +" am";
                                            }
                                            
                                            int AppointmentID = AppointmentHistory.get(j).getAppointmentID();
                                            Date AppointmentDate = AppointmentHistory.get(j).getDateOfAppointment();
                                            
                                            SimpleDateFormat appointmentSDF = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMM dd, yyyy");
                                            String AppointmentFormattedDate = appointmentSDF.format(AppointmentDate);
                                            
                                            int ProviderID = AppointmentHistory.get(j).getProviderID();
                                            String ProviderName = AppointmentHistory.get(j).getProviderName();
                                            String ProviderCompany = AppointmentHistory.get(j).getProviderCompany();
                                            String ProviderTel = AppointmentHistory.get(j).getProviderTel();
                                            String ProviderEmail = AppointmentHistory.get(j).getProviderEmail();
                                            String AppointmentReason = AppointmentHistory.get(j).getReason();
                                        
                                    %>
                                    
                                    <div id="HistoryAppointmentDiv<%=JString%>" style="margin-top: 5px; margin-bottom: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white; border-bottom: 1px solid darkgray; border-right: 1px solid darkgray; max-width: 700px;">
                                    
                                        <%
                                            if(Base64ProvPic != ""){
                                        %>
                                        <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                         <img class="fittedImg" style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
                                            </div></center>
                                        <%
                                            }
                                        %>
                                        
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                            <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                        <P>You were on<span style = "color: blue;"> <input style="background: 0; border: 0; color: blue; font-weight: bolder; margin: 0;" type="submit" value="<%=ProviderName%>'s"</span><span> line.</p>
                                        <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                            <span style = "color: blue;"> <input style="background: 0; border: 0; color: blue; font-weight: bolder; margin: 0;" type="submit" value="<%=ProviderCompany%>"</span></span></p>
                                        <p><span> <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %> - <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %></span></p>
                                        <p>on <span style ="color: red;"> <%= AppointmentFormattedDate%></span>, at <span style = "color: red;"> <%= TimeToUse%></span></P>
                                        <p style="color: darkgray; text-align: center;">- <%=AppointmentReason%> -</p>
                                        <a href="ViewSelectedProviderReviews.jsp?Provider=<%=ProviderID%>"><p id="ProviderReview<%=JString%>" style="color: green; text-align: center;"></p></a>
                                        
                                        </form>
                                        
                                        <form style=" display: none;" id="deleteAppointmentHistoryForm<%=JString%>" class="deleteAppointmentHistoryForm" name="confirmDeleteAppointmentHistory">
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to delete this history</p>
                                            <p><input id="DeleteAppointmentHistoryBtn<%=JString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=JString%>deleteAppointmentHistory" type="button" value="Yes" />
                                                <span onclick = "hideDeleteHistory(<%=JString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="AppointmentIDHistory<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteAppointmentHistoryBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentIDHistory<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("This is history has been removed");
                                                          document.getElementById("HistoryAppointmentDiv<%=JString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                        <form style=" display: none; border-top: 1px solid darkgrey; margin-top: 10px;" id="ratingAndReviewForm<%=JString%>" class="ratingAndReviewaForm" style="margin-top: 10px; border-top: 1px solid darkgray;" name ="ratingAndReview">
                                            <p style="margin-top: 5px; color: tomato;">Add your ratings and reviews for this provider below</p>
                                            
                                            <input id="CustomerIDforRev<%=JString%>" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                            <input id="ProviderIDforRev<%=JString%>" type="hidden" name="ProviderID" value="<%=ProviderID%>"/>
                                            
                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td  style="padding: 0; padding-left: 0;">
                                                        <!----------------------------------------------------->
                                                        
                                                            <div class="rate" style="">
                                                                <input type="radio" id="star5<%=JString%>" class="star5" name="rate" value="5" />
                                                                <label  for="star1" title="text">★</label>
                                                                <input type="radio" id="star4<%=JString%>" class="star4" name="rate" value="4" />
                                                                <label for="star2" title="text">★</label>
                                                                 <input type="radio" id="star3<%=JString%>" class="star3" name="rate" value="3" />
                                                                <label for="star3" title="text">★</label>
                                                                <input type="radio" id="star2<%=JString%>" class="star2" name="rate" value="2" />
                                                                <label for="star4" title="text">★</label>
                                                                <input type="radio" id="star1<%=JString%>" class="star1" name="rate" value="1" />
                                                                <label for="star5" title="text">★</label>
                                                                
                                                            </div>
                                                        
                                                        </td><td></td>
                                                       
                                                        <!-------------------------------------------------------->
                                                        
                                                    </tr>
                                                    <tr>
                                                        <td  style="padding-top: 0;">
                                                            <textarea id="ReviewTxtFld<%=JString%>" name="Review" rows="0" cols="0" style="width: 250px; height: 50px;" onfocus="if(this.innerHTML==='Compose review message...')this.innerHTML = ''; ">
                                                            </textarea>
                                                        </td>
                                                        <td><input id="submitReviewBtn<%=JString%>" style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;"
                                                                           type="button" value="Send" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                                                           
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#submitReviewBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var RateValue = 1;
                                                        
                                                        if(document.getElementById("star5<%=JString%>").checked === true){
                                                            RateValue = 5;
                                                        }else if(document.getElementById("star4<%=JString%>").checked === true){
                                                            RateValue = 4;
                                                        }else if(document.getElementById("star3<%=JString%>").checked === true){
                                                            RateValue = 3;
                                                        }else if(document.getElementById("star2<%=JString%>").checked === true){
                                                            RateValue = 2;
                                                        }else{
                                                            RateValue = 1;
                                                        }
                                                        
                                                        var ReviewMessage = document.getElementById("ReviewTxtFld<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustomerIDforRev<%=JString%>").value;
                                                        var ProviderID = document.getElementById("ProviderIDforRev<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "SendCustomerReviewController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID+"&rate="+RateValue+"&Review="+ReviewMessage,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById("ProviderReview<%=JString%>").innerHTML = "Review sent. Click here to See more...";
                                                          document.getElementById("ratingAndReviewForm<%=JString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                            
                                        </form>
                                            
                                        <script type="text/javascript">
                                                 
                                                 document.getElementById("ReviewTxtFld<%=JString%>").innerHTML = "Compose review message...";
                                                 
                                                 /*setInterval( function(){
                                                     
                                                        if(document.getElementById("ReviewTxtFld<=JString%>") !== document.activeElement){
                                                            
                                                            if(document.getElementById("ReviewTxtFld<=JString%>").innerHTML === "")
                                                                document.getElementById("ReviewTxtFld<=JString%>").innerHTML = "Compose review message...";
                                                            
                                                        }
                                                        
                                                }, 1);*/
                                                 
                                                 setInterval(function(){
                                                   
                                                    if((document.getElementById("star1<%=JString%>").checked === false && document.getElementById("star2<%=JString%>").checked === false 
                                                            && document.getElementById("star3<%=JString%>").checked === false
                                                            && document.getElementById("star4<%=JString%>").checked === false && document.getElementById("star5<%=JString%>").checked === false)
                                                            || document.getElementById("ReviewTxtFld<%=JString%>").innerHTML === "Compose review message..."){
                                                                
                                                                document.getElementById("submitReviewBtn<%=JString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("submitReviewBtn<%=JString%>").disabled = true;
                                                                
                                                    }else{
                                                        
                                                        document.getElementById("submitReviewBtn<%=JString%>").style.backgroundColor = "pink";
                                                        document.getElementById("submitReviewBtn<%=JString%>").disabled = false;
                                                        
                                                    }
                                                } , 1);
                                                    
                                                    
                                            </script>
                                        
                                        <form style=" display: none;" id="addFavProvFormFromRecent<%=JString%>" class="addFavProvForm" name="addFavProvForm">
                                            <input id="CustomerIDforAddFav<%=JString%>" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                            <input id="ProviderIDforAddFav<%=JString%>" type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                            <input id="addFavProvBtn<%=JString%>" style="margin: 10px; background-color: pink; border: 1px solid black; padding: 5px;" type="button" value="Add this provider to your favorite providers" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addFavProvBtn<%=JString%>').click(function(event) {  
                                                        
                                                        var ProviderID = document.getElementById("ProviderIDforAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustomerIDforAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          
                                                          if(result === "NewAdded"){
                                                              alert("Provider added to your favorites");
                                                            $.ajax({

                                                                type: "POST",
                                                                url: "GetLastFavProv",
                                                                data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                success: function(result){
                                                                    //alert(result);
                                                                    
                                                                    var favProv = JSON.parse(result);
                                                                    
                                                                    var UserName = "<%=NewUserName%>";
                                                                    var UserIndex = "<%=UserIndex%>";
                                                                    var provName = favProv.Name;
                                                                    var provCoverPic = favProv.CoverPic;
                                                                    var provProPic = favProv.ProfilePic;
                                                                    var provRating = parseInt(favProv.Rating, 10);
                                                                    //alert(provRating);
                                                                    
                                                                    var ratingStars;
                                                                    if(provRating === 5){
                                                                        ratingStars = '★★★★★';
                                                                    }
                                                                    else if(provRating === 4){
                                                                        ratingStars = '★★★★☆';
                                                                    }
                                                                    else if(provRating === 3){
                                                                        ratingStars = '★★★☆☆';
                                                                    }
                                                                    else if(provRating === 2){
                                                                        ratingStars = '★★☆☆☆';
                                                                    }
                                                                    else{
                                                                        ratingStars = '★☆☆☆☆';
                                                                    }
                                                                    //alert(ratingStars);
                                                                    
                                                                    var provCompany = favProv.Company;
                                                                    
                                                                    var LastFavDiv = document.getElementById("LastFavDiv");
                                                                    var Divv = document.createElement('div');
                                                                    
                                                                    Divv.innerHTML = '<div id="" style="background-color: white; border-right: darkgray 1px solid; border-bottom: darkgrey 1px solid; margin-bottom: 5px; padding: 2px;">' +
                                    
                                                                                    '<div class="propic" style="background-image: url(\'data:image/jpg;base64,'+provCoverPic+'\');">' +
                                                                                    '<img class="fittedImg" style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;"><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>' +
                                                                                     provCompany +
                                                                                    '<span style="color: blue;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" />' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +

                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: pink; border: 1px solid black; padding: 5px;" type="submit" value="Find a Spot" />' +
                                                                                        '</form></center>' +
                                                                                    '</div>' +
                                                                                    '</div>' +       
                                                                                    '</div>';
                                                                            
                                                                            //alert('im here');
                                                                    
                                                                    LastFavDiv.appendChild(Divv);
                                                                    
                                                                    if(document.getElementById("noFavProvStatus"))
                                                                        document.getElementById("noFavProvStatus").style.display = "none";
                                                                    
                                                                }
                                                            });
                                                          }else{
                                                            alert(result);
                                                          }
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        </form>
                                        
                                        <div style="text-align: right;  margin-right: 39px; margin-top: 10px;">
                                            
                                            <div class="tooltip">
                                            <a><img style="margin-right: 10px; cursor: pointer;" onclick="showAddFavProv(<%=JString%>)" src="icons/icons8-heart-20.png" width="20" height="20" alt="icons8-heart-20"/></a>
                                            <p class="tooltiptext">add provider to favorites<br></p>
                                            </div>
                                            
                                            <div class="tooltip" style="margin-right: 10px;">
                                            <a style="cursor: pointer;" ><img onclick="toggleShowReviewsForm(<%=JString%>)" src="icons/icons8-popular-20.png" width="20" height="20" alt="icons8-popular-20"/></a>
                                            <p class="tooltiptext">add your review<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                            <a><img style=" cursor: pointer;" onclick = "toggleHideDeleteHistory(<%=JString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></a>
                                            <p class="tooltiptext">delete this history<br></p>
                                            </div>
                                            
                                        </div>
                                        
                                    </div>
                                    
                                    <%  }// end of for loop   
                                        
                                        if(AppointmentHistory.size() == 0){
                                    
                                    %>
                                    
                                    <center><p style="background-color: red; color: white; margin-top: 30px; margin-bottom: 30px;">Your history is empty</p></center>
                                    
                                    <%} //end of if block%>     
                                    
                                </div>
                                    
                            <%
                                
                                ArrayList<ProviderInfo> favProvidersList = new ArrayList<>();
                                int FavProvID;
                                
                                try{
                                    
                                    Class.forName(Driver);
                                    Connection favConn = DriverManager.getConnection(Url, user, password);
                                    String favString = "Select top 5 * from ProviderCustomers.FavoriteProviders where CustomerId =? order by FavoritesId desc";
                                    
                                    PreparedStatement favPst = favConn.prepareStatement(favString);
                                    favPst.setInt(1,UserID);
                                    
                                    ResultSet favRow = favPst.executeQuery();
                                    
                                    ProviderInfo eachFavProv = new ProviderInfo();
                                    
                                    while(favRow.next()){
                                        
                                        FavProvID = favRow.getInt("ProviderId");
                                        
                                        try{
                                            
                                         Class.forName(Driver);
                                         Connection eachFavConn = DriverManager.getConnection(Url, user, password);
                                         String eachFavString = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID =?";
                                         
                                         PreparedStatement eachFavPst = eachFavConn.prepareStatement(eachFavString);
                                         eachFavPst.setInt(1, FavProvID);
                                         
                                         ResultSet eachFavProvRow = eachFavPst.executeQuery();
                                         
                                        while(eachFavProvRow.next()){
                                         
                                            eachFavProv = new ProviderInfo(eachFavProvRow.getInt("Provider_ID"), eachFavProvRow.getString("First_Name"), eachFavProvRow.getString("Middle_Name"), eachFavProvRow.getString("Last_Name"), 
                                                    eachFavProvRow.getDate("Date_Of_Birth"), eachFavProvRow.getString("Phone_Number"), eachFavProvRow.getString("Company"), eachFavProvRow.getInt("Ratings"), eachFavProvRow.getString("Service_Type"),eachFavProvRow.getString("First_Name") + "-" + eachFavProvRow.getString("Company"),eachFavProvRow.getBlob("Profile_Pic"), eachFavProvRow.getString("Email"));
                                            
                                            favProvidersList.add(eachFavProv);
                                        }
                                        
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                    }
                                }
                                catch(Exception e){
                                    e.printStackTrace();
                                }
                                
                            %>
                    
                                <div style="display: none;" id="serviceslist" style="margin-top: 0; border-top: 0;" class="FavDiv">
                              
                                     <p style="color: tomato; margin: 10px;">Your Favorite Providers</p>
                                      
                                <%
                                    
                                    if(favProvidersList.size() == 0){
                                        
                                 
                                %>
                                     
                                     <p id="noFavProvStatus" style ="background-color: red; color: white; margin-top: 30px; margin-bottom: 30px;">You don't have any favorite providers</p>
                                
                                <%}
                                    
                                    else{ 

                                        for(int s = 0; s < favProvidersList.size(); s++){
                                        
                                        
                                        String SString = Integer.toString(s);
                                        
                                        FavProvID = favProvidersList.get(s).getID();
                                        String FavProvFullName = favProvidersList.get(s).getFirstName() +
                                                     " " + favProvidersList.get(s).getMiddleName() + " " + favProvidersList.get(s).getLastName();  
                                                     
                                        String FavProvTel = favProvidersList.get(s).getPhoneNumber();
                                        String FavProvEmail = favProvidersList.get(s).getEmail();
                                        String FavProvCompany = favProvidersList.get(s).getCompany();
                                        String favProvAddress = "";
                                        int FavRatings = favProvidersList.get(s).getRatings();


                                        try{

                                            Class.forName(Driver);
                                            Connection favAddressConn = DriverManager.getConnection(Url, user, password);
                                            String favAddressString = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                                            
                                            PreparedStatement favAddressPst = favAddressConn.prepareStatement(favAddressString);
                                            favAddressPst.setInt(1, FavProvID );
                                            
                                            ResultSet favAddressRow = favAddressPst.executeQuery();
                                            
                                            while(favAddressRow.next()){
                                                
                                                favProvidersList.get(s).setAddress(favAddressRow.getInt("House_Number"), favAddressRow.getString("Street_Name").trim(),
                                                                        favAddressRow.getString("Town").trim(), favAddressRow.getString("City").trim(), favAddressRow.getString("Country").trim(), favAddressRow.getInt("Zipcode"));

                                                favProvAddress = favProvidersList.get(s).Address.getHouseNumber() + " " + favProvidersList.get(s).Address.getStreet() +
                                                        ", " + favProvidersList.get(s).Address.getTown() + ", " + favProvidersList.get(s).Address.getCity() + ", " + favProvidersList.get(s).Address.getCountry() + " " + favProvidersList.get(s).Address.getZipcode();
                                                
                                            }
                                            
                                        }
                                        catch(Exception e){
                                            e.printStackTrace();
                                        }

                                        String base64Image = "";

                            try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = favProvidersList.get(s).getProfilePicture(); 
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
                                        
                                %>
                                
                                                
                            
                    <%
                        
                        //getting coverdata
                        String base64Cover = "";
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(Url, user, password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,FavProvID);
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
                    
                                
                                <div id="FavoriteProvDiv<%=SString%>" class="EacFavsDiv" style="background-color: white; border-right: darkgray 1px solid; border-bottom: darkgrey 1px solid; margin-bottom: 5px; padding: 2px;">
                                    
                                    <div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                            <img style="border: 5px solid white;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                                    </div>
                                    
                                    <div style="padding-top: 75px;">
                                    <b><p style="font-size: 20px; margin-top: 15px;"><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                          <%=FavProvFullName%></p></b>
                                    <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>

                                        <%=FavProvCompany%> <span style="color: blue;">
                                            
                                        <%
                                            if(FavRatings ==5){
                                        
                                        %> 
                                        ★★★★★
                                        <%
                                             }else if(FavRatings == 4){
                                        %>
                                        ★★★★☆
                                        <%
                                             }else if(FavRatings == 3){
                                        %>
                                        ★★★☆☆
                                        <%
                                             }else if(FavRatings == 2){
                                        %>
                                        ★★☆☆☆
                                        <%
                                             }else if(FavRatings == 1){
                                        %>
                                        ★☆☆☆☆
                                        <%}%>
                                        
                                        </span></p>
                                    
                                    
                                    <div style="width: 70%;">
                                        
                                        <form style=" display: none;" id="deleteFavProviderForm<%=SString%>" class="deleteFavProvider" name="deleteFavProvider">
                                            
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to remove this Provider from your favorites</p>
                                            <p><input id="DeleteFavProvBtn<%=SString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=s%>deleteFavProv" type="button" value="Yes" />
                                                <span onclick = "hideDeleteFavProv(<%=SString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="ProvID<%=SString%>" type="hidden" name="UserID" value="<%=FavProvID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteFavProvBtn<%=SString%>').click(function(event) {  
                                                        
                                                        var ProvID = document.getElementById("ProvID<%=SString%>").value;
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "RemoveFavProvController",  
                                                            data: "UserID="+ProvID,  
                                                            success: function(result){  
                                                              alert(result);
                                                              document.getElementById("FavoriteProvDiv<%=SString%>").style.display = "none";
                                                            }                
                                                        });
                                                        
                                                    });
                                                });
                                            </script>
                                            
                                        </form>
                                        
                                            <div class="tooltip" style="max-width: 2px; float: right; padding-top: 15px;">
                                                <p style="text-align: right; width: 5px; cursor: pointer;"><img onclick = "showDeleteFavProv(<%=SString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></p>
                                                <p class="tooltiptext" style="width: 50px;">delete this favorite</p>
                                            </div>
                                                
                                    <center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                        <input type="hidden" name="UserID" value="<%=FavProvID%>" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <input style=" background-color: pink; border: 1px solid black; padding: 5px;" type="submit" value="Find a Spot" />
                                        </form></center>
                                        
                                        
                                    </div>
                                            
                                    </div>    
                                        
                                        <a href="AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                                            <p style="border: 1px solid darkblue; color: darkblue; text-align: center; padding: 5px; max-width: 300px;">View all your favorite providers</p></a>
                                </div>
                                
                                <%      }
                                    }
                                %>
                                
                                
                                <div style="display: none;" id="LastFavDiv">
                                    
                                </div>
                                
                                </div>
                               </div>
                                 </center>
                            </td> 
                        </tr>
                    </tbody>
                    </table>
                                     
               </div>      
              
    </body>
    <script>
        var ControllerResult = "<%=ControllerResult%>";
        
        if(ControllerResult !== "null")
            alert(ControllerResult);
    </script>
    
    <script src="scripts/script.js"></script>
    <!--script src="scripts/checkAppointmentDateUpdate.js"></script-->
    <script src="scripts/updateUserProfile.js"></script>
    <script src="scripts/customerReviewsAndRatings.js"></script>
    <script src="scripts/SettingsDivBehaviour.js"></script>
    <script src="scripts/ChangeProfileInformationFormDiv.js"></script>
</html>
