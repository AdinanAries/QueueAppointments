<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.arieslab.queue.queue_model.*"%>
<%@page import="java.util.*"%>

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
        String ServiceType = request.getParameter("formsServiceCategory");
        
        String Date = request.getParameter("formsDateValue");
        String Time = request.getParameter("formsTimeValue");
        String OrderedServices = request.getParameter("formsOrderedServices");
        String Price = request.getParameter("TotalToPay");
        
        if(Price.length() > 5)
            Price = Price.substring(0,5);
        
        int CreditCardNumber = 0;
        String PaymentMethod = request.getParameter("payment");
        
        String ProviderID = request.getParameter("ProviderID");
        String ProviderFullName = request.getParameter("ProviderFullName");
        String ProviderCompany = request.getParameter("ProviderCompany");
        
        

    %>  
    
    <body>
        
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image src="QueueLogo.png" style="margin-top: 5px;"/></center>
            
        </div>
            
        <div id="content">
        
            
            <div id="main">
                
                <cetnter><h4 style="color: white; background-color: red; margin-bottom: 10px;"><%=Message%></h4></cetnter>
                <h3 style="margin-top: 20px; margin-bottom: 5px;">Your Spot Details Provided Below</h3>
                <p style="color: seashell;"><span><%=ProviderFullName%> from <%=ProviderCompany%></span></p>
                <center><table border="0">
                <tbody>
                    
                <tr><td>Category: </td><td style="color: white;"><%=ServiceType%></td></tr>
                <tr><td>Date: </td><td style="color: white;"><%=Date%></td></tr>
                <tr><td>Time: </td><td style="color: white;"><%=Time%></td></tr>
                <tr><td>Reason: </td><td style="color: white;"><%=OrderedServices%></td></tr>
                <tr><td>Total Cost: </td><td style="color: white;"><%=Price%></td></tr>
                
                </tbody>
                </table></center>
            </div>
                
        </div>
                
        <div id="newbusiness">
            
            <center><h2 style="margin-top: 30px; margin-bottom: 20px; color: #000099">
                </h2></center>
            
            <div id="businessdetails">
                
                <center><div id ="logindetails"> <!--style="border-bottom: solid darkblue 1px; padding-bottom: 20px;"-->
                        
                        <center><h2 style="margin-top: 30px; margin-bottom: 10px; color: #000099">Login to finish.</h2></center>

                    
                    <form name="login" action="LoginAndSendAppointmentController" method="POST">
                        
                        
                        <input id="SendApptPID" type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                        <input id="formsOrderedServices" type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                        <input id="formsDateValue" type="hidden" name="AppointmentDate" value="<%=Date%>" />
                        <input id="formsTimeValue" type="hidden" name="AppointmentTime" value="<%=Time%>" />
                        <input id="Payment" type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                        <input id="cardNBR" type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                        <input id="TaxedPrice" type="hidden" name="ServiceCost" value="<%=Price%>" />
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder='enter your Queue user name here' type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="Password" type="password" name="password" value="" size="51"/></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                        
                        <!--script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#loginPageBtn').click(function(event) {  
                                                        
                                                        var ProviderID = document.getElementById("SendApptPID").value;
                                                        var CardNumberr = document.getElementById("cardNBR").value;
                                                        var PayMeth = document.getElementById("Payment").value;
                                                        var TotalPrice = document.getElementById("TaxedPrice").value;
                                                        var ApptDate = document.getElementById("formsDateValue").value;
                                                        var ApptTime = document.getElementById("formsTimeValue").value;
                                                        var ApptReason = document.getElementById("formsOrderedServices").value;
                                                        var UserName = document.getElementById("LoginPageUserNameFld").value;
                                                        var Password = document.getElementById("LoginPagePasswordFld").value;
                                                        //var PayMeth = $("input:radio[name=payment]:checked").val();
                                                        
                                                        alert("ProviderID: "+ProviderID);
                                                        alert("CardNumber: "+CardNumberr);
                                                        alert("UserName: "+UserName);
                                                        alert("Password: "+Password);
                                                        alert("TotalPrice: "+TotalPrice);
                                                        alert("ApptDate: "+ApptDate);
                                                        alert("ApptTime: "+ApptTime);
                                                        alert("ApptReason: "+ApptReason);
                                                        alert("Payment Method: "+PayMeth);
                                                        
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "LoginAndSendAppointmentController",  
                                                        data: "ProviderID="+ProviderID+"&DebitCreditCard="+CardNumberr+"&ServiceCost="+TotalPrice+"&AppointmentDate="+ApptDate+"&AppointmentTime="+ApptTime+"&OrderedServices="+ApptReason+"&PaymentMethod="+PayMeth+"&username="+UserName+"&password="+Password,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          if(result === "Success"){
                                                              window.location.replace("ProviderCustomerPage.jsp?UserIndex="+UserIndex);
                                                          }
                                                          //document.getElementById("eachClosedDate<>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script-->
                        
                    </form>
                    
                </div></center>
                        <center><h1 style="margin-top: 15px;">OR</h1></center>
                
                <center><h2 style="margin-top: 20px; color: white; background-color: red;">Don't have user account</h2></center>
                <center><h2 style="color: #000099; margin-bottom: 10px; ">Sign up to finish.</h2></center>

                
            <center><form name="AddBusiness" action="SignupAndSendAppointmentController" method="POST">
                    
                        <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                        <!--input type="hidden" name="CustomerID" value="" /-->
                        <input type="hidden" name="OrderedServices" value="<%=OrderedServices%>" />
                        <input type="hidden" name="AppointmentDate" value="<%=Date%>" />
                        <input type="hidden" name="AppointmentTime" value="<%=Time%>" />
                        <input type="hidden" name="PaymentMethod" value="<%=PaymentMethod%>" />
                        <input type="hidden" name="DebitCreditCard" value="<%=CreditCardNumber%>" />
                        <input type="hidden" name="ServicesCost" value="<%=Price%>" />
                        
                    <table border="0">
                        <tbody>
                            <tr>
                                <td><h3 style="color: white; text-align: center;">Provide your information below</h3></td>
                            </tr>
                            <tr>
                                <td><input id="SUPfirstName" placeholder='enter your first name' type="text" name="firstName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPmiddleName" placeholder='enter your middle name'  type="text" name="middleName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPlastName" placeholder='enter your last name'  type="text" name="lastName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPtelephone" placeholder='enter your telephone/mobile number here'  type="text" name="telNumber" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="SUPemail" placeholder='enter your email address here'  type="text" name="email" value="" size="50"/></td>
                            </tr>
                        </tbody>
                    </table>
                        
                        <div>
                            <h3 style="color: white; margin-top: 10px;">Add your login information</h3>
                            
                            <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="SUPuserName" placeholder='enter login user name here' type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input id="SUPpassword" placeholder='Password' type="password" name="password" value="" size="51"/></td>
                                </tr>
                                <tr>
                                    <td><p>Confirm Password</p><input id="SUPconfirm" placeholder='Re-enter Password' type="password" name="confirm" value="" size="51"/></td>
                                </tr>
                            </tbody>
                            </table>
                            <p id="SignUpAndBookStatus" style="color: white; background-color: red; width: 200px;"></p>
                            
                        </div>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="SignUpAndBookBtn" class="button" type="submit" value="Sign Up" name="submitBtn" />
                </form></center>
                
            </div>
    
            </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/SignUpandSendAppointmentBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
</html>
