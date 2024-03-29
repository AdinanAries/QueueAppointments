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
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>

<html>
    
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <title>Queue</title>
        
    </head>
    
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
        
        /*Date NotiDate = new Date();
        String NotiSDate = NotiDate.toString();
        SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
        String date = NotiDformat.format(NotiDate);
        String time = NotiSDate.substring(11,16);
        JOptionPane.showMessageDialog(null, NotiDate);
        JOptionPane.showMessageDialog(null, time);
        JOptionPane.showMessageDialog(null, date);*/
        
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
        
    %>
    
    <body onload="document.getElementById('HomePageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
        <div id="HomePageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        <!--a id='mapLink'>Click here to see location</a-->
        
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
                            GoogleReturnedCity = result.results[0].address_components[4].long_name;
                            GoogleReturnedTown = result.results[0].address_components[3].long_name;

                            let AddressParts = result.results[0].formatted_address.split(",");
                            let CityZipCodeParts = AddressParts[2].split(" ");
                            //alert(result.results[0].formatted_address);
                            //alert(AddressParts[0]);
                            let city = CityZipCodeParts[1];
                            GoogleReturnedTown = AddressParts[1];
                            if(GoogleReturnedTown === " The Bronx")
                                GoogleReturnedTown = "Bronx";
                            GoogleReturnedCity = StateAbbrev[city];
                            GoogleReturnedZipCode = CityZipCodeParts[2];
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
                alert("ERROR(" + error.code + "): " + error.message);
                //Will add error handling here;
            }
            
            var locationOptions = {
                
                enableHighAccuracy: true, 
                maximumAge        : 30000, 
                timeout           : 27000
            
            };
            
            function getLocation(){
                if (navigator.geolocation){
                  //navigator.geolocation.getCurrentPosition(showPosition, locationErrorHandling, locationOptions);
                  var watchID = navigator.geolocation.watchPosition(showPosition, locationErrorHandling, locationOptions);
                  //alert(watchID);
                  //navigator.geolocation.clearWatch(watchID);

                }else{ 
                    alert("Geolocation is not supported by this browser.");
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
        
        <div id="PermanentDiv" style="">
            
            <div style="float: left; width: 350px; margin-top: 5px; margin-left: 10px;">
                <p style="color: white;"><img style="background-color: white; padding: 1px;" src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                    tech.arieslab@outlook.com | 
                    <img style="background-color: white; padding: 1px;" src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                    (1) 732-799-9546
                </p>
            </div>
            
            <div style="float: right; width: 50px;">
                    <center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                        <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src="icons/icons8-user-filled-100.png" width="30" height="30" alt="icons8-user-filled-100"/>
                    </div></center>
            </div>
            
            <a href='NewsUpadtesPage.jsp'><div style='width: 40px; height: 27px; margin-top: 5px; float: right; margin-right: 5px;'>
                    <img style='background-color:white; width: 40px; height: 27px; padding: 1.5px;' src="icons/icons8-google-news-50.png" alt="icons8-google-news-50"/>
                </div></a>
        
            <ul style="margin-right: 5px;">
                <a  href="LogInPage.jsp">
                    <li style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Your Dashboard</li></a>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/>
                    Calender</li>
                <li style='cursor: pointer;'><img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/>
                    Account</li>
            </ul>
            
            <div id="ExtraDivSearch" style='background-color: #334d81; padding: 3px; padding-right: 5px; padding-left: 5px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #3d6999; color: #eeeeee; height: 30px; border: 1px solid darkblue; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; border: 1px solid white; background-color: navy; color: white; border-radius: 4px; padding: 7px; font-size: 15px;" 
                            type="submit" value="Search" />
                </form>
            </div>
                <p style='clear: both;'></p>
        
        </div>

        <div id="container">
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <li onclick="scrollToTop()" style="padding-left: 2px; padding-right: 2px;"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;"
                                   placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                            <input style="margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;" 
                                   type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div style='display: block;' id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image id="DashboardLogo" src="QueueLogo.png" style="margin-top: 5px;"/></center>
            <center><p style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></center>
            
        </div>
            
            <center><a href="NewsUpadtesPage.jsp"><p id='QShowNews22' 
                style='background-color: #6699ff; color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0;'>
                    <img style='background-color: white; width: 25px; height: 24px;' src="icons/icons8-google-news-50.png" alt="icons8-google-news-50"/>
                    <sup style='font-size: 17px;'>Show News Updates</sup>
            </p></a></center>
            
            <div id="Extras">
            
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 5px;">Updates from service providers</p></center>
            
            <div style="max-height: 87vh; overflow-y: auto;">
                <%
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        int newsItems = 0;
                        
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
            %>
            </div>
            </div>
            
        <div class="DashboardContent" id="">
            
            <div id="nav" style='display: block;'>
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <!--h4><a href="SignUpPage.jsp" style=" color: #000099;">First time on Queue (Sign-up now)</a></h4-->
                <!--h4><a href="PageController?Message=<=Message%>" style=" color: black;">Go to your dashboard/Login now</a></h4-->
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
               
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" />
                    </form> 
                        
                </div></center>
                
                <div id="LocSearchDiv" style="margin-top: 5px;">
                <center><form id="DashboardLocationSearchForm" action="ByAddressSearchResult.jsp" method="POST" style="">
                    <p style="color: #000099;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                        Find services at location below</p>
                    <p>City: <input id="city4Search" style="width: 80%;" type="text" name="city4Search" placeholder="" value=""/></p> 
                    <p>Town: <input id="town4Search" style=" width: 35%" type="text" name="town4Search" value=""/> Zip Code: <input id="zcode4Search" style="width: 19%;" type="text" name="zcode4Search" value="" /></p>
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
                    <p style='color: white; margin-top: 5px;'>Filter Search by:</p>
                    <div id="DashboardLocationSearchFilter" class='scrolldiv' style='width: 95%; overflow-x: auto; color: #ccc; background-color: #3d6999;'>
                        <table style='width: 2500px;'>
                            <tbody>
                                <tr>
                                    <td style='border-right: 1px solid darkblue;'>
                                        <p><input name='Barber' id='barberFlt' type="checkbox" value="ON" /><label for='barberFlt'>Barbershop</label></p>
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
                    <p><input type="submit" style="font-weight: bolder; background-color: #6699ff; color: white; padding: 5px; border-radius: 5px; border: 1px solid white; width: 95%;" value="Search" /></p>
                    </form></center>
                </div>
                
            </div>
            
            <div id="main" class="Main" style="padding-top: 5px;">
               
                <!--center><p style="max-width: 350px; color: white; background-color: red; margin-bottom: 10px;"><=Message%></p><center-->
               
                <!--h1>Academic Appointments</h1>
                <h2>Select Service category</h2>
                
                <h1>Health Services Appointments</h1>
                <h2>Select Service category</h2>
                
                
                <h1>Beaty Services Appointments</h1-->
                <h4 style="padding: 5px;">Select Service category</h4>
                
                 <div id="firstSetProvIcons">
                <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBusiness.jsp"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMedicalCenter.jsp"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectDentist.jsp"><p style="margin:0;">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectPodiatry.jsp"><p style="margin:0;" name="PodiatrySelect">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPhisicalTherapy.jsp"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMassage.jsp"><p style="margin:0;" name="MassageSelect">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectTattoo.jsp"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMedAesthet.jsp"><p style="margin:0;" name="MedEsthSelect">Medical Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusiness.jsp"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
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
                            <td style="width: 33.3%;"><center><a href="QueueSelectBrowsLashes.jsp"><p style="margin:0;" name="EyebrowsSelect">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                            </a></center></td>
                             <td style="width: 33.3%;"><center><a href="QueueSelectDietician.jsp"><p style="margin:0;" name="DieticianSelect">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectPetServe.jsp"><p style="margin:0;" name="PetServicesSelect">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHomeServe.jsp"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPiercing.jsp"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHolisticMed.jsp"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-pill-filled-70.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                            </a></center></td>
                        <tr>
                            <td><center><a href="QueueSelectNailSalon.jsp"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPersonalTrainer.jsp"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHairSalon.jsp"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
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
                            <td style="width: 33.3%;"><center><a href="QueueSelectDaySpa.jsp"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectHairRemoval.jsp"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalon.jsp"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            </tr>
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtist.jsp"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                                </a></center></td>
                            </tr>
                            
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondFromThirdProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Previous</p></center>

                </div>
                
            </div>
                
        </div>
                
        <div id="newbusiness" style="height: 525px;">
            
            <div id="Extras2" style="display: none; height: 565px; overflow-y: auto; position: fixed; width: 33.5%; z-index: 110; background-color: #ccccff; text-align: left;">
            
                <p onclick='document.getElementById("Extras2").style.display = "none";' style='width: 50px; float: right; margin-right: 5px; margin-top:5px;
                   border-radius: 5px;  color: white; cursor: pointer; border: 1px solid white; text-align: center; background-color: red;'>hide
                </p>
                
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">Updates from service providers</p></center>
            
            <div style="max-height: 600px; overflow-y: auto;">
                <%
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        int newsItems = 0;
                        
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
                        if(newsItems > 10)
                            break;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
            %>
            </div>
            </div>
            
            <p id='QShowNews2' onclick='document.getElementById("Extras2").style.display = "block";'
                style='margin-top: 40px; background-color: #334d81; color: white; border: 2px solid white; padding: 5px; cursor: pointer;'>
                <img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                Show News Updates</p>
            
            
            
            <center><p id='addBizTxt' style="font-size: 20px;  margin-bottom: 10px; color: #000099"><b>Add your business or create customer account below</b>
                </p></center>
            
            <div id="businessdetails" >
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    <table border="0">
                        <tbody>
                            <tr>
                                <td><p style="color: white; text-align: center;">Provide your information below<p></td>
                            </tr>
                            <tr>
                                <td><input id="signUpFirtNameFld" placeholder="enter your first name" type="text" name="firstName" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="sigUpLastNameFld" placeholder="enter your last name" type="text" name="lastName" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="37"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="37"/></td>
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
                    <input id="loginPageSignUpBtn" class="button" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <center><p style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; color: #000099"><b>Login to view and manage your spots</b></p></center>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="37"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="enter your password" type="password" name="password" value="" size="37"/></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
            
                </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
