<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.sql.Statement"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>

<html>
    
    <head>
        
        <script>
            document.cookie = "SameSite=None";
            document.cookie = "SameSite=None; Secure";
            //alert(document.cookie);
        </script>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <!--script src="https://code.jquery.com/jquery-1.12.4.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        <!--script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
        
        <script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
        
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
        
        <title>Queue</title>
        
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
    </head>
    <script>
        var CustPassFlag = "";
        var ProvPassFlag = "";
        if((window.localStorage.getItem("QueueUserName") === null || window.localStorage.getItem("QueueUserPassword") === null) 
                || (window.localStorage.getItem("QueueUserName") === '' || window.localStorage.getItem("QueueUserPassword") === '')){
            //do nothing
        }else{
            //alert(window.localStorage.getItem("QueueUserName"));
            var tempUserName = window.localStorage.getItem("QueueUserName");
            var tempUserPassword = window.localStorage.getItem("QueueUserPassword");
            (function(){
                //alert("here");
                document.location.href="LoginControllerMainRedirect?username="+tempUserName+"&password="+tempUserPassword;
                //window.location.replace("LoginControllerMain?username="+tempUserName+"&password="+tempUserPassword);
                return false;
            })();
        } 
        
        if((window.localStorage.getItem("ProvQueueUserName") === null || window.localStorage.getItem("ProvQueueUserPassword") === null) 
                || (window.localStorage.getItem("ProvQueueUserName") === '' || window.localStorage.getItem("ProvQueueUserPassword") === '')){
            //do nothing
        }else{
            var tempProvUserName = window.localStorage.getItem("ProvQueueUserName");
            var tempProvUserPassword = window.localStorage.getItem("ProvQueueUserPassword");
            (function(){
                document.location.href="LoginControllerMainRedirect?username="+tempProvUserName+"&password="+tempProvUserPassword;
                //window.location.replace("LoginControllerMain?username="+tempProvUserName+"&password="+tempProvUserPassword);
                return false;
            })();
        }
    </script>
    
    <%
        
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
         
         
        //resetting ResendAppointmentData data feilds
        ResendAppointmentData.CustomerID = "";
        ResendAppointmentData.ProviderID = "";
        ResendAppointmentData.SelectedServices = "";
        ResendAppointmentData.AppointmentDate = "";
        ResendAppointmentData.AppointmentTime = "";
        ResendAppointmentData.PaymentMethod = "";
        ResendAppointmentData.ServicesCost = "";
        ResendAppointmentData.CreditCardNumber = "";
        
        String Message = "You are not logged in";
        
        //if(UserAccount.AccountType.equals("CustomerAccount"))
            //response.sendRedirect("ProviderCustomerPage.jsp");
        
        //if(UserAccount.AccountType.equals("BusinessAccount"))
            //response.sendRedirect("ServiceProviderPage.jsp");
            
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
          
        String url = config.getInitParameter("databaseUrl");
        String Driver =  config.getInitParameter("databaseDriver");
        String User = config.getInitParameter("user");
        String Password = config.getInitParameter("password");
        
        String GlobalIDList = "";
        
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
            details.initializeDBParams(Driver, url, User, Password);
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
        
    
    <body onload="document.getElementById('HomePageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
        <div id='JumbotromBg' style="width: 100vw; height: 800px; position: fixed; top: 0px; z-index: -1; background-color: white;"></div>
        
        <div id="HomePageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <script>
            
            var GoogleReturnedZipCode;
            var GoogleReturnedCity;
            var GoogleReturnedTown;
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
                    
                    //alert(lat);
                    //alert(long);
                    $.ajax({
                        type: "GET",
                        data: 'latlng=' + lat + ',' + long + '&sensor=true&key=AIzaSyAoltHbe0FsMkNbMCAbY5dRYBjxwkdSVQQ',
                        url: 'https://maps.googleapis.com/maps/api/geocode/json',
                        success: function(result){

                            //GoogleReturnedZipCode = result.results[0].address_components[8].long_name;
                            GoogleReturnedCity = result.results[0].address_components[4].long_name;
                            GoogleReturnedTown = result.results[0].address_components[3].long_name;

                            let AddressParts = result.results[0].formatted_address.split(",");
                            let CityZipCodeParts = AddressParts[2].split(" ");
                            let city = CityZipCodeParts[1].trim();
                            GoogleReturnedTown = AddressParts[1].trim();
                            if(GoogleReturnedTown === "The Bronx")
                                GoogleReturnedTown = "Bronx";
                            GoogleReturnedCity = StateAbbrev[city].trim();
                            GoogleReturnedZipCode = CityZipCodeParts[2].trim();
                            addLocationToWebContext();

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
                      }
                  });
                  
            }
            
        </script>
        
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
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 5px 7px; font-size: 15px;" 
                           onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Search" />
                </form>
            </div>
            
            <div style="display: flex;">
                <ul style="margin-right: 5px;">
                    <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href="LogInPage.jsp">
                        <li style='cursor: pointer; background-color: #334d81;' class="active">
                        <i class="fa fa-home"></i>
                        Your Dashboard</li></a>
                    <li style='cursor: pointer;'>
                        <i class="fa fa-calendar"></i>
                        Calender</li>
                    <li style='cursor: pointer;'>
                        <i class="fa fa-cog"></i>
                        Account</li>
                </ul>
            
                <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href='NewsUpadtesPage.jsp'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-newspaper-o"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">News</span></p>
                    </div>
                </a>
                
                <a href="#" id='ExtraDrpDwnBtn'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-home"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">Home</span></p>
                    </div>
                </a>
                </div>
            </div>
            
        <div id="container">
            
            <div id="miniNav" style="display: none;">
                <div style="text-align: center">
                    <ul id="miniNavIcons" style="float: left;">
                        <li onclick="scrollToTop()" style=""><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="padding: 5px;" placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                            <input style="" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Search" />
                    </form>
                </div>
            </div>
            
        <div class="LandingPageheader" style='display: block;' id="header">
            
            <div style="text-align: center;"><p> </p>
            <image id="DashboardLogo" src="QueueLogo.png" style="margin-top: 5px;"/>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p>
            </div>
        </div>
        <div id="main_body_flex">   
            <div id="Extras" style="float: none;">
            <div id="ExtrasInnerContainer">
                <%
                    int newsItems = 0;
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select top 10 * from QueueServiceProviders.MessageUpdates where ProvID in "+GlobalIDList+" and VisibleTo like 'Public%' order by MsgID desc";
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
                                        String HouseNumber = ProvLocRec.getString("House_Number").trim();
                                        String Street = ProvLocRec.getString("Street_Name").trim();
                                        String Town = ProvLocRec.getString("Town").trim();
                                        String City = ProvLocRec.getString("City").trim();
                                        String ZipCode = ProvLocRec.getString("Zipcode").trim();
                                        
                                        ProvAddress = HouseNumber + " " + Street + ", " + Town + ", " + City + " " + ZipCode;
                                    }
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                %>
                
                <table  id="ExtrasTab" cellspacing="0 10px">
                        <tbody>
                            <tr style="background-color: #eeeeee;">
                                <td>
                                    <div id="ProvMsgBxOne">
                                        
                                        <div style='font-weight: bolder;'>
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
                                                <p style='color: red; margin: 10px;'><%=ProvCompany%></p>
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
            
            </div>
            
        <div class="DashboardContent" style="position: initial;" id="QueueJspContent">
            
            <div id="nav" style='display: block;'>
                <center>
                    <div class =" SearchObject" style="margin-bottom: 15px; margin-top: 20px; padding-top: 10px; background: none !important;">
                        
                        <p style="color: #3d6999; text-align: center; margin: 10px 0; font-weight: bolder;">Search By Name</p>
                        
                        <form style="background-color: #9bb1d0;" name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="border-top-left-radius: 4px !important; border-bottom-left-radius: 4px !important; background-color: #d9e8e8 !important;" placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" style="border-top-right-radius: 4px !important; border-bottom-right-radius: 4px !important; background-color: #06adad !important;
                                                                                                                                                                                                        color: white !important; border: 1px solid #3d6999 !important;" type="submit" value="Search" name="SearchBtn" onclick="document.getElementById('HomePageLoader').style.display = 'block';"/>
                        </form> 

                    </div>
                </center>
                
                <!--h4 style="padding: 5px 0;">Search By Location</h4-->
                
                <div id="LocSearchDiv" style="margin-top: 10px; margin-bottom: 5px;">
                    
                <center><form id="DashboardLocationSearchForm" action="ByAddressSearchResult.jsp" method="POST" style="padding-bottom: 10px">
                    <p style="font-weight: bolder; color: #3d6999; margin-top: 10px; margin-bottom: 20px;">
                        <i style="margin-right: 5px;" class="fa fa-map-marker" aria-hidden="true"></i>
                        Find services at location below</p>
                    <p class="LocSearchP">City: <input id="city4Search" style="width: 80%; background-color: #d9e8e8;" type="text" name="city4Search" placeholder="" value=""/></p> 
                    <p class="LocSearchP">Town: <input id="town4Search" style=" width: 35%; background-color: #d9e8e8;" type="text" name="town4Search" value=""/> Zip: <input id="zcode4Search" style="width: 19%; background-color: #d9e8e8;" type="text" name="zcode4Search" value="" /></p>
                    <script>
                        var setLocation = setInterval(
                                function(){
                                    
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
                    <p style='color: #3d6999; margin: 10px;'>Filter search by</p>
                    <div id="DashboardLocationSearchFilter" class='scrolldiv' style='margin: auto; overflow-x: auto; color: #ccc; background-color: #3d6999; border-radius: 4px; padding: 10px 0;  width: 95%;'>
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
                    <p><input onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" style="font-weight: bolder; background-color: #626b9e; color: white; padding: 10px; border-radius: 4px; width: 95%;" value="Search" onclick="document.getElementById('HomePageLoader').style.display = 'block';"/></p>
                    </form></center>
                </div>
                
            </div>
            
            <div id="main" class="Main" style="padding-top: 5px;">
               
            </div>
                
        </div>
                
        <div id="newbusiness" style="position: initial;">
            
            <p id='addBizTxt' style="text-align: center; font-size: 20px;  margin-bottom: 10px; margin-top: -10px;">
                <b>Add your business or create customer account</b>
            </p>
            
            <div id="businessdetails" >
                <div id='QShowNews22' style='width: fit-content; bottom: 5px; margin-left: 4px; position: fixed; background-color: #3d6999; padding: 5px 9px; border-radius: 50px;
                 box-shadow: 0 0 5px 1px black;'>
                    <div style="text-align: center;"><a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href="NewsUpadtesPage.jsp"><p  
                        style='color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0; width:'>
                            <i style='color: white; font-size: 25px;' class="fa fa-newspaper-o"></i>
                    </p>
                    <p style='font-size: 15px; color: white; margin-top: -2px;'>News</p>
                    </a></div>
                </div>
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    <table border="0">
                        <tbody>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                        <input id="signUpFirtNameFld" placeholder="Enter first name here" type="text" name="firstName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                        <input id="sigUpLastNameFld" placeholder="Enter last name here" type="text" name="lastName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                        <input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" id="signUpTelFld" placeholder="Enter mobile here" type="text" name="telNumber" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                        <input id="signUpEmailFld" placeholder="Enter email here" type="text" name="email" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <script>
                        var TelFld = document.getElementById("signUpTelFld");
                        
                        function numberFunc(){
                            
                            var number = parseInt((TelFld.value.substring(TelFld.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFld.value = TelFld.value.substring(0, (TelFld.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFunc, 1);
                        
                        function checkMiddleNumber(){
                            
                            for(var i = 0; i < TelFld.value.length; i++){

                                var middleString = TelFld.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFld.value = TelFld.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <p style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; text-align: center;"><b>Login to view and manage your spots</b></p>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="LoginPageUserNameFld" placeholder="enter username here" type="text" name="username" value="" size="30"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="enter password here" type="password" name="password" value="" size="20"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
            
                </div>
        </div>
            
            <div id="CosmeticsSection" style='padding-top: 0;'>
                <div style="background-color: #212c2c; padding: 0 10px; margin-bottom: 40px; padding-top: 5px; padding-bottom: 30px;">
                    <h1 style='color: white; font-size: 19px; font-family: serif; padding: 20px 0;'>Popular Services</h1>
                    
                    <div id="PopularSvcDiv" style="display: flex; flex-direction: row; justify-content: space-between; max-width: 700px; margin: auto;  padding-left: 10px; padding-right: 10px;">
                        
                    </div>
                    <style>
                        .eachPopularService{
                            cursor: pointer;
                        }
                        @media only screen and (max-width: 700px){
                            .dontShowMobile{
                                display: none;
                            }
                        }
                    </style>
                    <p style='margin: auto; margin-bottom: 20px; margin-top: 30px; display: block; border-bottom: #374949 1px solid; max-width: 700px;'></p>
                    <h1 style='color: white; font-size: 19px; font-family: serif; padding: 10px 0;'>Suggested Places</h1>
                    
                    <div style="max-width: 1000px; margin: auto; text-align: center;">
                        <div style="width: 85%; margin: auto;" class="recommendedProvidersDiv">
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
                                        Connection coverConn = DriverManager.getConnection(url, User, Password);
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
                            <a href='EachSelectedProvider.jsp?UserID=<%=RPID%>' onclick="document.getElementById('HomePageLoader').style.display = 'block';">
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
                                    <p style='color: #ffe96b; font-weight: bolder;'><%=RBizName%></p>
                                    <p style="color: #ccc; margin-top: -3px;">- <%=RBizType%> -</p>
                                </div>
                            </a>
                            <%}%>
                            
                          </div>
                          <%
                            if(providersList.size() == 0){
                          %>
                            <p style='color: white;'><i class='fa fa-exclamation-triangle' style='color: yellow;'></i> Oops! We have no recommendations at this time</p>
                          <% }
                          %>
                    </div>
                </div>
                
                <div>
                    <h1 style='color: orange; font-size: 22px; font-family: serif;'>What is Queue Appointments</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto;'>
                        Queue Appointments is a website and app that lets you find medical and beauty places near your location to book appointments.
                        It also provides features for the businesses to post news updates with pictures to keep you informed about their services
                        and products.
                    </p>
                    <div id="BkApptOnlnInfoDiv" class='CosmeSectFlex'>
                        
                    </div>
                    
                    <h1 style='color: orange; font-size: 22px; font-family: serif; margin-top: 40px;'>We have the best services in your area</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto;'>
                        Your ratings, reviews and feedbacks mean a lot to us. We are constantly watching how well businesses serve their customers in order to ensure that only the best medical and beauty places operate on 
                        our platform. Queue Appointments will eventually disassociate with badly rated businesses.
                    </p>
                    
                    <div id="RvwGrowingCmntCosmeDiv" class='CosmeSectFlex' style='margin: auto; margin-top: 20px; max-width: 1000px;'>
                        
                    </div>
                </div>
            </div>
                
            <div style='background-color: #212c2c; display: block;' id="footer">
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
    <script defer>
        $(document).ready(()=>{
            document.getElementById("main").innerHTML = 
                    `<h4 style="padding: 5px 0; margin-bottom: 5px; color: #3d6999; margin-top: 5px;">Search By Category</h4>

                     <div id="firstSetProvIcons">
                    <center><table id="providericons">
                            <tbody>
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectBusiness.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectMedicalCenter.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectDentist.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                                </a></center></td>
                            </tr>
                            <tr>
                                <td><center><a href="QueueSelectPodiatry.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="PodiatrySelect">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectPhisicalTherapy.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectMassage.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="MassageSelect">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                                </a></center></td>
                            </tr>
                            <tr>
                                <td><center><a href="QueueSelectTattoo.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectMedAesthet.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="MedEsthSelect">Medical Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                                </a></center></td>
                                <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusiness.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
                                </a></center></td>
                            </tr>
                        </tbody>
                        </table></center>

                        <center><p onclick="showSecondSetProvIcons()" style="margin-top: 5px; cursor: pointer; border-radius: 4px;">
                        <img src="icons/nextIcon.png" alt="" style="width: 35px; height: 35px"/>
                        </p></center>

                    </div>

                    <div id="secondSetProvIcons" style="display: none;">
                        <center><table id="providericons">
                            <tbody>
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectBrowsLashes.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="EyebrowsSelect">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                                </a></center></td>
                                 <td style="width: 33.3%;"><center><a href="QueueSelectDietician.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="DieticianSelect">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                                </a></center></td>
                                <td style="width: 33.3%;"><center><a href="QueueSelectPetServe.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="PetServicesSelect">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                                </a></center></td>
                            </tr>
                            <tr>
                                <td><center><a href="QueueSelectHomeServe.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectPiercing.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectHolisticMed.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-mortar-and-pestle-100.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                                </a></center></td>
                            <tr>
                                <td><center><a href="QueueSelectNailSalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectPersonalTrainer.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                                </a></center></td>
                                <td><center><a href="QueueSelectHairSalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
                                </a></center></td>
                            </tr>
                        </tbody>
                        </table></center>

                        <center><p style="margin-bottom: 7px; margin-top: 10px;"><span onclick="showFirstSetProvIcons()" style="padding: 5px; width: 50px; cursor: pointer; border-radius: 4px;">
                                <img src="icons/previousIcon.png" alt="" style="width: 35px; height: 35px"/>
                                </span>
                                <span onclick="showThirdSetProvIcons()" style="padding: 5px; padding-left: 17px; padding-right: 18px; cursor: pointer; border-radius: 4px;">
                                    <img src="icons/nextIcon.png" alt="" style="width: 35px; height: 35px"/>
                                </span></p></center>

                    </div>

                    <div id="thirdSetProvIcons" style="display: none;">
                            <center><table id="providericons">
                            <tbody>
                                <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectDaySpa.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                                </a></center></td>
                                <td style="width: 33.3%;"><center><a href="QueueSelectHairRemoval.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                                </a></center></td>
                                <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                                </a></center></td>
                                </tr>
                                <tr>
                                    <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtist.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                                    </a></center></td>
                                </tr>

                        </tbody>
                        </table></center>

                        <center><p onclick="showSecondFromThirdProvIcons()" style="padding: 5px; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">
                                <img src="icons/previousIcon.png" alt="" style="width: 35px; height: 35px"/>
                            </p></center>

                    </div>`;

            document.getElementById("PopularSvcDiv").innerHTML = 
                    `<a href="QueueSelectMedicalCenter.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-medical-doctor-100.png" style='width: 40px; height: 40px;'></p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Medical Center</p>
                                </div>
                            </a>
                            <a href="QueueSelectBarberBusiness.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-barber-pole-100.png" style='width: 40px; height: 40px;'></p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Barber Shop</p>
                                </div>
                            </a>
                            <a href="QueueSelectNailSalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-nails-96.png" style='width: 40px; height: 40px;'><p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Nail Salon</p>
                                </div>
                            </a>
                            <a href="QueueSelectDaySpa.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-spa-100.png" style='width: 40px; height: 40px;'></p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Day Spa</p>
                                </div>
                            </a>
                            <a class="dontShowMobile" href="QueueSelectBeautySalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-cosmetic-brush-96.png" style='width: 40px; height: 40px;'></p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Beauty Salon</p>
                                </div>
                            </a>
                            <a class="dontShowMobile" href="QueueSelectHairSalon.jsp" onclick="document.getElementById('HomePageLoader').style.display = 'block';">
                                <div class="eachPopularService">
                                    <p style="text-align: center;"><img src="icons/icons8-hair-dryer-100.png" style='width: 40px; height: 40px;'></p>
                                    <p style="text-align: center; color: #ccc; font-size: 12px;">Hair Salon</p>
                                </div>
                            </a>`;

            document.getElementById("BkApptOnlnInfoDiv").innerHTML =
                    `<div class='eachCSecFlex'>
                                <h1>Book your doctor's appointment online</h1>
                                <div style='margin: auto; width: 100%; max-width: 400px; height: 300px;
                                     background-image: url("./DocAppt.jpg"); background-size: cover; background-position: right;
                                     display: flex; justify-content: flex-end; flex-direction: column;'>
                                    <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>It's a fully automated platform for booking appointments. Your doctor's appointment has never been easier.</p>
                                </div>
                            </div>
                            <div class='eachCSecFlex marginUp20'>
                                <h1>Find barber shops near you</h1>
                                <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; 
                                     background-image: url("./BarberAppt.jpg"); background-size: cover; background-position: right;
                                     display: flex; justify-content: flex-end; flex-direction: column;'>
                                    <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>Our recommendations algorithms make it easier for you to find the best barber shops in town</p>
                                </div>
                            </div>
                            <div class='eachCSecFlex marginUp20'>
                                <h1>Find your beauty time online</h1>
                                <div style='margin: auto; width: 100%; max-width: 400px; height: 300px; 
                                     background-image: url("./SpaAppt.jpg"); background-size: cover; background-position: right;
                                     display: flex; justify-content: flex-end; flex-direction: column;'>
                                    <p style='background-color: rgba(0,0,0, 0.3); color: #ffe96b; padding: 5px;'>No more waiting on a line. Your service provider has a queue. Find your spot here.</p>
                                </div>
                            </div>`;

            document.getElementById("RvwGrowingCmntCosmeDiv").innerHTML =
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
        });
    </script>
    
    <script>
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
              ]
              });
        });
    </script>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
