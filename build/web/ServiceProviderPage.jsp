<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>
<%@page import="javax.websocket.Session"%>
<%@page import="java.util.Calendar"%>
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
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page import="com.arieslab.queue.queue_model.ProviderInfo"%>
<!DOCTYPE html>
<html lang="en-US">
    <head>                         
        
        <script>
            document.cookie = "SameSite=None";
            document.cookie = "SameSite=None; Secure";
            //alert(document.cookie);
        </script>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue | Business</title>
        
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
    
    </head>
   
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
        
        String GlobalUserName = "";
        String GlobalUserPassword = "";
        
        if(session.getAttribute("ThisProvUserName") != null && session.getAttribute("ThisProvUserPassword") != null){
            GlobalUserName = session.getAttribute("ThisProvUserName").toString();
            GlobalUserPassword = session.getAttribute("ThisProvUserPassword").toString();
        }
        
    %>
    
    <script>
        var GlobalUserName = '<%=GlobalUserName%>';
        var GlobalUserPassword = '<%=GlobalUserPassword%>';
        
        //check condition for in order to make sure we aren't storing empty strings or null inside of GlobalUserName and GlobalUserPassword
        if((GlobalUserName !== 'null' && GlobalUserPassword !== 'null') || (GlobalUserName !== '' && GlobalUserPassword !== '') ){
            
            if(window.localStorage.getItem("ProvQueueUserName") === null && window.localStorage.getItem("ProvQueueUserPassword") === null){
                window.localStorage.setItem("ProvQueueUserName", GlobalUserName);
                window.localStorage.setItem("ProvQueueUserPassword", GlobalUserPassword);
            }
        }
    </script>
    
    <%
        
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String Url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String user = config.getServletContext().getAttribute("DBUser").toString();
        String password = config.getServletContext().getAttribute("DBPassword").toString();
        
        int notiCounter = 0;
        
        String NewsPicSrc = "view-wallpaper-7.jpg";
        String lastNewsMsg = "Use Queue upates to advertise your products and services and also to keep customers informed";
        String LastNewsID = "";
        
        int d = 0;
        
        Date ThisDate = new Date();//default date constructor returns current date 
        String CurrentTime = ThisDate.toString().substring(11,16);
        String CurrentDay = ThisDate.toString().substring(0,3);
        
        boolean isSameUserName = true;
        boolean isSameSessionNumber = true;
        boolean isTrySuccess = true;
        
        String DailyOpenTime = "";
        String DailyOffTime = "";
        int openHour = 0;
        int openMinute = 0;
        int offHour = 0;
        int offMinute = 0;
        
        ProviderInfo ThisProvider = new ProviderInfo(); //Default Constructor
        
        //resetting TimeOpen fields
        ThisProvider.TimeOpen.SundayStart = "";
        ThisProvider.TimeOpen.SundayClose = "";
        ThisProvider.TimeOpen.MondayStart = "";
        ThisProvider.TimeOpen.MondayClose = "";
        ThisProvider.TimeOpen.TuesdayStart = "";
        ThisProvider.TimeOpen.TuesdayClose = "";
        ThisProvider.TimeOpen.WednessdayStart = "";
        ThisProvider.TimeOpen.WednessdayClose = "";
        ThisProvider.TimeOpen.ThursdayStart = "";
        ThisProvider.TimeOpen.ThursdayClose = "";
        ThisProvider.TimeOpen.FridayStart = "";
        ThisProvider.TimeOpen.FridayClose = "";
        ThisProvider.TimeOpen.SaturdayStart = "";
        ThisProvider.TimeOpen.SaturdayClose = "";
        
        //Temp Daily start and cloing times
        String MDS = "", MDC = "", TDS = "", TDC = "", WDS = "", WDC = "", THDS = "", THDC = "", FDS = "", FDC = "", SDS = "", SDC = "", SnDS = "", SnDC = "";
        
        String FullName = "";
        String ProvFirstName = "";
        String ProvMiddleName = "";
        String ProvLastName = "";
        String Email = "";
        String PhoneNumber = "";
        String Company = "";
        String ServiceType = "";
        String Address = "";
        String base64Image = "";
        String base64Cover = "";
        int Ratings = 0;
        String FirstNameAndCompany = "";
        ServicesAndPrices Services = new ServicesAndPrices();
        
        
        int UserID = 0;
        ProviderPhotos.ProviderID = 0;
        
        int JustLogged = 0;
        int UserIndex = -1;
        String NewUserName = "";
        String UserNameFrmList = "";
        String ControllerResult = "";
        
        boolean isIndexAttribute = false;
        boolean isUserNameAttribute = false;
        
        try{
            ControllerResult = request.getParameter("result");
        }catch(Exception e){}
        
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

            if(tempAccountType.equals("BusinessAccount")){
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
                ProviderPhotos.ProviderID = UserID;
                UserNameFrmList = UserAccount.LoggedInUsers.get(UserIndex).getName();
            }

            //incase of array flush
            if(!NewUserName.equals(UserNameFrmList)){
                isSameUserName = false;
            }


        }catch(Exception e){
            isTrySuccess = false;
        }
        
        String SessionID = request.getRequestedSessionId();
        String DatabaseSession = "";
        
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
            
            isSameSessionNumber = false;
        }
        
        if(!isSameSessionNumber || UserID == 0 || !isSameUserName || !isTrySuccess){
    %>
            <script>
                var tempUserName = window.localStorage.getItem("ProvQueueUserName");
                var tempUserPassword = window.localStorage.getItem("ProvQueueUserPassword");
                
                document.location.href="LoginControllerMainRedirect?username="+tempUserName+"&password="+tempUserPassword;
                //window.location.replace("LoginControllerMain?username="+tempUserName+"&password="+tempUserPassword);

            </script>
    <%
        }
        else if(JustLogged == 1){
            response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
        }
      
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Query = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID=?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setInt(1,UserID);
            ResultSet provider = pst.executeQuery();
            
            while(provider.next()){
                
                ThisProvider = new ProviderInfo(provider.getInt("Provider_ID"), provider.getString("First_Name"), provider.getString("Middle_Name")
                                ,provider.getString("Last_Name"),provider.getDate("Date_Of_Birth"),provider.getString("Phone_Number")
                                , provider.getString("Company"), provider.getInt("Ratings"), provider.getString("Service_Type"), provider.getString("First_Name") + " - " + provider.getString("Company"), provider.getBlob("Profile_Pic"), provider.getString("Email"));
                
                FullName = ThisProvider.getFirstName() + " " + ThisProvider.getMiddleName() + " " + ThisProvider.getLastName() ;
                Email = ThisProvider.getEmail();
                PhoneNumber = ThisProvider.getPhoneNumber();
                Ratings = ThisProvider.getRatings();
                Company = ThisProvider.getCompany();
                ProvFirstName = provider.getString("First_Name").trim();
                ProvMiddleName = provider.getString("Middle_Name").trim();
                ProvLastName = provider.getString("Last_Name").trim();
                                        
                            

                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob profilepic = ThisProvider.getProfilePicture(); 
                    InputStream inputStream = profilepic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                    base64Image = Base64.getEncoder().encodeToString(imageBytes);


                }catch(Exception e){}
                ServiceType = ThisProvider.getServiceType();
                FirstNameAndCompany = ThisProvider.getNameAndCompany();
            }
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        String HouseNumber = "";
        String StreetName = "";
        String Town = "";
        String City = "";
        String Country = "";
        String ZipCode = "";
        
        
        try{
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Query = "Select * from QueueObjects.ProvidersAddress where ProviderID=?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setInt(1,UserID);
            ResultSet address = pst.executeQuery();
            
            while(address.next()){
                HouseNumber = address.getString("House_Number");
                StreetName = address.getString("Street_Name").trim();
                Town = address.getString("Town").trim();
                City = address.getString("City").trim();
                Country = address.getString("Country").trim();
                ZipCode = address.getString("Zipcode");
                
                Address = HouseNumber + " " + StreetName + ", " + Town + ", " + City + ", " + Country + " " + ZipCode;
                
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        try{
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(Url, user, password);
            String Select = "Select * from QueueServiceProviders.ServicesAndPrices where ProviderID=?";
            PreparedStatement pst = conn.prepareStatement(Select);
            pst.setInt(1,UserID);
            ResultSet services = pst.executeQuery();
            
            while(services.next()){
                Services.setServicesAndPrices(services.getString("ServiceName"), services.getString("Price"));
                Services.setDescription(services.getString("ServiceDescription"));
                Services.setDuration(services.getInt("ServiceDuration"));
                Services.setID(services.getInt("ServiceID"));
                
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection timeConn = DriverManager.getConnection(Url, user, password);
            String timeQuery = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
            PreparedStatement timePst = timeConn.prepareStatement(timeQuery);
            timePst.setInt(1,UserID);
            ResultSet timeRows = timePst.executeQuery();
            
            while(timeRows.next()){
                
                ThisProvider.TimeOpen.MondayStart = timeRows.getString("MondayStart").substring(0,5);
                MDS = timeRows.getString("MondayStart").substring(0,5);
                
                int Hour = Integer.parseInt(ThisProvider.TimeOpen.MondayStart.substring(0,2));
                String Minute = ThisProvider.TimeOpen.MondayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.MondayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.MondayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.MondayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.MondayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.MondayClose = timeRows.getString("MondayClose").substring(0,5);
                MDC = timeRows.getString("MondayClose").substring(0,5); 
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.MondayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.MondayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.MondayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.MondayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.MondayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.MondayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.TuesdayStart = timeRows.getString("TuesdayStart").substring(0,5);
                TDS = timeRows.getString("TuesdayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.TuesdayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.TuesdayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.TuesdayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.TuesdayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.TuesdayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.TuesdayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.TuesdayClose = timeRows.getString("TuesdayClose").substring(0,5);
                TDC = timeRows.getString("TuesdayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.TuesdayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.TuesdayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.TuesdayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.TuesdayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.TuesdayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.TuesdayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.WednessdayStart = timeRows.getString("WednessdayStart").substring(0,5);
                WDS = timeRows.getString("WednessdayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.WednessdayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.WednessdayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.WednessdayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.WednessdayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.WednessdayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.WednessdayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.WednessdayClose = timeRows.getString("WednessdayClose").substring(0,5);
                WDC = timeRows.getString("WednessdayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.WednessdayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.WednessdayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.WednessdayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.WednessdayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.WednessdayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.WednessdayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.ThursdayStart = timeRows.getString("ThursdayStart").substring(0,5);
                THDS = timeRows.getString("ThursdayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.ThursdayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.ThursdayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.ThursdayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.ThursdayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.ThursdayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.ThursdayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.ThursdayClose = timeRows.getString("ThursdayClose").substring(0,5);
                THDC = timeRows.getString("ThursdayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.ThursdayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.ThursdayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.ThursdayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.ThursdayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.ThursdayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.ThursdayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.FridayStart = timeRows.getString("FridayStart").substring(0,5);
                FDS = timeRows.getString("FridayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.FridayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.FridayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.FridayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.FridayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.FridayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.FridayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.FridayClose = timeRows.getString("FridayClose").substring(0,5);
                FDC = timeRows.getString("FridayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.FridayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.FridayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.FridayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.FridayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.FridayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.FridayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.SaturdayStart = timeRows.getString("SaturdayStart").substring(0,5);
                SDS = timeRows.getString("SaturdayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.SaturdayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.SaturdayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.SaturdayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.SaturdayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.SaturdayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.SaturdayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.SaturdayClose = timeRows.getString("SaturdayClose").substring(0,5);
                SDC = timeRows.getString("SaturdayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.SaturdayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.SaturdayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.SaturdayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.SaturdayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.SaturdayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.SaturdayClose += " am";
                    
                }
                
                ThisProvider.TimeOpen.SundayStart = timeRows.getString("SundayStart").substring(0,5);
                SnDS = timeRows.getString("SundayStart").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.SundayStart.substring(0,2));
                Minute = ThisProvider.TimeOpen.SundayStart.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.SundayStart = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.SundayStart = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.SundayStart += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.SundayStart += " am";
                    
                }
                
                ThisProvider.TimeOpen.SundayClose = timeRows.getString("SundayClose").substring(0,5);
                SnDC = timeRows.getString("SundayClose").substring(0,5);
                
                Hour = Integer.parseInt(ThisProvider.TimeOpen.SundayClose.substring(0,2));
                Minute = ThisProvider.TimeOpen.SundayClose.substring(2,5);
                
                if(Hour > 12){
                    
                    Hour -= 12;
                    ThisProvider.TimeOpen.SundayClose = Hour + Minute + " pm";
                
                }
                else if(Hour == 00){
                    
                    ThisProvider.TimeOpen.SundayClose = "12"+ Minute + " am";
                    
                }
                else if(Hour == 12){
                    
                    ThisProvider.TimeOpen.SundayClose += " pm";
                    
                }
                else{
                    
                    ThisProvider.TimeOpen.SundayClose += " am";
                    
                }
                
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            if(CurrentDay.equalsIgnoreCase("Mon")){
                DailyOpenTime = MDS;
                DailyOffTime = MDC;
            }
            if(CurrentDay.equalsIgnoreCase("Tue")){
                DailyOpenTime = TDS;
                DailyOffTime = TDC;
            }
            if(CurrentDay.equalsIgnoreCase("Wed")){  
                DailyOpenTime = WDS;
                DailyOffTime = WDC;
            }
            if(CurrentDay.equalsIgnoreCase("Thu")){
                DailyOpenTime = THDS;
                DailyOffTime = THDC;
            }
            if(CurrentDay.equalsIgnoreCase("Fri")){
                DailyOpenTime = FDS;
                DailyOffTime = FDC;
            }
            if(CurrentDay.equalsIgnoreCase("Sat")){
                DailyOpenTime = SDS;
                DailyOffTime = SDC;
            }
            if(CurrentDay.equalsIgnoreCase("Sun")){
                DailyOpenTime = SnDS;
                DailyOffTime = SnDC;
            }
             
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(DailyOpenTime == "")
            DailyOpenTime = "01:00";
        if(DailyOffTime == "")
            DailyOffTime = "23:00";
        
        if(DailyOpenTime.length() <5)
            DailyOpenTime = "0" + DailyOpenTime;
        if(DailyOffTime.length() < 5)
            DailyOffTime = "0" + DailyOffTime;
        
        openHour = Integer.parseInt(DailyOpenTime.substring(0,2));
        openMinute = Integer.parseInt(DailyOpenTime.substring(3,5));
        offHour = Integer.parseInt(DailyOffTime.substring(0,2));
        offMinute = Integer.parseInt(DailyOffTime.substring(3,5));
        
    
    %>
    
    <%
        boolean isFirstIntervalsSet = false;
        int IntervalsValue = 30;
        
        try{
            
            Class.forName(Driver);
            Connection intervalsConn = DriverManager.getConnection(Url, user, password);
            String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
            PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);
            
            intervalsPst.setInt(1, UserID);
            
            ResultSet intervalsRec = intervalsPst.executeQuery();
            
            while(intervalsRec.next()){
                isFirstIntervalsSet = true;
                IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isFirstIntervalsSet == false){
            try{
                Class.forName(Driver);
                Connection intervalsConn = DriverManager.getConnection(Url, user, password);
                 String intervalsString = "Insert into QueueServiceProviders.Settings (If_providerID, Settings, CurrentValue) values (?,'SpotsIntervals',?)";
                 PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);
                 intervalsPst.setInt(1, UserID);
                 intervalsPst.setString(2, "30");
                 
                 intervalsPst.executeUpdate();
            
            }catch(Exception e){
                e.printStackTrace();
            }
        }
       
    %>
    
                    <%
                        //getting coverdata
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(Url, user, password);
                            String coverString = "Select top 1 * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,UserID);
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
                        
                        String UserName = "";
                        String Password = "";
                                            
                        try{
                                                
                            Class.forName(Driver);
                            Connection UsrAcntConn = DriverManager.getConnection(Url, user, password);
                            String UsrAcntString = "select * from QueueServiceProviders.UserAccount where Provider_ID = ?";
                            PreparedStatement UsrAcntPst = UsrAcntConn.prepareStatement(UsrAcntString);
                            UsrAcntPst.setInt(1, UserID);
                                                
                            ResultSet UsrAcntRec = UsrAcntPst.executeQuery();
                                                
                            while(UsrAcntRec.next()){
                                                    
                                UserName = UsrAcntRec.getString("UserName").trim();
                            }
                                                
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                                       
                    %>
                    
                    <%
                        
                        try{
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            
                            Class.forName(Driver);
                            Connection NotiConn = DriverManager.getConnection(Url, user, password);
                            
                            String Query = "Select top 11 Noti_Type, What, Noti_Status, ID from QueueServiceProviders.Notifications where (ProvID = ? and Noti_Type not like 'Today%')"
                                    + "or (ProvID = ? and Noti_Date = ? and Noti_Type like 'Today%') order by ID desc";
                            PreparedStatement pst = NotiConn.prepareStatement(Query);
                            pst.setInt(1, UserID);
                            pst.setInt(2, UserID);
                            pst.setString(3, sdf.format(new Date()));
                            ResultSet Rec = pst.executeQuery();
                            
                            while(Rec.next()){
                                
                                if(Rec.getString("Noti_Status") == null){
                                    notiCounter++;
                                }
                                
                                if(notiCounter > 10)
                                    break;
                            }
                                
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    %>
                    
                    <%
                       //getting galleryphotos
                       
                       ArrayList<String> Base64GalleryPhotos = new ArrayList<>();
                       
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(Url, user, password);
                            String coverString = "Select top 7 * from QueueServiceProviders.CoverPhotos where ProviderID = ? order by PicID desc";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,UserID);
                            ResultSet cover = coverPst.executeQuery();
                            
                            while(cover.next()){
                                
                                 try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = cover.getBlob("GalaryPhoto"); 
                                InputStream inputStream = profilepic.getBinaryStream();
                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead = -1;

                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    outputStream.write(buffer, 0, bytesRead);
                                }

                                byte[] imageBytes = outputStream.toByteArray();

                                Base64GalleryPhotos.add(Base64.getEncoder().encodeToString(imageBytes));


                            }
                            catch(Exception e){

                            }
                                 
                                 if(Base64GalleryPhotos.size() > 6)
                                     break;
                                
                            }
                            
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                        
                        String firstPic = "";
                        String secondPic = "";
                        String thirdPic = "";
                        String fourthPic = "";
                        String fithPic = "";
                        String sixthPic = "";
                        String seventhPic = "";
                        
                        try{
                            
                            firstPic = Base64GalleryPhotos.get(1);
                            seventhPic = Base64GalleryPhotos.get(0);
                            secondPic = Base64GalleryPhotos.get(2);
                            thirdPic = Base64GalleryPhotos.get(3);  
                            fourthPic = Base64GalleryPhotos.get(4);
                            fithPic = Base64GalleryPhotos.get(5);
                            sixthPic = Base64GalleryPhotos.get(6);
                            
                        }catch(Exception e){}
                        
                    %>
                    
    <%
        //getting booked appointments here
        ArrayList<BookedAppointmentList> AppointmentList = new ArrayList<>();
        ArrayList<BookedAppointmentList> FutureAppointmentList = new ArrayList<>();
        ArrayList<BookedAppointmentList> AppointmentListExtra = new ArrayList<>();
        
        //Getting Future Appointments
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StrinCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection appointmentConn = DriverManager.getConnection(Url, user, password);
            String appointment = "Select top 10 * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate > ? order by AppointmentDate asc";
            PreparedStatement appointmentPst = appointmentConn.prepareStatement(appointment);
            
            appointmentPst.setInt(1,UserID);
            appointmentPst.setString(2, StrinCurrentdate);
            ResultSet rows = appointmentPst.executeQuery();
            
            BookedAppointmentList ListItem;
            
            while(rows.next()){
                
                String Reason = rows.getString("OrderedServices").trim();
                if(Reason.equals("Blocked Time")){
                    
                    continue;
                    
                }
                
                String CustomerID = rows.getString("CustomerID");
                String customerFirstName = "";
                String customerMiddleName = "";
                String customerLastName = "";
                String customerFullName = "";
                String customerEmail = "";
                String customerPhone = "";
                Blob customerPic = null;
                
                try{
                    Class.forName(Driver);
                    Connection customerConn = DriverManager.getConnection(Url, user, password);
                    String customerSelect = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement customerPst = customerConn.prepareStatement(customerSelect);
                    customerPst.setString(1, CustomerID);
                    ResultSet customerInfo = customerPst.executeQuery();
                    
                    while(customerInfo.next()){
                        
                        customerFirstName = customerInfo.getString("First_Name").trim();
                        customerMiddleName = customerInfo.getString("Middle_Name").trim();
                        customerLastName = customerInfo.getString("Last_Name").trim();
                        customerFullName = customerFirstName + " " + customerMiddleName + " " + customerLastName;
                        customerEmail = customerInfo.getString("Email").trim();
                        customerPhone = customerInfo.getString("Phone_Number").trim();
                        customerPic = customerInfo.getBlob("Profile_Pic");
                        
                    }
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                String AppointmentTime = rows.getString("AppointmentTime").substring(0,5);
              
                int AppointmentID = rows.getInt("AppointmentID");
                int CustID = Integer.parseInt(CustomerID);
                
                Date AppointmentDate = rows.getDate("AppointmentDate");
                
                ListItem = new BookedAppointmentList(AppointmentID, CustID, customerFullName, null, customerPhone, customerEmail, AppointmentDate, AppointmentTime, customerPic);
                ListItem.setAppointmentReason(Reason);
                
                FutureAppointmentList.add(ListItem);
                
                
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //Getting Today's Appointments
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StrinCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            int TempHour2 = Integer.parseInt(CurrentTimeForAppointment.substring(0,2));
            int TempMinute2 = Integer.parseInt(CurrentTimeForAppointment.substring(3,5));

            TempHour2 -= 5; //turning this into 300 minutes
                            
            TempMinute2 += 300; //this makes TempMinute2 greater than IntervalsValue according to the prio algo (30 mins algo)
            
            TempMinute2 -= IntervalsValue;
            
            while(TempMinute2 >= 60){
             

                TempHour2++;

                if(TempMinute2 > 60 && TempMinute2 != 60)
                    TempMinute2 -= 60;

                else if(TempMinute2 == 60)
                    TempMinute2 = 0;

                if(TempHour2 > 23)
                    TempHour2 = 23;
            }
            
            //make TempMinute2 greater the the value of IntervalsValue so you can subtract IntervalsValue from it
            
            if(DailyOpenTime != ""){
                                            
                if(TempHour2 < openHour){
                    TempHour2 = openHour;
                    TempMinute2 = openMinute;
                }
            }else if(TempHour2 < 1){
                TempHour2 = 1;
                TempMinute2 = Integer.parseInt(CurrentTime.substring(3,5));
            }
                            
            String SMinute2 = Integer.toString(TempMinute2);
                            
            if(Integer.toString(TempMinute2).length() < 2)
                SMinute2 = "0" + TempMinute2;

            CurrentTimeForAppointment = TempHour2 + ":" + SMinute2;
            //JOptionPane.showMessageDialog(null, CurrentTimeForAppointment);
            
            Class.forName(Driver);
            Connection appointmentConn = DriverManager.getConnection(Url, user, password);
            String appointment = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and AppointmentTime >= ? order by AppointmentTime asc";
            PreparedStatement appointmentPst = appointmentConn.prepareStatement(appointment);
            
            appointmentPst.setInt(1,UserID);
            appointmentPst.setString(2, StrinCurrentdate);
            appointmentPst.setString(3, CurrentTimeForAppointment);
            ResultSet rows = appointmentPst.executeQuery();
            
            BookedAppointmentList ListItem;
            
            while(rows.next()){
               
                String Reason = rows.getString("OrderedServices").trim();
                if(Reason.equals("Blocked Time")){
                    
                    continue;
                    
                }
                
                String CustomerID = rows.getString("CustomerID");
                String customerFirstName = "";
                String customerMiddleName = "";
                String customerLastName = "";
                String customerFullName = "";
                String customerEmail = "";
                String customerPhone = "";
                Blob customerPic = null;
                
                
                try{
                    Class.forName(Driver);
                    Connection customerConn = DriverManager.getConnection(Url, user, password);
                    String customerSelect = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement customerPst = customerConn.prepareStatement(customerSelect);
                    customerPst.setString(1, CustomerID);
                    ResultSet customerInfo = customerPst.executeQuery();
                    
                    
                    while(customerInfo.next()){
                        
                        customerFirstName = customerInfo.getString("First_Name").trim();
                        customerMiddleName = customerInfo.getString("Middle_Name").trim();
                        customerLastName = customerInfo.getString("Last_Name").trim();
                        customerFullName = customerFirstName + " " + customerMiddleName + " " + customerLastName;
                        customerEmail = customerInfo.getString("Email").trim();
                        customerPhone = customerInfo.getString("Phone_Number").trim();
                        customerPic = customerInfo.getBlob("Profile_Pic");
                        
                    }
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                String AppointmentTime = rows.getString("AppointmentTime").substring(0,5);
              
                int AppointmentID = rows.getInt("AppointmentID");
                int CustID = Integer.parseInt(CustomerID);
                
                Date AppointmentDate = rows.getDate("AppointmentDate");
                
                ListItem = new BookedAppointmentList(AppointmentID, CustID, customerFullName, null, customerPhone, customerEmail, AppointmentDate, AppointmentTime, customerPic);
                ListItem.setAppointmentReason(Reason);
                AppointmentList.add(ListItem);
                
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //Getting Today's Appointments for Extras
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StrinCurrentdate = currentDateFormat.format(currentDate);
            
            Class.forName(Driver);
            Connection appointmentConn = DriverManager.getConnection(Url, user, password);
            String appointment = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ?";
            PreparedStatement appointmentPst = appointmentConn.prepareStatement(appointment);
            
            appointmentPst.setInt(1,UserID);
            appointmentPst.setString(2, StrinCurrentdate);
            ResultSet rows = appointmentPst.executeQuery();
            
            BookedAppointmentList ListItem;
            
            while(rows.next()){
               
                String Reason = rows.getString("OrderedServices").trim();
                if(Reason.equals("Blocked Time")){
                    
                    continue;
                    
                }
                
                String CustomerID = rows.getString("CustomerID");
                String customerFirstName = "";
                String customerMiddleName = "";
                String customerLastName = "";
                String customerFullName = "";
                String customerEmail = "";
                String customerPhone = "";
                Blob customerPic = null;
                
                
                try{
                    Class.forName(Driver);
                    Connection customerConn = DriverManager.getConnection(Url, user, password);
                    String customerSelect = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement customerPst = customerConn.prepareStatement(customerSelect);
                    customerPst.setString(1, CustomerID);
                    ResultSet customerInfo = customerPst.executeQuery();
                    
                    
                    while(customerInfo.next()){
                        
                        customerFirstName = customerInfo.getString("First_Name").trim();
                        customerMiddleName = customerInfo.getString("Middle_Name").trim();
                        customerLastName = customerInfo.getString("Last_Name").trim();
                        customerFullName = customerFirstName + " " + customerMiddleName + " " + customerLastName;
                        customerEmail = customerInfo.getString("Email").trim();
                        customerPhone = customerInfo.getString("Phone_Number").trim();
                        customerPic = customerInfo.getBlob("Profile_Pic");
                        
                    }
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                String AppointmentTime = rows.getString("AppointmentTime").substring(0,5);
              
                int AppointmentID = rows.getInt("AppointmentID");
                int CustID = Integer.parseInt(CustomerID);
                
                Date AppointmentDate = rows.getDate("AppointmentDate");
                
                ListItem = new BookedAppointmentList(AppointmentID, CustID, customerFullName, null, customerPhone, customerEmail, AppointmentDate, AppointmentTime, customerPic);
                ListItem.setAppointmentReason(Reason);
                AppointmentListExtra.add(ListItem);
                
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
         //Getting AppointmentHistory
         
         ArrayList<BookedAppointmentList> AppointmentHistory = new ArrayList<>();
         
        try{
            
            Date currentDate = new Date();
            SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String StrinCurrentdate = currentDateFormat.format(currentDate);
            String CurrentTimeForAppointment = currentDate.toString().substring(11,16);
            
            Class.forName(Driver);
            Connection historyConn = DriverManager.getConnection(Url, user, password);
            String appointmentHistoryQuery = "Select top 10 * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate < ? or (ProviderID = ? and AppointmentDate = ? and AppointmentTime < ?) order by AppointmentDate desc";
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
                
                String CustomerID = historyRecords.getString("CustomerID");
                String customerFirstName = "";
                String customerMiddleName = "";
                String customerLastName = "";
                String customerFullName = "";
                String customerEmail = "";
                String customerPhone = "";
                Blob customerPic = null;
                
                try{
                    Class.forName(Driver);
                    Connection customerConn = DriverManager.getConnection(Url, user, password);
                    String customerSelect = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement customerPst = customerConn.prepareStatement(customerSelect);
                    customerPst.setString(1, CustomerID);
                    ResultSet customerInfo = customerPst.executeQuery();
                    
                    while(customerInfo.next()){
                        
                        customerFirstName = customerInfo.getString("First_Name").trim();
                        customerMiddleName = customerInfo.getString("Middle_Name").trim();
                        customerLastName = customerInfo.getString("Last_Name").trim();
                        customerFullName = customerFirstName + " " + customerMiddleName + " " + customerLastName;
                        customerEmail = customerInfo.getString("Email").trim();
                        customerPhone = customerInfo.getString("Phone_Number").trim();
                        customerPic = customerInfo.getBlob("Profile_Pic");
                        
                    }
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
                String AppointmentTime = historyRecords.getString("AppointmentTime").substring(0,5);
              
                int AppointmentID = historyRecords.getInt("AppointmentID");
                int ProviderID = UserID;
                int CustID = Integer.parseInt(CustomerID);
                
                Date AppointmentDate = historyRecords.getDate("AppointmentDate");
                
                eachHistoryRecord = new BookedAppointmentList(AppointmentID, CustID , customerFullName, null, customerPhone, customerEmail, AppointmentDate, AppointmentTime, customerPic);
                eachHistoryRecord.setAppointmentReason(Reason);
                AppointmentHistory.add(eachHistoryRecord);
                
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

       
    %>
    
              
        <%
            //getting first reviews
            ArrayList<ReviewsDataModel> ReviewsList = new ArrayList<>();
        
        try{
            Class.forName(Driver);
            Connection ReviewsConn = DriverManager.getConnection(Url, user, password);
            String ReviewString = "Select top 1 * from QueueServiceProviders.ProviderCustomersReview where ProviderID = ? order by ReviewID desc";
            PreparedStatement ReviewPst = ReviewsConn.prepareStatement(ReviewString);
            ReviewPst.setInt(1, UserID);
            
            ResultSet ReviewRec = ReviewPst.executeQuery();
            
            ReviewsDataModel eachReview; //Create a reference one and assign different objects to it
            
            while(ReviewRec.next()){
                //ReviewsList.clear();
               eachReview = new ReviewsDataModel(); 
                
                eachReview.UserID = ReviewRec.getInt("CustomerID");
                eachReview.ReviewID = ReviewRec.getInt("ReviewID");
                eachReview.Rating = ReviewRec.getInt("CustomerRating");
                eachReview.ReviewMessage = ReviewRec.getString("ReviewMessage").trim();
                eachReview.ReviewDate = ReviewRec.getDate("ReviewDate");
                
                ReviewsList.add(eachReview);
                break;
                
            }
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
   
    <%
        //getting Clientslist Data
        ArrayList<ProviderCustomerData> ClientsList = new ArrayList<>(); 
        
        try{
            
            Class.forName(Driver);
            Connection ClientsConn = DriverManager.getConnection(Url, user, password);
            String ClientsString = "select top 10 * from QueueServiceProviders.ClientsList where ProvID = ? order by ClientID desc";
            PreparedStatement ClientsPST = ClientsConn.prepareStatement(ClientsString);
            ClientsPST.setInt(1, UserID);
            
            ResultSet ClientsRec = ClientsPST.executeQuery();
            
            ProviderCustomerData eachClient;
            
            while(ClientsRec.next()){
                
                int CustomerID = ClientsRec.getInt("CustomerID");
                
                String CustFirstName = "";
                String CustMiddleName = "";
                String CustLastName = "";
                String CustTel = "";
                String CustEmail = "";
                Blob CustProPic = null;
                
                try{
                    Class.forName(Driver);
                    Connection CustomerConn = DriverManager.getConnection(Url, user, password);
                    String CustomerString = "select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement CustomerPst = CustomerConn.prepareStatement(CustomerString);
                    CustomerPst.setInt(1,CustomerID);
                    
                    ResultSet CustRec = CustomerPst.executeQuery();
                    
                    while(CustRec.next()){
                        
                        CustFirstName = CustRec.getString("First_Name");
                        CustMiddleName = CustRec.getString("Middle_Name");
                        CustLastName = CustRec.getString("Last_Name");
                        CustTel = CustRec.getString("Phone_Number");
                        CustEmail = CustRec.getString("Email");
                        CustProPic = CustRec.getBlob("Profile_Pic");
                        
                    }
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
                
                eachClient = new ProviderCustomerData(CustomerID, CustFirstName, CustMiddleName, CustLastName, CustProPic, CustTel, null, CustEmail);
                ClientsList.add(eachClient);
                
            }
          
            
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
    
    <%
        //getting Closed Days
        ArrayList<Integer> ClosedDayID = new ArrayList<>();
        ArrayList<String> ClosedDate = new ArrayList<>();
        try{
            
            Class.forName(Driver);
            Connection ClosedDaysConn = DriverManager.getConnection(Url, user, password);
            String ClosedDaysString = "Select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
            PreparedStatement ClosedDaysPst = ClosedDaysConn.prepareStatement(ClosedDaysString);
            ClosedDaysPst.setInt(1, UserID);
            
            ResultSet ClosedDaysRec = ClosedDaysPst.executeQuery();
            
            while(ClosedDaysRec.next()){
                ClosedDayID.add(ClosedDaysRec.getInt("closedID"));
                ClosedDate.add(ClosedDaysRec.getString("DateToClose"));
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
    
    <%
        
        String status = "not_added";
        
        //getting the subscription status
        try{
            Class.forName(Driver);
            Connection SubsConn = DriverManager.getConnection(Url, user, password);
            String SubsString = "select status from QueueObjects.StripSubscriptions where ProvId = ?";
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
            
            SubsPst.setInt(1, UserID);
            
            ResultSet SubsRec = SubsPst.executeQuery();
            
            while(SubsRec.next()){
                if(SubsRec.getString("status").equalsIgnoreCase("0")){
                    status = "inactive";
                } else if (SubsRec.getString("status").equalsIgnoreCase("1")){
                    status = "active";
                }
            }
            
        }catch(Exception e){}
        
        //JOptionPane.showMessageDialog(null, status);
        
        //Getting Cancellation policy settings
        boolean isSettingExisting = false;
        String isSettingAllowed = "No";
        String TimeElapseValue = "0 mins";
        String ChargePercentValue = "0%";
        
        try{
            Class.forName(Driver);
            Connection CnclConn = DriverManager.getConnection(Url, user, password);
            String CnclString = "Select * from  QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyChargeCost%'";
            PreparedStatement CnclPst = CnclConn.prepareStatement(CnclString);
            CnclPst.setInt(1, UserID);
            ResultSet PlcyRec = CnclPst.executeQuery();
            
            while(PlcyRec.next()){
                isSettingExisting = true;
                
                if(!PlcyRec.getString("CurrentValue").trim().equals("0")){
                    isSettingAllowed = "Yes";
                    //int tempValue = Integer.parseInt(PlcyRec.getString("CurrentValue").trim() );
                    //TimeElapseValue = tempValue + " mins";
                    
                    int tempPercentValue = Integer.parseInt(PlcyRec.getString("CurrentValue").trim());
                    ChargePercentValue = tempPercentValue + "%";
                    
                    /*try{
                        Class.forName(Driver);
                        Connection CnclConnChrg = DriverManager.getConnection(Url, user, password);
                        String CnclStringChrg = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyChargeCost%'";
                        PreparedStatement CnclPstChrg = CnclConnChrg.prepareStatement(CnclStringChrg);
                        CnclPstChrg.setInt(1, UserID);
                        
                        ResultSet ChrgPolicyRec = CnclPstChrg.executeQuery();
                        
                        while(ChrgPolicyRec.next()){
                            
                            int tempPercentValue = Integer.parseInt(ChrgPolicyRec.getString("CurrentValue").trim());
                            
                            ChargePercentValue = tempPercentValue + "%";
                        }
                        
                    }catch(Exception e){
                        e.printStackTrace();
                    }*/
                }
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isSettingExisting == false){
            
            try{
                Class.forName(Driver);
                Connection CnclConn = DriverManager.getConnection(Url, user, password);
                String CnclString = "Insert into QueueServiceProviders.Settings (If_providerID, Settings, CurrentValue) values (?,?,?)";
                PreparedStatement CnclPst = CnclConn.prepareStatement(CnclString);
                CnclPst.setInt(1, UserID);
                CnclPst.setString(2, "CnclPlcyTimeElapse");
                CnclPst.setString(3, "0");
                
                CnclPst.executeUpdate();
            }catch(Exception e){
                e.printStackTrace();
            }
            
            try{
                Class.forName(Driver);
                Connection CnclConn = DriverManager.getConnection(Url, user, password);
                String CnclString = "Insert into QueueServiceProviders.Settings (If_providerID, Settings, CurrentValue) values (?,?,?)";
                PreparedStatement CnclPst = CnclConn.prepareStatement(CnclString);
                CnclPst.setInt(1, UserID);
                CnclPst.setString(2, "CnclPlcyChargeCost");
                CnclPst.setString(3, "0");
                
                CnclPst.executeUpdate();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    %>
    
    <%
        String BusinessName = "";
        String BusinessEmail = "";
        String BusinessTel = "";
        String BusinessType = "";
        
        try{
            Class.forName(Driver);
            Connection bizInfoConn = DriverManager.getConnection(Url, user, password);
            String bizInfoString = "Select * from QueueServiceProviders.BusinessInfo where Provider_ID = ?";
            PreparedStatement bizInfoPst = bizInfoConn.prepareStatement(bizInfoString);
            bizInfoPst.setInt(1, UserID);
            
            ResultSet bizInfoRec = bizInfoPst.executeQuery();
            
            while(bizInfoRec.next()){
                BusinessName = bizInfoRec.getString("Business_Name").trim();
                BusinessEmail = bizInfoRec.getString("Business_Email").trim();
                BusinessTel = bizInfoRec.getString("Business_Tel").trim();
                BusinessType = bizInfoRec.getString("Business_Type").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection lastNewsConn = DriverManager.getConnection(Url, user, password);
            String lastNewsString = "Select top 1 * from QueueServiceProviders.MessageUpdates where ProvID = ? order by MsgID desc";
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
    %>
    <body onload="document.getElementById('ProviderPageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
        <div id='JumbotromBg' class="notShownOnMobile" style="width: 100vw; height: 800px; position: fixed; top: 0px; z-index: -1; background-color: white;"></div>
        
        <div id='notSubscribedCover'>
            <div style='display: flex; flex-direction: column; justify-content: center; height: 100vh;'>
                <div style="margin-bottom: 30px;">
                    <p style="text-align: center; padding: 5px;">
                        <img src="QueueLogo.png" style="height: 50px; width: 120px;"/>
                    </p>
                </div>
                <p style="color: darkblue; font-weight: bolder; text-align: center; margin-bottom: 30px;">
                    <i class="fa fa-exclamation-triangle" style="color: orange;"></i> You have not subscribed
                    <br/>
                    <span style='font-size: 14px; color: #636363;'>your customers won't be able to book any appointments</span>
                </p>
                <p style="color: #636363; font-weight: bolder; text-align: center; margin-bottom: 30px;">
                    All subscription plans come with free trial periods. We don't charge you until after your trial period has elapsed.
                    However, in order for your account to be fully activated, you must subscribe to a plan.
                </p>
                <a href='stripe-payment-view.jsp?providerEmail=<%=Email%>&ProviderId=<%=UserID%>' target='_blank'>
                    <p style='padding: 10px; text-align: center; color: white; background-color: darkslateblue; border-radius: 4px; margin: auto; max-width: 400px;'>Click here to subscribe now</p>
                </a>
                    <p onclick="document.getElementById('notSubscribedCover').style.display = 'none'" style='cursor: pointer; font-size: 16px; margin-top: 20px; color: crimson; text-align: center;'>
                        <i style='color: green' class='fa fa-home'></i> Click here to skip this step</p>
            </div>
        </div>
        <script>
            subscribedFlag = false;
            var subscription_status = '<%=status%>';
            
            if(subscription_status === "active"){
                subscribedFlag = true;
            }else if(subscription_status === "inactive"){
                subscribedFlag = false;
            }else if(subscription_status === "not_added"){
                subscribedFlag = false;
            }
            
            if(subscribedFlag === false){
                document.getElementById('notSubscribedCover').style.display = "block";
            }else{
                document.getElementById('notSubscribedCover').style.display = "none";
            }
        </script>
        
        <div id="ProviderPageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="PermanentDiv" style="">
            
            <div style="float: left; width:fit-content; margin-left: 10px; padding-top: 1px;">
                <img id="" src="QueueLogo.png" style="width: 60px; height: 30px; background-color: white; padding: 4px; border-radius: 4px" />
            </div>
            
            <div style="margin-top: 3px; margin-right: 20px; margin-left: 10px; width: fit-content; display: flex;">
                
                <p style="color: white; text-align: justify;">
                    <i style='' class='fa fa-phone'></i>
                    +1 732-799-9546
                    <br />
                    <i class='fa fa-envelope'></i>
                    support@theomotech.com   
                </p>
            </div>
            
            <ul style="display: block; margin: 0 30px;">
                <li class="active" id='' onclick='showReservation();' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-meeting-time-50.png" width="22" height="19" alt="icons8-calendar-50"/-->
                    <i class="fa fa-plus-square" aria-hidden="true"></i>
                    Make Reservation</li>
                <a onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" href='ProviderSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=2'><li class="active" id='PermDivNotiBtn' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-notification-50.png" width="20" height="17" alt="icons8-notification-50"/-->
                        <i class="fa fa-bell" aria-hidden="true"></i>
                        Notifications<sup style='color: lawngreen; padding-left: 2px; padding-right: 2px;'><%=notiCounter%></sup></li></a> <!--onclick='showCustExtraNotification();'-->
                <li class="active calender_li" id='PermDivCalBtn' onclick='showCustExtraCal();' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/-->
                    <i class="fa fa-calendar" aria-hidden="true"></i>
                    Calender</li>
                <a onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" href='ProviderSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=4'><li class="active" id='PermDivUserBtn' style='cursor: pointer; background-color: #334d81;'><!--img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/-->
                        <i class="fa fa-cog" aria-hidden="true"></i>
                        Account</li></a>
            </ul>
                    
            <div style="margin-left: 20px;">
                <%
                    if(base64Image != ""){
                %>
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                        <div style="border-radius: 100%; margin-left: 5px; min-width: 30px; height: 30px; overflow: hidden; position: absolute;">
                            <img id="" style="width: 30px; min-height: 30px; height: auto; margin-bottom: 20px; position: absolute; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Image%>"/>
                        </div>
                    </div></center>
                <%
                    }else{
                %>
                
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                        <i style="font-size: 34px; color: darkgrey;" class="fa fa-user-circle" aria-hidden="true"></i>
                    </div></center>
                
                <%}%>
            </div>
            
        </div>
             
        <div id="container">
            
            <div id="miniNavPov" style="padding-top: 10px; padding-bottom: 10px; padding-right: 2px; background-color: #334d81; opacity: 0.9">
                <center>
                    <script>
                        function showDropDown(){
                            $("#DropDown").slideDown("fast");
                        }
                        
                        function hideDropDown(){
                            $("#DropDown").slideUp("fast");
                        }
                        
                        function hideDropDownBtnclick(){
                            if(document.getElementById("DropDown").style.display === "block"){
                                $("#DropDown").slideUp("fast");
                            }else{
                                $("#DropDown").slideDown("fast");
                                document.getElementById("DropDown").style.display = "block";
                            }
                        }
                    </script>
                    
                    <div style=' margin-left: 0;'>
                        <div onclick="toggleHideAppointmentsDiv()" style="width: 25%; color: white; float: left; cursor: pointer; border-radius: 4px;">
                            <i style="font-size: 25px;" class="fa fa-users"></i>
                            <p style="font-size: 11px;" id="hideAppointments">Hide Spots</p>
                        </div>
                        <a onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" href='ProviderSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=1'>  
                            <div id="" style="float: left; width: 25%; color: white; cursor: pointer; border-radius: 4px;">
                                <i style="font-size: 25px;" class="fa fa-newspaper-o"></i>
                                <p style="font-size: 11px;">Add News</p>
                            </div>
                        </a>
                        <a onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" href='ProviderSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=2' style='color: white;'>
                            <div id="" style="float: left; width: 25%; color: white; cursor: pointer; border-radius: 4px;">
                                <p style=' width: 13px; position: absolute; z-index: 1000; font-size: 11px; color: red; margin-left: 11%; border: #334d81 1px solid; background-color: white; background-color: white; padding-left: 2px; padding-right: 2px; border-radius: 2px;'><%=notiCounter%></p>
                                <i style="font-size: 25px;" class="fa fa-bell"></i>
                                <p style="font-size: 11px;">Notifications</p>
                            </div>
                        </a>
                        <a onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" href='ProviderSettingsPage.jsp?User=<%=NewUserName%>&UserIndex=<%=UserIndex%>&Settings=4' style='color: white;'>
                            <div id="" style="float: left; width: 25%; color: white; cursor: pointer; border-radius: 4px;">
                                <i style="font-size: 25px;" class="fa fa-cog"></i>
                                <p style="font-size: 11px;">Settings</p>
                            </div>
                        </a>
                    </div>
                    
                    <p style='clear: both;'></p>
                    
                </center>
                
                            <p style="clear: both;"></p>
            </div>
            
            
            <div class="providerHeader" id="ProviderHeader" style="display: none;">
                <cetnter><p> </p></cetnter>
                <center><img src="QueueLogo.png" style="margin-top: 5px;"/></center>
            </div>
                    
            <div>
                
            </div>
    <div id='ProvMainContentFlex'>
        
        <div id="Extras" style="margin-right: 10px; margin-top: 10px;">
            
            <div id='News' style='border-radius: 4px; padding: 0;'>
            
                <p style="color: #254386; font-weight: bolder; margin-bottom: 15px; font-size: 16px; text-align: center;">Update your clients on whats new</p>
                
                <form method="POST" enctype="multipart/form-data">
                <table  id="ExtrasTab" style="box-shadow: none; height: 100%;" cellspacing="0">
                    <tbody>
                        <tr>
                            <td style="padding-bottom: 10px;">
                                <textarea style="padding: 10px; width: calc(100% - 20px); border: 0;" onfocusout="checkEmptyNewTxt();" id="NewsMessageFld" name="TellCustomersMsgBx" rows="5">
                                </textarea>
                                
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="MsgPhotoDisplay"></div>
                                
                                <input id="NewsPhotoFld" style="padding: 10px; margin-left: -10px; display: none;" placeholder="Add a picture" type="file" name="MsgformPhoto" />
                                <label for="NewsPhotoFld" style="font-weight: bolder; color: white; padding: 10px; border-radius: 4px; background-color: #06adad; cursor: pointer;">
                                    <i class="fa fa-picture-o" aria-hidden="true" style="margin-right: 5px;"></i> Add Photo
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                
                                <p style="margin: 15px 0;">Make news visible to: </p>
                                    <input id="VPublicRd" type="radio" name="NewsVisibility" value="Public" checked="checked" /><label for="VPublicRd">Public</label>
                                    <input id="VCustomersRd" type="radio" name="NewsVisibility" value="Customer" /><label  for="VCustomersRd">Only customers</label>
                                
                                <center><input id="SaveNewsBtn" style="border: 0; margin: 15px 0; color: white; padding: 10px; background-color: darkslateblue; border-radius: 4px; width: calc(100% - 30px);" type="button" value="Save" /></center>
                            </td>
                            
                            <script>
                        
                                document.getElementById("NewsMessageFld").value = "Type what you want to post here";
                                
                                function checkEmptyNewTxt(){
                                    if(document.getElementById("NewsMessageFld").value === "")
                                        document.getElementById("NewsMessageFld").value = "Type what you want to post here";
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
                                    document.getElementById('ProviderPageLoader').style.display = 'block';
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
                                            $.ajax({
                                                type:"POST",
                                                data:"MessageID="+data,
                                                url:"getLastProvNews",
                                                success: function(result){
                                                   document.getElementById('ProviderPageLoader').style.display = 'none';
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
                                <div style='height: 360px; overflow-y: auto; padding: 2px;'>
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
                                            document.getElementById('ProviderPageLoader').style.display = 'block';
                                            var MessageID = document.getElementById("RecentMessageID").value;
                                            
                                            $.ajax({
                                                type: "POST",
                                                url: "DltProvNews",
                                                data: "MessageID="+MessageID,
                                                success: function(result){
                                                    alert("Deleted Successfully");
                                                    document.getElementById('ProviderPageLoader').style.display = 'none';
                                                    
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
            
            <div id='Calender' style='display: none; margin-top: 5px;'>
                <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px; margin-top: -10px;">Your Calender</p></center>
            
                <table  id="ExtrasTab" cellspacing="0">
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
                            
                            <div style='padding: 5px; background-color: white;'>
                                    <div onclick="showEventsTr();" id='EventsTrBtn' style='cursor: pointer; border-radius: 4px; padding: 5px; background-color: #eeeeee; width: 45%; float: right;'>Events</div>
                                    <div onclick="showAppointmentsTr();" id='AppointmentsTrBtn' style='cursor: pointer; border-radius: 4px; padding: 5px; background-color: #ccc; width: 45%; float: left;'>Appointments</div>
                                    <p style='clear: both;'></p>
                            </div>
                    
                            <td>
                                <p style='margin-bottom: 5px; color: #ff3333;'>Appointments</p>
                                
                                <input type="hidden" id="CalApptUserID" value="<%=UserID%>" />
                                
                                <div id='CalApptListDiv' style='height: 244px; overflow-y: auto;'>
                                    
                                    <%
                                        int count = 1;
                                        
                                        for(int aptNum = 0; aptNum < AppointmentListExtra.size(); aptNum++ ){
                                            
                                            
                                            
                                            int AptID = AppointmentListExtra.get(aptNum).getAppointmentID();
                                            String ProvName = AppointmentListExtra.get(aptNum).getProviderName();
                                            String ApptReason = AppointmentListExtra.get(aptNum).getReason().trim();
                                            
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
                                                document.getElementById('ProviderPageLoader').style.display = 'block';
                                                var date = document.getElementById("CalDatePicker").value;
                                                var ProviderID = document.getElementById("CalApptUserID").value;
                                                
                                                
                                                $.ajax({
                                                    type: "POST",
                                                    url: "GetProvApptForExtra",
                                                    data: "Date="+date+"&ProviderID="+ProviderID,
                                                    success: function(result){
                                                        
                                                        var ApptData = JSON.parse(result);
                                                        
                                                        var aDiv = document.createElement('div');
                                                        
                                                        for(i in ApptData.Data){
                                                            
                                                            var number = parseInt(i, 10) + 1;
                                                            
                                                            var name = ApptData.Data[i].CustName;
                                                            var service = ApptData.Data[i].Service;
                                                            
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
                                                        document.getElementById('ProviderPageLoader').style.display = 'none';
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
                                <div id='EventsListDiv' style='height: 244px;; overflow-y: auto;'>
                                    <%
                                        try{
                                            
                                             SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                             String SDate = sdf.format(new Date());
                                            
                                            Class.forName(Driver);
                                            Connection EventsConn = DriverManager.getConnection(Url, user, password);
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
                                    <p><input placeholder="add event time" id="DisplayedAddEvntTime" style='background-color: white; width: 92%;' type="text" name="" value="" readonly onkeydown="return false"/></p>
                                        <input id="AddEvntTime" style='background-color: white;' type="hidden" name="EvntTime" value="" />
                                        <p><input placeholder="add event date" id='EvntDatePicker' style='background-color: white; width: 92%;' type="text" name="EvntDate" value="" /></p>
                                    <script>
                                    $(function() {
                                        $("#EvntDatePicker").datepicker({
                                            minDate: 0
                                        });
                                      });
                                    </script>
                                    <p><input placeholder="add event title" id="AddEvntTtle" style='background-color: white; width: 92%;' type="text" name="EvntTitle" value="" /></p>
                                    <p><textarea onfocusout="checkEmptyEvntDesc();" id="AddEvntDesc" name="EvntDesc" rows="7" style='width: 98%; border: 0; background-color: #ccc;'>
                                        </textarea></p>
                                </div>
                            </td>
                        </tr>
                        <tr style="background-color: #eeeeee;">
                            <td>
                                <input type="hidden" id="EvntIDFld" value=""/>
                                <center><input id="CalSaveEvntBtn" style='border: 0; background-color: darkslateblue; color: white; border-radius: 4px; padding: 5px; width: 95%;' type='button' value='Save' /></center>
                                <center><input onclick="" id="CalDltEvntBtn" style='border: 0; float: right; display: none; border-radius: 4px; padding: 5px; color: white;; background-color: darkslateblue; width: 44%;' type='button' value='Delete' />
                                    <input onclick="SendEvntUpdate();" id="CalUpdateEvntBtn" style='border: 0; float: left; display: none; border-radius: 4px; padding: 5px; color: white; background-color: darkslateblue; width: 44%;' type='button' value='Change' /></center>
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
                                    document.getElementById('ProviderPageLoader').style.display = 'block';
                                    var EventID = document.getElementById("EvntIDFld").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "DltProvEvntAjax",
                                        data: "EventID="+EventID,
                                        success: function(result){
                                            if(result === "success")
                                                alert("Event Deleted Successfully");
                                                document.getElementById('ProviderPageLoader').style.display = 'none';
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
                                
                                document.getElementById('ProviderPageLoader').style.display = 'block';
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
                                        url: "UpdateProvEvent",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&EventID="+EvntId,
                                        success: function(result){
                                            
                                            alert("Event Updated Successfully");
                                            
                                            var Evnt = JSON.parse(result);
                                            
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
                                    document.getElementById('ProviderPageLoader').style.display = 'none';
                                
                            }
                        </script>
                        
                        <script>
                            
                            $(document).ready(function(){
                                
                                $("#CalSaveEvntBtn").click(function(event){
                                    document.getElementById('ProviderPageLoader').style.display = 'block';
                                    var EvntTtle = document.getElementById("AddEvntTtle").value;
                                    EvntTtle = EvntTtle.replace("\"","");
                                    var EvntDesc = document.getElementById("AddEvntDesc").value;
                                    EvntDesc = EvntDesc.replace("\"","");
                                    var EvntDate = document.getElementById("EvntDatePicker").value;
                                    var EvntTime = document.getElementById("AddEvntTime").value;
                                    
                                    var CalDate = document.getElementById("CalDatePicker").value;
                                    
                                    var ProvID = document.getElementById("CalApptUserID").value;
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "AddEventProv",
                                        data: "Title="+EvntTtle+"&Desc="+EvntDesc+"&Date="+EvntDate+"&Time="+EvntTime+"&CalDate="+CalDate+"&ProviderID="+ProvID,
                                        success: function(result){
                                            alert("Event Added Successfully");
                                            var Evnt = JSON.parse(result);
                                            
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
                                    
                                    document.getElementById("AddEvntTtle").value = "";
                                    document.getElementById("AddEvntDesc").value = "";
                                    document.getElementById("EvntDatePicker").value = "";
                                    document.getElementById("AddEvntTime").value = "";
                                    document.getElementById("DisplayedAddEvntTime").value = "";
                                    document.getElementById("EvntIDFld").value = "";
                                    document.getElementById('ProviderPageLoader').style.display = 'none';
                                });
                            });
                        </script>
                    </tbody>
                </table>
            </div>
                             
        <div id='ExtrasUserAccountDiv' style='display: none;'>
                <table  id="ExtrasTab" cellspacing="0">
                    
                </table>
            </div>
                                
            <div id='ExtrasNotificationDiv' style='display: none;'>
                
            </div>
        </div>
  
        <div class="ProvidersDashboardContent" id="content" style="min-height: 0 !important; padding-right: 0 !important;"  onclick="hideDropDown();">
                
            <div id="nav" style='padding: 0;'>
                
            </div>
            <div class="ProviderMainDiv" id="main">
                          
                <center><div id="QueuLineDiv" class="provQueueLineDiv" style="margin: 5px; margin-top: 10px; border-radius: 4px; overflow: hidden; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                                        
                                    <%
                                        Date currentDate = new Date();//default date constructor returns current date 
                                        String JSCurrentTime = currentDate.toString().substring(11,16); //forJavaScript;
                                        String DayOfWeek = currentDate.toString().substring(0,3);
                                        SimpleDateFormat formattedDate = new SimpleDateFormat("MMM dd"); //formatting date to a string value of month day, year
                                        String stringDate = formattedDate.format(currentDate); //calling format function to format date object
                                        SimpleDateFormat QuerySdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String QueryDate = QuerySdf.format(currentDate);
                                        
                                        
                                        //this is an arrayList with a Generic of type String
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllAvailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllThisProviderBlockedTime = new ArrayList<>();
                                        ArrayList<String> AllThisProviderBlockedFormattedTakenTime = new ArrayList<>();
                                        ArrayList<String> BlockedAppointmentIDs = new ArrayList<>();
                                        
                                        String DailyStartTime = "";
                                        String DailyClosingTime = "";
                                        String FormattedStartTime = "";
                                        String FormattedClosingTime = "";
                                        
                                        int startHour = 0;
                                        int startMinute = 0;
                                        int closeHour = 0;
                                        int closeMinute = 0;
                                        
                                        int TotalAvailableList = 0;
                                        int TotalUnavailableList = 0;
                                        int TotalThisCustomerTakenList = 0;
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
                                            Connection CloseddConn = DriverManager.getConnection(Url, user, password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setInt(1, UserID);
                                            
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
                                            Connection hoursConn = DriverManager.getConnection(Url, user, password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setInt(1, UserID);
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
                                                
                                                
                                                if(DailyStartTime == "")
                                                    DailyStartTime = "01:00";
                                                if(DailyClosingTime == "")
                                                    DailyClosingTime = "23:00";
                                                
                                                
                                                startHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                                startMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
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
                                                        }
                                               
                                                closeHour = Integer.parseInt(DailyClosingTime.substring(0,2));
                                                closeMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
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
                                                        }
                                                        
                                                        if(closeHour == 0)
                                                            closeHour = 23;
                                            }
                                            catch(Exception e){}
                                        
                                        
                                    %>
                                    
                                    <%
                                        
                                        if(DailyStartTime == "")
                                            DailyStartTime = "01:00";
                                        if(DailyClosingTime == "")
                                            DailyClosingTime = "23:00";
                                                
                                        CurrentTime = DailyStartTime;
                                        int CurrentHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                        int CurrentMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                        
                                        
                                        //do all this for status led
                                        String StatusLedCurrentTime = currentDate.toString().substring(11,16);
                                        int StatusLedCurrentHour = Integer.parseInt(StatusLedCurrentTime.substring(0,2));
                                        int StatusLedCurrentMinute = Integer.parseInt(StatusLedCurrentTime.substring(3,5));
                                        
                                        int CurrentHourForStatusLed = StatusLedCurrentHour;
                                        int CurrentMinuteForStatusLed = StatusLedCurrentMinute;
                                        
                                        if(DailyStartTime != ""){
                                            
                                            if(CurrentHour < startHour){
                                            
                                                CurrentHour = startHour;
                                                CurrentMinute = startMinute;
                                                
                                            }
                                        
                                        }
                                        
                                        String NextAvailableTime = "" ;
                                        String NextAvailableFormattedTime = "";
                                        
                                        int y = 0;
                                        int isFirstAppointmentFound = 0;
                                        int bookedTimeFlag = 0;
                                        int myAppointmentTimeFlag = 0;
                                        
                                        int NextThirtyMinutes = CurrentMinute + 30;
                                        
                                        //use this if there is no appointment for the next hour
                                        int ActualThirtyMinutesAfter = CurrentMinute + 30;
                                        
                                        int NextHour = CurrentHour;
                                        
                                        //use this if there is no appointment for the next hour
                                        int Hourfor30Mins = CurrentHour;
                                        
                                        while(NextThirtyMinutes >= 60){
                                            
                                            ++NextHour;
                                            
                                            if(DailyClosingTime != ""){
                                                
                                                if(NextHour > closeHour && closeHour != 0){

                                                    NextHour = closeHour - 1;

                                                }
                                                else if(closeHour == 0)
                                                    NextHour = 23;
                                                    
                                            }else if(NextHour > 23){
                                                NextHour = 23;
                                            }
                                            
                                            
                                            
                                            if(NextThirtyMinutes > 60)
                                                NextThirtyMinutes -= 60;
                                            
                                            else if(NextThirtyMinutes == 60)
                                                NextThirtyMinutes = 0;
                                        }
                                        
                                        //use this if there is no appointment for the next hour
                                        while(ActualThirtyMinutesAfter >= 60){
                                            
                                            ++Hourfor30Mins;
                                            
                                            if(Hourfor30Mins > 23)
                                                Hourfor30Mins = 23;
                                            
                                            if(ActualThirtyMinutesAfter > 60)
                                                ActualThirtyMinutesAfter -= 60;
                                            
                                            else if(ActualThirtyMinutesAfter == 60)
                                                ActualThirtyMinutesAfter = 0;
                                        }
                                        
                                        String p = Integer.toString(NextThirtyMinutes);
                                        String h = Integer.toString(ActualThirtyMinutesAfter);
                                        
                                        if(p.length() < 2)
                                            p = "0" + p;
                                        
                                        if(h.length() < 2)
                                            h = "0" + h;
                                        
                                        String TimeAfter30Mins = NextHour + ":" + p;
                                        String TimeWith30Mins = Hourfor30Mins + ":" + h;
                                        NextAvailableTime = NextHour + ":" + p;
                                        
                                        int Next30MinsAppointmentFlag = 0;
                                        
                                        //this part of the algorithm changed
                                        int twoHours = CurrentHour + 23;
                                        
                                        if(DailyClosingTime != ""){
                                            
                                            if(twoHours > closeHour && closeHour != 0){

                                                    twoHours = closeHour - 1;

                                                }
                                            else if(closeHour == 0)
                                                twoHours = 23;
                                            
                                        }else if(twoHours > 23){
                                                twoHours = 23;
                                            }
                                        
                                        if(isTodayClosed == true){
                                                
                                                DailyStartTime = "00:00";
                                                DailyClosingTime = "00:00";
                                                
                                            }
                                        
                                    %>
                                    
                                    <!--p id="PMargin" style="height: 60px; display: none;"></p-->
                                    
                                     <%
                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00")){
                                    %>
                                                 
                                    <!--p style="color: tomato;">You are not open on <%=DayOfWeek%>...</p-->
                                    
                                    <%
                                        }else  if(FormattedStartTime != "" || FormattedClosingTime != "" && !(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))){
                                    %>
                                    
                                        <!--p><span>
                                            
                                        <%
                                            if((startHour > CurrentHourForStatusLed || closeHour < CurrentHourForStatusLed) && closeHour != 0){
                                        %>
                                        
                                        <img src="icons/icons8-new-moon-20.png" width="10" height="10" alt="icons8-new-moon-20"/>

                                        
                                        <%
                                            }else{
                                        %>
                                        
                                        <img src="icons/icons8-new-moon-20 (1).png" width="10" height="10" alt="icons8-new-moon-20 (1)"/>

                                        
                                        <%
                                            }
                                        %>
                                            
                                        </span>Hours: <span style="color: tomato"><%=FormattedStartTime%></span> -
                                        <span style="color: tomato"><%=FormattedClosingTime%></span>,
                                        <span style="color: tomato"><%=DayOfWeek%>, <%=stringDate%></span>.</p-->
                                        
                                    <%
                                        }
                                    %>
                                    
                                        <!--p>Next Appointment: <%=NextAvailableTime%></p-->
                                    
                                    <div style="text-align: center;"><p id="TodaysLineP" style='color: darkblue; font-weight: bold; padding: 10px 0;'>Today's Queue</p></div>
                                    <script>
                                        if($(document).width() < 1000){
                                            document.getElementById("PMargin").style.display = "block";
                                        }
                                    </script>
                                    <center><div class="scrolldiv" style="width: 95%; max-width: 600px; overflow-x: auto;">
                                    
                                    <table style="width:100%; max-width: 600px; border-spacing: 20px 5px !important;">
                                        <tbody>
                                            <tr>
                                                
                                            <%
                                                int HowManyColums = 0;
                                                int BookedSpots = 0;
                                                boolean isLineAvailable = false;
                                                boolean broken = false;
                                                
                                                for(int x = CurrentHour; x < twoHours;){
                                                    
                                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                                        break;
                                                  
                                                    for(y = CurrentMinute; y <= 60;){
                                                        if(broken)
                                                            break;
                                                        
                                            %>
                                            
                                            <%
                                                String AppointmentID = "";
                                                 
                                                try{
                                                    
                                                    Class.forName(Driver);
                                                    Connection LineDivConn = DriverManager.getConnection(Url, user, password);
                                                    String LineDivString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                                    
                                                    PreparedStatement LineDivPst = LineDivConn.prepareStatement(LineDivString);
                                                    LineDivPst.setInt(1, UserID);
                                                    LineDivPst.setString(2, QueryDate);
                                                    LineDivPst.setString(3, CurrentTime);
                                                    LineDivPst.setString(4, NextAvailableTime);
                                                    
                                                    ResultSet LineDivRow = LineDivPst.executeQuery();
                                                    
                                                    while(LineDivRow.next()){
                                                        
                                                        bookedTimeFlag = 1;
                                                        
                                                        String Reason = LineDivRow.getString("OrderedServices").trim();
                                                        
                                                        
                                                        if(Reason.equals("Blocked Time")){
                                                            
                                                            bookedTimeFlag = 2;
                                                            AppointmentID = LineDivRow.getString("AppointmentID");
                                                            BlockedAppointmentIDs.add(AppointmentID);
                                                            
                                                        }
                                                        
                                                        CurrentTime = LineDivRow.getString("AppointmentTime");
                                                        
                                                        
                                                        int k = Integer.parseInt(CurrentTime.substring(0,2));
                                                        int l = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        x = Integer.parseInt(CurrentTime.substring(0,2));
                                                        y = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        ++l;
                                                        CurrentTime = k + ":" + l;
                                                        
                                                        break;
                                                      
                                                        
                                                    }
                                                }
                                                catch(Exception e){
                                                    e.printStackTrace();
                                                }
                                            %>
                                            
                                            <%
                                                        
                                                    
                                                String thisMinute = Integer.toString(y);
                                                        
                                                if(thisMinute.length() < 2){
                                                    thisMinute = "0" + thisMinute;
                                                }
                                                        
                                                NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                //formatting the time for user convenience
                                                if( x > 12)
                                                {
                                                    int TempHour = x - 12;
                                                    NextAvailableFormattedTime = Integer.toString(TempHour) + ":" +  thisMinute + "pm";
                                                }
                                                else if(x == 0){
                                                    NextAvailableFormattedTime = "12" + ":" + thisMinute + "am";
                                                }
                                                else if(x == 12){
                                                    NextAvailableFormattedTime = NextAvailableTime + "pm";
                                                }
                                                else{
                                                    NextAvailableFormattedTime = NextAvailableTime +"am";
                                                }
                                                     
                                            %>
                                            
                                            <% 
                                                
                                                if(bookedTimeFlag == 1){
                                                    
                                                    HowManyColums++;
                                                    isLineAvailable = true;
                                                    
                                                    TotalUnavailableList++;
                                                    AllUnavailableTimeList.add(NextAvailableTime);
                                                    AllUnavailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                    int t = d + 1;
                                            %>
                                            
                                            <td onclick="showLineTakenMessage(<%=t%><%=TotalUnavailableList%>)">
                                                <p style="font-size: 12px; font-weight: bold; color: red;"><%=NextAvailableFormattedTime%></p>
                                                <img src="icons/icons8-standing-man-filled-50.png" width="50" height="50" alt="icons8-standing-man-filled-50"/>
                                            </td>
                                                
                                            <%  
                                                    
                                                }
                                            
                                            %>
                                            
                                                <!--td>8:00am<img src="icons/icons8-standing-man-filled-50 (1).png" width="50" height="50" alt="icons8-standing-man-filled-50 (1)"/>
                                                </td-->
                                                
                                            <% 
                                                if(bookedTimeFlag == 0){
                                                    
                                                    HowManyColums++;
                                                    isLineAvailable = true;
                                                    
                                                    TotalAvailableList++;
                                                    AllAvailableTimeList.add(NextAvailableTime);
                                                    AllAvailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                    int t = d + 1;
                                            %>
                                                
                                                 <td onclick="ShowQueueLinDivBookAppointment(<%=t%><%=TotalAvailableList%>)">
                                                     <p style="font-size: 12px; font-weight: bold; color: blue;"><%=NextAvailableFormattedTime%></p>
                                                     <img src="icons/icons8-standing-man-filled-50 (1).png" width="50" height="50" alt="icons8-standing-man-filled-50 (1)"/>
                                                </td>
                                                
                                            <% 
                                                  }

                                            %>
                                                
                                            <%
                                            if(bookedTimeFlag == 2){
                                                
                                                HowManyColums++;
                                                isLineAvailable = true;
                                                
                                                TotalThisCustomerTakenList++;
                                                AllThisProviderBlockedTime.add(NextAvailableTime);
                                                AllThisProviderBlockedFormattedTakenTime.add(NextAvailableFormattedTime);
                                                
                                                int t = d + 1;
                                                
                                            %>
                                            
                                                <td onclick="showYourPositionMessage(<%=t%><%=TotalThisCustomerTakenList%>)">
                                                    <p style="font-size: 12px; font-weight: bold; color: green;"><%=NextAvailableFormattedTime%></p>
                                                    <img src="icons/icons8-standing-man-filled-50 (2).png" width="50" height="50" alt="icons8-standing-man-filled-50 (2)"/>
                                                </td>
                                                
                                            <%  }
                                            
                                                bookedTimeFlag = 0;
                                            
                                            %>
                                               
                                            <% 
                                                        
                                                        y += IntervalsValue;
                                                        
                                                        while(y >= 60){
                                                             
                                                            x++;
                                                            
                                                            if(y > 60)
                                                                y -= 60;
                                                            else if(y == 60)
                                                                y = 0;
                                                             
                                                            if(x > twoHours){
                                                               //breaking out of this inner loop  
                                                               //incidentally the condition of outer loop becomes false
                                                               //thereby exiting as well
                                                               broken = true;
                                                               break;
                                                            }
                                                        }
                                                        
                                                        thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                  
                                                    }
                                                      
                                                }
                                            %>
                                            
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                    </div></center>
                                        
                                     <%
                                         Date thisDate = new Date();
                                         String thisTime = thisDate.toString().substring(11,16);
                                        
                                        for(int z = 0; z < AllThisProviderBlockedFormattedTakenTime.size(); z++){
                                            
                                            String NextThisAvailableTimeForDisplay = AllThisProviderBlockedFormattedTakenTime.get(z);
                                            String NextThisProviderBlockedTime = AllThisProviderBlockedTime.get(z);
                                            String AppointmentID = BlockedAppointmentIDs.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>     
                                            
                                    
                                    <form name="ReleaseSpot" style='display: none; margin: 3px;' id='YourLinePositionMessage<%=t%><%=q%>' action="UnblockSpotController" method="POST">
                                        
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                   <!--p style="color: white; text-align: center;" id="">You blocked <=NextThisAvailableTimeForDisplay%></p-->
                                        
                                    <%
                                        if(thisTime.length() == 4)
                                            thisTime = "0" + thisTime;
                                        if(NextThisProviderBlockedTime.length() == 4)
                                            NextThisProviderBlockedTime = "0" + NextThisProviderBlockedTime;
                                        
                                        int TempThisHour = Integer.parseInt(thisTime.substring(0,2));
                                        int TempThisMinute = Integer.parseInt(thisTime.substring(3,5));
                                        int AppointmentHour = Integer.parseInt(NextThisProviderBlockedTime.substring(0,2));
                                        int AppointmentMinute = Integer.parseInt(NextThisProviderBlockedTime.substring(3,5));
                                        
                                        if(TempThisHour > AppointmentHour){}
                                        
                                        else if(TempThisHour == AppointmentHour){
                                            
                                            if(TempThisMinute <= AppointmentMinute){
                                        
                                    
                                    %>
                                        
                                        <input type="hidden" name="BlockedAppointmentID" value="<%=AppointmentID%>" />
                                        <input type="submit" style="background-color: crimson; padding: 5px; border-radius: 5px;" value="Unblock <%=NextThisAvailableTimeForDisplay%>" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                    
                                    <%      }
                                        }else if(TempThisHour < AppointmentHour) {
                                    %>
                                    
                                        <input type="hidden" name="BlockedAppointmentID" value="<%=AppointmentID%>" />
                                        <input type="submit" style="background-color: crimson; padding: 5px; border-radius: 5px;" value="Unblock <%=NextThisAvailableTimeForDisplay%>" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                    
                                    <%}%>
                                    
                                    </form>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        for(int z = 0; z < AllUnavailableTimeList.size(); z++){
                                            
                                            String NextUnavailableTimeForMessage = AllUnavailableFormattedTimeList.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>
                                   
                                    <%}%>
                                    
                                    <%
                                        if(!isLineAvailable){
                                    %>
                                    
                                    <p style="color: darkgrey; text-align: center; padding: 10px 0;"><i style="color: red;" class="fa fa-exclamation-triangle"></i> No available spots for today</p>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        for(int z = 0; z < AllAvailableTimeList.size(); z++){
                                            
                                            String NextAvailableTimeForForm = AllAvailableTimeList.get(z);
                                            String NextAvailableTimeForFormDisplay = AllAvailableFormattedTimeList.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>
                                    
                                    <form style="display: none;" id="bookAppointmentFromLineDiv<%=t%><%=q%>" name="bookAppointmentFromLineDiv" action="BlockSpotController" method="POST">
                                        <input type="hidden" name="CustomerID" value="1" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="ProviderID" value="<%=UserID%>" />
                                        <input type="hidden" name="formsOrderedServices" value="Blocked Time" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="formsDateValue" value="<%=QueryDate%>" />
                                        <input type="hidden" name="formsTimeValue" value="<%=NextAvailableTimeForForm%>" />
                                        <input type="hidden" name="TotalPrice" value="00.00" />
                                        <input type="hidden" name="payment" value="None" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                        <%
                                        if(thisTime.length() == 4)
                                            thisTime = "0" + thisTime;
                                        if(NextAvailableTimeForForm.length() == 4)
                                            NextAvailableTimeForForm = "0" + NextAvailableTimeForForm;
                                        
                                        int TempThisHour = Integer.parseInt(thisTime.substring(0,2));
                                        int TempThisMinute = Integer.parseInt(thisTime.substring(3,5));
                                        int AppointmentHour = Integer.parseInt(NextAvailableTimeForForm.substring(0,2));
                                        int AppointmentMinute = Integer.parseInt(NextAvailableTimeForForm.substring(3,5));
                                        
                                        if(TempThisHour > AppointmentHour){}
                                        
                                        else if(TempThisHour == AppointmentHour){
                                            
                                            if(TempThisMinute <= AppointmentMinute){
                                        
                                    
                                    %>
                                    
                                        
                                        <input style="background-color: darkslateblue; padding: 5px;" type="submit" value="Block this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                       
                                    <%      }
                                        }else if(TempThisHour < AppointmentHour) {
                                    %>
                                    
                                        <input style="background-color: darkslateblue; padding: 5px;" type="submit" value="Block this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                    
                                    <%}%>
                                    
                                    </form>
                                        
                                    <%}%>
                                    
                                        <!--center><p style="padding-bottom: 10px;">Summary: <span style="color: blue;"><%=HowManyColums%> spots,</span> <span style="color: red;"> <%=TotalUnavailableList%> booked,</span> <span style="color: green;"> <%=TotalThisCustomerTakenList%> blocked</span></p></center-->
                                    
                                        <p style="margin: 20px 0;"><span style="color: blue; border: 1px solid blue;"><img src="icons/icons8-standing-man-filled-50 (1).png" width="30" height="25" alt="icons8-standing-man-filled-50 (1)"/>
                                        Not Taken </span> <span style="color: red; border: 1px solid red;"><img src="icons/icons8-standing-man-filled-50.png" width="30" height="25" alt="icons8-standing-man-filled-50"/>
                                        Taken </span> <span style="color: green; border: 1px solid green; padding-right: 3px;"><img src="icons/icons8-standing-man-filled-50 (2).png" width="30" height="25" alt="icons8-standing-man-filled-50 (2)"/>
                                        Blocked Spot </span> </p>
                                    
                                        <form style=" margin-top: 10px; padding: 5px; padding-bottom: 10px;" name="SpotsIntervalForm" action="SetSpotsIntervalController" method="POST">
                                            <p style="text-align: center; color: #000099; margin: 10px 0; font-weight: bolder;">Change Your Spots Intervals Below</p>
                                            
                                            <div style="display: flex; flex-direction: row; justify-content: center;">
                                                <div style="padding-top: 5px;">
                                                    <select style="border: 0; color: white; padding: 10px 5px; background-color: darkslateblue; color: white; border-radius: 5px;" name="SpotsIntervals">
                                                        <option value="<%=IntervalsValue%>"><%=IntervalsValue%> minutes</option>
                                                        <option value="15">15 minutes</option>
                                                        <option value="30">30 minutes</option>
                                                        <option value="45">45 minutes</option>
                                                        <option value="60">1 hour</option>
                                                        <option value="90">1 hour, 30 minutes</option>
                                                        <option value="120">2 hours</option>
                                                        <option value="150">2 hours, 30 minutes</option>
                                                        <option value="180">3 hours</option>
                                                        <option value="210">3 hours, 30 minutes</option>
                                                        <option value="240">4 hours</option>
                                                        <option value="270">4 hours, 30 minutes</option>
                                                        <option value="300">5 hours</option>
                                                    </select>
                                                    <!--i style="" class="fa fa-caret-down" aria-hidden="true"></i-->
                                                </div>

                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                                <input type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                                <div>
                                                    <input style="background-color: #ff3333; border: 0; color: white; 
                                                           padding: 10px 5px; border-radius: 4px; width: 120px;" 
                                                           type="submit" value="Change" 
                                                           name="SetSpotsIntervalBtn" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                                </div>
                                            </div>
                                                
                                        </form>
                                    </div></center>
                <!------------------------------------------------------------------------------------------------------------------------------------------------------------>
            
                <div style="display: block;" id="appointmentsDiv" style="">
                <div style="margin: 5px; background-color: white; padding: 15px 10px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); border-radius: 4px;">
                                        <h style="color: #44484a; font-weight: bolder; text-align: center; padding-top: 20px;">See Your Bookings Below</p>
                                    
                                        <table cellspacing="0" style="width: 100%; margin-top: 10px;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateProvAppointmentsTab()" id="ProvAppointmentsTab" style="padding: 5px; cursor: pointer; width: 50%; color: darkblue; font-weight: bolder; text-align: center; padding-top: 10px;">
                                                        <i style="margin-right: 5px;" class="fa fa-list" aria-hidden="true"></i> Current Line
                                                    </td>
                                                    <td onclick="activateProvHistoryTab()" id="ProvHistoryTab" style="padding: 5px; cursor: pointer;  color: #8b8b8b; font-weight: bolder; text-align: center;padding-top: 10px;">
                                                        <i style="margin-right: 5px;" class="fa fa-history" aria-hidden="true"></i> History
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        
                                
                    </div>
                    
                    <div class="scrolldiv" style=" height: auto; overflow-y: auto; min-width: 100%; padding-top: 10px;">
                        
                        <script>
                                    
                                                        var currentDate = new Date();
                                                        var currentTime = '<%=JSCurrentTime%>';
                                                        
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
                                                         
                                    </script>
                    
                    <div id="CurrentProvAppointmentsDiv">
                <cetnter><h4 style="margin: 5px;">Next Client</h4></cetnter>
                <table id="ProviderAppointmentList" style="border-spacing: 5px; border: 0; width: 100%;">
                        <tbody>
                            
    <%
                      for(int w = 0; w < AppointmentList.size(); w++){
                      
                          String WString = Integer.toString(w);
                          int AppointmentID = AppointmentList.get(w).getAppointmentID();
                          int CustomerID = AppointmentList.get(w).getProviderID();
                          
                          //note all providerinfo here is customer instead but this is an error from DataStructure inconsistency
                          String Name = AppointmentList.get(w).getProviderName();
                          String Tel = AppointmentList.get(w).getProviderTel();
                          String email = AppointmentList.get(w).getProviderEmail();
                          String Time = AppointmentList.get(w).getTimeOfAppointment();
                          String AppointmentReason = AppointmentList.get(w).getReason().trim();
                          String Base64CustPic = "";
                          
                          try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = AppointmentList.get(w).getDisplayPic(); 
                            InputStream inputStream = profilepic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                             Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}

                          

                            String TimeToUse = "";
                            int Hours = Integer.parseInt(Time.substring(0,2));
                            String Minutes = Time.substring(2,5);

                            if( Hours > 12)
                            {
                                int TempHour = Hours - 12;
                                TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                            }
                            else if(Hours == 0){
                                TimeToUse = "12" + Minutes + "am";
                            }
                            else if(Hours == 12){
                                TimeToUse = Time + "pm";
                            }
                            else{
                                TimeToUse = Time +"am";
                            }
                
                          
                          Date date = AppointmentList.get(w).getDateOfAppointment();
                          
                          SimpleDateFormat sdf = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");
                          String DateOfAppointment = sdf.format(date);
                          
    %>
                       
                            <tr id="ApptRow<%=WString%>">
                                
                                <td id="ApptTD<%=WString%>" style = "padding: 10px; background-color: white; margin: 5px; border: 0; border-radius: 4px;
                                    box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                        
                        <%
                            if(Base64CustPic != ""){
                        %>
                                <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                                        <div style="border-radius: 100%; margin-left: 5px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                            <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
                                        </div>
                                        <!--img class="fittedImg" style="border-radius: 100%; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<=Base64CustPic%>" width="40" height="40"/-->
                                </div></center>
                        <%
                            }
                            
                            if(w == 0){
                            
                        %>
                   
                                <p style='display: flex; flex-direction: row; justify-content: space-between; padding: 5px 10px; margin-bottom: 5px; font-weight: bolder;'>
                                        <span></span>
                                        <span><i style='color: orange;' class="fa fa-info-circle" aria-hidden="true"> </i> 
                                        your current customer</span> 
                                        <i style='color: #4ed164;' class="fa fa-check" aria-hidden="true"></i>
                                </p>
                                
                        <%
                            } else {
                        %>
                        
                                <p style='display: flex; flex-direction: row; justify-content: space-between; padding: 5px 10px; margin-bottom: 5px; font-weight: bolder;'>
                                        <span></span>
                                        <span><i style='color: orange;' class="fa fa-info-circle" aria-hidden="true"> </i> 
                                        customer waiting on line</span> 
                                        <i style='color: green;' class="fa fa-spinner" aria-hidden="true"></i>
                                </p>
                        <%
                            }
                        %>
                        
                                <p style='text-align: center;'>
                                    <img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                    <span style="color: red;"><%=Name%></span> at <span id="ApptTimeSpan<%=WString%>" style="color: red;"><%=TimeToUse%></span>
                                </p>
                                <p style='text-align: center;'>
                                    <img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/> <%=email%>
                                </p>
                                <p style='text-align: center;'>
                                   <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/> <%=Tel%>
                                </p>
                                <p style="text-align: center; color: darkgrey; margin: 10px;">- <%=AppointmentReason%> -
                                </p>
                              
                                    <center>
                                        <input id="PIDCAddClient<%=WString%>" type="hidden" value="<%=UserID%>" />
                                        <input id="CCustIDAddClient<%=WString%>" type="hidden" name="CustomerID" value="<%=CustomerID%>" />
                                        <input type="button" id="AddClientsFromCurBtn<%=WString%>" style="cursor: pointer; background: 0; text-align: center; border: none; background-color: darkslateblue; border-radius: 4px; color: white; margin-top: 5px; padding:10px 5px;"
                                           value="Add person to clients" />
                                        <script>
                                                
                                            $(document).ready(function(){
                                                $("#AddClientsFromCurBtn<%=WString%>").click(function(event){
                                                    document.getElementById('ProviderPageLoader').style.display = 'block';
                                                    var CustomerID = document.getElementById("CCustIDAddClient<%=WString%>").value;
                                                    var ProviderID = document.getElementById("PIDCAddClient<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "AddClientsListController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID, 
                                                        
                                                        success: function(result){  
                                                          //alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          if(result === "notInList"){
                                                              
                                                              $.ajax({
                                                                  type: "POST",
                                                                  url: "getLastAddedClientAjax",
                                                                  data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                  success: function(result){
                                                                      var Customer = JSON.parse(result);
                                                                      var CustName = Customer.Name;
                                                                      var CustEmail = Customer.Email;
                                                                      var CustMobile = Customer.Mobile;
                                                                      var CustPic = Customer.ProfilePic;
                                                                      var UserIndex = "<%=UserIndex%>";
                                                                      var UserName = "<%=NewUserName%>";
                                                                      
                                                                      if(document.getElementById("EmptyStatus"))
                                                                          document.getElementById("EmptyStatus").style.display = "none";
                                                                      
                                                                      var Div = document.createElement('div');
                                                                      var Clients = document.getElementById("ProviderClientsDiv");
                                                                      
                                                                      Div.innerHTML = '<div style="padding: 5px; background-color: #6699ff; margin-bottom: 5px;">' +
                                                                                      '<center><div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; float: left; overflow: hidden;">'+
                                                                                      '<img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,'+CustPic+'"/>'+
                                                                                      '</div></center>' +
                                                                                            '<div style="float: right; width: 83%;">' +
                                                                                                    '<p style="font-weight: bolder;">'+CustName+'</p>' +
                                                                                                    '<p>'+CustMobile+'</p>' +
                                                                                                    '<p>'+CustEmail+'</p>' +
                                                                                                '</div>' +
                                                                                       ' <p style="clear: both;"></p>' +
                                                                                       '<form name="DeleteThisClient" action="DeleteClient" method="POST">' +
                                                                                            '<input id="PIDDltClnt" type="hidden" name="ProviderID" value="'+ProviderID+'" />' +
                                                                                            '<input id="ClientIDDltClnt" type="hidden" name="EachClientID" value="'+CustomerID+'"/>' +
                                                                                            '<input name="UserIndex" type="hidden" value="'+UserIndex+'" />' +
                                                                                            '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                                            '<input id="DeleteClientBtn" style="background-color: crimson; border: none; padding: 5px; border-radius: 4px;" type="submit" value="Delete this client" />'+
                                                                                        '</form>';
                                    
                                                                      
                                                                      Clients.appendChild(Div); 
                                                                      alert("Customer added to your list");
                                                                  }
                                                              });
                                                          }
                                                          else{
                                                           alert(result);
                                                        }                
                                                    }
                                                });
                                                
                                              });
                                            });
                                            
                                        </script>
                                    </center>
                                    
                                <center>
                                    <form id="changeBookedAppointmetForm<%=WString%>" style=" display: none;" id="changeBookedAppointmetForm<%=WString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                        <p style ="margin-top: 10px;">Reschedule This Customer</p>
                                        <input id="datepicker<%=WString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=date%>"/>
                                        <input id="timeFld<%=WString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=Time%>"/>
                                        <input id="timePicker<%=WString%>" style="background-color: white;" type="text" name="ApointmentTimePicker" value="<%=Time%>"/>
                                        <p id="timePickerStatus<%=WString%>" style="margin-bottom: 3px; font-weight: bolder; color: darkblue; text-align: center;"></p>
                                        <p id="datePickerStatus<%=WString%>" style="font-weight: bolder; color: darkblue; text-align: center;"></p>
                                        <input id="ChangeAppointmentID<%=WString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                        <input id="changeAppointmentBtn<%=WString%>" style="background-color: darkslateblue; color: white; border-radius: 4px; padding: 5px; border: none;" name="<%=WString%>changeAppointment" type="button" value="Reschedule" />
                                        <script>
                                               
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtn<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("ChangeAppointmentID<%=WString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFld<%=WString%>").value;
                                                        var AppointmentDate = document.getElementById("datepicker<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "ProvidersUpdateAppointment",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){
                                                            if(result === ""){
                                                                alert("Not Successful. You provided unacceptable date and time values");
                                                            }else{
                                                                alert(result);
                                                            }
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("changeBookedAppointmetForm<%=WString%>").style.display = "none";
                                                          
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetUpdateSpotInfo",
                                                              data: "AppointmentID="+AppointmentID,
                                                              success: function(result){
                                                                  //alert(result);
                                                                  var AppointmentData = JSON.parse(result);
                                                                  document.getElementById("ApptTimeSpan<%=WString%>").innerHTML = AppointmentData.AppointmentTime;
                                                                  //document.getElementById("ApptDateSpan").innerHTML = AppointmentData.AppointmentDate;
                                                              }
                                                          });
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        <script>
                                               
                                                    $('#timePicker<%=WString%>').timepicker({
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
                                                         
                                                         var tempTime = document.getElementById("timePicker<%=WString%>").value;
                                                         var tempDate = document.getElementById("datepicker<%=WString%>").value;

                                                         if(tempTime.length === 7)
                                                              tempTime = "0" + tempTime;

                                                          var tempHour = "";
                                                          var tempMinute = tempTime.substring(2,5);
                                                         
                                                         if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) !== '12'){
                                                             document.getElementById("timeFld<%=WString%>").value = tempTime.substring(0,5);
                                                         }
                                                         else if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) === '12'){
                                                             document.getElementById("timeFld<%=WString%>").value = "00" + tempMinute;
                                                         }
                                                         else{


                                                             tempHour = parseInt(tempTime.substring(0,2),10) + 12;
                                                             if(tempHour === 24)
                                                                 tempHour = 12;
                                                             
                                                             document.getElementById("timeFld<%=WString%>").value = tempHour + tempMinute;
                                                             
                                                         }
                                                         
                                                        if( currentDate === tempDate ){
                                                             
                                                            if( (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(0,2), 10)) < (parseInt(currentHour, 10)) ){
                                                                document.getElementById("timeFld<%=WString%>").value = currentTime;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("timePickerStatus<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFld<%=WString%>").value = currentTime;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatus<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }else{

                                                                document.getElementById("timePickerStatus<%=WString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkslateblue";
                                                            document.getElementById("timePickerStatus<%=WString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Time has been set to " + document.getElementById("timePicker<%=WString%>").value;
                        
                                                            }
                                                        
                                                        }else{
                                                            
                                                            document.getElementById("timePickerStatus<%=WString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkslateblue";
                                                            
                                                        }

                                                     }

                                                     setInterval(CheckCurrentTimeChooser,1);
                                                     
                                                 </script>
                                        
                                        <script>
                                                
                                                            $(function(){
                                                                $( "#datepicker<%=WString%>" ).datepicker();
                                                            });
                                                          
                                                         document.getElementById("datePickerStatus<%=WString%>").innerHTML = "";


                                                         function checkDateUpdateValue(){

                                                                 if((new Date(document.getElementById("datepicker<%=WString%>").value)) < (new Date())){

                                                                    if(document.getElementById("datepicker<%=WString%>").value === currentDate){

                                                                        if(document.getElementById("datePickerStatus<%=WString%>").innerHTML === ""){
                                                                            document.getElementById("datePickerStatus<%=WString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Today's Date: " + currentDate;
                                                                        }

                                                                    }
                                                                    else{
                                                                        document.getElementById("datePickerStatus<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Only today's date or future date allowed";
                                                                        document.getElementById("datepicker<%=WString%>").value = currentDate;
                                                                    }
                                                                 }
                                                                 else{

                                                                    document.getElementById("datePickerStatus<%=WString%>").innerHTML = "";
                                                                 }

                                                         }

                                                         setInterval(checkDateUpdateValue, 1);                                        
                                                             
                                            </script>
                                        
                                    </form>
                                </center>
                                    
                                    <form id="addFavProvForm<%=WString%>">
                                    </form>
                                
                                <center><form style=" display: none;" id="deleteAppointmentForm<%=WString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment">
                                    <p style="color: red; margin-top: 10px;">Are you sure you want to remove this customer</p>
                                    <p><input style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" id="DeleteApptBtn<%=WString%>" name="<%=WString%>deleteAppointment" type="button" value="Yes" />
                                    <span onclick = "hideDelete(<%=WString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 3px; cursor: pointer;"> NO</span></p>
                                    <input id="DeleteApptID<%=WString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                    
                                    <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#DeleteApptBtn<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("DeleteApptID<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "providerDeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("Spot Deleted Successfully");
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("ApptRow<%=WString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                            </script>
                                    
                                    </form></center>
                                
                                <p style="text-align: right; padding-right: 20px;">
                                    <a style="margin-right: 5px; cursor: pointer;" ><img onclick = "toggleChangeAppointment(<%=WString%>)" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></a> 
                                    <a><img style="cursor: pointer;" onclick = "toggleHideDelete(<%=WString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></a></p>
                            </td>
                        </tr>
                        
                        <script>
                            //if(document.getElementById("ApptTD0"))
                                //document.getElementById("ApptTD0").style.backgroundColor = "#ffc700";
                        </script>
                        
                        <%} //end of for loop
                            
                            if(AppointmentList.size() == 0){
                        
                        %>
                        
                        <center><p style="color: white; margin-bottom: 30px; margin-top: 30px; max-width: 600px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> No Current Line</p></center>
                        <%} //end of if block%>
                    </tbody>
                    </table>
                
                <center><h4 style="margin: 10px; max-width: 500px;">Future Line</h4></center>
                <center><table id="ProviderAppointmentList" style="border-spacing: 5px; border: 0; width: 100%; margin-bottom: 10px;">
                        <tbody>
                            
    <%
                      for(int w = 0; w < FutureAppointmentList.size(); w++){
                      
                          String WString = Integer.toString(w);
                          int AppointmentID = FutureAppointmentList.get(w).getAppointmentID();
                          int CustomerID = FutureAppointmentList.get(w).getProviderID();
                          
                          //note all providerinfo here is customer instead but this is an error from DataStructure inconsistency
                          String Name = FutureAppointmentList.get(w).getProviderName();
                          String Tel = FutureAppointmentList.get(w).getProviderTel();
                          String email = FutureAppointmentList.get(w).getProviderEmail();
                          String Time = FutureAppointmentList.get(w).getTimeOfAppointment();
                          String AppointmentReason = FutureAppointmentList.get(w).getReason();
                          String Base64CustPic = "";
                          
                        try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = FutureAppointmentList.get(w).getDisplayPic(); //Returns Blob data. Blob is the Datatype used by SQLDBs to store ByteArray data
                            InputStream inputStream = profilepic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                             Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}
                          
                          
                            String TimeToUse = "";
                            int Hours = Integer.parseInt(Time.substring(0,2));
                            String Minutes = Time.substring(2,5);

                            if( Hours > 12)
                            {
                                int TempHour = Hours - 12;
                                TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                            }
                            else if(Hours == 0){
                                TimeToUse = "12" + Minutes + "am";
                            }
                            else if(Hours == 12){
                                TimeToUse = Time + "pm";
                            }
                            else{
                                TimeToUse = Time +"am";
                            }
                
                          
                          Date date = FutureAppointmentList.get(w).getDateOfAppointment();
                          
                          SimpleDateFormat sdf = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");
                          String DateOfAppointment = sdf.format(date);
                          
    %>
                        <tr id="futureApptRow<%=WString%>">
                            <td style = "padding: 10px; background-color: white; margin: 5px; border: 0; border-radius: 4px;
                                box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                        <%
                            if(Base64CustPic != ""){
                        %>
                        <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                         <!--img class="fittedImg" style="border-radius: 100%; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<=Base64CustPic%>" width="40" height="40"/-->
                                <div style="border-radius: 100%; margin-left: 5px; min-width: 40px; height: 40px; float: left; overflow: hidden;">
                                    <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
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
                                        
                        <p style='text-align: center; margin-top: 10px;'>
                            <i class="fa fa-calendar" aria-hidden="true"> </i>
                            <span id="FutureDateSpan<%=WString%>" style="color: red;"><%=DateOfAppointment%> </span>
                            <i class="fa fa-clock-o" aria-hidden="true"> </i>
                            <span id="FutureTimeSpan<%=WString%>" style="color: red;"><%=TimeToUse%></span>
                        </p>
                            <p style='text-align: center; margin-top: 10px;'>
                                <img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                <span style="color: red;"><%=Name%></span> 
                            </p>
                            <p style='text-align: center;'>
                                <img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/> <%=email%>
                            </p>
                            <p style='text-align: center;'>
                                <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/> <%=Tel%>
                            </p>
                                    <p style="text-align: center; color: darkgrey; margin: 10px;">- <%=AppointmentReason%> -</p>
                                    
                                    <center>
                                        <input id="PIDFAddClient<%=WString%>" type="hidden" value="<%=UserID%>" />
                                        <input id="FCustIDAddClient<%=WString%>" type="hidden" name="CustomerID" value="<%=CustomerID%>" />
                                        <input type="button" id="AddClientsFromFutBtn<%=WString%>" style="cursor: pointer; background-color: darkslateblue; text-align: center; border: none; color: white; border-radius: 4px; margin-top: 5px; padding: 10px 5px;"
                                           value="Add person to clients" />
                                        <script>
                                                
                                            $(document).ready(function(){
                                                $("#AddClientsFromFutBtn<%=WString%>").click(function(event){
                                                    document.getElementById('ProviderPageLoader').style.display = 'block';
                                                    var CustomerID = document.getElementById("FCustIDAddClient<%=WString%>").value;
                                                    var ProviderID = document.getElementById("PIDFAddClient<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "AddClientsListController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID, 
                                                        
                                                        success: function(result){  
                                                          //alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          if(result === "notInList"){
                                                              
                                                              $.ajax({
                                                                  type: "POST",
                                                                  url: "getLastAddedClientAjax",
                                                                  data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                  success: function(result){
                                                                      //alert(result);
                                                                      var Customer = JSON.parse(result);
                                                                      var CustName = Customer.Name;
                                                                      var CustEmail = Customer.Email;
                                                                      var CustMobile = Customer.Mobile;
                                                                      var CustPic = Customer.ProfilePic;
                                                                      var UserIndex = "<%=UserIndex%>";
                                                                      var UserName = "<%=NewUserName%>";
                                                                      
                                                                      if(document.getElementById("EmptyStatus"))
                                                                          document.getElementById("EmptyStatus").style.display = "none";
                                                                      
                                                                      var Div = document.createElement('div');
                                                                      var Clients = document.getElementById("ProviderClientsDiv");
                                                                      
                                                                      Div.innerHTML = '<div style="padding: 5px; background-color: #6699ff; margin-bottom: 5px;">' +
                                                                                      '<center><div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; float: left; overflow: hidden;">'+
                                                                                      '<img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,'+CustPic+'"/>'+
                                                                                      '</div></center>' +
                                                                                            '<div style="float: right; width: 83%;">' +
                                                                                                    '<p style="font-weight: bolder;">'+CustName+'</p>' +
                                                                                                    '<p>'+CustMobile+'</p>' +
                                                                                                    '<p>'+CustEmail+'</p>' +
                                                                                                '</div>' +
                                                                                       ' <p style="clear: both;"></p>' +
                                                                                       '<form name="DeleteThisClient" action="DeleteClient" method="POST">' +
                                                                                            '<input id="PIDDltClnt" type="hidden" name="ProviderID" value="'+ProviderID+'" />' +
                                                                                            '<input id="ClientIDDltClnt" type="hidden" name="EachClientID" value="'+CustomerID+'"/>' +
                                                                                            '<input name="UserIndex" type="hidden" value="'+UserIndex+'" />' +
                                                                                            '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                                            '<input id="DeleteClientBtn" style="background-color: crimson; border: none; padding: 5px; border-radius: 4px" type="submit" value="Delete this client" />'+
                                                                                        '</form>';
                                    
                                                                      
                                                                      Clients.appendChild(Div); 
                                                                      alert("Customer added to your list");
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
                                    </center>
                                    
                                <center>
                                    <form style=" display: none;" id="changeFutureAppointmetForm<%=WString%>" class="changeBookedAppointmentForm" name="changeAppointment">
                                        <p style ="margin-top: 10px;">Reschedule This Customer</p>
                                        <input id="datepickerFuture<%=WString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=date%>"/>
                                        <input id="timeFldFuture<%=WString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=Time%>"/>
                                        <input id="timePickerFuture<%=WString%>" style="background-color: white;" type="text" name="ApointmentTimePicker" value="<%=Time%>"/>
                                        <p id="timePickerStatusFuture<%=WString%>" style="font-weight: bolder; margin-bottom: 3px; color: darkblue; text-align: center;"></p>
                                        <p id="datePickerStatusFuture<%=WString%>" style="font-weight: bolder; color: darkblue; text-align: center;"></p>
                                        <input id="ChangeFutureAppointmentID<%=WString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                        <input id="changeAppointmentBtnFuture<%=WString%>" style="background-color: darkslateblue; border: none; border-radius: 4px; color: white; padding: 5px;" name="<%=WString%>changeAppointment" type="button" value="Reschedule" />
                                        <script>
                                               
                                               $(document).ready(function() {                        
                                                    $('#changeAppointmentBtnFuture<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("ChangeFutureAppointmentID<%=WString%>").value;
                                                        var AppointmentTime = document.getElementById("timeFldFuture<%=WString%>").value;
                                                        var AppointmentDate = document.getElementById("datepickerFuture<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "ProvidersUpdateAppointment",  
                                                        data: "AppointmentID="+AppointmentID+"&ApointmentTime="+AppointmentTime+"&AppointmentDate="+AppointmentDate,  
                                                        success: function(result){
                                                            if(result === ""){
                                                                alert("Not Successful. You provided unacceptable date and time values");
                                                            }else{
                                                                alert(result);
                                                            }
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("changeFutureAppointmetForm<%=WString%>").style.display = "none";
                                                          
                                                          //JQuery Ajax takes an object as a parameter.
                                                          $.ajax({
                                                              //Object's data fields (State)
                                                              type: "POST",
                                                              url: "GetUpdateSpotInfo",
                                                              data: "AppointmentID="+AppointmentID,
                                                              
                                                              //Object's methods (Behavior)
                                                              success: function(result){
                                                                  //alert(result); //result contains data or information returned by/from controller/logic
                                                                  var AppointmentData = JSON.parse(result);
                                                                  document.getElementById("FutureTimeSpan<%=WString%>").innerHTML = AppointmentData.AppointmentTime;
                                                                  document.getElementById("FutureDateSpan<%=WString%>").innerHTML = AppointmentData.AppointmentDate;
                                                              }
                                                          });
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        <script>
                                               
                                               $('#timePickerFuture<%=WString%>').timepicker({
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
                                                    
                                                    var tempTime = document.getElementById("timePickerFuture<%=WString%>").value;
                                                    var tempDate = document.getElementById("datepickerFuture<%=WString%>").value;
                                                    
                                                    
                                                    if(tempTime.length === 7)
                                                         tempTime = "0" + tempTime;
                                                     
                                                     var tempHour = "";
                                                     var tempMinute = tempTime.substring(2,5);
                                                    
                                                    if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) !== '12'){
                                                        document.getElementById("timeFldFuture<%=WString%>").value = tempTime.substring(0,5);
                                                    }
                                                    else if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) === '12'){
                                                        document.getElementById("timeFldFuture<%=WString%>").value = "00" + tempMinute;
                                                    }
                                                    else{
                                                        
                                                        
                                                        tempHour = parseInt(tempTime.substring(0,2),10) + 12;
                                                        if(tempHour === 24)
                                                            tempHour = 12;
                                                        
                                                        
                                                        document.getElementById("timeFldFuture<%=WString%>").value = tempHour + tempMinute;
                                                       
                                                    }
                                                    
                                                    if( currentDate === tempDate ){
                                                        
                                                            if( (parseInt(document.getElementById("timeFldFuture<%=WString%>").value.substring(0,2), 10)) < (parseInt(currentHour, 10)) ){
                                                                document.getElementById("timeFldFuture<%=WString%>").value = currentTime;
                                                                document.getElementById("changeAppointmentBtnFuture<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtnFuture<%=WString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("timePickerStatusFuture<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFldFuture<%=WString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFldFuture<%=WString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFldFuture<%=WString%>").value = currentTime;
                                                                        document.getElementById("changeAppointmentBtnFuture<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtnFuture<%=WString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatusFuture<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Time cannot be in the past";
                                                            }else{
                                                                document.getElementById("timePickerStatusFuture<%=WString%>").innerHTML = "";
                                                                document.getElementById("changeAppointmentBtnFuture<%=WString%>").disabled = false;
                                                                document.getElementById("changeAppointmentBtnFuture<%=WString%>").style.backgroundColor = "darkslateblue";
                                                                document.getElementById("timePickerStatusFuture<%=WString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Time has been set to " + document.getElementById("timePickerFuture<%=WString%>").value;
                        
                                                            }
                                                    }   
                                                    else{
                                                            
                                                            document.getElementById("timePickerStatusFuture<%=WString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtnFuture<%=WString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtnFuture<%=WString%>").style.backgroundColor = "darkslateblue";
                                                            
                                                        }
                                                    
                                                    
                                                }
                                                
                                                setInterval(CheckTimeChooser,1);
                                               
                                            </script>
                                        
                                        <script>
                                                
                                                            $(function(){
                                                                $( "#datepickerFuture<%=WString%>" ).datepicker();
                                                            });
                                                         
                                                         document.getElementById("datePickerStatusFuture<%=WString%>").innerHTML = "";


                                                         function checkDateUpdateValueFuture(){

                                                                 if((new Date(document.getElementById("datepickerFuture<%=WString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepickerFuture<%=WString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatusFuture<%=WString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatusFuture<%=WString%>").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Today's Date: " + currentDate;
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         document.getElementById("datePickerStatusFuture<%=WString%>").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Only today's date or future date allowed";
                                                                                         document.getElementById("datepickerFuture<%=WString%>").value = currentDate;
                                                                                 }
                                                                 }
                                                                 else{

                                                                         document.getElementById("datePickerStatusFuture<%=WString%>").innerHTML = "";
                                                                         
                                                                 }

                                                         }

                                                         setInterval(checkDateUpdateValueFuture, 1);                                        
                                                             
                                            </script>
                                        
                                    </form>
                                </center>
                                    
                                    <form id="addFutureFavProvForm<%=WString%>"></form>
                                
                                <center><form style=" display: none;" id="deleteFutureAppointmentForm<%=WString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment" >
                                    <p style="color: red; margin-top: 10px;">Are you sure you want to remove this customer</p>
                                    <p><input style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" id="DeleteFutureApptBtn<%=WString%>" name="<%=WString%>deleteAppointment" type="button" value="Yes" />
                                    <span onclick = "hideFutureDelete(<%=WString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 3px; cursor: pointer;"> NO</span></p>
                                    <input id="DeleteFutureApptID<%=WString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                    
                                    <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#DeleteFutureApptBtn<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("DeleteFutureApptID<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "providerDeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("Spot Deleted Successfully");
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("futureApptRow<%=WString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                    </script>
                                    
                                </form></center>
                                
                                <p style="text-align: right; padding-right: 20px;">
                                    <a style="margin-right: 5px; cursor: pointer;" ><img onclick = "toggleChangeFutureAppointment(<%=WString%>)" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></a> 
                                    <a><img style="cursor: pointer;" onclick = "toggleFutureHideDelete(<%=WString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></a></p>
                            </td>
                        </tr>
                        
                        <%} //end of for loop
                            
                            if(FutureAppointmentList.size() == 0){
                        
                        %>
                        
                        <center><p style="color: white; margin-bottom: 30px; margin-top: 30px; max-width: 600px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> No Future Line Spots</p></center>
                        <%} //end of if block%>
                    </tbody>
                    </table></center>
                
                    
                    </div>
                
                <div id="ProviderAppointmentHistoryDiv" style= "display: none;">
                <center><h4 style="margin: 5px;">Your History</h4></center>
                
                <center><table id="ProviderAppointmentHistory" style="border-spacing: 5px; border: 0; margin-bottom: 10px; width: 100%;">
                        <tbody>
                            
    <%
                      for(int w = 0; w < AppointmentHistory.size(); w++){
                      
                          String WString = Integer.toString(w);
                          int AppointmentID = AppointmentHistory.get(w).getAppointmentID();
                          int CustomerID = AppointmentHistory.get(w).getProviderID();
                          //note all providerinfo here is customer instead but this is an error from DataStructure inconsistency
                          String Name = AppointmentHistory.get(w).getProviderName();
                          String Tel = AppointmentHistory.get(w).getProviderTel();
                          String email = AppointmentHistory.get(w).getProviderEmail();
                          String Time = AppointmentHistory.get(w).getTimeOfAppointment();
                          String AppointmentReason = AppointmentHistory.get(w).getReason();
                          String Base64CustPic = "";
                          
                            
                        try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = AppointmentHistory.get(w).getDisplayPic(); 
                            InputStream inputStream = profilepic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                             Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}


                            String TimeToUse = "";
                            int Hours = Integer.parseInt(Time.substring(0,2));
                            String Minutes = Time.substring(2,5);

                            if( Hours > 12)
                            {
                                int TempHour = Hours - 12;
                                TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                            }
                            else if(Hours == 0){
                                TimeToUse = "12" + Minutes + "am";
                            }
                            else if(Hours == 12){
                                TimeToUse = Time + "pm";
                            }
                            else{
                                TimeToUse = Time +"am";
                            }
                
                          
                          Date date = AppointmentHistory.get(w).getDateOfAppointment();
                          
                          SimpleDateFormat sdf = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");
                          String DateOfAppointment = sdf.format(date);
                          
    %>
                        <tr id="HistoryApptRow<%=WString%>">
                            <td style = "padding: 10px; background-color: white; margin: 5px; border: 0; border-radius: 4px;
                                box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                        <%
                            if(Base64CustPic != ""){
                        %>
                                <div style="display: flex; justify-content: center;">        
                                    <div style="width: 50px; margin-right: 20px;">
                                        <div style="border-radius: 100%; margin-left: 5px; width: 40px; height: 40px; overflow: hidden;">
                                           <img style="width: 40px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
                                        </div>
                                    </div>
                        <%
                            }
                        %>
                                    <div>        
                                        <p style="margin: 10px; text-align: center;">
                                            <span style="color: #334d81; font-weight: bolder;"><%=Name%></span></p>
                                        <p style="margin-bottom: 5px; text-align: center"><%=email%>, <%=Tel%></p>
                                        <p style="text-align: center;"><span style="color: red;"><%=DateOfAppointment%></span>, <span style="color: red;"><%=TimeToUse%></span></p>
                                        <p style="text-align: center; color: darkgrey; margin: 15px 0;">- <%=AppointmentReason%> -</p>
                                    </div>
                                </div>
                                
                                <form name="BlockThisCustomer" >
                                    <input id="CustIDforBlockCustomer<%=w%>" type="hidden" name="CustomerID" value="<%=CustomerID%>" />
                                    <input id="PIDforBlockCustomer<%=w%>" type="hidden" name="ProviderID" value="<%=UserID%>" />
                                    <center><input id="BlockCustBtn<%=w%>" style="background-color: crimson; color: white; border-radius: 4px; border: none; padding: 5px;" type="button" value="Block this person" /></center>
                                    
                                    <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#BlockCustBtn<%=w%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var CustomerID = document.getElementById("CustIDforBlockCustomer<%=w%>").value;
                                                        var ProviderID = document.getElementById("PIDforBlockCustomer<%=w%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "BlockCustController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          if(result === "notInList"){
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetBlockedClientAjax",
                                                              data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                              success: function(result){
                                                                  //alert(result);
                                                                  
                                                                  var blockedPer = JSON.parse(result);
                                                                  var BlockedID = blockedPer.ID;
                                                                  var Name = blockedPer.Name;
                                                                  var Email = blockedPer.Email;
                                                                  var Mobile = blockedPer.Tel;
                                                                  var ProfilePic = blockedPer.Propic;
                                                                  var UserIndex = "<%=UserIndex%>";
                                                                  var UserName = "<%=NewUserName%>";
                                                                  
                                                                  if(document.getElementById("NoBlockedClientStatus"))
                                                                      document.getElementById("NoBlockedClientStatus").style.display = "none";
                                                                  
                                                                  var BlockedPeopleDiv = document.getElementById("BlockedPeopleDiv");
                                                                  var div = document.createElement('div');
                                                                  
                                                                  div.innerHTML = '<div style="background-color: #6699ff; padding: 5px;  margin-bottom: 5px;">' +
                                                                                    '<center><div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; float: left; overflow: hidden;">'+
                                                                                      '<img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,'+ProfilePic+'"/>'+
                                                                                      '</div></center>' +
                                                                                    '<div style="float: right; width: 83%;">' +
                                                                                        '<p style="text-align: left; font-weight: bolder;">'+Name+'</p>' +
                                                                                        '<p style="text-align: left;">'+Mobile+'</p>' +
                                                                                        '<p style="text-align: left;">'+Email+'</p>' +
                                                                                    '</div>' +
                                                                                    '<p style="clear: both;"></p>' +
                                                                                  
                                                                                  '<form name="UnblockPerson" action="UnblockCust" method="POST">' +
                                                                                     '<input id="BlockedID" type="hidden" name="BlockedID" value="'+BlockedID+'" />' +
                                                                                     '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                                     '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                                     '<input id="UnblockCleintBtn" style="background-color: crimson; border: none; color: white; border-radius: 4px; padding: 5px;" type="submit" value="Unblock This Person" name="Unblock" />' +
                                                                                     '</form>' +
                                                                                     '</div>' ;
                                                                          
                                                                  BlockedPeopleDiv.appendChild(div);
                                                                  alert("This customer has been blocked");
                                                                }
                                                            });
                                                          }else{
                                                                alert("This customer is already blocked");
                                                          }
                                                       }
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                    
                                </form>
                                
                                    <center>
                                    <form id="ratingAndReviewForm<%=WString%>" class="changeBookedAppointmentForm" name="changeAppointment" action="ProvidersUpdateAppointment" method="POST">
                                    </form>
                                </center>
                                    
                                    <form style=" display: none;" id="addFavProvFormFromRecent<%=WString%>">
                                    </form>
                                    
                                    <center><form id="AddClientForm<%=WString%>" style="display: none" name="AddClient">
                                        <input id="PIDAddClient<%=WString%>" type="hidden" name="ProviderID" value="<%=UserID%>" />
                                        <input id="CustIDAddClient<%=WString%>" type="hidden" name="CustomerID" value="<%=CustomerID%>" />
                                        <input id="addClientBtn<%=WString%>" style="padding: 10px 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="button" value="Add person to clients" name="addfavclient" />
                                    
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#addClientBtn<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var CustomerID = document.getElementById("CustIDAddClient<%=WString%>").value;
                                                        var ProviderID = document.getElementById("PIDAddClient<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "AddClientsListController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("AddClientForm<%=WString%>").style.display = "none";
                                                          
                                                          if(result === "notInList"){
                                                              
                                                              $.ajax({
                                                                  type: "POST",
                                                                  url: "getLastAddedClientAjax",
                                                                  data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID,
                                                                  success: function(result){
                                                                      
                                                                      var Customer = JSON.parse(result);
                                                                      var CustName = Customer.Name;
                                                                      var CustEmail = Customer.Email;
                                                                      var CustMobile = Customer.Mobile;
                                                                      var CustPic = Customer.ProfilePic;
                                                                      var UserIndex = "<%=UserIndex%>";
                                                                      var UserName = "<%=NewUserName%>";
                                                                      
                                                                      if(document.getElementById("EmptyStatus"))
                                                                          document.getElementById("EmptyStatus").style.display = "none";
                                                                      var Div = document.createElement('div');
                                                                      var Clients = document.getElementById("ProviderClientsDiv");
                                                                      
                                                                      Div.innerHTML = '<div style="padding: 5px; background-color: #6699ff; margin-bottom: 5px;">' +
                                                                                      '<center><div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; float: left; overflow: hidden;">'+
                                                                                      '<img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,'+CustPic+'"/>'+
                                                                                      '</div></center>' +
                                                                                            '<div style="float: right; width: 83%;">' +
                                                                                                    '<p style="font-weight: bolder;">'+CustName+'</p>' +
                                                                                                    '<p>'+CustMobile+'</p>' +
                                                                                                    '<p>'+CustEmail+'</p>' +
                                                                                                '</div>' +
                                                                                       ' <p style="clear: both;"></p>' +
                                                                                       '<form name="DeleteThisClient" action="DeleteClient" method="POST">' +
                                                                                            '<input id="PIDDltClnt" type="hidden" name="ProviderID" value="'+ProviderID+'" />' +
                                                                                            '<input id="ClientIDDltClnt" type="hidden" name="EachClientID" value="'+CustomerID+'"/>' +
                                                                                            '<input name="UserIndex" type="hidden" value="'+UserIndex+'" />' +
                                                                                            '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                                            '<input id="DeleteClientBtn" style="background-color: crimson; color: white; border-radius: 4px; border: none; padding: 5px;" type="submit" value="Delete this client" />'+
                                                                                        '</form>';
                                    
                                                                      
                                                                      Clients.appendChild(Div); 
                                                                      alert("Customer added to your list");
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
                                        
                                    </form></center>
                                        
                                <center><form  style=" display: none;" id="deleteAppointmentHistoryForm<%=WString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment" >
                                    <p style="color: red; margin-top: 10px;">Are you sure you want to delete this history</p>
                                    <p><input style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" id="DeleteHistoryApptBtn<%=WString%>" name="<%=WString%>deleteAppointment" type="button" value="Yes" />
                                    <span onclick = "hideDeleteHistory(<%=WString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 3px; cursor: pointer;"> NO</span></p>
                                    <input id="DeleteHistoryApptID<%=WString%>" type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                    
                                    <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#DeleteHistoryApptBtn<%=WString%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var AppointmentID = document.getElementById("DeleteHistoryApptID<%=WString%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "providerDeleteAppointment",  
                                                        data: "AppointmentID="+AppointmentID,  
                                                        success: function(result){  
                                                          alert("This history has been deleted successfully");
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("HistoryApptRow<%=WString%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                    
                                                });
                                    </script>
                                    
                                    </form></center>
                                
                                <p style="text-align: right; padding-right: 20px; margin-top: 10px;"> 
                                    <a><img style="margin-right: 7px; cursor: pointer;" onclick="togglehideAddClientForm(<%=WString%>)" src="icons/icons8-user-account-20.png" width="24" height="22" alt="icons8-user-account-20"/>
                                    </a>
                                    <a><img style="cursor: pointer;" onclick = "toggleHideDeleteHistory(<%=WString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></a>
                                </p>
                            </td>
                        </tr>
                        
                        <%} //end of for loop
                            
                            if(AppointmentHistory.size() == 0){
                        
                        %>
                        
                        <center><p style="color: white; margin-bottom: 30px; margin-top: 30px; max-width: 600px;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> You have no history</p></center>
                        <%} //end of if block%>
                    </tbody>
                    </table></center>
                
                </div>
                    </div>
            </div>
                    
                <div id='ReservationAndFutureSpots' style='height: auto !important; background-color: #9bb1d0; border-radius: 4px; margin: 5px;
                     box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);'>  
                    <table style="width: 100%; background-color: #3d6999; border-top-left-radius: 4px; border-top-right-radius: 4px;">
                        <tbody>
                            <tr>
                                <td onclick="toggleShowMakeReservationForm();" style="cursor: pointer; width: 33.3%; color: white; padding: 10px 0;">
                                    <p style="text-align: center;"><i style="color: #ff6b6b; font-size: 18px;" class="fa fa-plus-square" aria-hidden="true"></i><br/>Reservations</p>
                                </td>
                                <td onclick="toggleShowBlockFutureSpotsForm();" style="cursor: pointer; width: 33.3%; color: white; padding: 10px 0;">
                                    <p style="text-align: center;"><i style="color: #ff6b6b; font-size: 18px;" class="fa fa-users" aria-hidden="true"></i><br/>More Spots</p>
                                </td>
                                <td onclick="toggleShowCloseFutureDysForm();" style="cursor: pointer; color: white; padding: 10px 0;">
                                    <p style="text-align: center;"><i style="color: #ff6b6b; font-size: 18px;" class="fa fa-calendar-times-o" aria-hidden="true"></i><br/>Closed Days</p>
                                </td>
                            </tr>
                        </tbody>
                        
                    </table>
                    
                        <div style="">
                            <form style="display: none; padding: 10px 0;" id="BlockFutureSpotsForm" name="BlockFutureSpots" action="BlockFutureSpots.jsp">
                                <p style="font-weight: bolder; text-align: center; color: slategrey; padding: 10px;">Choose date to block future spots</p>
                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                <input style="border: 1px solid slategrey; background-color: white; padding: 5px;" id="Fdatepicker" type="text" name="GetDate" value="" readonly/><br/>
                                <input id="GenerateSpotsBtn" style="padding: 10px 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="submit" value="Generate Spots" name="GenerateSpots" />
                            </form>
                        </div>
                    
                        <div id="CloseFutureDaysForm" style="display: none; margin: auto; text-align: center;">
                        <form style="width: 100%; max-width: 600px; margin: auto;" >
                            <p style="font-weight: bolder; text-align: center; color: slategrey; padding: 10px;">Choose date when to close</p>
                            <input style="border: 1px solid slategrey; background-color: white; padding: 5px;" id="Ddatepicker" type="text" name="GetDate" value="" readonly/><br/>
                            <input id="provIDforClosedDate" type="hidden" name="ProviderID" value="<%=UserID%>" />
                            <input id="CloseDayBtn" style="padding: 10px 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="button" value="Close this day" name="BlockDay" />
                            <script>
                                             
                                $(document).ready(function() {                        
                                    $('#CloseDayBtn').click(function(event) {  
                                        document.getElementById('ProviderPageLoader').style.display = 'block';                
                                        var ProviderID = document.getElementById("provIDforClosedDate").value;
                                        var CloseDate = document.getElementById("Ddatepicker").value;
                                        var UserIndex = "<%=UserIndex%>";
                                        var UserName = "<%=NewUserName%>";
                                                       
                                        $.ajax({  
                                        type: "POST",  
                                        url: "CloseDayController",  
                                        data: "ProviderID="+ProviderID+"&GetDate="+CloseDate,  
                                        success: function(result){
                                            document.getElementById('ProviderPageLoader').style.display = 'none';
                                            if(result === "notInList"){
                                                $.ajax({  
                                                type: "POST",  
                                                url: "AjaxGetClosedDays",  
                                                data: "ProviderID="+ProviderID,  
                                                success: function(result){  
                                                        
                                                        var NewClosedDates = JSON.parse(result);  
                                                        
                                                        var ClosedID = NewClosedDates.ClosedID;
                                                        var CDate = NewClosedDates.ClosedDate;
                                                        
                                                        if(document.getElementById("NoClosedDayStatus"))
                                                            document.getElementById("NoClosedDayStatus").style.display = "none";
                                                        var NewClosedDaysDiv = document.getElementById("NewClosedDays");
                                                        const div = document.createElement('div');

                                                        div.innerHTML = 
                                                            '<form id="eachClosedDate'+ClosedID+'" style="margin: 5px; padding: 10px; border-radius: 4px; background-color: white; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);" name="OpenClosedDay" action="OpenDate" method="POST">'+
                                                                '<p style="margin-bottom: 10px; color: #636363;">'+CDate+'</p>'+
                                                                '<input id="closedID'+ClosedID+'" type="hidden" name="ClosedID" value="'+ClosedID+'" />'+
                                                                '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />' +
                                                                '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                '<input onclick="document.getElementById(\'ProviderPageLoader\').style.display = \'block\';" id="openDayBtn'+ClosedID+'" style="padding: 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="submit" value="Open this day" />' +
                                                            '</form>';
                                                        

                                                        NewClosedDaysDiv.appendChild(div);
                                                        
                                                    }                
                                                });
                                                alert("Day Closed");
                                            }else{
                                                alert("Day Already Closed");
                                            }
                                          }                
                                        });
                                                      
                                        });
                                });
                            </script>
                        </form>
                            
                            <div id="NewClosedDays" style="margin: auto; max-width: 500px;  padding-top: 15px; margin-bottom: 15px; height: auto !important;">
                            <p style="font-weight: bolder; color: slategrey; padding: 10px;">Days Closed</p>
                            
                        <%
                            
                            for(int ij = 0; ij < ClosedDayID.size(); ij++){
                                
                            
                                String eachClosedDate = ClosedDate.get(ij);
                                int ClosedID = ClosedDayID.get(ij);
                                
                                SimpleDateFormat eachDateSdf = new SimpleDateFormat("yyyy-MM-dd");
                                String whatDay = "";
                                Date eachDate = null;
                                try{
                                    eachDate = eachDateSdf.parse(eachClosedDate);
                                    whatDay = eachDate.toString().substring(0,3);
                                }catch(Exception e){}
                                
                                eachDateSdf = new SimpleDateFormat("MMMMMMMMMMMMMMMMM dd, yyyy");
                                eachClosedDate = eachDateSdf.format(eachDate);
                            
                        %>
                        
                            <form id="eachClosedDate<%=ij%>" style="box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                                  border-radius: 4px; margin: 5px; padding: 10px; background-color: white;" name="OpenClosedDay">
                                <p style="margin-bottom: 10px; color: #636363;"><%=whatDay%>, <%=eachClosedDate%></p>
                                <input id="closedID<%=ij%>" type="hidden" name="ClosedID" value="<%=ClosedID%>" />
                                <input id="openDayBtn<%=ij%>" style="padding: 10px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="button" value="Open this day" />
                                <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#openDayBtn<%=ij%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var ClosedID = document.getElementById("closedID<%=ij%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "OpenClosedDateController",  
                                                        data: "ClosedID="+ClosedID,  
                                                        success: function(result){  
                                                          alert("Closed day has been opened");
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("eachClosedDate<%=ij%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                    
                                                });
                                            </script>
                            </form>
                            <div ></div>
                             
                        <%}
                            if(ClosedDayID.size() == 0){
                        %>
                                <p id="NoClosedDayStatus" style="color: white;"><i style="color: yellow;" class="fa fa-exclamation-triangle"></i> No specific days are closed</p>
                        <%}%>
                        
                        </div>
                    </div>
                        
                        <center><div id="MakeReservationForm" style="width: 100%; max-width: 500px; padding: 10px 0;">
                                
                                <script>document.getElementById("MakeReservationForm").style.display = "block";</script>
                                    
                                <form style="" name="makeReservationForm">
                                    
                                    <p style="text-align: center; color: slategrey; margin-top: 5px; padding: 10px; font-weight: bolder;">Add reservation details below</p>
                                    
                                    <table style="border-spacing: 0; max-width: 310px;">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <p style="font-weight: bolder; color: slategrey; padding: 5px; text-align: center;">Date</p>
                                                    <input style="border: slategrey 1px solid; background-color: white; padding: 5px; max-width: 100px !important;" id="Rdatepicker" type="text" name="formsDateValue" value="" readonly/>
                                                </td>
                                                <td>
                                                    <p style="font-weight: bolder; color: slategrey; padding: 5px; text-align: center;">Time</p>
                                                    <input style="border: 1px solid slategrey; background-color: white; padding: 5px; max-width: 100px !important;" id="RtimePicker" type="text" name="formsTimeValue" value="" readonly/>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                    <p style="font-weight: bolder; color: slategrey; padding: 5px; margin-top: 10px;">What is this reservation for?</p>
                                    
                                        <%
                                            if(Services.getNumberOfServices() > 0){
                                        %>
                                            <select style="border: slategrey 1px solid; padding: 10px; background-color: white; color: black;" id="reserveService" name="formsOrderedServices">
                                                <%

                                                        for(int svc = 0; svc < Services.getNumberOfServices(); svc++){

                                                            String ServiceName = Services.getService(svc).trim();
                                                            String ServicePrice = Services.getPrice(svc);
                                                            String ServiceDetails = "$" + ServicePrice + "-" + ServiceName; 
                                                %>
                                                            <option><%=ServiceDetails%></option>
                                                <%
                                                        }
                                                %>
                                            </select>
                                        <%
                                            }else{
                                        %>
                                            <p style='margin: 10px 0; color: white; text-align: center;'>
                                                <i class='fa fa-exclamation-triangle' style='color: yellow'></i>
                                                You have no services to choose from.
                                                <br/>
                                                <br/>
                                                To add a service go to services tab which you will find below your profile area to add services your business provide to customers 
                                            </p>
                                        <%
                                            }
                                        %>
                                        
                                        
                                    <p style="font-weight: bolder; color: slategrey; padding: 5px;">Who is this reservation for?</p>
                                    
                                    <div class="scrolldiv" style="max-height: 200px; width:310px; overflow-y: auto; margin-bottom: 10px; padding-top: 5px;">
                                        
                                        <ul style="list-style-type: none;">
                                            
                                            <%
                                                String CustomerFullName = "";
                                                for(int cl = 0; cl <  ClientsList.size(); cl++){
                                                
                                                    int ClientID = ClientsList.get(cl).getUserID();
                                                    String FirstName = ClientsList.get(cl).getFirstName();
                                                    String MiddleName = ClientsList.get(cl).getMiddleName().trim();
                                                    String LastName = ClientsList.get(cl).getLastName().trim();
                                                    CustomerFullName = FirstName + " " + MiddleName + " " + LastName;
                                                            String Base64CustPic = "";
                                        
                                                    try{    
                                                        //put this in a try catch block for incase getProfilePicture returns nothing
                                                        Blob profilepic = ClientsList.get(cl).getProfilePic(); 
                                                        InputStream inputStream = profilepic.getBinaryStream();
                                                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                                        byte[] buffer = new byte[4096];
                                                        int bytesRead = -1;

                                                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                            outputStream.write(buffer, 0, bytesRead);
                                                        }

                                                        byte[] imageBytes = outputStream.toByteArray();

                                                         Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                                                    }
                                                    catch(Exception e){}
        
                                            %>
                                            <li style="background-color: white; margin-bottom: 5px; max-width: 300px; padding: 5px; border-radius: 5px;">
                                                
                                                <input class="reserveCustID" id="eachClientID<%=cl%>" style="margin-top: 10px; float: left; background-color: white;" type="radio" name="CustomerID" value="<%=ClientID%>" />
                                                
                                                <label for="eachClientID<%=cl%>"><p style="padding-top: 8px;">
                                                <%
                                                    if(Base64CustPic == ""){
                                                %> 

                                                    <span>
                                                        <img style="border-radius: 5px; margin-top: -8px; float: right; border-radius: 100%;" src="icons/icons8-user-filled-50.png" height="30" width="30" alt="icons8-user-filled-50"/>
                                                    </span>

                                                <%
                                                    }else{
                                                %>
                                                    <span>
                                                        <div style="margin-top: -8px; float: right; border-radius: 100%; overflow: hidden; width: 30px; height: 30px;">
                                                            <img style="width: 30px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
                                                        </div>
                                                        <!--img class="fittedImg" style="" src="data:image/jpg;base64,<=Base64CustPic%>" height="30" width="30" /-->
                                                    </span>

                                                <%
                                                    }
                                                %>
                                                    <span><%=CustomerFullName%></span></p></label>
                                                
                                                <p style="clear: both;"></p>
                                                
                                            </li>
                                    <script>  
                                        
                                        var TotalClients = "<%=cl%>"; //JSP expression tags in javascript are pretty slow.
                                        
                                        function checkMkReservationBtn(){
                                            
                                            var Rdatepicker = document.getElementById("Rdatepicker");
                                            var RtimePicker = document.getElementById("RtimePicker");
                                            var MkReservationBtn = document.getElementById("MkReservationBtn");
                                            var EachChecked = 0;
                                            var eachClientID = null;
                                            
                                        
                                            for(var i = 0; i <= TotalClients; i++){
                                                
                                                eachClientID = document.getElementById(("eachClientID"+i));
                                                
                                                if(eachClientID.checked === true)
                                                    EachChecked = 1;
                                                
                                            }
                                            
                                        
                                        if(Rdatepicker.value === "" || RtimePicker.value === "" || EachChecked === 0){
                                            
                                            MkReservationBtn.style.backgroundColor = "darkgrey";
                                            MkReservationBtn.disabled = true;
                                            
                                        }else{
                                            
                                            MkReservationBtn.style.backgroundColor = "darkslateblue";
                                            MkReservationBtn.disabled = false;
                                         
                                        }
 
                                    }
                                    
                                    $(document).ready(()=> {
                                        setInterval(checkMkReservationBtn,1);
                                    });
                                    
                                    </script>
                                    
                                    <%}
                                        if(ClientsList.size() == 0){
                                    %>
                                    
                                    <p style="color: white;">
                                        <span><i style="color: yellow;" class="fa fa-exclamation-triangle"></i> You don't have any clients in your clients list.</span>
                                        <br/><br/>
                                        <span style="">You can only make reservations for people you've added to your cliets list.
                                            To add a client, go to your current line or your appointment history to add a customer from your bookings.</span>
                                    </p>
                                    <script>
                                        
                                        $(document).ready(()=> {
                                            document.getElementById("MkReservationBtn").style.backgroundColor = "darkgrey";
                                            document.getElementById("MkReservationBtn").disabled = true;
                                        });
                                        
                                    </script>
                                        
                                    <%}%>
                                    </ul>
                                    </div>
                                      
                                    <br/>
                                    <input id="reservePID" name="ProviderID" type="hidden" value="<%=UserID%>"/>
                                    <input id="MkReservationBtn" style="padding: 10px 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px;" type="button" value="Make Reservation" name="MakeReservationBtn" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"/>
                                </form>
                                    
                                    <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#MkReservationBtn').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var reserveDate = document.getElementById("Rdatepicker").value;
                                                        var reserveTime = document.getElementById("RtimePicker").value;
                                                        var ProviderID = document.getElementById("reservePID").value;
                                                        var Services =  document.getElementById("reserveService");
                                                        var Reason = Services.options[Services.selectedIndex].text;
                                                        var CustomerID = $("input[name=CustomerID]:checked").val();
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "MakeReservationController",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID+"&formsDateValue="+reserveDate+"&formsTimeValue="+reserveTime+"&formsOrderedServices="+Reason,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          //document.getElementById("MakeReservationForm").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                    
                        </div></center>
                    
                                    <script>
                                        document.getElementById("MkReservationBtn").style.backgroundColor = "darkgrey";
                                        document.getElementById("MkReservationBtn").disabled = true;
                                    </script>
                    <script>
                        $( 
                            function(){
                                $( "#Fdatepicker" ).datepicker({
                                    minDate: 0
                                });
                            } 
                        );
                            
    
                        $(    function(){
                                $( "#Ddatepicker" ).datepicker({
                                    minDate: 0
                                });
                            }
                        );
                
                        $(    function(){
                                $( "#Rdatepicker" ).datepicker({
                                    minDate: 0
                                });
                            }
                        );
                
                        $('#RtimePicker').timepicker({
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
                        
                                    function checkFdatePicker(){
                                        
                                        var Fdatepicker = document.getElementById("Fdatepicker");
                                        var GenerateSpotsBtn = document.getElementById("GenerateSpotsBtn");
                                        
                                        if(Fdatepicker.value === ""){
                                            GenerateSpotsBtn.style.backgroundColor = "darkgrey";
                                            GenerateSpotsBtn.disabled = true;
                                        }
                                        else{
                                            GenerateSpotsBtn.style.backgroundColor = "darkslateblue";
                                            GenerateSpotsBtn.disabled = false;
                                            
                                        }
                                            
                                        
                                    }
                                    
                                    setInterval(checkFdatePicker,1);
                                    
                                    
                             function checkDdatePicker(){
                                        
                                        var Ddatepicker = document.getElementById("Ddatepicker");
                                        var CloseDayBtn = document.getElementById("CloseDayBtn");
                                        
                                        if(Ddatepicker.value === ""){
                                            CloseDayBtn.style.backgroundColor = "darkgrey";
                                            CloseDayBtn.disabled = true;
                                        }
                                        else{
                                            CloseDayBtn.style.backgroundColor = "darkslateblue";
                                            CloseDayBtn.disabled = false;
                                            
                                        }
                                            
                                        
                                    }
                                    
                                    setInterval(checkDdatePicker,1);
                                    
                    </script>
                </div>  
            </div>
            </div>
                   
            <!--script>
                function hideAllDropDowns(){
                    hideExtraDropDown();
                    hideDropDown();
                }
            </script-->
         
        <div id="newbusiness" style="margin-top: 1px; min-height: 0; height: auto; position: initial; overflow-x: hidden; background: none !important;">
            <!--script>
                if($(window).width() > 1000){
                    document.getElementById("newbusiness").style.minHeight = "initial";
                    //document.getElementById("newbusiness").style.position = "";
                }
            </script-->
            <!------------------------------------------------------------------------------------------------------------------------------------------->
            
            <!------------------------------------------------------------------------------------------------------------------>
        
            
            <center><div id="Providerprofile" class="ProviderWidthEnforcement" style="width: 100%; max-width: 700px;">
                 <!--p id="ProviderYourBusinessTxt"-->
                    <p style="font-weight: bolder; color: #444; background: rgba(255, 255, 255, 0.7); position: relative; z-index: 1; margin-bottom: -35px; padding: 5px;">Your Business Profile</p>
                
                <table id="ProviderprofileTable" style="border-spacing: 0; width: 100%; max-width: 600px;">
                    
                    <tbody>
                        <tr>
                            <td><center>
                                
                                <a href="UploadProviderProfilePhoto.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';">
                                    
                                    <div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');  background-color: #eeeeee; border-radius: 4px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                                        
                                    <%if(base64Cover == ""){%>
                                        <p style="text-align: center; margin-top: -75px; margin-bottom: 60px; color: #636363;">
                                            <i style="font-size: 19px;" aria-hidden="true" class="fa fa-picture-o"></i>
                                            Click here to add Cover Photo
                                        </p>
                                    <%}%>
                                    
                                    <%
                                        if(base64Image == ""){
                                    %> 

                                        <div style="width: 150px; height: 150px; border-radius: 100%; display: flex; flex-direction: column; justify-content: center;
                                             box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); background-color: #eeeeee; text-align: center;">
                                            <i class="fa fa-user" aria-hidden="true" style="font-size: 130px; color: #ccc;"></i>
                                        </div>

                                    <%
                                        }else{
                                    %>
                                        <div class='MainPropicContainer' style='box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); width: 150px; height: 150px; overflow: hidden;'>
                                            <img style="width: 150px; height: auto; min-height: 150px;" src="data:image/jpg;base64,<%=base64Image%>" />
                                        </div>
                                    <%
                                        }
                                    %>
                                </div></a>
                                
                            </center>
                            
                                <div class="proinfo" style="padding-top:5px; margin-top:5px; padding-bottom: 5px; margin-bottom:5px;">
                            
                                    <p id="FullNameDetail" style="font-size: 17px; font-weight: bolder; color: #334d81; padding-top: 95px; text-align: center;"><%=FullName%></p>
                                    <p style='margin-bottom: 10px; text-align: center;'><span style='font-weight: bolder; color: #636363;' id="CompanyDetail"><%=Company%></span></p>
                                    
                                </div>
                                        
                                        <p onclick="toggleShowEditPerInfoDiv();" style="box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                                           text-align: center; margin: auto; color: white; background-color: darkslateblue; padding: 10px 5px; border-radius: 4px; cursor: pointer; border-radius: 4px; max-width: 300px; margin-bottom: 15px; margin-top: 15px;">
                                                <i style="color: #4ed164;;" class="fa fa-pencil-square" aria-hidden="true"></i>
                                                <span style="color: white;">Edit Your Personal Information</span>
                                            </p>
                                        
                                        <center><div id="EditPerInfoDiv" style="display: none; max-width: 400px; background-color: #9bb1d0; border-radius: 4px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                                                     width: fit-content; padding: 5px; border: #3d6999 1px solid; margin-bottom: 10px;">
                                                <form name="UpdatePsnalInfor">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td style="text-align: left;">First Name: </td>
                                                            <td><input style="border-radius: 4px; background-color: #d9e8e8;" id="ProvFNameFld" placeholder="First name here" type="text" name="FirstNameFld" value="<%=ThisProvider.getFirstName()%>" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left;">Middle Name: </td>
                                                            <td><input style="border-radius: 4px; background-color: #d9e8e8;" id="ProvMNameFld" placeholder="Middle name here" type="text" name="MiddleNameFld" value="<%=ThisProvider.getMiddleName()%>" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left;">Last Name: </td>
                                                            <td><input style="border-radius: 4px; background-color: #d9e8e8;" id="ProvLNameFld" placeholder="Last name here" type="text" name="LastNameFld" value="<%=ThisProvider.getLastName()%>" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left;">Mobile Number: </td>
                                                            <td><input style="border-radius: 4px; background-color: #d9e8e8;" onclick="checkMiddlePhoneNumberEdit();"  onkeydown="checkMiddlePhoneNumberEdit();"id="ProvPhnNumberFld" placeholder="Phone number here" type="text" name="MobileNumberFld" value="<%=PhoneNumber%>"/></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: left;">Email: </td>
                                                            <td><input style="border-radius: 4px; background-color: #d9e8e8;" id="ProvEmailFld" placeholder="Email here" type="text" name="EmailFld" value="<%=Email%>"/></td>
                                                        </tr>                                        
                                                </tbody>
                                                </table>
                                                        <script>
                                                        var ProvPhnNumberFld = document.getElementById("ProvPhnNumberFld");

                                                        function numberFuncPhoneNumberEdit(){

                                                            var number = parseInt((ProvPhnNumberFld.value.substring(ProvPhnNumberFld.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                ProvPhnNumberFld.value = ProvPhnNumberFld.value.substring(0, (ProvPhnNumberFld.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncPhoneNumberEdit, 1);

                                                        function checkMiddlePhoneNumberEdit(){

                                                            for(var i = 0; i < ProvPhnNumberFld.value.length; i++){

                                                                var middleString = ProvPhnNumberFld.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    ProvPhnNumberFld.value = ProvPhnNumberFld.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                       
                                                <input id="ProvIDforPerDetails" type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                                <input id="UpdateProvPerBtn" style="color: white; padding: 10px; border:0; border-radius: 4px; background-color: darkslateblue;" type="button" value="Update" name="UpdatePerInfoBtn" />
                                                        
                                            </form>
                                                
                                                <script>
                                                    $(document).ready(function(){
                                                        $("#UpdateProvPerBtn").click(function(event){
                                                            document.getElementById('ProviderPageLoader').style.display = 'block';
                                                            var FirstName = document.getElementById("ProvFNameFld").value;
                                                            var MiddleName = document.getElementById("ProvMNameFld").value;
                                                            var LastName = document.getElementById("ProvLNameFld").value;
                                                            var PerEmail = document.getElementById("ProvEmailFld").value;
                                                            var PerTel = document.getElementById("ProvPhnNumberFld").value;
                                                            var ProviderID = document.getElementById("ProvIDforPerDetails").value;
                                                                
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "UpdateProvPerInfoController",
                                                                data: "ProviderID="+ProviderID+"&FirstNameFld="+FirstName+"&MiddleNameFld="+MiddleName+"&LastNameFld="+LastName+"&EmailFld="+PerEmail+"&MobileNumberFld="+PerTel,
                                                                success: function(result){
                                                                    alert(result);
                                                                    document.getElementById('ProviderPageLoader').style.display = 'none';
                                                                    document.getElementById('EditPerInfoDiv').style.display = "none";
                                                                   $.ajax({
                                                                        type: "POST",
                                                                        url: "GetProvPerInfo",
                                                                        data: "ProviderID="+ProviderID,
                                                                        success: function(result){
                                                                            //alert(result);
                                                                            
                                                                            var PerInfo = JSON.parse(result);
                                                                            
                                                                            document.getElementById("ProvFNameFld").value = PerInfo.FirstName;
                                                                            document.getElementById("ProvMNameFld").value = PerInfo.MiddleName;
                                                                            document.getElementById("ProvLNameFld").value = PerInfo.LastName;
                                                                            document.getElementById("ProvEmailFld").value = PerInfo.Email;
                                                                            document.getElementById("ProvPhnNumberFld").value = PerInfo.Mobile;
                                                                            
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
                                                    
                                                    var ProvFNameFld = document.getElementById("ProvFNameFld");
                                                    var ProvMNameFld = document.getElementById("ProvMNameFld");
                                                    var ProvLNameFld = document.getElementById("ProvLNameFld");
                                                    var ProvPhnNumberFld = document.getElementById("ProvPhnNumberFld");
                                                    var ProvEmailFld = document.getElementById("ProvEmailFld");
                                                    var UpdateProvPerBtn = document.getElementById("UpdateProvPerBtn");
                                                    
                                                    function CheckUpdateProvPerBtn(){
                                                        
                                                        if(ProvFNameFld.value === "" || ProvMNameFld.value === "" || ProvLNameFld.value === ""
                                                                || ProvPhnNumberFld.value === "" || ProvEmailFld.value === ""){
                                                            UpdateProvPerBtn.style.backgroundColor = "darkgrey";
                                                            UpdateProvPerBtn.disabled = true;
                                                        }else{
                                                            UpdateProvPerBtn.style.backgroundColor = "darkslateblue";
                                                            UpdateProvPerBtn.disabled = false;
                                                        }
                                                            
                                                        
                                                    }
                                                    setInterval(CheckUpdateProvPerBtn,1);
                                                    
                                                </script>
                                        </div></center>
                                         
    <%
                                        for(int x = 0; x < ReviewsList.size(); x++){

                                            String ReviewMessage = "";

                                            SimpleDateFormat ReviewSDF = new SimpleDateFormat("MMM dd, yyyy");
                                            String ReviewStringDate = ReviewSDF.format(ReviewsList.get(x).ReviewDate);

                                            try{

                                                ReviewMessage = ReviewsList.get(x).ReviewMessage;

                                            }catch(Exception e){}

                                            int CustomerRating = ReviewsList.get(x).Rating;
                                            int CustomerID = ReviewsList.get(x).UserID;
                                            String ClientFullName = "";
                                            String Base64Image = "";

                                            try{

                                                Class.forName(Driver);
                                                Connection ReviewCustConn = DriverManager.getConnection(Url, user, password);
                                                String CustString = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                                                PreparedStatement CustInfoPst = ReviewCustConn.prepareStatement(CustString);
                                                CustInfoPst.setInt(1, CustomerID);

                                                ResultSet CustRec = CustInfoPst.executeQuery();

                                                while(CustRec.next()){

                                                    String FirstName = CustRec.getString("First_Name").trim();
                                                    String MiddleName = CustRec.getString("Middle_Name").trim();
                                                    String LastName = CustRec.getString("Last_Name").trim();

                                                    ClientFullName = FirstName + " " + MiddleName + " " + LastName;


                                                    try{    
                                                        //put this in a try catch block for incase getProfilePicture returns nothing
                                                        Blob profilepic = CustRec.getBlob("Profile_Pic"); 
                                                        InputStream inputStream = profilepic.getBinaryStream();
                                                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                                        byte[] buffer = new byte[4096];
                                                        int bytesRead = -1;

                                                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                            outputStream.write(buffer, 0, bytesRead);
                                                        }

                                                        byte[] imageBytes = outputStream.toByteArray();

                                                         Base64Image = Base64.getEncoder().encodeToString(imageBytes);


                                                    }
                                                    catch(Exception e){}


                                                }

                                            }catch(Exception e){
                                                e.printStackTrace();
                                            }
                                            
    %>

                                            <div style='box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); margin: 5px; border-radius: 4px;
                                                         background-color: #374949; padding: 1px; padding: 15px; margin-bottom: 5px; margin-bottom: 5px;'>
                                                    
                                                    <p style="font-size: 20px; color: #37a0f5; font-weight: bolder; text-align: center; margin-bottom: 10px;">
                                                        <span style="color: tomato;">Overall Rating: </span>
                                                        <span style="font-size: 20px; margin-left: 10px;">
                                                        <%
                                                            if(Ratings ==5){

                                                        %> 
                                                        ★★★★★ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #eeeeee; font-size: 10px;"> Great job</span></i>
                                                        <%
                                                             }else if(Ratings == 4){
                                                        %>
                                                        ★★★★☆ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #eeeeee; font-size: 10px;"> Good job</span></i>
                                                        <%
                                                             }else if(Ratings == 3){
                                                        %>
                                                        ★★★☆☆ 
                                                        <i class="fa fa-thumbs-up" style="color: yellow; font-size: 16px; margin-left: 20px;"><span style="color: #eeeeee; font-size: 10px;"> Average rating</span></i>
                                                        <%
                                                             }else if(Ratings == 2){
                                                        %>
                                                        ★★☆☆☆ 
                                                        <i class="fa fa-exclamation-triangle" style="color: red; font-size: 17px; margin-left: 20px;"><span style="color: #eeeeee; font-size: 10px;"> Bad rating</span></i>
                                                        <%
                                                             }else if(Ratings == 1){
                                                        %>
                                                        ★☆☆☆☆   
                                                        <i class="fa fa-thumbs-down" aria-hidden="true" style="color: red; font-size: 16px; margin-left: 20px;"><span style="color: #eeeeee; font-size: 10px;"> Worst rating</span></i>
                                                        <%}%>
                                                        </span>
                                                        
                                                    </p>
                                                    
                                                    <p style='text-align: center; color: #8b8b8b; margin: 10px 0; margin-top: 20px;'>Recent Customer Review</p>
                                                <div style="display: flex; flex-direction: row; justify-content: center;"> 
                                                <%
                                                    if(Base64Image == ""){
                                                %> 

                                                    <img style="border-radius: 100%; margin-left: 5px; width: 50px; height: 50px;" src="icons/icons8-user-filled-50.png" alt="icons8-user-filled-50"/>

                                                <%
                                                    }else{
                                                %>
                                                    <!--img  class="fittedImg" style="border-radius: 100%; margin-left: 5px; width: 50px; height: 50px;" src="data:image/jpg;base64,<=Base64Image%>"/-->
                                                    <div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; overflow: hidden;">
                                                        <img style="width: 50px; height: auto;" src="data:image/jpg;base64,<%=Base64Image%>"/>
                                                    </div>
                                                <%
                                                    }
                                                %>
                                            <center><div style="margin-left: 10px;">                 
                                            <p style='color: white; text-align: left; margin: 0; font-weight: bolder;'><%=ClientFullName%></p>

                                            <p style='color: darkgray; text-align: left; margin: 0;'>Rated: <span style="color: gold; font-size: 18px;">


                                                <%
                                                    if(CustomerRating == 5){

                                                %> 
                                                        ★★★★★
                                                <%
                                                    }else if(CustomerRating == 4){
                                                %>
                                                        ★★★★☆
                                                <%
                                                    }else if(CustomerRating == 3){
                                                %>
                                                        ★★★☆☆
                                                <%
                                                    }else if(CustomerRating == 2){
                                                %>
                                                        ★★☆☆☆
                                                <%
                                                    }else if(CustomerRating == 1){
                                                %>
                                                        ★☆☆☆☆
                                                <%  }  %>
                                                        </span>
                                            </p>

                            <%
                                if(!ReviewMessage.equals("")){
                            %>
                                <p style='color: darkgray; text-align: left; margin: 0;'>Says: <span style='color: white;'><%=ReviewMessage%></span></p>

                                <p style='color: silver; float: right; margin: 0; margin-right: 5px;'><%=ReviewStringDate%></p>
                            <%}%>
                                <a href='ViewSelectedProviderReviews.jsp?UserIndex=<%=UserIndex%>&Provider=<%=UserID%>&User=<%=NewUserName%>' onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"><p style='clear: both; text-align: center; color: greenyellow; cursor: pointer; padding-top: 10px;'>See More...</p></a>
                            </div>
                        </div>
                    </div>

                        <%}%>
                        
                        <%
                            if(ReviewsList.size() == 0){
                        %>

                        <!--center><p style="color: #636363; text-align: center; margin: 30px 0; max-width: 600px;"><i style="color: orange;" class="fa fa-exclamation-triangle"></i> You don't have any customer reviews</p></center-->
                        
                        <%}%>
                                        
                                        <%
                                            if(firstPic != ""){
                                        %>
                                        
                                        <div style="margin: 5px; margin-top: 20px; margin-bottom: 20px; background: white; padding: 15px 5px; border-radius: 4px;  box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">
                                        
                                            <p style="text-align: center; color: #254386; font-weight: bolder; padding-bottom: 20px; padding-top: 5px;">Photo Gallery</p>
                                            
                                        <%
                                            if(seventhPic != ""){
                                        %>
                                            
                                            <center><img  class="fittedImg" src="data:image/jpg;base64,<%=seventhPic%>" width="100%" height="300" style="max-width: 350px; margin-bottom: 0;  border-radius: 5px;"/></center>
                                         
                                        <%}%>
                                            <table style="margin: auto; width: 100%; max-width: 350px; margin-top: 0;">
                                               
                                                <tbody>
                                                <tr>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=firstPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        
                                                    </td>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=secondPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        
                                                    </td>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=thirdPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=fourthPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        
                                                    </td>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=fithPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        
                                                    </td>
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=sixthPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px; padding-top: 0;">
                                                        <div style="background-color: black; opacity: 0.7; width: 96%; height: 96%; cursor: pointer; margin-left: 2px;">
                                                            <a href="PhotoPreview.jsp?UserIndex=<%=Integer.toString(UserIndex)%>&User=<%=NewUserName%>" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';"><p style="color: white; text-align: center; padding-top: 20px;"><img src="icons/icons8-photo-gallery-20 (1).png" width="20" height="20" alt="icons8-photo-gallery-20 (1)"/>
                                                            </p>
                                                            <p style="color: white; text-align: center;">View Photos</p></a>
                                                            </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        </div>
                                                    
                                        <%} else{%>
                                        
                                        <a href="UploadGalleryPhotoWindow.jsp?UserIndex=<%=UserIndex%>" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';">
                                            <p style="padding: 30px 5px; margin: 5px; border-radius: 4px; color: #636363; cursor: pointer; text-align: center;">
                                                <img src="icons/AddPhotoImg.png" style="width: 30px; height: 30px;" alt=""/>
                                                <sup>Create Photo Gallery</sup>
                                            </p></a>
                                        
                                        <%}%>
                                      
                                        <table cellspacing="0" style="width: 100%; border: none !important; padding-bottom: 10px;">
                                            <tbody>
                                                <tr>
                                                    <td onclick="activateServicesTab()" id="Services" style="text-align: center; padding: 10px; cursor: pointer; font-weight: bolder;">
                                                        <i class="fa fa-bars" aria-hidden="true"></i> Services
                                                    </td>
                                                    <td onclick="activateHourOpenTab()" id="HoursOpen" style="text-align: center; padding: 10px; cursor: pointer; color: #636363;">
                                                        <i class="fa fa-sliders" aria-hidden="true"></i> Settings
                                                    </td>
                                                    <td onclick="activateClientsTab()" id="Clients" style="text-align: center; padding: 10px; cursor: pointer; color: #636363;">
                                                        <i class="fa fa-address-card" aria-hidden="true"></i> Clients
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        
                                <div style=" height: auto; overflow-y: auto;">
                                        
                                <div id="ServiceListDiv">
                                <div class="scrolldiv" id="serviceslist" style="min-height: 490px; border: none !important;">
                                    
                                     <!--center><p style="color: tomato; margin: 5px;">Services</p></center-->
                                     
                                     <div>
                                         
                                     <table style="width: 100%; border-spacing: 5px 10px;">
                                     <tbody>
                                             
                                <%
                                    
                                     if(Services.getNumberOfServices() != 0){   
                                         
                                         for(int i = 0; i < Services.getNumberOfServices(); i++){
                                             
                                         String IString = Integer.toString(i);
                                           
                                         int ServiceID = Services.getID(i);
                                         String ServicePrice = Services.getPrice(i);
                                         String ServiceName = Services.getService(i).trim();
                                         int ServiceDuration = Services.getDuration(i);
                                         String ServiceDescription = Services.getDescription(i).trim();
                                         
                                         String PriceFld = "Price" + Integer.toString(i);
                                         String NameFld = "Name" + Integer.toString(i);
                                         String DurationFld = "Dur" + Integer.toString(i);
                                         String DescriptionFld = "Desc" + Integer.toString(i);
                                         
                                     
                                %>
                                     
                                         <tr id="ServiceRow<%=i%>">
                                             <td style="background-color: white; margin: 15px 0; padding: 10px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); border-radius: 4px;">
                                                 
                                                 <p style="color: black; margin: 15px 0;"><span id="ServiceNameDetail<%=i%>" style="color: #254386; font-weight: bolder;"><%=ServiceName%></span>
                                                     <span id="ServPrcDur<%=i%>"> - $<%=ServicePrice%> - <%=ServiceDuration%> mins.</span><span style="float: right;">
                                                         <img style="cursor: pointer;" onclick = "toggleHideEditService(<%=IString%>)" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></span>
                                                 </p>
                                                 <p style="margin-bottom: 15px;" id="SvcDescDetail<%=i%>" style="color: darkgray;"><%=ServiceDescription%></p>
                                                 
                                                <form style=" display: none; margin-top: 20px; width: 100%; max-width: 600px;" id="changeServiceForm<%=IString%>" class="changeServiceForm" name="EditService">
                                                 
                                                <p style="color: red; margin: 5px;">Change this service</p>
                                                     
                                                <div style="width: fit-content; margin: auto;">
                                                    
                                                    <p style="text-align: left; max-width: 500px;">
                                                        <span style="color: darkblue;">Service Name:</span> 
                                                        <input id="EditServiceName<%=i%>" style="background-color: white;" type="text" name="SerivceNameFld" value="<%=ServiceName%>" />
                                                    </p>
                                                 
                                                    <p style="text-align: left; max-width: 500px;">
                                                        <span style="color: darkblue;">Price:</span>
                                                        $<input id="EditPriceDD<%=i%>" onclick="checkMiddlenumberFuncEditPriceDD();" onkeydown="checkMiddlenumberFuncEditPriceDD();" type="text" style="width: 35px; border: 0; background-color: white; text-align: right; margin-right: 0; margin-left: 0;" placeholder="00" name="ServicePriceFldDD" value="" />.<input id="EditPriceCC<%=i%>" onclick="checkMiddleEditPriceCC();" onkeydown="checkMiddleEditPriceCC();" type="text" style="text-align: left; margin-left: 0; width: 35px; border:0; background-color: white;" placeholder="00" name="ServicePriceFldCC" value="" />
                                                    </p>
                                                 
                                                    <p style="text-align: left; max-width: 500px;">
                                                        <span style="color: darkblue;">Duration:</span> 
                                                        <select style="background-color: #d9e8e8; color: black; border: none; padding: 5px;" id="DurationFldHH<%=i%>" name="DurationFldHH">
                                                            <option value="0">0 hour(s)</option>
                                                            <option value="1">1 hour(s)</option>
                                                            <option value="2">2 hour(s)</option>
                                                            <option value="3">3 hour(s)</option>
                                                            <option value="4">4 hour(s)</option>
                                                            <option value="5">5 hour(s)</option>
                                                        </select> 
                                                            -
                                                        <select style="background-color: #d9e8e8; color: black; border: none; padding: 5px;" id="DurationFldMM<%=i%>" name="DurationFldMM">
                                                            <option value="15">15 minute(s)</option>
                                                            <option value="20">20 minute(s)</option>
                                                            <option value="25">25 minute(s)</option>
                                                            <option value="30">30 minute(s)</option>
                                                            <option value="35">35 minute(s)</option>
                                                            <option value="40">40 minute(s)</option>
                                                            <option value="45">45 minute(s)</option>
                                                            <option value="50">50 minute(s)</option>
                                                            <option value="55">55 minute(s)</option>
                                                            <option value="0">0 minute(s)</option>
                                                        </select> 
                                                    </p>
                                                 
                                                 <!--center><input style="background-color: white; margin: 5px;" type="text" name="" value="<=ServiceDuration%>" /-->
                                                 
                                                    <p style="text-align: left; max-width: 500px;">
                                                        <textarea id="ServiceNotes<%=i%>" name="DescriptionFld" rows="4" cols="40"><%=ServiceDescription%>
                                                        </textarea>
                                                     </p>
                                                     
                                                     <script>
                                                        

                                                        function numberFuncEditPriceDD(){
                                                            
                                                            var EditPriceDD = document.getElementById("EditPriceDD<%=i%>");

                                                            var number = parseInt((EditPriceDD.value.substring(EditPriceDD.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                EditPriceDD.value = EditPriceDD.value.substring(0, (EditPriceDD.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncEditPriceDD, 1);

                                                        function checkMiddlenumberFuncEditPriceDD(){
                                                            
                                                            var EditPriceDD = document.getElementById("EditPriceDD<%=i%>");

                                                            for(var i = 0; i < EditPriceDD.value.length; i++){

                                                                var middleString = EditPriceDD.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    EditPriceDD.value = EditPriceDD.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                    
                                                    <script>
                                                        

                                                        function numberFuncEditPriceCC(){
                                                            
                                                            var EditPriceCC = document.getElementById("EditPriceCC<%=i%>");

                                                            var number = parseInt((EditPriceCC.value.substring(EditPriceCC.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                EditPriceCC.value = EditPriceCC.value.substring(0, (EditPriceCC.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncEditPriceCC, 1);

                                                        function checkMiddleEditPriceCC(){
                                                            
                                                            var EditPriceCC = document.getElementById("EditPriceCC<%=i%>");

                                                            for(var i = 0; i < EditPriceCC.value.length; i++){

                                                                var middleString = EditPriceCC.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    EditPriceCC.value = EditPriceCC.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                     
                                                 <input id="ServiceID<%=i%>" type="hidden" name="ServiceID" value="<%=ServiceID%>" />
                                                 <p style="text-align: center;"><input id="EditServiceBtn<%=i%>" style="background-color: darkslateblue; border: none; color: white; border-radius: 4px; padding: 10px;" type="button" value="change" name="<%=IString%>editService" /></p>
                                        </div>
                                               <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#EditServiceBtn<%=i%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var ServiceName = document.getElementById("EditServiceName<%=i%>").value;
                                                        var PriceDD = document.getElementById("EditPriceDD<%=i%>").value;
                                                        var PriceCC = document.getElementById("EditPriceCC<%=i%>").value;
                                                        var DurationHHFld = document.getElementById("DurationFldHH<%=i%>");
                                                        var DurationMMFld = document.getElementById("DurationFldMM<%=i%>");
                                                        var DurationHH = DurationHHFld.options[DurationHHFld.selectedIndex].value;
                                                        var DurationMM = DurationMMFld.options[DurationMMFld.selectedIndex].value;
                                                        var ServiceNotes = document.getElementById("ServiceNotes<%=i%>").innerHTML;
                                                        var ServiceID = document.getElementById("ServiceID<%=i%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "ChangeServiceController",  
                                                        data: "SerivceNameFld="+ServiceName+"&ServicePriceFldDD="+PriceDD+"&ServicePriceFldCC="+PriceCC+"&DurationFldHH="+DurationHH+"&DurationFldMM="+DurationMM+"&DescriptionFld="+ServiceNotes+"&ServiceID="+ServiceID,  
                                                        success: function(result){ 
                                                            
                                                            alert(result);
                                                            document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("changeServiceForm<%=IString%>").style.display = "none";
                                                          
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetEachServiceDetails",
                                                              data: "ServiceID="+ServiceID,
                                                              success: function(result){
                                                                  
                                                                  var ServiceDetails = JSON.parse(result);
                                                                  
                                                                  var ServiceName = ServiceDetails.Name;
                                                                  var ServiceDuration = ServiceDetails.Duration;
                                                                  var ServicePrice = ServiceDetails.Price;
                                                                  ServicePrice = parseFloat(ServicePrice).toFixed(2);
                                                                  var ServiceDescription = ServiceDetails.Description;
                                                                  
                                                                  document.getElementById("ServiceNameDetail<%=i%>").innerHTML = ServiceName;
                                                                  document.getElementById("ServPrcDur<%=i%>").innerHTML = " - $" + ServicePrice + " - " + ServiceDuration + " mins";
                                                                  document.getElementById("SvcDescDetail<%=i%>").innerHTML = ServiceDescription;
                                                                  
                                                              }
                                                              
                                                          });
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                                 
                                                </form></center>
                                     
                                                <script>

                                                    function checkEditserviceBtn(){

                                                        if(document.getElementById("EditServiceName<%=i%>").value === ""){
                                                            document.getElementById("EditServiceBtn<%=i%>").style.backgroundColor = "darkgrey";
                                                            document.getElementById("EditServiceBtn<%=i%>").disabled = true;
                                                        }else{
                                                            document.getElementById("EditServiceBtn<%=i%>").style.backgroundColor = "darkslateblue";
                                                            document.getElementById("EditServiceBtn<%=i%>").disabled = false;
                                                        }

                                                    }

                                                    setInterval(checkEditserviceBtn, 1);
                                                </script>
                                     
                                                <form name="DeleteServiceForm" >
                                                    <input id="SVCIDforDelete<%=i%>" type="hidden" name="ServiceID" value="<%=ServiceID%>" />
                                                    <input id="deleteSVRBtn<%=i%>" style="color: white; border: none; background-color: crimson; border-radius: 4px; padding: 10px;" type="button" value="Delete this service" name="DeleteSVCBtn" />
                                                
                                            <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#deleteSVRBtn<%=i%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var ServiceID = document.getElementById("SVCIDforDelete<%=i%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteServiceController",  
                                                        data: "ServiceID="+ServiceID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("ServiceRow<%=i%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                        </script>
                                                
                                                </form>
                                             </td>
                                         </tr>
                                         
                                <%       } // end of for loop
                                    }//and of if block
                                    else{

                                %>
                                
                                <p id='noServStatus1' style="padding: 20px 5px; color: #334d81; text-align: center; font-weight: bolder;">
                                    <i style="color: red; font-weight: bolder;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> 
                                    Customers cannot book appointment if you don't have any service(s)</p>
                                <p id='noServStatus2' style="padding: 10px;"></p>
                                
                                
                                
                                <% 
                                        /*try{

                                            Class.forName(Driver);
                                            Connection AddSVCConn = DriverManager.getConnection(Url, user, password);
                                            String AddSVCString = "Insert into QueueServiceProviders.ServicesAndPrices"
                                                    + " (ProviderID, ServiceName, Price, ServiceDescription, ServiceDuration) values (?,?,?,?,?)";
                                            PreparedStatement AddSVCPst = AddSVCConn.prepareStatement(AddSVCString);
                                            AddSVCPst.setInt(1, UserID);
                                            AddSVCPst.setString(2, "Business' Regular Service");
                                            AddSVCPst.setString(3, "00.00");
                                            AddSVCPst.setString(4, "This service is provided as default. Service provider may delete this service in their own convinience.");
                                            AddSVCPst.setInt(5, 30);
                                            
                                            AddSVCPst.executeUpdate();

                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }*/
                                    } 
                                %>
                                     
                                        </tbody>
                                     </table></center>
                                     
                                     <center><p onclick = "toggleHideAddServiceDiv()" style=" box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                                                color: white; cursor: pointer; width: fit-content; padding: 10px; background-color: darkslateblue; border-radius: 4px; margin: auto; margin-top: 5px; margin-bottom: 5px;">
                                             Add Service</p></center>
                                     
                                    <div style=" display: none; margin: auto !important; padding: 10px; margin-bottom: 15px !important; margin-top: 15px !important; border: none !important; border-radius: 4px;
                                         box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);" id="addServiceDiv">
                                             
                                     <form name="addServices" style="padding-top: 5px; margin-left: 5px; text-align: center;">
                                         
                                         <p style="color: tomato; padding: 5px;">Add new service</p>
                                         
                                            <div style="width: fit-content; margin: auto;">
                                                <p style="text-align: left; max-width: 500px;">
                                                    <span style="color: darkblue;">Service Name:</span> 
                                                    <input id="AddServiceName" style="background-color: white;" type="text" name="SerivceNameFld" value="" />
                                                 </p>
                                                 
                                                 <p style="text-align: left; max-width: 500px;">
                                                    <span style="color: darkblue;">Price:</span> 
                                                    $<input onclick="checkMiddlenumberFuncNewPriceDD();" onkeydown="checkMiddlenumberFuncNewPriceDD();" id="NewPriceDD" type="text" style="width: 35px; border: 0; background-color: white; text-align: right; margin-right: 0; margin-left: 0;" placeholder="00" name="ServicePriceFldDD" value="" />.<input onclick="checkMiddlenumberFunctionNewPriceCC();" onkeydown="checkMiddlenumberFunctionNewPriceCC();" id="NewPriceCC" type="text" style="text-align: left; margin-left: 0; width: 35px; border:0; background-color: white;" placeholder="00" name="ServicePriceFldCC" value="" />
                                                 </p>
                                                 <p style="text-align: left; max-width: 500px;">
                                                    <span style="color: darkblue;">Duration:</span> 
                                                    <select style="background-color: #d9e8e8; color: black; border: none; padding: 5px;" id="DurationFldHHAddSVC" name="DurationFldHH">
                                                        <option value="0">0 hour(s)</option>
                                                        <option value="1">1 hour(s)</option>
                                                        <option value="2">2 hour(s)</option>
                                                        <option value="3">3 hour(s)</option>
                                                        <option value="4">4 hour(s)</option>
                                                        <option value="5">5 hour(s)</option>
                                                    </select> 
                                                      -
                                                    <select style="background-color: #d9e8e8; color: black; border: none; padding: 5px;" id="DurationFldMMAddSVC" name="DurationFldMM">
                                                        <option value="15">15 minute(s)</option>
                                                        <option value="20">20 minute(s)</option>
                                                        <option value="25">25 minute(s)</option>
                                                        <option value="30">30 minute(s)</option>
                                                        <option value="35">35 minute(s)</option>
                                                        <option value="40">40 minute(s)</option>
                                                        <option value="45">45 minute(s)</option>
                                                        <option value="50">50 minute(s)</option>
                                                        <option value="55">55 minute(s)</option>
                                                        <option value="0">0 minute(s)</option>
                                                    </select> 
                                                </p>
                                                 
                                                 <!--center><input style="background-color: white; margin: 5px;" type="text" name="" value="<=ServiceDuration%>" /-->
                                                 
                                                 <script>
                                                        var NewPriceDD = document.getElementById("NewPriceDD");

                                                        function numberFuncNewPriceDD(){

                                                            var number = parseInt((NewPriceDD.value.substring(NewPriceDD.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                NewPriceDD.value = NewPriceDD.value.substring(0, (NewPriceDD.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncNewPriceDD, 1);

                                                        function checkMiddlenumberFuncNewPriceDD(){

                                                            for(var i = 0; i < NewPriceDD.value.length; i++){

                                                                var middleString = NewPriceDD.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    NewPriceDD.value = NewPriceDD.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                    
                                                    <script>
                                                        var NewPriceCC = document.getElementById("NewPriceCC");

                                                        function numberFuncNewPriceCC(){

                                                            var number = parseInt((NewPriceCC.value.substring(NewPriceCC.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                NewPriceCC.value = NewPriceCC.value.substring(0, (NewPriceCC.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncNewPriceCC, 1);

                                                        function checkMiddlenumberFunctionNewPriceCC(){

                                                            for(var i = 0; i < NewPriceCC.value.length; i++){

                                                                var middleString = NewPriceCC.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    NewPriceCC.value = NewPriceCC.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script>
                                                 
                                                <p style="text-align: left; max-width: 500px;">
                                                    <textarea id="ServiceDescForAdd" onfocus="if(this.innerHTML === 'Add service description here')this.innerHTML = '';" name="DescriptionFld" rows="4" cols="40">Add service description here</textarea>
                                                </p>
                                                <input id="AddSVCPID" type="hidden" name="ProviderID" value="<%=UserID%>" />
                                                <input style="background-color: darkslateblue; border-radius: 4px; color: white; padding: 10px; border: none;" id ="addServiceBtn" type="button" value="Add Service" name="addNewService" />
                                            </div>
                                         
                                         <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#addServiceBtn').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var ServiceName = document.getElementById("AddServiceName").value;
                                                        var PriceDD = document.getElementById("NewPriceDD").value;
                                                        var PriceCC = document.getElementById("NewPriceCC").value;
                                                        var DurationHHFld = document.getElementById("DurationFldHHAddSVC");
                                                        var DurationMMFld = document.getElementById("DurationFldMMAddSVC");
                                                        var DurationHH = DurationHHFld.options[DurationHHFld.selectedIndex].value;
                                                        //var DurationHH = DurationHHFld.value;
                                                        var DurationMM = DurationMMFld.options[DurationMMFld.selectedIndex].value;
                                                        //var DurationMM = DurationMMFld.value;
                                                        var ServiceNotes = document.getElementById("ServiceDescForAdd").value;
                                                        var ProviderID = document.getElementById("AddSVCPID").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "AddServicesController",  
                                                        data: "SerivceNameFld="+ServiceName+"&ServicePriceFldDD="+PriceDD+"&ServicePriceFldCC="+PriceCC+"&DurationFldHH="+DurationHH+"&DurationFldMM="+DurationMM+"&DescriptionFld="+ServiceNotes+"&ProviderID="+ProviderID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("addServiceDiv").style.display = "none";
                                                          document.getElementById("AddServiceName").value = "";
                                                          document.getElementById("NewPriceDD").value = "";
                                                          document.getElementById("NewPriceCC").value = "";
                                                          document.getElementById("ServiceDescForAdd").innerHTML = "";
                                                          if(document.getElementById("noServStatus1"))
                                                          document.getElementById("noServStatus1").style.display = "none";
                                                          
                                                          $.ajax({
                                                              type: "POST",
                                                              url: "GetLastServiceAjax",
                                                              data: "SerivceNameFld="+ServiceName+"&ServicePriceFldDD="+PriceDD+"&ServicePriceFldCC="+PriceCC+"&DurationFldHH="+DurationHH+"&DurationFldMM="+DurationMM+"&DescriptionFld="+ServiceNotes+"&ProviderID="+ProviderID,
                                                              success: function(result){
                                                                  
                                                                  var ServiceDetails = JSON.parse(result);
                                                                  
                                                                  var ServiceID = ServiceDetails.ID;
                                                                  var name = ServiceDetails.Name;
                                                                  var price = parseFloat(ServiceDetails.Price).toFixed(2);
                                                                  var duration = ServiceDetails.Dur;
                                                                  var description = ServiceDetails.Desc;
                                                                  var UserIndex = "<%=UserIndex%>";
                                                                  var UserName = "<%=NewUserName%>";
                                                                  
                                                                  var NewServDiv = document.getElementById("newServDiv");
                                                                  NewServDiv.style.display = "block";
                                                                  
                                                                  var aService = document.createElement('div');
                                                                  
                                                                  aService.innerHTML = '<div style="margin: 10px; background-color: white; border-radius: 4px; padding: 10px; text-align: left; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);">'+
                                                                          '<p style="margin: 15px 0;"><span style="color: blue;">'+name+'</span> - $'+price+' - '+duration+' mins</p>'+
                                                                          '<p style="margin-bottom: 15px;">Description: <span style="color: darkgrey;">'+description+'</span></p>'+
                                                                          '<form method="POST" action="DeleteNewService">'+
                                                                              '<input type="hidden" name="UserIndex" value="'+UserIndex+'" />'+
                                                                              '<input name="User" type="hidden" value="'+UserName+'" />' +
                                                                              '<input type="hidden" name="ServiceID" value="'+ServiceID+'" />'+
                                                                              '<input type="submit" style="color: white; border: none; padding: 10px; background-color: crimson; border-radius: 4px;" value="Delete this service" />'+
                                                                           '</form>'+
                                                                          '</div>';
                                                                  
                                                                  NewServDiv.appendChild(aService);
                                                              }
                                                          });
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                     </form>
                                         
                                         <script>
                                             
                                             function checkAddserviceBtn(){
                                                 
                                                 if(document.getElementById("AddServiceName").value === ""){
                                                     document.getElementById("addServiceBtn").style.backgroundColor = "darkgrey";
                                                     document.getElementById("addServiceBtn").disabled = true;
                                                 }else{
                                                     document.getElementById("addServiceBtn").style.backgroundColor = "darkslateblue";
                                                     document.getElementById("addServiceBtn").disabled = false;
                                                 }
                                                 
                                             }
                                             
                                             setInterval(checkAddserviceBtn, 1);
                                         </script>
                                     </div>
                                                                  
                                     <div id='newServDiv' style='display: none;'>
                                        <p style='color: darkblue; font-weight: bolder; margin: 10px 5px; text-align: center;'>Recent Added Service(s)</p>
                                     </div>
                                         
                                     </div>
                                    
                                </div> 
                                </div>
                                         
                                <div id="hoursOpenDiv" style="display: none;">
                                    
                                <div id="serviceslist">
                                    
                                    <%
                                        if(ThisProvider.TimeOpen.SundayStart.equals("") || ThisProvider.TimeOpen.SundayClose.equals("") ||
                                                ThisProvider.TimeOpen.MondayStart.equals("") || ThisProvider.TimeOpen.MondayClose.equals("") ||
                                                ThisProvider.TimeOpen.TuesdayStart.equals("") || ThisProvider.TimeOpen.TuesdayClose.equals("") ||
                                                ThisProvider.TimeOpen.WednessdayStart.equals("") || ThisProvider.TimeOpen.WednessdayClose.equals("") ||
                                                ThisProvider.TimeOpen.ThursdayStart.equals("") || ThisProvider.TimeOpen.ThursdayClose.equals("") ||
                                                ThisProvider.TimeOpen.FridayStart.equals("") ||ThisProvider.TimeOpen.FridayClose.equals("") ||
                                                ThisProvider.TimeOpen.SaturdayStart.equals("") ||ThisProvider.TimeOpen.SaturdayClose.equals("")){
                                            
                                            boolean isUserHoursSet = false;
                                            
                                            try{
                                                Class.forName(Driver);
                                                Connection HoursConn = DriverManager.getConnection(Url, user, password);
                                                String HoursString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                                PreparedStatement HoursPst = HoursConn.prepareStatement(HoursString);
                                                HoursPst.setInt(1, UserID);
                                                    
                                                ResultSet ProviderHoursRec = HoursPst.executeQuery();
                                                
                                                while (ProviderHoursRec.next()){
                                                    isUserHoursSet = true;
                                                }
                                            
                                            }catch(Exception e){
                                                e.printStackTrace();
                                            }
                                            
                                            if(isUserHoursSet == false){
                                                
                                                try{
                                                    Class.forName(Driver);
                                                    Connection HoursConn = DriverManager.getConnection(Url, user, password);
                                                    String HoursString = "Insert into QueueServiceProviders.ServiceHours (ProviderID) values(?)";
                                                    PreparedStatement HoursPst = HoursConn.prepareStatement(HoursString);
                                                    HoursPst.setInt(1, UserID);
                                                    
                                                    HoursPst.executeUpdate();
                                                }catch(Exception e){
                                                    e.printStackTrace();
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    %>
                                    
                                    <!--p style="color: tomato; margin: 5px; text-align: center;">Hours Open and Other Settings</p-->
                                    <table style="width: 100%; background-color: #3d6999; color: white; padding: 0; border-spacing: 0;">
                                        <tbody>
                                            <tr>
                                                <td id="ShowHourBtn" onclick="toggleshowHoursOpen();" style="padding: 10px 5px; cursor: pointer; width: 50%; text-align: center; border-bottom: 2px solid white;"><i style="margin-right: 5px;" class="fa fa-clock-o" aria-hidden="true"></i> Hours Open</td>
                                                <td id="showOtherSettingsBtn" onclick="toggleshowOtherSettings();" style="padding: 10px 5px; cursor: pointer; text-align: center; color: #ccc; border-bottom: #9bb1d0 2px solid;"><i style="margin-right: 5px;" class="fa fa-cogs" aria-hidden="true"></i> Other Settings</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                <div class="scrolldiv" style="min-height: 450px; overflow-y: auto;">
                                    
                                    <div id="ShowHoursOpenDiv">
                                    
                                    <div style="width: 100%; padding-top: 5px;">
                                    <form name="HoursOpen" action="SetProviderHoursController" method="POST">
                                    
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: #eeeeee;"><span style="color: red;">Sun:</span>
                                        <input id="SundayStart" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="SundayStart" value="<%=ThisProvider.TimeOpen.SundayStart%>" readonly/> -
                                        <input id="SundayClose" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="SundayClose" value="<%=ThisProvider.TimeOpen.SundayClose%>" readonly/>
                                        <input id="SundayChck" type="checkbox" name="SundayChck" value="12:00 am" />
                                        <label for="SundayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white;"><span style="color: red;">Mon:</span>
                                        <input id="MondayStart" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="MondayStart" value="<%=ThisProvider.TimeOpen.MondayStart%>" readonly/> -
                                        <input id="MondayClose" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="MondayClose" value="<%=ThisProvider.TimeOpen.MondayClose%>" readonly/>
                                        <input id="MondayChck" type="checkbox" name="MondayChck" value="12:00 am" />
                                        <label for="MondayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: #eeeeee;"><span style="color: red;">Tue:</span>
                                        <input id="TuesdayStart" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="TuesdayStart" value="<%=ThisProvider.TimeOpen.TuesdayStart%>" readonly/> -
                                        <input id="TuesdayClose" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="TuesdayClose" value="<%=ThisProvider.TimeOpen.TuesdayClose%>" readonly/>
                                        <input id="TuesdayChck" type="checkbox" name="TuesdayChck" value="12:00 am" />
                                        <label for="TuesdayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white;"><span style="color: red;">Wed:</span>
                                        <input id="WednesdayStart" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="WednesdayStart" value="<%=ThisProvider.TimeOpen.WednessdayStart%>" readonly/> -
                                        <input id="WednesdayClose" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="WednesdayClose" value="<%=ThisProvider.TimeOpen.WednessdayClose%>" readonly/>
                                        <input id="WednesdayChck" type="checkbox" name="WednesdayChck" value="12:00 am" />
                                        <label for="WednesdayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: #eeeeee;"><span style="color: red;">Thu:</span>
                                        <input id="ThursdayStart" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="ThursdayStart" value="<%=ThisProvider.TimeOpen.ThursdayStart%>" readonly/> -
                                        <input id="ThursdayClose" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="ThursdayClose" value="<%=ThisProvider.TimeOpen.ThursdayClose%>" readonly/>
                                        <input id="ThursdayChck" type="checkbox" name="ThursdayChck" value="12:00 am" />
                                        <label for="ThursdayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: white;"><span style="color: red;">Fri:</span>
                                        <input id="FridayStart" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="FridayStart" value="<%=ThisProvider.TimeOpen.FridayStart%>" readonly/> -
                                        <input id="FridayClose" style="background-color: white; border: 0; width: 60px;" placeholder="Not Set" type="text" name="FridayClose" value="<%=ThisProvider.TimeOpen.FridayClose%>" readonly/>
                                        <input id="FridayChck" type="checkbox" name="FridayChck" value="12:00 am" />
                                        <label for="FridayChck">Close</label></p>
                                        
                                        <p style="padding-left: 5px; padding-top: 5px; padding-bottom: 5px; background-color: #eeeeee;"><span style="color: red;">Sat:</span>
                                        <input id="SaturdayStart" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="SaturdayStart" value="<%=ThisProvider.TimeOpen.SaturdayStart%>" readonly/> -
                                        <input id="SaturdayClose" style="background-color: #eeeeee; border: 0; width: 60px;" placeholder="Not Set" type="text" name="SaturdayClose" value="<%=ThisProvider.TimeOpen.SaturdayClose%>" readonly/>
                                        <input id="SaturdayChck" type="checkbox" name="SaturdayChck" value="12:00 am" />
                                        <label for="SaturdayChck">Close</label></p>
                                        
                                        <input type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                        <input type='hidden' name='UserIndex' value='<%=UserIndex%>' />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <center><input id="UpdateHoursBtn" style="background-color: darkslateblue; padding: 5px; border-radius: 4px;" type="submit" value="Update Your Hours" name="UpdateHoursBtn" onclick="document.getElementById('ProviderPageLoader').style.display = 'block';" /></center>
                                        
                                    </form>
                                    </div>
                                    </div>
                                    
                                    <script>
                                        
                                        var SundayStart = document.getElementById("SundayStart");
                                        var SundayClose = document.getElementById("SundayClose");
                                        var SundayChck = document.getElementById("SundayChck");
                                        var MondayStart = document.getElementById("MondayStart");
                                        var MondayClose = document.getElementById("MondayClose");
                                        var MondayChck = document.getElementById("MondayChck");
                                        var TuesdayStart = document.getElementById("TuesdayStart");
                                        var TuesdayClose = document.getElementById("TuesdayClose");
                                        var TuesdayChck = document.getElementById("TuesdayChck");
                                        var WednesdayStart = document.getElementById("WednesdayStart");
                                        var WednesdayClose = document.getElementById("WednesdayClose");
                                        var WednesdayChck = document.getElementById("WednesdayChck");
                                        var ThursdayStart = document.getElementById("ThursdayStart");
                                        var ThursdayClose = document.getElementById("ThursdayClose");
                                        var ThursdayChck = document.getElementById("ThursdayChck");
                                        var FridayStart = document.getElementById("FridayStart");
                                        var FridayClose = document.getElementById("FridayClose");
                                        var FridayChck = document.getElementById("FridayChck");
                                        var SaturdayStart = document.getElementById("SaturdayStart");
                                        var SaturdayClose = document.getElementById("SaturdayClose");
                                        var SaturdayChck = document.getElementById("SaturdayChck");
                                        var UpdateHoursBtn = document.getElementById("UpdateHoursBtn");
                                        
                                        function toggleShowHoursUpdateBtn(){
                                            if(SundayStart.value === "" || SundayClose.value === "" || MondayStart.value === "" || MondayClose.value === ""
                                                    || TuesdayStart.value === "" || TuesdayClose.value === "" || WednesdayStart.value === "" 
                                                    || WednesdayClose.value === "" || ThursdayStart.value === "" || ThursdayClose.value === "" 
                                                    || FridayStart.value === "" || FridayClose.vlaue === "" || FridayClose === ""
                                                    || SaturdayStart.value === "" || SaturdayClose === ""){
                                                
                                                UpdateHoursBtn.style.display = "none";
                                            }else{
                                                UpdateHoursBtn.style.display = "block";
                                            }
                                            
                                        }
                                        
                                        setInterval(toggleShowHoursUpdateBtn,1);
                                        
                                        function checkSunClosedChck(){
                                            
                                            if((SundayStart.value === "12:00 am" && SundayClose.value === "12:00 am") || SundayChck.checked === true){
                                                SundayStart.disabled = true;
                                                SundayClose.disabled = true;
                                                SundayChck.checked = true;
                                                //if the text fields are disabled they will return null
                                                SundayStart.value = "Closed";
                                                SundayClose.value = "Closed";
                                            }
                                            else if(SundayChck.checked === false){
                                                SundayStart.disabled = false;
                                                SundayClose.disabled = false;
                                                
                                                if(SundayStart.value === "Closed" && SundayClose.value === "Closed"){
                                                    SundayStart.value = "9:00 am";
                                                    SundayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkSunClosedChck,1);
                                        
                                        function checkMonClosedChck(){
                                            
                                            if((MondayStart.value === "12:00 am" && MondayClose.value === "12:00 am") || MondayChck.checked === true){
                                                MondayStart.disabled = true;
                                                MondayClose.disabled = true;
                                                MondayChck.checked = true;
                                                MondayStart.value = "Closed";
                                                MondayClose.value = "Closed";
                                            }
                                            else if(MondayChck.checked === false){
                                                MondayStart.disabled = false;
                                                MondayClose.disabled = false;
                                                
                                                if(MondayStart.value === "Closed" && MondayClose.value === "Closed"){
                                                    MondayStart.value = "9:00 am";
                                                    MondayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkMonClosedChck,1);
                                        
                                        function checkTuesClosedChck(){
                                            
                                            if((TuesdayStart.value === "12:00 am" && TuesdayClose.value === "12:00 am") || TuesdayChck.checked === true){
                                                TuesdayStart.disabled = true;
                                                TuesdayClose.disabled = true;
                                                TuesdayChck.checked = true;
                                                TuesdayStart.value = "Closed";
                                                TuesdayClose.value = "Closed";
                                            }
                                            else if(TuesdayChck.checked === false){
                                                TuesdayStart.disabled = false;
                                                TuesdayClose.disabled = false;
                                                
                                                if(TuesdayStart.value === "Closed" && TuesdayClose.value === "Closed"){
                                                    TuesdayStart.value = "9:00 am";
                                                    TuesdayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkTuesClosedChck,1);
                                        
                                        function checkWedClosedChck(){
                                            
                                            if((WednesdayStart.value === "12:00 am" && WednesdayClose.value === "12:00 am") || WednesdayChck.checked === true){
                                                WednesdayStart.disabled = true;
                                                WednesdayClose.disabled = true;
                                                WednesdayChck.checked = true;
                                                WednesdayStart.value = "Closed";
                                                WednesdayClose.value = "Closed";
                                            }
                                            else if(WednesdayChck.checked === false){
                                                WednesdayStart.disabled = false;
                                                WednesdayClose.disabled = false;
                                                
                                                if(WednesdayStart.value === "Closed" && WednesdayClose.value === "Closed"){
                                                    WednesdayStart.value = "9:00 am";
                                                    WednesdayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkWedClosedChck,1);
                                        
                                        function checkThursClosedChck(){
                                            
                                            if((ThursdayStart.value === "12:00 am" && ThursdayClose.value === "12:00 am") || ThursdayChck.checked === true){
                                                ThursdayStart.disabled = true;
                                                ThursdayClose.disabled = true;
                                                ThursdayChck.checked = true;
                                                ThursdayStart.value = "Closed";
                                                ThursdayClose.value = "Closed";
                                            }
                                            else if(ThursdayChck.checked === false){
                                                    ThursdayStart.disabled = false;
                                                    ThursdayClose.disabled = false;
                                                
                                                if(ThursdayStart.value === "Closed" && ThursdayClose.value === "Closed"){
                                                    ThursdayStart.value = "9:00 am";
                                                    ThursdayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkThursClosedChck,1);
                                        
                                        function checkFriClosedChck(){
                                            
                                            if((FridayStart.value === "12:00 am" && FridayClose.value === "12:00 am") || FridayChck.checked === true){
                                                FridayStart.disabled = true;
                                                FridayClose.disabled = true;
                                                FridayChck.checked = true;
                                                FridayStart.value = "Closed";
                                                FridayClose.value = "Closed";
                                            }
                                            else if(FridayChck.checked === false){
                                                FridayStart.disabled = false;
                                                FridayClose.disabled = false;
                                                
                                                if(FridayStart.value === "Closed" && FridayClose.value === "Closed"){
                                                    FridayStart.value = "9:00 am";
                                                    FridayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkFriClosedChck,1);
                                        
                                        function checkSatClosedChck(){
                                            
                                            if((SaturdayStart.value === "12:00 am" && SaturdayClose.value === "12:00 am") || SaturdayChck.checked === true){
                                                SaturdayStart.disabled = true;
                                                SaturdayClose.disabled = true;
                                                SaturdayChck.checked = true;
                                                SaturdayStart.value = "Closed";
                                                SaturdayClose.value = "Closed";
                                            }
                                            else if(SaturdayChck.checked === false){
                                                SaturdayStart.disabled = false;
                                                SaturdayClose.disabled = false;
                                                
                                                if(SaturdayStart.value === "Closed" && SaturdayClose.value === "Closed"){
                                                    SaturdayStart.value = "9:00 am";
                                                    SaturdayClose.value = "5:00 pm";
                                                }
                                            }
                                            
                                        }
                                        
                                        setInterval(checkSatClosedChck,1);
                                            
                                    </script>
                                        
                                    <script>
                                            $('#MondayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#MondayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '5:00pm',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#TuesdayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#TuesdayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#WednesdayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 1,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#WednesdayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#ThursdayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#ThursdayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#FridayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#FridayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#SaturdayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#SaturdayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#SundayStart').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '00',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '00',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                            $('#SundayClose').timepicker({
                                                timeFormat: 'h:mm p',
                                                interval: 15,
                                                minTime: '01:00am',
                                                maxTime: '11:59pm',
                                                //defaultTime: '00',
                                                startTime: '01:00am',
                                                dynamic: false,
                                                dropdown: true,
                                                scrollbar: false
                                            });
                                        
                                    </script>
                                    
                                    
                                    
                                    <div id="ShowOtherSettingsDiv" style="display: none;">
                                    
                                    <div style="background-color: white; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                                         border-radius: 4px; padding: 5px; margin: 5px;">
                                    
                                        <div style="margin: auto;">
                                            <p style="cursor: pointer; color: tomato; margin: 5px; padding: 5px; background-color: #eeeeee; text-align: left;
                                                   border-radius: 4px; padding-top: 15px; padding-bottom: 15px;"><label for="CnclPlcyChck">Cancellation/Payment <span style="margin-left: 10px;"><i id="CnclPlcyPaymentStatuIcon" class="fa"></i></span></label>
                                                <span style="float: right;"><input style="background-color: white;" id="CnclPlcyChck" type="radio" name="CancellationPolicyChck" value="ON" />
                                                <label for="CnclPlcyChck">ON</label>
                                                <input style="background-color: white;" id="CnclPlcyChckOFF" type="radio" name="CancellationPolicyChck" value="OFF" />
                                                <label for="CnclPlcyChckOFF">OFF</label></span></p>
                                        </div>
                                            <p style="clear: both;"></p>
                                            
                                        <input id="EnabledCnclPlcy" type="hidden" name="CancelationPolicyEnabled" value="<%=isSettingAllowed%>" />
                                    
                                   <div style="background-color: #6699ff;">
                                
                                   <div id="CnclPlcyInfo" style="display: none; padding: 5px;">
                                <%
                                    String CardAdded = "0";
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection SaveIDConn = DriverManager.getConnection(Url, user, password);
                                        String SaveIDSql = "select * from QueueServiceProviders.StripeConnectedAccountIDs where ProvID = ?";
                                        PreparedStatement GetStatusPst = SaveIDConn.prepareStatement(SaveIDSql);
                                        GetStatusPst.setInt(1, UserID);
                                        ResultSet GetStatusRec = GetStatusPst.executeQuery();

                                        while(GetStatusRec.next()){
                                            
                                            CardAdded = GetStatusRec.getString("CardAdded").trim();
                                            break;

                                        }


                                    }catch(Exception e){}
                                    
                                     if(CardAdded.equalsIgnoreCase("0")){
                                %>
                                
                                                <div id="cardNotAddedForm">
                                                    <p id="AcceptPaymentCardStatus" style="color: darkblue; text-align: center; padding: 10px 0;">
                                                        <i style="color: orange;" class="fa fa-exclamation-triangle"></i> 
                                                        You cannot accept online payments.
                                                        <br/>
                                                        Your business bank is not added.
                                                    </p>
                                                    <%
                                                        String emailHash = QueuePWHash.GetHash(Email);
                                                        emailHash = UserID + emailHash;
                                                        //JOptionPane.showMessageDialog(null, emailHash);
                                                    %>
                                                    <!--p style='margin: 10px 5px; margin-top: 0; border-bottom: #334d81 1px solid; display: block;'></p-->
                                                    <a href="https://connect.stripe.com/express/oauth/authorize?client_id=ca_HaRSyhhy1omR9EXdBPZRCswKBXY4vb2i&state=<%=emailHash%>&stripe_user[email]=<%=Email%>" 
                                                       target="_blank">
                                                     <p style="padding: 10px 5px; background-color: #06adad; color: white; text-align: center; border-radius: 4px; max-width: 150px; margin:auto; cursor: pointer;">
                                                         <i class="fa fa-credit-card-alt" aria-hidden="true"></i> 
                                                         Add your bank card
                                                     </p>
                                                    </a>
                                                       
                                                    <script>
                                                        document.getElementById("CnclPlcyPaymentStatuIcon").classList.add("fa-exclamation-triangle");
                                                        document.getElementById("CnclPlcyPaymentStatuIcon").style.color = "red";
                                                    </script>
                                                       
                                                </div>
                                
                                <%
                                            }else if(CardAdded.equalsIgnoreCase("1")){
                                %>
                                
                                                <div id="cardAddedForm">
                                                    <p id="AcceptPaymentCardStatus" style="color: darkblue; text-align: center; padding: 10px 0;">
                                                        <i style="color: green;" class="fa fa-check"></i> 
                                                        You're all set to receive payments.
                                                    </p>
                                                    
                                                    <script>
                                                        document.getElementById("CnclPlcyPaymentStatuIcon").classList.add("fa-check");
                                                        document.getElementById("CnclPlcyPaymentStatuIcon").style.color = "green";
                                                    </script>
                                                </div>
                                
                                <%
                                            }
                                %>
                                    
                                   
                                    <p style='margin: 20px 5px; display: block;'></p>
                                    
                                    <p style='color: white; font-weight: bolder; margin: 5px 0; text-align: center;'>Cancellation and No-Show Policy</p>
                                    
                                    <p style="margin: 10px 0; text-align: center;">
                                    <small style='color: #eeeeee;'>
                                        The customer is allowed to cancel the appointment anytime before the appointment due time. This results in the customer having
                                        to pay the percentage amount you specify for cancellation charge.
                                    </small>
                                   </p>
                                   
                                   <p style="margin: 10px 0; text-align: center;">
                                    <small style='color: #eeeeee;'>
                                        No-show means that the customer failed to cancel before the appointment due time resulting 
                                        in them getting charged full amount immediately when appointment time is due.
                                    </small>
                                   </p>
                                   
                                   <p style='margin: 20px 5px; display: block;'></p>
                                   
                                   <p id="CancelStatusIndicator" style="margin: auto; color: darkblue; font-weight: bolder; text-align: center; margin-top: 10px; margin-bottom: 10px;"></p>
                                    <p style='text-align: center; margin: 10px 0; color: darkblue; font-weight: bolder;'><i class='fa fa-info-circle' style='color: #fefde5;'></i> Your current cancellation charge is <span id="PercentSpan" style=""><%=ChargePercentValue%> of total cost</span></p>
                                     
                                    <p onclick="showPolicyForm();" style="cursor: pointer; padding: 10px; background-color: darkslateblue; width: 200px; margin: auto; margin-top: 10px; text-align: center;
                                       margin-bottom: 10px; border-radius: 4px; color: white;">Change Cancellation Policy</p>
                                       
                                    <form id="CnclPlcyForm" style="display: none; margin-top: 10px; padding: 5px;" name="CancelationPolicyForm">
                                        
                                        <input id="PIDforCnclPlcy" type="hidden" name="ProviderID" value="<%=UserID%>">
                                        <!--Settings names used to identify these settings everywhere in this app-->
                                        <input id="timeElapse" type="hidden" name="TimeElapse" value="CnclPlcyTimeElapse"/>
                                        <input id="ChargeCost" type="hidden" name="ChargeCost" value="CnclPlcyChargeCost"/>
                                        
                                        <p onclick="$('#CnclPlcyForm').slideUp('slow');" style="text-align: center; color: white; font-size: 30px; padding: 0;">
                                            <i class="fa fa-caret-up" aria-hidden="true"></i>
                                        </p>
                                        
                                        <p style="text-align: center; margin-bottom: 10px; color: white;">Change Cancellation Policy</p>
                                        
                                        <p style="text-align: center;"><small style='color: honeydew'>What percentage of the service cost should your customers be charged as cancellation fee.
                                                <br/><br/> For example, If the customer books for $30.00 service, then 50% means you charge them $15.00 as cancellation fee.</small></p>
                                        <center><p id="percentPar" style="text-align: left; max-width: 500px; padding: 10px;">Charge Percentage: <select style="border: none; background-color: #d9e8e8; padding: 10px; color: black;" id="ChargePercent" name="ChargePercent">
                                                    <option>100%</option>
                                                    <option>90%</option>
                                                    <option>80%</option>
                                                    <option>75%</option>
                                                    <option>70%</option>
                                                    <option>60%</option>
                                                    <option>50%</option>
                                                    <option>40%</option>
                                                    <option>30%</option>
                                                    <option>25%</option>
                                                    <option>20%</option>
                                                    <option>10%</option>
                                                </select>
                                            </p></center>
                                        
                                        <!--script>
                                                    var CnclPlcyExpDate = document.getElementById("CnclPlcyExpDate");
                                                         
                                                         setInterval(function(){
                                                             
                                                            if(CnclPlcyExpDate.value !== ""){
                                                                
                                                               if(CnclPlcyExpDate.value.length === 2){
                                                                   
                                                                   CnclPlcyExpDate.value = CnclPlcyExpDate.value.substring(0,2) + "/" + CnclPlcyExpDate.value.substring(2);
                                                                  
                                                                   if(CnclPlcyExpDate.value === "///" || CnclPlcyExpDate.value.substring(1,3) === "//" || CnclPlcyExpDate.value.substring(0,1) === "/"){
                                                                       CnclPlcyExpDate.value = "";
                                                                   }
                                                                   
                                                               }
                                                               //checking if month is greater than 12
                                                               var month = parseInt((CnclPlcyExpDate.value.substring(0,2)), 10);
                                                               var month1 = parseInt((CnclPlcyExpDate.value.substring(0,1)), 10);
                                                               var month2 = parseInt((CnclPlcyExpDate.value.substring(1,2)), 10);
                                                               var year = parseInt((CnclPlcyExpDate.value.substring(3,5)), 10);
                                                               var year1 = parseInt((CnclPlcyExpDate.value.substring(3,4)), 10);
                                                               var year2 = parseInt((CnclPlcyExpDate.value.substring(4,5)), 10);
                                                               
                                                               if(month !== null){
                                                                    if(month > 12){
                                                                        CnclPlcyExpDate.value = "12" + CnclPlcyExpDate.value.substring(2,5);
                                                                    }
                                                                }
                                                                //checking if entered date is more than 5 characters
                                                               if(CnclPlcyExpDate.value.length > 5){
                                                                   CnclPlcyExpDate.value = CnclPlcyExpDate.value.substring(0,5);
                                                               }
                                                               //checking is what's entered is is not a number 
                                                               if(isNaN(month1))
                                                                   CnclPlcyExpDate.value = "";
                                                               if(isNaN(month2))
                                                                   CnclPlcyExpDate.value = CnclPlcyExpDate.value.substring(0,1) + "";
                                                               if(isNaN(year1))
                                                                   CnclPlcyExpDate.value = CnclPlcyExpDate.value.substring(0,3) + "";
                                                               if(isNaN(year2))
                                                                   CnclPlcyExpDate.value = CnclPlcyExpDate.value.substring(0,4) + "";
                                                              
                                                            }
                                                         },1);
                                                </script-->
                                        
                                            <!--script>
                                                        var CnclPlcyBizCardNumber = document.getElementById("CnclPlcyBizCardNumber");

                                                        function numberFuncCnclPlcyBizCardNumber(){

                                                            var number = parseInt((CnclPlcyBizCardNumber.value.substring(CnclPlcyBizCardNumber.value.length - 1)), 10);

                                                            if(isNaN(number)){
                                                                CnclPlcyBizCardNumber.value = CnclPlcyBizCardNumber.value.substring(0, (CnclPlcyBizCardNumber.value.length - 1));
                                                            }

                                                        }

                                                        setInterval(numberFuncCnclPlcyBizCardNumber, 1);

                                                        function checkMiddlenumberCnclPlcyBizCardNumber(){

                                                            for(var i = 0; i < CnclPlcyBizCardNumber.value.length; i++){

                                                                var middleString = CnclPlcyBizCardNumber.value.substring(i, (i+1));
                                                                //window.alert(middleString);
                                                                var middleNumber = parseInt(middleString, 10);
                                                                //window.alert(middleNumber);
                                                                if(isNaN(middleNumber)){
                                                                    CnclPlcyBizCardNumber.value = CnclPlcyBizCardNumber.value.substring(0, i);
                                                                }
                                                            }
                                                        }

                                                        //setInterval(checkMiddleNumber, 1000);
                                                    </script-->
                                               
                                        <p style="margin: auto; text-align: center; color: white; background-color: crimson; padding: 5px; border-radius: 4px; margin: 5px;">
                                            <input id="RmvCnclPlcy" type="checkbox" name="RMVCnclPlcy" value="ON" />
                                            <label for="RmvCnclPlcy">I dont want cancellation policy</label>
                                        </p>
                                        
                                        <center><input id="submitCnclPlcyBtn" style="padding: 10px; color: white; border: none; border-radius: 4px; background-color: darkslateblue;" type="button" value="Update" name="UpdateCnclPlcy" /></center>
                                    </form>
                                    
                                   </div>
                                   
                                    
                                   </div>
                                        
                                        
                                        
                                        <script>
                                            
                                            $(document).ready(function() {                        
                                                    $('#submitCnclPlcyBtn').click(function(event) {
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        
                                                            var ProviderID = document.getElementById("PIDforCnclPlcy").value;
                                                            var DurationHH = 0;
                                                            var DurationMM = 0;
                                                            var ChargeCost = document.getElementById("ChargeCost").value;
                                                            var timeElapse = document.getElementById("timeElapse").value;
                                                            var PercentOption = document.getElementById("ChargePercent");
                                                            var ChargePercent = PercentOption.options[PercentOption.selectedIndex].text;

                                                            if(ChargePercent.length === 3)
                                                                ChargePercent = "0" + ChargePercent;

                                                            ChargePercent = ChargePercent.substring(0,3);
                                                            var RMVCNCLOption = document.getElementById("RmvCnclPlcy");

                                                            var RemoveCancellation = "OFF";
                                                            if(RMVCNCLOption.checked === true){
                                                                RemoveCancellation = "ON";
                                                            }

                                                            $.ajax({  
                                                                type: "POST",  
                                                                url: "CancellationPolicyController",  
                                                                data: "ProviderID="+ProviderID+"&DurationFldHH="+DurationHH+"&ChargeCost="+ChargeCost+"&DurationFldMM="+DurationMM+"&TimeElapse="+timeElapse+"&ChargePercent="+ChargePercent+"&RMVCnclPlcy="+RemoveCancellation,  
                                                                success: function(result){  
                                                                  alert(result);
                                                                  document.getElementById('ProviderPageLoader').style.display = 'none';
                                                                  document.getElementById("CnclPlcyForm").style.display = "none";

                                                                  document.getElementById("CancelStatusIndicator").innerHTML = "<i style='color: green;' class='fa fa-check'></i> Cancellation policy has been set";

                                                                  if(document.getElementById("RmvCnclPlcy").checked === true){

                                                                     document.getElementById("PercentSpan").innerHTML = 0 + "% of service cost";
                                                                     document.getElementById("CnclPlcyChckOFF").checked = true;
                                                                     document.getElementById("CnclPlcyChck").checked = false;
                                                                     document.getElementById("CancelStatusIndicator").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> No cancellation policy";
                                                                     
                                                                  }else{

                                                                    document.getElementById("PercentSpan").innerHTML = parseInt(ChargePercent, 10) + "% of service cost";
                                                                  }
                                                                }                
                                                          });
                                                        
                                                      
                                                    });
                                                });
                                        </script>
                                        
                                   <script>
                                       
                                       var RmvCnclPlcy = document.getElementById("RmvCnclPlcy");
                                       var percentPar = document.getElementById("percentPar");
                                       var CnclPlcyChckOFF = document.getElementById("CnclPlcyChckOFF");
                                       
                                       if(document.getElementById("CnclPlcyChckOFF"))
                                           CnclPlcyChckOFF.disabled = true;
                                       
                                       function checkPlcForm(){
                                           
                                            if(RmvCnclPlcy.checked === true){
                                                percentPar.style.display = "none";
                                            }
                                            else{
                                                percentPar.style.display = "block";
                                                
                                            }
                                        }
                                        
                                        setInterval(checkPlcForm, 1);
                                       
                                       
                                       var CnclPlcyChck = document.getElementById("CnclPlcyChck");
                                       var CnclPlcyInfo = document.getElementById("CnclPlcyInfo");
                                       var CnclPlcyForm = document.getElementById("CnclPlcyForm");
                                       var EnabledCnclPlcy = document.getElementById("EnabledCnclPlcy");
                                       
                                       if(EnabledCnclPlcy.value === "Yes"){
                                           CnclPlcyChck.checked = true;
                                       }
                                       else{
                                           if(document.getElementById("CnclPlcyChckOFF"))
                                               CnclPlcyChckOFF.checked = true;
                                       }
                                       
                                       function showPolicyForm(){
                                           $("#CnclPlcyForm").slideDown("fast");
                                           //CnclPlcyForm.style.display = "block";
                                       }
                                       
                                       function CheckCancellationPlcy(){
                                           
                                            if(CnclPlcyChck.checked === true){
                                                $("#CnclPlcyInfo").slideDown("fast");

                                            }else{
                                               $("#CnclPlcyForm").slideUp("fast");
                                               $("#CnclPlcyInfo").slideUp("fast");
                                            }
                                        
                                       }
                                       
                                       if(document.getElementById("CnclPlcyChck"))
                                           setInterval(CheckCancellationPlcy, 1);
                                       
                                   </script>
                                    
                                    <center><p onclick="toggleShowSubscriptionDiv();" style="text-align: left; cursor: pointer; color: tomato; margin: 5px; padding: 5px; background-color: #eeeeee;
                                               border-radius: 4px; padding-top: 15px; padding-bottom: 15px;">Manage Your Subscription <span style='margin-left: 10px;'><i id="SubscriptionSettingsStatus" class="fa"></i></span></p></center>
                                    
                                    <div id="SubscriptionDiv" style="text-align: center; background-color: #6699ff; padding: 5px; display: none;">
                                        
                                    <form action="ProviderSubscriptionLoggedIn.jsp" method="POST">
                                        
                                        
                                    <!--p style="text-align: center; color: white; margin-bottom: 10px;">Your Queue Subscription</p-->
                                    <input type="hidden" name="SubscStatusValue" value="" />
                                    <p style="color: white; text-align: center; margin: 5px;">
                                        <span id='SubscriptionSettingsTextStatus' style="color: white; text-align: center;"></span>
                                        <br/>
                                        <span id='SubscriptionSettingsTextStatusSpan' style='font-size: 14px; color: #d8d8d8;'>your customers won't be able to book any appointments</span>
                                    </p>
                                    <a href='stripe-payment-view.jsp?providerEmail=<%=Email%>&ProviderId=<%=UserID%>' target='_blank'>
                                        <p id='SubscribeFromSettingsBtn' style='padding: 5px; color: white; background-color: darkslateblue; border-radius: 4px;'>Click here to subscribe</p>
                                    </a>
                                        
                                    <script>if(subscribedFlag === false){
                                        document.getElementById('SubscriptionSettingsTextStatus').innerHTML = "<i class='fa fa-exclamation-triangle' style='color: orange;'></i> You have not subscribed";
                                        document.getElementById('SubscriptionSettingsStatus').classList.add('fa-exclamation-triangle');
                                        document.getElementById('SubscriptionSettingsStatus').style.color = "red";
                                        document.getElementById('SubscriptionSettingsTextStatusSpan').style.display = "block";
                                        document.getElementById('SubscribeFromSettingsBtn').style.display = "block";
                                    }else{
                                        document.getElementById('SubscriptionSettingsTextStatus').innerHTML = "<i class='fa fa-check' style='color: green;'></i> You have a valid subscription";
                                        document.getElementById('SubscriptionSettingsStatus').classList.add('fa-check');
                                        document.getElementById('SubscriptionSettingsStatus').style.color = "green";
                                        document.getElementById('SubscriptionSettingsTextStatusSpan').style.display = "none";
                                        document.getElementById('SubscribeFromSettingsBtn').style.display = "none";
                                    }
                                </script>    
                                    </div>
                                    <script>
                                        var SubscriptionDiv = document.getElementById("SubscriptionDiv");
                                        
                                        function toggleShowSubscriptionDiv(){
                                            
                                            if(SubscriptionDiv.style.display === "none")
                                                $("#SubscriptionDiv").slideDown("fast");
                                                //SubscriptionDiv.style.display = "block";
                                            else
                                                $("#SubscriptionDiv").slideUp("fast");
                                                //SubscriptionDiv.style.display = "none";
                                                
                                        }
                                        
                                        var BizBankCard = document.getElementById("BizBankCard");
                                        
                                        function toggleShowBizBankCard(){
                                            
                                            if(BizBankCard.style.display === "none")
                                                $("#BizBankCard").slideDown("fast");
                                                //BizBankCard.style.display = "block";
                                            else
                                                $("#BizBankCard").slideUp("fast");
                                                //BizBankCard.style.display = "none";
                                            
                                        }
                                        
                                    </script>                                    
                                    <center><p onclick="toggleShowEditBizInfoDiv();" style="text-align: left; cursor: pointer; color: tomato; margin: 5px; padding: 5px; background-color: #eeeeee;
                                               border-radius: 4px; padding-top: 15px; padding-bottom: 15px;">Edit Your Business Info</p></center>
                                    
                                    <div id="EditBizInfoDiv" style="text-align: center; background-color: #6699ff; display: none">
                                        <form name="UpdateBizInfoForm">
                                        <p style="color: white; padding: 5px;">Your Business Information</p>
                                        <table style="width: 100%; max-width: 400px; background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; border: #3d6999 1px solid; margin: auto; margin-bottom: 5px; margin-bottom: 5px;">
                                            <tbody>
                                                <tr>
                                                    <td style="text-align: left;">Business Name: </td>
                                                    <td><input id="ProvBNameFld" style="background-color: #d9e8e8; border: #3d6999 1px solid;" type="text" name="BusinessNameFld" value="<%=BusinessName%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">Business Email: </td>
                                                    <td><input id="ProvBEmailFld" style="background-color: #d9e8e8; border: #3d6999 1px solid;" type="text" name="BusinessEmailFld" value="<%=BusinessEmail%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">Business Tel. Number: </td>
                                                    <td><input id="ProvBTelFld" style="background-color: #d9e8e8; border: #3d6999 1px solid;" type="text" name="BusinessTelephoneNumberFld" value="<%=BusinessTel%>" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">Business Type: </td>
                                                    <td><select style="background-color: #d9e8e8; border: #3d6999 1px solid; padding: 5px; color: black;" id="businessType" name="BusinessType">
                                            <option><%=BusinessType%></option>
                                            <option>Barber Shop</option>
                                            <option>Beauty Salon</option>
                                            <option>Day Spa</option>
                                            <option>Dentist</option>
                                            <option>Dietician</option>
                                            <option>Eyebrows and Eyelashes</option>
                                            <option>Hair Removal</option>
                                            <option>Hair Salon</option>
                                            <option>Holistic Medicine</option>
                                            <option>Home Services</option>
                                            <option>Makeup Artist</option>
                                            <option>Massage</option>
                                            <option>Medical Aesthetician</option>
                                            <option>Medical Center</option>
                                            <option>Nail Salon</option>
                                            <option>Personal Trainer</option>
                                            <option>Pet Services</option>
                                            <option>Physical Therapy</option>
                                            <option>Piercing</option>
                                            <option>Podiatry</option>
                                            <option>Tattoo Shop</option>
                                            <option>Other</option>
                                        </select></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <p style="color: white;">Your Business Location (Address)</p>
                                        <p style="margin: 5px; text-align: center;">Providing accurate address information<br/>will help customers locate your business</p>
                                        <p><i class='fa fa-exclamation-triangle' id='AddrStatusIcon'></i> <input id="businessLocation" type="text" name="businessLocation" value="" readonly style="background: none; border: none; font-size: 9px; width: 85%;"/></p>
                                        <table style="width: 100%; max-width: 400px; background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; border: #3d6999 1px solid; margin: auto; margin-top: 5px; margin-top: 5px;">
                                            <tbody>
                                                <tr>
                                                    <td> 
                                                        House:
                                                    </td>
                                                    <td>
                                                        <input id="HouseNumber" type="text" name="HouseNumber" placeholder='123...' value="<%=HouseNumber%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        Street:
                                                    </td>
                                                    <td>
                                                        <input id="Street" type="text" name="Street" placeholder='street/avenue' value="<%=StreetName%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        Town:
                                                    </td>
                                                    <td>
                                                        <input id="Town" type="text" name="Town" placeholder='town' value="<%=Town%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        City:
                                                    </td>
                                                    <td>
                                                        <input id="City" type="text" name="City" placeholder='city' value="<%=City%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        Zip Code:
                                                    </td>
                                                    <td>
                                                        <input id="ZCode" type="text" name="ZCode" placeholder='123...' value="<%=ZipCode%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        Country:
                                                    </td>
                                                    <td>
                                                        <input id="Country" type="text" name="Country" placeholder='country' value="<%=Country%>" style="background-color: #d9e8e8;"/>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <input id="ProvIDforUpdateBiz" type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                        <input id="UpdateProvBizBtn" style="background-color: darkslateblue; border: none; padding: 10px; border-radius: 4px; color: white; margin: auto; margin-top: 5px; margin-bottom: 5px;" type="button" value="Update" name="updateBizInfoBtn" />
                                        </form>
                                        
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#UpdateProvBizBtn').click(function(event) {  
                                                        
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var ProviderID = document.getElementById("ProvIDforUpdateBiz").value;
                                                        
                                                        //address information
                                                        var HouseNumber = document.getElementById("HouseNumber").value;
                                                        var Street = document.getElementById("Street").value;
                                                        var Town = document.getElementById("Town").value;
                                                        var City = document.getElementById("City").value;
                                                        var Country = document.getElementById("Country").value;
                                                        var ZCode = document.getElementById("ZCode").value;
                                                        
                                                        //business information
                                                        var BusinessName = document.getElementById("ProvBNameFld").value;
                                                        var BusinessEmail = document.getElementById("ProvBEmailFld").value;
                                                        var BusinessTel = document.getElementById("ProvBTelFld").value;
                                                        var BizTypeObj = document.getElementById("businessType");
                                                        var BizType = BizTypeObj.options[BizTypeObj.selectedIndex].text;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UpdateProvBizInfoController",  
                                                        data: "HouseNumber="+HouseNumber+"&ProviderID="+ProviderID+"&Street="+Street+"&Town="+Town+"&City="+City+"&Country="+Country+"&ZCode="+ZCode+"&BusinessEmailFld="+BusinessEmail+"&BusinessTelephoneNumberFld="+BusinessTel+"&BusinessType="+BizType+"&BusinessNameFld="+BusinessName,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("EditBizInfoDiv").style.display = "none";
                                                          $.ajax({  
                                                            type: "POST",  
                                                            url: "getProviderBizInforAjax",  
                                                            data: "ProviderID="+ProviderID,  
                                                            success: function(result){  
                                                              
                                                              var BusinessInfo = JSON.parse(result);
                                                              
                                                              document.getElementById("HouseNumber").value = BusinessInfo.Address.HouseNumber;
                                                              document.getElementById("Street").value = BusinessInfo.Address.Street;
                                                              document.getElementById("Town").value = BusinessInfo.Address.Town;
                                                              document.getElementById("City").value = BusinessInfo.Address.City;
                                                              document.getElementById("Country").value = BusinessInfo.Address.Country;
                                                              document.getElementById("ZCode").value = BusinessInfo.Address.ZipCode;
                                                              
                                                              var Address = BusinessInfo.Address.HouseNumber + " " + BusinessInfo.Address.Street + ", " + BusinessInfo.Address.Town + ", "
                                                                      + BusinessInfo.Address.City + ", " + BusinessInfo.Address.Country + " " + BusinessInfo.Address.ZipCode;
                                                              var FirstName = BusinessInfo.ProvName;
                                                              
                                                              document.getElementById("CompanyDetail").innerHTML = BusinessInfo.BusinessName;
                                                              document.getElementById("AddressDetail").innerHTML = Address;
                                                        
                                                              document.getElementById("ProvBNameFld").value = BusinessInfo.BusinessName;
                                                              document.getElementById("ProvBEmailFld").value = BusinessInfo.BusinessEmail;
                                                              document.getElementById("ProvBTelFld").value = BusinessInfo.BusinessTel;
                                                              BizTypeObj.options[BizTypeObj.selectedIndex].text = BusinessInfo.BusinessType;
                                                              //document.getElementById("LoginNameDisplay").innerHTML = " Logged in as " +FirstName+ " - " + BusinessInfo.BusinessName;
                                                          
                                                          
                                                            }                
                                                         });
                                                          
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                        </script>
                                        
                                        <script>
                                                    
                                                    var ProvBNameFld = document.getElementById("ProvBNameFld");
                                                    var ProvBEmailFld = document.getElementById("ProvBEmailFld");
                                                    var ProvBTelFld = document.getElementById("ProvBTelFld");
                                                    var HouseNumber = document.getElementById("HouseNumber");
                                                    var Street = document.getElementById("Street");
                                                    var Town = document.getElementById("Town");
                                                    var City = document.getElementById("City");
                                                    var ZCode = document.getElementById("ZCode");
                                                    var Country = document.getElementById("Country");
                                                    var UpdateProvBizBtn = document.getElementById("UpdateProvBizBtn");
                                                    
                                                    function CheckUpdateProvBizBtn(){
                                                        
                                                        if(ProvBNameFld.value === "" || ProvBEmailFld.value === "" || ProvBTelFld.value === ""
                                                                || HouseNumber.value === "" || Street.value === "" || Town.value === "" 
                                                                || City.value === "" || ZCode.value === "" || Country.value === "" ){
                                                            
                                                            UpdateProvBizBtn.style.backgroundColor = "darkgrey";
                                                            UpdateProvBizBtn.disabled = true;
                                                        }else{
                                                            UpdateProvBizBtn.style.backgroundColor = "darkslateblue";
                                                            UpdateProvBizBtn.disabled = false;
                                                        }
                                                            
                                                        
                                                    }
                                                    setInterval(CheckUpdateProvBizBtn,1);
                                                    
                                                </script>
                                        
                                    </div>
                                    
                                    <!--center><p style="cursor: pointer; color: tomato; margin: 5px; padding: 5px; border: 1px solid darkgrey;">Your Queue Stats.</p></center-->
                                    
                                    <center><p onclick="showUpdateLoginDiv();" style="text-align: left; cursor: pointer; color: tomato; margin: 5px; padding: 5px; background-color:
                                               #eeeeee; border-radius: 4px; padding-top: 15px; padding-bottom: 15px;">Edit Your Login Info.</p></center>
                                    
                                    <div id="UpdateLoginDiv" style="text-align: center; background-color: #6699ff; display: none;">
                                        
                                        <p style="color: white; padding: 5px;">Your Login Information</p>
                                        
                                        <form name="UpdateLoginInfo" >
                                            
                                            <table style="width: 100%; max-width: 400px; background-color: #9bb1d0; border-radius: 4px; width: fit-content; padding: 5px; border: #3d6999 1px solid; margin: auto; margin-bottom: 5px; margin-bottom: 5px;">
                                                        <tbody> 
                                                            <tr>
                                                                <td style="text-align: left;">Username: </td>
                                                                <td><input id="UsrNamefld" style="background-color: #d9e8e8;" type="text" name="UserNameFld" value="<%=UserName%>" /></td>
                                                            </tr>
                                                            <tr>
                                                                <input id="oldPassfld" type="hidden" name="oldpass" value=""/>
                                                                <td style="text-align: left;">Old Password: </td>
                                                                <td><input class="passwordFld" id="compareOldPassfld" id="" style="background-color: #d9e8e8;" type="password" name="OldPasswordFld" value="" />
                                                                    <p style="text-align: right; margin-top: -25px; margin-bottom: 10px; padding-right: 10px;"><i class="fa fa-eye showPassword" onclick="showPassword();" style="color: red;" aria-hidden="true"></i></p></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="text-align: left;">New Password: </td>
                                                                <td><input class="passwordFld" id="newPassfld" style="background-color: #d9e8e8;" type="password" name="NewPasswordFld" value="" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="text-align: left;">Confirm Password: </td>
                                                                <td><input class="passwordFld" id="compareNewPassfld" style="background-color: #d9e8e8;" type="password" name="ConfirmPasswordFld" value="" /></td>
                                                            </tr>
                                                        </tbody>
                                                </table>
                                                <p style="color: white;" id="UpdatePassStatus"></p>    
                                                <p id="WrongPassStatus" style="background-color: red; color: white; display: none;">Your current password is wrong </p>
                                               <input id="ProviderIDforUpdateLogin" type="hidden" name="ProviderID" value="<%=UserID%>"/>
                                               <input id="UserIndexforUpdateLogin" type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                               <input id="updateUsrAcntBtn" style="background-color: darkslateblue; border: none; padding: 10px; border-radius: 4px; color: white;" type="button" value="Update" />
                                        </form>
                                    </div>
                                    <script>
                                                        $(document).ready(function(){
                                                            $("#updateUsrAcntBtn").click(function(event){
                                                                document.getElementById('ProviderPageLoader').style.display = 'block';
                                                                var ProviderID = document.getElementById("ProviderIDforUpdateLogin").value;
                                                                var UserIndex = document.getElementById("UserIndexforUpdateLogin").value;
                                                                var UserName = document.getElementById("UsrNamefld").value;
                                                                var NewPassword = document.getElementById("newPassfld").value;
                                                                var oldPassword = document.getElementById("compareOldPassfld").value;
                                                                
                                                                $.ajax({
                                                                    method: "POST",
                                                                    url: "updateProvLoginInfo",
                                                                    data: "ProviderID="+ProviderID+"&UserIndex="+UserIndex+"&UserNameFld="+UserName+"&NewPasswordFld="+NewPassword+"&OldPasswordFld="+oldPassword,
                                                                    success: function(result){
                                                                        document.getElementById('ProviderPageLoader').style.display = 'none';
                                                                        if(result === "fail"){
                                                                            
                                                                            document.getElementById("WrongPassStatus").style.display = "block";
                                                                            document.getElementById("compareOldPassfld").value = "";
                                                                            document.getElementById("compareOldPassfld").style.backgroundColor = "red";
                                                                            
                                                                            //document.getElementById("changeUserAccountStatus").innerHTML = "Enter your old password correctly";
                                                                            //document.getElementById("changeUserAccountStatus").style.backgroundColor = "red";
                                                                            //document.getElementById("LoginFormBtn").disabled = true;
                                                                            //document.getElementById("LoginFormBtn").style.backgroundColor = "darkgrey";
                                                                        }
                                                                        if(result === "success"){
                                                                            alert("Update Successful");
                                                                            document.getElementById("newPassfld").value = "";
                                                                            document.getElementById("compareOldPassfld").value = "";
                                                                            document.getElementById("compareOldPassfld").style.backgroundColor = "#d9e8e8";
                                                                            document.getElementById("compareNewPassfld").value = "";
                                                                            document.getElementById("WrongPassStatus").style.display = "none";
                                                                            
                                                                            //getUserAccountNameController
                                                                            $.ajax({
                                                                                method: "POST",
                                                                                url: "getProvUserAccountName",
                                                                                data: "ProviderID="+ProviderID,
                                                                                
                                                                                success: function(result){
                                                                                    document.getElementById("UsrNamefld").value = result;
                                                                                }

                                                                            });
                                                                        }
                                                                    }
                                                                    
                                                                });
                                                                
                                                            });
                                                        });
                                                    </script>
                                               
                                    <script>
                                        
                                        var UsrNamefld = document.getElementById("UsrNamefld");
                                        var oldPassfld = document.getElementById("oldPassfld");
                                        var compareOldPassfld = document.getElementById("compareOldPassfld");
                                        var newPassfld = document.getElementById("newPassfld");
                                        var compareNewPassfld = document.getElementById("compareNewPassfld");
                                        var updateUsrAcntBtn = document.getElementById("updateUsrAcntBtn");
                                        var UpdatePassStatus = document.getElementById("UpdatePassStatus");
                                        
                                        function CheckUpdateUsrAcntBtn(){
                                            
                                            if(UsrNamefld.value === "" || compareOldPassfld.value === "" || newPassfld.value === "" || compareNewPassfld.value === ""){
                                                UpdatePassStatus.style.backgroundColor = "green";
                                                UpdatePassStatus.innerHTML = "Uncompleted Form";
                                                updateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                updateUsrAcntBtn.disabled = true;
                                            }else if(newPassfld.value.length < 8){ //.length is a property not a function (like .length();)
                                                   UpdatePassStatus.style.backgroundColor = "red";
                                                   UpdatePassStatus.innerHTML = "Password Too Short";
                                                   updateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                   updateUsrAcntBtn.disabled = true;
                                               }
                                               else if(newPassfld.value !== compareNewPassfld.value){
                                                   UpdatePassStatus.style.backgroundColor = "red";
                                                   UpdatePassStatus.innerHTML = "New Passwords Don't Match";
                                                   updateUsrAcntBtn.style.backgroundColor = "darkgrey";
                                                   updateUsrAcntBtn.disabled = true;
                                               }else{

                                                   UpdatePassStatus.style.backgroundColor = "green";
                                                   UpdatePassStatus.innerHTML = "OK";
                                                   updateUsrAcntBtn.style.backgroundColor = "darkslateblue";
                                                   updateUsrAcntBtn.disabled = false;
                                               }
                                               
                                            
                                        }
                                        
                                        setInterval(CheckUpdateUsrAcntBtn, 1);
                                        
                                        var UpdateLoginDiv = document.getElementById("UpdateLoginDiv");
                                        
                                        function showUpdateLoginDiv(){
                                            
                                            if(UpdateLoginDiv.style.display === "none"){
                                                //UpdateLoginDiv.style.display = "block";
                                                $("#UpdateLoginDiv").slideDown("fast");
                                                $(".scrolldiv").animate({ scrollTop: $(document).height() }, "slow");
                                            }
                                            else
                                                $("#UpdateLoginDiv").slideUp("fast");
                                                //UpdateLoginDiv.style.display = "none";
                                        }
                                        
                                    </script>
                                    
                                    </div>
                                    </div>
                                </div>
                                </div>
                                </div>
                                 
                                <div id="clientsListDiv" style="display: none;">
                                <div id="serviceslist">
                                    
                                    <!--center><p style="color: tomato; margin: 5px;">Your Clients and Blocked People</p></center-->
                                    <table style="width: 100%; background-color: #3d6999; color: white; padding: 0; border-spacing: 0; margin-bottom: 3px;">
                                        <tbody>
                                            <tr>
                                                <td id="ShowClientsBtn" onclick="toggleshowClients();" style="padding: 10px 5px; cursor: pointer; width: 50%; text-align: center; border-bottom: 2px solid white;"><i style="" class="fa fa-address-book" aria-hidden="true"></i> Your Clients</td>
                                                <td id="ShowBlockedPeopleBtn" onclick="toggleshowBlockedPeople();" style="padding: 10px 5px; cursor: pointer; text-align: center; color: #ccc; border-bottom: #9bb1d0 2px solid;"><i style="" class="fa fa-ban" aria-hidden="true"></i> Blocked People</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                <div>
                                    
                                <div class="scrolldiv" style="min-height: 450px; overflow-y: auto;" id="ProviderClientsDiv">
                                    
                                <%
                                    for(int c = 0; c < ClientsList.size(); c++){
                                        
                                        int ClientID = ClientsList.get(c).getUserID();
                                        String ClientFirstName = ClientsList.get(c).getFirstName().trim();
                                        String ClientMiddleName = ClientsList.get(c).getMiddleName().trim();
                                        String ClientLastName = ClientsList.get(c).getLastName().trim();
                                        String ClientFullName = ClientFirstName + " " + ClientMiddleName + " " + ClientLastName;
                                        String ClientEmail = ClientsList.get(c).getEmail();
                                        String ClientTel = ClientsList.get(c).getPhoneNumber();
                                        String Base64CustPic = "";
                                        
                                try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob profilepic = ClientsList.get(c).getProfilePic(); 
                                    InputStream inputStream = profilepic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                     Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){}
                                        
                                %>
                                
                                <div id="EachClientRow<%=c%>" style="padding: 5px; margin: 15px 0; display: flex; flex-direction: row !important; justify-content: space-between;">
                                    <div style="display: flex; flex-direction: row !important; justify-content: space-between;">
                                    
                            <%
                                if(Base64CustPic == ""){
                            %> 
                            
                                        <img style="border-radius: 100%;" src="icons/icons8-user-filled-50.png" height="50" width="50" alt="icons8-user-filled-50"/>

                                    
                            <%
                                }else{
                            %>
                                        <div style="border-radius: 100%; min-width: 50px; height: 50px; float: left; overflow: hidden;">
                                            <img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
                                        </div>   
                            <%
                                }
                            %>
                                        <div style="margin-left: 15px;">
                                            <p style="font-weight: bolder; color: #334d81;"><%=ClientFullName%></p>
                                            <p style="color: #636363;"><%=ClientTel%></p>
                                            <p style="color: #636363;"><%=ClientEmail%></p>
                                        </div>
                                    </div>
                                    <form name="DeleteThisClient">
                                        <input id="PIDDltClnt<%=c%>" type="hidden" name="ProviderID" value="<%=UserID%>" />
                                        <input id="ClientIDDltClnt<%=c%>" type="hidden" name="EachClientID" value="<%=ClientID%>"/>
                                        <input id="DeleteClientBtn<%=c%>" style="background-color: crimson; border: none; border-radius: 4px; color: white; padding: 10px;" type="button" value="Delete" />
                                    
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#DeleteClientBtn<%=c%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var eachClientID = document.getElementById("ClientIDDltClnt<%=c%>").value;
                                                        var ProviderID = document.getElementById("PIDDltClnt<%=c%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "DeleteClientController",  
                                                        data: "EachClientID="+eachClientID+"&ProviderID="+ProviderID,  
                                                        success: function(result){  
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("EachClientRow<%=c%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                        </script>
                                        
                                    </form>
                                </div>
                            <%}
                                if(ClientsList.size() == 0){
                            %>
                            
                            <p id="EmptyStatus" style="text-align: center; color: darkblue; margin-top: 30px"><i class="fa fa-exclamation-triangle" style="color: yellow;"></i> Your clients list is empty</p>
                            
                            <%}%>
                            </div>
                            <div class="scrolldiv" style="min-height: 450px; overflow-y: auto; display: none !important;" id="BlockedPeopleDiv">
                                
                                <%
                                    boolean isBlockedEmpty = true;
                                    
                                    int eachBlocked = 0;
                                    
                                     try{
                                        Class.forName(Driver);
                                        Connection BlckCustConn = DriverManager.getConnection(Url, user, password);
                                        String BlckCustString = "Select top 10 * from QueueServiceProviders.BlockedCustomers where ProviderId = ? order by BlockedID desc";
                                        PreparedStatement BlckCustPst = BlckCustConn.prepareStatement(BlckCustString);
                                        BlckCustPst.setInt(1, UserID);

                                        ResultSet BlckCustRec = BlckCustPst.executeQuery();

                                        while(BlckCustRec.next()){
                                            
                                            isBlockedEmpty = false;
                                            eachBlocked++;
                                            
                                            String CustFullName = "";
                                            String CustEmail = "";
                                            String CustMobile = "";
                                            String Base64CustPic = "";
                                            
                                            int CustomerID = BlckCustRec.getInt("CustomerID");
                                            int BlockedID = BlckCustRec.getInt("BlockedID");
                                            
                                            try{
                                                Class.forName(Driver);
                                                Connection CustConn = DriverManager.getConnection(Url, user, password);
                                                String CustStrig = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                                                PreparedStatement CustPst = CustConn.prepareStatement(CustStrig);
                                                CustPst.setInt(1, CustomerID);
                                                
                                                ResultSet CustRec = CustPst.executeQuery();
                                                
                                                while(CustRec.next()){
                                                    
                                                    String firstName = CustRec.getString("First_Name").trim();
                                                    String middleName = CustRec.getString("Middle_Name").trim();
                                                    String lastName = CustRec.getString("Last_Name").trim();
                                                    CustFullName = firstName + " " + middleName + " " + lastName;
                                                    CustEmail = CustRec.getString("Email").trim();
                                                    CustMobile = CustRec.getString("Phone_Number").trim();
                                                    
                                                    try{    
                                                        //put this in a try catch block for incase getProfilePicture returns nothing
                                                        Blob profilepic = CustRec.getBlob("Profile_Pic"); 
                                                        InputStream inputStream = profilepic.getBinaryStream();
                                                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                                        byte[] buffer = new byte[4096];
                                                        int bytesRead = -1;

                                                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                            outputStream.write(buffer, 0, bytesRead);
                                                        }

                                                        byte[] imageBytes = outputStream.toByteArray();

                                                         Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                                                    }
                                                    catch(Exception e){}
                                                    
                                                }
                                            }catch(Exception e){
                                                e.printStackTrace();
                                            }
                                %>
                                
                                <div id="ClientsRow<%=eachBlocked%>" style=" padding: 5px; display: flex; flex-direction: row !important; justify-content: space-between;  margin: 15px 0;">
                                         
                                    <div style="display: flex; flex-direction: row !important;">
                            <%
                                if(Base64CustPic == ""){
                            %> 
                            
                                <img style="border-radius: 5px; float: left; border-radius: 100%;" src="icons/icons8-user-filled-50.png" height="50" width="50" alt="icons8-user-filled-50"/>
    
                            <%
                                }else{
                            %>
                            
                                <div style="border-radius: 100%; min-width: 50px; height: 50px; overflow: hidden;">
                                    <img style="width: 50px; height: auto; margin-bottom: 0;  background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>"/>
                                </div>
                                    
                            <%
                                }
                            %>
                                    <div style="margin-left: 15px;">
                                        <p style="font-weight: bolder; color: #334d81;"><%=CustFullName%></p>
                                        <p style="color: #636363;"><%=CustMobile%></p>
                                        <p style="color: #636363;"><%=CustEmail%></p>
                                    </div>
                                    
                                    </div>
                                    <form name="UnblockPerson" >
                                        <input id="BlockedID<%=eachBlocked%>" type="hidden" name="BlockedID" value="<%=BlockedID%>" />
                                        <input id="UnblockCleintBtn<%=eachBlocked%>" style="background-color: crimson; border: none; border-radius: 4px; color: white; padding: 10px;" type="button" value="Unblock" name="Unblock" />
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#UnblockCleintBtn<%=eachBlocked%>').click(function(event) {  
                                                        document.getElementById('ProviderPageLoader').style.display = 'block';
                                                        var BlockedID = document.getElementById("BlockedID<%=eachBlocked%>").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "UnblockCustomerController",  
                                                        data: "BlockedID="+BlockedID,  
                                                        success: function(result){  
                                                          alert(result);
                                                          document.getElementById('ProviderPageLoader').style.display = 'none';
                                                          document.getElementById("ClientsRow<%=eachBlocked%>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                        </script>
                                    </form>
                                </div>
                                        
                                <%
                                        }
                                    }
                                    catch(Exception e){
                                        e.printStackTrace();
                                    }

                                    if(isBlockedEmpty){
                                %>
                                
                                <p id="NoBlockedClientStatus" style="color: darkblue; text-align: center; margin-top: 30px;"><i class="fa fa-exclamation-triangle" style="color: yellow;"></i> You haven't blocked any person</p>
                                
                                <%}%>
                            </div>
                            </div>
                                </div>
                                </div>
                                </div>
                                 </td> 
                        </tr>
                    </tbody>
                    </table>
                                     
                </div></center>
                
                <script>
                    function LogoutMethod(){
                        document.getElementById('ProviderPageLoader').style.display = 'block';
                        window.localStorage.removeItem("ProvQueueUserName");
                        window.localStorage.removeItem("ProvQueueUserPassword");
                    }
                </script>
                            
                <form style="display: none;" class="middleScreenWidthLogoutBtn" action = "LogoutController" name="LogoutForm" method="POST">
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <center><input style="width: 97%;" type="submit" value="Logout" class="button" onclick="LogoutMethod();"/></center>
                </form>
                
                </div>
                        
    </div>  
       
        <!--div id="footer">
            <p>AriesLab &copy;2019</p>
        </div-->
        <div style='background-color: #212c2c; display: block; position: relative; z-index: 100;' id="footer">
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
    </script>
    <script src="scripts/script.js"></script>
    <script src="ServiceProviderPageAddCardBizScripts.js"></script>
    <script src="scripts/checkAppointmentDateUpdate.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    <script src="scripts/CollectAddressInfo.js"></script>
    <script src="scripts/stripe-scripts.js"></script>
    
</html>
