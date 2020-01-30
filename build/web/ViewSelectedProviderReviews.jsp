<%-- 
    Document   : ViewCustomerReviews
    Created on : May 30, 2019, 10:03:44 AM
    Author     : aries
--%>

<%@page import="com.arieslab.queue.queue_model.ProviderPhotos"%>
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
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <title>Reviews</title>
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
<link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
<meta name="apple-mobile-web-app-status-bar" content="#ccccff" />
        
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
        
        int UserID = 0;
        
        try{
            int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));

            String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

            if(tempAccountType.equals("CustomerAccount"))
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();

            if(tempAccountType.equals("BusinessAccount")){
                //request.setAttribute("UserIndex", UserIndex);
                //request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }

            else if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");
        
        }catch(Exception e){
        }
        
           //int ID = ProviderPhotos.ProviderID;
           int ID = Integer.parseInt(request.getParameter("Provider"));;
           ArrayList<ReviewsDataModel> ReviewsList = new ArrayList<>();
        
        try{
            Class.forName(Driver);
            Connection ReviewsConn = DriverManager.getConnection(url, User, Password);
            String ReviewString = "Select * from QueueServiceProviders.ProviderCustomersReview where ProviderID = ?";
            PreparedStatement ReviewPst = ReviewsConn.prepareStatement(ReviewString);
            ReviewPst.setInt(1, ID);
            
            ResultSet ReviewRec = ReviewPst.executeQuery();
            
            ReviewsDataModel eachReview;
            
            while(ReviewRec.next()){
                
                eachReview = new ReviewsDataModel();
                
                eachReview.UserID = ReviewRec.getInt("CustomerID");
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
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style='background-color: #7e7e7e;'>
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <%
            int NumberOfRatings = 0;
            int TotalRatings = 0;
            int RatingsAvg = 0;
            int FullRating = 0;
            
            try{
                Class.forName(Driver);
                Connection ProvRatingsConn = DriverManager.getConnection(url, User, Password);
                String ProvRatingsString = "select * from QueueServiceProviders.ProviderRatings where ProviderID = ?";
                PreparedStatement ProvRatingsPst = ProvRatingsConn.prepareStatement(ProvRatingsString);
                ProvRatingsPst.setInt(1, ID);
                ResultSet ProvRatingsRec = ProvRatingsPst.executeQuery();
                
                while(ProvRatingsRec.next()){
                    NumberOfRatings = ProvRatingsRec.getInt("NumberOfRatings");
                    TotalRatings = ProvRatingsRec.getInt("TotalRatings");
                    RatingsAvg = ProvRatingsRec.getInt("RatingsAvg");
                    
                }
                
            }catch(Exception e){
                e.printStackTrace();
            }
            
            FullRating = NumberOfRatings * 5;
            
            double doubleTotalRatings = TotalRatings;
            double doulbeFullRatings = FullRating;
            double CalculatedRating = ((doubleTotalRatings * 5) / doulbeFullRatings);
        %>
        
        <%
            String ProvFullName = "";
            String ProvCompany = "";
            String Base64ProvImage = "";
            String ServiceType = "";
            int ProvRating = 0;
            
            
            try{
                Class.forName(Driver);
                Connection ProvInfoConn = DriverManager.getConnection(url, User, Password);
                String ProvInfoString = "select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                PreparedStatement ProvInfoPst = ProvInfoConn.prepareStatement(ProvInfoString);
                ProvInfoPst.setInt(1, ID);
                ResultSet ProvInfoRec = ProvInfoPst.executeQuery();
                
                while(ProvInfoRec.next()){
                    String FirstName = ProvInfoRec.getString("First_Name").trim();
                    String MiddleName = ProvInfoRec.getString("Middle_Name").trim();
                    String LastName = ProvInfoRec.getString("Last_Name").trim();
                    ProvFullName = FirstName + " " + MiddleName + " " + LastName;
                    ProvCompany = ProvInfoRec.getString("Company").trim();
                    ServiceType = ProvInfoRec.getString("Service_Type").trim();
                    ProvRating = ProvInfoRec.getInt("Ratings");
                    
                    try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob profilepic = ProvInfoRec.getBlob("Profile_Pic"); 
                                    InputStream inputStream = profilepic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                     Base64ProvImage = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){}
                    
                }
                
            }catch(Exception e){
                e.printStackTrace();
            }
        %>
     
        <div style="position: fixed;  width: 96.5%;padding: 0;">
    <center><div id='ProviderReviewSummary' style="z-index: 100; background-color: #333333; width: 100%; box-shadow: 3px 3px 3px darkslategrey; max-width: 420px; margin-bottom: 5px; padding: 3px; padding-top: 10px; padding-bottom: 10px; border-radius: 10px; border: 1px solid white;">
           
            
                            <%
                                if(Base64ProvImage == ""){
                            %> 
                            
                            <center><img style="border-radius: 5px; float: left; border-radius: 100%;" src="icons/icons8-user-filled-50.png" height="50" width="50" alt="icons8-user-filled-50"/>

                                </center>
                                    
                            <%
                                }else{
                            %>
                            <center><img style="border-radius: 5px; float: left; border-radius: 100%;" src="data:image/jpg;base64,<%=Base64ProvImage%>" height="50" width="50" /></center>
                                    
                            <%
                                }
                            %>
                            
                            <div style="width: 81%; float: right;">
                                <p style='color: white; text-align: left; margin: 0; font-weight: bolder;'><%=ProvFullName%></p>
            <p style='color: white; text-align: left; margin: 0;'><%=ProvCompany%> - <%=ServiceType%></p>
            <p style='color: darkgray; text-align: left; margin: 0;'>Total Rating: <span style="color: orange; font-size: 25px;">
                                                    
                                
                                        <%
                                            if(ProvRating == 5){
                                        
                                        %> 
                                        ★★★★★
                                        <%
                                             }else if(ProvRating == 4){
                                        %>
                                        ★★★★☆
                                        <%
                                             }else if(ProvRating == 3){
                                        %>
                                        ★★★☆☆
                                        <%
                                             }else if(ProvRating == 2){
                                        %>
                                        ★★☆☆☆
                                        <%
                                             }else if(ProvRating == 1){
                                        %>
                                        ★☆☆☆☆
                                        <%}%>
                                        </span>
            </p>
            <p id='summeryBtn' onclick='showSummery();' style="text-align: center; color: tomato; margin: 0;border-top: 1px solid darkgray; padding: 5px; width: 96%; margin-top: 5px;">Summary</p>
            <div id='providerReviewSummery'>
            <p style="color: darkgray; margin: 0; text-align: left;">Total Reviews: <span style="color:#6699ff ;"> <%if(NumberOfRatings == 1){%>Review<%} else{%> Reviews<%}%> from
                    <%=NumberOfRatings%> <%if(NumberOfRatings == 1){%>person.<%} else{%> people.<%}%></span></p>
            
            <p style="color: darkgray; margin: 0; text-align: left;">Rating Score: <span style="color:#6699ff ;">Scores <%=TotalRatings%>/<%=FullRating%> points.</span></p>
            <p style="color: darkgray; margin: 0; text-align: left;">Exact Rating: <span style="color:#6699ff ;">Gets <%=CalculatedRating%>/5 stars.</span></p>
            <p style="color: darkgray; margin: 0; text-align: left;">Approximated Rating: <span style="color:#6699ff ;">Rated as <%=RatingsAvg%><%if(RatingsAvg == 1){%> star.<%} else{%> stars.<%}%></span></p>
            </div>
            </div>
            <script>
                   
                function showSummery(){
                    
                    if($(window).width() < 1000){
                        
                        if(document.getElementById("providerReviewSummery").style.display === "none"){
                            $("#providerReviewSummery").slideDown("fast");
                            document.getElementById("providerReviewSummery").style.display = "block";
                            document.getElementById("summeryBtn").innerHTML = "Minimize";
                        }else{
                            $("#providerReviewSummery").slideUp("fast");  
                            document.getElementById("providerReviewSummery").style.display = "none";
                            document.getElementById("summeryBtn").innerHTML = "Summary";
                        }

                    }
                };
                
            </script>
                            
            <p style="clear: both;"></p>
            
        </div></center>
        </div>
        
        <div id='ProviderReviewsListDiv' style="">
            
        <h3 style='color: white; text-align: center; margin: 0;'>Reviews</h3>
        
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
        
                         <center><div style='background-color: black; padding: 1px; padding-top: 10px; padding-bottom: 10px; margin-bottom: 1px; width: 99%; max-width: 500px; margin-left: 0;'>
                    
                            <%
                                if(Base64Image == ""){
                            %> 
                            
                            <center><img style="border-radius: 5px; float: left; width: 15%;" src="icons/icons8-user-filled-50.png" alt="icons8-user-filled-50"/>

                                </center>
                                    
                            <%
                                }else{
                            %>
                            <center><img style="border-radius: 5px; float: left; width: 15%;" src="data:image/jpg;base64,<%=Base64Image%>"/></center>
                                    
                            <%
                                }
                            %>
                            
            <center><div style='float: right; width: 84%;'>                 
            <p style='color: white; text-align: left; margin: 0; font-weight: bolder;'><%=CustomerFullName%></p>
            
            <p style='color: darkgray; text-align: left; margin: 0;'>Rated: <span style="color: blue; font-size: 25px;">
                                                    
                                
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
            
            <p style='clear: both;'></p>
            
        </div></center>
        
        <%}%>
        
        </div>
    </body>
</html>
