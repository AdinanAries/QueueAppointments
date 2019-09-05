 <%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

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
        <title>Queue</title>
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script src="scripts/QueueLineDivBehavior.js"></script>
        
    </head>
    
    <% 
        
        boolean isTypeChck = false;
        String SVCTypeAppend = " and ( ";
        
        String Barber = request.getParameter("Barber");
        if(Barber != null){
            SVCTypeAppend += "Service_Type like '%Barber Shop%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Barber is: " + Barber);
        
        String Beauty = request.getParameter("Beauty");
        if(Beauty != null){
            SVCTypeAppend += "Service_Type like '%Beauty Salon%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Beauty is: " + Beauty);
        
        String DaySpa = request.getParameter("DaySpa");
        if(DaySpa != null){
            SVCTypeAppend += "Service_Type like '%Day Spa%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "DaySpa is: " + DaySpa);
        
        String Dentist = request.getParameter("Dentist");
        if(Dentist != null){
            SVCTypeAppend += "Service_Type like '%Dentist%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Dentist is: " + Dentist);
        
        String Dietician = request.getParameter("Dietician");
        if(Dietician != null){
            SVCTypeAppend += "Service_Type like '%Dietician%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Dietician is: " + Dietician);
        
        String EyeBrows = request.getParameter("EyeBrows");
        if(EyeBrows != null){
            SVCTypeAppend += "Service_Type like '%Eyebrows and Eyelashes%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "EyeBrows is: " + EyeBrows);
        
        String HairRemoval = request.getParameter("HairRemoval");
        if(HairRemoval != null){
            SVCTypeAppend += "Service_Type like '%Hair Removal%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "HairRemoval is: " + HairRemoval);
        
        String TattooShop = request.getParameter("TattooShop");
        if(TattooShop != null){
            SVCTypeAppend += "Service_Type like '%Tattoo Shop%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "TattooShop is: " + TattooShop);
        
        String Podiatry = request.getParameter("Podiatry");
        if(Podiatry != null){
            SVCTypeAppend += "Service_Type like '%Podiatry%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Podiatry is: " + Podiatry);
        
        String Piercing = request.getParameter("Piercing");
        if(Piercing != null){
            SVCTypeAppend += "Service_Type like '%Piercing%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Piercing is: " + Piercing);
        
        String PhysicalTherapy = request.getParameter("PhysicalTherapy");
        if(PhysicalTherapy != null){
            SVCTypeAppend += "Service_Type like '%Physical Therapy%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "PhysicalTherapy is: " + PhysicalTherapy);
        
        String PetServices = request.getParameter("PetServices");
        if(PetServices != null){
            SVCTypeAppend += "Service_Type like '%Pet Services%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "PetServices is: " + PetServices);
        
        String PersonalTrainer = request.getParameter("PersonalTrainer");
        if(PersonalTrainer != null){
            SVCTypeAppend += "Service_Type like '%Personal Trainer%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "PersonalTrainer is: " + PersonalTrainer);
        
        String NailSalon = request.getParameter("NailSalon");
        if(NailSalon != null){
            SVCTypeAppend += "Service_Type like '%Nail Salon%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "NailSalon is: " + NailSalon);
                
        String MedCenter = request.getParameter("MedCenter");
        if(MedCenter != null){
            SVCTypeAppend += "Service_Type like '%Medical Center%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "MedCenter is: " + MedCenter);
        
        String Aethetician = request.getParameter("Aethetician");
        if(Aethetician != null){
            SVCTypeAppend += "Service_Type like '%Medical Aesthetician%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Aethetician is: " + Aethetician);
        
        String Massage = request.getParameter("Massage");
        if(Massage != null){
            SVCTypeAppend += "Service_Type like '%Massage%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "Massage is: " + Massage);
        
        String MakeUpArtist = request.getParameter("MakeUpArtist");
        if(MakeUpArtist != null){
            SVCTypeAppend += "Service_Type like '%Makeup Artist%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "MakeUpArtist is: " + MakeUpArtist);
        
        String HomeService = request.getParameter("HomeService");
        if(HomeService != null){
            SVCTypeAppend += "Service_Type like '%Home Services%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "HomeService is: " + HomeService);
        
        String HolisticMedicine = request.getParameter("HolisticMedicine");
        if(HolisticMedicine != null){
            SVCTypeAppend += "Service_Type like '%Holistic Medicine%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "HolisticMedicine is: " + HolisticMedicine);
        
        String HairSalon = request.getParameter("HairSalon");
        if(HairSalon != null){
            SVCTypeAppend += "Service_Type like '%Hair Salon%' or ";
            isTypeChck = true;
        }
        //JOptionPane.showMessageDialog(null, "HairSalon is: " + HairSalon);
        
        SVCTypeAppend += "Service_Type = '')";
        
        if(isTypeChck == false){
            SVCTypeAppend = "";
        }
        
        //JOptionPane.showMessageDialog(null, SVCTypeAppend);
        
        int UserID = 0;
        
        String ServiceType = "";
        
        //if(UserAccount.AccountType.equals("BusinessAccount"))
            //response.sendRedirect("ServiceProviderPage.jsp");
        
        //connection parameters
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; //Driver Class
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue"; //url (database)
        String User = "sa"; //datebase user account
        String Password = "Password@2014"; //database password
        
        //getting search parameters for search query
        String City = request.getParameter("city4Search").trim();
        String Town = request.getParameter("town4Search").trim();
        String ZipCode = request.getParameter("zcode4Search").trim();
        
        if(City.equals("")){
            if(isTypeChck)
                City = "";
            else
                City = "none";
        }
        
        if(Town.equals("")){
            if(isTypeChck)
                Town = "";
            else
                Town = "none";
        }
        
        if(ZipCode.equals("")){
            if(isTypeChck)
                ZipCode = "";
            else
                ZipCode = "none";
        }
        
        /*JOptionPane.showMessageDialog(null, City);
        JOptionPane.showMessageDialog(null, Town);
        JOptionPane.showMessageDialog(null, ZipCode);*/
        
        ArrayList<Integer> ProviderIDList = new ArrayList<>();
        
        try{
            Class.forName(Driver);
            Connection Conn = DriverManager.getConnection(url, User, Password);
            String AddressQuery = "Select * from QueueObjects.ProvidersAddress where City like '%"+City+"%' and Town like '%"+Town+"%' and Zipcode like '%"+ZipCode+"%'";
            
            PreparedStatement AddressPst = Conn.prepareStatement(AddressQuery);
            
            ResultSet AddressRec = AddressPst.executeQuery();
            
            while(AddressRec.next()){
                ProviderIDList.add(AddressRec.getInt("ProviderID"));
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
    %>
    
    <%!
        
       class getUserDetails{
           //class instance fields
           private Connection conn; //connection object variable
           private ResultSet records; //Resultset object variable
           private Statement st;
           
           //connection parameters
           private String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; //Driver Class
           private String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue"; //url (database)
           private String User = "sa"; //datebase user account
           private String Password = "Password@2014"; //database password
           
           public ResultSet getRecords(int ProvID, String SVCTypeAppend){
              
               try{
                   
                    Class.forName(Driver); //registering driver class
                    conn = DriverManager.getConnection(url,User,Password);
                    //Search Query String
                    String  select = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?" + SVCTypeAppend; 
                    
                    PreparedStatement pst = conn.prepareStatement(select);
                    pst.setInt(1, ProvID);
                    
                    
                    records = pst.executeQuery();
                    
               }
               catch(Exception e){
                  e.printStackTrace();
                }
               
                 return records;
            }
                
       }
        %>
        
        <%
            //instantiating getUserDetails class
            getUserDetails details = new getUserDetails();
            ArrayList <ProviderInfo> providersList = new ArrayList<>(); //ArrayList of ProviderInfo that models the providerInfo table data
            
            for(int q = 0; q < ProviderIDList.size(); q++){
                
                ResultSet rows = details.getRecords(ProviderIDList.get(q), SVCTypeAppend); //calling search function
                
                try{

                    ProviderInfo eachrecord; //try block not needed for this declaration

                    while(rows.next()){

                        //try block needed for this operation (while(rows.next())
                        eachrecord = new ProviderInfo(rows.getInt("Provider_ID"),rows.getString("First_Name"), rows.getString("Middle_Name"), rows.getString("Last_Name"), rows.getDate("Date_Of_Birth"), rows.getString("Phone_Number"),
                                                        rows.getString("Company"), rows.getInt("Ratings"), rows.getString("Service_Type"), rows.getString("First_Name") + " - " +rows.getString("Company"),rows.getBlob("Profile_Pic"), rows.getString("Email"));

                        providersList.add(eachrecord);
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
            
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
            <!--center><h1 style="color: #000099;">Find Your Spot Now!</h1></center-->
            
        </div>
            
        <div id="content">
            
            <div id="nav">
                
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
                
                <center><table id="providerdetails" style="border-spacing: 12px;">
                        
                    <%
                        
                        for(int i = 0; i < providersList.size(); i++){ 
                            
                        String fullName = providersList.get(i).getFirstName() + " " + providersList.get(i).getMiddleName() + " " + providersList.get(i).getLastName();
                        String Company = providersList.get(i).getCompany();
                        String Email = providersList.get(i).getEmail();
                        String phoneNumber = providersList.get(i).getPhoneNumber();
                        ServiceType = providersList.get(i).getServiceType().trim();
                        
                                                
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
                            
                        int ID = providersList.get(i).getID();
                        String SID = Integer.toString(ID);
                        
                        try{
                            
                            Class.forName(details.Driver);
                            Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                            String selectAddress = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                            PreparedStatement pst = conn.prepareStatement(selectAddress);
                            pst.setInt(1,ID);
                            ResultSet address = pst.executeQuery();
                            
                            while(address.next()){
                                
                                providersList.get(i).setAddress(address.getInt("House_Number"), address.getString("Street_Name"), address.getString("Town"),address.getString("City"),address.getString("Country"),address.getInt("Zipcode"));
                            }
                            
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }
                        
                        String fullAddress = "address information not found";
                        
                        try{
                            int hNumber = providersList.get(i).Address.getHouseNumber();
                            String sName = providersList.get(i).Address.getStreet().trim(); //trimming text data to get rid of all extra spaces
                            String tName = providersList.get(i).Address.getTown().trim();
                            String cName = providersList.get(i).Address.getCity().trim();
                            String coName = providersList.get(i).Address.getCountry().trim();
                            int zCode = providersList.get(i).Address.getZipcode();
                            fullAddress = Integer.toString(hNumber) + " " + sName + ", " + tName + ", " + cName + ", " + coName + " " + Integer.toString(zCode);
                        }catch(Exception e){}
                        
                        int ratings = providersList.get(i).getRatings();
                        
                    %>
                    
                        
                                
                    <%
                        //getting coverdata
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,ID);
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
                            
                            <tbody>
                            <tr>
                            <td>
                            
                            <center>        
                            <div class="propic" style="background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                <img style="border-radius: 100%;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                            </div>
                            
                                <div class="proinfo">
                                
                                <b><p style="font-size: 20px; text-align: center; margin-bottom: 0;"><span><!--img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/-->
                                            <%=fullName%></span></p></b>
                                            
                                <p style="text-align: center; margin: 0;"><%=ServiceType%></P>
                                <p style='text-align: center; color:#7e7e7e; margin: 0; padding: 0;'><small><%=fullAddress%></small></p>
                                         
                                <%
                                    if(ServiceType.equals("Barber Shop")){
                                %>
                                
                                <div>
                                    <img style="float: left;" src="icons/icons8-barber-pole-50.png" width="30" height="30" alt="icons8-barber-pole-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Day Spa")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-spa-50.png" width="25" height2="30" alt="icons8-spa-50"/>
                                </div>
                                
                                <%}%>
                                
                                 <%
                                    if(ServiceType.equals("Beauty Salon")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-hair-dryer-50.png" width="30" height2="30" alt="icons8-hair-dryer-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Dentist")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-tooth-50.png" width="30" height2="30" alt="icons8-tooth-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Dietician")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-dairy-50.png" width="30" height2="30" alt="icons8-dairy-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Eyebrows and Eyelashes")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-eye-50.png" width="30" height2="30" alt="icons8-eye-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Hair Salon")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-woman's-hair-50.png" width="30" height2="30" alt="icons8-woman's-hair-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Hair Removal")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-skin-50.png" width="30" height2="30" alt="icons8-skin-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Tattoo Shop")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-tattoo-machine-50.png" width="30" height2="30" alt="icons8-tattoo-machine-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Home Services")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-home-50 (1).png" width="30" height2="30" alt="icons8-home-50 (1)"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Holistic Medicine")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-hospital-3-50.png" width="30" height2="30" alt="icons8-hospital-3-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Medical Center")){
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-hospital-3-50.png" width="30" height2="30" alt="icons8-hospital-3-50"/>
                                </div>
                                
                                <%}%>
                                
                                <%
                                    if(ServiceType.equals("Medical Aesthetician")){
                                %>
                                   
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-business-50.png" width="30" height="30" alt="icons8-business-50"/>
                                </div>
                                
                                <%}%>
                                
                                <% 
                                    
                                    if(ServiceType.equals("Physical Therapy")){
                                    
                                %>
                                
                                <div>
                                    <img style="float: left; margin-right: 3px;" src="icons/icons8-business-50.png" width="30" height="30" alt="icons8-business-50"/>
                                </div>
                                
                                <%}%>
                                
                                <p style=""><span>
                                        
                                <%
                                    if(!ServiceType.equals("Barber Shop") && !ServiceType.equals("Day Spa") && !ServiceType.equals("Beauty Salon") && !ServiceType.equals("Dentist") && !ServiceType.equals("Dietician") && !ServiceType.equals("Eyebrows and Lashes") && !ServiceType.equals("Hair Salon") && !ServiceType.equals("Hair Removal") && !ServiceType.equals("Tattoo Shop") && !ServiceType.equals("Home Services") && !ServiceType.equals("Holistic Medicine") && !ServiceType.equals("Medical Center") && !ServiceType.equals("Medical Aesthetician") && !ServiceType.equals("Physical Therapy")){
                                %>
                                        <img style="float: left; margin-right: 3px;" src="icons/icons8-business-50.png" width="30" height="30" alt="icons8-business-50"/>
                                <%}%>
                                
                                        <%=Company%> </span><span style="color: blue; font-size: 22px;">
                                
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
                                        <%}%>
                                        </span>
                                </p>
                                
                            </div>
                                        
                                    <div id="QueuLineDiv">
                                        
                                    <%
                                        
                                        int IntervalsValue = 30;
        
                                        try{

                                            Class.forName(Driver);
                                            Connection intervalsConn = DriverManager.getConnection(url, User, Password);
                                            String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                                            PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

                                            intervalsPst.setInt(1, ID);

                                            ResultSet intervalsRec = intervalsPst.executeQuery();

                                            while(intervalsRec.next()){
                                                IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
                                            }
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                        
                                        Date currentDate = new Date();//default date constructor returns current date 
                                        String CurrentTime = currentDate.toString().substring(11,16);
                                        String DayOfWeek = currentDate.toString().substring(0,3);
                                        SimpleDateFormat formattedDate = new SimpleDateFormat("MMM dd"); //formatting date to a string value of month day, year
                                        String stringDate = formattedDate.format(currentDate); //calling format function to format date object
                                        SimpleDateFormat QuerySdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String QueryDate = QuerySdf.format(currentDate);
                                        
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllAvailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllThisCustomerTakenTime = new ArrayList<>();
                                        ArrayList<String> AllThisCustomerTakenFormattedTakenTime = new ArrayList<>();
                                        
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
                                            Connection hoursConn = DriverManager.getConnection(url, User, Password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setInt(1, ID);
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
                                        //getting the closed days data
                                        ArrayList<String> ClosedDates = new ArrayList<>();
                                        ArrayList<Integer> ClosedIDs = new ArrayList<>();
                                        boolean isTodayClosed = false;
                                        
                                       
                                        
                                        Date DateForClosedCompare = new Date();
                                        SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare);
                                        
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection CloseddConn = DriverManager.getConnection(url, User, Password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setInt(1, ID);
                                            
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
                                        int CurrentHour = Integer.parseInt(CurrentTime.substring(0,2));
                                        int CurrentMinute = Integer.parseInt(CurrentTime.substring(3,5));
                                        
                                        int CurrentHourForStatusLed = CurrentHour;
                                        
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
                                        
                                        if(NextThirtyMinutes >= 60){
                                            
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
                                        if(ActualThirtyMinutesAfter >= 60){
                                            
                                            ++Hourfor30Mins;
                                            
                                            if(DailyClosingTime != ""){
                                                
                                                if(Hourfor30Mins > closeHour && closeHour != 0){

                                                    Hourfor30Mins = closeHour - 1;

                                                }
                                                else if(closeHour == 0)
                                                    Hourfor30Mins = 23;
                                                    
                                            }else if(Hourfor30Mins > 23){
                                                Hourfor30Mins = 23;
                                            }
                                            
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
                                        
                                        int Next30MinsAppointmentFlag = 0;
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection ThirtyMinsConn = DriverManager.getConnection(url, User, Password);
                                            String ThirtyMinsString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                            
                                            PreparedStatement ThirtyPst = ThirtyMinsConn.prepareStatement(ThirtyMinsString);
                                            ThirtyPst.setInt(1, providersList.get(i).getID());
                                            ThirtyPst.setString(2, QueryDate);
                                            ThirtyPst.setString(3, CurrentTime);
                                            ThirtyPst.setString(4, TimeAfter30Mins);
                                            
                                            ResultSet ThirtyMinsRow = ThirtyPst.executeQuery();
                                            
                                            while(ThirtyMinsRow.next()){
                                                
                                                Next30MinsAppointmentFlag = 1;
                                                isFirstAppointmentFound = 1;
                                                
                                                String TempTime = ThirtyMinsRow.getString("AppointmentTime");
                                                
                                                CurrentHour = Integer.parseInt(TempTime.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TempTime.substring(3,5));
                                                CurrentTime = CurrentHour + ":" + CurrentMinute;
                                                
                                                //getting the next 30 minute time from the current time;
                                                int TempMinute = CurrentMinute + 30;
                                        
                                                int TempHour = CurrentHour;

                                                if(TempMinute >= 60){

                                                    ++TempHour;

                                                    if(DailyClosingTime != ""){
                                                
                                                        if(TempHour > closeHour && closeHour != 0){

                                                            TempHour = closeHour - 1;

                                                        }
                                                        else if(closeHour == 0)
                                                            TempHour = 23;

                                                    }else if(TempHour > 23){
                                                        TempHour = 23;
                                                    }

                                                    if(TempMinute > 60)
                                                        TempMinute -= 60;

                                                    else if(TempMinute == 60)
                                                        TempMinute = 0;
                                                }
                                                
                                                String StringTempMinute = Integer.toString(TempMinute);
                                                
                                                if(StringTempMinute.length() < 2)
                                                    StringTempMinute = "0" + StringTempMinute;
                                                
                                                NextAvailableTime = TempHour + ":" + StringTempMinute;
                                                
                                                break;
                                                
                                            }
                                            if(Next30MinsAppointmentFlag == 0){
                                                
                                                if(TimeWith30Mins.length() == 4)
                                                    TimeWith30Mins = "0" + TimeWith30Mins;
                                                
                                                CurrentHour = Integer.parseInt(TimeWith30Mins.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TimeWith30Mins.substring(3,5));
                                                String thisMinute = Integer.toString(CurrentMinute);
                                                        
                                                if(thisMinute.length() < 2){
                                                    thisMinute = "0" + thisMinute;
                                                }
                                                
                                                NextAvailableTime = CurrentHour + ":" + CurrentMinute;
                                                 
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
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
                                     
                                    <%
                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00")){
                                    %>
                                                 
                                    <p style="color: tomato;">Not open on <%=DayOfWeek%>...</p>
                                    
                                    <%
                                        }else if(FormattedStartTime != "" || FormattedClosingTime != "" && !(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))){
                                    %>
                                    
                                        <p><span>
                                            
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
                                        <span style="color: tomato"><%=DayOfWeek%>, <%=stringDate%></span>.</p>
                                        
                                    <%
                                        }
                                    %>
                                    
                                        <!--p>Next Appointment: <%=NextAvailableTime%></p-->
                                        <center><p>Select any <span style="color: blue;">blue</span> spot to take position on this line</p></center>
                                      
                                    <div class="scrolldiv" style="width: 280px; max-width: 500px; overflow-x: auto;">    
                                    <table>
                                        <tbody>
                                            <tr>
                                                
                                            <%
                                                int HowManyColums = 0;
                                                boolean isLineAvailable = false;
                                                
                                                for(int x = CurrentHour; x < twoHours;){
                                                    
                                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                                        break;
                                                   
                                                    for(y = CurrentMinute; y <= 60;){
                                                        
                                            %>
                                            
                                            <%
                                                
                                                try{
                                                    
                                                    Class.forName(Driver);
                                                    Connection LineDivConn = DriverManager.getConnection(url, User, Password);
                                                    String LineDivString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                                    
                                                    PreparedStatement LineDivPst = LineDivConn.prepareStatement(LineDivString);
                                                    LineDivPst.setInt(1, providersList.get(i).getID());
                                                    LineDivPst.setString(2, QueryDate);
                                                    LineDivPst.setString(3, CurrentTime);
                                                    LineDivPst.setString(4, NextAvailableTime);
                                                    
                                                    ResultSet LineDivRow = LineDivPst.executeQuery();
                                                    
                                                    while(LineDivRow.next()){
                                                        
                                                        bookedTimeFlag = 1;
                                                        
                                                        int CustomerID = LineDivRow.getInt("CustomerID");
                                                        
                                                        if(UserID == CustomerID){
                                                            bookedTimeFlag = 2;
                                                        }
                                                        
                                                        CurrentTime = LineDivRow.getString("AppointmentTime");
                                                        
                                                        
                                                        int k = Integer.parseInt(CurrentTime.substring(0,2));
                                                        int l = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        x = Integer.parseInt(CurrentTime.substring(0,2));
                                                        y = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        ++l;
                                                        CurrentTime = k + ":" + l;
                                                      
                                                        
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
                                                    int t = i + 1;
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
                                                    int t = i + 1;
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
                                                AllThisCustomerTakenTime.add(NextAvailableTime);
                                                AllThisCustomerTakenFormattedTakenTime.add(NextAvailableFormattedTime);
                                                int t = i + 1;
                                                
                                            %>
                                            
                                                <td onclick="showYourPositionMessage(<%=t%><%=TotalThisCustomerTakenList%>)">
                                                    <p style="font-size: 12px; font-weight: bold; color: green;"><%=NextAvailableFormattedTime%></p>
                                                    <img src="icons/icons8-standing-man-filled-50 (2).png" width="50" height="50" alt="icons8-standing-man-filled-50 (2)"/>
                                                </td>
                                                
                                            <%  }
                                            
                                                bookedTimeFlag = 0;
                                            
                                            %>
                                                <!--td>9:30am<img src="icons/icons8-standing-man-filled-50.png" width="50" height="50" alt="icons8-standing-man-filled-50"/>
                                                </td-->
                                            <% 
                                                        
                                                        y += IntervalsValue;
                                                        
                                                        if(y >= 60){
                                                             
                                                            x++;
                                                            
                                                            if(y > 60)
                                                                y -= 60;
                                                            else if(y == 60)
                                                                y = 0;
                                                             
                                                            if(x > twoHours){
                                                               //breaking out of this inner loop  
                                                               //incidentally the condition of outer loop becomes false
                                                               //thereby exiting as well
                                                               break;
                                                            }
                                                        }
                                                        
                                                        thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                        /*formatting the time for user convenience
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
                                                        }*/
                                                    
                                                        //CurrentMinute = y;
                                                        
                                                        //if(HowManyColums >= 5)
                                                            //break;
                                                  
                                                    }
                                                      
                                                    //if(HowManyColums >= 5)
                                                        //break;
                                                }
                                            %>
                                            
                                            </tr>
                                        </tbody>
                                    </table>
                                            
                                    </div>
                                        
                                     <%
                                        
                                        for(int z = 0; z < AllThisCustomerTakenFormattedTakenTime.size(); z++){
                                            
                                            String NextThisAvailableTimeForDisplay = AllThisCustomerTakenFormattedTakenTime.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    %>     
                                            
                                    <p style="background-color: green; color: white; display: none; text-align: center;" id="YourLinePositionMessage<%=t%><%=q%>">Position at <%=NextThisAvailableTimeForDisplay%> is your spot on <%=fullName%>'s line.</p>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        for(int z = 0; z < AllUnavailableTimeList.size(); z++){
                                            
                                            String NextUnavailableTimeForMessage = AllUnavailableFormattedTimeList.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    %>
                                    
                                    <p style="background-color: red; color: white; text-align: center; display: none;" id="LineTakenMessage<%=t%><%=q%>"><%=NextUnavailableTimeForMessage%> is unavailable. This and every red spot has been taken.</p>
                                    
                                    <%}%>
                                    
                                    <%
                                        if(!isLineAvailable){
                                    %>
                                    
                                    <p style="background-color: red; color: white; text-align: center;">There is no line currently available for this service provider</p>
                                    
                                    <%}%>
                                    
                                    <p style=""><span style="color: blue; border: 1px solid blue;"><img src="icons/icons8-standing-man-filled-50 (1).png" width="30" height="25" alt="icons8-standing-man-filled-50 (1)"/>
                                        Available </span> <span style="color: red; border: 1px solid red;"><img src="icons/icons8-standing-man-filled-50.png" width="30" height="25" alt="icons8-standing-man-filled-50"/>
                                        Taken </span> </p>
                                      
                                    <%
                                        
                                        for(int z = 0; z < AllAvailableTimeList.size(); z++){
                                            
                                            String NextAvailableTimeForForm = AllAvailableTimeList.get(z);
                                            String NextAvailableTimeForFormDisplay = AllAvailableFormattedTimeList.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    %>
                                    
                                    <form style="display: none;" id="bookAppointmentFromLineDiv<%=t%><%=q%>" name="bookAppointmentFromLineDiv" action="EachSelectedProvider.jsp" method="POST">
                                        <input type="hidden" name="AppointmentTime" value="<%=NextAvailableTimeForForm%>" />
                                        <input type="hidden" name="UserID" value="<%=SID%>" />
                                        <input style="background-color: lightblue; padding: 5px; border: 1px solid black;" type="submit" value="Take this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                        <p style="margin-top: 5px; color: red; text-align: center;">OR</p>
                                    </form>
                                        
                                    <%}%>
                                
                                </div></center>
                                                
                            <center><form action="EachSelectedProvider.jsp" method="POST" id="SID">   
                            <input type="hidden" name="UserID" value="<%=SID%>" />
                            <input id="eachprov" type="submit" value="I will choose a different spot" name="submit" />
                            </form></center>
                            
                            </td> 
                            </tr>
                            </tbody>
                            
                            <%}//end of for loop%>
                            
                            </table></center>
                            
                </div></center>
                
            </div>
                            
        </div>
                            
        <div id="newbusiness">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Sign-up with Queue to add your business or to book appointment</h2></center>
            
            <div id="businessdetails">
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST"><table border="0">
                        
                        <tbody>   
                            <tr>
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input onfocus="this.value=''" type="text" name="firstName" value="enter your first name" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input onfocus="this.value=''" type="text" name="lastName" value="enter your last name" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input onfocus="this.value=''" type="text" name="telNumber" value="enter your telephone/mobile number here" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input onfocus="this.value=''" type="text" name="email" value="enter your email address here" size="50"/></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input class="button" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Already with Queue (Login to manage your appointments)</h2></center>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0"> 
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="enter your password here" type="password" name="password" value="" size="50"/></td>
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
