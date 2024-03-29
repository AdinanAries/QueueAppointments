<%-- 
    Document   : index
    Created on : Feb 10, 2019, 10:14:26 AM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    
    <head>
        
        <script>
            document.cookie = "SameSite=None";
            document.cookie = "SameSite=None; Secure";
            //alert(document.cookie);
        </script>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="indexCSS.css" media="screen" rel="stylesheet" type="text/css"/>
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <title>AriesLab</title>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
    </head>
    
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
                            let city = CityZipCodeParts[1].trim();
                            GoogleReturnedTown = AddressParts[1].trim();
                            if(GoogleReturnedTown === "The Bronx")
                                GoogleReturnedTown = "Bronx";
                            GoogleReturnedCity = StateAbbrev[city].trim();
                            GoogleReturnedZipCode = CityZipCodeParts[2].trim();
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
                  //navigator.geolocation.getCurrentPosition(showPosition, locationErrorHandling, locationOptions);
                  var watchID = navigator.geolocation.watchPosition(showPosition, locationErrorHandling, locationOptions);
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
                      url: "./addLocationDataToWebContext",
                      success: function(result){
                          //alert("Location added!");
                      }
                  });
                  
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
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        response.sendRedirect("Queue.jsp");
        
        /*this stores the UserIndex for session tracking
        String UserIndex = "";
        
        try{
            //try incase UserAccount hasn't yet been created
            UserIndex = request.getParameter("UserIndex");
            int Index = Integer.parseInt(request.getParameter("UserIndex"));
            
            int UserID = UserAccount.LoggedInUsers.get(Index).getUserID();
            String AccountType = UserAccount.LoggedInUsers.get(Index).getAccountType();
            //JOptionPane.showMessageDialog(null, AccountType);
            
        }catch(Exception e){
            e.printStackTrace();
        }*/
        
    %>
    
    <body>
        
        <div id="header" style="background-color: white;">
            <div style="background-color: white; width: 260px; float: left;">
                <center>
                    <img src="ThisLogo.png" width="250" height="84" alt="ThisLogo"/>
                    <p style="font-weight: bolder; color: white; margin-bottom: 5px; font-style: italic; background-color: red;">Bringing solutions to your finger tips</p>
                </center>
            </div>
            <p style="clear: both;"></p>

        </div>
        
        <div id="container">
            
            <div id="content">
                
            <div id="allnavs">
                
        <!--div id="nav">
            
                    <ul>
                        <a href=""><li class="active" style="background-color: #6699ff; border: black solid 1px; color: #000099;">Home Page</li></a>
                        <a href="SoftwareProducts.jsp"><li>AriesLab Products</li></a>
                        <a href="ContactUs.jsp"><li>Contact Us</li></a>
                        <a href="OurReputation.jsp"><li>Our Reputation</li></a>
                        <a href="PageController?UserIndex=<=UserIndex%>"><li  id="queuenav" style="color: #ff3333; border:#ff3333 solid 1px;" >Queue</li></a>
                        <a href="ContractServices.jsp"><li>AriesLab Contracts</li></a>
                        <a href="DevelopersJoin.jsp"><li>Join AriesLab</li></a>
                        <a href=""><li>AriesLab Projects</li></a>
                        <a href=""><li>Legal Team</li></a>
                        <a href=""><li>Learn Programming</li></a>
                        <a href=""><li>IT Solutions</li></a>
                    </ul>
        </div-->
                
        </div>
                <div id ="main">
                    
                    <center><p style = "width: 150px; margin:5px; float: right; color: red;"><span id="displayDate" style=""></span></p></center>
            
                    
                    <h2 style="color: darkblue; margin-top: 10px; clear: both;">ABOUT US</h2>
                    <p style="text-align: justify; margin: 10px;">AriesLab is a software development team, and a group of information-technology(IT) 
                        specialists, and a software vending business based in the USA. This company specializes mainly in Desktop 
                        and Mobile applications development, as well as Web applications and Web-sites development, and other IT based solutions. This company
                        of software engineers and computer specialists has over 10 years of experience in the fields of Computer Science and
                        Software Engineering, and is known to be one of the most reputed group of engineers in its fields of specialties.
                        AriesLab always offers its customers effective, low-cost, on-time, and on-budget software and IT solutions, and always puts its clients first
                        in all its business dealings. If you are looking for a team of software developers and engineers or information-technology(IT) specialists
                        who can provide you with effective software and IT
                        solutions, then look no further, AriesLab is here to satisfy all your needs.
                    </p>
                        <h2 style="color: darkblue; margin-top: 15px;">WHY ENTRUST TO AriesLab</h2>
                    <p style="text-align: justify; margin: 10px;">Software Development is an iterative process(ie creating software is not a build it at once process), and for this reason, 
                    you need a team of developers who will stick with the process from its inception, through development process as the software evolves, all-the-way till its retirement.
                    Building and keeping such team of developers in your company could be a very expensive undertaking. You have an alternative though! OutSourcing the software development process 
                    to developers outside of your company is often a cheaper alternative. With outsourcing though, you usually don't get developers to stay throughout your products lifetime. One of the 
                    consequences of outsourcing is that, progress is usually very slow and very uncertain, especially when you start hopping from one developer or development-team to another. You may also end up
                    with pieces of code that cannot be stitched together. 
                    This is where AriesLab comes in. With AriesLab, you get to out-source the development process, yet we assign a dedicated team of Engineers 
                    who stay with you all-the-way on your journey to build your amazing software,
                    and to evolve and maintain it as and when your business goals change and as and when the software scales-up.</p>
                    <p style="text-align: justify; margin: 10px;">At AriesLab, we say focus on the other important things, we'll be your development-team throughout your software-products' lifetime.
                    </p>
                    <p><a href="ContactUs.jsp" style="color: red;">Contact us now</a>.</p>
                </div>
                <p style="clear: both;"></p>
                       
            </div>
            <div id="additional">
                 <div id="subscribeDiv" style="margin-top: 0;">
                    <h4 style="color: #000099; margin-top: 15px; margin-bottom: 5px;">Subscribe to AriesLab news feed</h4>
                    <form name="subscribeAriesLab" action="subscriptionsController" method="POST">
                        <input style="padding: 5px;" type="text" placeholder="Email" name="subscriptionsEmailFld" value="" size="30" /><input style="padding: 5px;" type="submit" value="Subscribe" name="subscriptionsBtn" />
                    </form>
                </div>
            </div>
            <div id="footer">
                <p>AriesLab &copy;2019</p>
            </div>
        </div>
    </body>
    
    <script src="scripts/script.js"></script>
    
</html>
