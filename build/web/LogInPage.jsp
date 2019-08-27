<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>

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
        String Message = "";
        
        try{
            Message = request.getParameter("Message");
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
        
        int UserID = 0;
        
        int UserIndex = Integer.parseInt(session.getAttribute("UserIndex").toString());
        
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        if(tempAccountType.equals("CustomerAccount"))
            UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        if(tempAccountType.equals("BusinessAccount")){
            request.setAttribute("UserIndex", UserIndex);
            request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        }
        
        else if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");
        }catch(Exception e){}
    %>
    
    <body>
        
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><a href="LoginPageToQueue"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find Your Spot Now!</h3></center>
            
        </div>
            
        <div id="content">
            
            <div id="nav">
                
                <h3><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h3>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center>
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 15px;">
                <center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: white; background-color: blue; border: 1px solid black; padding: 4px;">Click here to go to Queue home page</a></h2></center>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center>
                
                <%if(Message != null){%>
                    <center><h4 style="color: white; margin-bottom: 15px; background-color: red; max-width: 350px;"><%=Message%></h4></center>
                <%}%>
                    
                <center><h2 style="margin-bottom: 20px;">Login Here</h2></center>
                
                <form name="login" action="LoginControllerMain" method="POST"><table border="0"> 
                        
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="45" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder='enter your password here' type="password" name="password" value="" size="45" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                <h5  style = "margin: 10px;" ><a href="SignUpPage.jsp" style="color: white; background-color: blue; padding: 4px; border: 1px solid black;">I don't have a user account. Sign-up now!</a></h5>
                </div></center>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center>
            
            </div>
                
        </div>
                
        <div id="newbusiness" style="height: 525px;">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">Sign-up to add your business or to find a spot</h2></center>
            
            <div id="businessdetails">
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    
                    <table border="0">
                        <tbody>
                            <tr>
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input id="signUpFirtNameFld" placeholder="enter your first name" type="text" name="firstName" value="" size="45"/></td>
                            </tr>
                            <tr>
                                <td><input id="sigUpLastNameFld" placeholder="enter your last name" type="text" name="lastName" value="" size="45"/></td>
                            </tr>
                            <tr>
                                <td><input onclick='checkMiddleNumber()' onkeydown="checkMiddleNumber()" id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="45"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="45"/></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                <script>
                    var TelFld = document.getElementById("signUpTelFld");
                        
                        function numberFunc(){
                            
                            var number = parseInt((TelFld.value.substring(TelFld.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFld.value = TelFld.value.substring(0, (TelFld.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFunc, 1);
                        
                        function checkMiddleNumber(){
                            
                            for(var i = 0; i < TelFld.value.length; i++){

                                var middleString = TelFld.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFld.value = TelFld.value.substring(0, i);
                                }
                            }
                        }
                        
                </script>
            </div>
            
            </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
