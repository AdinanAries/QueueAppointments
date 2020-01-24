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
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link href='QueueCSS.css' media='screen' type='text/css' rel='stylesheet'>
        <title>Upload Photo</title>
    </head>
    
    <%
        String base64Image = "";
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
        
        int UserID = 0;
        String NewUserName = "";
        int UserIndex = 0;
        String ControllerResult = "";
        
        try{
            ControllerResult = request.getParameter("result");
        }catch(Exception e){}
        
        boolean isTrySuccess = true;
        
        try{
            
            NewUserName = request.getParameter("User");

            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));

            String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

            if(tempAccountType.equals("CustomerAccount"))
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();

            if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }

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
        
        //JOptionPane.showMessageDialog(null, Integer.toString(ID));
        
        try{
            
            Class.forName(Driver);
            Connection ProfilePicConn = DriverManager.getConnection(url, User, Password);
            String ProfilePicString = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
            PreparedStatement ProfilePicPst = ProfilePicConn.prepareStatement(ProfilePicString);
            ProfilePicPst.setInt(1, ID);
            ResultSet ProfilePicRec = ProfilePicPst.executeQuery();
            
            while(ProfilePicRec.next()){
                
                try{    
                //put this in a try catch block for incase getProfilePicture returns nothing
                Blob profilepic = ProfilePicRec.getBlob("Profile_Pic"); 
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

        
        <form style="margin-top: 5px;" name="Upload Photo" action="UploadCustomerProfilePic" method="POST" enctype="multipart/form-data">
            <p style="border-top: 1px solid darkgrey; margin-top: 10px;"></p>
            <input type="hidden" name="CustomerID" value="<%=ID%>" />
            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
            <input type="hidden" name="User" value="<%=NewUserName%>" />
            
            <p style="text-align: center; margin: 5px; color: white;">Choose a picture to upload</p>
            
            <input id="PhotoFileFld" style="width: 90%; background-color: white; border: 1px solid #ccc;" type="file" name="file" value="" /><br />
            <input id="uploadBtn" style="width: 90%; background-color: pink; padding: 5px; border: solid black 1px; border-radius: 4px; margin: 5px;" type="submit" value="Upload Photo" />
            
            <script>
                setInterval(function(){
                    
                    if(document.getElementById("PhotoFileFld").value === ""){
                        document.getElementById("uploadBtn").style.display = "none";
                    }else{
                        document.getElementById("uploadBtn").style.display = "block";
                    }
                    
                },1);
            </script>
        </form>
        <p style="border-top: 1px solid darkgrey; margin-top: 10px;"></p>
        <!--a href="ProviderCustomerPage.jsp?UserIndex=<=UserIndex%>&User=<=NewUserName%>" style="text-decoration: none;"><p style="background-color: pink; color: white; padding: 5px; margin-top: 10px;">Your Dashboard</p></a-->
        
    </body>
    <script>
        var ControllerResult = "<%=ControllerResult%>";
        if(ControllerResult !== "null")
            alert(ControllerResult);
    </script>
</html>
