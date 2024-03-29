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
        
        <script>
            document.cookie = "SameSite=None";
            document.cookie = "SameSite=None; Secure";
            //alert(document.cookie);
            
            var count = 0;
            var myInterval;
            
            function timerHandler() {
                count++;
           }

           // Start timer
           function startTimer() {
                myInterval = window.setInterval(timerHandler, 1000);
                //alert("started");
           }

           // Stop timer
           function stopTimer() {
               count = 0;
               window.clearInterval(myInterval);
           }
            
            window.addEventListener('focus', () => {
                if(count < 3600){
                    stopTimer();
                }else{
                    window.location.reload(true);
                    stopTimer();
                }
            });
            window.addEventListener('blur', startTimer);
            
        </script>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue  | Customer</title>
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <!--script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
        
        <!--script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script-->
        
        <!--link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"-->
        
        <!--link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css"-->
        
        <!--link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" /-->
        
        <link rel="shortcut icon" type="image/png" href="./favicon.png"/>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
    </head>
    
    <script>
        if($(window).width() > 1000){
            
            /*var jQryTmPkr = document.createElement('script');
            jQryTmPkr.setAttribute('src','//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js');
            document.head.appendChild(jQryTmPkr);*/
            
            var SlickCarousel = document.createElement('script');
            SlickCarousel.setAttribute('src','//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js');
            document.head.appendChild(SlickCarousel);
            
            var font_awesome_css = document.createElement('link');
            font_awesome_css.setAttribute('rel','stylesheet');
            font_awesome_css.setAttribute('type','text/css');
            font_awesome_css.setAttribute('href','https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css');
            document.head.appendChild(font_awesome_css);
            
            var slick_css = document.createElement('link');
            slick_css.setAttribute('rel','stylesheet');
            slick_css.setAttribute('type','text/css');
            slick_css.setAttribute('href','//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css');
            document.head.appendChild(slick_css);
            
            var slick_theme_css = document.createElement('link');
            slick_theme_css.setAttribute('rel','stylesheet');
            slick_theme_css.setAttribute('type','text/css');
            slick_theme_css.setAttribute('href','//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css');
            document.head.appendChild(slick_theme_css);
            
            var chart_js = document.createElement('script');
            chart_js.setAttribute('src','https://pagecdn.io/lib/chart/2.9.3/Chart.min.js');
            document.head.appendChild(chart_js);
            
            var chart_css = document.createElement('link');
            chart_css.setAttribute('rel','stylesheet');
            chart_css.setAttribute('type','text/css');
            chart_css.setAttribute('href','https://pagecdn.io/lib/chart/2.9.3/Chart.min.css');
            document.head.appendChild(chart_css);
            
            /*var jquery_timepicker_css = document.createElement('link');
            jquery_timepicker_css.setAttribute('rel','stylesheet');
            jquery_timepicker_css.setAttribute('type','text/css');
            jquery_timepicker_css.setAttribute('href','//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css');
            document.head.appendChild(jquery_timepicker_css);*/
            
        }
    </script>
    
    <%
        
        String GlobalUserName = "";
        String GlobalUserPassword = "";
        
        if(session.getAttribute("ThisUserName") != null && session.getAttribute("ThisUserPassword") != null){
            GlobalUserName = session.getAttribute("ThisUserName").toString();
            GlobalUserPassword = session.getAttribute("ThisUserPassword").toString();
        }
        
    %>
    
    <script>
        var GlobalUserName = '<%=GlobalUserName%>';
        var GlobalUserPassword = '<%=GlobalUserPassword%>';
        
        //check condition for in order to make sure we aren't storing empty strings or null inside of GlobalUserName and GlobalUserPassword
        if((GlobalUserName !== 'null' && GlobalUserPassword !== 'null') || (GlobalUserName !== '' && GlobalUserPassword !== '') ){
            
            
            if(window.localStorage.getItem("QueueUserName") === null && window.localStorage.getItem("QueueUserPassword") === null){
                window.localStorage.setItem("QueueUserName", GlobalUserName);
                window.localStorage.setItem("QueueUserPassword", GlobalUserPassword);
                //alert("just got set");
            }
            
        }
    </script>
        
        
    <%
        
        /*Cookie myName = new Cookie("Name","Mohammed");
        myName.setMaxAge(60*60*24); 
        response.addCookie(myName);*/
        
        //Changing some domain cookie properties
        Cookie cookie = null;
         Cookie[] cookies = null;
         
         // Get an array of Cookies associated with the this domain
         cookies = request.getCookies();
         
         String CookieText = "";
         
         if( cookies != null ) {
            
            for (int i = 0; i < cookies.length; i++) {
                
               cookie = cookies[i];
               CookieText += cookie.getName()+"="+cookie.getValue();
               
               /*if((cookie.getName()).compareTo("JSESSIONID") == 0 ) {
                  //cookie.setHttpOnly(false);
                  //cookie.setSecure(false);
                  //cookie.setMaxAge(60*60*999999999);
                  //response.addCookie(cookie);
                  
               }*/
            }
         } else {
             //JOptionPane.showMessageDialog(null, "no cookies found");
         }
         //JOptionPane.showMessageDialog(null, CookieText);
         response.setHeader("Set-Cookie", "Name=Mohammed;"+CookieText+"; HttpOnly; SameSite=None; Secure");
         //JOptionPane.showMessageDialog(null, response.getHeader("Set-Cookie"));
        
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
        String GlobalIDList = "";
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        //connection arguments
        String Url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String user = config.getServletContext().getAttribute("DBUser").toString();
        String password = config.getServletContext().getAttribute("DBPassword").toString();
        
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
        
        Date ThisDate = new Date();//default date constructor returns current date 
        String CurrentTime = ThisDate.toString().substring(11,16);
        
        //UserAccount.UserID stores UserID after Login Successfully
        //ProviderCustomerData.eachCustomer = null;
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
        boolean isIndexAttribute = false;
        boolean isUserNameAttribute = false;
        
        try{
            
            UserIndex = Integer.parseInt(request.getAttribute("UserIndex").toString());
            isIndexAttribute = true;
            JustLogged = 1;
            
        }catch(Exception e){}
        
        if(!isIndexAttribute){
            try{
                UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            }catch(Exception e){}
        }
        
        //JOptionPane.showMessageDialog(null, UserIndex);
        try{
            NewUserName = request.getAttribute("UserName").toString();
            isUserNameAttribute = true;
        }catch(Exception e){}
        
        if(!isUserNameAttribute){
            try{
                NewUserName = request.getParameter("User");
            }catch(Exception e){}
        }
        
        
       
        
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
        
        //the next six lines of code is an ettempt to fix login exceptions that occur for as user try to login after a long Idle page
        //This may have resulted from SessionID being 'null' instead of an actual string value, therefore making it incompatible with String.equals() function of the string class
        //JOptionPane.showMessageDialog(null, DatabaseSession);
        //JOptionPane.showMessageDialog(null, SessionID);
        
        if(SessionID == null){
            SessionID = "";
        }
        
        if(!SessionID.equals(DatabaseSession)){
            
            /*try{
                Class.forName(Driver);
                Connection DltSesConn = DriverManager.getConnection(Url, user, password);
                String DltSesString = "delete from QueueObjects.UserSessions where UserIndex = ?";
                PreparedStatement DltSesPst = DltSesConn.prepareStatement(DltSesString);
                DltSesPst.setInt(1, UserIndex);
                DltSesPst.executeUpdate();
            }
            catch(Exception e){}*/
            
            isSameSessionData = false;
            //response.sendRedirect("LogInPage.jsp");
        }
        
        if(!isSameSessionData || !isSameUserName || UserID == 0 || !isUserIndexInList){
            //response.sendRedirect("Queue.jsp");
    %>
        <script>
            var tempUserName = window.localStorage.getItem("QueueUserName");
            var tempUserPassword = window.localStorage.getItem("QueueUserPassword");
            (function(){
                document.location.href="LoginControllerMainRedirect?username="+tempUserName+"&password="+tempUserPassword;
                //window.location.replace("LoginControllerMain?username="+tempUserName+"&password="+tempUserPassword);
                return false;
            })();
            
        </script>
    <%
        }else if(JustLogged == 1){
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
    
    <%!
        
       class getUserDetails{
           
           //class instance fields
           private Connection conn; //connection object variable
           private ResultSet records; //Resultset object variable
           private Statement st;
           private String Driver;
           private String url;
           private String User;
           private String Password;
           private String IDList = "(";
           
           public void initializeDBParams(String driver, String url, String user, String password){
               
               this.Driver = driver;
               this.url = url;
               this.User = user;
               this.Password = password;
           }
           
           public String getIDsFromAddress(String city, String town, String zipCode){
               
               try{
                   
                   Class.forName(Driver);
                   conn = DriverManager.getConnection(url, User, Password);
                   String AddressQuery = "Select top 1000 ProviderID from QueueObjects.ProvidersAddress where City like '"+city+"%' and Town like '"+town+"%' ORDER BY NEWID()";// and Zipcode = "+zipCode;//+" ORDER BY NEWID()";
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
               
               return IDList;
               
           }
           
           public ResultSet getRecords(){
               
               try{
                    Class.forName(Driver); //registering driver class
                    conn = DriverManager.getConnection(url,User,Password); //creating a connection object
                    st = conn.createStatement();  //Creating a statement object
                    String  select = "Select top 10 * from QueueServiceProviders.ProviderInfo where (Ratings = 5 or Ratings = 4) and Provider_ID in "+ IDList + " ORDER BY NEWID()"; //SQL query string
                    records = st.executeQuery(select); //execute Query

               }
               catch(Exception e){
                  e.printStackTrace();
                }
               
                return records;
            }
       }
       
    %>
    
    <%
            
            getUserDetails details = new getUserDetails();
            details.initializeDBParams(Driver, Url, user, password);
            GlobalIDList = details.getIDsFromAddress(PCity, PTown, "");
            //System.out.println(GlobalIDList);
            
            ArrayList <ProviderInfo> providersList = new ArrayList<>();
            ResultSet rows = details.getRecords();
            
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
    
    <body onload="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';" id="CustomerPageHtmlBody">
        
        <div id='JumbotromBg' class="notShownOnMobile" style="width: 100vw; height: 800px; position: fixed; top: 0px; z-index: -1; background-color: white;"></div>
        
        <script>
            
            var GoogleReturnedZipCode;
            var GoogleReturnedCity;
            var GoogleReturnedTown;
            var GoogleReturnedStreetName;
            var GoogleReturnedStreetNo;
            var GoogleReturnedCountry;
            var formatted_address;
            var GoogleReached = false;
            
            var StateAbbrev = {
                "AL": "Alabama",
                "AK": "Alaska",
                "AZ": "Arizona",
                "AR": "Arkansas",
                "CA": "California",
                "CO": "Colorado",
                "CT": "Connecticut",
                "DE": "Delaware",
                "FL": "Florida",
                "GA": "Georgia",
                "HI": "Hawaii",
                "ID": "Idaho",
                "IL": "Illinois",
                "IN": "Indiana",
                "IA": "Iowa",
                "KS": "Kansas",
                "KY": "Kentucky",
                "LA": "Louisiana",
                "ME": "Maine",
                "MD": "Maryland",
                "MA": "Massachusetts",
                "MI": "Michigan",
                "MN": "Minnesota",
                "MS": "Mississippi",
                "MO": "Missouri",
                "MT": "Montana",
                "NE": "Nebraska",
                "NV": "Nevada",
                "NH": "New Hampshire",
                "NJ": "New Jersey",
                "NM": "New Mexico",
                "NY": "New York",
                "NC": "North Carolina",
                "ND": "North Dakota",
                "OH": "Ohio",
                "OK": "Oklahoma",
                "OR": "Oregon",
                "PA": "Pennsylvania",
                "RI": "Rhode Island",
                "SC": "South Carolina",
                'SD': "South Dakota",
                "TN": "Tennessee",
                "TX": "Texas",
                "UT": "Utah",
                "VT": "Vermont",
                "VA": "Virginia",
                "WA": "Washington",
                "WV": "West Virginia",
                "WI": "Wisconsin",
                "WY": "Wyoming"
            };
            
            function GetGoogleMapsJSON(lat, long){
                    
                    $.ajax({
                        type: "GET",
                        data: 'latlng=' + lat + ',' + long + '&sensor=true&key=AIzaSyAoltHbe0FsMkNbMCAbY5dRYBjxwkdSVQQ',
                        url: 'https://maps.googleapis.com/maps/api/geocode/json',
                        success: function(result){

                            let AddressParts = result.results[0].formatted_address.split(",");
                            let CityZipCodeParts = AddressParts[2].split(" ");
                            let StreetParts = AddressParts[0].split(" ");
                            
                            let city = CityZipCodeParts[1].trim();
                            GoogleReturnedTown = AddressParts[1].trim();
                            if(GoogleReturnedTown === "The Bronx")
                                GoogleReturnedTown = "Bronx";
                            GoogleReturnedCity = StateAbbrev[city].trim();
                            GoogleReturnedZipCode = CityZipCodeParts[2].trim();
                            GoogleReturnedStreetName = StreetParts.slice(1, (StreetParts.length));
                            GoogleReturnedStreetName = GoogleReturnedStreetName.toString().replace("," , " ");
                            GoogleReturnedStreetName = GoogleReturnedStreetName.trim();
                            GoogleReturnedStreetNo = StreetParts[0].trim();
                            GoogleReturnedCountry = AddressParts[3].trim();
                            addLocationToWebContext();
                            formatted_address = result.results[0].formatted_address;

                        }
                    });
                    
                    
                }

            function showPosition(position){
                GetGoogleMapsJSON(position.coords.latitude, position.coords.longitude);
                GoogleReached = true;
            }
            
            function locationErrorHandling(error){
            }
            
            var locationOptions = {
                
                enableHighAccuracy: true, 
                maximumAge        : 30000, 
                timeout           : 27000
            
            };
            
            function getLocation(){
                if (navigator.geolocation){
                    
                  var watchID = navigator.geolocation.watchPosition(showPosition, locationErrorHandling, locationOptions);

                }else{ 
                    alert("Location is not supported by this browser.");
                }
            }
            
            getLocation();
            
        </script>
        
        <script>
            function addLocationToWebContext(){
                
                  $.ajax({
                      type: "POST",
                      data: "city="+GoogleReturnedCity+"&town="+GoogleReturnedTown+"&zipcode="+GoogleReturnedZipCode,
                      url: "./addLocationDataToWebContext",
                      success: function(result){
                          //alert("Location added!");
                      }
                  });
                  
            }
            
        </script>
        
        <div id="MainProviderCustomerPagePageLoader" class="QueueLoader">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="ExploreLoading" class="QueueLoader">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="SpotsLoading" class="QueueLoader">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="UserProfileLoading" class="QueueLoader">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="FavoritesLoading" class="QueueLoader"  style="display: none;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="SearchLoading" class="QueueLoader">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="PermanentDiv" style="">
            
            <div style="margin-top: 3px; margin-right: 10px; width: fit-content; display: flex;">
                
                <p style="color: white; text-align: justify;">
                    <i style='' class='fa fa-phone'></i>
                    +1 732-799-9546
                    <br />
                    <i class='fa fa-envelope'></i>
                    support@theomotech.com   
                </p>
            </div>
            
            <div id="ExtraDivSearch" style='padding: 3px; margin-right: 20px; margin-left: 20px; margin-top: 1.2px; border-radius: 4px;'>
                <form action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; font-weight: bolder; border-radius: 4px;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; border-radius: 4px; background-color: cadetblue; color: white; padding: 5px 7px; font-size: 15px;" 
                            type="submit" value="Search" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"/>
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <input type='hidden' name='User' value='<%=NewUserName%>' />
                </form>
            </div>
            
            <div style="display: flex;">
                
                <ul style="margin-right: 5px;">
                <textarea style="display: none;" id="NotiIDInput" rows="4" cols="20"><%=NotiIDs%>
                </textarea>
                    <li class="active" onclick="showCustExtraNotification();" id='PermDivNotiBtn' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-notification-50.png" width="20" height="17" alt="icons8-notification-50"/-->
                        <i class="fa fa-bell"></i>
                        Notifications<sup id="notiCounterSup" style='color: lawngreen; padding-right: 2px;'> <%=notiCounter%></sup></li>
                    <li class="active" onclick='showCustExtraCal();' id='PermDivCalBtn' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/-->
                        <i class="fa fa-calendar"></i>
                        Calender</li>
                    <li class="active" onclick='showCustExtraUsrAcnt();' id='PermDivUserBtn' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/-->
                        <i class="fa fa-cog"></i>
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
                    
                    
                <a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" href='CustomerSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=3'>
                    <div id="middleScreenSettingsBtn" style='margin-right: 5px; cursor: pointer; text-align: center; float: right; margin-right: 10px; width: fit-content; background-color: #eeeeee; padding: 2px; border-radius: 4px;'>
                        <img style='border-radius: 2px;' src="icons/icons8-settings-50.png" width="23" height="22" alt="icons8-settings-50"/>
                        <p style='font-size: 11px; margin-top: -2px; color: black;'>Settings</p>
                    </div></a>
            
                <a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" href='NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-newspaper-o"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">News</span></p>
                    </div>
                </a>
                
                <div style="margin-left: 10px;">
                <%
                    if(Base64Pic != ""){
                %>
                    <center><div style="width: 100%; text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                            <div style="width: 30px; height: 30px; border-radius: 100%; margin-bottom: 20px; position: absolute; overflow: hidden;">
                                <img id="" style="width: 30px; height: auto; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64Pic%>"/>
                            </div>
                    </div></center>
                <%
                    }else{
                %>
                    <div style="text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                        <i style="font-size: 34px; color: darkgrey;" class="fa fa-user-circle" aria-hidden="true"></i>
                    </div>
                
                <%}%>
                </div>
            
                </div>
            </div>
        
        <div id="PermanentDiv1" style="display:none;">
           
        </div>
                
        <div id='ExtraDropDwnDiv'>  
            <table id='ExtraDropDown' style='display: none; z-index: 120; background-color: white; margin-top: 40px; position: fixed;  box-shadow: 4px 4px 4px #2c3539;'>
                <tbody>
                    <tr>
                        <td onclick="showCustExtraNews();" id='' style='cursor: pointer; background-color: #334d81; color: white; padding: 5px;'>
                            <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="20" height="17" alt="icons8-google-news-50"/>
                            News
                        </td>
                    </tr>
                    <tr>
                        <td onclick="showCustExtraNotification2();" id='PermDivNotiBtn2' style='cursor: pointer; background-color: #334d81; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-notification-50.png" width="20" height="17" alt="icons8-notification-50"/>
                            Notifications<sup id='notiCounterSup2' style='color: red; background-color: white; padding-right: 2px;'> <%=notiCounter%></sup>
                        </td>
                    </tr>
                    <tr>
                        <td onclick='showCustExtraCal2();' id='' style='cursor: pointer; background-color: #334d81; color: white; padding: 5px'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                            Calender</td>
                    </tr>
                    <tr>
                        <td onclick='showCustExtraUsrAcnt2();' id='' style='cursor: pointer; background-color: #334d81; color: white; padding: 5px;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
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
                        <li onclick="scrollToTop()"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <div>
                        <input id="MiniNavSearchBox" style="padding: 5px;" placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                        <input type='hidden' name='User' value='<%=NewUserName%>' />
                        <input style="background-color: darkslateblue; color: white; border: none;" type="button" value="Search" />
                    </div>
                    <script>
                        function SearchFromMiniNav(){
                            document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                            
                            $("#SpotsIframe").hide("slide", { direction: "right" }, 100);
                            $(".UserProfileContainer").hide("slide", { direction: "right" }, 100);
                            $("#ExploreDiv").hide("slide", { direction: "right" }, 100);
                            $("#FavoritesIframe").hide("slide", { direction: "right" }, 100);
                            $("#SearchIframe").show("slide", { direction: "left" }, 100);
                            document.getElementById("SearchIframe").style.display = "block";
                            
                            var SearchString = document.getElementById("MiniNavSearchBox").value;
                            
                            document.getElementById("SearchIframe").src = "QueueSelectBusinessSearchResultLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>&SearchFld="+SearchString;
                            
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                            setTimeout(function(){
                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                            }, 2000);
                        }
                        
                    </script>
                </center>
            </div>
            
        <div id="header" style="display: none;" class="CustomerPageHeader">
            
            <center><p> </p></center>
            <center><img id="DashboardLogo" src="QueueLogo.png" style="margin-top: 5px;" /></center>
            
        </div>
                            
        <div id="MobileHeader">
            
            <div style="width: 40px; height: 36px; float: left; margin-left: 3px;">
                <div class='MenuIcon' style=''>
                    <a id="nav-toggle" href="#"><span></span></a>
                </div>
            </div>
            
            <center><p> </p></center>
            <div id="showUploadPhotoBtn">
            <%
                if(Base64Pic != ""){
            %>
                    <div style="overflow: hidden; border-radius: 100%; float: right; background-color: darkgray; width: 36px; height: 36px; margin-right: 3px; margin-top: 3px; margin-bottom: 3px;">
                        <img style="width: 36px; height: auto;" src="data:image/jpg;base64,<%=Base64Pic%>"/>
                    </div>
            <%
                }else{
            %>
                    <img class="fittedImg" style="border-radius: 100%; float: right; width: 36px; height: 36px; margin-right: 3px; margin-top: 3px; margin-bottom: 3px; background-color: #eeeeee;" src="icons/NoProPicAvatar.png" alt="No Proile Picture Avatar"/>
            <%
                }
            %>
            </div>
            <center><img id="MobileDashboardLogo" src="QueueLogo.png" style="" /></center>
            
            <p style="clear: both;"></p>
        </div>
       <div id="main_body_flex">  
           
        <div id="Extras" style="float: none;">
            
            <div id="News">
            
            <div id="ExtrasInnerContainer">
                <%
                    int newsItems = 0;
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(Url, user, password);
                        String newsQuery = "Select top 1 * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
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
                            String ServiceType = "";
                            
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
                                        
                                        ServiceType = ProvRec.getString("Service_Type").trim();
                                            
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

                                        }catch(Exception e){}
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
                
                <a href="./NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>">
                    <p style="padding: 10px 0; color: #44484a; font-weight: bolder; margin: auto; width: fit-content;">
                        <i style="margin-right: 5px;" class="fa fa-newspaper-o"></i>
                        Click here to see more ads
                    </p>
                </a>
                
                
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
                                                    <div style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; overflow: hidden;">    
                                                        <img id="" style="background-color: darkgray; width:35px; height: auto;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    </div>
                                                <%
                                                    }else{
                                                %>
                                                    <img style='margin: 4px; width:35px; height: 35px; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <b>
                                                    <a href="EachSelectedProvider.jsp?UserID=<%=ProvID%>">
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
            
            <%
                if(newsItems == 0){
            %>

                <p style="font-weight: bolder; margin-top: 50px; text-align: center;"><i class="fa fa-exclamation-triangle" style="color: orange;"></i> No news items found at this time</p>

            <%
                }
            %>
            
                <div class='eachCSecFlex marginUp20' style='width: 100%; margin-top: 10px;'>
                    <h1>Our businesses keep you posted</h1>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding-top: 20px;
                           display: flex; justify-content: flex-end; flex-direction: column;'>
                        <p style='text-align: center;'><img src='NewsPic.png'  style='width: 80px; height: 80px'/></p>
                        <p style='color: #37a0f5; padding: 5px;'>Our integrated news feed feature lets businesses post regular ads to keep you informed</p>
                    </div>
                </div>
            
            </div>
            
            <div id='Calender' style='display: none;'>
                <table  id="ExtrasTab" cellspacing="0" style="width: 100%;">
                    <tbody>
                        <tr style="background-color: #eeeeee">
                            <td>
                                <div id="DateChooserDiv" style=''>
                                    <p style='margin: 10px 0; color: #3d6999; font-weight: bolder;'>
                                    <i style='margin-right: 5px; color: #334d81;' class="fa fa-calendar" aria-hidden="true"></i>Pick a date below</p>
                                    <% SimpleDateFormat CalDateFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");%>
                                    <p style='text-align: center;'><input id="CalDatePicker" style='cursor: pointer; width: 90%; 
                                                                        border: #3d6999 1px solid;  font-weight: bolder; background-color: #06adad; color: white; padding: 10px 5px;' type="button" name="CalDateVal" 
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
                            <div style='padding: 10px; border-radius: 4px;'>
                                    <div onclick="showEventsTr();" id='EventsTrBtn' style='cursor: pointer; border-radius: 4px; 
                                         font-weight: bolder; border: 0; padding: 5px; color: black; width: 40%; float: right;'>
                                        Events</div>
                                    <div onclick="showAppointmentsTr();" id='AppointmentsTrBtn' style='color: darkgrey; font-weight: bolder;
                                         cursor: pointer; border-radius: 4px; border: 0; padding: 5px; width: 45%; float: left;'>
                                        Appointments</div>
                                    <p style='clear: both;'></p>
                            </div>
                            <td style=''>
                                <p style='margin-bottom: 5px; color: #626b9e; font-weight: bolder;'><i class='fa fa-calendar-check-o' style="margin-right: 5px; color: #334d81; "aria-hidden='true'></i>Appointments</p>
                                
                                <input type="hidden" id="CalApptUserID" value="<%=UserID%>" />
                                
                                <div id='CalApptListDiv' style='height: 244px; overflow-y: auto;'>
                                    
                                    <%
                                        int count = 1;
                                        
                                        for(int aptNum = 0; aptNum < AppointmentListExtra.size(); aptNum++ ){
                                            
                                            int AptID = AppointmentListExtra.get(aptNum).getAppointmentID();
                                            String ProvName = AppointmentListExtra.get(aptNum).getProviderName();
                                            String ProvComp = AppointmentListExtra.get(aptNum).getProviderCompany();
                                            /*if(ProvComp.length() > 13)
                                                ProvComp = ProvComp.substring(0, 12) + "...";*/
                                            String AptTime = AppointmentListExtra.get(aptNum).getTimeOfAppointment();
                                            if(AptTime.length() > 5)
                                                AptTime = AptTime.substring(0,5);
                                    %>
                                    
                                    <p style="margin-top: 10px; margin-bottom: 5px; color: #334d81; font-weight: bolder; width: 100%;">
                                        <%=ProvName%>
                                        <span style="color: #888; text-align: right;">
                                            <i class='fa fa-clock-o' style='margin-right: 5px; margin-left: 10px; color: #06adad;'></i>
                                            <%=AptTime%>
                                        </span>
                                    </p>
                                    <p style="color: #888; margin-bottom: 20px;"><%=ProvComp%></p>
                                    
                                        
                                    
                                    <%
                                            count++;
                                        }
                                    %>
                                    
                                    <script>
                                        var updtCounter = 0;
                                        
                                        $(document).ready(function(){
                                            
                                            $("#CalDatePicker").change(function(event){
                                                
                                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                var date = document.getElementById("CalDatePicker").value;
                                                var CustomerID = document.getElementById("CalApptUserID").value;
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetApptForExtra",
                                                    data: "Date="+date+"&CustomerID="+CustomerID,
                                                    success: function(result){
                                                        
                                                        var ApptData = JSON.parse(result);
                                                        
                                                        var aDiv = document.createElement('div');
                                                        
                                                        for(i in ApptData.Data){
                                                            
                                                            var name = ApptData.Data[i].ProvName;
                                                            var comp = ApptData.Data[i].ProvComp;
                                                            
                                                            var time = "" + ApptData.Data[i].ApptTime;
                                                            
                                                            aDiv.innerHTML += 
                                                                '<p style="margin-top: 10px; margin-bottom: 5px; color: #334d81; font-weight: bolder; width: 100%;">'
                                                                    +name+
                                                                    '<span style="color: #888; text-align: right;">' +
                                                                    '<i class="fa fa-clock-o" style="margin-right: 5px; margin-left: 10px; color: #06adad;"></i>'
                                                                    +time+
                                                                    '</span>'+
                                                                '</p>'+
                                                                '<p style="color: #888; margin-bottom: 20px;">'+comp+'</p>';
                                                            
                                                        };
                                                        
                                                        document.getElementById("CalApptListDiv").innerHTML = aDiv.innerHTML;
                                                        
                                                    }
                                                    
                                                });
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetCustEvntAjax",
                                                    data: "Date="+date+"&CustomerID="+CustomerID,
                                                    success: function(result){
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                                                    'style="cursor: pointer; margin: 10px 0; padding: 2px;">' +
                                                                    '<p><span style="font-weight: bolder; color: #334d81; font-size: 15px;">'+Title+'</p>' +
                                                                    '<p style="font-size: 11px;"><i class="fa fa-calendar" style="color: #06adad; margin-right: 5px;" aria-hidden="true"></i>' +
                                                                        '<span style="color: darkblue;font-size: 11px;">'+Date+'</span>' +
                                                                        '<i class="fa fa-clock-o" style="color: #06adad; margin-right: 5px; margin-left: 10px;" aria-hidden="true"></i>' +
                                                                        '<span style="color: darkblue; font-size: 11px;">'+Time+'</span></p>' +
                                                                    '<p style="color: #888; margin-top: 5px;">'+Desc+'</p>' +
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
                                
                                <p style='margin-bottom: 5px; color: #626b9e; font-weight: bolder;'><i class='fa fa-calendar-check-o' style="margin-right: 5px; color: #334d81; "aria-hidden='true'></i>Events</p>
                                
                                <div id='EventsListDiv' style='height: 244px; overflow-y: auto;'>
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
                                                    style="cursor: pointer; margin: 10px 0; padding: 2px;">
                                                    
                                                    <p><span style="font-weight: bolder; color: #334d81; font-size: 15px;"><%=EventTitle%></p>
                                                    <p style="font-size: 11px;"><i class="fa fa-calendar" style="color: #06adad; margin-right: 5px;" aria-hidden="true"></i>
                                                        <span style="color: darkblue;font-size: 11px;"><%=EventDate%></span>
                                                        <i class="fa fa-clock-o" style="color: #06adad; margin-right: 5px; margin-left: 10px;" aria-hidden="true"></i>
                                                        <span style="color: darkblue; font-size: 11px;"><%=EventTime%></span></p>
                                                    <p style="color: #888; margin-top: 5px;"><%=EventDesc%></p>
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
                                <p style='margin: 10px 0; color: #3d6999; font-weight: bolder;'>
                                    <i style='margin-right: 5px; color: #334d81;' class="fa fa-calendar-plus-o" aria-hidden="true"></i>Add/Change Event</p>
                                <div style="height: auto; overflow-y: auto;">
                                    <p><input placeholder="time" id="DisplayedAddEvntTime" style='padding: 10px 0; border: 1px solid darkgrey; cursor: pointer; background-color: white; width: 92%;' type="text" name="" value="" readonly onkeydown="return false"/></p>
                                    <input id="AddEvntTime" style='background-color: white;' type="hidden" name="EvntTime" value="" />
                                    <p><input placeholder="date" id='EvntDatePicker' style='padding: 10px 0; cursor: pointer;  border: 1px solid darkgrey; background-color: white; width: 92%;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p><input placeholder="title" id="AddEvntTtle" style=' border: 1px solid darkgrey; padding: 10px 0; background-color: white; width: 92%;' type="text" name="EvntTitle" value="" /></p>
                                    <p style="margin-top: 10px; margin-bottom: 5px; color: #334d81; font-weight: bolder;">
                                        Description
                                    </p>
                                    <p>
                                        <textarea onfocusout="checkEmptyEvntDesc();" id="AddEvntDesc" name="EvntDesc" rows="7" style='width: 98%;'>
                                        </textarea></p>
                                </div>
                            </td>
                            
                            <script>
                        
                                document.getElementById("AddEvntDesc").value = "";
                                
                                function checkEmptyEvntDesc(){
                                    /*if(document.getElementById("AddEvntDesc").value === "")
                                        document.getElementById("AddEvntDesc").value = "Add event description here...";*/
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

                        </script>
                            
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <input type="hidden" id="EvntIDFld" value=""/>
                                <input id="CalSaveEvntBtn" style='cursor: pointer; float: left; border: 0; color: white; background-color: darkslateblue; padding: 10px 5px; border-radius: 4px; width: 95%;' type='button' value='Save' /></center>
                                <input onclick="" id="CalDltEvntBtn" style='cursor: pointer; float: right; display: none; border: 0; color: white; background-color: darkslateblue; padding: 10px 5px; border-radius: 4px; width: 47%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate();" id="CalUpdateEvntBtn" style='cursor: pointer; display: none; border: 0; color: white; padding: 10px 5px; background-color: darkslateblue; border-radius: 4px; width: 47%;' type='button' value='Change' />
                            </td>
                        </tr>
                        
                        <script>
                            $(document).ready(function(){
                                
                                $("#CalDltEvntBtn").click(function(event){
                                    
                                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                    var EventID = document.getElementById("EvntIDFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            
                                            document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                            
                                            if(result === "success"){
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
                                
                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                
                                var EvntTtle = document.getElementById("AddEvntTtle").value;
                                EvntTtle = EvntTtle.replace("\"","");
                                var EvntDesc = document.getElementById("AddEvntDesc").value;
                                EvntDesc = EvntDesc.replace("\"","");
                                var EvntDate = document.getElementById("EvntDatePicker").value;
                                var EvntTime = document.getElementById("AddEvntTime").value;
                                var EvntId = document.getElementById("EvntIDFld").value;
                                
                                var CalDate = document.getElementById("CalDatePicker").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "UpdateEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&EventID="+EvntId,
                                        success: function(result){
                                            
                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                           alert("Event Updated Successfully");
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter = parseInt(updateCounter, 10) + 1;
                                                document.getElementById("EventsListDiv").innerHTML += '<div id="updt'+updateCounter+'" ' +
                                                    'onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' +
                                                        'style="cursor: pointer; margin: 10px 0; padding: 2px;">' +
                                                            '<p><span style="font-weight: bolder; color: #334d81; font-size: 15px;">'+EvntTtle+'</p>' +
                                                            '<p style="font-size: 11px;"><i class="fa fa-calendar" style="color: #06adad; margin-right: 5px;" aria-hidden="true"></i>' +
                                                                '<span style="color: darkblue;font-size: 11px;">'+EvntDate+'</span>' +
                                                                '<i class="fa fa-clock-o" style="color: #06adad; margin-right: 5px; margin-left: 10px;" aria-hidden="true"></i>' +
                                                                '<span style="color: darkblue; font-size: 11px;">'+EvntTime+'</span></p>' +
                                                            '<p style="color: #888; margin-top: 5px;">'+EvntDesc+'</p>' +
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
                                    
                                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                    
                                    var EvntTtle = document.getElementById("AddEvntTtle").value;
                                    EvntTtle = EvntTtle.replace("\"","");
                                    var EvntDesc = document.getElementById("AddEvntDesc").value;
                                    EvntDesc = EvntDesc.replace("\"","");
                                    var EvntDate = document.getElementById("EvntDatePicker").value;
                                    var EvntTime = document.getElementById("AddEvntTime").value;
                                    
                                    var CalDate = document.getElementById("CalDatePicker").value;
                                    
                                    var CustID = document.getElementById("CalApptUserID").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "AddEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&CustomerID="+CustID,
                                        success: function(result){
                                            
                                            alert("Event Added Successufuly");
                                            
                                            document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                            
                                            var Evnt = JSON.parse(result);
                                            
                                            if(Evnt.JQDate === EvntDate){
                                                updateCounter = parseInt(updateCounter, 10) + 1;
                                                document.getElementById("EventsListDiv").innerHTML += '<div id="updt'+updateCounter+'" ' +
                                                    'onclick=\'updateEvent("'+Evnt.EvntID+'", "'+EvntTtle.replace("'","")+'","'+EvntDesc.replace("'","")+'", "'+EvntDate+'","' +EvntTime+'", "updt'+updateCounter+'");\' ' +
                                                    'style="cursor: pointer; margin: 10px 0; padding: 2px;">' +
                                                        '<p><span style="font-weight: bolder; color: #334d81; font-size: 15px;">'+EvntTtle+'</p>' +
                                                        '<p style="font-size: 11px;"><i class="fa fa-calendar" style="color: #06adad; margin-right: 5px;" aria-hidden="true"></i>' +
                                                            '<span style="color: darkblue;font-size: 11px;">'+EvntDate+'</span>' +
                                                            '<i class="fa fa-clock-o" style="color: #06adad; margin-right: 5px; margin-left: 10px;" aria-hidden="true"></i>' +
                                                            '<span style="color: darkblue; font-size: 11px;">'+EvntTime+'</span></p>' +
                                                        '<p style="color: #888; margin-top: 5px;">'+EvntDesc+'</p>' +
                                                '</div>';
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
                             
        <div id='ExtrasUserAccountDiv' style='display: none;'>
            
                <table  id="ExtrasTab" style="width: 100%;" cellspacing="0">
                    <tbody>
                        <tr style="">
                            <td>
                                <div style="background-color: #9bb1d0; border-radius: 4px; padding: 15px 10px; border: #3d6999 1px solid; margin: auto;">
                                <input type='hidden' id='ExtraUpdPerUserID' value='<%=UserID%>' />
                                <p style='margin-bottom: 10px; color: #334d81; font-weight: bolder;'>Edit Your Personal Info</p>
                                <p>First: <input id='fNameExtraFld' style='background-color: #9bb1d0; padding: 10px 0; border: 0; text-align: left; color: white;' type="text" name="ExtfName" value="<%=FirstName%>" /></p>
                                <p>Middle: <input id='mNameExtraFld' style='background-color: #9bb1d0; border: 0; padding: 10px 0; text-align: left; color: white;' type="text" name="ExtmName" value="<%=MiddleName%>" /></p>
                                <p>Last: <input id='lNameExtraFld' style='background-color: #9bb1d0; padding: 10px 0; border: 0; text-align: left; color: white;' type="text" name="ExtlName" value="<%=LastName%>" /></p>
                                <p>Email: <input id='EmailExtraFld' style='background-color: #9bb1d0; padding: 10px 0; border: 0; text-align: left; color: white;' type="text" name="ExtEmail" value="<%=Email%>" /></p>
                                <p>Phone: <input id='PhoneExtraFld' style='background-color: #9bb1d0; padding: 10px 0; border: 0; text-align: left; color: white;' type="text" name="EvntTime" value="<%=PhoneNumber%>" /></p>
                                <center><input id='UpdtPerInfExtraBtn' style='background-color: darkslateblue; border-radius: 4px; border:0; padding: 10px; min-width: 150px; color: white; width: 95%;' type="submit" value="Change" /></center>
                                </div>
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
                                        UpdtPerInfExtraBtn.style.backgroundColor = "darkslateblue";
                                        UpdtPerInfExtraBtn.disabled = false;
                                    }
                                    
                                }, 1);
                                
                            </script>
                            
                            <script>
                                $(document).ready(function(){
                                    $("#UpdtPerInfExtraBtn").click(function(){
                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
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
                                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                if(result === "success"){
                                                    alert("Update Successful");
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
                                <div id="ExtrasFeedbackDiv" style="background-color: #9bb1d0; border-radius: 4px; padding: 15px 10px; border: #3d6999 1px solid; margin: auto;">
                                    <p style='margin-bottom: 10px; color: #334d81; font-weight: bolder;'>Send Feedback</p>
                                    <form id="ExtrasFeedBackForm" style="width: 99%;" >
                                        <center><div id='ExtLastReviewMessageDiv' style='display: none; padding: 10px; border-radius: 4px; border: #626b9e 1px solid; background-color: white; max-width: 400px; margin-bottom: 10px;'>
                                                    <p style="font-weight: bolder; color: #334d81; margin-bottom: 15px; text-align: center;">Thanks for your feedback!</p>
                                                    <p id='ExtLasReviewMessageP' style='text-align: left; padding: 10px 5px; color: darkgray; font-size: 13px;'></p>
                                                    <p id="ExtFeedBackDate" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table>
                                                <tbody>
                                                <tr>
                                                    <td><textarea id="ExtFeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" style='width: 200px; border-radius: 5px; background-color: #d9e8e8;'>Compose Feedback Message Here...
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='ExtFeedBackUserID' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="ExtSendFeedBackBtn" style="width: 98%; border: 0;padding: 10px; border-radius: 4px; min-width: 150px; background-color: darkslateblue; color: white;" type="button" value="Send" /></center>
                                                <script>
                                                    $(document).ready(function() {                        
                                                         $('#ExtSendFeedBackBtn').click(function(event) {  
                                                             
                                                             document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                             
                                                             var feedback = document.getElementById("ExtFeedBackTxtFld").value;
                                                             var CustomerID = document.getElementById("ExtFeedBackUserID").value;

                                                             $.ajax({  
                                                             type: "POST",  
                                                             url: "SendProvCustFeedBackController",  
                                                             data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                             success: function(result){ 
                                                               alert(result);
                                                               document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                        <tr style=''>
                            <td>
                                <div style="background-color: #9bb1d0; border-radius: 4px; padding: 15px 10px; border: #3d6999 1px solid; margin: auto;">
                                <p style='margin-bottom: 15px; color: #334d81; font-weight: bolder;'>Update Your Login</p>
                                <P>User:
                                    <input id="ExtraUpdateLoginNameFld" style='background-color: #d9e8e8; text-align: left; padding: 10px 0;
                                           color: cadetblue; font-weight: bolder; text-align: center;' type='text' name='ExtUserName' value='<%=thisUserName%>'/></p>
                                <P>
                                    <input id="ExtraCurrentPasswordFld" style='background-color: #d9e8e8; text-align: left; padding: 10px 0;
                                           color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter Current Password' type='password' name='ExtOldPass' value=''/></p>
                                <P>
                                    <input id="ExtraNewPasswordFld" style='background-color: #d9e8e8; text-align: left; padding: 10px 0;
                                           color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Enter New Password' type='password' name='ExtNewPass' value=''/></p>
                                <P>
                                    <input id="ExtraConfirmPasswordFld" style='background-color: #d9e8e8; text-align: left; padding: 10px 0;
                                           color: cadetblue; font-weight: bolder; width: 95%; text-align: center;' placeholder='Confirm New Password' type='password' name='ExtConfirmPass' value=''/></p>
                                <center><input id="ExtraLoginFormBtn" style='background-color: darkslateblue; padding: 5px; border-radius: 4px; color: white; border: 0; width: 95%; padding: 10px;' type="submit" value="Change" /></center>
                                <p id="ExtraWrongPassStatus" style="padding: 10px 0; display: none; background-color: red; color: white; text-align: center;">You have entered wrong current password</p>
                                <p id='ExtrachangeUserAccountStatus' style='padding: 10px 0; text-align: center; color: white;'></p>
                                </div>
                            </td>
                            <input type='hidden' id='ExtraThisPass' value='' />
                            <input type="hidden" id="ExtraUserIDforLoginUpdate" value="<%=UserID%>" />
                            <input type="hidden" id="ExtraUserIndexforLoginUpdate" value="<%=UserIndex%>" />
                            <script>
                                $(document).ready(function(){
                                    $("#ExtraLoginFormBtn").click(function(event){
                                                                
                                       document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';       
                                                        
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
                                                                
                                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                
                                                if(result === "fail"){
                                                                            
                                                    document.getElementById("ExtraWrongPassStatus").style.display = "block";
                                                    document.getElementById("ExtraCurrentPasswordFld").value = "";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.backgroundColor = "red";
                                                    document.getElementById("ExtraCurrentPasswordFld").style.color = "white";

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
                                                    alert("Update Successful");
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
                                    <center><input style='width: 95%;' type="submit" value="Logout" class="button" onclick="LogoutMethod()"/></center>
                                </form>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
                                
            <div id='ExtrasNotificationDiv' style='display: none;'>
            
            <div>
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
                        
                    </tbody>
                </table>
                        
            </div>
                    
            </div>
        </div>
            
            
        <div class="DashboardContent" id="">
            <div id='PhoneNotiBar' style='cursor: pointer; background-color: #6699ff; padding-top: 2px; width: 100%; position: relative;'>
                
                    <div class='MainMenu'>
                        <div id='MainMenuCover'></div>
                        <div id="MainMenuItems">
                        <table id="MainMenuItemsTable">
                            
                        </table>
                        <div id="MenuSummaries">
                            <h4 style="text-align: center; color: darkblue;">Summaries</h4>
                            <div style='margin-top: 10px;'>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <img src="icons/icons8-marker-filled-30_1.png" style='width: 20px; height: 20px;' alt=""/>
                                            </td>
                                            <td id='MainMenuAddressDisplay' style='font-size: 14px;'>
                                            <script>
                                                let MainMenuLocDisplay = setInterval(function(){
                                                    document.getElementById("MainMenuAddressDisplay").innerHTML = formatted_address;
                                                    if(formatted_address !== undefined){
                                                        //alert("Menu Loc Disp Stopped");
                                                        clearInterval(MainMenuLocDisplay);
                                                    }
                                                },1);
                                            </script>
                                            </td>
                                            <td>
                                                
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        </div>
                    </div>
                
                <script>
                    if(document.querySelector(".MainMenu")){
                        document.querySelector(".MainMenu").style.display = "none";
                    }
                    function ToggleMenuDisplay() {
                        document.querySelector( "#nav-toggle" ).classList.toggle( "active" );
                        var MenuDisplay = document.querySelector(".MainMenu").style.display;

                        if(MenuDisplay === "none"){
                            $(".MainMenu").show("slide", { direction: "left" }, 100);
                        }else{
                            $(".MainMenu").hide("slide", { direction: "left" }, 100);
                        }
                    }
                    function hideExtraDropDown() {
                        document.getElementById("ExtraDropDown").style.display = "none";
                    }
                    $(".MenuIcon").click(function(event){
                        ToggleMenuDisplay();
                    });
                    
                </script>
                    
                    </div>
                        
            <center><div id="ExploreAndAccountButtons" style="background-color: white;">
                    <div onclick="showDashboardExplore();" id="exploreBtn">
                        <img style="display: none;" id="RegularExploreIcon" src="icons/SecondExploreIcon.png" width="29" height="29" alt=""/>
                        <img style="display: none;" id="ActiveExploreIcon" src="icons/ExploreIcon.png" width="29" height="29" alt=""/>
                        <p id="ExploreBtnText" style="padding: 0; font-size: 10px; margin-top: 1px; color: #7e7e7e;">Explore</p>
                    </div>
                    <div onclick="showDashboardSpots();" id="QueueIconBtn">
                            <img style="display: none;" style="" id="SpotsIcon" src="icons/SpotsIcon.png" alt="" width="29" height="29"/>
                            <img style="display: none;" style="" id="ActiveSpotsIcon" src="icons/ActiveSpotsIcon.png" alt="" width="29" height="29"/>
                            
                            <p id="SpotsBtnTxt" style="padding: 0; font-size: 10px; margin-top: 1px; color: #7e7e7e;">Spots</p>
                    </div>
                    <div onclick="showDashboardFavorites();" id="favoritesBtn">
                            <img style="display: none;" style="" id="SecondFavoritesIcon" src="icons/SecondFavoritesIcon.png" alt="" width="29" height="29"/>
                            <img style="display: none;" style="" id="FavoritesIcon" src="icons/FavoritesIcon.png" alt="" width="29" height="29"/>
                            <p id="FavoritesBtnTxt" style="padding: 0; font-size: 10px; margin-top: 1px; color: #7e7e7e;">Favorites</p>
                    </div>
                    <div onclick="showDashboardAccount();" id="accountBtn">
                            
                        <img style="display: none;" id="ActiveUserProfile" src="icons/UserProfileIcon.png" width="29" height="29" alt=""/>
                        <img style="display: none;" id="RegularUserProfile" src="icons/SecondUserProfileIcon.png" width="29" height="29" alt=""/>
                        <p id="AccountBtnTxt" style="padding: 0; font-size: 10px; margin-top: 1px; color: #7e7e7e;">Account</p>
                    </div>
                    <p style="clear: both;"></p>
                    
                    <script>
                        document.getElementById("ActiveExploreIcon").style.display = "block";
                        document.getElementById("RegularUserProfile").style.display = "block";
                        document.getElementById("FavoritesIcon").style.display = "block";
                        document.getElementById("SpotsIcon").style.display = "block";
                        var MblFavFirstLoaded = 0;
                        var SptsFirstLoaded = 0;
                        var AccntFirstLoaded = 0;
                        
                        document.getElementById("ExploreBtnText").style.color = "darkblue";
                        
                        function showDashboardSpots(){
                            
                            if(SptsFirstLoaded === 0){
                                OnloadedSpots = 0;
                                document.getElementById("SpotsIframe").src = "ProviderCustomerSpotsWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                                SptsFirstLoaded = 1;
                            }
                            if(document.getElementById("SpotsIframe").style.display === "block"){
                                OnloadedSpots = 0;
                                document.getElementById("SpotsIframe").src = "ProviderCustomerSpotsWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                            }
                            
                            document.getElementById("ActiveSpotsIcon").style.display = "block";
                            document.getElementById("SpotsIcon").style.display = "none";
                            
                            document.getElementById("ActiveUserProfile").style.display = "none";
                            document.getElementById("SecondFavoritesIcon").style.display = "none";
                            document.getElementById("RegularUserProfile").style.display = "block";
                            
                            document.getElementById("RegularExploreIcon").style.display = "block";
                            document.getElementById("FavoritesIcon").style.display = "block";
                            document.getElementById("ActiveExploreIcon").style.display = "none";
                            
                            document.getElementById("SpotsBtnTxt").style.color = "darkblue";
                            document.getElementById("ExploreBtnText").style.color = "#7e7e7e";
                            document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("AccountBtnTxt").style.color = "#7e7e7e";
                            
                            $("#SpotsIframe").show("slide", { direction: "left" }, 10);
                            $(".UserProfileContainer").hide("slide", { direction: "right" }, 10);
                            $("#ExploreDiv").hide("slide", { direction: "right" }, 10);
                            $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                            $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                            document.getElementById("SpotsIframe").style.display = "block";
                            
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                            
                        }
                        
                        function showDashboardExplore(){
                        
                            if(document.getElementById("ExploreDiv").style.display === "block"){
                                OnloadedExplore = 0;
                                document.getElementById("ExploreDiv").src = "ProviderCustomerExploreWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                            }
                            
                            document.getElementById("ActiveSpotsIcon").style.display = "none";
                            document.getElementById("SpotsIcon").style.display = "block";
                            
                            document.getElementById("ActiveUserProfile").style.display = "none";
                            document.getElementById("SecondFavoritesIcon").style.display = "none";
                            document.getElementById("RegularUserProfile").style.display = "block";
                            
                            document.getElementById("RegularExploreIcon").style.display = "none";
                            document.getElementById("FavoritesIcon").style.display = "block";
                            document.getElementById("ActiveExploreIcon").style.display = "block";
                            
                            document.getElementById("ExploreBtnText").style.color = "darkblue";
                            document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("AccountBtnTxt").style.color = "#7e7e7e";
                            
                            $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                            $(".UserProfileContainer").hide("slide", { direction: "right" }, 10);
                            $("#ExploreDiv").show("slide", { direction: "left" }, 10);
                            $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                            $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                            document.getElementById("ExploreDiv").style.display = "block";
                            
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                            
                        }
                        function showDashboardAccount(){
                        
                            if(AccntFirstLoaded === 0){
                                OnloadedUser = 0;
                                document.querySelector(".UserProfileContainer").src = "ProviderCustomerUserAccountWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                                AccntFirstLoaded = 1;
                            }
                        
                            if(document.querySelector(".UserProfileContainer").style.display === "block"){
                                OnloadedUser = 0;
                                document.querySelector(".UserProfileContainer").src = "ProviderCustomerUserAccountWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                            }
                        
                            document.getElementById("ActiveSpotsIcon").style.display = "none";
                            document.getElementById("SpotsIcon").style.display = "block";
                            
                            document.getElementById("ActiveUserProfile").style.display = "block";
                            document.getElementById("SecondFavoritesIcon").style.display = "none";
                            document.getElementById("RegularUserProfile").style.display = "none";
                            
                            document.getElementById("RegularExploreIcon").style.display = "block";
                            document.getElementById("FavoritesIcon").style.display = "block";
                            document.getElementById("ActiveExploreIcon").style.display = "none";
                            
                            document.getElementById("AccountBtnTxt").style.color = "darkblue";
                            document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("ExploreBtnText").style.color = "#7e7e7e";
                            
                            $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                            $(".UserProfileContainer").show("slide", { direction: "left" }, 10);
                            $("#ExploreDiv").hide("slide", { direction: "right" }, 10);
                            $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                            $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                            document.querySelector(".UserProfileContainer").style.display = "block";
                            
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                            
                        }
                        
                        function showDashboardFavorites(){
                        
                            if(MblFavFirstLoaded === 0){
                                OnloadedFavorites = 0;
                                document.getElementById("FavoritesIframe").src = "AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                                MblFavFirstLoaded = 1;
                            }
                        
                            if(document.getElementById("FavoritesIframe").style.display === "block"){
                                OnloadedFavorites = 0;
                                document.getElementById("FavoritesIframe").src = "AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                            }
                            
                            document.getElementById("ActiveSpotsIcon").style.display = "none";
                            document.getElementById("SpotsIcon").style.display = "block";
                        
                            document.getElementById("ActiveUserProfile").style.display = "none";
                            document.getElementById("SecondFavoritesIcon").style.display = "block";
                            document.getElementById("RegularUserProfile").style.display = "block";
                            
                            document.getElementById("RegularExploreIcon").style.display = "block";
                            document.getElementById("FavoritesIcon").style.display = "none";
                            document.getElementById("ActiveExploreIcon").style.display = "none";
                            
                            document.getElementById("FavoritesBtnTxt").style.color = "darkblue";
                            document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("AccountBtnTxt").style.color = "#7e7e7e";
                            document.getElementById("ExploreBtnText").style.color = "#7e7e7e";
                            
                            $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                            $(".UserProfileContainer").hide("slide", { direction: "right" }, 10);
                            $("#ExploreDiv").hide("slide", { direction: "right" }, 10);
                            $("#FavoritesIframe").show("slide", { direction: "left" }, 10);
                            $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                            document.getElementById("FavoritesIframe").style.display = "block";
                            
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                            
                        }
                    </script>
                    
            </div></center>
                     
            <div id="DesktopExplore" >
                
            <div id="nav" style='display: block;'>
               
                <h4><a href="" style=" color: black;"></a></h4>
                
                
                
                <center><div class ="SearchObject" style="margin-bottom: 15px;">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"/>
                    </form> 
                        
                </div></center>
                
                <!--h4 style="padding: 10px 0;">Search By Location</h4-->
                        
                <div id="LocSearchDiv" style="margin: 5px; margin-top: 10px;">
                <center><form id="DashboardLocationSearchForm" style="padding-bottom: 10px;" action="ByAddressSearchResultLoggedIn.jsp" method="POST">
                    <input type="hidden" name="User" value="<%=NewUserName%>" />
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <p style="color: #3d6999; margin-top: 10px; margin-bottom: 20px; font-weight: bolder;">
                        <i style="margin-right: 5px;" class="fa fa-map-marker" aria-hidden="true"></i>
                        Find services at location below</p>
                    <p class="LocSearchP">City: <input id="city4Search" style="width: 80%; background-color: #d9e8e8;" type="text" name="city4Search" placeholder="" value=""/></p> 
                    <p class="LocSearchP">Town: <input id="town4Search" style="width: 35%; background-color: #d9e8e8;" type="text" name="town4Search" value=""/> Zip Code: <input id="zcode4Search" style="width: 19%; background-color: #d9e8e8;" type="text" name="zcode4Search" value="" /></p>
                    <script>
                        var setLocation = setInterval(
                            function(){
                                
                                //don't clear interval as long as values are undefined
                                if(GoogleReturnedCity !== undefined && GoogleReturnedZipCode !== undefined && GoogleReturnedTown !== undefined){
                                    document.getElementById("city4Search").value = GoogleReturnedCity;
                                    document.getElementById("zcode4Search").value = GoogleReturnedZipCode;
                                    document.getElementById("town4Search").value = GoogleReturnedTown;
                                    clearInterval(setLocation);
                                }
                            }, 
                            1000
                        );
                
                    </script>
                    <p style='color: #3d6999; margin: 10px 0;'>Filter search by</p>
                    <div id="DashboardLocationSearchFilter" class='scrolldiv' style='margin: auto; overflow-x: auto; color: #ccc; background-color: #3d6999; border-radius: 4px; padding: 10px 5px;  width: 95%;'>
                        <table style='width: 2500px;'>
                            <tbody>
                                <tr>
                                    <td>
                                        <p><input name='Barber' id='barberFlt' type="checkbox" value="ON" /><label for='barberFlt'>Barbershop</label></p>
                                    </td>
                                    <td>
                                    <input name='Beauty' id='BeautyFlt' type="checkbox" value="ON" /><label for='BeautyFlt'>Beauty Salon</label>
                                    </td>
                                    <td>
                                    <input name='DaySpa' id='DaySpaFlt' type="checkbox" value="ON" /><label for='DaySpaFlt'>Day Spa</label>
                                    </td>
                                    <td>
                                    <input name='Dentist' id='DentistFlt' type="checkbox" value="ON" /><label for='DentistFlt'>Dentist</label>
                                    </td>
                                    <td>
                                    <input name='Dietician' id='DietFlt' type="checkbox" value="ON" /><label for='DietFlt'>Dietician</label>
                                    </td>
                                    <td>
                                    <input name='EyeBrows' id='EyebrowsFlt' type="checkbox" value="ON" /><label for='EyebrowsFlt'>Eyebrows and Eyelashes</label>
                                    </td>
                                    <td>
                                    <input name='HairRemoval' id='HairRmvFlt' type="checkbox" value="ON" /><label for='HairRmvFlt'>Hair Removal</label>
                                    </td>
                                    <td>
                                    <input name='HairSalon' id='HairSlnFlt' type="checkbox" value="ON" /><label for='HairSlnFlt'>Hair Salon</label>
                                    </td>
                                    <td>
                                    <input name='HolisticMedicine' id='HolMedFlt' type="checkbox" value="ON" /><label for='HolMedFlt'>Holistic Medicine</label>
                                    </td>
                                    <td>
                                    <input name='HomeService' id='HomeSvFlt' type="checkbox" value="ON" /><label for='HomeSvFlt'>Home Services</label>
                                    </td>
                                    <td>
                                    <input name='MakeUpArtist' id='MkUpArtistFlt' type="checkbox" value="ON" /><label for='MkUpArtistFlt'>Makeup Artist</label>
                                    </td>
                                    <td>
                                    <input name='Massage' id='MassageFlt' type="checkbox" value="ON" /><label for='MassageFlt'>Massage</label>
                                    </td>
                                    <td>
                                    <input name='Aethetician' id='MedEsthFlt' type="checkbox" value="ON" /><label for='MedEsthFlt'>Medical Aesthetician</label>
                                    </td>
                                    <td>
                                    <input name='MedCenter' id='MedCntrFlt' type="checkbox" value="ON" /><label for='MedCntrFlt'>Medical Center</label>
                                    </td>
                                    <td>
                                    <input name='NailSalon' id='NailSlnFlt' type="checkbox" value="ON" /><label for='NailSlnFlt'>Nail Salon</label>
                                    </td>
                                    <td>
                                    <input name='PersonalTrainer' id='PsnlTrnFlt' type="checkbox" value="ON" /><label for='PsnlTrnFlt'>Personal Trainer</label>
                                    </td>
                                    <td>
                                    <input name='PetServices' id='PetSvcFlt' type="checkbox" value="ON" /><label for='PetSvcFlt'>Pet Services</label>
                                    </td>
                                    <td>
                                    <input name='PhysicalTherapy' id='PhThpyFlt' type="checkbox" value="ON" /><label for='PhThpyFlt'>Physical Therapy</label>
                                    </td>
                                    <td>
                                    <input name='Piercing' id='PiercingFlt' type="checkbox" value="ON" /><label for='PiercingFlt'>Piercing</label>
                                    </td>
                                    <td>
                                    <input name='Podiatry' id='PodiatryFlt' type="checkbox" value="ON" /><label for='PodiatryFlt'>Podiatry</label>
                                    </td>
                                    <td>
                                    <input name='TattooShop' id='TtShFlt' type="checkbox" value="ON" /><label for='TtShFlt'>Tattoo Shop</label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p><input type="submit" style="font-weight: bolder; background-color: #626b9e; color: white; padding: 10px; border-radius: 3px; width: 95%;" value="Search" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"/></p>
                    </form></center>
                </div>
                    
            </div>
            
            <div id="main" class="Main">
               
            </div>
          </div>    
        </div>
                
        <div onclick='hideExtraDropDown();' class="DesktopUserAccount" id="newbusiness" style="padding: 0 !important; margin: 0; position: initial;">
            
            <script>
                if($(window).width() > 1000){
                    document.getElementById("newbusiness").style.minHeight = "100%";
                }
            </script>
                
                <div id="Customerprofile" style="padding-top: 0; margin-top: 10px;">
                    
                <table id="CustomerprofileTable" style="border-spacing: 0; width: 100%; max-width: 700px;">
                    
                    <tbody>
                        <tr>
                            <td>
                            <center>
                                    
                               <center><p id="ShowProInfo" onclick="toggleProInfoDivDisplay()" style="cursor: pointer; color: black; background-color: #3d6999; border: 1px solid black; color: white; padding: 5px;">
                                       <img style='background-color: white;' src="icons/icons8-user-15.png" width="20" height="20" alt="icons8-user-15"/>
                                       Show Your Profile Details</p></center>
                               
                               <div id="ProInfoDiv" class="proinfo" style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); border-radius: 4px; border-top: 0; text-align: left;  margin: 5px; margin-bottom: 0; background-color: #8abde1;">
                                
                                   
                                <div style="display: flex; flex-direction: row; padding: 5px; margin: auto; width: fit-content;  padding: 15px 0;">   
                                <%
                                    if(Base64Pic != ""){
                                %> 
                                
                                <div style="min-width: 80px;">
                                    <div style='margin-top: 0; border-radius: 100%; margin-bottom: 0; width: 60px; height: 60px; overflow: hidden;'>
                                        <img style="width: 60px; height: auto; background-color: darkgrey;" src="data:image/jpg;base64,<%=Base64Pic%>"/>
                                    </div>
                                </div>
                                <%
                                    } else{
                                %>
                                
                                   <a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';" href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                                           <div style="cursor: pointer; width: 60px; height: 60px; margin-right: 30px; border-radius: 100%; background-color: #ccc; padding: 5px; text-align: center; margin-bottom: 5px; display: flex; flex-direction: column; justify-content: center;">
                                                <div style="text-align: center;">
                                                    <img src="icons/SecondUserProfileIcon.png" style="width: 50px; height: 50px; border-radius: 0; background: none; border: none;" alt=""/>
                                                </div>
                                           </div>
                                   </a>
                                    
                                <%
                                    }
                                %>
                                
                                <div style="display: flex; flex-direction: column; justify-content: center;">
                                    <p style='font-weight: bolder;'>
                                        <span id="FullNameDetail"><%=FullName%></span>
                                    </p>
                                
                                    <table style="border-spacing: 1px; width: 100%;" border="0">
                                            <tr>
                                                <td style="padding-bottom: 2px;">
                                                    <p>
                                                        <small id="PhoneNumberDetail"><%=PhoneNumber%></small>, 
                                                        <br/>
                                                        <small id="EmailDetail"><%=Email%></small>
                                                    </p>
                                                </td>
                                            </tr>
                                    </table>
                                </div>
                                        
                               </div>
                                        
                                        <%
                                            
                                            if(thisUserAddress == "no address information"){
                                                
                                        %>
                                        
                                        <form id="SetUserAddress" style="margin-top: 5px;
                                              padding-top: 5px;" action="SetUserAddress" method="POST">
                                                <p style="padding: 5px; color: #ffffff; text-align: center;">Add Your Address</p>
                                            <center><table style='background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; border: #3d6999 1px solid; max-width: 300px; margin: auto;'>
                                                <tbody>
                                                <tr>
                                                    <td>House Number: </td>
                                                    <td><input id="NewAddressHNumber" placeholder="1234" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="houseNumberFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Street: </td>
                                                    <td><input id="NewAddressStreet" placeholder="Some St./Ave." style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="streetAddressFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Town: </td>
                                                    <td><input id="NewAddressTown" placeholder="Some Town" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="townFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>City: </td>
                                                    <td><input id="NewAddressCity" placeholder="Some City " style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="cityFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Country: </td>
                                                    <td><input id="NewAddressCountry" placeholder="Some Country" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="countryFld" value="" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Zip Code: </td>
                                                    <td><input id="NewAddressZipcode" placeholder="1234" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="zipCodeFld" value="" /></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                            
                                                <p id="NewAddressStatus" style="text-align: center; color: white; font-size: 14px; margin: 5px 0;"></p>
                                                <input type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                <center><input onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" id="NewAddressBtn" style="margin-top: 10px; border: 0; padding: 10px; background-color: darkslateblue; border-radius: 4px;" type="submit" value="Set Address" /></center>
                                            
                                                <script>
                                                    var setAddress = setInterval(
                                                        function(){

                                                            //don't clear interval as long as values are undefined
                                                            if(GoogleReturnedCity !== undefined && GoogleReturnedZipCode !== undefined && GoogleReturnedTown !== undefined){
                                                                document.getElementById("NewAddressHNumber").value = GoogleReturnedStreetNo;
                                                                document.getElementById("NewAddressStreet").value = GoogleReturnedStreetName;
                                                                document.getElementById("NewAddressCity").value = GoogleReturnedCity;
                                                                document.getElementById("NewAddressZipcode").value = GoogleReturnedZipCode;
                                                                document.getElementById("NewAddressTown").value = GoogleReturnedTown;
                                                                document.getElementById("NewAddressCountry").value = GoogleReturnedCountry;
                                                                clearInterval(setAddress);
                                                            }
                                                        }, 
                                                        1000
                                                    );

                                                </script>
                                                
                                        </form>
                                                
                                        <%
                                            }
                                            else{
                                                          
                                        %>
                                                    
                                        
                                        <form id="UpdateUserAccountForm" style="border-top: 0; margin-top: 5px; display: none;
                                              padding-top: 5px;" >
                                            <center><p style="color: white; margin: 5px; font-weight: bolder;">Change profile information</p></center>
                                            
                                            <center><a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" href="UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                                                    <p style="cursor: pointer; color: #334d81; font-weight: bolder; padding: 15px 5px; border-radius: 4px; text-align: center; width: 300px;"><img src="icons/AddPhotoImg.png" style="width: 30px; height: 30px; border-radius: 0; background: none; border: none;" alt=""/>
                                                        <sup>Change Profile Picture</sup></p>
                                                </a></center>
                                            <center><table style='background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 10px 5px; border: #3d6999 1px solid; max-width: 300px; margin: auto;'>
                                                <tbody>
                                                <tr>
                                                    <td>First Name: </td><td><input id="ChangeProfileFirstName" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="firstNameFld" value="<%=FirstName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Middle Name: </td><td><input id="ChangeProfileMiddleName" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="middleNameFld" value="<%=MiddleName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Last Name: </td><td><input id="ChangeProfileLastName" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="lastNameFld" value="<%=LastName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Phone Number: </td>
                                                    <td><input onclick="checkMiddlePhoneNumberEdit();" onkeydown="checkMiddlePhoneNumberEdit();" id="ChangeProfilePhoneNumber" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="phoneNumberFld" value="<%=PhoneNumber%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Email: </td>
                                                    <td><input id="ChangeProfileEmail" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="emailFld" value="<%=Email%>" /></td>
                                                </tr>
                                                </tbody>
                                                </table>
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
                                                    <p style="padding: 15px 0; font-weight: bolder; color: #ffffff;">Address Info Below</p>
                                                    <table style='background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 15px 5px; border: #3d6999 1px solid; max-width: 300px; margin: auto;'>
                                                    <tbody>
                                                
                                                <tr>
                                                    <td>House Number: </td>
                                                    <td><input onclick="checkMiddleHouseNumberEdit();" onkeydown="checkMiddleHouseNumberEdit();" id="ChangeProfileHouseNumber" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="houseNumberFld" value="<%=H_Number%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Street: </td>
                                                    <td><input id="ChangeProfileStreet" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="streetAddressFld" value="<%=Street%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Town: </td>
                                                    <td><input id="ChangeProfileTown" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="townFld" value="<%=Town%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>City: </td>
                                                    <td><input id="ChangeProfileCity" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="cityFld" value="<%=City%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Country: </td>
                                                    <td><input id="ChangeProfileCountry" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="countryFld" value="<%=Country%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Zip Code: </td>
                                                    <td><input onclick="checkMiddleZipCodeEdit();" onkeydown="checkMiddleZipCodeEdit();" id="ChangeProfileZipCode" style="background-color: #d9e8e8; border-radius: 4px; padding: 10px 5px;" type="text" name="zipCodeFld" value="<%=ZipCode%>" /></td>
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
                                                <center><p id="userProfileFormStatus" style="background: none !important; color: #334d81; font-weight: bolder; text-align: center; padding: 10px 0;"></p></center>
                                                <center><input id="ChangeProfileUpdateBtn" style="color: white; margin-top: 10px; border: 0; padding: 10px; min-width: 150px; border-radius: 4px;" type="button" value="Update" /></center>
                                            
                                                <script>
                                                    $(document).ready(function(){
                                                        $("#ChangeProfileUpdateBtn").click(function(event){
                                                            
                                                            document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                            
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
                                                                    
                                                                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                                    document.getElementById("UpdateUserAccountForm").style.display = "none";
                                                                    
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
                                                
                                        <form id="SendFeedBackForm" style="border-top: 0; margin-top: 5px; display: none;
                                              padding-top: 5px;" >
                                            <center><div id='LastReviewMessageDiv' style='display: none; padding: 10px; border-radius: 4px; border: #626b9e 1px solid; background-color: white; width: 100%; max-width: 400px; margin-bottom: 10px;'>
                                                    <p style="font-weight: bolder; color: #334d81; margin-bottom: 15px; text-align: center;">Thanks for your feedback!</p>
                                                    <p id='LasReviewMessageP' style='text-align: left; padding: 10px 5px; color: darkgray; font-size: 13px;'></p>
                                                    <p id="FeedBackDate" style="text-align: left; margin-right: 5px; text-align: right; color: darkgrey; font-size: 13px;"></p>
                                                </div></center>
                                            <center><table style='background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 20px; border: #3d6999 1px solid; max-width: 300px; margin: auto;'>
                                                <tbody>
                                                <tr>
                                                    <td style="color: #334d81; font-weight: bolder; text-align: center; padding-bottom: 15px">Send Your Feedback</td>
                                                </tr>
                                                <tr>
                                                    <td><textarea id="FeedBackTxtFld" onfocus="if(this.innerHTML === 'Add your message here...')this.innerHTML = ''" name="FeedBackMessage" rows="4" cols="35">
                                                        </textarea></td>
                                                </tr>
                                                </tbody>
                                                </table></center>
                                                
                                                <input id='FeedBackUserID' type="hidden" name="CustomerID" value="<%=UserID%>" />
                                                <center><input id="SendFeedBackBtn" style="color: white; padding: 5px; margin-top: 10px; border: 0; padding: 10px; background-color: darkslateblue; border-radius: 4px; min-width: 150px;" type="button" value="Send" /></center>
                                            
                                        </form>
                                                <script>
                                               $(document).ready(function() {                        
                                                    $('#SendFeedBackBtn').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var feedback = document.getElementById("FeedBackTxtFld").value;
                                                        var CustomerID = document.getElementById("FeedBackUserID").value;
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "SendProvCustFeedBackController",  
                                                            data: "FeedBackMessage="+feedback+"&CustomerID="+CustomerID,  
                                                            success: function(result){
                                                              alert(result);
                                                              
                                                              document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                              
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
                                                    
                                                    function checkFeedBackFld(){
                                                        
                                                        var FeedBackTxtFld = document.getElementById("FeedBackTxtFld");
                                                        var SendFeedBackBtn = document.getElementById("SendFeedBackBtn");
                                                        
                                                        if(FeedBackTxtFld.innerHTML !== "Add your message here..."){
                                                            SendFeedBackBtn.style.backgroundColor = "darkslateblue";
                                                            SendFeedBackBtn.disabled = false;
                                                        }else{
                                                            SendFeedBackBtn.style.backgroundColor = "darkgrey";
                                                            SendFeedBackBtn.disabled = true;
                                                        }
                                                        
                                                }
                                                
                                                setInterval(checkFeedBackFld, 1);
                                                    
                                        </script>
                                        
                                        <p style=""></p>
                                        
                                        <div style="text-align: center; margin-right: 5px; margin-top: 10px;">
                                            <div class="tooltip">
                                                <p style="margin-left: 10px; cursor: pointer; background-color: oldlace; padding: 5px; border-radius: 4px;" onclick="showUserFeedBackForm()">
                                                    <img style="" src="icons/icons8-comments-96.png" width="20" height="20" alt="icons8-feedback-20"/>
                                                    <small style="color: darkblue;">feedback</small>
                                                </p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p style="margin-left: 10px; cursor: pointer;  background-color: oldlace; padding: 5px; border-radius: 4px;" onclick = "showUserProfileForm();">
                                                    <img style="" src="icons/icons8-edit-96.png" width="20" height="20" alt="icons8-pencil-20"/>
                                                    <small style="color: darkblue;">Edit info</small>
                                                <p>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <p style="cursor: pointer; margin-left: 10px;  background-color: oldlace; padding: 5px; border-radius: 4px;" onclick = "showSettingsDiv();">
                                                    <img style="" src="icons/icons8-settings-96.png" width="20" height="20" alt="icons8-settings-20"/>
                                                    <small style="color: darkblue;">Settings</small>
                                                </p>
                                            </div>
                                        </div>
                                        <style>
                                            #SettingsDiv form p input{
                                                padding: 10px 5px !important;
                                            }
                                        </style>
                                        <div id="SettingsDiv" style= "display: none; margin-top: 10px;">
                                            <ul style="color: white;">
                                                <li>
                                                    
                                                    <p style="cursor: pointer; padding: 10px 0;" onclick="showLoginFormsDiv()"><img src="icons/icons8-admin-settings-male-20 (1).png" width="20" height="20" alt="icons8-admin-settings-male-20 (1)"/>
                                                    Account Settings</p>
                                                    <form  id="UserAcountLoginForm" style="margin: auto; margin-top: 5px; display: none; border-top: darkblue solid 1px; padding: 15px 5px;
                                                           background-color: #9bb1d0; border-radius: 4px; width: fit-content; border: #3d6999 1px solid; max-width: 300px;" name="userAccountForm">
                                                        <p>Change your login here</p>
                                                        <p style="color: #334d81; margin-top: 15px; margin-bottom: 5px;">User Name:</p>
                                                        <center><p><input id="UpdateLoginNameFld" style="padding: 3px; background-color: #d9e8e8; border-radius: 4px; color: darkblue;" placeholder="Enter New User Name Here" type="text" name="userName" value="<%=thisUserName%>" size="35" /></p></center>
                                                        
                                                        <p style="color: #334d81; margin-top: 15px; margin-bottom: 5px;">Password:</p>
                                                        <center><p><input class="passwordFld" id="CurrentPasswordFld" style="padding: 3px; background-color: #d9e8e8; border-radius: 4px;" placeholder="Enter Current Password" type="password" name="currentPassword" value="" size="36" /></p>
                                                            <p style="text-align: right; margin-top: -32px; margin-bottom: 15px; padding-right: 15px;"><i class="fa fa-eye showPassword" style="color: #626b9e;" aria-hidden="true"></i></p>
                                                        
                                                            <p><input class="passwordFld" id="NewPasswordFld" style="padding: 3px; background-color: #d9e8e8; border-radius: 4px;" placeholder="Enter New Password" type="password" name="newPassword" value="" size="36" /></p>
                                                        
                                                            <p><input class="passwordFld" id="ConfirmPasswordFld" style="padding: 3px; background-color: #d9e8e8; border-radius: 4px;" placeholder="Confirm New Password" type="password" name="confirmNewPassword" value="" size="36" /></p>
                                                        <p id="changeUserAccountStatus" style="margin: 10px 0;"></p>
                                                        <p id="WrongPassStatus" style="color: #334d81; font-weight: bolder; margin: 10px 0; display: none;"><i style="margin-right: 5px; color: orange;" class="fa fa-exclamation-triangle" aria-hidden="true"></i>Enter your current password correctly</p>
                                                        <input id='UserIDforLoginUpdate' name="CustomerID" type="hidden" value="<%=UserID%>" />
                                                        <input id="ThisPass" type="hidden" name="ThisPass" value="" />
                                                        <input id='UserIndexforLoginUpdate' type='hidden' name='UserIndex' value='<%=UserIndex%>'/>
                                                        <input id="LoginFormBtn" style="margin-top: 10px; border: 0; padding: 10px; min-width: 150px; background-color: darkslateblue; color: white; border-radius: 4px;" type="button" value="Update" /></center>
                                                    </form>
                                                    <script>
                                                        $(document).ready(function(){
                                                            $("#LoginFormBtn").click(function(event){
                                                                
                                                                document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                                
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
                                                                        
                                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                                        
                                                                        if(result === "fail"){
                                                                            
                                                                            document.getElementById("WrongPassStatus").style.display = "block";
                                                                            document.getElementById("CurrentPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").style.backgroundColor = "red";
                                                                            
                                                                        }
                                                                        if(result === "success"){
                                                                            document.getElementById("NewPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").value = "";
                                                                            document.getElementById("CurrentPasswordFld").style.backgroundColor = "#d9e8e8";
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
                                                    <p style="cursor: pointer; padding: 10px 0;" onclick="showContactUsDiv()">
                                                        <img src="icons/icons8-telephone-20.png" width="20" height="20" alt="icons8-telephone-20"/>
                                                        Contact Us<p>
                                                    <div id="ContactUsDiv" style="margin-top: 5px; display: none; padding: 10px 5px;">
                                                        <p style="color: #44484a; margin-bottom: 5px;">
                                                          <i style="margin-right: 5px;" class="fa fa-phone"></i>
                                                          +1 (732) 799-9546</p>
                                                        <p style="color: #44484a;">
                                                            <i style="margin-right: 5px;" class="fa fa-envelope"></i>
                                                            support@theomotech.com</p>
                                                    </div>
                                                </li>
                                                <li style='display: none;'> 
                                                    <p style="cursor: pointer; padding: 10px 0;" onclick="showPaymentsForm()"><img src="icons/icons8-mastercard-credit-card-20 (1).png" width="20" height="20" alt="icons8-mastercard-credit-card-20 (1)"/>
                                                        Payments</p>
                                                    
                                                    <div style=''>
                                                        <form id="PaymentsCardForm" style="margin: auto; margin-top: 5px; display: none; border-top: darkblue solid 1px; padding: 5px;
                                                          background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; border: #3d6999 1px solid; max-width: 300px;" name="PaymentForm" action="notYet" method="POST">
                                                
                                                        <p style="margin-bottom: 5px; ">Add new debit/credit card:</p>
                                                        <table id="paymentDetailsTable">
                                                    <tbody>

                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Card Number: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input onclick="checkMiddleCardNumber();" onkeydown="checkMiddleCardNumber();" id="CardNumberFld" style="background-color: #d9e8e8; border-radius: 4px;" type="text" name="C/DcardNumber" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Holder's Name: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="HoldersNameFld" style="background-color: #d9e8e8; border-radius: 4px;" type="text" name="holdersName" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Exp. Date: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="ExpDateFld" style="background-color: #d9e8e8; border-radius: 4px; max-width: 100px;" type="text" name="cardExpDate" value="" /></td></tr>
                                                            <tr><td style="border-radius: 0; padding: 0; color: black;">Security Code: </td><td style="border-radius: 0; padding: 0;">
                                                                    <input id="SecCodeFld" style="background-color: #d9e8e8; border-radius: 4px; max-width: 100px;" type="text" name="secCode" value="" /></td></tr>

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
                                                    <center><input id="PaymentsUpdateBtn" style="background-color: darkslateblue; border: 0; padding: 10px; color: white; border-radius: 4px;" type="submit" value="Update" name="paymentBtn" /></center>
                                                
                                                </form>
                                            </div>
                                                </li>
                                                <li>
                                                    <a onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" href='ViewCustomerReviews.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>'>
                                                        <p style="cursor: pointer; color: white;  padding: 10px 0;">
                                                            <img src="icons/icons8-popular-20 (1).png" width="20" height="20" alt="icons8-popular-20 (1)"/>
                                                            Your Reviews</p></a>
                                                </li>
                                            </ul>
                                        </div>
                                        
                                        <%  }
                                        
                                        %>
                                       
                                        <center><table onclick="collapseAllSettings();" id="selectCustSpttabs" cellspacing="0" style="width: 100%; padding: 10px 0; background-color: #6fa0cb; margin-top: 15px;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateAppTab()" id="AppointmentsTab" style="padding-top: 20px; text-align: center; color: white; font-weight: bolder; padding: 5px; cursor: pointer; width: 33.3%;">
                                                        <i class="fa fa-list" aria-hidden="true"></i> Your Spots
                                                    </td>
                                                    <td onclick="activateHistory()" id="HistoryTab" style="text-align: center; color: #496884; font-weight: bolder; padding: 5px; cursor: pointer; width: 33.3%;">
                                                        <i class="fa fa-history" aria-hidden="true"></i> History
                                                    </td>
                                                    <td onclick="activateFavTab()" id="FavoritesTab" style="text-align: center; color: #496884; font-weight: bolder; padding: 5px; cursor: pointer; width: 33.3%;">
                                                        <i class="fa fa-heart" aria-hidden="true"></i> Favorites
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table></center>
                                        
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
                                        <!--background-color: #8abde1;-->
                                        
                                        
                                <div class="scrolldiv" style=" height: 640px; overflow-y: auto; background: none !important; padding-top: 15px;">
                                   
                                   <script>
                                        function showselectCustSpttabs(){
                                            document.getElementById("selectCustSpttabs").scrollIntoView();
                                        }
                                    </script>
                                        
                                <div id="serviceslist" style="padding-bottom: 0; border-top: 0;" class="AppListDiv">
                                    
                                    <p style="color: black; margin: 15px 0; color: #334d81; font-weight: bolder;">Today's Spots</p>
                                   
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
                                    
                                    <div style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; margin-bottom: 10px; padding: 10px; background-color: white; border-radius: 5px; max-width: 700px;">
                                     
                                    <%
                                        if(Base64ProvPic != ""){
                                    %>
                                    <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                            <div style="border-radius: 100%; margin-left: 10px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                                <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>"/>
                                            </div>
                                        </div></center>
                                    <%
                                        }
                                    %>
                                    
                                    <p style='display: flex; flex-direction: row; justify-content: space-between; padding: 5px 10px; margin-bottom: 5px; font-weight: bolder;'>
                                        <span></span>
                                        <span><i style='color: orange;' class="fa fa-info-circle" aria-hidden="true"> </i> 
                                        its your turn</span> 
                                        <i style='color: #4ed164;' class="fa fa-check" aria-hidden="true"></i>
                                    </p>
                                    
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                                <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                
                                                <p style='color: darkblue; font-weight: bolder;'>This spot with <span style = "color: blue;">
                                                    <input style="background-color: darkslateblue; padding: 5px; border-radius: 5px; margin: 5px; font-weight: bolder;  color: white; border:0; font-weight: bolder; margin: 0;" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderName%>"/>
                                                    </span> started at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                        
                                                
                                            
                                        </form>
                                        
                                        <p style='margin-top: 10px;'>
                                            <img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                            <span><%= ProviderCompany%></span>
                                        </p>
                                        
                                        <p>
                                            <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %>
                                        </p>
                                        <p>
                                            <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %>
                                        </p>
                                        <p style="color: darkgray; text-align: center; margin-top: 10px;">- <%=AppointmentReason%> -</p>
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
                                    
                                    <div id="AppointmentDiv<%=JString%>" style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; margin-bottom: 10px; padding: 10px; background-color: white; border-radius: 5px; max-width: 700px;">
                                    
                                    <%
                                        if(Base64ProvPic != ""){
                                    %>
                                    <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                     <!--img class="fittedImg" style="border-radius: 100%; margin-left: 10px; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<=Base64ProvPic%>" width="40" height="40"/-->
                                            <div style="border-radius: 100%; margin-left: 10px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                                <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>"/>
                                            </div>
                                        </div></center>
                                    <%
                                        }
                                    %>
                                        
                                    <p style='display: flex; flex-direction: row; justify-content: space-between; padding: 5px 10px; font-weight: bolder;'>
                                        <span></span>
                                        <span><i style='color: orange;' class="fa fa-info-circle" aria-hidden="true"> </i> 
                                        waiting on line</span> 
                                        <i style='color: green;' class="fa fa-spinner" aria-hidden="true"></i>
                                    </p>
                                    
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                                <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                
                                                <p style="font-weight: bolder; color: darkblue;">You are on <span style = "color: blue;">
                                                    <input style="color: white; padding: 5px; border-radius: 5px; border:0; font-weight: bolder; margin: 5px; background-color: darkslateblue;" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" type='submit' value="<%= ProviderName%>'s"/> <i class='fa fa-arrow-right' aria-hidden='true'></i>
                                                    </span> line at <span id="ApptTimeSpan<%=JString%>" style = "color: red;"> <%= TimeToUse%></span>
                                                </p>
                                        </form>
                                                
                                        <p style="padding-top: 10px;">
                                            <img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                            <%=ProviderCompany%>
                                        </p>
                                        <p>
                                            <img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail.trim() %>
                                        </p>
                                        <p>
                                            <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                            <%= ProviderTel %>
                                        </p>
                                        <p style="color: darkgray; text-align: center; margin-top: 10px;">- <%=AppointmentReason%> -</p>
                                        
                                        
                                        <form style=" display: none;" id="changeBookedAppointmetForm<%=JString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                            
                                            <p style="color: tomato; margin-top: 5px;">Set new time or date to change this spot</p>
                                            <input  id="datepicker<%=JString%>" class="datepicker<%=JString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=AppointmentDate%>" />
                                            <input id="timeFld<%=JString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=AppointmentTime%>" />
                                            <input id="timePicker<%=JString%>" style="background-color: white;" type="text" name="ApointmentTimePicker" value="<%=AppointmentTime%>" />
                                            <p id="timePickerStatus<%=JString%>" style="margin-bottom: 3px; font-weight: bolder; color: darkblue; text-align: center;"></p>
                                            <p id="datePickerStatus<%=JString%>" style="font-weight: bolder; color: darkblue; text-align: center;"></p>
                                            <input id="ChangeAppointmentID<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <input id="changeAppointmentBtn<%=JString%>" style="background-color: darkslateblue; border: 0; color: white; padding: 3px; border-radius: 4px;" name="<%=JString%>changeAppointment" type="button" value="Change" />
                                        
                                            <script>
                                                
                                                $( 
                                                    function(){
                                                        $("#datepicker<%=JString%>").datepicker();
                                                    } 
                                                );
                                                
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtn<%=JString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var AppointmentID = document.getElementById("ChangeAppointmentID<%=JString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFld<%=JString%>").value;
                                                        var AppointmentDate = document.getElementById("datepicker<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){
                                                            if(result === ""){
                                                                alert("Not Successful. Time chosen may have violated this service providers booking time settings");
                                                            }else{
                                                                alert(result);
                                                            }
                                                          
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                          
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
                                                                document.getElementById("timePickerStatus<%=JString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFld<%=JString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFld<%=JString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFld<%=JString%>").value = currentTime;
                                                                        document.getElementById("changeAppointmentBtn<%=JString%>").disabled = true;
                                                                        document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatus<%=JString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }else{
                                                                
                                                                document.getElementById("timePickerStatus<%=JString%>").innerHTML = "";
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").disabled = false;
                                                                document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "darkslateblue";
                                                                document.getElementById("timePickerStatus<%=JString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Time has been set to " + document.getElementById("timePicker<%=JString%>").value;
                                                                
                                                            }
                                                        
                                                        }else{
                                                            
                                                            document.getElementById("timePickerStatus<%=JString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=JString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=JString%>").style.backgroundColor = "darkslateblue";
                                                            
                                                        }

                                                     }

                                                     setInterval(CheckCurrentTimeChooser,1);
                                                     
                                                 </script>
                                            
                                            
                                            <script>
                                        
                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "";


                                                         function checkDateUpdateValue(){

                                                                 if((new Date(document.getElementById("datepicker<%=JString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepicker<%=JString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatus<%=JString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatus<%=JString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Today's Date: " + currentDate;
                                                                                                 //document.getElementById("datePickerStatus<=JString%>").style.backgroundColor = "green";
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Only today's date or future date allowed";
                                                                                         //document.getElementById("datePickerStatus<=JString%>").style.backgroundColor = "red";
                                                                                         document.getElementById("datepicker<%=JString%>").value = currentDate;
                                                                                 }
                                                                 }
                                                                 else{

                                                                         document.getElementById("datePickerStatus<%=JString%>").innerHTML = "";
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
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentID<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                          
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
                                            <input id="addProvtoFavBtn<%=JString%>" style="color: white; margin: 10px; background-color: darkslateblue; border: 0; padding: 5px; border-radius: 4px; font-weight: bolder;" type="button" value="Add person to favorites" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addProvtoFavBtn<%=JString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var ProviderID = document.getElementById("ProvIDatAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustIDatAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){
                                                            
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                            
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
                                                                                        '<div class="MainPropicContainer" style="border: 5px solid white; width: 150px; height: 150px; overflow: hidden;">'+
                                                                                            '<img style="width: 150px; height: auto;" src="data:image/jpg;base64,'+provProPic+'" />'+
                                                                                        '</div>'+
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;">' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p>' +
                                                                                     provCompany +
                                                                                    '<span style="color: goldenrod; font-size: 18px;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: crimson; border: none; color: white; padding: 5px; border-radius: 4px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: darkslateblue; border: 0; padding: 5px; color: white; border-radius: 4px;" type="submit" value="Find a Spot" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
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
                                    
                                    <center><p style="color: white; margin-top: 30px; margin-bottom: 30px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> You don't have any current spots</p></center>
                                    
                                    <%} //end of if block%>
                                    
                                    <!--------------------------------------------------------------------------------------------------------------------------------------------->
                                    
                                    <p style="color: #334d81; font-weight: bolder; margin: 15px 0; width: 100%;">Future Spots</p>
                                    
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
                                    
                                    <div id="FutureAppointmentDiv<%=QString%>" style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; margin-bottom: 10px; padding: 10px; background-color: white; border-radius: 5px; max-width: 700px;">
                                    
                                        <%
                                            if(Base64ProvPic != ""){
                                        %>
                                        <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                         <!--img class="fittedImg" style="border-radius: 100%; margin-left: 10px; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<=Base64ProvPic%>" width="40" height="40"/-->
                                                <div style="border-radius: 100%; margin-left: 10px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                                    <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>"/>
                                                </div>
                                            </div></center>
                                        <%
                                            }
                                        %>
                                        
                                        <p style='display: flex; flex-direction: row; justify-content: space-between; padding: 5px 10px; font-weight: bolder;'>
                                            <span></span>
                                            <span><i style='color: orange;' class="fa fa-info-circle" aria-hidden="true"> </i> 
                                            not a today appointment</span> 
                                            <i style='color: green;' class="fa fa-bed" aria-hidden="true"></i>
                                        </p>
                                        
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                            
                                            <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                            <P style='font-weight: bolder; color: darkblue;'>
                                                You will be on <span style = "color: blue;">
                                                    <input style="background-color: darkslateblue; border: 0; border-radius: 4px; margin: 5px; font-weight: bolder; color: white; padding: 5px;" type="submit"  value="<%= ProviderName%>'s" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"/>
                                                </span> line
                                            </p>
                                            <p style='color: blue; font-weight: bolder;'><i class="fa fa-calendar" aria-hidden="true"></i> <span id="FutureDateSpan<%=QString%>" style ="color: red;"> <%= AppointmentFormattedDate%></span> <i class="fa fa-clock-o" aria-hidden="true"></i> <span id="FutureTimeSpan<%=QString%>" style = "color: red;"> <%= TimeToUse%></span></p>
                                            
                                        </form>
                                            
                                        <p style='margin-top: 15px;'>
                                            <img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                            <span><%= ProviderCompany%></span>
                                        </p>
                                                
                                        <p>
                                            <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                            <%= ProviderEmail %>
                                        </p>
                                        <p>
                                            <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/><%= ProviderTel %>
                                        </p>
                                        <p style="color: darkgray; text-align: center; margin-top: 10px;">- <%=AppointmentReason%> -
                                        </p>
                                        
                                        <form style=" display: none;" id="changeFutureAppointmetForm<%=QString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                            
                                            <p style="color: tomato; margin-top: 5px;">Set new time or date to change this spot</p>
                                            <input  id="datepickerFuture<%=QString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=AppointmentDate%>" />
                                            <input id="timeFldFuture<%=QString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=AppointmentTime%>" />
                                            <input id="timePickerFuture<%=QString%>"  style="background-color: white;" type="text" name="ApointmentTimePicker" value="" />
                                            <p id="timePickerStatusFuture<%=QString%>" style="margin-bottom: 3px; font-weight: bolder; color: darkblue; text-align: center;"></p>
                                            <p id="datePickerStatusFuture<%=QString%>" style="font-weight: bolder; color: darkblue; text-align: center;"></p>
                                            <input id="UpdateAppointmentID<%=QString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <input id="changeAppointmentBtnFuture<%=QString%>" style="background-color: darkslateblue; border: 0; color: white; padding: 3px; border-radius: 4px;" name="<%=QString%>changeAppointment" type="button" value="Change" />
                                           
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtnFuture<%=QString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var AppointmentID = document.getElementById("UpdateAppointmentID<%=QString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFldFuture<%=QString%>").value;
                                                        var AppointmentDate = document.getElementById("datepickerFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateAppointmentController",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){
                                                            if(result === ""){
                                                                alert("Not Successful. Time chosen may have violated this service providers booking time settings");
                                                            }else{
                                                                alert(result);
                                                            }
                                                          
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                          
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
                                                                document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFldFuture<%=QString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFldFuture<%=QString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFldFutureFuture<%=QString%>").value = currentTime;
                                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = true;
                                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }else{
                                                                document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "";
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = false;
                                                                document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "darkslateblue";
                                                                document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Time has been set to " + document.getElementById("timePickerFuture<%=QString%>").value;
                                                            }
                                                            
                                                    }else{
                                                        
                                                        document.getElementById("timePickerStatusFuture<%=QString%>").innerHTML = "";
                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").disabled = false;
                                                        document.getElementById("changeAppointmentBtnFuture<%=QString%>").style.backgroundColor = "darkslateblue";
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
                                                            
                                                         document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "";


                                                         function checkDateUpdateValueFuture(){

                                                                 if((new Date(document.getElementById("datepickerFuture<%=QString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepickerFuture<%=QString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Today's Date: " + currentDate;
                                                                                                 //document.getElementById("datePickerStatusFuture<=QString%>").style.backgroundColor = "green";
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         document.getElementById("datePickerStatusFuture<%=QString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Only today's date or future date allowed";
                                                                                         //document.getElementById("datePickerStatusFuture<=QString%>").style.backgroundColor = "red";
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
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentIDFuture<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                            <input id="addFavtoProvBtn<%=QString%>" style="margin: 10px; background-color: darkslateblue; border: 0; border-radius: 4px; color: white; padding: 5px; font-weight: bolder;" type="button" value="Add person to favorites" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addFavtoProvBtn<%=QString%>').click(function(event) {  
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProvIDforAddFav<%=QString%>").value;
                                                        var CustomerID = document.getElementById("CustIDforAddFav<%=QString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                                                                        '<div class="MainPropicContainer" style="border: 5px solid white; width: 150px; height: 150px; overflow: hidden;">'+
                                                                                            '<img style="width: 150px; height: auto;" src="data:image/jpg;base64,'+provProPic+'" />'+
                                                                                        '</div>'+
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;">' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p>' +
                                                                                     provCompany +
                                                                                    '<span style="color: goldenrod; font-size: 18px;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: crimson; border: none; color: white; padding: 5px; border-radius: 4px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +

                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: darkslateblue; color: white; border: 0; border-radius: 4px; padding: 5px;" type="submit" value="Find a Spot" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
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
                                    
                                    <center><p style="color: white; margin-top: 30px; margin-bottom: 30px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> You don't have any future spots</p></center>
                                    
                                    <%} //end of if block%>
                                   
                                    
                                </div> 
                                        
                                <div id="serviceslist" class="AppHistoryDiv" style="border-top: 0;">
                                    
                                    <!--p style="color: black; margin: 10px;">Your Past Spots</p-->
                                    
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
                                    
                                    <div id="HistoryAppointmentDiv<%=JString%>" style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; margin-bottom: 10px; padding: 10px; background-color: white; border-radius: 5px; max-width: 700px;s">
                                    
                                        <%
                                            if(Base64ProvPic != ""){
                                        %>
                                        <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                         <!--img class="fittedImg" style="border-radius: 100%; margin-left: 10px; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<=Base64ProvPic%>" width="40" height="40"/-->
                                                <div style="border-radius: 100%; margin-left: 10px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                                    <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64ProvPic%>"/>
                                                </div>
                                            </div></center>
                                        <%
                                            }
                                        %>
                                        
                                        <form action="EachSelectedProviderLoggedIn.jsp" method="POST">
                                            <input type='hidden' name='UserID' value='<%=ProviderID%>'/>
                                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                            <p>
                                                <i class="fa fa-calendar" aria-hidden="true"></i> 
                                                <span style ="color: red;"> <%= AppointmentFormattedDate%></span>,  
                                                <i class="fa fa-clock-o" aria-hidden="true"></i> 
                                                <span style = "color: red;"> <%= TimeToUse%></span>
                                            </p>
                                            
                                            <p style = "color: blue; margin-top: 10px;">
                                                <input onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" style="
                                                       background: 0; border: 0; color: white; padding: 5px; background-color: darkslateblue; font-weight: bolder; margin: 0; border-radius: 4px;"
                                                       type="submit" value="<%=ProviderName%> - <%=ProviderCompany%>" />
                                            </p>
                                            
                                            <p style="margin-top: 10px;">
                                                <img style ="padding-bottom: 0; " src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/> 
                                                <%= ProviderEmail %>
                                            </p>
                                            
                                            <p>
                                                <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/> 
                                                <%= ProviderTel %>
                                            </p>
                                            
                                            <p style="color: darkgray; text-align: center; margin: 10px 0;">- <%=AppointmentReason%> -</p>
                                            <a href="ViewSelectedProviderReviews.jsp?Provider=<%=ProviderID%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';" ><p id="ProviderReview<%=JString%>" style="color: green; text-align: center;"></p></a>

                                        </form>
                                        
                                        <form style=" display: none;" id="deleteAppointmentHistoryForm<%=JString%>" class="deleteAppointmentHistoryForm" name="confirmDeleteAppointmentHistory">
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to delete this history</p>
                                            <p><input id="DeleteAppointmentHistoryBtn<%=JString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=JString%>deleteAppointmentHistory" type="button" value="Yes" />
                                                <span onclick = "hideDeleteHistory(<%=JString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="AppointmentIDHistory<%=JString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteAppointmentHistoryBtn<%=JString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var AppointmentID = document.getElementById("AppointmentIDHistory<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("This is history has been removed");
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                                        <td><input id="submitReviewBtn<%=JString%>" style="background-color: darkslateblue; color: white; border: 0; padding: 5px; border-radius: 4px;"
                                                                           type="button" value="Send" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                                                           
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#submitReviewBtn<%=JString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
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
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                                        
                                                        document.getElementById("submitReviewBtn<%=JString%>").style.backgroundColor = "darkslateblue";
                                                        document.getElementById("submitReviewBtn<%=JString%>").disabled = false;
                                                        
                                                    }
                                                } , 1);
                                                    
                                                    
                                            </script>
                                        
                                        <form style=" display: none;" id="addFavProvFormFromRecent<%=JString%>" class="addFavProvForm" name="addFavProvForm">
                                            <input id="CustomerIDforAddFav<%=JString%>" type="hidden" name="CustomerID" value="<%=UserID%>"/>
                                            <input id="ProviderIDforAddFav<%=JString%>" type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                            <input id="addFavProvBtn<%=JString%>" style="margin: 10px; background-color: darkslateblue; border: 0; color: white; padding: 5px; border-radius: 4px; font-weight: bolder;" type="button" value="Add person to favorites" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#addFavProvBtn<%=JString%>').click(function(event) {  
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProviderIDforAddFav<%=JString%>").value;
                                                        var CustomerID = document.getElementById("CustomerIDforAddFav<%=JString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "addFavProvController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          
                                                          document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
                                                          
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
                                                                                        '<div class="MainPropicContainer" style="border: 5px solid white; width: 150px; height: 150px; overflow: hidden;">'+
                                                                                            '<img style="width: 150px; height: auto;" src="data:image/jpg;base64,'+provProPic+'" />'+
                                                                                        '</div>'+
                                                                                    '</div>' +

                                                                                    '<div style="padding-top: 75px;">' +
                                                                                    '<b><p style="font-size: 20px; margin-top: 15px;">' +
                                                                                     provName + '</p></b>' +
                                                                                    '<p>' +
                                                                                     provCompany +
                                                                                    '<span style="color: goldenrod; font-size: 18px;">'+
                                                                                     ratingStars +
                                                                                    '</span></p>' +


                                                                                    '<div style="width: 70%;">' +

                                                                                    '<form style=" display: block;" id="deleteFavProviderForm" class="deleteFavProvider" name="deleteFavProvider" action="RemoveLastFavProv" method="POST" >' +

                                                                                    '<p><input id="DeleteFavProvBtn" style="background-color: crimson; border: none; color: white; padding: 5px; border-radius: 4px; cursor: pointer;" name="deleteFavProv" type="submit" value="Delete this Provider from your Favorites" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
                                                                                    '</span></p>' +
                                                                                    '<input id="ProvID" type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                    '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                    '<input type="hidden" name="User" value="'+UserName+'" />' +

                                                                                    '</form>' +

                                                                                    '<center><form name="bookFromFavoritesForm" action="EachSelectedProviderLoggedIn.jsp" method="POST">' +
                                                                                        '<input type="hidden" name="UserID" value="'+ProviderID+'" />' +
                                                                                        '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                        '<input type="hidden" name="User" value="'+UserName+'" />' +
                                                                                        '<input style=" background-color: darkslateblue; border: 0; padding: 5px; border-radius: 4px; color: white;" type="submit" value="Find a Spot" onclick="document.getElementById(\'MainProviderCustomerPagePageLoader\').style.display = \'block\';"/>' +
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
                                    
                                    <center><p style="color: white; margin-top: 30px; margin-bottom: 30px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> Your history is empty</p></center>
                                    
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
                              
                                     <!--p style="color: black; margin: 10px;">Your Favorite Providers</p-->
                                      
                                <%
                                    
                                    if(favProvidersList.size() == 0){
                                        
                                 
                                %>
                                     
                                     <p id="noFavProvStatus" style ="color: white; margin-top: 30px; margin-bottom: 30px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> You don't have any favorite providers</p>
                                
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
                    
                                
                                <div id="FavoriteProvDiv<%=SString%>" class="EacFavsDiv" style="overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; margin-bottom: 10px; padding-bottom: 10px; background-color: white; border-radius: 5px; max-width: 700px;">
                                    
                                    <div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                        <div class='MainPropicContainer' style='border: 5px solid white; width: 150px; height: 150px; overflow: hidden;'>
                                            <img style='width: 150px; height: auto;' src="data:image/jpg;base64,<%=base64Image%>" />
                                        </div>
                                    </div>
                                    
                                    <div style="padding-top: 75px;">
                                    <b><p style="font-size: 20px; margin-top: 15px;">
                                          <%=FavProvFullName%></p></b>
                                    <p>
                                        <%=FavProvCompany%>
                                    </p>
                                    <p style="font-size: 20px; color: #37a0f5; font-weight: bolder; text-align: center; margin-bottom: 10px;">
                                        <span style="color: tomato;">Overall Rating: </span>
                                        <span style="font-size: 20px; margin-left: 10px;">
                                            <%
                                                if(FavRatings ==5){

                                            %> 
                                                ★★★★★ 
                                                <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Recommended</span></i>
                                            <%
                                                }else if(FavRatings == 4){
                                            %>
                                                ★★★★☆ 
                                                <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Recommended</span></i>
                                            <%
                                                }else if(FavRatings == 3){
                                            %>
                                                ★★★☆☆ 
                                                <i class="fa fa-thumbs-up" style="color: orange; font-size: 16px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Average</span></i>
                                            <%
                                                }else if(FavRatings == 2){
                                            %>
                                                ★★☆☆☆ 
                                                <i class="fa fa-exclamation-triangle" style="color: red; font-size: 17px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Bad rating</span></i>
                                            <%
                                                }else if(FavRatings == 1){
                                            %>
                                                ★☆☆☆☆   
                                                <i class="fa fa-thumbs-down" aria-hidden="true" style="color: red; font-size: 16px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Worst rating</span></i>
                                            <%}%>
                                        </span>
                                                        
                                    </p>
                                    
                                    
                                    <div style="width: 70%;">
                                        
                                        <form style=" display: none;" id="deleteFavProviderForm<%=SString%>" class="deleteFavProvider" name="deleteFavProvider">
                                            
                                            <p style="color: red; margin-top: 10px;">Are you sure you want to remove this Provider from your favorites</p>
                                            <p><input id="DeleteFavProvBtn<%=SString%>" style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=s%>deleteFavProv" type="button" value="Yes" />
                                                <span onclick = "hideDeleteFavProv(<%=SString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 1.9px; cursor: pointer;"> No</span></p>
                                            <input id="ProvID<%=SString%>" type="hidden" name="UserID" value="<%=FavProvID%>" />
                                            <script>
                                               $(document).ready(function() {                        
                                                    $('#DeleteFavProvBtn<%=SString%>').click(function(event) {  
                                                        
                                                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                                                        
                                                        var ProvID = document.getElementById("ProvID<%=SString%>").value;
                                                        
                                                        $.ajax({  
                                                            type: "POST",  
                                                            url: "RemoveFavProvController",  
                                                            data: "UserID="+ProvID,  
                                                            success: function(result){  
                                                              alert(result);
                                                              document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'none';
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
                                        <input style=" background-color: darkslateblue; border: 0; padding: 5px; border-radius: 4px; color: white;" type="submit" value="Find a Spot" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"/>
                                        </form></center>
                                        
                                        
                                    </div>
                                            
                                    </div>    
                                        
                                        <a href="AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                            <p style="font-weight: bolder; color: darkblue; text-align: center; padding: 5px; max-width: 300px;">see all favorites...</p></a>
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
                       
                <script>
                    function LogoutMethod(){
                        document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                        window.localStorage.removeItem("QueueUserName");
                        window.localStorage.removeItem("QueueUserPassword");
                    }
                </script>
                
                <form style="display: none;" class='middleScreenWidthLogoutBtn' action = "LogoutController" name="LogoutForm" method="POST"> 
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <input style="width: 95%; height: auto;" type="submit" value="Logout" class="button" onclick="LogoutMethod()"/>
                </form> 
                
                </div>
                    
        </div>
                
                <div id="IframesDiv">
                    
                   <script defer>
                       var OnloadedExplore = 0;
                       
                       function OnloadExploreMeth(){
                           $("html, body").animate({ scrollTop: 0}, "fast");
                           OnloadedExplore = 1;
                       }
                       
                       function checkExploreLoadStatus(){
                           
                           if(document.getElementById("ExploreDiv").style.display === "none"){
                                document.getElementById("ExploreLoading").style.display = "none";
                            }else if(OnloadedExplore === 1){
                                document.getElementById("ExploreLoading").style.display = "none";
                            }else{
                                document.getElementById("ExploreLoading").style.display = "block";
                                    
                            }
                            
                       }
                       
                        $(document).ready(()=>{
                                setInterval(
                                    function(){
                                        if($(window).width() < 1000){
                                            checkExploreLoadStatus();
                                        }
                                }, 1);
                            })
                        
                   </script>
                    
                   <iframe onload="OnloadExploreMeth();" style="position: absolute; background: none; margin-top: -2px;" id="ExploreDiv" src=""></iframe>       
                   
                   <script defer>
                       
                       if($(window).width() < 1000){
                           document.getElementById("ExploreDiv").src = "ProviderCustomerExploreWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                       }
                       
                       var OnloadedSpots = 0;
                       
                       function OnloadSpotsMeth(){
                           $("html, body").animate({ scrollTop: 0}, "fast");
                           OnloadedSpots = 1;
                       }
                       
                        function checkSpotsLoadStatus(){
                           
                           if(document.getElementById("SpotsIframe").style.display === "none"){
                                document.getElementById("SpotsLoading").style.display = "none";
                            }else if(OnloadedSpots === 1){
                                document.getElementById("SpotsLoading").style.display = "none";
                            }else{
                                document.getElementById("SpotsLoading").style.display = "block";
                                    
                            }
                            
                       }
                       
                       $(document).ready(()=>{
                            setInterval(
                                function(){
                                    if($(window).width() < 1000){
                                        checkSpotsLoadStatus();
                                    }
                            }, 1);
                        });
                       
                   </script>
                   
                   <iframe onload="OnloadSpotsMeth();" id="SpotsIframe" style="position: absolute; background: none; display: none; margin-top: -2px;"  src=""></iframe>
                   
                   <script defer>
                       
                       /*if($(window).width() < 1000){
                           document.getElementById("SpotsIframe").src = "ProviderCustomerSpotsWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                       }*/
                       
                       var OnloadedFavorites = 0;
                       
                       function OnloadFavoritesMeth(){
                           $("html, body").animate({ scrollTop: 0}, "fast");
                           OnloadedFavorites = 1;
                       }
                       
                   </script>
                   
                   <iframe onload="OnloadFavoritesMeth();" id="FavoritesIframe" style="position: absolute; background: none; margin-top: -2px; display: none;" src=""></iframe>
                   
                   <script defer>
                       
                       /*if($(window).width() < 1000){
                           document.getElementById("FavoritesIframe").src = "AllFavProviders.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                       }*/
                       
                       var OnloadedUser = 0;
                       
                       function OnloadAccountMeth(){
                           $("html, body").animate({ scrollTop: 0}, "fast");
                           OnloadedUser = 1;
                       }
                       
                        function checkUserAcountWindowLoadStatus(){
                           
                           if(document.querySelector(".UserProfileContainer").style.display === "none"){
                                document.getElementById("UserProfileLoading").style.display = "none";
                            }else if(OnloadedUser === 1){
                                document.getElementById("UserProfileLoading").style.display = "none";
                            }else{
                                document.getElementById("UserProfileLoading").style.display = "block";
                                    
                            }
                            
                       }
                       
                       $(document).ready(()=>{
                            setInterval(
                                function(){
                                    if($(window).width() < 1000){
                                        checkUserAcountWindowLoadStatus();
                                    }
                            }, 1);
                        });
                   </script>
                   
                   <iframe onload="OnloadAccountMeth();" style="position: absolute; background: none; display: none; margin-top: -2px;" id="UsrAccountIframe" class="UserProfileContainer" src=""></iframe>
                   
                   <script defer>
                       
                       /*if($(window).width() < 1000){
                           document.getElementById("UsrAccountIframe").src = "ProviderCustomerUserAccountWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                       }*/
                       
                       var OnloadedSearch = 0;
                       
                       function OnloadSearchIframetMeth(){
                           $("html, body").animate({ scrollTop: 0}, "fast");
                           OnloadedSearch = 1;
                           
                       }
                       
                        function checkSeachLoadStatus(){
                           
                           if(document.getElementById("SearchIframe").style.display === "none"){
                                document.getElementById("SearchLoading").style.display = "none";
                            }else if(OnloadedSearch === 1){
                                document.getElementById("SearchLoading").style.display = "none";
                            }else{
                                document.getElementById("SearchLoading").style.display = "block";
                                    
                            }
                            
                       }
                       
                       $(document).ready(()=>{
                            setInterval(
                                function(){
                                    if($(window).width() < 1000){
                                        checkSeachLoadStatus();
                                    }
                            }, 1);
                        });
                       
                   </script>
                   
                   <iframe onload="OnloadSearchIframetMeth();" id="SearchIframe" style="position: absolute; background-color: #6699ff; display: none;"  src=""></iframe>
                   
                   <script>
                       
                       //document.getElementById("UserProfileLoading").style.display = "none";
                       //document.getElementById("SearchLoading").style.display = "none";
                       //document.getElementById("SpotsLoading").style.display = "none";
                       //document.getElementById("FavoritesLoading").style.display = "none";
                       
                    </script>
                    
                </div>
                   
        <div class="DashboardFooter" style='background-color: #212c2c; position: relative; z-index: 100 !important; padding-top: 0;' id="footer">
            <div id="CosmeticsSection" style="padding-top: 0;">
                <div style="background-color: #212c2c; padding: 0 10px; margin-bottom: 40px; padding-top: 5px; padding-bottom: 30px;">
                    <h1 style='color: white; font-size: 19px; font-family: serif; padding: 20px 0;'>Popular Services</h1>
                    
                    <div id="PopularSvcDiv" style="display: flex; flex-direction: row; justify-content: space-between; max-width: 700px; margin: auto; padding-left: 10px; padding-right: 10px;">
                        
                    </div>
                    <style>
                        .eachPopularService{
                            cursor: pointer;
                        }
                        /*.eachPopularService:hover{
                            border-bottom: 1px solid #224467;
                        }*/
                        @media only screen and (max-width: 700px){
                            .dontShowMobile{
                                display: none;
                            }
                        }
                    </style>
                    
                    <p style='margin: auto; margin-bottom: 20px; margin-top: 30px; display: block; border-bottom: #374949 1px solid; max-width: 700px;'></p>
                    <h1 style='color: white; font-size: 19px; font-family: serif; padding: 10px 0;'>Suggested Places</h1>
                    
                    <div id="SuggestedPlcsDiv" style="max-width: 1000px; margin: auto; text-align: center;">
                        
                    </div>
                    
                    <p style='margin: auto; margin-bottom: 20px; margin-top: 30px; display: block;'></p>
                    <h1 id="PlacesInYourAreaP" style='color: white; font-size: 19px; font-family: serif; padding: 10px 0;'></h1>
                    <script>
                        document.getElementById("PlacesInYourAreaP").innerText = "Places found in " + (GoogleReturnedTown ? GoogleReturnedTown : " your town");
                    </script>
                    <div style="max-width: 1000px; margin: auto; text-align: center;">
                        <canvas style="width: 100%; height: 100%; min-height: 250px;" id="line-chart"></canvas>
                    </div>
                    
                </div>
                <div>
                    <h1 style='color: orange; font-size: 22px; font-family: serif;'>What is Queue Appointments</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto; color: black;'>
                        Queue Appointments is a website and app that lets you find medical and beauty places near your location to book appointments.
                        It also provides features for the businesses to post news updates with pictures to keep you informed about their services
                        and products.
                    </p>
                    <div class='CosmeSectFlex'>
                        <div id="BkApptOnlnInfoDiv" class='eachCSecFlex'>
                            
                        </div>
                        <div id="FindBarberShopsNearInfoDiv" class='eachCSecFlex marginUp20'>
                            
                        </div>
                        <div id="FindBwtyTymOnlnDiv" class='eachCSecFlex marginUp20'>
                            
                        </div>
                    </div>
                    
                    <h1 style='color: orange; font-size: 22px; font-family: serif; margin-top: 40px;'>We have the best services in your area</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto; color: black;'>
                        Your ratings, reviews and feedbacks mean a lot to us. We are constantly watching how well businesses serve their customers in order to ensure that only the best medical and beauty places operate on 
                        our platform. Queue Appointments will eventually disassociate with badly rated businesses.
                    </p>
                    
                    <div id="YourRvwsCosmeticFlexDiv" class='CosmeSectFlex' style='margin: auto; margin-top: 20px; max-width: 1000px;'>
                        
                    </div>
                </div>
            </div>
            <div class='CosmeSectFlex' style='margin: auto; margin-top: 20px; max-width: 1000px;'>
                <div id='footerContactsDiv' class='eachCSecFlex'>
                    <h1 style='color: #06adad; text-align: justify'>Contact</h1>
                    <p style='padding: 5px; font-weight: bolder; margin-top: 10px; text-align: justify;'><i style='margin-right: 15px; font-size: 20px;' class="fa fa-map-marker" aria-hidden="true"></i> 260 Manning Blvd</p> 
                    <p style='text-align: justify; padding-left: 35px;'>Albany, NY</p>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                 display: flex; flex-direction: column;'>
                        <p style='text-align: justify; font-weight: bolder;'><i style='margin-right: 15px; font-size: 20px;' class='fa fa-phone'></i> +1 732-799-9546</p>
                        <p style='text-align: justify; font-weight: bolder;'><i style='margin-right: 15px; font-size: 20px;' class='fa fa-phone'></i> +1 518-898-3991</p>
                        <p style='text-align: justify; font-weight: bolder;'><i style='margin-right: 15px;' class='fa fa-envelope'></i> support@theomotech.com</p>
                        
                    </div>
                </div>
                <style>
                    @media only screen and (max-width: 1000px){
                        #footerContactsDiv p{
                            text-align: center !important;
                        }
                        #footerContactsDiv h1{
                            text-align: center !important;
                        }
                        #footerContactsDiv{
                            padding-bottom: 30px !important;
                        }
                    }
                </style>
                <div class='eachCSecFlex'>
                    <h1 style='color: #06adad;'>About the company</h1>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 10px;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                        <p style='color: white; padding: 5px;'>Queue appointments is a product of Theomotech Inc. Theomotech as a Tech company is
                            dedicated to providing businesses with Software and IT solutions in order to help improve their business operations and 
                            <span style='color: #ccc;'>increase in revenue... 
                                <br/><br/><a href="https://theomotech.herokuapp.com" style="color: #ccc;" target="_blank">read more 
                                    <i style="color: white; margin-left: 5px;" class="fa fa-long-arrow-right" aria-hidden="true"></i></a>
                            </span>
                        </p>
                        
                    </div>
                </div>
                <div class='eachCSecFlex'>
                    <h1 style='color: #06adad'></h1>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                 display: flex; justify-content: flex-end; flex-direction: column;'>
                                <p style='text-align: center;'><img src='TMTlogo.svg'  style='width: 80px; height: 40px'/></p>
                                <p style='color: #37a0f5; padding: 5px;'>Theomotech Inc. &copy;2020</p>
                                <p style='color: darkgray; font-size: 13px;'>All rights reserved</p>
                                <p style="margin-top: 10px;">
                                    <a href="https://www.facebook.com/TheoMotech-107976207592401/about/?ref=page_internal" target="_blank">
                                        <i style='padding: 5px; background-color: #374949; color: white; border-radius: 4px; margin: 5px; width: 20px; font-size: 20px;' class="fa fa-facebook" aria-hidden="true"></i> 
                                    </a>
                                    <a href="https://www.linkedin.com/company/theomotech-inc" target="_blank">
                                        <i style='padding: 5px; background-color: #374949; color: white; border-radius: 4px; margin: 5px; width: 20px; font-size: 20px;' class="fa fa-linkedin" aria-hidden="true"></i> 
                                    </a>
                                    <i style='padding: 5px; background-color: #374949; color: white; border-radius: 4px; margin: 5px; width: 20px; font-size: 20px;' class="fa fa-instagram" aria-hidden="true"></i>
                                </p>
                    </div>
                </div>
            </div>
        </div>
                                        
    </div>
                      
    </body>
    <script>
        var ControllerResult = "<%=ControllerResult%>";
        
        if(ControllerResult !== "null")
            alert(ControllerResult);
        
        /*var iframes = Array.prototype.slice.call(document.getElementsByTagName("iframe"));
            iframes.forEach(iframe => {
                //console.log(iframe);
                iframe.onclick = function(){
                    alert("clicked");
                    if(count < 10){
                        stopTimer();
                    }
                };
            });*/
    </script>
    
    <script defer>
        $(document).ready(()=>{
            if($(window).width() > 1000){

                document.getElementById("main").innerHTML =
                        `<center><h4 style="margin-bottom: 10px; padding-top: 10px; color: #3d6999; max-width: 300px"> Search By Category </h4></center>

                        <div id="firstSetProvIcons">
                        <center><table id="providericons">
                                <tbody>
                                <tr>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                                    </a></center></td>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectDentistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                                    </a></center></td>
                                </tr>
                                <tr>
                                    <td><center><a href="QueueSelectPodiatryLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PodiatrySelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectPhysicalTherapyLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="PhysicalTherapySelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectMassageLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MassageSelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                                    </a></center></td>
                                </tr>
                                <tr>
                                    <td><center><a href="QueueSelectTattooLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectMedAesthetLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="margin:0;" name="MedEsthSelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Medical Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                                    </a></center></td>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
                                    </a></center></td>
                                </tr>
                            </tbody>
                            </table></center>

                            <center><p onclick="showSecondSetProvIcons()" style="padding: 5px; width: 50px; margin-top: 5px; cursor: pointer; border-radius: 4px;">
                                <img src="icons/nextIcon.png" alt="" style="width: 35px; height: 35px"/>
                                </p></center>

                        </div>

                        <div id="secondSetProvIcons" style="display: none;">
                            <center><table id="providericons">
                                <tbody>
                                <tr>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectBrowLashLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="EyebrowsSelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                                    </a></center></td>
                                     <td style="width: 33.3%;"><center><a href="QueueSelectDieticianLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="DieticianSelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                                    </a></center></td>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectPetServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="PetServicesSelect" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                                    </a></center></td>
                                </tr>
                                <tr>
                                    <td><center><a href="QueueSelectHomeServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectPiercingLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectHolisticMedicineLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-mortar-and-pestle-100.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                                    </a></center></td>
                                <tr>
                                    <td><center><a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectPersonalTrainerLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                                    </a></center></td>
                                    <td><center><a href="QueueSelectHairSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
                                    </a></center></td>
                                </tr>
                            </tbody>
                            </table></center>

                            <center><p style="margin-bottom: 7px; margin-top: 10px;"><span onclick="showFirstSetProvIcons()" style="padding: 5px; width: 50px; cursor: pointer; border-radius: 4px;">
                                    <img src="icons/previousIcon.png" alt="" style="width: 35px; height: 35px"/>
                                    </span>
                                    <span onclick="showThirdSetProvIcons()" style="padding: 5px; padding-left: 17px; padding-right: 18px; width: 50px; cursor: pointer; border-radius: 4px;">
                                    <img src="icons/nextIcon.png" alt="" style="width: 35px; height: 35px"/>
                                    </span></p></center>

                        </div>

                        <div id="thirdSetProvIcons" style="display: none;">
                                <center><table id="providericons">
                                <tbody>
                                    <tr>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                                    </a></center></td>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectHairRemovalLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                                    </a></center></td>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                                    </a></center></td>
                                    </tr> 
                                    <tr>
                                        <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                                        </a></center></td>
                                    </tr>
                            </tbody>
                            </table></center>

                            <center><p onclick="showSecondFromThirdProvIcons()" style="padding: 5px; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">
                                <img src="icons/previousIcon.png" alt="" style="width: 35px; height: 35px"/>
                                </p></center>

                        </div>`;

                document.getElementById("PopularSvcDiv").innerHTML =
                        `<a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-medical-doctor-100.png" style='width: 40px; height: 40px;'></p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Medical Center</p>
                                    </div>
                                </a>
                                <a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-barber-pole-100.png" style='width: 40px; height: 40px;'></p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Barber Shop</p>
                                    </div>
                                </a>
                                <a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-nails-96.png" style='width: 40px; height: 40px;'><p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Nail Salon</p>
                                    </div>
                                </a>
                                <a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-spa-100.png" style='width: 40px; height: 40px;'></p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Day Spa</p>
                                    </div>
                                </a>
                                <a href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="dontShowMobile eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-cosmetic-brush-96.png" style='width: 40px; height: 40px;'></p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Beauty Salon</p>
                                    </div>
                                </a>
                                <a href="QueueSelectHairSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div class="dontShowMobile eachPopularService">
                                        <p style="text-align: center;"><img src="icons/icons8-hair-dryer-100.png" style='width: 40px; height: 40px;'></p>
                                        <p style="text-align: center; color: #ccc; font-size: 12px;">Hair Salon</p>
                                    </div>
                                </a>`;

                document.getElementById("BkApptOnlnInfoDiv").innerHTML =
                        `<h1>Book your doctor's appointment online</h1>
                         <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; 
                            background-image: url("./DocAppt.jpg"); background-size: cover; background-position: right;
                            display: flex; justify-content: flex-end; flex-direction: column;'>
                              <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>It's a fully automated platform for booking appointments. Your doctor's appointment has never been easier.</p>
                         </div>`;
                document.getElementById("FindBarberShopsNearInfoDiv").innerHTML = 
                        `<h1>Find barber shops near you</h1>
                         <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; 
                            background-image: url("./BarberAppt.jpg"); background-size: cover; background-position: right;
                            display: flex; justify-content: flex-end; flex-direction: column;'>
                              <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>Our recommendations algorithms make it easier for you to find the best barber shops in town</p>
                         </div>`;
                document.getElementById("FindBwtyTymOnlnDiv").innerHTML = 
                        `<h1>Find your beauty time online</h1>
                         <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; 
                            background-image: url("./SpaAppt.jpg"); background-size: cover; background-position: right;
                            display: flex; justify-content: flex-end; flex-direction: column;'>
                              <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>No more waiting on a line. Your service provider has a queue. Find your spot here.</p>
                         </div>`;

                document.getElementById("YourRvwsCosmeticFlexDiv").innerHTML =
                        `<div class='eachCSecFlex'>
                                <h1>Your reviews make a difference</h1>
                                <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                     display: flex; justify-content: flex-end; flex-direction: column;'>
                                    <p style='text-align: center;'><img src='ReviewIcon.png'  style='width: 80px; height: 80px'/></p>
                                    <p style='color: #37a0f5; padding: 5px;'>Always feel free to tell us how you were served. You help us keep the platform clean</p>
                                </div>
                            </div>
                            <div class='eachCSecFlex marginUp20'>
                                <h1>Fast growing community</h1>
                                <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                     display: flex; flex-direction: column;'>
                                    <p style='text-align: center;'><img src='BizGroup.png'  style='width: 80px; height: 80px'/></p>
                                    <p style='color: #37a0f5; padding: 5px;'>More and more businesses are signing up on our platform everyday</p>
                                </div>
                            </div>
                            <div class='eachCSecFlex marginUp20'>
                                <h1>Our businesses keep you posted</h1>
                                <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                                     display: flex; justify-content: flex-end; flex-direction: column;'>
                                    <p style='text-align: center;'><img src='NewsPic.png'  style='width: 80px; height: 80px'/></p>
                                    <p style='color: #37a0f5; padding: 5px;'>Our integrated news feed feature lets businesses post regular news updates to keep you informed</p>
                                </div>
                            </div>`;

                            document.getElementById("SuggestedPlcsDiv").innerHTML =
                                    `<div style="width: 85%; margin: auto;" class="recommendedProvidersDiv">
                                <%
                                    for(int i = 0; i < providersList.size(); i++){

                                        String RProvName = providersList.get(i).getFirstName() + " " + providersList.get(i).getLastName() ;
                                        int ratings = providersList.get(i).getRatings();
                                        String RBizName = providersList.get(i).getCompany();
                                        String RBizType = providersList.get(i).getServiceType().trim();
                                        String RProPic = "";
                                        String RCovPic = "";
                                        int RPID = providersList.get(i).getID();

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

                                             RProPic = Base64.getEncoder().encodeToString(imageBytes);


                                        }
                                        catch(Exception e){}


                                        try{

                                            Class.forName(Driver);
                                            Connection coverConn = DriverManager.getConnection(Url, user, password);
                                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                                            coverPst.setInt(1,RPID);
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

                                                    RCovPic = Base64.getEncoder().encodeToString(imageBytes);


                                                }
                                                catch(Exception e){

                                                }

                                                if(!RCovPic.equals(""))
                                                    break;

                                            }

                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                %>
                                <a href='EachSelectedProviderLoggedIn.jsp?UserID=<%=RPID%>&UserIndex=<%=UserIndex%>&User=<%=NewUserName%>' onclick="document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';">
                                    <div style="min-height: 120px; background-color: #334d81; border-top: 10px solid #ffe96b; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.5), 0px 0px 2.9px rgba(0, 0, 0, 0.5);
                                 border-radius: 5px; margin: 5px; text-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.5), 0px 0px 2.9px rgba(0, 0, 0, 0.5);
                                 background: linear-gradient(rgba( 0, 0, 0, 0.3), rgba(116,115,15,0.8)), url('data:image/jpg;base64,<%=RCovPic%>'); background-size: cover;
                                 background-position: center; padding: 30px 10px; display: flex; flex-direction: column; justify-content: space-between;">
                                        <div style='display: flex; flex-direction: row; justify-content: space-between;'>
                                            <div>
                                                <div style="overflow: hidden; border-radius: 100%; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.5), 0px 0px 2.9px rgba(0, 0, 0, 0.5); width: 70px; height: 70px;">
                                                    <img src="data:image/jpg;base64,<%=RProPic%>" style="width: 70px; height: auto; min-height: 70px;">
                                                </div>
                                            </div>
                                            <div>
                                                <p style="color: #fefde5; font-weight: bolder; font-size: 17px;"><%=RProvName%></p>
                                                <p style="font-size: 20px; max-width: 200px; color: #37a0f5; font-weight: bolder; text-align: center; margin-bottom: 10px;">
                                                            <span style="font-size: 20px; margin-left: 10px;">
                                                            <%
                                                                if(ratings ==5){

                                                            %> 
                                                            ★★★★★ 
                                                            <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: white; font-size: 10px;"> Recommended</span></i>
                                                            <%
                                                                 }else if(ratings == 4){
                                                            %>
                                                            ★★★★☆ 
                                                            <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: white; font-size: 10px;"> Recommended</span></i>
                                                            <%
                                                                 }else if(ratings == 3){
                                                            %>
                                                            ★★★☆☆ 
                                                            <i class="fa fa-thumbs-up" style="color: orange; font-size: 16px; margin-left: 20px;"><span style="color: white; font-size: 10px;"> Average</span></i>
                                                            <%
                                                                 }else if(ratings == 2){
                                                            %>
                                                            ★★☆☆☆ 
                                                            <i class="fa fa-exclamation-triangle" style="color: red; font-size: 17px; margin-left: 20px;"><span style="color: white; font-size: 10px;"> Bad rating</span></i>
                                                            <%
                                                                 }else if(ratings == 1){
                                                            %>
                                                            ★☆☆☆☆   
                                                            <i class="fa fa-thumbs-down" aria-hidden="true" style="color: red; font-size: 16px; margin-left: 20px;"><span style="color: white; font-size: 10px;"> Worst rating</span></i>
                                                            <%}%>
                                                            </span>

                                                        </p>
                                            </div>

                                        </div>
                                        <p style='color: #ffe96b; font-weight: bolder;'><!--i style="color: tomato;" class="fa fa-briefcase" aria-hidden="true"></i--><%=RBizName%></p>
                                        <p style="color: #ccc; margin-top: -3px;">- <%=RBizType%> -</p>
                                    </div>
                                </a>
                                <%}%>

                              </div>
                              <%
                                 if(providersList.size() == 0){
                               %>
                                    <p style='color: white;'><i class='fa fa-exclamation-triangle' style='color: yellow;'></i> Oops! We have no recommendations at this time</p>
                               <%}%>`;

            }

            if($(window).width() < 1000){
                document.getElementById("MainMenuItemsTable").innerHTML =
                        `<tbody>
                                    <tr>
                                        <td>
                                            <div id="MobileMenuNewBtn" style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-google-news-50.png" width="25" height="22" alt="icons8-google-news-50"/>
                                                <p style='margin-top: 0;'>News</p>
                                            </div>
                                        </td>
                                        <td>
                                            <div id="MobileSettingsBtn" class='MobileSettingsPageBtn' style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-settings-50.png" width="23" height="20" alt="icons8-settings-50"/>
                                                <p style='margin-top: 0;'>Settings</p>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div id="MobileNotificationBtn" class='MobileSettingsPageBtn' style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-notification-50.png" width="25" height="22" alt="icons8-notification-50"/>
                                                <sup style='color: white; background-color: red; margin-left: -20px; border-radius: 50px; padding-left: 4px; padding-right: 4px;'><%=notiCounter%></sup>
                                                <p style='margin-top: 0;'>Notifications</p>
                                            </div>
                                        </td>
                                        <td>
                                            <div id="MobileCalendarBtn" class='MobileSettingsPageBtn' style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-calendar-50.png" width="22" height="21" alt="icons8-calendar-50"/>
                                                <p style='margin-top: 0;'>Calender</p>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="MenuGoBackBtn">
                                            <div style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-arrow-pointing-left-100.png" width="20" height="19" alt="icons8-sign-out-50"/>
                                                <p style='margin-top: 0;'>Dashboard</p>
                                            </div>
                                        </td>
                                        <td style="background: linear-gradient(-45deg, #ffe96b, #ff6b6b);">
                                            <a onclick="LogoutMethod()" href="LogoutController?UserIndex=<%=UserIndex%>"><div style='color: black;'>
                                                <img style='border-radius: 2px;' src="icons/icons8-sign-out-50.png" width="20" height="19" alt="icons8-sign-out-50"/>
                                                <p style='margin-top: 0;'>Logout</p>
                                            </div>
                                            </a>

                                        </td>
                                    </tr>

                                </tbody>`;
    
                $(document).ready(()=>{
                    $("#MenuGoBackBtn").click(function(event){
                        ToggleMenuDisplay();
                    });
                });
                
                var showMobileNews = ()=>{
                    ToggleMenuDisplay();
                   
                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
                    document.getElementById("ExploreDiv").src = "NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>";

                    document.getElementById("ActiveSpotsIcon").style.display = "none";
                    document.getElementById("SpotsIcon").style.display = "block";

                    document.getElementById("ActiveUserProfile").style.display = "none";
                    document.getElementById("SecondFavoritesIcon").style.display = "none";
                    document.getElementById("RegularUserProfile").style.display = "block";

                    document.getElementById("RegularExploreIcon").style.display = "none";
                    document.getElementById("FavoritesIcon").style.display = "block";
                    document.getElementById("ActiveExploreIcon").style.display = "block";

                    document.getElementById("ExploreBtnText").style.color = "darkblue";
                    document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("AccountBtnTxt").style.color = "#7e7e7e";

                    $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                    $(".UserProfileContainer").hide("slide", { direction: "right" }, 10);
                    $("#ExploreDiv").show("slide", { direction: "left" }, 10);
                    $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                    $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                    document.getElementById("ExploreDiv").style.display = "block";

                    document.body.scrollTop = 0;
                    document.documentElement.scrollTop = 0;
                };
                $("#MobileMenuNewBtn").click(function(event){
                    showMobileNews();
                });
                
                var showMobileSettings = ()=>{
                    ToggleMenuDisplay();
                   
                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
       
                    document.getElementById("ActiveSpotsIcon").style.display = "none";
                    document.getElementById("SpotsIcon").style.display = "block";

                    document.getElementById("ActiveUserProfile").style.display = "none";
                    document.getElementById("SecondFavoritesIcon").style.display = "none";
                    document.getElementById("RegularUserProfile").style.display = "block";

                    document.getElementById("RegularExploreIcon").style.display = "none";
                    document.getElementById("FavoritesIcon").style.display = "block";
                    document.getElementById("ActiveExploreIcon").style.display = "block";

                    document.getElementById("ExploreBtnText").style.color = "darkblue";
                    document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("AccountBtnTxt").style.color = "#7e7e7e";

                    $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                    $(".UserProfileContainer").hide("slide", { direction: "right" }, 10);
                    $("#ExploreDiv").show("slide", { direction: "left" }, 10);
                    $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                    $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                    document.getElementById("ExploreDiv").style.display = "block";

                    document.body.scrollTop = 0;
                    document.documentElement.scrollTop = 0;
                };
                
                document.getElementById("ExploreDiv").addEventListener("load", ()=>{
                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = "none";
                });
                
                $(".MobileSettingsPageBtn").click(function(event){
                    showMobileSettings();
                });
                
                $("#MobileSettingsBtn").click(function(event){
                    document.getElementById("ExploreDiv").src = "CustomerSettingsPage.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=3";
                });
                $("#MobileNotificationBtn").click(function(event){
                    document.getElementById("ExploreDiv").src = "CustomerSettingsPage.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=1";
                });
                $("#MobileCalendarBtn").click(function(event){
                    document.getElementById("ExploreDiv").src = "CustomerSettingsPage.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=2";
                });
                
                function showUploadPhotoPage(){
                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = 'block';
       
                    document.getElementById("ActiveSpotsIcon").style.display = "none";
                    document.getElementById("SpotsIcon").style.display = "block";

                    document.getElementById("ActiveUserProfile").style.display = "block";
                    document.getElementById("SecondFavoritesIcon").style.display = "none";
                    document.getElementById("RegularUserProfile").style.display = "none";

                    document.getElementById("RegularExploreIcon").style.display = "block";
                    document.getElementById("FavoritesIcon").style.display = "block";
                    document.getElementById("ActiveExploreIcon").style.display = "none";

                    document.getElementById("ExploreBtnText").style.color = "#7e7e7e";
                    document.getElementById("SpotsBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("FavoritesBtnTxt").style.color = "#7e7e7e";
                    document.getElementById("AccountBtnTxt").style.color = "darkblue";

                    $("#SpotsIframe").hide("slide", { direction: "right" }, 10);
                    $("#ExploreDiv").hide("slide", { direction: "right" }, 10);
                    $(".UserProfileContainer").show("slide", { direction: "left" }, 10);
                    $("#FavoritesIframe").hide("slide", { direction: "right" }, 10);
                    $("#SearchIframe").hide("slide", { direction: "right" }, 10);
                    document.getElementById("ExploreDiv").style.display = "none";
                    document.getElementsByClassName("UserProfileContainer")[0].style.display = "block";

                    document.body.scrollTop = 0;
                    document.documentElement.scrollTop = 0;
                    
                    document.getElementsByClassName("UserProfileContainer")[0].src = "UploadPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>";
                    
                }
                
                document.getElementById("showUploadPhotoBtn").addEventListener("click", showUploadPhotoPage);
                document.getElementsByClassName("UserProfileContainer")[0].addEventListener("load", ()=>{
                    document.getElementById('MainProviderCustomerPagePageLoader').style.display = "none";
                });
                
            }
        });
    </script>
    
    <script>
        if($(window).width() > 1000){
            $(document).ready(function(){
                $('.recommendedProvidersDiv').slick({
                    infinite: true,
                    slidesToShow: 3,
                    slidesToScroll: 3,
                    dots: false,
                    responsive: [
                    {
                      breakpoint: 1024,
                      settings: {
                        slidesToShow: 3,
                        slidesToScroll: 3,
                        infinite: true,
                        dots: true
                      }
                    },
                    {
                      breakpoint: 850,
                      settings: {
                        slidesToShow: 2,
                        slidesToScroll: 2
                      }
                    },
                    {
                      breakpoint: 480,
                      settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                      }
                    }
                    // You can unslick at a given breakpoint now by adding:
                    // settings: "unslick"
                    // instead of a settings object
                  ]
                  });
            });
        }
    </script>
    
    <script>
        
        if($(window).width() > 1000){
            
            var main_script = document.createElement('script');
            main_script.setAttribute('src','scripts/script.js');
            document.body.appendChild(main_script);
            
            var updateUserProfile = document.createElement('script');
            updateUserProfile.setAttribute('src','scripts/updateUserProfile.js');
            document.body.appendChild(updateUserProfile);
            
            var customerReviewsAndRatings = document.createElement('script');
            customerReviewsAndRatings.setAttribute('src','scripts/customerReviewsAndRatings.js');
            document.body.appendChild(customerReviewsAndRatings);
            
            var ChangeProfileInformationFormDiv = document.createElement('script');
            ChangeProfileInformationFormDiv.setAttribute('src','scripts/ChangeProfileInformationFormDiv.js');
            document.body.appendChild(ChangeProfileInformationFormDiv);
            
            var SettingsDivBehaviour = document.createElement('script');
            SettingsDivBehaviour.setAttribute('src','scripts/SettingsDivBehaviour.js');
            document.body.appendChild(SettingsDivBehaviour);
            
            var data_chart_local_script = document.createElement('script');
            data_chart_local_script.setAttribute('src','scripts/data_charts.js');
            document.body.appendChild(data_chart_local_script);
        }
        
    </script>
    
    <!--script src="scripts/script.js"></script-->
    <!--script src="scripts/checkAppointmentDateUpdate.js"></script-->
    <!--script src="scripts/updateUserProfile.js"></script>
    <script src="scripts/customerReviewsAndRatings.js"></script>
    <script src="scripts/SettingsDivBehaviour.js"></script>
    <script src="scripts/ChangeProfileInformationFormDiv.js"></script-->
</html>
