<%-- 
    Document   : PhotoPreview
    Created on : May 28, 2019, 8:05:52 PM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
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
        
        <title>Photos</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        
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
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; //Driver Class
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue"; //url (database)
        String User = "sa"; //datebase user account
        String Password = "Password@2014"; //database password
    
        int UserID = 0;
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        
        String NewUserName = request.getParameter("User");
        
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        //if(tempAccountType.equals("BusinessAccount")){
            //request.setAttribute("UserIndex", UserIndex);
            //request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        //}
        
        if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");

        
        int picCounter = 0;
        int ProviderID = UserID;
        ArrayList<Blob> AllPhotos = new ArrayList<>();
        ArrayList<Integer> PhotoIDs = new ArrayList<>();
        
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
                int id = PhotoRows.getInt("PicID");
                
                if(eachPic != null){
                    AllPhotos.add(eachPic);
                    PhotoIDs.add(id);
                }
                
            }
            
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        String FirstImage = "";
        int FirstID = PhotoIDs.get(0);
        
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
    
    
    <body style="background-color: #333333; margin:0; padding:0;">
        
    
            
        <h3 style="text-align: center; color: white;">Photos</h3>
        
        
        <div id="selectedImage" style="padding: 5px; margin-bottom: 5px; max-height: 570px; padding-top: 20px; background-color: black;">
            
            <center><img id="ChosenImage" style="width: 100%; max-width: 600px;  max-height: 500px;" src="data:image/jpg;base64,<%=FirstImage%>"/></center>

            
            <center><div style="width: 100%; max-width: 600px;">
            
            <form name="deletePhoto">
                <input id="selectedPhID" type="hidden" value="<%=FirstID%>" />
                <input id="deleteBtn" type="button" value="Delete This Photo" style="padding: 5px; background-color: black; color: red; border: 1px solid red; width: 98%; margin-top: 3px; font-weight: bolder; cursor: pointer;" />
                
                <script>
                    var ThisCell;
                    
                $(document).ready(function(){
                    
                    $("#deleteBtn").click(function(event){
                        
                        var ID = document.getElementById("selectedPhID").value;
                        var ProviderID = <%=ProviderID%>
                        //alert(ID);
                        
                        $.ajax({  
                            type: "POST",  
                            url: "DeletePhotoByProv",  
                            data: "PhotoID="+ID,  
                            success: function(result){
                                
                                $.ajax({
                                    type: "POST",
                                    url: "GetPhotoAfterDelete",
                                    data: "ProviderID="+ProviderID,
                                    success: function(result){
                                        //alert(result);
                                        var PhObject = JSON.parse(result);
                                        var Photo = PhObject.Image;
                                        var PhID = PhObject.ID;
                                        
                                        document.getElementById("ChosenImage").setAttribute("src", "data:image/jpg;base64,"+Photo);
                                        document.getElementById("selectedPhID").value = PhID;
                                        document.getElementById(ThisCell).style.display = "none";
                                    }
                                });
                            }                
                        });
                        
                    });
                });
            </script>
            </form>
                        
            <center><a href="UploadGalleryPhotoWindow.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="background-color:#7e7e7e; border:1px solid darkgray; color: white; cursor: pointer; width: 46%; max-width: 590px; text-align: center; padding: 5px; margin-top: 2px; float: right;">Add New Photo</p></a></center>
            <center><a href="ServiceProviderPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="background-color: pink; border:1px solid darkgray; color: white; cursor: pointer; width: 46%; max-width: 590px; text-align: center; padding: 5px; margin-top: 2px; float: left;">Your Dashboard</p></a></center>
            
            <p style="clear: both;"></p>
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
            
            int PhotoID = PhotoIDs.get(i);
        
    %>
                        <td id="picCell<%=i%>">
                            <div id="photoNumber<%=i%>" style="margin: 2px; background-size: cover; width: 120px; height: 120px; background-image: url('data:image/jpg;base64,<%=base64Image%>'); "></div>
                            <input id="IDnumber<%=i%>" type="hidden" value="<%=PhotoID%>" /> 
                        </td>
                        <script>
                                
                                $(document).ready(function(){
                                    $("#photoNumber<%=i%>").click(function(event){
                                        
                                        var ID = document.getElementById("IDnumber<%=i%>").value;
                                        //alert(ID);
                                        document.getElementById("selectedPhID").value = ID;
                                        
                                        var ChosenImage = document.getElementById("ChosenImage");
                                        ChosenImage.setAttribute("src", "data:image/jpg;base64,<%=base64Image%>");
                                        ThisCell = document.getElementById("picCell<%=i%>").getAttribute("id");
                                        
                                    });
                                });
                                
                        </script>
    <%}%>
    
                        </tr>
                    </tbody>
                </table>
        </div>
    
    <center><p style="max-width: 600px; color: white; text-align: center; margin-top: 10px; border-top: 1px solid darkgray;">Last Upload</p></center>
    
        <center><div style="margin: 2px; width: 100%; max-width: 400px; max-height: 400px; height: 400px; background-size: cover; background-image: url('data:image/jpg;base64,<%=base64Image%>'); "></div></center>
    
    </div></center>
    
    </body>
</html>
