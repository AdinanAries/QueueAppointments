<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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

<!DOCTYPE html>

<html>
    
    <head>                         
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <!--script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
        <title>Queue</title>
        
    </head>
    
    <%
        config.getServletContext().setAttribute("DBUrl",config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver",config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser",config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword",config.getInitParameter("password"));
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
        
        //connection arguments
        try{
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            response.sendRedirect("LogInPage.jsp");
        }
    %>
    
    <%!
        
        //declaring the getUserDetails Class 
        //connects to database, gets Provider records and stash it within a Records ResultSet object
           class getUserDetails{
               //private class fields
               private Connection conn;
               private ResultSet records;
               private String Driver;
               private String url;
               private String User;
               private String Password;
               
               public void initializeDBParams(String driver, String url, String user, String password){
               
                this.Driver = driver;
                this.url = url;
                this.User = user;
                this.Password = password;
            }
               
           //Getter (gets ProviderInfo list, stores it in records and returns records)
           public ResultSet getRecords(String ID){
               try{
                    Class.forName(Driver);
                    conn = DriverManager.getConnection(url,User,Password);
                    String  select = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement pst = conn.prepareStatement(select);
                    pst.setString(1,ID);
                    records = pst.executeQuery();

               }catch(Exception e){
                  e.printStackTrace();
                }
                return records;
            }
       }
           
        %>
        
        <%
            //resetting providerPhotos providerID
            //ProviderPhotos.ProviderID = 0;
            int ProviderID;
            String CurrentProvsName = "";
            
            int UserID = 0;
       
            String For = " - Line position at: ";
            String AppointmentTime = "";
            String FormattedAppointmentTime = "";
            
            try{
                
                AppointmentTime = request.getParameter("AppointmentTime");
                
            }catch(Exception e){
            }
            
            
            try{
                //formatting the time for user convenience
                FormattedAppointmentTime = AppointmentTime;
                
                if(FormattedAppointmentTime.length() == 4)
                    FormattedAppointmentTime = "0" + FormattedAppointmentTime;
                
                int x = Integer.parseInt(FormattedAppointmentTime.substring(0,2));
                String y = FormattedAppointmentTime.substring(3,5);
                
            /*
                if(y.length() < 2){
                    
                    y = "0" + y;
                }
            */
            
                if( x > 12)
                {
                    int TempHour = x - 12;
                    FormattedAppointmentTime = Integer.toString(TempHour) + ":" +  y + " pm";
                }
                else if(x == 0){
                    FormattedAppointmentTime = "12" + ":" + y + " am";
                }
                else if(x == 12){
                    FormattedAppointmentTime = AppointmentTime + " pm";
                }
                else{
                    FormattedAppointmentTime = AppointmentTime + " am";
                }
                
            }catch(Exception e){}
             
            if(AppointmentTime == null){
                
                AppointmentTime = " ";
                FormattedAppointmentTime = " ";
                For = "";
            }
            
            String ID = request.getParameter("UserID"); //value passed from hidden text field from previous page for currently selected service provider
            
            ProviderID = Integer.parseInt(request.getParameter("UserID"));
            ProcedureClass.ProviderID = 0; //always do this first to make sure CustomerID is reset;
            ProcedureClass.ProviderID = Integer.parseInt(request.getParameter("UserID"));
            
            getUserDetails details = new getUserDetails();
            details.initializeDBParams(Driver, url, User, Password);
            
            ArrayList <ProviderInfo> providersList = new ArrayList<>(); //ArrayList for storing Provider Info data from database
            ResultSet rows = details.getRecords(ID); //getRecords method of getUserDetails class takes value as parameter and returns a ResultSet object
            
            try{
                
                ProviderInfo eachrecord;
                
                while(rows.next()){
                    eachrecord = new ProviderInfo(rows.getInt("Provider_ID"),rows.getString("First_Name"), rows.getString("Middle_Name"), rows.getString("Last_Name"), rows.getDate("Date_Of_Birth"), rows.getString("Phone_Number"),
                                                    rows.getString("Company"), rows.getInt("Ratings"), rows.getString("Service_Type"), rows.getString("First_Name") + " - " +rows.getString("Company"),rows.getBlob("Profile_Pic"), rows.getString("Email"));
                    
                    providersList.add(eachrecord);
                }
            }catch(Exception e){
                e.printStackTrace();
            }
            
        %>
             
        <%
            //getting first reviews
            ArrayList<ReviewsDataModel> ReviewsList = new ArrayList<>();
        
        try{
            Class.forName(Driver);
            Connection ReviewsConn = DriverManager.getConnection(url, User, Password);
            String ReviewString = "Select * from QueueServiceProviders.ProviderCustomersReview where ProviderID = ? order by ReviewID desc";
            PreparedStatement ReviewPst = ReviewsConn.prepareStatement(ReviewString);
            ReviewPst.setString(1, ID);
            
            ResultSet ReviewRec = ReviewPst.executeQuery();
            
            ReviewsDataModel eachReview;
            
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
        
        CurrentProvsName = providersList.get(0).getFirstName().trim(); //+ " " + providersList.get(0).getMiddleName().trim() + " " + providersList.get(0).getLastName().trim();
        
        String status = "not_added";
        
            //getting the subscription status
            try{
                Class.forName(Driver);
                Connection SubsConn = DriverManager.getConnection(url, User, Password);
                String SubsString = "select status from QueueObjects.StripSubscriptions where ProvId = ?";
                PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);

                SubsPst.setString(1, ID);

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
    %>
   
    <%

            if(status.equalsIgnoreCase("inactive") || status.equalsIgnoreCase("not_added")){
    %>
                                        
            <script>
                alert("Oops! You cannot continue.\nThis account is not active at this time.\nTry again later.");
                window.history.go(-1);
            </script>
                                        
    <%
            }
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        <div id='QShowNews22' style='width: fit-content; bottom: 5px; margin-left: 4px; position: fixed; background-color: #3d6999; padding: 5px 9px; border-radius: 50px;
                 box-shadow: 0 0 5px 1px black;'>
                <center><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp"><p  
                    style='color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0; width:'>
                        <img style='background-color: white; width: 25px; height: 24px; border-radius: 4px;' src="icons/icons8-home-50.png" alt="icons8-home-50-50"/>
                </p>
                <p style='font-size: 15px; color: white; margin-top: -5px;'>Home</p>
                </a></center>
            </div>
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
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <!--a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp"><li><img src="icons/icons8-home-24.png" width="24" height="24" alt="icons8-home-24"/>
                            </li></a-->
                        <li onclick="scrollToTop()"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="padding: 5px;" placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                            <input onclick="document.getElementById('PageLoader').style.display = 'block';"  type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="PageController" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
        </div>
            
        <div id="main_body_flex">
            
        <div id="Extras">
            
            <div id="ExtrasInnerContainer">
                <%
                    int newsItems = 0;
                    int CurrentProvID = 0;
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select top 10 * from QueueServiceProviders.MessageUpdates where ProvID = ? and VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        newsPst.setString(1, ID);
                        ResultSet newsRec = newsPst.executeQuery();
                        
                        while(newsRec.next()){
                            
                            newsItems++;
                            
                            String ProvID = newsRec.getString("ProvID");
                            CurrentProvID = Integer.parseInt(ProvID);
                            String ProvFirstName = "";
                            String ProvCompany = "";
                            String ProvAddress = "";
                            String ProvTel = "";
                            String ProvEmail = "";
                            
                            String DateOfUpdate = newsRec.getString("DateOfUpdate").trim();
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            Date date = sdf.parse(DateOfUpdate);
                            String day = date.toString().substring(0,3);
                            SimpleDateFormat sdf2 = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMM dd");
                            DateOfUpdate = day + ", " + sdf2.format(date);
                            
                            
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
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 5px;">
                        <tbody>
                            <tr style="background-color: #eeeeee;">
                                <td>
                                    <div id="ProvMsgBxOne">
                                        
                                        <div style='font-weight: bolder;'>
                                            <div>
                                                <p><%=ProvFirstName%></p>
                                                <p style='color: red;'><%=ProvCompany%></p>
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

                
                if(newsItems < 10){

                    if(newsItems == 0){

                %>
                
                        <p style="color: white; text-align: center;"><i style="color: yellow;" class="fa fa-exclamation-triangle" aria-hidden="true"></i> <%=CurrentProvsName%> has not posted any news updates</p>
                    <%}%>
                    
                <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin: 20px 0;">Others updates</p></center>
                
                <%
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(url, User, Password);
                            String newsQuery2 = "Select top 10 * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
                            ResultSet newsRec = newsPst.executeQuery();

                            while(newsRec.next()){

                                if(CurrentProvID == Integer.parseInt(newsRec.getString("ProvID")))
                                    continue;
                                
                                newsItems++;
                                String base64Profile = "";

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
                                                    <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                        <img class="fittedImg" id="" style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    <!--/div></center-->
                                                <%
                                                    }else{
                                                %>

                                                <!--center><div style="width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;"-->
                                                    <img style='margin: 4px; width:35px; height: 35px; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <!--/div></center-->

                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <p><%=ProvFirstName%></p>
                                                <p style='color: red;'><%=ProvCompany%></p>
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
            
                }
            %>
            </div>
            </div>
            
            
        <div id="content">
            
            <div id="nav">
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <h4><a href="LoginPageToQueue" style=" color: #000099;">Queue</a></h4-->
                <!--h3>Your Dashboard</a></h3-->
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Search" name="SearchBtn" />
                    </form> 
                        
                </div></center> 
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                <center><div id="providerlist">
                <center><table id="providerdetails" style="">
                        
                    <%
                        
                        for(int i = 0; i < providersList.size(); i++){ 
                            
                            String fullName = providersList.get(i).getFirstName() + " " + providersList.get(i).getMiddleName() + " " + providersList.get(i).getLastName();
                            String Company = providersList.get(i).getCompany();
                            String Email = providersList.get(i).getEmail();
                            String phoneNumber = providersList.get(i).getPhoneNumber();
                           
                                                    
                            String base64Image = "";
                            String base64Cover = "";

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

                                base64Image = Base64.getEncoder().encodeToString(imageBytes);


                            }
                            catch(Exception e){

                            }
                            
                            int PID = providersList.get(i).getID();
                            
                            try{
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String selectAddress = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                                PreparedStatement pst = conn.prepareStatement(selectAddress);
                                pst.setInt(1,PID);
                                ResultSet address = pst.executeQuery();

                                while(address.next()){
                                    providersList.get(i).setAddress(address.getInt("House_Number"), address.getString("Street_Name"), address.getString("Town"),address.getString("City"),address.getString("Country"),address.getInt("Zipcode"));
                                }
                                
                            }catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            String fullAddress = "address information not found";
                            try{
                                
                                int hNumber = providersList.get(i).Address.getHouseNumber();
                                String sName = providersList.get(i).Address.getStreet().trim(); //trim values to remove extra spaces
                                String tName = providersList.get(i).Address.getTown().trim();
                                String cName = providersList.get(i).Address.getCity().trim();
                                String coName = providersList.get(i).Address.getCountry().trim();
                                int zCode = providersList.get(i).Address.getZipcode();
                                fullAddress = Integer.toString(hNumber) + " " + sName + ", " + tName + ", " + cName + ", " + coName + " " + Integer.toString(zCode);

                            }catch(Exception e){}
                            
                            int ratings = providersList.get(i).getRatings();
                            
                            String SundayTime = "";//stores both the start time and the close time
                            String MondayTime = "";
                            String TuesdayTime = "";
                            String WednessdayTime = "";
                            String ThursdayTime = "";
                            String FridayTime = "";
                            String SaturdayTime = "";
                            
                            try{
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String services = "Select * from QueueServiceProviders.ServicesAndPrices where ProviderID = ?";
                                PreparedStatement pst = conn.prepareStatement(services);
                                pst.setInt(1,PID);
                                ResultSet list = pst.executeQuery();
                                
                                //always make sure there isn't any records already in the SVCPRC field of the class
                                if(providersList.get(i).SVCPRC.getNumberOfServices() == 0){
                                    
                                    while(list.next()){
                                        providersList.get(i).SVCPRC.setServicesAndPrices(list.getString("ServiceName"), list.getString("Price"));
                                        providersList.get(i).SVCPRC.setDuration(list.getInt("ServiceDuration"));
                                    providersList.get(i).SVCPRC.setDescription(list.getString("ServiceDescription"));
                                    }
                                    
                                }

                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            try{
                                
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String statement = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                PreparedStatement pst = conn.prepareStatement(statement);
                                pst.setInt(1,PID);
                                ResultSet hours = pst.executeQuery();
                                
                                while(hours.next()){
                                    
                                    int Hour = 0;
                                    
                                    String SundayStart = hours.getString("SundayStart").substring(0,5);//getting rid of extra zeros from data
                                    if(Integer.parseInt(SundayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(SundayStart.substring(0,2)) - 12;
                                        SundayStart = Integer.toString(Hour) + SundayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(SundayStart.substring(0,2)) == 00){
                                        SundayStart = "12" + SundayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(SundayStart.substring(0,2)) == 12){
                                        SundayStart = "12" + SundayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        SundayStart += " am";
                                    }

                                    String SundayClose = hours.getString("SundayClose").substring(0,5);
                                    if(Integer.parseInt(SundayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(SundayClose.substring(0,2)) - 12;
                                        SundayClose = Integer.toString(Hour) + SundayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(SundayClose.substring(0,2)) == 00){
                                        SundayClose = "12" + SundayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(SundayClose.substring(0,2)) == 12){
                                        SundayClose = "12" + SundayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        SundayClose += " am";
                                    }

                                    String MondayStart = hours.getString("MondayStart").substring(0,5);
                                    if(Integer.parseInt(MondayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(MondayStart.substring(0,2)) - 12;
                                        MondayStart = Integer.toString(Hour) + MondayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(MondayStart.substring(0,2)) == 00){
                                        MondayStart = "12" + MondayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(MondayStart.substring(0,2)) == 12){
                                        MondayStart = "12" + MondayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        MondayStart += " am";
                                    }


                                    String MondayClose = hours.getString("MondayClose").substring(0,5);
                                    if(Integer.parseInt(MondayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(MondayClose.substring(0,2)) - 12;
                                        MondayClose = Integer.toString(Hour) + MondayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(MondayClose.substring(0,2)) == 00){
                                        MondayClose = "12" + MondayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(MondayClose.substring(0,2)) == 12){
                                        MondayClose = "12" + MondayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        MondayClose += " am";
                                    }


                                    String TuesdayStart = hours.getString("TuesdayStart").substring(0,5);
                                    if(Integer.parseInt(TuesdayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(TuesdayStart.substring(0,2)) - 12;
                                        TuesdayStart = Integer.toString(Hour) + TuesdayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(TuesdayStart.substring(0,2)) == 00){
                                        TuesdayStart = "12" + TuesdayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(TuesdayStart.substring(0,2)) == 12){
                                        TuesdayStart = "12" + TuesdayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        TuesdayStart += " am";
                                    }


                                    String TuesdayClose = hours.getString("TuesdayClose").substring(0,5);
                                    if(Integer.parseInt(TuesdayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(TuesdayClose.substring(0,2)) - 12;
                                        TuesdayClose = Integer.toString(Hour) + TuesdayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(TuesdayClose.substring(0,2)) == 00){
                                        TuesdayClose = "12" + TuesdayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(TuesdayClose.substring(0,2)) == 12){
                                        TuesdayClose = "12" + TuesdayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        TuesdayClose += " am";
                                    }

                                    String WeddayClose = hours.getString("WednessdayClose").substring(0,5);
                                    if(Integer.parseInt(WeddayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(WeddayClose.substring(0,2)) - 12;
                                        WeddayClose = Integer.toString(Hour) + WeddayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(WeddayClose.substring(0,2)) == 00){
                                        WeddayClose = "12" + WeddayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(WeddayClose.substring(0,2)) == 12){
                                        WeddayClose = "12" + WeddayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        WeddayClose += " am";
                                    }


                                    String WeddayStart = hours.getString("WednessdayStart").substring(0,5);
                                    if(Integer.parseInt(WeddayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(WeddayStart.substring(0,2)) - 12;
                                        WeddayStart = Integer.toString(Hour) + WeddayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(WeddayStart.substring(0,2)) == 00){
                                        WeddayStart = "12" + WeddayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(WeddayStart.substring(0,2)) == 12){
                                        WeddayStart = "12" + WeddayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        WeddayStart += " am";
                                    }


                                    String ThursdayStart = hours.getString("ThursdayStart").substring(0,5);
                                    if(Integer.parseInt(ThursdayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(ThursdayStart.substring(0,2)) - 12;
                                        ThursdayStart = Integer.toString(Hour) + ThursdayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(ThursdayStart.substring(0,2)) == 00){
                                        ThursdayStart = "12" + ThursdayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(ThursdayStart.substring(0,2)) == 12){
                                        ThursdayStart = "12" + ThursdayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        ThursdayStart += " am";
                                    }


                                    String ThursdayClose = hours.getString("ThursdayClose").substring(0,5);
                                    if(Integer.parseInt(ThursdayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(ThursdayClose.substring(0,2)) - 12;
                                        ThursdayClose = Integer.toString(Hour) + ThursdayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(ThursdayClose.substring(0,2)) == 00){
                                        ThursdayClose = "12" + ThursdayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(ThursdayClose.substring(0,2)) == 12){
                                        ThursdayClose = "12" + ThursdayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        ThursdayClose += " am";
                                    }


                                    String FridayStart = hours.getString("FridayStart").substring(0,5);
                                    if(Integer.parseInt(FridayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(FridayStart.substring(0,2)) - 12;
                                        FridayStart = Integer.toString(Hour) + FridayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(FridayStart.substring(0,2)) == 00){
                                        FridayStart = "12" + FridayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(FridayStart.substring(0,2)) == 12){
                                        FridayStart = "12" + FridayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        FridayStart += " am";
                                    }


                                    String FridayClose = hours.getString("FridayClose").substring(0,5);
                                    if(Integer.parseInt(FridayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(FridayClose.substring(0,2)) - 12;
                                        FridayClose = Integer.toString(Hour) + FridayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(FridayClose.substring(0,2)) == 00){
                                        FridayClose = "12" + FridayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(FridayClose.substring(0,2)) == 12){
                                        FridayClose = "12" + FridayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        FridayClose += " am";
                                    }


                                    String SaturdayStart = hours.getString("SaturdayStart").substring(0,5);
                                    if(Integer.parseInt(SaturdayStart.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(SaturdayStart.substring(0,2)) - 12;
                                        SaturdayStart = Integer.toString(Hour) + SaturdayStart.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(SaturdayStart.substring(0,2)) == 00){
                                        SaturdayStart = "12" + SaturdayStart.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(SaturdayStart.substring(0,2)) == 12){
                                        SaturdayStart = "12" + SaturdayStart.substring(2,5) + " pm";
                                    }
                                    else{
                                        SaturdayStart += " am";
                                    }


                                    String SaturdayClose = hours.getString("SaturdayClose").substring(0,5);
                                    if(Integer.parseInt(SaturdayClose.substring(0,2)) > 12){
                                        Hour = Integer.parseInt(SaturdayClose.substring(0,2)) - 12;
                                        SaturdayClose = Integer.toString(Hour) + SaturdayClose.substring(2,5) + " pm";
                                    }
                                    else if(Integer.parseInt(SaturdayClose.substring(0,2)) == 00){
                                        SaturdayClose = "12" + SaturdayClose.substring(2,5) + " am";
                                    }
                                    else if(Integer.parseInt(SaturdayClose.substring(0,2)) == 12){
                                        SaturdayClose = "12" + SaturdayClose.substring(2,5) + " pm";
                                    }
                                    else{
                                        SaturdayClose += " am";
                                    }


                                    SundayTime = " " + SundayStart + " - " + SundayClose;
                                    if(SundayStart.equals("12:00 am") && SundayClose.equals("12:00 am"))
                                        SundayTime = " Closed on Sundays";
                                    MondayTime = " " + MondayStart + " - " + MondayClose;
                                        if(MondayStart.equals("12:00 am") && MondayClose.equals("12:00 am"))
                                            MondayTime = " Closed on Mondays";
                                    TuesdayTime = " " + TuesdayStart + " - " + TuesdayClose;
                                        if(TuesdayStart.equals("12:00 am") && TuesdayClose.equals("12:00 am"))
                                            TuesdayTime = " Closed on Tuesdays";
                                    WednessdayTime = " " + WeddayStart + " - " + WeddayClose;
                                        if(WeddayStart.equals("12:00 am") && WeddayClose.equals("12:00 am"))
                                            WednessdayTime = " Closed on Wednesdays";
                                    ThursdayTime = " " + ThursdayStart + " - " + ThursdayClose;
                                        if(ThursdayStart.equals("12:00 am") && ThursdayClose.equals("12:00 am"))
                                            ThursdayTime = " Closed on Thursdays";
                                    FridayTime = " " + FridayStart + " - " + FridayClose;
                                        if(FridayStart.equals("12:00 am") && FridayClose.equals("12:00 am"))
                                            FridayTime = " Closed on Fridays";
                                    SaturdayTime = " " + SaturdayStart + " - " + SaturdayClose;
                                        if(SaturdayStart.equals("12:00 am") && SaturdayClose.equals("12:00 am"))
                                            SaturdayTime = " Closed on Saturdays";
                                    
                                }
                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                    %>
                    
                    <%
                        //getting coverdata
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,PID);
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
                    
                    <%
                       //getting galleryphotos
                       
                       ArrayList<String> Base64GalleryPhotos = new ArrayList<>();
                       
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =? order by PicID desc";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,PID);
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
                                break;
                                
                            }
                            
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                        
                          
                        
                        String seventhPic = "";
                        
                        try{
                            seventhPic = Base64GalleryPhotos.get(0);
                            
                        }catch(Exception e){}

                    %>
                    
                    <tbody>
                        <tr>
                            <td  style="padding: 0 !important; overflow: hidden;">
                                
                                <center>
                                <div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                    <div class='MainPropicContainer' style='width: 150px; height: 150px; overflow: hidden;'>
                                        <img style='width: 150px; height: auto; min-height: 150px;' src="data:image/jpg;base64,<%=base64Image%>" />
                                    </div>
                                </div></center>
                    
                            <div class="proinfo" style="padding-left: 0;">
                                
                                <table id="ProInfoTable" style="width: 100%; border-spacing: 0; box-shadow: 0; margin-left: 0; margin-bottom: 10px;">
                                <tbody>
                                <tr>
                                    <td>
                                        <p style="font-size: 20px; text-align: center;">
                                            <span style="color: #3d6999; font-weight: bolder;"><!--img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/-->
                                                <%=fullName%>
                                            </span>
                                        </p>
                                        <p style="text-align: center; margin-top: -4px; color: #636363;"><!--img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/-->
                                            <small><%=Company%></small> 
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="width: 100%; display: flex; flex-direction: row; justify-content: center;">
                                            <div>
                                                <a style="color: seagreen;" href="https://maps.google.com/?q=<%=fullAddress%>" target="_blank">
                                                    <i class="fa fa-location-arrow" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                   font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">map</span></i>
                                                </a>
                                                <!--img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                                <=fullAddress-->
                                            </div>
                                            <div>
                                                <a style="color: seagreen;" href="tel:<%=phoneNumber%>">
                                                    <i class="fa fa-phone" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                    font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">call</span></i>
                                                </a>
                                            </div>
                                            <div>
                                                <a style="color: seagreen;" href="mailto:<%=Email%>">
                                                    <i class="fa fa-envelope" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                    font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">email</span></i>
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <!--tr>
                                    <td>
                                        <div style="width: 95%; display: flex; flex-direction: row; justify-content: space-between; max-width: 400px;">
                                            <p><img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                                <=Email%>
                                            </p>
                                            <a style="color: seagreen;" href="mailto:<=Email%>">
                                                <i class="fa fa-envelope" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">email</span></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="width: 95%; display: flex; flex-direction: row; justify-content: space-between; max-width: 400px;">
                                            <p><img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                                <=phoneNumber%>
                                            </p>
                                            <a style="color: seagreen;" href="tel:<=phoneNumber%>">
                                                <i class="fa fa-phone" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">call</span></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="width: 95%; display: flex; flex-direction: row; justify-content: space-between; max-width: 400px;">
                                            <p><img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                                <=fullAddress.split(",")[0]%>
                                            </p>
                                            <a style="color: seagreen;" href="https://maps.google.com/?q=<=fullAddress%>" target="_blank">
                                                <i class="fa fa-location-arrow" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                               font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">map</span></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr-->
                                <tr>
                                    <td>
                                        <%if(ReviewsList.size() != 0){%>
                                        <!--p style="text-align: center; color: tomato;">Last Review</p-->
                                        <%}%>
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
                                        String CustomerFullName = "";
                                        String Base64Image = "";

                                        try{

                                            Class.forName(Driver);
                                            Connection ReviewCustConn = DriverManager.getConnection(url, User, Password);
                                            String CustString = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                                            PreparedStatement CustInfoPst = ReviewCustConn.prepareStatement(CustString);
                                            CustInfoPst.setInt(1, CustomerID);

                                            ResultSet CustRec = CustInfoPst.executeQuery();

                                            while(CustRec.next()){

                                                String FirstName = CustRec.getString("First_Name").trim();
                                                String MiddleName = CustRec.getString("Middle_Name").trim();
                                                String LastName = CustRec.getString("Last_Name").trim();

                                                CustomerFullName = FirstName + " " + MiddleName + " " + LastName;


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

                                         <center><div style='padding: 1px; margin-top: 5px; padding-bottom: 10px; margin-bottom: 1px; width: 99%; margin-left: 0;'>
                    
                            <p style="font-size: 20px; color: #37a0f5; font-weight: bolder; text-align: center; margin-bottom: 10px;">
                                                        <span style="color: tomato;">Overall Rating: </span>
                                                        <span style="font-size: 20px; margin-left: 10px;">
                                                        <%
                                                            if(ratings ==5){

                                                        %> 
                                                        ★★★★★ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #334d81; font-size: 10px;"> Recommended</span></i>
                                                        <%
                                                             }else if(ratings == 4){
                                                        %>
                                                        ★★★★☆ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #334d81; font-size: 10px;"> Recommended</span></i>
                                                        <%
                                                             }else if(ratings == 3){
                                                        %>
                                                        ★★★☆☆ 
                                                        <i class="fa fa-thumbs-up" style="color: yellow; font-size: 16px; margin-left: 20px;"><span style="color: #334d81; font-size: 10px;"> Average</span></i>
                                                        <%
                                                             }else if(ratings == 2){
                                                        %>
                                                        ★★☆☆☆ 
                                                        <i class="fa fa-exclamation-triangle" style="color: red; font-size: 17px; margin-left: 20px;"><span style="color: #334d81; font-size: 10px;"> Bad rating</span></i>
                                                        <%
                                                             }else if(ratings == 1){
                                                        %>
                                                        ★☆☆☆☆   
                                                        <i class="fa fa-thumbs-down" aria-hidden="true" style="color: red; font-size: 16px; margin-left: 20px;"><span style="color: #334d81; font-size: 10px;"> Worst rating</span></i>
                                                        <%}%>
                                                        </span>
                                                        
                                                    </p>
                                                    
                                 
                            <p style="text-align: center; color: #8b8b8b; margin: 10px; margin-top: 20px;">Last Review (<%=ReviewStringDate%>)</p>
                            <div style="display: flex; flex-direction: row; justify-content: center;">
                                
                                <%
                                    if(Base64Image == ""){
                                %> 
                                    
                                    <img style="border-radius: 100%; width: 50px; height: 50px;" src="icons/icons8-user-filled-50.png" alt="icons8-user-filled-50"/>
                                    
                                <%
                                    }else{
                                %>
                                    <div style="border-radius: 100%; margin-left: 5px; min-width: 50px; height: 50px; overflow: hidden;">
                                        <img style="width: 50px; height: auto;" src="data:image/jpg;base64,<%=Base64Image%>"/>
                                    </div>
                                <%
                                    }
                                %>
                                <div style='margin-left: 10px;'>                 
                                    <p style='color: #334d81; text-align: left; margin-top: 10px; margin-bottom: 5px; margin-left: 0; font-weight: bolder;'><%=CustomerFullName%></p>

                                    <!--p style='color: darkgray; text-align: left; margin: 0;'><span style="color: #334d81; font-size: 18px;">
                                                    
                                
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
                                        <%}%>
                                        </span>
                                    </p-->

                        <%
                            if(!ReviewMessage.equals("")){
                        %>
                                    <p style='color: darkgray; text-align: left; margin: 0;'><span style='color: #626b9e;'><%=ReviewMessage%></span></p>

                        <%}%>
                                    <a onclick="document.getElementById('PageLoader').style.display = 'block';" href='ViewSelectedProviderReviews.jsp?Provider=<%=ProviderID%>'><p style='clear: both; text-align: center; color: #334d81; cursor: pointer; padding-top: 20px;'>See More...</p></a>
                        </div>
                    </div>
        </div></center>


                        <%}%>

                                    </td>
                                </tr>
                                </tbody>
                                </table>
                                        
                                        <%
                                            if(seventhPic != ""){
                                        %>
                                         
                                        <div id="GalleryThumnail" style="margin: 0 10px; margin-bottom: 20px; box-shadow: 0px 1.6px 3.6px rgba(0, 0, 0, 0.3), 0px 0px 2.9px rgba(0, 0, 0, 0.33); border-radius: 4px; overflow: hidden;">
                                        
                                        <%
                                            if(seventhPic != ""){
                                        %>
                                            <div style="background-image: url('data:image/jpg;base64,<%=seventhPic%>'); background-size: cover; background-position: center; background-repeat: no-repeat;
                                                 background-repeat: no-repeat; padding: 0 10px; height: 200px; cursor: pointer; display: flex; flex-direction: column; justify-content: center;">
                                                <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ViewProviderPhotos.jsp?Provider=<%=ProviderID%>">
                                                    <p style="color: white; text-align: center; background-color: #626b9e; padding: 10px; border-radius: 4px; margin: auto; width: fit-content;">
                                                        <i style="margin-right: 5px;" class="fa fa-picture-o" aria-hidden="true"></i>
                                                        <% String aName = fullName.split(" ")[0];%>
                                                        click here to see <span style='font-weight: bolder;'><%=aName%></span>'s photos
                                                    </p>
                                                </a>
                                            </div>
                                        <%}%>
                                        </div>
                                             
                                        <%}%>
                                </div>
                                
                                <div id="serviceslist" style="border: 0; padding-bottom: 20px;">
                                    
                                    <p style="color: #254386; font-weight: bolder; text-align: center; padding: 20px 0;">Hours Open</p>
                                    <table id="hoursTable" style="border-spacing: 0; box-shadow: 0; margin-left: 0;  width: 100%;">
                                        <tbody>
                                        <tr>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="SunTime" style="color: #334d81; text-align: center;">Sunday: </p><%= SundayTime%>
                                            </td>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="ThuTime" style="color: #334d81; text-align: center;">Thursday: </p><%= ThursdayTime%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="MonTime" style="color: #334d81; text-align: center;">Monday: </p><%= MondayTime%>
                                            </td>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="FriTime" style="color: #334d81; text-align: center;">Friday: </p><%= FridayTime%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="TueTime" style="color: #334d81; text-align: center;">Tuesday: </p><%= TuesdayTime%>
                                            </td>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="SatTime" style="color: #334d81; text-align: center;">Saturday: </p><%= SaturdayTime%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 10px; text-align: center;">
                                                <p id="WedTime" style="color: #334d81; text-align: center;">Wednesday: </p><%= WednessdayTime%>
                                            </td>
                                            <td style="">
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                            
                                    <script>
                                            var todate_for_hours_open = new Date();
                                            TodaySpan = document.createElement("span");
                                            TodaySpan.innerHTML = '<i style="margin-left: 10px;" class="fa fa-long-arrow-left" aria-hidden="true"></i>';
                                            //alert(todate_for_hours_open);
                                                
                                            var this_day_for_hours_open = todate_for_hours_open.getDay();;
                                                
                                            if(this_day_for_hours_open === 0){
                                                document.getElementById("SunTime").style.color = "Red";
                                                document.getElementById("SunTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 1){
                                                document.getElementById("MonTime").style.color = "Red";
                                                document.getElementById("MonTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 2){
                                                document.getElementById("TueTime").style.color = "Red";
                                                document.getElementById("TueTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 3){
                                                document.getElementById("WedTime").style.color = "Red";
                                                document.getElementById("WedTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 4){
                                                document.getElementById("ThuTime").style.color = "Red";
                                                document.getElementById("ThuTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 5){
                                                document.getElementById("FriTime").style.color = "Red";
                                                document.getElementById("FriTime").appendChild(TodaySpan);
                                            }else if(this_day_for_hours_open === 6){
                                                document.getElementById("SatTime").style.color = "Red";
                                                document.getElementById("SatTime").appendChild(TodaySpan);
                                            }
                                                
                                                
                                    </script>
                                        
                                </div> 
                                        
                                     <div id="serviceslist" style='border: none; background: none;' class="servicesList">
                                         
                                        <form action="FinishAppointment.jsp" method="POST">
                                        <p style="color: #334d81; font-weight: bolder; padding: 15px 0; text-align: center;">
                                            Select service(s) to continue<%=For%><%=FormattedAppointmentTime%>
                                        </p>
                                     
                                        <% 
                                            
                                            //getting Services list
                                            int listcounter = 0;
                                            
                                            for(int j = 0; j < providersList.get(i).SVCPRC.getNumberOfServices(); j++){
                                                
                                                listcounter++; //List counter starts from one (1) not zero(0) as initialized to
                                                
                                                int Jincrement = j + 1;
                                                
                                                String Number = Integer.toString(Jincrement);
                                                
                                                //concatenate list counter number with provided name to assing unique names to request parameter objects
                                                String CheckboxName = "CheckboxOfServiceNo" + Integer.toString(listcounter);
                                                String NameOfService = "NameOfServiceNo" + Integer.toString(listcounter);
                                                String PriceOfService = "PriceOfServiceNo" + Integer.toString(listcounter);
                                                
                                                String Description = providersList.get(i).SVCPRC.getDescription(j).trim();
                                                String ServiceAndPrice = providersList.get(i).SVCPRC.getService(j) + " - $" + providersList.get(i).SVCPRC.getPrice(j);
                                        
                                        %>
                                        
                                            <div style="border-radius: 4px; padding: 10px; display: flex; flex-direction: row; justify-content: space-between;">
                                                <div style='display: flex;'>
                                                    <input style="min-width: 17px;" onclick="enableBkAppBtn(<%=Number%>)" type="checkbox" id="<%=CheckboxName%>" name="<%=CheckboxName%>" value="Checked" />
                                                    <p><label for="<%=CheckboxName%>" style='color: #334d81;'> 
                                                            <span style='font-weight: bolder;'><%=ServiceAndPrice%></span> - <%=Description%>
                                                        </label>
                                                    <p>
                                                </div>
                                                <p>
                                                    <label for="<%=CheckboxName%>">
                                                        <i id="AddonPlus<%=Number%>" style="font-size: 30px; color: darkslateblue; margin-left: 10px;" class="fa fa-plus-square" aria-hidden="true"></i>
                                                        <i id="AddonMinus<%=Number%>" style="font-size: 30px; color: red; margin-left: 10px; display: none;" class="fa fa-minus-square" aria-hidden="true"></i>
                                                    </label>
                                                </p>
                                            </div>
                                            
                                            
                                            <input type="hidden" name="<%=NameOfService%>" value="<%=providersList.get(i).SVCPRC.getService(j).trim()%>" />
                                            <input type="hidden" name="<%=PriceOfService%>" value="<%=providersList.get(i).SVCPRC.getPrice(j)%>" />
                                            
                                            
                                        <%} //end of for loop for services and prices list items %>
                                        
                                          <%
                                            
                                            if(providersList.get(i).SVCPRC.getNumberOfServices() == 0){
                                                
                                             
                                        %>
                                        
                                        <p style="color: darkblue; font-weight: bolder; text-align: center;"><i style="color: red" class="fa fa-exclamation-triangle"></i> This provider has no service to select. You cannot continue.</p>
                                        
                                        <%}%>
                                           
                                        <p id="SVCSelectStatus" style="color: darkblue; font-weight: bolder; margin: 15px 0 !important; text-align: center"></p>
                                        
                                            <input type="hidden" id="totallist" name="totallist" value="<%=listcounter%>" />
                                            <input type="hidden" name="UserID" value="<%=PID%>" />
                                            <input type="hidden" name="AppointmentTime" value="<%=AppointmentTime%>" />
                                            <center><input style="border: none; background-color: darkslateblue; border-radius: 4px; color: white; margin-top: 10px;
                                                   padding: 10px;" id="BookAppointmentBtn"
                                                  onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Continue" name="BookAppointmentBtn" /></center>
                                            </form>
                                    </div>
                            </td> 
                        </tr>
                    </tbody>
                            <%}//end of for overall loop%>
                    </table></center>
                </div></center>
            </div>
        </div>
                    
        <div id="newbusiness">
            
            
            
            <!--p id='QShowNews2' onclick='document.getElementById("Extras2").style.display = "block";'
                style='margin-top: 10px; background-color: #334d81; color: white; padding: 5px; cursor: pointer;'>
                <i style='color: white; font-size: 35px;' class="fa fa-newspaper-o" width="28" height="25" ></i>
                <sup> Show News Updates</sup></p-->
            
            
            
            <p id='addBizTxt' style="text-align: center; font-size: 20px;  margin-bottom: 10px; margin-top: -10px;">
                <b>Add your business or create customer account</b>
            </p>
            
            <div id="businessdetails" >
                
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
                    
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                    
    </div>
                    
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/ActivateBkAppBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
