<%-- 
    Document   : UploadPhotoWindow
    Created on : May 29, 2019, 5:02:04 PM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.arieslab.queue.queue_model.ProviderPhotos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Upload Photo</title>
    </head>
    
    <%
        String base64Image = "";
        String base64Cover = "";
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; //Driver Class
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue"; //url (database)
        String User = "sa"; //datebase user account
        String Password = "Password@2014"; //database password
        
        int UserID = 0;
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        String NewUserName = request.getParameter("User");
       
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        if(tempAccountType.equals("CustomerAccount")){}
            //UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        if(tempAccountType.equals("BusinessAccount")){
            UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
            //request.setAttribute("UserIndex", UserIndex);
            //request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        }
        
        else if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");
        
        //int ID = ProviderPhotos.ProviderID;
        int ID = UserID;
        
        try{
            
            Class.forName(Driver);
            Connection ProfilePicConn = DriverManager.getConnection(url, User, Password);
            String ProfilePicString = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
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
        
                try{
            
                    Class.forName(Driver);
                    Connection ProfilePicConn = DriverManager.getConnection(url, User, Password);
                    String ProfilePicString = "select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
                    PreparedStatement ProfilePicPst = ProfilePicConn.prepareStatement(ProfilePicString);
                    ProfilePicPst.setInt(1, ID);
                    ResultSet ProfilePicRec = ProfilePicPst.executeQuery();

                    while(ProfilePicRec.next()){

                        try{    
                        //put this in a try catch block for incase getProfilePicture returns nothing
                        Blob profilepic = ProfilePicRec.getBlob("CoverPhoto"); 
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
                    catch(Exception e){}
                        
                        if(!base64Cover.equals("")){
                            break;
                        }
                    }
            
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
    
    <body style="background-color: #7e7e7e;">
    
    <center><div style='width: 100%; max-width: 600px;'>
    <center><h3 style='color: white; margin-bottom: 5px;'>Change Profile Photos</h3></center>
    
    <center>
                                
                                <div class="propic" style="background-color: white; background-image: url('data:image/jpg;base64,<%=base64Cover%>');">
                                    
                            <%
                                if(base64Image == ""){
                            %> 
                            
                            <center><img style="border: #7e7e7e solid 5px;" src="icons/icons8-user-filled-100.png" width="150" height="150" alt="icons8-user-filled-100"/>

                                </center>
                                    
                            <%
                                }else{
                            %>
                                    <img style="border: #7e7e7e solid 5px;" src="data:image/jpg;base64,<%=base64Image%>" width="150" height="150"/>
                                    
                            <%
                                }
                            %>
                                </div>
                            </center>
                    <div style="margin-top: 90px;">
                        <form name="UploadProfilePhotos" action="UploadCoverPhotoControl" method="POST" enctype="multipart/form-data">
                        
                            <p style="color: white; border-top: 1px solid darkgrey;">Choose Cover Photo</p>
                            <input style="width: 90%;" type="file" name="coverPic" value="" />
                            <input type="hidden" name="ProviderID" value="<%=ID%>" />
                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                            <input style="width: 90%; background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;" type="submit" value="Upload Cover Photo" />
                        </form>
                            
                        <form name="UploadCoverPhotos" action="UploadProviderPhotosControl" method="POST" enctype="multipart/form-data">
                            <p style="color: white; margin-top: 10px; border-top: 1px solid darkgray;">Choose Profile Photo</p>
                            <input style="width: 90%;" type="file" name="profilePic" value="" />
                            <input type="hidden" name="ProviderID" value="<%=ID%>" />
                            <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                            <input type="hidden" name="User" value="<%=NewUserName%>" />
                            <input style="width: 90%; background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;" type="submit" value="Upload Profile Photo" />
                            <p style="border-top: 1px solid darkgrey; margin-top: 10px;"></p>
                        
                        </form>
                                    
                    </div>
                    <a href="ServiceProviderPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="background-color: pink; color: white; padding: 5px; margin-top: 10px;">Your Dashboard</p></a>
    
        
    </body>
    
    <script src="scripts/script.js"></script>
    
</html>
