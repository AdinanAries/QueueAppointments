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
        <link rel="manifest" href="/manifest.json" />
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <!--script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script-->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css"-->
        
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
        
        //initializing Address and its Fields
        String thisUserAddress = "no address information";
        int H_Number = 0;
        String Street = "street";
        String Town = "town";
        String City = "city";
        String Country = "country";
        int ZipCode = 0;
        String Base64Pic = "";
        
        String AppointmentDateValue = "";
        
        ProviderCustomerData eachCustomer = null;
        
        //ArrayList to store all appointments list (made global for global access)
        ArrayList<BookedAppointmentList> AppointmentList = new ArrayList<>();
        ArrayList<BookedAppointmentList> AppointmentHistory = new ArrayList<>();
        ArrayList<BookedAppointmentList> FutureAppointmentList = new ArrayList<>();
        ArrayList<BookedAppointmentList> AppointmentListExtra = new ArrayList<>();
        
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
                                                        
                                                    
        
        //Getting AddressData
        try{
            
            Class.forName(Driver);
            Connection addressConn = DriverManager.getConnection(Url, user, password);
            String addressString = "Select * from QueueObjects.CustomerAddress where Customer_ID = ?";
            
            PreparedStatement addressPst = addressConn.prepareStatement(addressString);
            addressPst.setInt(1, UserID);
            
            ResultSet addressRecord = addressPst.executeQuery();
            
            while(addressRecord.next()){
                
                thisUserAddress = eachCustomer.getAddress(
                        addressRecord.getInt("House_Number"), addressRecord.getString("Street_Name"), addressRecord.getString("Town"),
                        addressRecord.getString("City"), addressRecord.getString("Country"), addressRecord.getInt("Zipcode"));
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
    //------------------------------------------------------------------------------------------------------------------------------------------    
        //Getting Notifications data
        ArrayList<String> Notifications = new ArrayList<>();
        String NotiIDs = "{\"Data\" : [ ";
        
        try{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Class.forName(Driver);
            Connection NotiConn = DriverManager.getConnection(Url, user, password);
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
        
        String FirstName = "";
            String MiddleName = "";
            String LastName = "";
            String FullName = "";
            String PhoneNumber = "";
            String Email = "";
        
        try{
            FirstName = eachCustomer.getFirstName();
            MiddleName = eachCustomer.getMiddleName();
            LastName = eachCustomer.getLastName();
            FullName = eachCustomer.getFirstName() + " " + eachCustomer.getMiddleName() + " " + eachCustomer.getLastName();
            PhoneNumber = eachCustomer.getPhoneNumber();
            Email = eachCustomer.getEmail();
        }catch(Exception e){}
        
        try{
            
            H_Number = eachCustomer.CustomerAddress.getHouseNumber();
            Street = eachCustomer.CustomerAddress.getStreet().trim();
            Town = eachCustomer.CustomerAddress.getTown().trim();
            City = eachCustomer.CustomerAddress.getCity().trim();
            Country = eachCustomer.CustomerAddress.getCountry().trim();
            ZipCode = eachCustomer.CustomerAddress.getZipcode();
        
        }catch(Exception e){}
        
        try{    
            //put this in a try catch block for incase getProfilePicture returns nothing
            Blob profilepic = eachCustomer.getProfilePic(); 
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
        
        //Getting Appointments for Extra Div
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StringCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
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
                AppointmentListExtra.add(eachAppointmentItem);
                
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
    
    <body>
              
        <div id="PagePageLoader" class="QueueLoader" style='display: none;'>
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="container">
              
        <div id="newbusiness" style="padding-top: 0; border-bottom: 0;">
                
            <center><h4 id="YourAccountH4" style="margin-top: 1px; margin-bottom: 5px; color: #000099">Your Account</h4></center>
            
                <div id="Customerprofile" style="padding-top: 0;">
                    
                <!--<h2 style="color: black;">Your User Profile</h2> -->
                
                <table id="CustomerprofileTable" style="border-spacing: 0; width: 100%; max-width: 700px;">
                    
                    <tbody>
                        <tr>
                            <td>
                            <center>
                                
                               <!-- <div class="propic">
                                    <img src="" width="100" height="100"/>
                                </div> -->
                                    
                               <center><p id="ShowProInfo" onclick="toggleProInfoDivDisplay()" style="cursor: pointer; color: black; background-color: #3d6999; border: 1px solid black; color: white; padding: 5px; margin-bottom: 5px;">
                                       <img style='background-color: white;' src="icons/icons8-user-15.png" width="20" height="20" alt="icons8-user-15"/>
                                       Show Your Profile Details</p></center>
                               
                               <div id="ProInfoDiv" class="proinfo" style="border-top: 0; text-align: left; padding-bottom: 10px; margin-top: 0; background-color: cornflowerblue;">
                                
                                <%
                                    if(Base64Pic != ""){
                                %> 
                                
                                    <center><div id="WideScreenProfilePic" style="background-image: url('data:image/jpg;base64,<%=Base64Pic%>'); background-size: cover; padding: 5px; margin-left: 5px; margin-right: 5px; margin-bottom: 5px;">
                                        <div style="height: 5px; background-size: cover; margin-left: 5px; margin-right: 5px; margin-bottom: 150px; background-color: #334d81;" >
                                            <center><img class="fittedImg" style="margin-top: 0; border-radius: 100%; border: 5px solid #334d81; margin-bottom: 0; background-color: darkgrey; " src="data:image/jpg;base64,<%=Base64Pic%>" width="150" height="150"/></center>
                                        </div>
                                        <div style="background-color: #334d81; height: 5px; margin-left: 5px; margin-right: 5px;">
                                        </div>
                                    </div></center>
                                    
                                    <div id="SmallscreenProfilePic">
                                        <center><div class ="SearchObject">
                                            <form name="searchForm" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="Search" name="SearchBtn" />
                                            </form> 
                                        </div></center>
                                        <div style="background-image: url('data:image/jpg;base64,<%=Base64Pic%>'); background-size: cover; height: 100px; margin-bottom: 60px; border-bottom: #3d6999 1px solid">
                                            <div id="" style="height: 100px; background-color: #6699ff; opacity: 0.7;"></div>        
                                            <img class="fittedImg" style="position: relative; z-index: 2; margin-top: -50px; margin-left: 6px; border-radius: 100%; border: #3d6999 1px solid; margin-bottom: 0; background-color: darkgrey; " src="data:image/jpg;base64,<%=Base64Pic%>" width="100" height="100"/>
                                            
                                        </div>
                                    </div>
                                
                                <%
                                    } else{
                                %>
                                
                                   <center><a onclick="document.getElementById('PagePageLoader').style.display = 'block';" href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="cursor: pointer; border-radius: 4px; background-color: pink; color: black; padding: 5px; border: solid black 1px; width: 200px; text-align: center; margin-bottom: 5px;">Add Profile Picture<p></a></center>
                                    
                                <%
                                    }
                                %>
                                
                                <center><p style='font-weight: bolder;'><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                        <span id="FullNameDetail"><%=FullName%></span></p></center>
                                
                                <center><table style="border-spacing: 1px; width: 100%; text-align: center;" border="0">
                                            <tr><td style="padding-bottom: 2px;"></td></tr>
                                            <tr><td style="padding-bottom: 2px;"><p><img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                                        <span id="PhoneNumberDetail"><%=PhoneNumber%></span>, 
                                                        <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/> <span id="EmailDetail"><%=Email%></span></p></td></tr>
                                            <tr><td style="padding-bottom: 2px;"><p><img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                                        <span id="AddressDetail"><%=thisUserAddress%></span></p></td></tr>
                                        </table></center>
                                        
                                        <%
                                            
                                            if(thisUserAddress == "no address information"){
                                                
                                        %>
                                        
                                        <form id="SetUserAddress" style="border-top: 1px solid darkblue; margin-top: 5px;
                                              padding-top: 5px;" action="SetUserAddress" method="POST">
                                            
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td style="padding-top: 10px; color: #ffffff;">
                                                        <P>Add Your Address</P>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>House Number: </td><td><input id="NewAddressHNumber" placeholder="1234" style="background-color: cornflowerblue;" type="text" name="houseNumberFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Street: </td><td><input id="NewAddressStreet" placeholder="Some St./Ave." style="background-color: cornflowerblue;" type="text" name="streetAddressFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Town: </td><td><input id="NewAddressTown" placeholder="Some Town" style="background-color: cornflowerblue;" type="text" name="townFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>City: </td><td><input id="NewAddressCity" placeholder="Some City " style="background-color: cornflowerblue;" type="text" name="cityFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Country: </td><td><input id="NewAddressCountry" placeholder="Some Country" style="background-color: cornflowerblue;" type="text" name="countryFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Zip Code: </td><td><input id="NewAddressZipcode" placeholder="1234" style="background-color: cornflowerblue;" type="text" name="zipCodeFld" value="" /></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                            
                                                <p id="NewAddressStatus" style="text-align: center; color: white;"></p>
                                                <input type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                <center><input id="NewAddressBtn" style="margin-top: 10px; border: 1px solid black; padding: 10px; background-color: pink; border-radius: 4px;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="Set Address" /></center>
                                            
                                        </form>
                                                
                                        <%
                                            }
                                            else{
                                                          
                                        %>
                                                    
                                        
                                        <form id="UpdateUserAccountForm" style="border-top: 1px solid darkblue; margin-top: 5px; display: none;
                                              padding-top: 5px;" >
                                            <center><p style="color: white; margin: 5px;">Change profile information</p></center>
                                            
                                            <center><a onclick="document.getElementById('PagePageLoader').style.display = 'block';" href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="cursor: pointer; background-color: pink; color: black; padding: 5px; border: 1px solid black; border-radius: 5px; text-align: center; width: 300px;">Change Your Profile Photo</p></a></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td>First Name: </td><td><input id="ChangeProfileFirstName" style="background-color: cornflowerblue;" type="text" name="firstNameFld" value="<%=FirstName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Middle Name: </td><td><input id="ChangeProfileMiddleName" style="background-color: cornflowerblue;" type="text" name="middleNameFld" value="<%=MiddleName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Last Name: </td><td><input id="ChangeProfileLastName" style="background-color: cornflowerblue;" type="text" name="lastNameFld" value="<%=LastName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Phone Number: </td><td><input onclick="checkMiddlePhoneNumberEdit();" onkeydown="checkMiddlePhoneNumberEdit();" id="ChangeProfilePhoneNumber" style="background-color: cornflowerblue;" type="text" name="phoneNumberFld" value="<%=PhoneNumber%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Email: </td><td><input id="ChangeProfileEmail" style="background-color: cornflowerblue;" type="text" name="emailFld" value="<%=Email%>" /></td>
                                                </tr>
                                                
                                                <script>
                                                        var ChangeProfilePhoneNumber = document.getElementById("ChangeProfilePhoneNumber");

                                                        function numberFuncPhoneNumberEdit(){

                                                            var number = parseInt((ChangeProfilePhoneNumber.value.substring(ChangeProfilePhoneNumber.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                ChangeProfilePhoneNumber.value = ChangeProfilePhoneNumber.value.substring(0, (ChangeProfilePhoneNumber.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncPhoneNumberEdit, 1);

                                                        function checkMiddlePhoneNumberEdit(){

                                                            for(var i = 0; i < ChangeProfilePhoneNumber.value.length; i++){

                                                                var middleString = ChangeProfilePhoneNumber.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    ChangeProfilePhoneNumber.value = ChangeProfilePhoneNumber.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                
                                                <tr>
                                                    <td style="padding-top: 10px; color: #ffffff;">
                                                        <P>Address Info Below</P>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>House Number: </td><td><input onclick="checkMiddleHouseNumberEdit();" onkeydown="checkMiddleHouseNumberEdit();" id="ChangeProfileHouseNumber" style="background-color: cornflowerblue;" type="text" name="houseNumberFld" value="<%=H_Number%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Street: </td><td><input id="ChangeProfileStreet" style="background-color: cornflowerblue;" type="text" name="streetAddressFld" value="<%=Street%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Town: </td><td><input id="ChangeProfileTown" style="background-color: cornflowerblue;" type="text" name="townFld" value="<%=Town%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>City: </td><td><input id="ChangeProfileCity" style="background-color: cornflowerblue;" type="text" name="cityFld" value="<%=City%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Country: </td><td><input id="ChangeProfileCountry" style="background-color: cornflowerblue;" type="text" name="countryFld" value="<%=Country%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Zip Code: </td><td><input onclick="checkMiddleZipCodeEdit();" onkeydown="checkMiddleZipCodeEdit();" id="ChangeProfileZipCode" style="background-color: cornflowerblue;" type="text" name="zipCodeFld" value="<%=ZipCode%>" /></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                            
                                                <script>
                                                        var ChangeProfileHouseNumber = document.getElementById("ChangeProfileHouseNumber");

                                                        function numberFuncHouseNuberEdit(){

                                                            var number = parseInt((ChangeProfileHouseNumber.value.substring(ChangeProfileHouseNumber.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                ChangeProfileHouseNumber.value = ChangeProfileHouseNumber.value.substring(0, (ChangeProfileHouseNumber.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncHouseNuberEdit, 1);

                                                        function checkMiddleHouseNumberEdit(){

                                                            for(var i = 0; i < ChangeProfileHouseNumber.value.length; i++){

                                                                var middleString = ChangeProfileHouseNumber.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    ChangeProfileHouseNumber.value = ChangeProfileHouseNumber.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                
                                                <script>
                                                        var ChangeProfileZipCode = document.getElementById("ChangeProfileZipCode");

                                                        function numberFuncZipCodeEdit(){

                                                            var number = parseInt((ChangeProfileZipCode.value.substring(ChangeProfileZipCode.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                ChangeProfileZipCode.value = ChangeProfileZipCode.value.substring(0, (ChangeProfileZipCode.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncZipCodeEdit, 1);

                                                        function checkMiddleZipCodeEdit(){

                                                            for(var i = 0; i < ChangeProfileZipCode.value.length; i++){

                                                                var middleString = ChangeProfileZipCode.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    ChangeProfileZipCode.value = ChangeProfileZipCode.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                            
                                                <input id="CustomerIDforUpdateInfo" type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <input id="UserIndexforUpdateInfo" type='hidden' name='UserIndex' value='<%=UserIndex%>'/>
                                                <center><p id="userProfileFormStatus" style="color: white; text-align: center;"></p></center>
                                                <center><input id="ChangeProfileUpdateBtn" style="margin-top: 10px; border: 1px solid black; padding: 10px; background-color: pink; border-radius: 4px;" type="button" value="Update" /></center>
                                            
                                                <script>
                                                    $(document).ready(function(){
                                                        $("#ChangeProfileUpdateBtn").click(function(event){
                                                            document.getElementById('PagePageLoader').style.display = 'block';
                                                            var CustomerID = document.getElementById("CustomerIDforUpdateInfo").value;
                                                            var UserIndex = document.getElementById("UserIndexforUpdateInfo").value;
                                                            var FirstName = document.getElementById("ChangeProfileFirstName").value;
                                                            var MiddleName = document.getElementById("ChangeProfileMiddleName").value;
                                                            var LastName = document.getElementById("ChangeProfileLastName").value;
                                                            var Email = document.getElementById("ChangeProfileEmail").value;
                                                            var Tel = document.getElementById("ChangeProfilePhoneNumber").value;
                                                            
                                                            //address info
                                                            var HouseNumber = document.getElementById("ChangeProfileHouseNumber").value;
                                                            var Street = document.getElementById("ChangeProfileStreet").value;
                                                            var Town = document.getElementById("ChangeProfileTown").value;
                                                            var City = document.getElementById("ChangeProfileCity").value;
                                                            var Country = document.getElementById("ChangeProfileCountry").value;
                                                            var ZCode = document.getElementById("ChangeProfileZipCode").value;
                                                            
                                                            
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "updateCustomerUserAccount",
                                                                data: "CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&firstNameFld="+FirstName+"&middleNameFld="+MiddleName+"&lastNameFld="+LastName+"&emailFld="+
                                                                        Email+"&phoneNumberFld="+Tel+"&houseNumberFld="+HouseNumber+"&streetAddressFld="+Street+"&townFld="+Town+"&cityFld="+City+"&countryFld="+Country+"&zipCodeFld="+ZCode,
                                                                
                                                                success: function(result){
                                                                    
                                                                    alert("Update Successful");
                                                                    document.getElementById('PagePageLoader').style.display = 'none';
                                                                    $.ajax({
                                                                        type: "POST",
                                                                        url: "GetCustPerInfo",
                                                                        data: "CustomerID="+CustomerID,
                                                                        success: function(result){
                                                                            
                                                                            var PersonalInfo = JSON.parse(result);
                                                                            
                                                                            document.getElementById("ChangeProfileFirstName").value = PersonalInfo.FirstName;
                                                                            document.getElementById("ChangeProfileMiddleName").value = PersonalInfo.MiddleName;
                                                                            document.getElementById("ChangeProfileLastName").value = PersonalInfo.LastName;
                                                                            document.getElementById("ChangeProfileEmail").value = PersonalInfo.Email;
                                                                            document.getElementById("ChangeProfilePhoneNumber").value = PersonalInfo.Tel;

                                                                            //address info
                                                                            document.getElementById("ChangeProfileHouseNumber").value = PersonalInfo.Address.HouseNumber;
                                                                            document.getElementById("ChangeProfileStreet").value = PersonalInfo.Address.Street;
                                                                            document.getElementById("ChangeProfileTown").value = PersonalInfo.Address.Town;
                                                                            document.getElementById("ChangeProfileCity").value = PersonalInfo.Address.City;
                                                                            document.getElementById("ChangeProfileCountry").value = PersonalInfo.Address.Country;
                                                                            document.getElementById("ChangeProfileZipCode").value = PersonalInfo.Address.ZipCode;
                                                                            var FullAddress = PersonalInfo.Address.HouseNumber + " " + PersonalInfo.Address.Street + ", " + PersonalInfo.Address.Town + ", " +
                                                                                    PersonalInfo.Address.City + ", " + PersonalInfo.Address.Country + " " + PersonalInfo.Address.ZipCode;
                                                                            
                                                                            var FullName = PersonalInfo.FirstName + " " + PersonalInfo.MiddleName + " " + PersonalInfo.LastName;
                                                                            document.getElementById("FullNameDetail").innerHTML = FullName;
                                                                            document.getElementById("PhoneNumberDetail").innerHTML = PersonalInfo.Tel;
                                                                            document.getElementById("EmailDetail").innerHTML = PersonalInfo.Email;
                                                                            document.getElementById("AddressDetail").innerHTML = FullAddress;
                                                                            document.getElementById("NameForLoginStatus").innerHTML = PersonalInfo.FirstName;
                                                                            
                                                                        }
                                                                    });
                                                                    
                                                                }
                                                                
                                                            });
                                                            
                                                        });
                                                    });
                                                    
                                                </script>
                                                
                                        </form>
                                                
                                        <form id="SendFeedBackForm" style="border-top: 1px solid darkblue; margin-top: 5px; display: none;
                                              padding-top: 5px;" >
                                            <center><div id='LastReviewMessageDiv' style='display: none; background-color: white; width: 100%; max-width: 400px;'>
                                                <p id='LasReviewMessageP' style='text-align: left; padding: 5px; color: darkgray; font-size: 13px;'></p>
                                                <p id="FeedBackDate" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td>Compose feedback message below</td>
                                                </tr>
                                                <tr>
                                                    <td><textarea id="FeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" cols="35">
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='FeedBackUserID' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="SendFeedBackBtn" style="margin-top: 10px; border: 1px solid black; padding: 10px; background-color: pink; border-radius: 4px;" type="button" value="Send" /></center>
                                            
                                        </form>
                                                <script>
                                               $(document).ready(function() {                        
                                                    $('#SendFeedBackBtn').click(function(event) {  
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var feedback = document.getElementById("FeedBackTxtFld").value;
                                                        var CustomerID = document.getElementById("FeedBackUserID").value;
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "SendProvCustFeedBackController",  
                                                            data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                            success: function(result){
                                                              alert(result);
                                                              document.getElementById('PagePageLoader').style.display = 'none';
                                                              document.getElementById("FeedBackTxtFld").innerHTML = "Add your message here...";
                                                              document.getElementById("LastReviewMessageDiv").style.display = "block";
                                                              document.getElementById("LasReviewMessageP").innerHTML = "You've Sent: "+ "<p style='color: green; font-size: 15px;'>" +feedback+ "</p>";

                                                              $.ajax({  
                                                                type: "POST",  
                                                                url: "getCustFeedbackDate",  
                                                                data: "CustomerID="+CustomerID,  
                                                                success: function(result){  
                                                                    //alert(result);
                                                                    document.getElementById("FeedBackDate").innerHTML = result + " ";
                                                                }                
                                                              });
                                                            }                
                                                        });
                                                        
                                                    });
                                                });
                                            </script>
                                                
                                                <script>
                                                    
                                                    document.getElementById("FeedBackTxtFld").innerHTML = "Add your message here...";
                                                    
                                                   /* setInterval( function(){
                                                        
                                                        if(document.getElementById("FeedBackTxtFld") !== document.activeElement){
                                                            
                                                            if(document.getElementById("FeedBackTxtFld").innerHTML === "")
                                                                document.getElementById("FeedBackTxtFld").innerHTML = "Add your message here...";
                                                            
                                                        }
                                                        
                                                    }, 1);*/
                                                    
                                                    function checkFeedBackFld(){
                                                        
                                                        var FeedBackTxtFld = document.getElementById("FeedBackTxtFld");
                                                        var SendFeedBackBtn = document.getElementById("SendFeedBackBtn");
                                                        
                                                        if(FeedBackTxtFld.innerHTML !== "Add your message here..."){
                                                            SendFeedBackBtn.style.backgroundColor = "pink";
                                                            SendFeedBackBtn.disabled = false;
                                                        }else{
                                                            SendFeedBackBtn.style.backgroundColor = "darkgrey";
                                                            SendFeedBackBtn.disabled = true;
                                                        }
                                                        
                                                }
                                                
                                                setInterval(checkFeedBackFld, 1);
                                                    
                                        </script>
                                        
                                        <p style=""></p>
                                        
                                        <div style="text-align: right; margin-right: 5px; margin-top: 10px;">
                                            <div class="tooltip">
                                            <img style="margin-right: 10px; cursor: pointer;" onclick="showUserFeedBackForm()" src="icons/icons8-feedback-20.png" width="20" height="20" alt="icons8-feedback-20"/>
                                            
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick = "showUserProfileForm()" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/><p>
                                                <!--p class="tooltiptext"><br></p-->
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="cursor: pointer;" onclick = "showSettingsDiv()" src="icons/icons8-settings-20.png" width="20" height="20" alt="icons8-settings-20"/></p>
                                                
                                            </div>
                                        </div>
                                                
                                        <div id="SettingsDiv" style= "display: none;">
                                            <ul style="color: white;">
                                                <li>
                                                    
                                                    <p style="cursor: pointer;" onclick="showLoginFormsDiv()"><img src="icons/icons8-admin-settings-male-20 (1).png" width="20" height="20" alt="icons8-admin-settings-male-20 (1)"/>
                                                    Account Settings</p>
                                                    <form  id="UserAcountLoginForm" style="margin-top: 5px; display: none; border-top: darkblue solid 1px; padding: 5px;" name="userAccountForm">
                                                        <p>Change your login information:</p>
                                                        <p style="color: thistle; margin-top: 10px;">User Name:</p>
                                                        <center><p><input id="UpdateLoginNameFld" style="padding: 3px; background-color: cornflowerblue; color: darkblue;" placeholder="Enter New User Name Here" type="text" name="userName" value="<%=thisUserName%>" size="32" /></p></center>
                                                        
                                                        <p style="color: thistle; margin-top: 10px;">Password:</p>
                                                        <center><p><input id="CurrentPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Enter Current Password" type="password" name="currentPassword" value="" size="33" /></p>
                                                        
                                                            <p><input id="NewPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Enter New Password" type="password" name="newPassword" value="" size="33" /></p>
                                                        
                                                            <p><input id="ConfirmPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Confirm New Password" type="password" name="confirmNewPassword" value="" size="33" /></p>
                                                        <p id="changeUserAccountStatus"></p>
                                                        <p id="WrongPassStatus" style="color: white; background-color: red; display: none;">Enter your current password correctly</p>
                                                        <input id='UserIDforLoginUpdate' name="CustomerID" type="hidden" value="<%=UserID%>" />
                                                        <input id="ThisPass" type="hidden" name="ThisPass" value="" />
                                                        <input id='UserIndexforLoginUpdate' type='hidden' name='UserIndex' value='<%=UserIndex%>'/>
                                                        <input id="LoginFormBtn" style="margin-top: 10px; border: 1px solid black; padding: 10px; background-color: pink; border-radius: 4px;" type="button" value="Update" /></center>
                                                    </form>
                                                    <script>
                                                        $(document).ready(function(){
                                                            $("#LoginFormBtn").click(function(event){
                                                                document.getElementById('PagePageLoader').style.display = 'block';
                                                                var CustomerID = document.getElementById("UserIDforLoginUpdate").value;
                                                                var UserIndex = document.getElementById("UserIndexforLoginUpdate").value;
                                                                var UserName = document.getElementById("UpdateLoginNameFld").value;
                                                                var NewPassword = document.getElementById("NewPasswordFld").value;
                                                                var oldPassword = document.getElementById("CurrentPasswordFld").value;
                                                                
                                                                $.ajax({
                                                                    method: "POST",
                                                                    url: "updateLoginController",
                                                                    data: "CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&userName="+UserName+"&newPassword="+NewPassword+"&currentPassword="+oldPassword,
                                                                    success: function(result){
                                                                        document.getElementById('PagePageLoader').style.display = 'none';
                                                                        //alert(result);
                                                                        
                                                                        if(result === "fail"){
                                                                            
                                                                            document.getElementById("WrongPassStatus").style.display = "block";
                                                                            document.getElementById("CurrentPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").style.backgroundColor = "red";
                                                                            
                                                                            //document.getElementById("changeUserAccountStatus").innerHTML = "Enter your old password correctly";
                                                                            //document.getElementById("changeUserAccountStatus").style.backgroundColor = "red";
                                                                            //document.getElementById("LoginFormBtn").disabled = true;
                                                                            //document.getElementById("LoginFormBtn").style.backgroundColor = "darkgrey";
                                                                        }
                                                                        if(result === "success"){
                                                                            document.getElementById("NewPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").style.backgroundColor = "cornflowerblue";
                                                                            document.getElementById("ConfirmPasswordFld").value = "";
                                                                            document.getElementById("WrongPassStatus").style.display = "none";
                                                                            
                                                                            //getUserAccountNameController
                                                                            $.ajax({
                                                                                method: "POST",
                                                                                url: "getUserAccountNameController",
                                                                                data: "CustomerID="+CustomerID,
                                                                                
                                                                                success: function(result){

                                                                                    document.getElementById("UpdateLoginNameFld").value = result;


                                                                                }

                                                                            });
                                                                            alert("Update Successful");
                                                                        }
                                                                    }
                                                                    
                                                                });
                                                                
                                                            });
                                                        });
                                                    </script>
                                                    
                                                </li>
                                                <li>
                                                    <p style="cursor: pointer;" onclick="showContactUsDiv()"><img src="icons/icons8-telephone-20.png" width="20" height="20" alt="icons8-telephone-20"/>
                                                        Contact Us<p>
                                                    <div id="ContactUsDiv" style="margin-top: 5px; display: none; border-top: darkblue solid 1px; padding: 5px;">
                                                        <p style="margin-bottom: 5px; ">Our contact information:</p>
                                                        <p style="color: black;"><img src="icons/icons8-phone-32.png" width="20" height="20" alt="icons8-phone-32"/>
                                                          +1 (732) 799-9546</p>
                                                        <!--p style="color: black;"><img src="icons/icons8-fax-32.png" width="20" height="20" alt="icons8-fax-32"/>
                                                            7345738232</p-->
                                                        <p style="color: black;"><img src="icons/icons8-secured-letter-32.png" width="20" height="20" alt="icons8-secured-letter-32"/>
                                                            tech.arieslab@outlook.com</p>
                                                        <!--p style="color: black;"><img src="icons/icons8-facebook-32.png" width="20" height="20" alt="icons8-facebook-32"/>
                                                            @Queue</p>
                                                        <p style="color: black;"><img src="icons/icons8-twitter-32.png" width="20" height="20" alt="icons8-twitter-32"/>
                                                            @Queue</p>
                                                        <p style="color: black"><img src="icons/icons8-snapchat-32.png" width="20" height="20" alt="icons8-snapchat-32"/>
                                                            @Queue
                                                        </p>
                                                        <p style="color: black"><img src="icons/icons8-instagram-32.png" width="20" height="20" alt="icons8-instagram-32"/>
                                                            @Queue</p>
                                                        <p style="color: black;"><img src="icons/icons8-organization-32.png" width="20" height="20" alt="icons8-organization-32"/>
                                                            1227 Grand Concourse, New York, 10344 USA</p-->
                                                        
                                                    </div>
                                                </li>
                                                <li> 
                                                    <p style="cursor: pointer;" onclick="showPaymentsForm()"><img src="icons/icons8-mastercard-credit-card-20 (1).png" width="20" height="20" alt="icons8-mastercard-credit-card-20 (1)"/>
                                                        Payments</p>
                                                    
                                                    <form id="PaymentsCardForm" style="margin-top: 5px; display: none; border-top: darkblue solid 1px; padding: 5px;" name="PaymentForm" action="notYet" method="POST">
                                                
                                                        <p style="margin-bottom: 5px; ">Add new debit/credit card:</p>
                                                        <table id="paymentDetailsTable">
                                                    <tbody>

                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Card Number: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input onclick="checkMiddleCardNumber();" onkeydown="checkMiddleCardNumber();" id="CardNumberFld" style="background-color: #eeeeee;" type="text" name="C/DcardNumber" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Holder's Name: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="HoldersNameFld" style="background-color: #eeeeee;" type="text" name="holdersName" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Exp. Date: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="ExpDateFld" style="background-color: #eeeeee; max-width: 100px;" type="text" name="cardExpDate" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Security Code: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="SecCodeFld" style="background-color: #eeeeee; max-width: 100px;" type="text" name="secCode" value="" /></td></tr>

                                                    </tbody>
                                                    
                                                    <script>
                                                        var cardNumber = document.getElementById("CardNumberFld");

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
                                                         var ExpDateFld = document.getElementById("ExpDateFld");
                                                         
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
                                                    </table>
                                                
                                                    <p id="PaymentFormStatus" style="text-align: center;" ></p>
                                                    <center><input id="PaymentsUpdateBtn" style="background-color: pink; border: 1px solid black; padding: 10px; color: black; border-radius: 4px;" type="submit" value="Update" name="paymentBtn" /></center>
                                                
                                            </form>
                                                </li>
                                                <li>
                                                    <a onclick="document.getElementById('PagePageLoader').style.display = 'block';" href='ViewCustomerReviews.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>'><p style="cursor: pointer; color: white;"><img src="icons/icons8-popular-20 (1).png" width="20" height="20" alt="icons8-popular-20 (1)"/>
                                                            Your Reviews</p></a>
                                                </li>
                                            </ul>
                                        </div>
                                        
                                        <%  }
                                        
                                        %>
                                       
                                </div>
                                        
                                        <script>
                                            
                                            //making sure that the user enters some text before being able to post a feedback
                                            
                                            function toggleProInfoDivDisplay(){
                                                
                                                var ProInfoDiv = document.getElementById("ProInfoDiv");
                                                var ShowProInfo = document.getElementById("ShowProInfo");
                                                
                                                $("#ProInfoDiv").slideDown("fast");
                                                   ShowProInfo.style.display = "none";
                                               
                                                    
                                                
                                            }
                                            
                                        </script>
                                        
                                        <center><table id="selectCustSpttabs" cellspacing="0" style="width: 100%; margin-top: -5px;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateAppTab()" id="AppointmentsTab" style="padding: 5px; cursor: pointer; border-top: 1px solid black; width: 33.3%;  background-color: #ccccff;">
                                                        Your Spots
                                                    </td>
                                                    <td onclick="activateHistory()" id="HistoryTab" style="padding: 5px; cursor: pointer; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                        History
                                                    </td>
                                                    <td onclick="activateFavTab()" id="FavoritesTab" style="padding: 5px; cursor: pointer; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                        Favorites
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table></center>
                                        
                                <div class="scrolldiv" style=" height: 600px; overflow-y: auto;">
                                   
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
                                                
                                                <P>This spot with <span style = "color: blue;"><input style="background-color: #ffc700; color: blue; border:0; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderName%>"/>
                                                </span><span> started at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                        
                                                <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                    <span style = "color: blue;"><input style="background-color: #ffc700; color: blue; border: 0; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderCompany%>"/></span></span></p>
                                            
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
                                                
                                                <P>You are on <span style = "color: blue;"><input style="background-color: white; color: blue; border:0; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderName%>'s"/>
                                                </span><span> line at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                        
                                                <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                    <span style = "color: blue;"><input style="background-color: white; color: blue; border: 0; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderCompany%>"/></span></span></p>
                                            
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("ChangeAppointmentID<%=JString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFld<%=JString%>").value;
                                                        var AppointmentDate = document.getElementById("datepicker<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("AppointmentID<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProvIDatAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustIDatAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){
                                                         document.getElementById('PagePageLoader').style.display = 'none';
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
                                        
                                            <P>You will be on <span style = "color: blue;"><input style="background-color: white; border: 0; margin: 0; font-weight: bolder; color: blue;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit"  value="<%= ProviderName%>'s" /></span><span> line</p>
                                            <p>on <span id="FutureDateSpan<%=QString%>" style ="color: red;"> <%= AppointmentFormattedDate%></span>, at <span id="FutureTimeSpan<%=QString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                            <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                                <span style = "color: blue;"><input style="background-color: white; border: 0; margin: 0; font-weight: bolder; color: blue;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="<%= ProviderCompany%>" /></span></span></p>
                                        
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("UpdateAppointmentID<%=QString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFldFuture<%=QString%>").value;
                                                        var AppointmentDate = document.getElementById("datepickerFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("AppointmentIDFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProvIDforAddFav<%=QString%>").value;
                                                        var CustomerID = document.getElementById("CustIDforAddFav<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                        
                                        <P>You were on<span style = "color: blue;"> <input style="background: 0; border: 0; color: blue; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="<%=ProviderName%>'s"</span><span> line.</p>
                                        <p><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                            <span style = "color: blue;"> <input style="background: 0; border: 0; color: blue; font-weight: bolder; margin: 0;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="<%=ProviderCompany%>"</span></span></p>
                                        <p><span> <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %> - <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %></span></p>
                                        <p>on <span style ="color: red;"> <%= AppointmentFormattedDate%></span>, at <span style = "color: red;"> <%= TimeToUse%></span></P>
                                        <p style="color: darkgray; text-align: center;">- <%=AppointmentReason%> -</p>
                                        <a onclick="document.getElementById('PagePageLoader').style.display = 'block';" href="ViewSelectedProviderReviews.jsp?Provider=<%=ProviderID%>"><p id="ProviderReview<%=JString%>" style="color: green; text-align: center;"></p></a>
                                        
                                        </form>
                                        
                                        <form style=" display: none;" id="deleteAppointmentHistoryForm<%=JString%>" class="deleteAppointmentHistoryForm" name="confirmDeleteAppointmentHistory">
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to delete this history</p>
                                            <p><input id="DeleteAppointmentHistoryBtn<%=JString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=JString%>deleteAppointmentHistory" type="button" value="Yes" />
                                                <span onclick = "hideDeleteHistory(<%=JString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="AppointmentIDHistory<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteAppointmentHistoryBtn<%=JString%>').click(function(event) {  
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("AppointmentIDHistory<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("This is history has been removed");
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
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
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProviderIDforAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustomerIDforAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          document.getElementById('PagePageLoader').style.display = 'none';
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
                    
                                <div id="serviceslist" style="margin-top: 0; border-top: 0;" class="FavDiv">
                              
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
                                            <img class="fittedImg" style="border: 5px solid white;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
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
                                                        document.getElementById('PagePageLoader').style.display = 'block';
                                                        var ProvID = document.getElementById("ProvID<%=SString%>").value;
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "RemoveFavProvController",  
                                                            data: "UserID="+ProvID,  
                                                            success: function(result){  
                                                              alert(result);
                                                              document.getElementById('PagePageLoader').style.display = 'none';
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
                                        <input style=" background-color: pink; border: 1px solid black; padding: 5px;" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="Find a Spot" />
                                        </form></center>
                                        
                                        
                                    </div>
                                            
                                    </div>    
                                        
                                        <a onclick="document.getElementById('PagePageLoader').style.display = 'block';" href="AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                                            <p style="border: 1px solid darkblue; color: darkblue; text-align: center; padding: 5px; max-width: 300px;">View all your favorite providers</p></a>
                                </div>
                                
                                <%      }
                                    }
                                %>
                                
                                
                                <div id="LastFavDiv">
                                    
                                </div>
                                
                                </div>
                               </div>
                                 </center>
                            </td> 
                        </tr>
                    </tbody>
                    </table>
                                     
                </div>
                                        
        </div>
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
