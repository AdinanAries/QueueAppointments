<%-- 
    Document   : UploadPhotoWindow
    Created on : May 29, 2019, 5:02:04 PM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page import="com.arieslab.queue.queue_model.ProviderPhotos"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link href='QueueCSS.css' rel='stylesheet' media='screen' type='text/css'/>
        <title>Upload Photo</title>
    </head>
    
    <%
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        int UserID = 0;
        int UserIndex = 0;
        String tempAccountType = "";
        String NewUserName = "";
        String base64Image = "";
        
        boolean isTrySuccess = true;
        
        String url = "";
        String User = "";
        String Password = "";
        String Driver = "";
        
        try{
            
            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));

            tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
            NewUserName = request.getParameter("User");

            if(tempAccountType.equals("CustomerAccount")){}


            if(tempAccountType.equals("BusinessAccount")){
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
                //request.setAttribute("UserIndex", UserIndex);
                //request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }

            /*else if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");*/
        
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
            
        }catch(Exception e){
            isTrySuccess = false;
        }
        
        if(!isTrySuccess || UserID == 0){
            response.sendRedirect("LogInPage.jsp");
        }
        
        int ID = UserID;
        
        //JOptionPane.showMessageDialog(null, UserIndex);
        //JOptionPane.showMessageDialog(null, NewUserName);
        
        try{
            
            Class.forName(Driver);
            Connection ProfilePicConn = DriverManager.getConnection(url, User, Password);
            String ProfilePicString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID = ? order by PicID desc";
            PreparedStatement ProfilePicPst = ProfilePicConn.prepareStatement(ProfilePicString);
            ProfilePicPst.setInt(1, ID);
            ResultSet ProfilePicRec = ProfilePicPst.executeQuery();
            
            while(ProfilePicRec.next()){
                
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob profilepic = ProfilePicRec.getBlob("GalaryPhoto"); 
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
                
                if(!base64Image.equals(""))
                    break;
                 
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
    %>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background-color: #7e7e7e;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
    
    <center><div style='width: 100%; max-width: 500px;'>
    <center><h3 style='color: white;'>Upload Photo</h3></center>
    
        <!--div style="background-color: black; width:100%; max-width: 600px; height: 00px; background-size: cover; background-image: url('data:image/jpg;base64,<=base64Image%>')"></div-->
        
        <img style="background-color: black; width:100%; max-width: 400px;" src="data:image/jpg;base64,<%=base64Image%>" width="100%"/>
        <p style="color: darkgray; text-align: center; margin: 0;">last uploaded photo</p>
        
        <form style="margin-top: 5px;" name="Upload Photo" action="UploadGalleryPhotoController" method="POST" enctype="multipart/form-data">
            <p style="border-top: 1px solid darkgrey; margin-top: 10px;"></p>
            <p style="color: white;">Choose a photo to download new one</p>
            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
            <input type="hidden" name="User" value="<%=NewUserName%>" />
            <input type="hidden" name="ProviderID" value="<%=ID%>" />
            
            <input id="GalPhotoFld" style="width: 90%; background-color: white; border: #d8d8d8 1px solid;" type="file" name="file" value="" /><br />
            <input id="GalUploadBtn" style="width: 90%; background-color: pink; padding: 5px; border: solid black 1px; border-radius: 4px; margin: 5px;" type="submit" value="Upload Photo" onclick="document.getElementById('PageLoader').style.display = 'block';"/>
        
            <script>
                setInterval(function(){

                    if(document.getElementById("GalPhotoFld").value === ""){
                        document.getElementById("GalUploadBtn").style.display = "none";
                    }else{
                        document.getElementById("GalUploadBtn").style.display = "block";
                    }

                },1);
            </script>
            
        </form>
        <p style="border-top: 1px solid darkgrey; margin-top: 10px;"></p>
        <a href="ServiceProviderPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" style="text-decoration: none;" onclick="document.getElementById('PageLoader').style.display = 'block';"><p style="background-color: pink; color: white; padding: 5px; margin-top: 10px;">Your Dashboard</p></a>
        
    </body>
</html>
