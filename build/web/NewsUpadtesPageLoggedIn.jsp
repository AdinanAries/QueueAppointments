<%-- 
    Document   : BlockFutureSpots
    Created on : Jun 3, 2019, 10:13:16 AM
    Author     : aries
--%>

<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="com.arieslab.queue.queue_model.ProviderCustomerData"%>
<%@page import="com.arieslab.queue.queue_model.BookedAppointmentList"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.arieslab.queue.queue_model.ResendAppointmentData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Driver"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Queue | Settings</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
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
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        int UserID = 0;
        int UserIndex = -1;
        String NameFromList = "";
        String NewUserName = "";
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
         
        try{
            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            NewUserName = request.getParameter("User");
            UserID = Integer.parseInt(request.getParameter("CustomerID"));

            int notiCounter = 0;

            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            response.sendRedirect("NewsUpadtesPageLoggedIn.jsp?CustomerID="+UserID);
        }
        
        ProviderCustomerData eachCustomer = null;
       
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background-color: #ccccff; padding-bottom: 0; position: absolute;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <!--script>
            setTimeout(function(){
                window.location.replace("NewsUpadtesPageLoggedIn.jsp?CustomerID=<%=UserID%>&User=<%=NewUserName%>&UserIndex=<%=UserIndex%>");
            },6000);
        </script-->
        
    <center><div id='PhoneSettingsPgNav' style='z-index: 110; width: 99.5%; position: fixed; margin-bottom: 5px; background-color: #000099; padding: 5px; box-shadow: 4px 4px 4px #334d81;'>
       
            <p style='color: white;'><img style='background-color: white;' src="icons/icons8-google-news-50.png" width="28" height="25" alt="icons8-google-news-50"/>
                Queue News Area
            
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>">
                    <span style='margin-right: 5px; cursor: pointer; color: white; float: right; border: 2px solid white; padding: 3px; background-color: #334d81;'><img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/>
                        Home</span></a></p>
             
        </div></center>
        
    <center><div id="PhoneExtras">
            
            <div id='PhoneNews' style='width: 100%; max-width: 500px; padding-top: 50px;' >
            <div id='News' style=''>
            <center><p style="color: #254386; font-size: 16px; font-weight: bolder; margin-bottom: 10px;">News updates from your providers</p></center>
            
                <div style="overflow-y: auto;">
                    
                    <%
                        int newsItems = 0;
                        String newsQuery = "";
                        //String base64Profile = "";
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(url, User, Password);
                                String CustQuery = "select * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
                                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                                CustPst.setInt(1, UserID);
                                ResultSet CustRec = CustPst.executeQuery();
                                
                                while(CustRec.next()){
                                    
                                    String MessageID = CustRec.getString("MessageID").trim();
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                                        newsQuery = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
                                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                                        newsPst.setString(1, MessageID);
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


                                            }catch(Exception e){}


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

                    <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 3px; background-color: white;">
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

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    //}
                
                    if(newsItems < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(url, User, Password);
                            String newsQuery2 = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
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
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 3px; background-color: white;">
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
            
                }
            %>
               </div> 
            </div>
        </div>
        </div></center>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    
</html>
