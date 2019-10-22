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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <title>Queue</title>
        
    </head>
    
    <%
        //connection arguments
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
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
    %>
   
    <body>
        
        <div id="PermanentDiv" style="">
            
            <a href="Queue.jsp" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 70px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>
                        <p><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                            Home</p></a>
            
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
        
            <ul>
                <a  href="Queue.jsp">
                    <li onclick="" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                    Home</li></a>
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
                        <a href="Queue.jsp"><li><img src="icons/icons8-home-24.png" width="24" height="24" alt="icons8-home-24"/>
                            </li></a>
                        <li onclick="scrollToTop()" style="padding-left: 2px; padding-right: 2px;"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;"
                                   placeholder="Search provider" name="SearchFld" type="text"  value="" size="30" />
                            <input style="margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;" 
                                   type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            <cetnter><p> </p></cetnter>
            <center><a href="PageController" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
        </div>
            
        <div id="Extras">
            
            <center><p style="color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;">Updates from <%=CurrentProvsName%></p></center>
            
            <div style="max-height: 600px; overflow-y: auto;">
                <%
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where ProvID = ? and VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        newsPst.setString(1, ID);
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
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 3px;">
                    <tbody>
                        <tr style="background-color: #333333;">
                            <td>
                                <div id="ProvMsgBxOne">
                                    <p style='font-weight: bolder; margin-bottom: 4px;'><span style='color: #eeeeee;'><%=DateOfUpdate%></p></p>
                                    
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
            
            
        <div id="content">
            
            <div id="nav">
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <h4><a href="LoginPageToQueue" style=" color: #000099;">Queue</a></h4-->
                <!--h3>Your Dashboard</a></h3-->
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" />
                    </form> 
                        
                </div></center> 
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                <center><div id="providerlist">
                <center><table id="providerdetails" style="border-spacing: 10px;">
                        
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
                            //put seventh photo second because it may be skipped if there isn't any
                            //second photo as try block will skip to catch clause
                            firstPic = Base64GalleryPhotos.get(1);
                            seventhPic = Base64GalleryPhotos.get(0);
                            secondPic = Base64GalleryPhotos.get(2);
                            thirdPic = Base64GalleryPhotos.get(3);  
                            fourthPic = Base64GalleryPhotos.get(4);
                            fithPic = Base64GalleryPhotos.get(5);
                            sixthPic = Base64GalleryPhotos.get(6);
                            
                        }catch(Exception e){}

                    %>
                    
                    <tbody>
                        <tr>
                            <td>
                                
                                <center><div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                    <img src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                                </div></center>
                    
                            <div class="proinfo" style="padding-left: 0;">
                                
                                <table id="ProInfoTable" style="width: 100%; border-spacing: 0; box-shadow: 0; margin-left: 0; margin-bottom: 10px;">
                                <tbody>
                                <tr>
                                    <td><b><p style="font-size: 20px; text-align: center;"><span><!--img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/-->
                                            <%=fullName%></span></p></b></td>
                                </tr>
                                <tr>
                                    <td><p style="margin-left: 0;"><img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/>
                                        <%=Company%> <span style="color: blue; font-size: 25px;">
                                       
                                        <%
                                            if(ratings ==5){
                                        
                                        %> 
                                        ★★★★★
                                        <%
                                             }else if(ratings == 4){
                                        %>
                                        ★★★★☆
                                        <%
                                             }else if(ratings == 3){
                                        %>
                                        ★★★☆☆
                                        <%
                                             }else if(ratings == 2){
                                        %>
                                        ★★☆☆☆
                                        <%
                                             }else if(ratings == 1){
                                        %>
                                        ★☆☆☆☆
                                        <%}%></span></p>
                                         </td>
                                </tr>
                                <tr>
                                    <td><img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/>
                                        <%=Email%>, <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/>
                                        <%=phoneNumber %> </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td><img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                        <%=fullAddress%> </td>
                                </tr>
                                <tr>
                                    <td>
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

                                         <center><div style='background-color: black; padding: 1px; padding-top: 10px; padding-bottom: 10px; margin-bottom: 1px; width: 100%; margin-left: 0;'>

                                            <%
                                                if(Base64Image == ""){
                                            %> 

                                            <center><img style="border-radius: 5px; float: left; width: 15%;" src="icons/icons8-user-filled-50.png" alt="icons8-user-filled-50"/>

                                                </center>

                                            <%
                                                }else{
                                            %>
                                                    <img style="border-radius: 5px; float: left; width: 15%;" src="data:image/jpg;base64,<%=Base64Image%>"/>

                                            <%
                                                }
                                            %>
                            <center><div style='float: right; width: 84%;'>                 
                            <p style='color: white; text-align: left; margin: 0; font-weight: bolder;'><%=CustomerFullName%></p>

                            <p style='color: darkgray; text-align: left; margin: 0;'>Rated: <span style="color: blue; font-size: 20px;">


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
                            </p>

                            <%
                                if(!ReviewMessage.equals("")){
                            %>
                            <p style='color: darkgray; text-align: left; margin: 0;'>Says: <span style='color: white;'><%=ReviewMessage%></span></p>

                            <p style='color: silver; float: right; margin: 0; margin-right: 5px;'><%=ReviewStringDate%></p>
                            <%}%>
                            </div></center>

                            <a href='ViewSelectedProviderReviews.jsp?Provider=<%=ProviderID%>'><p style='clear: both; text-align: center; color: greenyellow; cursor: pointer;'>See More...</p></a>

                        </div></center>

                        <%}%>

                                    </td>
                                </tr>
                                </tbody>
                                </table>
                                        
                                        <%
                                            if(firstPic != ""){
                                        %>
                                         
                                        <div style="margin-bottom: 15px; background: #eeeeee; padding: 3px; padding-top: 5px; padding-bottom: 10px; border-bottom: 1px solid darkgrey; border-top: 1px solid darkgrey;">
                                        
                                            <p style="text-align: center; color: tomato; padding-bottom: 5px;">Photo Gallery</p>
                                            
                                        <%
                                            if(seventhPic != ""){
                                        %>
                                            
                                            <center><img src="data:image/jpg;base64,<%=seventhPic%>" width="100%" height="300" style="max-width: 350px; margin-bottom: 0;  border-radius: 5px;"/></center>
                                         
                                        <%}%>
                                            <center><table style=" width: 100%; max-width: 350px; margin-top: 0;">
                                               
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
                                                    <td style="width: 100px; height: 110px; background-image: url('data:image/jpg;base64,<%=sixthPic%>'); background-size: cover; box-shadow: 0 0 0 0; border-radius: 0; border-radius: 5px;">
                                                        <div style="background-color: black; opacity: 0.7; width: 96%; height: 96%; cursor: pointer; margin-left: 2px;">
                                                            <a href="ViewProviderPhotos.jsp?Provider=<%=ProviderID%>"><p style="color: white; text-align: center; padding-top: 20px;"><img src="icons/icons8-photo-gallery-20 (1).png" width="20" height="20" alt="icons8-photo-gallery-20 (1)"/>
                                                            </p>
                                                            <p style="color: white; text-align: center;">View Photos</p></a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table></center>
                                        </div>
                                             
                                        <%}%>
                                </div>
                                
                                <div id="serviceslist" style="padding-bottom: 5px; border: 0;">
                                    
                                    <center><p style="color: tomato; text-align: center;">Hours Open</p>
                                    <table id="hoursTable" style="border-spacing: 0; box-shadow: 0; margin-left: 0;  width: 100%;">
                                        <tbody>
                                        <tr><td style="padding: 0; background-color: #eeeeee; border-top: darkgray 1px solid;"><p style="color: blue;">Sunday: </p><%= SundayTime%></td><td style="padding: 0; background-color: #eeeeee; border-top: darkgray 1px solid;"><p style="color: blue;">Thursday: </p><%= ThursdayTime%></td></tr>
                                        <tr><td style=" border-top: darkgray 1px solid;"><p style="color: blue;">Monday: </p><%= MondayTime%></td><td style="border-top: darkgray 1px solid;"><p style="color: blue;">Friday: </p><%= FridayTime%></td></tr>
                                        <tr><td style="background-color: #eeeeee; border-top: darkgray 1px solid;"><p style="color: blue;">Tuesday: </p><%= TuesdayTime%></td><td style="background-color: #eeeeee; border-top: darkgray 1px solid;"><p style="color: blue;">Saturday: </p><%= SaturdayTime%></td></tr>
                                        <tr><td style="border-top: darkgray 1px solid;"><p style="color: blue;">Wednesday: </p><%= WednessdayTime%></td><td style=" border-top: darkgray 1px solid;"></td></tr>
                                        </tbody></center>
                                    </table>
                                        
                                </div> 
                                        
                                     <div id="serviceslist" class="servicesList">
                                         
                                        <form action="FinishAppointment.jsp" method="POST">
                                        <p style="color: tomato;">Select service(s) to continue<%=For%><%=FormattedAppointmentTime%></p>
                                     
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
                                        
                                            <p style="border: 1px solid black; text-align: center; background-color: pink; padding: 5px;"><input style="float: left; " onclick="enableBkAppBtn(<%=Number%>)" type="checkbox" id="<%=CheckboxName%>" name="<%=CheckboxName%>" value="Checked" />
                                                <label for="<%=CheckboxName%>"> <%=ServiceAndPrice%>,<span style="color: #000099;"> <%=Description%></span></label></p>
                                            <input type="hidden" name="<%=NameOfService%>" value="<%=providersList.get(i).SVCPRC.getService(j).trim()%>" />
                                            <input type="hidden" name="<%=PriceOfService%>" value="<%=providersList.get(i).SVCPRC.getPrice(j)%>" />
                                            
                                        <%} //end of for loop for services and prices list items %>
                                        
                                          <%
                                            
                                            if(providersList.get(i).SVCPRC.getNumberOfServices() == 0){
                                                
                                             
                                        %>
                                        
                                        <p style="background-color: red; color: white; text-align: center;">This provider has no service to select. You cannot continue.</p>
                                        
                                        <%}%>
                                           
                                        <p id="SVCSelectStatus" style="background-color: red; color: white; text-align: center;"></p>
                                        
                                            <input type="hidden" id="totallist" name="totallist" value="<%=listcounter%>" />
                                            <input type="hidden" name="UserID" value="<%=PID%>" />
                                            <input type="hidden" name="AppointmentTime" value="<%=AppointmentTime%>" />
                                            <center><input style="border: black solid 1px; background-color: red; border-radius: 5px; color: white;
                                                   padding: 5px;" id="BookAppointmentBtn"
                                                   type="submit" value="Continue" name="BookAppointmentBtn" /></center>
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
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Sign-up with Queue to add your business or to find a line spot</h2></center>
            <div id="businessdetails">
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST"><table border="0">
                        <tbody>
                            <tr>
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input id="signUpFirtNameFld" placeholder="enter your first name" type="text" name="firstName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="sigUpLastNameFld" placeholder="enter your last name" type="text" name="lastName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="50"/></td>
                            </tr>
                        </tbody>
                    </table>
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" type="submit" value="Submit" name="submitBtn" />
                </form></center>
            </div>
                    <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Already with Queue (Login to view and manage your spots)</h2></center>
            <center><div id ="logindetails">
                    <form name="login" action="LoginControllerMain" method="POST"><table border="0"> 
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="enter your password here" type="password" name="password" value="" size="51"/></td>
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
    <script src="scripts/ActivateBkAppBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
