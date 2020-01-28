<%-- 
    Document   : PhotoPreview
    Created on : May 28, 2019, 8:05:52 PM
    Author     : aries
--%>

<%@page import="com.arieslab.queue.queue_model.ProviderPhotos"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <title>Photos</title>
        
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
        
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
    
        int picCounter = 0;
        //int ProviderID = ProviderPhotos.ProviderID;
        int ProviderID = Integer.parseInt(request.getParameter("Provider"));
        ArrayList<Blob> AllPhotos = new ArrayList<>();
        
        String ProviderFullName = "";
        String ProviderCompany = "";
        String ServiceType = "";
        int ProviderRating = 0;
        
        
        try{
            
            Class.forName(Driver);
            Connection ProviderInfoConn = DriverManager.getConnection(url, User, Password);
            String ProviderInfoString = "select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement ProviderInfoPst = ProviderInfoConn.prepareStatement(ProviderInfoString);
            ProviderInfoPst.setInt(1, ProviderID);
            
            ResultSet ProviderRec = ProviderInfoPst.executeQuery();
            
            while(ProviderRec.next()){
                
                String FirstName = ProviderRec.getString("First_Name").trim();
                String MiddleName = ProviderRec.getString("Middle_Name").trim();
                String LastName = ProviderRec.getString("Last_Name").trim();
                
                ProviderFullName = FirstName + " " + MiddleName + " " + LastName;
                ProviderCompany = ProviderRec.getString("Company");
                ProviderRating = ProviderRec.getInt("Ratings");
                ServiceType = ProviderRec.getString("Service_Type");
                
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection PhotosConn = DriverManager.getConnection(url, User, Password);
            String PhotosString = "select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
            PreparedStatement PhotosPst = PhotosConn.prepareStatement(PhotosString);
            PhotosPst.setInt(1, ProviderID);
            
            ResultSet PhotoRows = PhotosPst.executeQuery();
            
            while(PhotoRows.next()){
                
                picCounter++;
                Blob eachPic = PhotoRows.getBlob("GalaryPhoto");
                if(eachPic != null)
                    AllPhotos.add(eachPic);
                
            }
            
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        String FirstImage = "";
        
        try{    
                //put this in a try catch block for incase getProfilePicture returns nothing
                Blob profilepic = AllPhotos.get(0); 
                InputStream inputStream = profilepic.getBinaryStream();
                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead = -1;

                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }

                byte[] imageBytes = outputStream.toByteArray();

                FirstImage = Base64.getEncoder().encodeToString(imageBytes);


            }
            catch(Exception e){}
    
    
    %>
    
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background-color: #333333; margin:0; padding:0; position: absolute; width: 100%;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
            
        <h3 style="text-align: center; color: white;">Photos</h3>
        
        
        <div id="selectedImage" style="padding: 5px; margin-bottom: 10px; max-height: 550px; padding-top: 20px; background-color: black;">
            
            <center><img id="chosenImage" style="width: 100%; max-width: 550px; max-height: 450px;" src="data:image/jpg;base64,<%=FirstImage%>"/></center>

            <center><div id="ProviderDetails" style="width: 100%; max-width: 550px; text-align: left;">
                
            <p style="font-weight: bolder; color: white;"><%=ProviderFullName%></p>
            <p style="color: white;"><span><%=ProviderCompany%></span><span style="color: blue; font-size: 25px;">
                                                    
                                
                                        <%
                                            if(ProviderRating ==5){
                                        
                                        %> 
                                        ★★★★★
                                        <%
                                             }else if(ProviderRating == 4){
                                        %>
                                        ★★★★☆
                                        <%
                                             }else if(ProviderRating == 3){
                                        %>
                                        ★★★☆☆
                                        <%
                                             }else if(ProviderRating == 2){
                                        %>
                                        ★★☆☆☆
                                        <%
                                             }else if(ProviderRating == 1){
                                        %>
                                        ★☆☆☆☆
                                        <%}%>
                                        </span>
            </p>
            <p style="color: white;"><%=ServiceType%></p>
                                
            </div></center>
            
        </div>
        
        <center><div id="" style="width: 100%;">
                
        <div id="ProvPhotoScrollDiv" class="scrolldiv" style="width: 100%; overflow-x: auto; ">
                
                <table style="border-spacing: 0;">
                    <tbody>
                        <tr>
    <%
        
        String base64Image = "";
        
        for(int i = 0; i < AllPhotos.size(); i++){
            
            try{    
                //put this in a try catch block for incase getProfilePicture returns nothing
                Blob profilepic = AllPhotos.get(i); 
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
            catch(Exception e){}
        
    %>
                        <td>
                            <div id="photoNumber<%=i%>" style="margin: 2px; background-size: cover; width: 160px; height: 160px; background-image: url('data:image/jpg;base64,<%=base64Image%>'); "></div>
                        </td>
                    <script>
                        
                        $(document).ready(function(){
                            
                            $("#photoNumber<%=i%>").click(function(event){
                                
                                var chosenImage = document.getElementById("chosenImage");
                                chosenImage.setAttribute("src", "data:image/jpg;base64,<%=base64Image%>");
                                $("html, body").animate({ scrollTop: 0 }, "fast");
                                
                            });
                            
                        });
                        
                    </script>
    <%}%>
    
                        </tr>
                    </tbody>
                </table>
    
        </div>
    <center><p style="max-width: 600px; color: white; text-align: center; margin-top: 10px; border-top: 1px solid darkgray;">Recent Photo</p></center>
    
            <center><div style="margin: 2px; width: 100%; max-width: 400px; max-height: 400px; height: 400px; background-size: cover; background-image: url('data:image/jpg;base64,<%=base64Image%>'); "></div></center>
    
        </div></center>
    
    </body>
</html>
