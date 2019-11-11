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
        
        <script>
            setTimeout(function(){
                window.location.replace("ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>");
            }, 60000);
        </script>
        
        <div id="PermanentDiv" style="">
            
            <img onclick="showExtraDropDown();" id="ExtraDrpDwnBtn" style='margin-top: 2px; margin-left: 2px;float: left; border: 1px solid black; cursor: pointer; background-color: white;' src="icons/icons8-menu-25.png" width="33" height="33" alt="icons8-menu-25"/>
            <script>
                function showExtraDropDown(){
                    if(document.getElementById("ExtraDropDown").style.display === "none")
                        document.getElementById("ExtraDropDown").style.display = "block";
                    else
                        document.getElementById("ExtraDropDown").style.display = "none";
                }
                
            </script>
               
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
                        <img id="" style="border-radius: 100%; border: 2px solid green; margin-bottom: 20px; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64Pic%>" width="30" height="30"/>
                    </div></center>
                <%
                    }else{
                %>
                
                        <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" width="30" height="30" alt="icons8-user-filled-100"/>
                            </div></center>
                
                <%}%>
            </div>
            
            <a href='NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>'><div style='border:2px solid red; width: 40px; height: 27px; margin-top: 5px; float: right; border-radius: 4px; margin-right: 5px;'>
                    <img style='background-color:white; width: 40px; height: 27px;border-radius: 3px;' src="icons/icons8-google-news-50.png" alt="icons8-google-news-50"/>
                </div></a>
            
            <ul style="margin-right: 5px;">
                <textarea style="display: none;" id="NotiIDInput" rows="4" cols="20"><%=NotiIDs%>
                </textarea>
                <li onclick="showCustExtraNotification();" id='PermDivNotiBtn' style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-notification-50.png" width="20" height="17" alt="icons8-notification-50"/>
                    Notifications<sup id="notiCounterSup" style='color: red; background-color: white; padding-right: 2px;'> <%=notiCounter%></sup></li>
                <li onclick='showCustExtraCal();' id='PermDivCalBtn' style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li onclick='showCustExtraUsrAcnt();' id='PermDivUserBtn' style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
                
                <script>
                    $(document).ready(function(){
                        $("#PermDivNotiBtn").click(function(event){
                            
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
                
        <div id='ExtraDropDwnDiv'>  
            <table id='ExtraDropDown' style='display: none; z-index: 120; background-color: white; margin-top: 40px; position: fixed;  box-shadow: 4px 4px 4px #2c3539;'>
                <tbody>
                    <tr>
                        <td onclick="showCustExtraNews();" id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'>
                            <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="20" height="17" alt="icons8-google-news-50"/>
                            News
                        </td>
                    </tr>
                    <tr>
                        <td onclick="showCustExtraNotification2();" id='PermDivNotiBtn2' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-notification-50.png" width="20" height="17" alt="icons8-notification-50"/>
                            Notifications<sup id='notiCounterSup2' style='color: red; background-color: white; padding-right: 2px;'> <%=notiCounter%></sup>
                        </td>
                    </tr>
                    <tr>
                        <td onclick='showCustExtraCal2();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                            Calender</td>
                    </tr>
                    <tr>
                        <td onclick='showCustExtraUsrAcnt2();' id='' style='cursor: pointer; background-color: #334d81; border: 1px solid white; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                            Account</td>
                    </tr>
                </tbody>
            </table>
                        
            <script>
                    $(document).ready(function(){
                        $("#PermDivNotiBtn2").click(function(event){
                            
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
                                        document.getElementById("notiCounterSup2").innerHTML = " 0 ";
                                    }
                                });
                            }
                            
                        });
                    });
                </script>
                        
        </div>
                        
        <div onclick='hideExtraDropDown();' id="container">
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <li onclick="scrollToTop()" style="padding-left: 2px; padding-right: 2px;"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                            <input style="margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;"
                                   placeholder="Search provider" name="SearchFld" type="text"  value="" size="30" />
                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                            <input type='hidden' name='User' value='<%=NewUserName%>' />
                            <input style="margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;" 
                                   type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            
            <center><p> </p></center>
            <center><img src="QueueLogo.png" style="margin-top: 5px;" /></center>
            
        </div>
                            
        <div id="Extras">
            
            <div id='News' style=''>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">News updates from your providers</p></center>
            
                <div style="max-height: 600px; overflow-y: auto;">
                    
                    <%
                        int newsItems = 0;
                        String newsQuery = "";
                        String base64Profile = "";
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(Url, user, password);
                                String CustQuery = "select * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
                                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                                CustPst.setInt(1, UserID);
                                ResultSet CustRec = CustPst.executeQuery();
                                
                                while(CustRec.next()){
                                    
                                    String MessageID = CustRec.getString("MessageID").trim();
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection newsConn = DriverManager.getConnection(Url, user, password);
                                        newsQuery = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
                                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                                        newsPst.setString(1, MessageID);
                                        ResultSet newsRec = newsPst.executeQuery();

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


                                            }catch(Exception e){}


                                                try{
                                                    Class.forName(Driver);
                                                    Connection ProvConn = DriverManager.getConnection(Url, user, password);
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
                                                    Connection ProvLocConn = DriverManager.getConnection(Url, user, password);
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

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    //}
                
                    if(newsItems < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(Url, user, password);
                            String newsQuery2 = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
                            ResultSet newsRec = newsPst.executeQuery();

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
                                        Connection ProvConn = DriverManager.getConnection(Url, user, password);
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
                                        Connection ProvLocConn = DriverManager.getConnection(Url, user, password);
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
            
                }
            %>
               </div> 
            </div>
            
            <div id='Calender' style='display: none; margin-top: 5px;'>
                <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Your Calender</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <div id="DateChooserDiv" style=''>
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Pick a date below</p>
                                    <% SimpleDateFormat CalDateFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");%>
                                    <p style='text-align: center;'><input id="CalDatePicker" style='cursor: pointer; width: 90%; 
                                                                          font-weight: bolder; border: 1px solid white; background-color: #eeeeee; padding: 5px;' type="button" name="CalDateVal" 
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
                            
                            <td style=''>
                                
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
                            <td style=''>
                                
                                <p style='margin-bottom: 5px; color: #ff3333;'>Events</p>
                                
                                <div id='EventsListDiv' style='height: 290px; overflow-y: auto;'>
                                    <%
                                        try{
                                            
                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                            String SDate = sdf.format(new Date());
                                            
                                            Class.forName(Driver);
                                            Connection EventsConn = DriverManager.getConnection(Url, user, password);
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
                                    <p>Title: <input id="AddEvntTtle" style='background-color: white;' type="text" name="EvntTitle" value="" /></p>
                                    <p><textarea onfocusout="checkEmptyEvntDesc();" id="AddEvntDesc" name="EvntDesc" rows="4" style='width: 98%;'>
                                        </textarea></p>
                                    <p>Date: <input id='EvntDatePicker' style='background-color: white;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p>Time: <input id="AddEvntTime" style='background-color: white;' type="text" name="EvntTime" value="" /></p>
                                </div>
                            </td>
                            
                            <script>
                        
                                document.getElementById("AddEvntDesc").value = "Add event description here...";

                                function checkEmptyEvntDesc(){
                                    if(document.getElementById("AddEvntDesc").value === "")
                                        document.getElementById("AddEvntDesc").value = "Add event description here...";
                                }

                                $('#AddEvntTime').timepicker({
                                        timeFormat: 'HH:mm',
                                        interval: 10,
                                        minTime: '00',
                                        maxTime: '23:59',
                                        defaultTime: '12',
                                        startTime: '00',
                                        dynamic: false,
                                        dropdown: true,
                                        scrollbar: true
                                });

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
                                <input id="CalSaveEvntBtn" style='float: left; border: 1px solid black; background-color: pink; width: 95%;' type='button' value='Save' /></center>
                                <input onclick="" id="CalDltEvntBtn" style='float: right; display: none; border: 1px solid black; background-color: pink; width: 47%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate();" id="CalUpdateEvntBtn" style='display: none; border: 1px solid black; background-color: pink; width: 47%;' type='button' value='Change' />
                            </td>
                        </tr>
                        
                        <script>
                            $(document).ready(function(){
                                
                                $("#CalDltEvntBtn").click(function(event){
                                    var EventID = document.getElementById("EvntIDFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            if(result === "success")
                                                alert(result);
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
                             
        <div id='ExtrasUserAccountDiv' style='display: none;'>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Your Account</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee"> <!--fNameExtraFld mNameExtraFld lNameExtraFld EmailExtraFld-->
                            <td>
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
                                                if(result === "success"){
                                                    //alert(result);
                                                    var FullName = FirstName + " " + MiddleName + " " + LastName;
                                                    document.getElementById("FullNameDetail").innerHTML = FullName;
                                                    document.getElementById("PhoneNumberDetail").innerHTML = Phone;
                                                    document.getElementById("EmailDetail").innerHTML = Email;
                                                    document.getElementById("NameForLoginStatus").innerHTML = FirstName;
                                                                            
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

                                                             var feedback = document.getElementById("ExtFeedBackTxtFld").value;
                                                             var CustomerID = document.getElementById("ExtFeedBackUserID").value;

                                                             $.ajax({  
                                                             type: "POST",  
                                                             url: "SendProvCustFeedBackController",  
                                                             data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                             success: function(result){  
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
                                $(document).ready(function(){
                                    $("#ExtraLoginFormBtn").click(function(event){
                                                                
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
                                                    document.getElementById("ExtraNewPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.backgroundColor = "#eeeeee";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.color = "cadetblue";
                                                    document.getElementById("ExtraConfirmPasswordFld").value = "";
                                                    document.getElementById("ExtraWrongPassStatus").style.display = "none";
                                                                            
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
                                <form action = "LogoutController" name="LogoutForm" method="POST"> 
                                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                    <center><input style='width: 95%;' type="submit" value="Logout" class="button" /></center>
                                </form>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
                                
            <div id='ExtrasNotificationDiv' style='display: none;'>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Notifications</p></center>
            
            <div style=' height: 630px; overflow-y: auto;'>
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        
                    <%
                        
                        boolean isTrWhite = false;
                        
                        for(int notify = 0 ; notify < Notifications.size(); notify++){
                    
                            if(!isTrWhite){
                            
                    %>
                    
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p style='padding: 0; margin: 0; text-align: left; padding: 3px; color: darkblue; font-family: helvetica;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%
                                isTrWhite = true;
                                
                            }else{
                    %>
                    
                        <tr>
                            <td>
                                <p style='padding: 0; margin: 0; text-align: left; padding: 3px; color: darkblue; font-family: helvetica;'><%=Notifications.get(notify)%></p>
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
                        
                <!--p style='text-align: center; color: green; padding: 5px; cursor: pointer;'>more...</p-->
            </div>
                    
            </div>
        </div>
            
            
        <div id="content">
            <center><div id='PhoneNotiBar' style='cursor: pointer; background-color: #ccccff; border-top: 1px solid white; padding: 5px;'>
                    <a href='NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>'><div style='color: black; border-right: 1px solid grey; width: 30%; float: left;'><img style='background-color: white;' src="icons/icons8-google-news-50.png" width="25" height="22" alt="icons8-google-news-50"/>
                        News </div></a>
                    <a href='CustomerSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=1'><div style='color: black; border-right: 1px solid grey; width: 37%; float: left;'><img style='background-color: white;' src="icons/icons8-notification-50.png" width="25" height="22" alt="icons8-notification-50"/>
                            Notifications<sup style='color: red; padding-right: 2px;'> <%=notiCounter%></sup> </div></a>
                    <a href='CustomerSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=2'><div style='width: 30%; color: black; float: left;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="24" height="21" alt="icons8-calendar-50"/>
                        Calender</div></a>
                    <p style='clear: both;'></p>
                    </div></center>
            <div id="nav">
                
                <!--h3><a href="index.jsp?UserIndex=<%=UserIndex%>" style ="color: blanchedalmond">AriesLab.com</a></h3>
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
                <h4><a href="" style=" color: black;"></a></h4>
                
                <center><div class ="SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" />
                    </form> 
                        
                </div></center>
                        
                <div id="LocSearchDiv" style="margin-top: 5px;">
                <center><form style="background-color: #6699ff; border: 1px solid darkblue; padding: 5px; border-radius: 5px; width: 95%;" action="ByAddressSearchResultLoggedIn.jsp" method="POST">
                    <input type="hidden" name="User" value="<%=NewUserName%>" />
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <p style="color: #000099;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                        Find services at location below</p>
                    <p>City: <input style="width: 80%; background-color: #6699ff;" type="text" name="city4Search" placeholder="" value=""/></p> 
                    <p>Town: <input style="background-color: #6699ff; width: 40%" type="text" name="town4Search" value=""/> Zip Code: <input style="width: 19%; background-color: #6699ff;" type="text" name="zcode4Search" value="" /></p>
                    <p style='color: white; margin-top: 5px;'>Filter Search by:</p>
                    <div class='scrolldiv' style='width: 95%; overflow-x: auto; color: white; background-color: #3d6999;'>
                        <table style='width: 2500px;'>
                            <tbody>
                                <tr>
                                    <td style='border-right: 1px solid darkblue;'>
                                        <p><input name='Barber' id='barberFlt' type="checkbox" value="ON" /><label for='barberFlt'>Barber Shop</label></p>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Beauty' id='BeautyFlt' type="checkbox" value="ON" /><label for='BeautyFlt'>Beauty Salon</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='DaySpa' id='DaySpaFlt' type="checkbox" value="ON" /><label for='DaySpaFlt'>Day Spa</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Dentist' id='DentistFlt' type="checkbox" value="ON" /><label for='DentistFlt'>Dentist</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Dietician' id='DietFlt' type="checkbox" value="ON" /><label for='DietFlt'>Dietician</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='EyeBrows' id='EyebrowsFlt' type="checkbox" value="ON" /><label for='EyebrowsFlt'>Eyebrows and Eyelashes</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='HairRemoval' id='HairRmvFlt' type="checkbox" value="ON" /><label for='HairRmvFlt'>Hair Removal</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='HairSalon' id='HairSlnFlt' type="checkbox" value="ON" /><label for='HairSlnFlt'>Hair Salon</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='HolisticMedicine' id='HolMedFlt' type="checkbox" value="ON" /><label for='HolMedFlt'>Holistic Medicine</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='HomeService' id='HomeSvFlt' type="checkbox" value="ON" /><label for='HomeSvFlt'>Home Services</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='MakeUpArtist' id='MkUpArtistFlt' type="checkbox" value="ON" /><label for='MkUpArtistFlt'>Makeup Artist</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Massage' id='MassageFlt' type="checkbox" value="ON" /><label for='MassageFlt'>Massage</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Aethetician' id='MedEsthFlt' type="checkbox" value="ON" /><label for='MedEsthFlt'>Medical Aesthetician</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='MedCenter' id='MedCntrFlt' type="checkbox" value="ON" /><label for='MedCntrFlt'>Medical Center</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='NailSalon' id='NailSlnFlt' type="checkbox" value="ON" /><label for='NailSlnFlt'>Nail Salon</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='PersonalTrainer' id='PsnlTrnFlt' type="checkbox" value="ON" /><label for='PsnlTrnFlt'>Personal Trainer</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='PetServices' id='PetSvcFlt' type="checkbox" value="ON" /><label for='PetSvcFlt'>Pet Services</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='PhysicalTherapy' id='PhThpyFlt' type="checkbox" value="ON" /><label for='PhThpyFlt'>Physical Therapy</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Piercing' id='PiercingFlt' type="checkbox" value="ON" /><label for='PiercingFlt'>Piercing</label>
                                    </td>
                                    <td style='border-right: 1px solid darkblue;'>
                                    <input name='Podiatry' id='PodiatryFlt' type="checkbox" value="ON" /><label for='PodiatryFlt'>Podiatry</label>
                                    </td>
                                    <td>
                                    <input name='TattooShop' id='TtShFlt' type="checkbox" value="ON" /><label for='TtShFlt'>Tattoo Shop</label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p><input type="submit" style="background-color: #6699ff; color: white; padding: 5px; border-radius: 5px; border: 1px solid white; width: 95%;" value="Search" /></p>
                    </form></center>
                </div>
                    
            </div>
            
            <div id="main" class="Main">
                <%
                    if(Base64Pic != ""){
                %>
                <center><div id="custProPicDisplay" style="width: 100%; max-width: 340px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                 <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64Pic%>" width="40" height="40"/>
                    </div></center>
                <%
                    }
                %>
                    
                <center><p style="color: white; background-color: green; margin-bottom: 15px; margin-top: 0; max-width: 300px">
                        <span style='color: #ffc700;' id="NameForLoginStatus"><%=FirstName%></span> - What are you looking for? </p></center>
                 
                <!--cetnter><h4></h4></cetnter-->
                
                <div id="firstSetProvIcons">
                <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
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
                            <td><center><a href="QueueSelectPiercingLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectTattooLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                            </a></center></td>
                        <tr>
                            <td><center><a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPersonalTrainerLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPhysicalTherapyLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
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
                            <td style="width: 33.3%;"><center><a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectHairRemovalLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            </tr> 
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                                </a></center></td>
                            </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondFromThirdProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Previous</p></center>

                </div>
                
            </div>
                
        </div>
                
        <div onclick='hideExtraDropDown();' id="newbusiness" style="padding-top: 0;">
                
                <!----------------------------------------------------------------------------------------------------------------->
        <div id='Extras2Container' style='z-index: 200;'>
            <div id="Extras2" style="display: none; height: 565px; overflow-y: auto; position: fixed; width: 33.5%; z-index: 110; background-color: #ccccff; text-align: left;">
                
                <p onclick='document.getElementById("Extras2").style.display = "none";' style='width: 50px; float: right; margin-right: 5px; margin-top:5px;
                   border-radius: 5px;  color: white; cursor: pointer; border: 1px solid white; text-align: center; background-color: red;'>hide
                </p>
                
            <div id='News2' style='display: none;'>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">News updates from your providers</p></center>
            
                <div style="max-height: 600px; overflow-y: auto;">
                    
                    <%
                        int newsItems2 = 0;
                        String newsQuery2 = "";
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(Url, user, password);
                                String CustQuery = "select * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
                                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                                CustPst.setInt(1, UserID);
                                ResultSet CustRec = CustPst.executeQuery();
                                
                                while(CustRec.next()){
                                    
                                    String MessageID = CustRec.getString("MessageID").trim();
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection newsConn = DriverManager.getConnection(Url, user, password);
                                        newsQuery2 = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
                                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
                                        newsPst.setString(1, MessageID);
                                        ResultSet newsRec = newsPst.executeQuery();

                                        while(newsRec.next()){

                                            newsItems2++;
                                            
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
                                                    Connection ProvConn = DriverManager.getConnection(Url, user, password);
                                                    String ProvQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                                                    PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                                                    ProvPst.setString(1, ProvID);

                                                    ResultSet ProvRec = ProvPst.executeQuery();

                                                    while(ProvRec.next()){
                                                        ProvFirstName = ProvRec.getString("First_Name").trim();
                                                        ProvCompany = ProvRec.getString("Company").trim();
                                                        ProvTel = ProvRec.getString("Phone_Number").trim();
                                                        ProvEmail = ProvRec.getString("Email").trim();
                                                    }

                                                }catch(Exception e){
                                                    e.printStackTrace();
                                                }

                                                try{
                                                    Class.forName(Driver);
                                                    Connection ProvLocConn = DriverManager.getConnection(Url, user, password);
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
                                        <p style='font-weight: bolder; margin-bottom: 4px;'><span style='color: #eeeeee;'><%=ProvFirstName%> - <%=ProvCompany%></p></p>

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
                                        if(newsItems2 > 10)
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
                
                    if(newsItems2 < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(Url, user, password);
                            String newsQuery3 = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery3);
                            ResultSet newsRec = newsPst.executeQuery();

                            while(newsRec.next()){

                                newsItems2++;

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
                                        Connection ProvConn = DriverManager.getConnection(Url, user, password);
                                        String ProvQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                                        PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                                        ProvPst.setString(1, ProvID);

                                        ResultSet ProvRec = ProvPst.executeQuery();

                                        while(ProvRec.next()){
                                            ProvFirstName = ProvRec.getString("First_Name").trim();
                                            ProvCompany = ProvRec.getString("Company").trim();
                                            ProvTel = ProvRec.getString("Phone_Number").trim();
                                            ProvEmail = ProvRec.getString("Email").trim();
                                        }

                                    }catch(Exception e){
                                        e.printStackTrace();
                                    }

                                    try{
                                        Class.forName(Driver);
                                        Connection ProvLocConn = DriverManager.getConnection(Url, user, password);
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
                                    <p style='font-weight: bolder; margin-bottom: 4px;'><span style='color: #eeeeee;'><%=ProvFirstName%> - <%=ProvCompany%></p></p>
                                    
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
                            if(newsItems2 > 10)
                                break;
                        }
                    }catch(Exception e){
                        e.printStackTrace();
                    }
            
                }
            %>
               </div>
            </div>
            
            <div id='Calender2' style='display: none; margin-top: 5px;'>
                <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Your Calender</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <div id="DateChooserDiv2" style=''>
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Pick a date below</p>
                                    <!--% SimpleDateFormat CalDateFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");%-->
                                    <p style='text-align: center;'><input id="CalDatePicker2" style='cursor: pointer; width: 90%; 
                                                                          font-weight: bolder; border: 1px solid white; background-color: #eeeeee; padding: 5px;' type="button" name="CalDateVal" 
                                                                          value="<%= new Date().toString().substring(0,3) + ", " +CalDateFormat.format(new Date())%>" readonly onkeydown="return false"/></p>
                                    <script>
                                    $(function() {
                                        $("#CalDatePicker2").datepicker();
                                      });
                                    </script>
                                </div>
                                    
                                <div style='border-bottom: 1px #7e7e7e solid; padding-bottom: 4px;'>
                                    <div onclick="showEventsTr2();" id='EventsTrBtn2' style='cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: #eeeeee; width: 49%; float: right;'>Events</div>
                                    <div onclick="showAppointmentsTr2();" id='AppointmentsTrBtn2' style='cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: #ccc; width: 49%; float: left;'>Appointments</div>
                                    <p style='clear: both;'></p>
                                </div>
                                    
                            </td>
                        </tr>
                        <tr id='AppointmentsTr2' style='display: none; background-color: #eeeeee;'>
                            
                            <td style=''>
                                
                                <p style='margin-bottom: 5px; color: #ff3333;'>Appointments</p>
                                
                                <input type="hidden" id="CalApptUserID2" value="<%=UserID%>" />
                                
                                <div id='CalApptListDiv2' style='height: 290px; overflow-y: auto;'>
                                    
                                    <%
                                        int count2 = 1;
                                        
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
                                    
                                    <p style="background-color: #ffc700; margin-bottom: 2px;"><%=count2%>. <span style="color: white; font-weight: bolder;"><%=ProvName%></span> of <span style="color: darkblue; font-weight: bolder;"><%=ProvComp%></span> at <span style="color: darkblue; font-weight: bolder;"><%=AptTime%></span></p>
                                    
                                    <%
                                            count2++;
                                        }
                                    %>
                                    
                                    <script>
                                        var updtCounter2 = 0;
                                        
                                        $(document).ready(function(){
                                            
                                            $("#CalDatePicker2").change(function(event){
                                                
                                                var date = document.getElementById("CalDatePicker2").value;
                                                var CustomerID = document.getElementById("CalApptUserID2").value;
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
                                                        
                                                        document.getElementById("CalApptListDiv2").innerHTML = aDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetCustEvntAjax",
                                                    data: "Date="+date+"&CustomerID="+CustomerID,
                                                    success: function(result){
                                                        //alert(result);
                                                        
                                                        var EvntsData = JSON.parse(result);
                                                        
                                                        var bDiv = document.createElement('div');
                                                        
                                                        for(i in EvntsData.Data){
                                                            
                                                            
                                                            var ID = EvntsData.Data[i].EvntID;
                                                            var Date = EvntsData.Data[i].EvntDate;
                                                            var Time = EvntsData.Data[i].EvntTime;
                                                            var Title = EvntsData.Data[i].EvntTtle;
                                                            var Desc = EvntsData.Data[i].EvntDesc;
                                                            
                                                            
                                                            updtCounter2 = parseInt(updtCounter2, 10) + 1;
                                                            
                                                            bDiv.innerHTML += '<div id="Cupdt2'+updtCounter2+'" ' +
                                                                    'onclick=\'updateEvent2("'+ID+'", "'+Title+'","'+Desc+'", "'+Date+'","' +Time+'", "Cupdt2'+updtCounter2+'");\' ' +
                                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +

                                                                    '<p><span style="font-weight: bolder; color: white;">'+Title+'</span> - <span style="color: darkblue; font-weight: bolder;">'+Date+'</span> - <span style="color: darkblue; font-weight: bolder;">'+Time+'</span></p>'+
                                                                    '<P style="color: #334d81;">'+Desc+'</p>'+
                                                                '</div>';
                                                            
                                                        }
                                                        
                                                        document.getElementById("EventsListDiv2").innerHTML = bDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                            });
                                            
                                        });
                                    </script>
                                </div>
                            </td>
                        </tr>
                        <tr id='EventsTr2' style="background-color: #eeeeee;">
                            
                            <td style=''>
                                
                                <p style='margin-bottom: 5px; color: #ff3333;'>Events</p>
                                
                                <div id='EventsListDiv2' style='height: 290px; overflow-y: auto;'>
                                    <%
                                        try{
                                            
                                             SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                             String SDate = sdf.format(new Date());
                                            
                                            Class.forName(Driver);
                                            Connection EventsConn = DriverManager.getConnection(Url, user, password);
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
                                    
                                                <div id="PgLdupdt2<%=counter%>"
                                                    onclick='updateEvent2("<%=EventID%>", "<%=EventTitle%>", "<%=EventDesc%>", "<%=EventDate%>", "<%=EventTime%>", "PgLdupdt2<%=counter%>");' 
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
                                    <p>Title: <input id="AddEvntTtle2" style='background-color: white;' type="text" name="EvntTitle" value="" /></p>
                                    <p><textarea onfocusout="checkEmptyEvntDesc2();" id="AddEvntDesc2" name="EvntDesc" rows="4" style='width: 98%;'>Describe this event here
                                        </textarea></p>
                                    <p>Date: <input id='EvntDatePicker2' style='background-color: white;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker2").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p>Time: <input id="AddEvntTime2" style='background-color: white;' type="text" name="EvntTime" value="" /></p>
                                </div>
                            </td>
                            
                            <script>
                        
                            document.getElementById("AddEvntDesc2").value = "Add event description here...";

                            function checkEmptyEvntDesc2(){
                                if(document.getElementById("AddEvntDesc2").value === "")
                                    document.getElementById("AddEvntDesc2").value = "Add event description here...";
                            }

                            $('#AddEvntTime2').timepicker({
                                    timeFormat: 'HH:mm',
                                    interval: 10,
                                    minTime: '00',
                                    maxTime: '23:59',
                                    defaultTime: '12',
                                    startTime: '00',
                                    dynamic: false,
                                    dropdown: true,
                                    scrollbar: true
                                });

                            setInterval(function(){
                                var CalSaveEvntBtn = document.getElementById("CalSaveEvntBtn2");
                                var CalUpdateEvntBtn = document.getElementById("CalUpdateEvntBtn2");
                                var CalDltEvntBtn = document.getElementById("CalDltEvntBtn2");

                                var AddEvntTtle = document.getElementById("AddEvntTtle2");
                                var AddEvntDesc = document.getElementById("AddEvntDesc2");
                                var EvntDatePicker = document.getElementById("EvntDatePicker2");
                                var AddEvntTime = document.getElementById("AddEvntTime2");

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
                                <input type="hidden" id="EvntIDFld2" value=""/>
                                <center><input id="CalSaveEvntBtn2" style='border: 1px solid black; background-color: pink; width: 95%;' type='button' value='Save' /></center>
                                <center><input onclick="" id="CalDltEvntBtn2" style='float: right; display: none; border: 1px solid black; background-color: pink; width: 47%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate2();" id="CalUpdateEvntBtn2" style='float: left; display: none; border: 1px solid black; background-color: pink; width: 47%;' type='button' value='Change' /></center>
                            </td>
                        </tr>
                        
                        <script>
                            $(document).ready(function(){
                                
                                $("#CalDltEvntBtn2").click(function(event){
                                    var EventID = document.getElementById("EvntIDFld2").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            if(result === "success")
                                                //alert(result);
                                                document.getElementById("CalUpdateEvntBtn2").style.display = "none";
                                                document.getElementById("CalDltEvntBtn2").style.display = "none";
                                                document.getElementById("CalSaveEvntBtn2").style.display = "block";
                                                document.getElementById("AddEvntTtle2").value = "";
                                                document.getElementById("AddEvntDesc2").value = "";
                                                document.getElementById("EvntDatePicker2").value = "";
                                                document.getElementById("AddEvntTime2").value = "";
                                                document.getElementById("EvntIDFld2").value = "";
                                        }
                                        
                                    });
                                });
                            });
                        </script>
                        
                        <script>
                            var updateCounter2 = 0;
                            
                            function updateEvent2(pEvntID, pEvntTtle, pEvntDesc, pEvntDate, pEvntTime, element){
                                
                                document.getElementById(element).style.display = "none";
                                document.getElementById("CalSaveEvntBtn2").style.display = "none";
                                document.getElementById("CalUpdateEvntBtn2").style.display = "block";
                                document.getElementById("CalDltEvntBtn2").style.display = "block";
                                
                                document.getElementById("AddEvntTtle2").value = pEvntTtle.toString();
                                document.getElementById("AddEvntDesc2").value = pEvntDesc.toString();
                                document.getElementById("EvntDatePicker2").value = pEvntDate.toString();
                                document.getElementById("AddEvntTime2").value = pEvntTime.toString();
                                document.getElementById("EvntIDFld2").value = pEvntID.toString();
                            }  
                            
                            function SendEvntUpdate2(){
                                
                                var EvntTtle = document.getElementById("AddEvntTtle2").value;
                                EvntTtle = EvntTtle.replace("\"","");
                                var EvntDesc = document.getElementById("AddEvntDesc2").value;
                                EvntDesc = EvntDesc.replace("\"","");
                                var EvntDate = document.getElementById("EvntDatePicker2").value;
                                var EvntTime = document.getElementById("AddEvntTime2").value;
                                var EvntId = document.getElementById("EvntIDFld2").value;
                                
                                var CalDate = document.getElementById("CalDatePicker2").value;
                                    
                                    //alert(CalDate);
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "UpdateEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&EventID="+EvntId,
                                        success: function(result){
                                            
                                            //alert(result);
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            //alert(Evnt.EvntID);
                                            //alert(Evnt.JQDate);
                                            
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter2 = parseInt(updateCounter2, 10) + 1;
                                                document.getElementById("EventsListDiv2").innerHTML += '<div id="updt2'+updateCounter2+'" ' +
                                                    'onclick=\'updateEvent2("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt2'+updateCounter2+'");\' ' +
                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +
                                                    
                                                    '<p><span style="font-weight: bolder; color: white;">'+EvntTtle+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntDate+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntTime+'</span></p>'+
                                                    '<P style="color: #334d81;">'+EvntDesc+'</p>'+
                                                '</div>';
                                        
                                            }
                                        }
                                    });
                                    
                                    document.getElementById("CalUpdateEvntBtn2").style.display = "none";
                                    document.getElementById("CalDltEvntBtn2").style.display = "none";
                                    document.getElementById("CalSaveEvntBtn2").style.display = "block";
                                    document.getElementById("AddEvntTtle2").value = "";
                                    document.getElementById("AddEvntDesc2").value = "";
                                    document.getElementById("EvntDatePicker2").value = "";
                                    document.getElementById("AddEvntTime2").value = "";
                                    document.getElementById("EvntIDFld2").value = "";
                                
                            }
                        </script>
                        
                        <script>
                            
                            $(document).ready(function(){
                                
                                $("#CalSaveEvntBtn2").click(function(event){
                                    
                                    var EvntTtle = document.getElementById("AddEvntTtle2").value;
                                    EvntTtle = EvntTtle.replace("\"","");
                                    var EvntDesc = document.getElementById("AddEvntDesc2").value;
                                    EvntDesc = EvntDesc.replace("\"","");
                                    var EvntDate = document.getElementById("EvntDatePicker2").value;
                                    var EvntTime = document.getElementById("AddEvntTime2").value;
                                    //alert(EvntTime);
                                    
                                    var CalDate = document.getElementById("CalDatePicker2").value;
                                    //alert(CalDate);
                                    
                                    var CustID = document.getElementById("CalApptUserID2").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "AddEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&CustomerID="+CustID,
                                        success: function(result){
                                            
                                            //alert(result);
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            //alert(Evnt.EvntID);
                                            //alert(Evnt.JQDate);
                                            
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter2 = parseInt(updateCounter2, 10) + 1;
                                                document.getElementById("EventsListDiv2").innerHTML += '<div id="updt2'+updateCounter2+'" ' +
                                                    'onclick=\'updateEvent2("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt2'+updateCounter2+'");\' ' +
                                                    'style="cursor: pointer; background-color: orange; margin-bottom: 2px; padding: 2px;">' +
                                                    
                                                    '<p><span style="font-weight: bolder; color: white;">'+EvntTtle+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntDate+'</span> - <span style="color: darkblue; font-weight: bolder;">'+EvntTime+'</span></p>'+
                                                    '<P style="color: #334d81;">'+EvntDesc+'</p>'+
                                                '</div>';
                                        //alert('onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle+'","'+EvntDesc+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' );
                                        
                                            }
                                        }
                                    });
                                    
                                    document.getElementById("AddEvntTtle2").value = "";
                                    document.getElementById("AddEvntDesc2").value = "";
                                    document.getElementById("EvntDatePicker2").value = "";
                                    document.getElementById("AddEvntTime2").value = "";
                                    document.getElementById("EvntIDFld2").value = "";
                                    
                                });
                            });
                        </script>
                    </tbody>
                </table>
            </div>
                             
        <div id='ExtrasUserAccountDiv2' style='display: none;'>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Account Settings</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <input type='hidden' id='ExtraUpdPerUserID2' value='<%=UserID%>' />
                                <p style='margin-bottom: 5px; color: #ff3333;'>Edit Your Personal Info</p>
                                <p>First Name: <input id='fNameExtraFld2' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtfName" value="<%=FirstName%>" /></p>
                                <p>Middle Name: <input id='mNameExtraFld2' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtmName" value="<%=MiddleName%>" /></p>
                                <p>Last Name: <input id='lNameExtraFld2' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtlName" value="<%=LastName%>" /></p>
                                <p>Email: <input id='EmailExtraFld2' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="ExtEmail" value="<%=Email%>" /></p>
                                <p>Phone: <input id='PhoneExtraFld2' style='background-color: #eeeeee; border: 0; text-align: left; color: cadetblue; font-weight: bolder;' type="text" name="EvntTime" value="<%=PhoneNumber%>" /></p>
                                <center><input id='UpdtPerInfExtraBtn2' style='background-color: pink; border: 1px solid black; width: 95%;' type="submit" value="Change" /></center>
                            </td>
                            
                            <script>
                                
                                setInterval(function(){
                                    
                                    var fNameExtraFld = document.getElementById("fNameExtraFld2");
                                    var mNameExtraFld = document.getElementById("mNameExtraFld2");
                                    var lNameExtraFld = document.getElementById("lNameExtraFld2");
                                    var EmailExtraFld = document.getElementById("EmailExtraFld2");
                                    var PhoneExtraFld = document.getElementById("PhoneExtraFld2");
                                    var UpdtPerInfExtraBtn = document.getElementById("UpdtPerInfExtraBtn2");
                                    
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
                                    $("#UpdtPerInfExtraBtn2").click(function(){
                                        
                                        var FirstName = document.getElementById("fNameExtraFld2").value;
                                        var MiddleName = document.getElementById("mNameExtraFld2").value;
                                        var LastName = document.getElementById("lNameExtraFld2").value;
                                        var Email = document.getElementById("EmailExtraFld2").value;
                                        var Phone = document.getElementById("PhoneExtraFld2").value;
                                        var CustomerID = document.getElementById("ExtraUpdPerUserID2").value;
                                        
                                        $.ajax({
                                            type: "POST",
                                            url: "updtPerInfoExtraAjax",
                                            data: "FirstName="+FirstName+"&MiddleName="+MiddleName+"&LastName="+LastName+"&Email="+Email+"&Phone="+Phone+"&CustomerID="+CustomerID,
                                            success: function(result){
                                                if(result === "success"){
                                                    //alert(result);
                                                    var FullName = FirstName + " " + MiddleName + " " + LastName;
                                                    document.getElementById("FullNameDetail").innerHTML = FullName;
                                                    document.getElementById("PhoneNumberDetail").innerHTML = Phone;
                                                    document.getElementById("EmailDetail").innerHTML = Email;
                                                    document.getElementById("NameForLoginStatus").innerHTML = FirstName;
                                                                            
                                                }
                                                
                                            }
                                        });
                                        
                                    });
                                });
                                
                            </script>
                        </tr>
                        <tr>
                            <td>
                                <div id="ExtrasFeedbackDiv2">
                                    <p style='margin-bottom: 5px; color: #ff3333;'>Send Feedback</p>
                                    <form id="ExtrasFeedBackForm2" style="width: 95%;" >
                                            <center><div id='ExtLastReviewMessageDiv2' style='display: none; background-color: white; width: 100%;'>
                                                <p id='ExtLasReviewMessageP2' style='text-align: left; padding: 5px; color: darkgray; font-size: 13px;'></p>
                                                <p id="ExtFeedBackDate2" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td><textarea id="ExtFeedBackTxtFld2" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" style='width: 270px;'>Compose Feedback Message Here...
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='ExtFeedBackUserID2' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="ExtSendFeedBackBtn2" style="width: 100%; border: 1px solid black; background-color: pink;" type="button" value="Send" /></center>
                                            <script>
                                                    $(document).ready(function() {                        
                                                         $('#ExtSendFeedBackBtn2').click(function(event) {  

                                                             var feedback = document.getElementById("ExtFeedBackTxtFld2").value;
                                                             var CustomerID = document.getElementById("ExtFeedBackUserID2").value;

                                                             $.ajax({  
                                                             type: "POST",  
                                                             url: "SendProvCustFeedBackController",  
                                                             data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                             success: function(result){  
                                                               document.getElementById("ExtFeedBackTxtFld2").innerHTML = "Add your message here...";
                                                               document.getElementById("ExtLastReviewMessageDiv2").style.display = "block";
                                                               document.getElementById("ExtLasReviewMessageP2").innerHTML = "You've Sent: "+ "<p style='color: green; font-size: 15px;'>" +feedback+ "</p>";

                                                               $.ajax({  
                                                             type: "POST",  
                                                             url: "getCustFeedbackDate",  
                                                             data: "CustomerID="+CustomerID,  
                                                             success: function(result){  
                                                                 //alert(result);
                                                                 document.getElementById("ExtFeedBackDate2").innerHTML = result +" ";
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
                                <P>User Name: <input id="ExtraUpdateLoginNameFld2" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; text-align: center;' type='text' name='ExtUserName' value='<%=thisUserName%>'/></p>
                                <P><input id="ExtraCurrentPasswordFld2" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter Current Password' type='password' name='ExtOldPass' value=''/></p>
                                <P><input id="ExtraNewPasswordFld2" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter New Password' type='password' name='ExtNewPass' value=''/></p>
                                <P><input id="ExtraConfirmPasswordFld2" style='background-color: #eeeeee; text-align: left; color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Confirm New Password' type='password' name='ExtConfirmPass' value=''/></p>
                                <center><input id="ExtraLoginFormBtn2" style='background-color: pink; border: 1px solid black; width: 95%;' type="submit" value="Change" /></center>
                                <p id="ExtraWrongPassStatus2" style="display: none; background-color: red; color: white; text-align: center;">You have entered wrong current password</p>
                                <p id='ExtrachangeUserAccountStatus2' style='text-align: center; color: white;'></p>
                            </td>
                            <input type='hidden' id='ExtraThisPass2' value='' />
                            <input type="hidden" id="ExtraUserIDforLoginUpdate2" value="<%=UserID%>" />
                            <input type="hidden" id="ExtraUserIndexforLoginUpdate2" value="<%=UserIndex%>" />
                            <script>
                                $(document).ready(function(){
                                    $("#ExtraLoginFormBtn2").click(function(event){
                                                                
                                        var CustomerID = document.getElementById("ExtraUserIDforLoginUpdate2").value;
                                        var UserIndex = document.getElementById("ExtraUserIndexforLoginUpdate2").value;
                                        var UserName = document.getElementById("ExtraUpdateLoginNameFld2").value;
                                        var NewPassword = document.getElementById("ExtraNewPasswordFld2").value;
                                        var oldPassword = document.getElementById("ExtraCurrentPasswordFld2").value;
                                                                
                                        $.ajax({
                                            method: "POST",
                                            url: "updateLoginController",
                                            data: "CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&userName="+UserName+"&newPassword="+NewPassword+"&currentPassword="+oldPassword,
                                            success: function(result){
                                                                        
                                                //alert(result);
                                                                        
                                                if(result === "fail"){
                                                                            
                                                    document.getElementById("ExtraWrongPassStatus2").style.display = "block";
                                                    document.getElementById("ExtraCurrentPasswordFld2").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld2").style.backgroundColor = "red";
                                                    document.getElementById("ExtraCurrentPasswordFld2").style.color = "white";

                                                    //document.getElementById("changeUserAccountStatus").innerHTML = "Enter your old password correctly";
                                                    //document.getElementById("changeUserAccountStatus").style.backgroundColor = "red";
                                                    //document.getElementById("LoginFormBtn").disabled = true;
                                                    //document.getElementById("LoginFormBtn").style.backgroundColor = "darkgrey";
                                                }
                                                if(result === "success"){
                                                    document.getElementById("ExtraNewPasswordFld2").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld2").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld2").style.backgroundColor = "#eeeeee";
                                                    document.getElementById("ExtraCurrentPasswordFld2").style.color = "cadetblue";
                                                    document.getElementById("ExtraConfirmPasswordFld2").value = "";
                                                    document.getElementById("ExtraWrongPassStatus2").style.display = "none";
                                                                            
                                                    //getUserAccountNameController
                                                    $.ajax({
                                                        method: "POST",
                                                        url: "getUserAccountNameController",
                                                        data: "CustomerID="+CustomerID,
                                                                                
                                                        success: function(result){

                                                            document.getElementById("ExtraUpdateLoginNameFld2").value = result;


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
                                <form action = "LogoutController" name="LogoutForm" method="POST"> 
                                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                    <center><input style='width: 95%;' type="submit" value="Logout" class="button" /></center>
                                </form>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
                                
            <div id='ExtrasNotificationDiv2' style='display: none;'>
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Notifications</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
                    <tbody>
                        
                    <%
                       boolean isTrWhite2 = false;
                        for(int notify = 0 ; notify < Notifications.size(); notify++){
                    
                        if(!isTrWhite2){
                            
                    %>
                    
                        <tr style="background-color: #eeeeee">
                            <td>
                                <p style='text-align: left; border: 1px solid #d8d8d8; padding: 3px; font-family: helvetica; color: darkblue;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%
                                isTrWhite2 = true;
                                
                            }else{
                            
                    %>
                    
                        <tr>
                            <td>
                                <p style='text-align: left; border: 1px solid #d8d8d8; padding: 3px; font-family: helvetica; color: darkblue;'><%=Notifications.get(notify)%></p>
                            </td>
                        </tr>
                        
                    <%      
                                isTrWhite2 = false;
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
        </div>
    </div> 
        
                <!------------------------------------------------------------------------------------------------------------------>
            
            <center><h4 style="margin-top: 1px; margin-bottom: 5px; color: #000099">Your Account</h4></center>
            
                <div id="Customerprofile" style="border-bottom: 10px solid cornflowerblue; padding-top: 0;">
                    
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
                               
                               <div id="ProInfoDiv" class="proinfo" style="border-top: 0; text-align: left; padding-bottom: 5px; margin-top: 0; margin-bottom: 10px; background-color: cornflowerblue; border-right: darkblue 1px solid; border-bottom: darkblue 1px solid; padding-top: 10px;">
                                
                                <%
                                    if(Base64Pic != ""){
                                %> 
                                
                                <center><div style="background-image: url('data:image/jpg;base64,<%=Base64Pic%>'); background-size: cover; padding: 5px; margin-left: 5px; margin-right: 5px; margin-bottom: 5px;">
                                    <div style="height: 5px; background-size: cover; margin-left: 5px; margin-right: 5px; margin-bottom: 150px; background-color: #334d81;" >
                                        <center><img style="margin-top: 0; border-radius: 100%; border: 5px solid #334d81; margin-bottom: 0; background-color: darkgrey; " src="data:image/jpg;base64,<%=Base64Pic%>" width="150" height="150"/></center>
                                    </div>
                                    <div style="background-color: #334d81; height: 5px; margin-left: 5px; margin-right: 5px;">
                                    </div>
                                </div></center>
                                
                                <%
                                    } else{
                                %>
                                   
                                   <center><a href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="cursor: pointer; border-radius: 4px; background-color: pink; color: black; padding: 5px; border: solid black 1px; width: 200px; text-align: center; margin-bottom: 5px;">Add Profile Picture<p></a></center>
                                       
                                <%
                                    }
                                %>
                                
                                <center><p style='font-weight: bolder;'><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                        <span id="FullNameDetail"><%=FullName%></span></p></center>
                                
                                <center><table style="border-spacing: 1px; border-top: 1px solid darkblue;" border="0">
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
                                                <center><input id="NewAddressBtn" style="margin-top: 10px; border: 1px solid black; padding: 10px; background-color: pink; border-radius: 4px;" type="submit" value="Set Address" /></center>
                                            
                                        </form>
                                                
                                        <%
                                            }
                                            else{
                                                          
                                        %>
                                                    
                                        
                                        <form id="UpdateUserAccountForm" style="border-top: 1px solid darkblue; margin-top: 5px; display: none;
                                              padding-top: 5px;" >
                                            <center><p style="color: white; margin: 5px;">Change profile information</p></center>
                                            
                                            <center><a href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="cursor: pointer; background-color: pink; color: black; padding: 5px; border: 1px solid black; border-radius: 5px; text-align: center; width: 300px;">Change Your Profile Photo</p></a></center>
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
                                                                    
                                                                    $.ajax({
                                                                        type: "POST",
                                                                        url: "GetCustPerInfo",
                                                                        data: "CustomerID="+CustomerID,
                                                                        success: function(result){
                                                                            //alert(result);
                                                                            
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
                                                    <td><textarea id="FeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" cols="40">
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
                                                        
                                                        var feedback = document.getElementById("FeedBackTxtFld").value;
                                                        var CustomerID = document.getElementById("FeedBackUserID").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "SendProvCustFeedBackController",  
                                                        data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          document.getElementById("FeedBackTxtFld").innerHTML = "Add your message here...";
                                                          document.getElementById("LastReviewMessageDiv").style.display = "block";
                                                          document.getElementById("LasReviewMessageP").innerHTML = "You've Sent: "+ "<p style='color: green; font-size: 15px;'>" +feedback+ "</p>";
                                                          
                                                          $.ajax({  
                                                        type: "POST",  
                                                        url: "getCustFeedbackDate",  
                                                        data: "CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                            //alert(result);
                                                            document.getElementById("FeedBackDate").innerHTML = result +" ";
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
                                        
                                        <p style="border-top: 1px solid darkblue;"></p>
                                        
                                        <div style="text-align: right; margin-right: 39px; margin-top: 10px;">
                                            <div class="tooltip">
                                            <img style="margin-right: 10px; cursor: pointer;" onclick="showUserFeedBackForm()" src="icons/icons8-feedback-20.png" width="20" height="20" alt="icons8-feedback-20"/>
                                            <p class="tooltiptext">send feedback message<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="margin-right: 10px; cursor: pointer;" onclick = "showUserProfileForm()" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/><p>
                                                <p class="tooltiptext">edit your profile<br></p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p><img style="cursor: pointer;" onclick = "showSettingsDiv()" src="icons/icons8-settings-20.png" width="20" height="20" alt="icons8-settings-20"/></p>
                                                <p class="tooltiptext">change settings<br></p>
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
                                                        <center><p><input id="UpdateLoginNameFld" style="padding: 3px; background-color: cornflowerblue; color: darkblue;" placeholder="Enter New User Name Here" type="text" name="userName" value="<%=thisUserName%>" size="35" /></p></center>
                                                        
                                                        <p style="color: thistle; margin-top: 10px;">Password:</p>
                                                        <center><p><input id="CurrentPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Enter Current Password" type="password" name="currentPassword" value="" size="36" /></p>
                                                        
                                                            <p><input id="NewPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Enter New Password" type="password" name="newPassword" value="" size="36" /></p>
                                                        
                                                            <p><input id="ConfirmPasswordFld" style="padding: 3px; background-color: cornflowerblue;" placeholder="Confirm New Password" type="password" name="confirmNewPassword" value="" size="36" /></p>
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
                                                    <a href='ViewCustomerReviews.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>'><p style="cursor: pointer; color: white;"><img src="icons/icons8-popular-20 (1).png" width="20" height="20" alt="icons8-popular-20 (1)"/>
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
                                        
                                        <table id="selectCustSpttabs" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateAppTab()" id="AppointmentsTab" style="padding: 5px; cursor: pointer; border-radius: 4px; border-top: 1px solid black; width: 33.3%;">
                                                        Your Spots
                                                    </td>
                                                    <td onclick="activateHistory()" id="HistoryTab" style="padding: 5px; cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                        History
                                                    </td>
                                                    <td onclick="activateFavTab()" id="FavoritesTab" style="padding: 5px; cursor: pointer; border-radius: 4px; border: 1px solid black; background-color: cornflowerblue; width: 33.3%;">
                                                        Favorites
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        
                                <div onscroll="showselectCustSpttabs();"  class="scrolldiv" style=" height: 600px; overflow-y: auto;">
                                   
                                   <script>
                                        function showselectCustSpttabs(){
                                            document.getElementById("selectCustSpttabs").scrollIntoView();
                                        }
                                    </script>
                                        
                                <div id="serviceslist" style="padding-bottom: 0;" class="AppListDiv">
                                    
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
                                     <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
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
                                     <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
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
                                                          //alert(result);
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
                                                          //alert(result);
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
                                                                                    '<img style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
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
                                    
                                    <p style="color: tomato; margin-top: 10px; border-top: 1px solid darkgray; width: 100%; max-width: 500px;">Future Spots</p>
                                    
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
                                         <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
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
                                                          //alert(result);
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
                                                          //alert(result);
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
                                                                                    '<img style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
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
                                        
                                <div id="serviceslist" class="AppHistoryDiv" style="">
                                    
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
                                         <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>" width="40" height="40"/>
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
                                                          //alert(result);
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
                                                          //alert(result);
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
                                                          //alert(result);
                                                          if(result === "NewAdded"){
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
                                                                                    '<img style="border: 5px solid white;" src="data:image/jpg;base64,'+provProPic+'" width="150" height="150"/>' +
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
                    
                                <div id="serviceslist" style="margin-top: 0;" class="FavDiv">
                              
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
                                                          //alert(result);
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
                                    
                <form action = "LogoutController" name="LogoutForm" method="POST"> 
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <input type="submit" value="Logout" class="button" />
                </form> 
                
                </div>
                  
                                        
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                                        
    </div>
                                        
    </body>
    
    <script src="scripts/script.js"></script>
    <!--script src="scripts/checkAppointmentDateUpdate.js"></script-->
    <script src="scripts/updateUserProfile.js"></script>
    <script src="scripts/customerReviewsAndRatings.js"></script>
    <script src="scripts/SettingsDivBehaviour.js"></script>
    <script src="scripts/ChangeProfileInformationFormDiv.js"></script>
</html>
