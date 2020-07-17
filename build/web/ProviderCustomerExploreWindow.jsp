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
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
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
        
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
        
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
            }
            
            /*if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }*/

            /*if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");*/
            
        }catch(Exception e){
            isUserIndexInList = false;
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
        
        if(SessionID == null){
            SessionID = "";
        }
        
        //JOptionPane.showMessageDialog(null, DatabaseSession);
        if(!SessionID.equals(DatabaseSession)){
            isSameSessionData = false;
        }
        
        if(!isSameSessionData || !isSameUserName || UserID == 0 || !isUserIndexInList){
    %>
            <script>

                let UserName2 = window.localStorage.getItem("QueueUserName");
                let UserPassword2 = window.localStorage.getItem("QueueUserPassword");
                parent.window.document.location = "LoginControllerMainRedirect?username="+UserName2+"&password="+UserPassword2;
                    
            </script>
    <%
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
           
           public void getIDsFromAddress(String city, String town, String zipCode){
               
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
            details.getIDsFromAddress(PCity, PTown, "");
            
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
    
    <body style="position: absolute; width: 100%;">
        
        <div id="PagePageLoader" class="QueueLoader" style='display: none;'>
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
            <div id="nav" style='display: block; '>
               
                <center><div class ="SearchObject" style="margin-bottom: 15px;">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResultLoggedIn.jsp" method="POST">
                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" onclick="document.getElementById('PagePageLoader').style.display = 'block';" type="submit" value="Search" name="SearchBtn" onclick="document.getElementById('PagePageLoader').style.display = 'block';"/>
                    </form> 
                        
                </div></center>
                
                <h4><a href="" style=" color: black;"></a></h4>
                
                <h4 style="color: darkblue; padding: 5px;">Search By Location</h4>
                
                <div id="LocSearchDiv" style="margin-top: 5px;">
                <center><form id="DashboardLocationSearchForm" style="" action="ByAddressSearchResultLoggedIn.jsp" method="POST">
                    <input type="hidden" name="User" value="<%=NewUserName%>" />
                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                    <p style="color: #3d6999;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                        Find services at location below</p>
                    <p style="color: #3d6999;">City: <input id="city4Search" style="width: 80%; border-radius: 3px; border: 1px solid #3d6999; color: #3d6999; background-color: #d9e8e8;" type="text" name="city4Search" placeholder="" value="<%=PCity%>"/></p> 
                    <p style="color: #3d6999;">Town: <input id="town4Search" style="width: 35%; border-radius: 3px; border: 1px solid #3d6999; color: #3d6999; background-color: #d9e8e8;" type="text" name="town4Search" value="<%=PTown%>"/> Zip: <input id="zcode4Search" style="width: 19%; border-radius: 3px; border: 1px solid #3d6999; color: #3d6999; background-color: #d9e8e8;" type="text" name="zcode4Search" value="<%=PZipCode%>" /></p>
                    
                    <p style='color: white; margin-top: 5px;'>Filter Search by:</p>
                    <div id="DashboardLocationSearchFilter" class='scrolldiv' style='width: 95%; overflow-x: auto; color: #ccc; background-color: #3d6999; border-radius: 3px; padding: 5px;'>
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
                    <p><input type="submit" style="font-weight: bolder; background-color: #626b9e; color: white; padding:7px; border-radius: 3px; width: 95%;" value="Search" onclick="document.getElementById('PagePageLoader').style.display = 'block';"/></p>
                    </form></center>
                </div>
            </div>
                 
            <div id="main" class="Main" style="padding-bottom: 0 !important;">
                <center><h4 style="color: darkblue; margin-bottom: 5px; padding-top: 5px; max-width: 300px">
                        <!--span style='color: white;' id="NameForLoginStatus"><=FirstName%></span--> Search By Category </h4></center>
                 
                <!--cetnter><h4></h4></cetnter-->
                
                <div id="firstSetProvIcons">
                <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                            </a></center></td>
                            <td style=""><center><a href="QueueSelectDentistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectPodiatryLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="PodiatrySelect">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPhysicalTherapyLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMassageLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="MassageSelect">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectTattooLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMedAesthetLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="MedEsthSelect">Medical Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
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
                            <td style="width: 33.3%;"><center><a href="QueueSelectBrowLashLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="EyebrowsSelect">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                            </a></center></td>
                             <td style="width: 33.3%;"><center><a href="QueueSelectDieticianLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="DieticianSelect">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectPetServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="PetServicesSelect">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHomeServLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPiercingLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHolisticMedicineLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-mortar-and-pestle-100.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                            </a></center></td>
                        <tr>
                            <td><center><a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPersonalTrainerLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHairSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
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
                            <td style="width: 33.3%;"><center><a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectHairRemovalLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            </tr> 
                            <tr>
                                <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtistLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                                </a></center></td>
                            </tr>
                    </tbody>
                    </table></center>
                    
                                <center><p onclick="showSecondFromThirdProvIcons()" style="padding: 5px; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">
                                    <img src="icons/previousIcon.png" alt="" style="width: 35px; height: 35px"/>
                                    </p></center>

                </div>
                                
                <div class="DashboardFooter" style='background-color: #212c2c; 
                     margin-bottom: 0 !important; margin-top: 10px !important; position: relative; z-index: 100 !important; padding-top: 0; display: block !important;' id="footer">
            <div id="CosmeticsSection" style="padding-top: 0;">
                <div style="background-color: #212c2c; padding: 0 10px; margin-bottom: 40px; padding-top: 5px; padding-bottom: 10px;">
                    <h1 style='color: white; font-size: 19px; font-family: serif; padding-bottom: 20px;'>Popular Services</h1>
                    
                    <div style="display: flex; flex-direction: row; justify-content: space-between; max-width: 700px; margin: auto;">
                        <a href="QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-medical-doctor-100.png" style="width: 50px; height: 50px;"/></p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Medical Center</p>
                            </div>
                        </a>
                        <a href="QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-barber-pole-100.png" style="width: 50px; height: 50px;"/></p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Barber Shop</p>
                            </div>
                        </a>
                        <a href="QueueSelectNailSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-nails-96.png" style="width: 50px; height: 50px;"/><p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Nail Salon</p>
                            </div>
                        </a>
                        <a href="QueueSelectDaySpaLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-spa-100.png" style="width: 50px; height: 50px;"/></p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Day Spa</p>
                            </div>
                        </a>
                        <a class="dontShowMobile" href="QueueSelectBeautySalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-cosmetic-brush-96.png" style="width: 50px; height: 50px;"/></p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Beauty Salon</p>
                            </div>
                        </a>
                        <a class="dontShowMobile" href="QueueSelectHairSalonLoggedIn.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                            <div class="eachPopularService">
                                <p style="text-align: center;"><img src="icons/icons8-hair-dryer-100.png" style="width: 50px; height: 50px;"/></p>
                                <p style="text-align: center; color: #ccc; font-size: 12px;">Hair Salon</p>
                            </div>
                        </a>
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
                            <a href='EachSelectedProviderLoggedIn.jsp?UserID=<%=RPID%>&UserIndex=<%=UserIndex%>&User=<%=NewUserName%>' onclick="document.getElementById('PagePageLoader').style.display = 'block';">
                                <div style="height: 120px; background-color: #334d81;
                                 padding: 15px 5px; border-radius: 10px; margin: 0 5px;
                                 background: linear-gradient(rgba( 0, 0, 0, 0.3), rgba(0,0,0,0.8)), url('data:image/jpg;base64,<%=RCovPic%>'); background-size: cover;
                                 background-position: center;
                                 display: flex; flex-direction: column; justify-content: space-between;">
                                    <div style='display: flex; flex-direction: row; justify-content: space-between;'>
                                        <div>
                                           <img src="data:image/jpg;base64,<%=RProPic%>" style="border-bottom-right-radius: 10px; border-top-left-radius: 10px; margin-top: -15px; margin-left: -5px; width: 70px; height: 70px; object-fit: cover;">
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
                                    <p style='color: white; font-weight: bolder;'><!--i style="color: tomato;" class="fa fa-briefcase" aria-hidden="true"></i--><%=RBizName%></p>
                                    <p style="color: #ccc; margin-top: -3px;">- <%=RBizType%> -</p>
                                </div>
                            </a>
                            <%}%>
                            
                          </div>
                         <%
                             if(providersList.size() == 0){
                         %>
                         <p style='color: white;'><i class='fa fa-exclamation-triangle' style='color: yellow;'></i> Oops! We have no recommendations at this time</p>
                         <%}%>
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
                        <div class='eachCSecFlex'>
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
                        </div>
                    </div>
                    
                    <h1 style='color: orange; font-size: 22px; font-family: serif; margin-top: 40px;'>We have the best services in your area</h1>
                    <p style='margin: 10px; text-align: center; max-width: 400px; margin: auto; color: black;'>
                        Your ratings, reviews and feedbacks mean a lot to us. We are constantly watching how well businesses serve their customers in order to ensure that only the best medical and beauty places operate on 
                        our platform. Queue Appointments will eventually disassociate with badly rated businesses.
                    </p>
                    
                    <div class='CosmeSectFlex' style='margin: auto; margin-top: 20px; max-width: 1000px;'>
                        <div class='eachCSecFlex'>
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
                        </div>
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
                            
        <!--script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script-->
    <script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
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
                // You can unslick at a given breakpoint now by adding:
                // settings: "unslick"
                // instead of a settings object
              ]
              });
        });
    </script>
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
