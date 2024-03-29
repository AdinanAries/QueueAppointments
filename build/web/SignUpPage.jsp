<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>

<!DOCTYPE html>

<html>
    
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        
        <!-- Zebra Dialog CSS -->
        <link rel="stylesheet" href="dialog_dist/css/flat/zebra_dialog.min.css" type="text/css">

        <!-- Zebra Dialog JS -->
        <script src="dialog_dist/zebra_dialog.min.js"></script>
       
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
         
    </head>
    
    <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String Driver = "";
        String User = "";
        String url = "";
        String Password = "";
        
        try{
            Driver = config.getInitParameter("databaseDriver");
            url = config.getInitParameter("databaseUrl");
            User = config.getInitParameter("user");
            Password = config.getInitParameter("password");
        }catch(Exception e){
            response.sendRedirect("Queue.jsp");
        }
        
        String fName = "";
        String lName = "";
        String telNumber = "";
        String email = "";
        
        try{
            
            fName = request.getParameter("firstName");
            lName = request.getParameter("lastName");
            telNumber = request.getParameter("telNumber");
            email = request.getParameter("email");
            
        }
        catch(Exception e){
            
        }
        
        if(fName == null || fName.equalsIgnoreCase("enter your first name")){
            fName = "";
        }
        if(lName == null || lName.equalsIgnoreCase("enter your last name")){
            lName = "";
        }
        if(telNumber == null || telNumber.equalsIgnoreCase("enter your telephone/mobile number here")){
            telNumber = "";
        }
        if(email == null || email.equalsIgnoreCase("enter your email address here")){
            email = "";
        }
        
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
        <script>
            
            var GoogleReturnedStreetNo;
            var GoogleReturnedStreetName;
            var GoogleReturnedZipCode;
            var GoogleReturnedCity;
            var GoogleReturnedTown;
            var GoogleReturnedCountry;
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
            /*if ("geolocation" in navigator) {
                alert("I'm you location navigator");
            } else {
                alert("You don't have any location navigator");
            }*/
            
            function GetGoogleMapsJSON(lat, long){
                    
                    //alert(lat);
                    //alert(long);
                    $.ajax({
                        type: "GET",
                        data: 'latlng=' + lat + ',' + long + '&sensor=true&key=AIzaSyAoltHbe0FsMkNbMCAbY5dRYBjxwkdSVQQ',
                        url: 'https://maps.googleapis.com/maps/api/geocode/json',
                        success: function(result){

                            //GoogleReturnedZipCode = result.results[0].address_components[8].long_name;
                            //GoogleReturnedCity = result.results[0].address_components[4].long_name;
                            //GoogleReturnedTown = result.results[0].address_components[3].long_name;
                            
                            let AddressParts = result.results[0].formatted_address.split(",");
                            let CityZipCodeParts = AddressParts[2].split(" ");
                            let StreetParts = AddressParts[0].split(" ");
                            //alert(result.results[0].formatted_address);
                            //alert(AddressParts[0]);
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
                            /*alert(result.results[0].address_components[5].long_name);
                            alert(result.results[0].address_components[4].long_name);
                            alert(result.results[0].address_components[3].long_name);
                            alert(result.results[0].address_components[2].long_name);
                            alert(result.results[0].address_components[1].long_name);
                            alert(result.results[0].address_components[0].long_name);*/

                        }
                    });
                    
                    /*var mapLink = document.getElementById("mapLink");
                    mapLink.href = "";
                    mapLink.href = 'https://www.openstreetmap.org/#map=18/'+lat+'/'+long;*/
                    
                }

            function showPosition(position){
                GetGoogleMapsJSON(position.coords.latitude, position.coords.longitude);
                GoogleReached = true;
            }
            
            function locationErrorHandling(error){
                //alert("ERROR(" + error.code + "): " + error.message);
                //Will add error handling here;
            }
            
            var locationOptions = {
                
                enableHighAccuracy: true, 
                maximumAge        : 30000, 
                timeout           : 27000
            
            };
            
            function getLocation(){
                if (navigator.geolocation){
                    
                  var watchID = navigator.geolocation.watchPosition(showPosition, locationErrorHandling, locationOptions);
                  //navigator.geolocation.getCurrentPosition(showPosition, locationErrorHandling, locationOptions);
                  //alert(watchID);
                  //navigator.geolocation.clearWatch(watchID);

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
                      url: "addLocationDataToWebContext",
                      success: function(result){
                          //alert("Location added!");
                      }
                  });
                  
            }
            
        </script>
        
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
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
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 5px 7px; font-size: 15px;" 
                           onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Search" />
                </form>
            </div>
            
            <div style="display: flex;">
                <ul style="margin-right: 5px;">
                    <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href="Queue.jsp">
                        <li style='cursor: pointer; background-color: #334d81;' class="active"><!--img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/-->
                        <i class="fa fa-home"></i>
                        Home</li></a>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/-->
                        <i class="fa fa-calendar"></i>
                        Calender</li>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/-->
                        <i class="fa fa-cog"></i>
                        Account</li>
                </ul>
            
                <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href='NewsUpadtesPage.jsp'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-newspaper-o"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">News</span></p>
                    </div>
                </a>
                
                <a href="Queue.jsp" id='ExtraDrpDwnBtn'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-home"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">Home</span></p>
                    </div>
                </a>
                
                <!--div style="">
                        <center><div style="text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                           <i style="font-size: 34px; color: darkgrey;" class="fa fa-user-circle" aria-hidden="true"></i> 
                        </div--></center>
                </div>
            </div>
        
        <div id="container">
            
        <div id="header" style='display: block;'>
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="LoginPageToQueue" style=" color: black;"><image class="mobileLogo" src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
            
        </div>
         
        <div id="main_body_flex">
            
            <div id="Extras">
            
            <div id="ExtrasInnerContainer">
                <%
                    int newsItems = 0;
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
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
                                    Connection ProvConn = DriverManager.getConnection(url, User, Password);
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
                
                <a href="./NewsUpadtesPage.jsp">
                    <p style="padding: 10px; color: #44484a; font-weight: bolder; margin: auto; width: fit-content;">
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
            
                <div class='eachCSecFlex marginUp20' style='margin-left: -10px; width: 100%; margin-top: 10px;'>
                    <h1>Our businesses keep you posted</h1>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                           display: flex; justify-content: flex-end; flex-direction: column;'>
                        <p style='text-align: center;'><img src='NewsPic.png'  style='width: 80px; height: 80px'/></p>
                        <p style='color: #37a0f5; padding: 5px;'>Our integrated news feed feature lets businesses post regular ads to keep you informed</p>
                    </div>
                </div>
            
            </div>
               
            <div id="content">
            
            <div id="nav">
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 10px;">
                        
                <center><h2 id="SignUpHereTxt" style="margin-bottom: 20px;">Sign-up Here</h2></center>
                
                <center><div id="accountTypeOptions">
                <center><h3 style="color: darkblue; margin-bottom: 10px; ">Choose account type</h3></center>
                <table>
                    <tbody>
                        <tr>
                            <td id="ShowBizForm" onclick="toggleHideAddBusinessForm()" style="padding-right: 45px; cursor: pointer;">
                        <center>
                            <!--img src="icons/icons8-business-50.png" width="50" height="50" alt="icons8-business-50"/-->
                            <i class='fa fa-address-book' style='font-size:48px;color: #334d81;'></i><p>Business</p>
                                </center></td>
                        
                            <td id="ShowCustForm" onclick="toggleHideAddCustomerForm()" style="padding-left: 45px; cursor: pointer;" >
                            <center>
                                <!--img src="icons/icons8-user-50 (1).png" width="50" height="50" alt="icons8-user-50 (1)"/-->
                                <i class="fa fa-users" style='font-size:48px;color: #334d81;'></i><p>Customer</p>

                                </center></td>
                        </tr>
                    </tbody>
                </table>
                </div><center>
                    
                <div class="scrolldiv" style="overflow-y: auto; width: auto;">
                    
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                
                <center><h3 style="color: white; margin-bottom: 15px; background-color: red;"></h3></center>
                
                <style>
                    form input, form select{
                        padding: 10px !important;
                    }
                    
                    form table{
                        box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33);
                        background-color: #9bb1d0; 
                        border-radius: 4px; 
                        width: fit-content; 
                        padding: 20px; 
                        min-height: 300px; 
                        max-width: 300px;
                    }
                    form tr td p{
                        margin: 10px 0;
                    }
                </style>
                
                <form style="display: none;" name="customerForm" id="customerForm" action="CustomoerSignUpController" method="POST">
                    <p style="color: darkblue; margin: 15px 0; font-weight: bolder;">Add Customer Account<p>
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input type="text" id="firstName" name="firstName" value="<%=fName%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr style='display: none;'>
                                    <td><p>Middle Name</p><input type="text" id="middleName" name="middleName" value=" " size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input type="text" id="lastName" name="lastName" value="<%=lName%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <p id='CustEmailStatus' style='color: white; display: none; text-align: center; margin: 10px 0;'></p>
                                        <p>Email</p><input onchange='CustSetVerifyFalse();' onfocusout='CustCloseEmailVerify();' onfocus='CustShowEmailVerify();' type="text" id="visibleEmail" name="email" value="<%=email%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        <input id='email' type='hidden' value=''/>
                                        <div id='CustEmailVeriDiv' style='display: none; background-color: #3d6999; padding: 10px; margin: 5px;'>
                                            <div id='CustsendVerifyDiv'>
                                                <center><input id='CustSendverifyEmailBtn' type='button' value='1. Click to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            </div>
                                            <div id='CustverifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='CustvCodeStatus' style='padding-left: 5px; color: white; max-width: 250px; margin: 10px 0;'><span style="color: #ffc700; font-weight: bolder;">2.</span> We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input id="CustEmailConfirm" placeholder="Enter 6-digit code here" type="text" style="background-color: #d9e8e8; border-radius: 4px;" /></p>
                                            </div>
                                            <center><input id='CustverifyEmailBtn' onclick="CustVerifyCode();" type='button' value='3. Click to verify entered code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            <script>
                                                
                                                var CustEmailVerified = false;
                                                var CustPageJustLoaded = true;
                                                
                                                if(document.getElementById("visibleEmail").value !== ""){
                                                    //Execute this code when page loads with information from prio page
                                                    CustPageJustLoaded = false;
                                                }
                                                
                                                setInterval(function(){
                                                    
                                                    if(!CustPageJustLoaded){
                                                        
                                                        if(CustEmailVerified){
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            //document.getElementById("CustEmailStatus").style.backgroundColor = "green";
                                                            document.getElementById("CustEmailStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Your email has been verified";
                                                            document.getElementById("email").value = document.getElementById("visibleEmail").value;
                                                            document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("CustEmailStatus").style.display = "block";
                                                            //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                            
                                                            if(document.getElementById("CustEmailVeriDiv").style.display === "block"){
                                                                if(document.getElementById("visibleEmail").value === "")
                                                                    document.getElementById("CustEmailStatus").innerHTML = "";
                                                                else
                                                                    document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please verify your email";
                                                            }else{
                                                                if(document.getElementById("visibleEmail").value === "")
                                                                    document.getElementById("CustEmailStatus").innerHTML = "";
                                                                else
                                                                    document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Click on email to verify your email";
                                                            }
                                                            document.getElementById("email").value = "";
                                                        }
                                                    }
                                                    
                                                }
                                                ,1);
                                                
                                                var CustSetVerifyFalse = function(){
                                                    CustEmailVerified = false;
                                                    document.getElementById("CustSendverifyEmailBtn").style.display = "block";
                                                };
                                                var CustShowEmailVerify = function(){
                                                    document.getElementById("CustEmailVeriDiv").style.display = "block";
                                                    //document.getElementById("provSignUpBtn").style.display = "none";
                                                };
                                                var CustCloseEmailVerify = function(){
                                                    CustPageJustLoaded = false;
                                                    if(document.getElementById("visibleEmail").value === ""){
                                                        document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                        document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please enter a valid email";
                                                        //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var CustVeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#CustSendverifyEmailBtn").click(function(event){
                                                        
                                                        //document.getElementById('PageLoader').style.display = 'block';
                                                        CustVeriCode = Math.floor(100000 + Math.random() * 900000);
                                                        CustVeriCode = CustVeriCode + "";
                                                        
                                                        document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Verification Code has been sent to your Email";
                                                        //document.getElementById("CustvCodeStatus").style.backgroundColor = "green";
                                                        document.getElementById("CustSendverifyEmailBtn").style.display = "none";
                                                        
                                                        var to = document.getElementById("visibleEmail").value;
                                                        var Message = CustVeriCode + ' is your Queue verification code';
                                                        
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "QueueMailer",
                                                            data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                            success: function(result){
                                                                //document.getElementById('PageLoader').style.display = 'none';
                                                            }
                                                        });
                                                        
                                                    });
                                                });
                                                
                                                var CustVerifyCode = function () {
                                                    
                                                    if(document.getElementById("CustEmailConfirm").value === CustVeriCode){
                                                        CustEmailVerified = true;
                                                    }
                                                    else{
                                                        document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Make sure verification code is entered or is correct";
                                                        //document.getElementById("CustvCodeStatus").style.backgroundColor = "red";
                                                    }
                                                        
                                                };
                                            </script>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><p>Phone Number</p><input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" type="text" id="phoneNumber" name="phoneNumber" value="<%=telNumber%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                    <script>
                        var TelFld = document.getElementById("phoneNumber");
                        
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
                    
                    <h2 style="margin: 15px 0; margin-top: 30px; ">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td style="padding-top: 10px;"><p>User Name</p><input onkeyup="setPasswordsZero();" onfocusout="checkIsUsernameEmpty('userName','CustUserNameStatus');"
                                                                                          onchange="CustUserNameCheck();" type="text" id="userName" name="userName" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        <p id="CustUserNameStatus" style="color: white; text-align: center; max-width: 250px; margin: 10px 0;"></p></td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px;"><p>Password</p><input class="passwordFld" type="password" id="firstPassword" name="firstPassword" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        <p style="text-align: right; margin-top: -25px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px;"><p>Password (Again)</p><input class="passwordFld" type="password" id="secondPassword" name="secondPassword" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="margin: 15px 0; width: 180px; color: #334d81;" id="passwordStatus"></p></center>
                        <center><p style="margin: 15px 0; width: 180px; color: #334d81;" id="formStatus"></p></center>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" id="AddUserSignUpBtn" type="submit" value="Signup" name="submitbtn" />
                    </form>
                                
                    <script>
                                    
                        function setPasswordsZero(){
                            document.getElementById("secondPassword").value = "";
                            document.getElementById("firstPassword").value = "";
                        }
                                    
                        function CustUserNameCheck(){
                            
                            var userName = document.getElementById("userName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckCustUserNameExists",
                                data: "UserName="+userName,
                                success: function(result){
                                    
                                    if(document.getElementById("userName").value === ""){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = "";
                                        
                                    }
                                    else if(result === "true"){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: red;" class="fa fa-exclamation-triangle"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is not available. Choose a different Username';
                                        //document.getElementById("CustUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("userName").value = "";
                                        
                                    }else if(result === "false" && document.getElementById("userName").value !== ""){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: #58FA58;" class="fa fa-check"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is available.';
                                        //document.getElementById("CustUserNameStatus").style.backgroundColor = "green";
                                        
                                    }
                                }
                            });
                        }  
                        
                    </script>
                    
                    <form style="overflow-x: hidden; display: none;" name="businessForm" id="businessForm" action="ProviderSignUpController" method="POST">
                    
                    <p style="color: darkblue; font-weight: bolder; margin: 15px 0;">Add Business Account<p>
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input id="firstProvName" type="text" name="firstProvName" value="<%=fName%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr style='display: none;'>
                                    <td><p>Middle Name</p><input id="middleProvName" type="text" name="middleProvName" value=" " size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input id="lastProvName" type="text" name="lastProvName" value="<%=lName%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td>
                                        <p id='BizEmailStatus' style='color: darkblue; margin: 10px 0; display: none; text-align: center;'></p>
                                        <p>Email</p><input onchange='SetVerifyFalse();' onfocusout='CloseEmailVerify();' onfocus='ShowEmailVerify();' id="visibleProvEmail" type="text" name="provEmail" value="<%=email%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        <input id='provEmail' type='hidden' value='' />
                                        <div id='BizEmailVeriDiv' style='display: none; background-color: #3d6999; padding: 10px; margin: 5px;'>
                                            <div id='sendVerifyDiv'>
                                                <center><input id='SendverifyEmailBtn' type='button' value='1. Click to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            </div>
                                            <div id='verifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                <p id='vCodeStatus' style='padding-left: 5px; color: white; max-width: 250px; margin: 10px 0;'><span style="color: #ffc700; font-weight: bolder;">2.</span> We will be sending a verification code to your email. You should enter the code below</p>
                                                <p style='color: #ccc;'><input id="BizEmailConfirm" type="text" placeholder="Enter 6-digit code here" style="background-color: #d9e8e8; border-radius: 4px;" /></p>
                                            </div>
                                            <center><input id='verifyEmailBtn' onclick="VerifyCode();" type='button' value='3. Click to verify entered code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                            <script>
                                                
                                                var EmailVerified = false;
                                                var PageJustLoaded = true;
                                                
                                                if(document.getElementById("visibleProvEmail").value !== ""){
                                                    PageJustLoaded = false;
                                                }
                                                
                                                setInterval(function(){
                                                    
                                                    if(!PageJustLoaded){
                                                        
                                                        if(EmailVerified){
                                                            document.getElementById("BizEmailStatus").style.display = "block";
                                                            //document.getElementById("BizEmailStatus").style.backgroundColor = "green";
                                                            document.getElementById("BizEmailStatus").innerHTML = "<i style='color: #58FA58;;' class='fa fa-check'></i> Your email has been verified";
                                                            document.getElementById("provEmail").value = document.getElementById("visibleProvEmail").value;
                                                            document.getElementById("BizEmailVeriDiv").style.display = "none";
                                                        }else{
                                                            document.getElementById("BizEmailStatus").style.display = "block";
                                                            //document.getElementById("BizEmailStatus").style.backgroundColor = "red";
                                                            if(document.getElementById("BizEmailVeriDiv").style.display === "block"){
                                                                if(document.getElementById("visibleProvEmail").value === "")
                                                                    document.getElementById("BizEmailStatus").innerHTML = "";
                                                                else
                                                                    document.getElementById("BizEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please verify your email";
                                                            }else{
                                                                if(document.getElementById("visibleProvEmail").value === "")
                                                                    document.getElementById("BizEmailStatus").innerHTML = "";
                                                                else
                                                                    document.getElementById("BizEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Click on email to verify your email";
                                                            }
                                                            document.getElementById("provEmail").value = "";
                                                        }
                                                    }
                                                    
                                                }
                                                ,1);
                                                
                                                var SetVerifyFalse = function(){
                                                    EmailVerified = false;
                                                    document.getElementById("SendverifyEmailBtn").style.display = "block";
                                                };
                                                var ShowEmailVerify = function(){
                                                    document.getElementById("BizEmailVeriDiv").style.display = "block";
                                                    //document.getElementById("provSignUpBtn").style.display = "none";
                                                };
                                                var CloseEmailVerify = function(){
                                                    PageJustLoaded = false;
                                                    if(document.getElementById("visibleProvEmail").value === ""){
                                                        document.getElementById("BizEmailVeriDiv").style.display = "none";
                                                        document.getElementById("BizEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please enter a valid email";
                                                        //document.getElementById("BizEmailStatus").style.backgroundColor = "red";
                                                        //document.getElementById("provSignUpBtn").style.display = "block";
                                                    }
                                                };
                                                
                                                var VeriCode;
                                                
                                                $(document).ready(function(){
                                                    $("#SendverifyEmailBtn").click(function(event){
                                                        //document.getElementById('PageLoader').style.display = 'block'
                                                        VeriCode = Math.floor(100000 + Math.random() * 900000);
                                                        VeriCode = VeriCode + "";
                                                        //document.getElementById("BizEmailConfirm").value = VeriCode;
                                                        
                                                        document.getElementById("vCodeStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Verification Code has been sent to your Email";
                                                        //document.getElementById("vCodeStatus").style.backgroundColor = "green";
                                                        document.getElementById("SendverifyEmailBtn").style.display = "none";
                                                        
                                                        var to = document.getElementById("visibleProvEmail").value;
                                                        var Message = VeriCode + ' is your Queue verification code';
                                                        
                                                        $.ajax({
                                                            type: "POST",
                                                            url: "QueueMailer",
                                                            data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                            success: function(result){
                                                                //document.getElementById('PageLoader').style.display = 'none';
                                                            }
                                                        });
                                                        
                                                    });
                                                });
                                                
                                                var VerifyCode = function () {
                                                    
                                                    if(document.getElementById("BizEmailConfirm").value === VeriCode){
                                                        EmailVerified = true;
                                                    }
                                                    else{
                                                        document.getElementById("vCodeStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Make sure verification code is entered or is correct";
                                                        //document.getElementById("vCodeStatus").style.backgroundColor = "red";
                                                    }
                                                        
                                                };
                                            </script>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p>Phone Number</p><input onclick="checkMiddleNumberProPer();" onkeydown="checkMiddleNumberProPer();" id="provPhoneNumber" type="text" name="provPhoneNumber" value="<%=telNumber%>" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                                
                        <script>
                        var TelFldProPer = document.getElementById("provPhoneNumber");
                        
                        function numberFuncProvPer(){
                            
                            var number = parseInt((TelFldProPer.value.substring(TelFldProPer.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProPer.value = TelFldProPer.value.substring(0, (TelFldProPer.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProvPer, 1);
                        
                        function checkMiddleNumberProPer(){
                            
                            for(var i = 0; i < TelFldProPer.value.length; i++){

                                var middleString = TelFldProPer.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProPer.value = TelFldProPer.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <center><h2 style="margin: 15px 0; margin-top: 30px;">Add your business information below</h2></center>
                        
                    <center><table border="0" style="">
                            <tbody>
                                <tr>
                                    <td style="padding-bottom: 10px;"><p>Business Name</p><input id="businessName" type="text" name="businessName" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                
                                <tr>
                                    <td  style="padding-top: 15px; padding-left: 5px; padding-bottom: 15px; border-top: 1px solid white; border: 1px solid white;">
                                        
                                        <p style="color: white;">Business Location (Address)</p>
                                        
                                        <p style="margin: 5px; text-align: center;">Providing accurate address information<br/>will help customers locate your business</p>
                                        
                                        <h3 style="text-align: center; color: #000099;">Enter your address below</h3>      
                                        
                                        <table style="background: none; box-shadow: none;">
                                            <tbody>
                                            <tr> 
                                                <td>House</td>
                                                <td><input onkeydown="checkMiddleNumberHNumber();" onclick="checkMiddleNumberHNumber();" id="HouseNumber" type="text" name="HouseNumber" placeholder='123...' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            </tr>
                                            <tr>
                                                <td>Street:</td>
                                                <td><input id="Street" type="text" name="Street" placeholder='street/avenue' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            </tr>
                                            <tr>
                                                <td>Town:</td>
                                                <td><input id="Town" type="text" name="Town" placeholder='town' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            </tr>
                                            <tr>
                                                <td>City:</td>
                                                <td><input id="City" type="text" name="City" placeholder='city' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            <tr>
                                                <td>Zip Code:</td>
                                                <td><input onclick="checkMiddleNumberZCode();" onkeydown="checkMiddleNumberZCode();" id="ZCode" type="text" name="ZCode" placeholder='123...' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            </tr>
                                            <tr>
                                                <td>Country:</td>
                                                <td><input id="Country" type="text" name="Country" placeholder='country' value="" size="22" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                            </tr>
                                            </tbody>
                                        </table>
                                        <p><i class='fa fa-exclamation-triangle' id='AddrStatusIcon'></i> <input id="businessLocation" type="text" name="businessLocation" value="" readonly style="background: none; border: none; font-size: 9px; width: 85%; margin: auto;"/></p>
                                       </td>
                                </tr>
                                
                                <script>
                        var setLocation = setInterval(
                            function(){
                                //don't clear interval as long as values are undefined
                                if(GoogleReturnedCity !== undefined && GoogleReturnedZipCode !== undefined && GoogleReturnedTown !== undefined){
                                    document.getElementById("HouseNumber").value = GoogleReturnedStreetNo;
                                    document.getElementById("Street").value = GoogleReturnedStreetName;
                                    document.getElementById("Town").value = GoogleReturnedTown;
                                    document.getElementById("City").value = GoogleReturnedCity;
                                    document.getElementById("ZCode").value = GoogleReturnedZipCode;
                                    document.getElementById("Country").value = GoogleReturnedCountry;
                                    clearInterval(setLocation);
                                }
                            }, 
                            1000
                        );
                
                    </script>
                                
                                <script>
                                    var HouseNumber = document.getElementById("HouseNumber");

                                    function numberFuncHNumber(){

                                        var number = parseInt((HouseNumber.value.substring(HouseNumber.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            HouseNumber.value = HouseNumber.value.substring(0, (HouseNumber.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncHNumber, 1);

                                    function checkMiddleNumberHNumber(){

                                        for(var i = 0; i < HouseNumber.value.length; i++){

                                            var middleString = HouseNumber.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                HouseNumber.value = HouseNumber.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <script>
                                    var ZCode = document.getElementById("ZCode");

                                    function numberFuncZCode(){

                                        var number = parseInt((ZCode.value.substring(ZCode.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            ZCode.value = ZCode.value.substring(0, (ZCode.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncZCode, 1);

                                    function checkMiddleNumberZCode(){

                                        for(var i = 0; i < ZCode.value.length; i++){

                                            var middleString = ZCode.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                ZCode.value = ZCode.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <tr style='display: none;'>
                                    <td style="padding-top: 10px;"><p>Business Email</p><input id="businessEmail" type="text" name="businessEmail" value=" " size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td style="padding: 10px;"><p style="">Business Telephone</p><input onclick="checkMiddleNumberProBiz();" onkeydown="checkMiddleNumberProBiz();" id="businessTel" type="text" name="businessTel" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                                <tr>
                                    <td style="padding: 10px; padding-bottom: 0;"><p>Business Type</p><select id="businessType" style="padding: 5px; background-color: #d9e8e8; color: black; border: #3d6999 1px solid; margin: 5px" name="businessType">
                                            <option>Select Business Type</option>
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
                                <tr>
                                    <td><input id="otherBusinessType" type="text" name="otherBusinessType" placeholder="name your business type here" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                            </tbody>
                        </table></center>
                    
                    <script>
                        var TelFldProBiz = document.getElementById("businessTel");
                        
                        function numberFuncProBiz(){
                            
                            var number = parseInt((TelFldProBiz.value.substring(TelFldProBiz.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProBiz.value = TelFldProBiz.value.substring(0, (TelFldProBiz.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProBiz, 1);
                        
                        function checkMiddleNumberProBiz(){
                            
                            for(var i = 0; i < TelFldProBiz.value.length; i++){

                                var middleString = TelFldProBiz.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProBiz.value = TelFldProBiz.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>

                    <h2 style="margin: 15px 0; margin-top: 30px;">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td style="padding-top: 10px;"><p>User Name</p><input onkeyup="setProvPasswordsZero();" onfocusout="checkIsUsernameEmpty('provUserName','provUserNameStatus');"
                                                                                          onchange="ProvUserNameCheck();" id="provUserName" type="text" name="provUserName" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                        <p id="provUserNameStatus" style="color: white; text-align: center; max-width: 250px; margin: 10px 0;"></p></td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px;"><p>Password</p><input class="passwordFld" id="firstProvPassword" type="password" name="firstProvPassword" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/>
                                    <p style="text-align: right; margin-top: -25px; padding-right: 10px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p></td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px;"><p>Password (Again)</p><input class="passwordFld" id="secondProvPassword" type="password" name="secondProvPassword" value="" size="30" style="background-color: #d9e8e8; border-radius: 4px;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="margin: 15px 0; width: 180px; color: #334d81;" id="provPasswordStatus"></p></center>
                        <center><p style="margin: 15px 0; width: 180px; color: #334d81;" id="provFormStatus"></p></center>
                        
                        <p style='min-width: 350px;'><input class="button" type="reset" value="Reset" name="resetbtn"/>
                            <input id="provSignUpBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Sign up" name="provSignUpBtn" /></p>
                    </form>
                                
                    <script>
                        
                        /*document.getElementById("provUserName").value = "";
                        document.getElementById("firstProvPassword").value = "";
                        document.getElementById("secondProvPassword").value = "";*/
                        
                        function setProvPasswordsZero(){
                            document.getElementById("secondProvPassword").value = "";
                            document.getElementById("firstProvPassword").value = "";
                        }
                        
                        
                        var checkIsUsernameEmpty = (usernameFld, statusFld) => {
                            
                            if(document.getElementById(usernameFld).value === ""){
                                document.getElementById(statusFld).innerHTML = "";
                            }
                        };
                        
                        function ProvUserNameCheck(){
                            
                            var userName = document.getElementById("provUserName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckProvUserNameExist",
                                data: "UserName="+userName,
                                success: function(result){
                                    
                                    if(document.getElementById("provUserName").value === ""){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = "";
                                        
                                    }
                                    else if(result === "true" && document.getElementById("provUserName").value !== ""){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = '<i style="color: red;" class="fa fa-exclamation-triangle"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is not available. Choose a different Username';
                                        //document.getElementById("provUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("provUserName").value = "";
                                        
                                        
                                    }else if(result === "false" && document.getElementById("provUserName").value !== ""){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = '<i style="color: #58FA58;" class="fa fa-check"></i> <span style="color: #E6E6E6; font-weight: bolder;">"' + userName + '"</span> is available.';
                                        //document.getElementById("provUserNameStatus").style.backgroundColor = "green";
                                        
                                    }
                                    
                                }
                            });
                        }  
                        
                    </script>
                
                <!--center><h4 style="margin-top: 15px;">Click here to go to Queue home page</a></h4></center-->
                </div>
                </div></center>
                
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                <center><p id="alreadyAccountStatus" ><a style="color: #000099;" href="LogInPage.jsp">Already have an account? <span style="color: #ffffff">Login now.</span></a></p></center>
            </div>
            
        </div>
                
            <div id="newbusiness" style=" height: 73%;">
            
        <center><div id ="logindetailsSignUP" style="padding-top: 60px;">
                <center><h1 style='color: darkblue; margin-bottom: 40px;'>Already have an account</h1></center>
                
                <center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: #334d81; padding: 4px;">
                            <i class="fa fa-home" style="font-size: 30px;"></i> Click here to go to Queue home page</a></h2></center>
                
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                  
                <center><h2 style="margin-bottom: 20px;">Login here</h2></center>
                
                <form name="login" action="LoginControllerMain" method="POST">
                    <table border="0" style="background: none; box-shadow: none;"> 
                        
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <span class="fa fa-user"></span>
                                            <input id="LoginPageUserNameFld" placeholder="Enter user name here" type="text" name="username" value="" size="34" style=""/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <span class="fa fa-key"></span>
                                            <input id="LoginPagePasswordFld" placeholder='Enter password here' type="password" name="password" value="" size="34" style=""/>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
                    </form>
                <center><h4 style = "margin-top: 15px; margin-bottom: 15px; width: 90%; max-width: 300px;"></h4></center>
                </div></center>
            
            </div>
                                        
        </div>
                                        
        </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
    <script>
        $(document).ready(function() {
            new $.Zebra_Dialog(
                "We are not responsible for any unsatisfied service from a business on our platform. " +
                "<br/><br/>However, we are committed to making sure that you get the best service through our platform. " +
                "<br/><br/>Rating businesses on our platform will help us disassociate with bad businesses.",
                {
                    type: "warning",
                    title: "Disclaimer",
                    //buttons: ["Yes", "No", "Help"],
                    buttons: ["Continue"],
                    onClose: function(caption) {

                        // notice that we use the button's label to determine which button was clicked
                        // "caption" will be empty when the dialog box is closed by pressing ESC, by clicking the
                        // dialog box's close button, or by clicking the overlay
                        /*new $.Zebra_Dialog((caption !== "" ? "\"" + caption + "\"" : "nothing") + " was clicked", {
                            auto_close: 2000,
                            buttons: false,
                            modal: false,
                            position: ["center", "center"]
                        });*/

                    }
                }
            );
        });
    </script>
    </body>
    
    <script src="scripts/signUpPageScript.js"></script>
    <script src="scripts/script.js"></script>
    <script src="scripts/CollectAddressInfo.js"></script>
    
</html>
