<%-- 
    Document   : ViewCustomerReviews
    Created on : May 30, 2019, 10:03:44 AM
    Author     : aries
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.arieslab.queue.queue_model.ReviewsDataModel"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link href='QueueCSS.css' rel='stylesheet' media='screen' type='text/css' >
        <title>Reviews</title>
    </head>
    
    <%
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        int UserID = 0;
        
        String NewUserName = request.getParameter("User");
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
       
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        if(tempAccountType.equals("CustomerAccount"))
            UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        if(tempAccountType.equals("BusinessAccount")){
            request.setAttribute("UserIndex", UserIndex);
            request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        }
        
        else if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");
        
        int CustomerID = UserID;
        ArrayList<ReviewsDataModel> ReviewsList = new ArrayList<>();
        
        try{
            Class.forName(Driver);
            Connection ReviewsConn = DriverManager.getConnection(url, User, Password);
            String ReviewString = "Select * from QueueServiceProviders.ProviderCustomersReview where CustomerID = ?";
            PreparedStatement ReviewPst = ReviewsConn.prepareStatement(ReviewString);
            ReviewPst.setInt(1, CustomerID);
            
            ResultSet ReviewRec = ReviewPst.executeQuery();
            
            ReviewsDataModel eachReview;
            
            while(ReviewRec.next()){
                
                eachReview = new ReviewsDataModel();
                
                eachReview.UserID = ReviewRec.getInt("ProviderID");
                eachReview.ReviewID = ReviewRec.getInt("ReviewID");
                eachReview.Rating = ReviewRec.getInt("CustomerRating");
                eachReview.ReviewMessage = ReviewRec.getString("ReviewMessage").trim();
                eachReview.ReviewDate = ReviewRec.getDate("ReviewDate");
                
                ReviewsList.add(eachReview);
                
            }
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
    %>
    
    <body style='background-color: #7e7e7e;'>
        
    <!--center><div style="position: fixed; width: 100%; padding: 0;">
            <center><a href="ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>" style="text-decoration: none;"><p style="margin-top: 5px; margin-bottom: 0; background-color: pink; color: white; padding: 5px; width: 150px; max-width: 400px; border: 1px solid red;">Your Dashboard</p></a>
            </center>
    </div></center-->
    <center><div style=""> 
            
        <center><h3 style='color: white; text-align: center; margin-bottom: 0; margin-top: 0; width: 120px;'>Your Reviews</h3></center>
        
        <%
            for(int i = 0; i < ReviewsList.size(); i++){
                
                String ReviewMessage = "";
                
                SimpleDateFormat ReviewSDF = new SimpleDateFormat("MMM dd, yyyy");
                String ReviewStringDate = ReviewSDF.format(ReviewsList.get(i).ReviewDate);
                
                try{
                  
                    ReviewMessage = ReviewsList.get(i).ReviewMessage;
                    
                }catch(Exception e){}
               
                int CustomerRating = ReviewsList.get(i).Rating;
                int ProviderID = ReviewsList.get(i).UserID;
                String ProviderFullName = "";
                String Base64Image = "";
                String Company = "";
                String ServiceType = "";
                
                try{
                    
                    Class.forName(Driver);
                    Connection ProviderConn = DriverManager.getConnection(url, User, Password);
                    String ProviderString = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement ProviderInfoPst = ProviderConn.prepareStatement(ProviderString);
                    ProviderInfoPst.setInt(1, ProviderID);
                    
                    ResultSet ProviderRec = ProviderInfoPst.executeQuery();
                    
                    while(ProviderRec.next()){
                        
                        String FirstName = ProviderRec.getString("First_Name").trim();
                        String MiddleName = ProviderRec.getString("Middle_Name").trim();
                        String LastName = ProviderRec.getString("Last_Name").trim();
                        
                        ProviderFullName = FirstName + " " + MiddleName + " " + LastName;
                        Company = ProviderRec.getString("Company");
                        ServiceType = ProviderRec.getString("Service_Type").trim();
                        
                          
                        try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = ProviderRec.getBlob("Profile_Pic"); 
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
        
        <center><div style='background-color: black; padding: 1px; padding-top: 10px; padding-bottom: 10px; margin-bottom: 1px; width: 100%; max-width: 500px; margin-left: 0;'>
                    
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
            <p style='color: white; text-align: left; margin: 0; font-weight: bolder;'><%=ProviderFullName%></p>
            <p style='color: white; text-align: left; margin: 0;'><%=Company%> - <%=ServiceType%></p>
            <p style='color: darkgray; text-align: left; margin: 0;'>You Rated: <span style="color: blue; font-size: 25px;">
                                                    
                                
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
            <p style='color: darkgray; text-align: left; margin: 0;'>Your Message: <span style='color: white;'><%=ReviewMessage%></span></p>
            
            <p style='color: silver; float: right; margin: 0; margin-right: 5px;'><%=ReviewStringDate%></p>
            <%}%>
            </div></center>
            
            <p style='clear: both;'></p>
            
        </div></center>
        <%}%>
        
    </div></center>
    </body>
</html>
