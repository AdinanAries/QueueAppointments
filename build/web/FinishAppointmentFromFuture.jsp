<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script-->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        
        <script src="https://js.stripe.com/v3/"></script>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />

        
    </head>
    
    <%
        
        String UserName = request.getParameter("User");
        String UserIndex = request.getParameter("UserIndex");
        int UserID = Integer.parseInt(request.getParameter("CustID"));
        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        //connection arguments
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
        
        try{
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            response.sendRedirect("Queue.jsp");
        }
    %>
    
    <%!
        
       class getUserDetails{
           
           //class fields
           private Connection conn;
           private ResultSet records;
           private String Driver;
           private String url;
           private String User;
           private String Password;
           
           public void initializeDBParams(String driver, String url, String user, String password){
               
               this.Driver = driver;
               this.url = url;
               this.User = user;
               this.Password = password;
           }
           
           public ResultSet getRecords(String ID){
               
               try{
                   
                    Class.forName(Driver);
                    conn = DriverManager.getConnection(url,User,Password);
                    String  select = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement pst = conn.prepareStatement(select);
                    pst.setString(1,ID);
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
            
            //ResendAppointmentData.AppointmentTime = request.getParameter("AppointmentTime");
            String AppointmentTime = request.getParameter("AppointmentTime");
            String FormattedAppointmentTime = " ";
            
            try{
                //formatting the time for user convenience
                FormattedAppointmentTime = AppointmentTime;
                
                if(FormattedAppointmentTime.length() == 4)
                    FormattedAppointmentTime = "0" + FormattedAppointmentTime;
                
                int x = Integer.parseInt(FormattedAppointmentTime.substring(0,2));
                String y = FormattedAppointmentTime.substring(3,5);

               /*
                   if(y.length() < 2){

                       y = "0" + y;
                   }
               */

                   if( x > 12)
                   {
                       int TempHour = x - 12;
                       FormattedAppointmentTime = Integer.toString(TempHour) + ":" +  y + " pm";
                   }
                   else if(x == 0){
                       FormattedAppointmentTime = "12" + ":" + y + " am";
                   }
                   else if(x == 12){
                       FormattedAppointmentTime = AppointmentTime + " pm";
                   }
                   else{
                       FormattedAppointmentTime = AppointmentTime +" am";
                   }
            }catch(Exception e){
                
                FormattedAppointmentTime = " ";
                
            }
           
            String ID = request.getParameter("ProviderID");
            
            getUserDetails details = new getUserDetails();
            details.initializeDBParams(Driver, url, User, Password);
            
            ArrayList <ProviderInfo> providersList = new ArrayList<>();
            ResultSet rows = details.getRecords(ID);
            
            try{
                
                ProviderInfo eachrecord;
                
                while(rows.next()){
                    eachrecord = new ProviderInfo(rows.getInt("Provider_ID"),rows.getString("First_Name"), rows.getString("Middle_Name"), rows.getString("Last_Name"), rows.getDate("Date_Of_Birth"), rows.getString("Phone_Number"),
                                                    rows.getString("Company"), rows.getInt("Ratings"), rows.getString("Service_Type"), rows.getString("First_Name") + " - " +rows.getString("Company"),rows.getBlob("Profile_Pic"), rows.getString("Email"));
                    
                    providersList.add(eachrecord);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            
        %>
        
        <%
            String StripeAccID = "";
            try{
                Class.forName(Driver);
                Connection StripAccIDConn = DriverManager.getConnection(url, User, Password);
                String StripAccIDSql = "select * from QueueServiceProviders.StripeConnectedAccountIDs where ProvID = ?";
                PreparedStatement StripAccIDPst = StripAccIDConn.prepareStatement(StripAccIDSql);
                StripAccIDPst.setString(1, ID);
                ResultSet StripAccRec = StripAccIDPst.executeQuery();
                
                while(StripAccRec.next()){
                    StripeAccID = StripAccRec.getString("StripeConnectID").trim();
                }
            }catch(Exception e){}
        %>
        
        <%
            //getting cancellation policy data
            boolean hasCancellation = false;
            //int CancelElapse = 0;
            int ChargePercent = 0;
            
             try{
                Class.forName(Driver);
                Connection CnclPlcyConn = DriverManager.getConnection(url, User, Password);
                String CnclPlcyString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyChargeCost%' ";
                PreparedStatement CnclPlcyPst = CnclPlcyConn.prepareStatement(CnclPlcyString);
                CnclPlcyPst.setString(1,ID);
                ResultSet CnclRow = CnclPlcyPst.executeQuery();
                
                while(CnclRow.next()){
                    
                    if(!CnclRow.getString("CurrentValue").trim().equals("0")){
                        
                        hasCancellation = true;
                        ChargePercent = Integer.parseInt(CnclRow.getString("CurrentValue").trim());
                        //CancelElapse = Integer.parseInt(CnclRow.getString("CurrentValue").trim());
                        
                        /*try{
                            Class.forName(Driver);
                            Connection CnclPlcyConn2 = DriverManager.getConnection(url, User, Password);
                            String CnclPlcyString2 = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'CnclPlcyChargeCost%' ";
                            PreparedStatement CnclPlcyPst2 = CnclPlcyConn2.prepareStatement(CnclPlcyString2);
                            CnclPlcyPst2.setString(1,ID);
                            ResultSet CnclRow2 = CnclPlcyPst2.executeQuery();
                            
                            while(CnclRow2.next()){
                                ChargePercent = Integer.parseInt(CnclRow2.getString("CurrentValue").trim());
                            }
                            
                        }
                        catch(Exception e){
                            e.printStackTrace();
                        }*/
                        
                    }
                    //JOptionPane.showMessageDialog(null, ChargePercent);
                    //JOptionPane.showMessageDialog(null, CancelElapse);
                    //JOptionPane.showMessageDialog(null, hasCancellation); 
                }
            }catch(Exception e){
                e.printStackTrace();
            }
            
            String status = "not_added";
        
            //getting the subscription status
            try{
                Class.forName(Driver);
                Connection SubsConn = DriverManager.getConnection(url, User, Password);
                String SubsString = "select status from QueueObjects.StripSubscriptions where ProvId = ?";
                PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);

                SubsPst.setString(1, ID);

                ResultSet SubsRec = SubsPst.executeQuery();

                while(SubsRec.next()){
                    if(SubsRec.getString("status").equalsIgnoreCase("0")){
                        status = "inactive";
                    } else if (SubsRec.getString("status").equalsIgnoreCase("1")){
                        status = "active";
                    }
                }

            }catch(Exception e){}
            //JOptionPane.showMessageDialog(null, status);
        %>
        
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="padding-bottom: 0; background-color: #ccccff;">
        
        <div id='LoginAndSignupForms' 
             style='height: 100vh; width: 100vw; background-color: rgba(0,0,0,0.4); 
             position: fixed; z-index: 1100; display: flex; flex-direction: column; justify-content: center;
             '>
            <div style='height: 90%;'>
                <div style='width: 90%; max-width: 600px; background-color: #8FC9F0; margin: auto; border-radius: 10px; height: 100%;'>
                    
                    <div style='background-color: white !important; padding-bottom: 30px; border-top-right-radius: 10px; border-top-left-radius: 10px;
                            clip-path: polygon(100% 0, 100% 66%, 91% 73%, 79% 79%, 64% 83%, 50% 86%, 33% 90%, 18% 94%, 0 100%, 0 0);'>
                        <p style="text-align: center;"><img src="QueueLogo.png" style="margin-top: 20px; width: 80px; height: auto;"/></p>
                        <p style='color: darkblue; font-weight: bolder; text-align: center; margin-bottom: 20px; margin-top: 10px;'>
                        <i style='color: red;' class="fa fa-exclamation-triangle"></i> You have to login/signup to continue</p>
                    </div>
                    
                    <div style="height: 60%; display: flex; flex-direction: column; justify-content: center;
                         padding: 10px 5px; overflow-y: auto;">
                        <div id='FnshApptLoginForm' style="width: fit-content; margin: auto;">
                            <p style="font-size: 20px; text-align: center; font-weight: bolder; color: #334d81; margin-bottom: 20px;">Login</p>
                            <table border="0">
                                <tbody>
                                    <tr>
                                        <td>
                                            <fieldset class="loginInputFld">
                                                <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                                <input id="LoginPageUserNameFld" placeholder='Enter username here' type="text" name="username" value="" size="34"/>
                                            </fieldset>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <fieldset class="loginInputFld">
                                                <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                                <input class="passwordFld" id="LoginPagePasswordFld" placeholder="Enter password here" type="password" name="password" value="" size="34"/>
                                                <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                            </fieldset>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <div style="width: fit-content; margin: auto;">
                                <input class="button" type="reset" value="Reset" name="resetbtn"/>
                                <input onclick="document.getElementById('PageLoader').style.display = 'block';" id="loginAndBookApptBtn" class="button" type="submit" value="Login" name="submitbtn" />
                            </div>
                            
                        </div>
                        <div id='FnshApptSignupForm' style="display: none; width: fit-content; margin: auto; padding-top: 320px;">
                            <p style="font-size: 20px; text-align: center; font-weight: bolder; color: #334d81; margin-bottom: 20px;">Signup</p>
                            <table border="0">
                            <tbody>

                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                            <input id="SUPfirstName" placeholder='Enter first name here' type="text" name="firstName" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <!--fieldset class="loginInputFld">
                                            <legend>Enter your middle name</legend>
                                            <span class="fa fa-user"></span-->
                                            <input id="SUPmiddleName" placeholder='middlename'  type="hidden" name="middleName" value=" " size="34"/>
                                        <!--/fieldset-->
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                            <input id="SUPlastName" placeholder='Enter last name here'  type="text" name="lastName" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                            <input id="SUPtelephone" placeholder='Enter mobile here'  type="text" name="telNumber" value="" size="34"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p id='CustEmailStatus' style='color: white; display: none; text-align: center; margin: 10px 0;'></p>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                            <input onchange='CustSetVerifyFalse();' placeholder='Enter email here' onfocusout='CustCloseEmailVerify();' onfocus='CustShowEmailVerify();' type="text" id="visibleEmail" name="email" value="" size="34" />
                                        </fieldset>
                                        <input id="SUPemail" type="hidden" name="email" value="" size="37"/>
                                        <div id='CustEmailVeriDiv' style='display: none; background-color: #3d6999; padding: 10px; margin: 5px;'>
                                                <div id='CustsendVerifyDiv'>
                                                    <center><input id='CustSendverifyEmailBtn' type='button' value='1. Click to send verification code' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                                </div>
                                                <div id='CustverifyDiv' style='border-top: darkblue 1px solid; margin-top: 10px; padding-top: 5px;'>
                                                    <p id='CustvCodeStatus' style='padding-left: 5px; color: white; max-width: 250px; margin: 10px 0;'><span style="color: #ffc700; font-weight: bolder;">2.</span> We will be sending a verification code to your email. You should enter the code below</p>
                                                    <p style='color: #ccc;'><input placeholder="Enter 6-digit code here" id="CustEmailConfirm" type="text" /></p>
                                                </div>
                                                <center><input id='CustverifyEmailBtn' onclick="CustVerifyCode();" type='button' value='3. Click to verify entered code ' style='color: white; background-color: #334d81; border: 0; width: 95%; padding: 10px; border-radius: 4px;'/></center>
                                                <script>

                                                    var CustEmailVerified = false; //main controller for all verification related operations. This flag switches to true or false in order to determine what actions to be taken by the verification algorithm
                                                    var CustPageJustLoaded = true;

                                                    if(document.getElementById("visibleEmail").value !== ""){
                                                        //Execute this code when page loads with information from prio page
                                                        CustPageJustLoaded = false;
                                                    }

                                                    setInterval(function(){

                                                        if(!CustPageJustLoaded){

                                                            if(CustEmailVerified){
                                                                document.getElementById("CustEmailStatus").style.display = "block";
                                                                //document.getElementById("CustEmailStatus").style.backgroundColor = "green";
                                                                document.getElementById("CustEmailStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Your email has been verified";
                                                                document.getElementById("SUPemail").value = document.getElementById("visibleEmail").value;
                                                                document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                            }else{
                                                                document.getElementById("CustEmailStatus").style.display = "block";
                                                                //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                                document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please verify your email";
                                                                document.getElementById("SUPemail").value = "";
                                                            }
                                                        }

                                                    }
                                                    ,1);

                                                    var CustSetVerifyFalse = function(){
                                                        CustEmailVerified = false;
                                                        document.getElementById("CustSendverifyEmailBtn").style.display = "block";
                                                    };
                                                    var CustShowEmailVerify = function(){
                                                        document.getElementById("CustEmailVeriDiv").style.display = "block";
                                                        //document.getElementById("provSignUpBtn").style.display = "none";
                                                    };
                                                    var CustCloseEmailVerify = function(){
                                                        CustPageJustLoaded = false;
                                                        if(document.getElementById("visibleEmail").value === ""){
                                                            document.getElementById("CustEmailVeriDiv").style.display = "none";
                                                            document.getElementById("CustEmailStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please enter a valid email";
                                                            //document.getElementById("CustEmailStatus").style.backgroundColor = "red";
                                                            //document.getElementById("provSignUpBtn").style.display = "block";
                                                        }
                                                    };

                                                    var CustVeriCode;

                                                    $(document).ready(function(){
                                                        $("#CustSendverifyEmailBtn").click(function(event){
                                                            //document.getElementById('PageLoader').style.display = 'block';
                                                            CustVeriCode = Math.floor(100000 + Math.random() * 900000);
                                                            CustVeriCode = CustVeriCode + "";

                                                            document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: #58FA58;' class='fa fa-check'></i> Verification Code has been sent to your Email";
                                                            //document.getElementById("CustvCodeStatus").style.backgroundColor = "green";
                                                            document.getElementById("CustSendverifyEmailBtn").style.display = "none";

                                                            var to = document.getElementById("visibleEmail").value;
                                                            var Message = CustVeriCode + ' is your Queue verification code';

                                                            $.ajax({
                                                                type: "POST",
                                                                url: "QueueMailer",
                                                                data: "to="+to+"&subject=Queue%20Email%20Verification&msg="+Message,
                                                                success: function(result){
                                                                    //document.getElementById('PageLoader').style.display = 'none';
                                                                }
                                                            });
                                                            //document.getElementById("CustEmailConfirm").value = CustVeriCode;
                                                        });
                                                    });

                                                    var CustVerifyCode = function () {

                                                        if(document.getElementById("CustEmailConfirm").value === CustVeriCode){
                                                            CustEmailVerified = true;
                                                        }
                                                        else{
                                                            document.getElementById("CustvCodeStatus").innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Make sure verification code is entered or is correct";
                                                            //document.getElementById("CustvCodeStatus").style.backgroundColor = "red";
                                                        }

                                                    };
                                                </script>
                                            </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                            <div>
                                <h3 style="color: darkblue; margin: 10px 0;">Add your login information</h3>

                                <table border="0">
                                <tbody>
                                    <tr>
                                        <td>
                                            <fieldset class="loginInputFld">
                                                <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                                <input onkeyup="setPasswordsZero();" onchange="CustUserNameCheck();" id="SUPuserName" placeholder='Enter username here' type="text" name="username" value="" size="34"/>
                                            </fieldset>
                                            <p id="CustUserNameStatus" style="color: black; text-align: center; max-width: 250px; margin: 10px 0;"></p>
                                        </td>
                                    </tr>

                                    <script>
                                        function setPasswordsZero(){
                                            document.getElementById("SUPconfirm").value = "";
                                            document.getElementById("SUPpassword").value = "";
                                        }

                                        function CustUserNameCheck(){

                                            var userName = document.getElementById("SUPuserName").value;

                                            $.ajax({
                                                type: "POST",
                                                url: "CheckCustUserNameExists",
                                                data: "UserName="+userName,
                                                success: function(result){
                                                    //alert(result);

                                                    if(document.getElementById("SUPuserName").value === ""){

                                                        document.getElementById("CustUserNameStatus").innerHTML = "";

                                                    }
                                                    else if(result === "true"){

                                                        document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: red;" class="fa fa-exclamation-triangle"></i> <span style="color: blue;">"' + userName + '"</span> is not available. Choose a different Username';
                                                        //document.getElementById("CustUserNameStatus").style.backgroundColor = "red";
                                                        document.getElementById("SUPuserName").value = "";

                                                    }else if(result === "false" && document.getElementById("SUPuserName").value !== ""){

                                                        document.getElementById("CustUserNameStatus").innerHTML = '<i style="color: #58FA58;" class="fa fa-check"></i> <span style="color: blue;">"' + userName + '"</span> is available.';
                                                        //document.getElementById("CustUserNameStatus").style.backgroundColor = "green";

                                                    }
                                                }
                                            });
                                        }
                                    </script>

                                    <tr>
                                        <td>
                                            <fieldset class="loginInputFld">
                                                <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                                <input class="passwordFld" id="SUPpassword" placeholder='Enter new password here' type="password" name="password" value="" size="34"/>
                                                <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                            </fieldset>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <fieldset class="loginInputFld">
                                                <p style="border-bottom: #ccc 1px solid; margin-bottom: 5px; padding-bottom: 5px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                                <input class="passwordFld" id="SUPconfirm" placeholder='Confirm password here' type="password" name="confirm" value="" size="34"/>
                                            </fieldset>
                                        </td>
                                    </tr>
                                </tbody>
                                </table>
                                <p id="SignUpAndBookStatus" style="color: black; width: 200px; margin: 10px 0;"></p>

                            </div>
                            
                            <div style="width: fit-content; margin: auto;">
                                <input class="button" type="reset" value="Reset" name="resetBtn" />
                                <input id="SignUpAndBookBtn" class="button" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Sign Up" name="submitBtn" />
                            </div>
                            
                        </div>
                    </div>
                    <p id='showSignupWndwLnk' style='cursor: pointer; font-weight: bolder; text-align: center; color: darkblue; margin-top: 20px;'>Don't have an account? <span style='color: white;'>Signup here</span></p>
                    <p id='showLoginWndwLnk' style='cursor: pointer; display: none; font-weight: bolder; text-align: center; color: darkblue; margin-top: 20px;'>Already have an account? <span style='color: white;'>Login here</span></p>
                </div>
                
                <script>
                    function showSignup(){
                        $("#FnshApptLoginForm").slideUp("fast");
                        $("#FnshApptSignupForm").slideDown("fast");
                    }
                    document.getElementById("showSignupWndwLnk").addEventListener("click", ()=>{
                        document.getElementById("showSignupWndwLnk").style.display = "none";
                        document.getElementById("showLoginWndwLnk").style.display = "block";
                        showSignup();
                    });
                    function showLogin(){
                        $("#FnshApptSignupForm").slideUp("fast");
                        $("#FnshApptLoginForm").slideDown("fast");
                    }
                    document.getElementById("showLoginWndwLnk").addEventListener("click", ()=>{
                        document.getElementById("showLoginWndwLnk").style.display = "none";
                        document.getElementById("showSignupWndwLnk").style.display = "block";
                        showLogin();
                    });
                </script>
                
            </div>
        </div>
        
        <script>
            var LoggedIn = true;
            
            var UserID = 0;
            var UserIndex = -1;
            var UserName = "";
            
            document.getElementById("loginAndBookApptBtn").addEventListener("click", ()=>{
                
                let Username = document.getElementById("LoginPageUserNameFld").value;
                let Password = document.getElementById("LoginPagePasswordFld").value;
                
                if(Username === ""){
                    alert("please enter your username");
                    document.getElementById("PageLoader").style.display = "none";
                }else if(Password === ""){
                    alert("please enter your password");
                    document.getElementById("PageLoader").style.display = "none";
                }else{
                    $.ajax({
                        type: "POST",
                        url: "./LoginBeforeFinishApptControl",
                        data: "username="+Username+"&password="+Password,
                        success: function(result){
                            //console.log(result);
                            let resObj = JSON.parse(result);
                            if(resObj.status === "success"){
                                document.getElementById("PageLoader").style.display = "none";
                                let UserID = resObj.customerID;
                                let UserName = resObj.customerName;
                                let UserIndex = resObj.loginIndex;
                                /*alert(UserID);
                                alert(UserName);
                                alert(UserIndex);*/
                                document.getElementById("SendApptCustID").value = UserID;
                                document.getElementById("SendApptUserIndex").value = UserIndex;
                                document.getElementById("sendApptUser").value = UserName;
                                
                                document.getElementById("GenfutureCustID").value = UserID;
                                document.getElementById("GenFutureUserIndex").value = UserIndex;
                                document.getElementById("GenFutureUserNameFld").value = UserName;
                                  
                                LoggedIn = true;
                                alert('Login successful!');
                            }else{
                                document.getElementById("PageLoader").style.display = "none";
                                alert("Unable to login. Please check your username and password");
                            }
                        }
                    });
                }
                
            });
            document.getElementById("SignUpAndBookBtn").addEventListener("click", ()=>{
                
                let FirstName = document.getElementById("SUPfirstName").value;
                let MiddleName = document.getElementById("SUPmiddleName").value;
                let LastName = document.getElementById("SUPlastName").value;
                let Email = document.getElementById("SUPemail").value;
                let Mobile = document.getElementById("SUPtelephone").value;
                let Username = document.getElementById("SUPuserName").value;
                let Password = document.getElementById("SUPpassword").value;
                
                
                    $.ajax({
                        type: "POST",
                        url: "./SignupBeforeFinishApptControl",
                        data: "firstName="+FirstName+"&middleName="+MiddleName+"&lastName="+LastName+"&email="+Email+"&phoneNumber="+Mobile+"&userName="+Username+"&firstPassword="+Password,
                        success: function(result){
                            //console.log(result);
                            let resObj = JSON.parse(result);
                            if(resObj.status === "success"){
                                document.getElementById("PageLoader").style.display = "none";
                                let UserID = resObj.customerID;
                                let UserName = resObj.customerName;
                                let UserIndex = resObj.loginIndex;
                                /*alert(UserID);
                                alert(UserName);
                                alert(UserIndex);*/
                                document.getElementById("SendApptCustID").value = UserID;
                                document.getElementById("SendApptUserIndex").value = UserIndex;
                                document.getElementById("sendApptUser").value = UserName;
                                
                                document.getElementById("GenfutureCustID").value = UserID;
                                document.getElementById("GenFutureUserIndex").value = UserIndex;
                                document.getElementById("GenFutureUserNameFld").value = UserName;
                                  
                                LoggedIn = true;
                                alert('Signup successful!');
                            }else{
                                document.getElementById("PageLoader").style.display = "none";
                                alert(resObj.msg);
                            }
                        }
                    });
                    
            });
            setInterval(()=>{
                if(LoggedIn === true){
                    document.getElementById("LoginAndSignupForms").style.display = "none";
                }else{
                    document.getElementById("LoginAndSignupForms").style.display = "flex";
                }
            });
        </script>
        
        <div id='QShowNews22' style='width: fit-content; bottom: 5px; margin-left: 4px; position: fixed; background-color: #3d6999; padding: 5px 9px; border-radius: 50px;
                 box-shadow: 0 0 5px 1px black;'>
                <center><a onclick="document.getElementById('PageLoader').style.display = 'block';" href="Queue.jsp"><p  
                    style='color: black; padding-top: 5px; cursor: pointer; margin-bottom: 0; width:'>
                        <img style='background-color: white; width: 25px; height: 24px; border-radius: 4px;' src="icons/icons8-home-50.png" alt="icons8-home-50-50"/>
                </p>
                <p style='font-size: 15px; color: white; margin-top: -5px;'>Home</p>
                </a></center>
            </div>
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <div id="PermanentDiv" style="">
            
            <div style="margin-top: 3px; margin-right: 10px; width: fit-content; display: flex;">
                
                <p style="color: white; text-align: justify;">
                    <i style='' class='fa fa-phone'></i>
                    +1 732-799-9546
                    <br />
                    <i class='fa fa-envelope'></i>
                    support@theomotech.com   
                </p>
            </div>
            
            <div id="ExtraDivSearch" style='padding: 3px; margin-right: 20px; margin-left: 20px; margin-top: 1.2px; border-radius: 4px;'>
                <form action="QueueSelectBusinessSearchResult.jsp" method="POST">
                    <input style="width: 450px; margin: 0; background-color: #d9e8e8; height: 30px; border-radius: 4px; font-weight: bolder;"
                            placeholder="Search service provider" name="SearchFld" type="text"  value="" />
                    <input style="font-weight: bolder; margin: 0; background-color: cadetblue; color: white; border-radius: 4px; padding: 5px 7px; font-size: 15px;" 
                           onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Search" />
                </form>
            </div>
            
            <div style="display: flex;">
                <ul style="margin-right: 5px;">
                    <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href="Queue.jsp">
                        <li style='cursor: pointer; background-color: #334d81;' class="active"><!--img style='background-color: white;' src="icons/icons8-home-50.png" width="20" height="17" alt="icons8-home-50"/-->
                        <i class="fa fa-home"></i>
                        Home</li></a>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-calendar-50.png" width="20" height="17" alt="icons8-calendar-50"/-->
                        <i class="fa fa-calendar"></i>
                        Calender</li>
                    <li style='cursor: pointer;'><!--img style='background-color: white;' src="icons/icons8-user-50 (1).png" width="20" height="17" alt="icons8-user-50 (1)"/-->
                        <i class="fa fa-cog"></i>
                        Account</li>
                </ul>
            
                <a onclick="document.getElementById('HomePageLoader').style.display = 'block';" href='NewsUpadtesPage.jsp'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-newspaper-o"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">News</span></p>
                    </div>
                </a>
                
                <a href="Queue.jsp" id='ExtraDrpDwnBtn'>
                    <div style='border-radius: 4px; width: 40px;'>
                        <p style="text-align: center; padding: 5px;"><i style='color: #8FC9F0;  padding-bottom: 0; font-size: 22px;' class="fa fa-home"></i>
                        </p><p style="text-align: center; margin-top: -10px;"><span style="color: #8FC9F0; font-size: 11px;">Home</span></p>
                    </div>
                </a>
                
                <!--div style="">
                        <center><div style="text-align: left; padding-top: 5px; margin-bottom: 0; padding-bottom: 0;">
                           <i style="font-size: 34px; color: darkgrey;" class="fa fa-user-circle" aria-hidden="true"></i> 
                        </div--></center>
                </div>
            </div>

        <div id="container">
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <!--a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ProviderCustomerPage.jsp"><li><img src="icons/icons8-home-24.png" width="24" height="24" alt="icons8-home-24"/>
                            </li></a-->
                        <li onclick="scrollToTop()"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="padding: 5px;" placeholder="Search provider" name="SearchFld" type="text"  value=""/>
                            <input onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            <div style="text-align: center;"><p> </p>
            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="PageController" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a>
            <p id="LogoBelowTxt" style="font-size: 20px; margin: 0;"><b>Find medical & beauty places</b></p></div>
        </div>
            
        <div id="main_body_flex">
            
            <div id="Extras">
            
            <div id="ExtrasInnerContainer">
                <%
                    int newsItems = 0;
                    
                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select top 1 * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        
                        while(newsRec.next()){
                            
                            String base64Profile = "";
                            newsItems++;
                            
                            String ProvID = newsRec.getString("ProvID");
                            String ProvFirstName = "";
                            String ProvCompany = "";
                            String ProvAddress = "";
                            String ProvTel = "";
                            String ProvEmail = "";
                            String ServiceType = "";
                            
                            String Msg = newsRec.getString("Msg").trim();
                            String MsgPhoto = "";
                            
                            try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob Pic = newsRec.getBlob("MsgPhoto"); 
                                    InputStream inputStream = Pic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                    MsgPhoto = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){

                                }
                            

                                try{
                                    Class.forName(Driver);
                                    Connection ProvConn = DriverManager.getConnection(url, User, Password);
                                    String ProvQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                                    PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                                    ProvPst.setString(1, ProvID);
                                    
                                    ResultSet ProvRec = ProvPst.executeQuery();
                                    
                                    while(ProvRec.next()){
                                        
                                        ServiceType = ProvRec.getString("Service_Type").trim();
                                            
                                        ProvFirstName = ProvRec.getString("First_Name").trim();
                                        ProvCompany = ProvRec.getString("Company").trim();
                                        ProvTel = ProvRec.getString("Phone_Number").trim();
                                        ProvEmail = ProvRec.getString("Email").trim();
                                        
                                        try{    
                                            //put this in a try catch block for incase getProfilePicture returns nothing
                                            Blob Pic = ProvRec.getBlob("Profile_Pic"); 
                                            InputStream inputStream = Pic.getBinaryStream();
                                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                            byte[] buffer = new byte[4096];
                                            int bytesRead = -1;

                                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                                outputStream.write(buffer, 0, bytesRead);
                                            }

                                            byte[] imageBytes = outputStream.toByteArray();

                                            base64Profile = Base64.getEncoder().encodeToString(imageBytes);

                                        }catch(Exception e){}
                                    }
                                    
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                                
                                try{
                                    Class.forName(Driver);
                                    Connection ProvLocConn = DriverManager.getConnection(url, User, Password);
                                    String ProvLocQuery = "select * from QueueObjects.ProvidersAddress where ProviderID = ?";
                                    PreparedStatement ProvLocPst = ProvLocConn.prepareStatement(ProvLocQuery);
                                    ProvLocPst.setString(1, ProvID);
                                    
                                    ResultSet ProvLocRec = ProvLocPst.executeQuery();
                                    
                                    while(ProvLocRec.next()){
                                        String HouseNumber = ProvLocRec.getString("House_Number").trim();
                                        String Street = ProvLocRec.getString("Street_Name").trim();
                                        String Town = ProvLocRec.getString("Town").trim();
                                        String City = ProvLocRec.getString("City").trim();
                                        String ZipCode = ProvLocRec.getString("Zipcode").trim();
                                        
                                        ProvAddress = HouseNumber + " " + Street + ", " + Town + ", " + City + " " + ZipCode;
                                    }
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                                
                %>
                
                <a href="./NewsUpadtesPage.jsp">
                    <p style="padding: 10px; color: #44484a; font-weight: bolder; margin: auto; width: fit-content;">
                        <i style="margin-right: 5px;" class="fa fa-newspaper-o"></i>
                        Click here to see more ads
                    </p>
                </a>
                
                
                <table  id="ExtrasTab" cellspacing="0" style="margin-bottom: 5px;">
                        <tbody>
                            <tr style="background-color: #eeeeee;">
                                <td>
                                    <div id="ProvMsgBxOne">
                                        
                                        <div style='font-weight: bolder;'>
                                            <!--div style="float: right; width: 65px;" -->
                                                <%
                                                    if(base64Profile != ""){
                                                %>
                                                    <div style="margin: 4px; width:35px; height: 35px; border-radius: 100%; float: left; overflow: hidden;">    
                                                        <img id="" style="background-color: darkgray; width:35px; height: auto;" src="data:image/jpg;base64,<%=base64Profile%>"/>
                                                    </div>
                                                <%
                                                    }else{
                                                %>
                                                    <img style='margin: 4px; width:35px; height: 35px; background-color: beige; border-radius: 100%; float: left;' src="icons/icons8-user-filled-100.png" alt="icons8-user-filled-100"/>
                                                <%}%>
                                            <!--/div-->
                                            <div>
                                                <b>
                                                    <a href="EachSelectedProvider.jsp?UserID=<%=ProvID%>">
                                                        <p onclick="document.getElementById('PageLoader').style.display = 'block';" style="color: #3d6999;">
                                                            <%=ProvFirstName%> 
                                                            <span style="border-radius: 4px; color: white; background-color: #3d6999; padding: 5px; font-size: 12px; font-weight: initial; margin-left: 10px;">
                                                                go to profile <i style="color: #ff6b6b; font-weight: initial;" class="fa fa-chevron-right"></i>
                                                            </span>
                                                        </p>
                                                    </a>
                                                </b>
                                                <p style='color: red; margin-top: 5px;'><%=ProvCompany%></p>
                                            </div>
                                        </div>
                                    </div>      
                                </td>
                            </tr>
                            <tr style="background-color: #eeeeee;">
                                <td style="padding: 0;">
                                    <div style="display: flex; flex-direction: row; justify-content: space-between; padding: 5px; padding-top: 0;">
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="mailto:<%=ProvEmail%>">
                                                <i style="font-size: 20px;" class="fa fa-envelope" aria-hidden="true"></i> Mail
                                            </a>  
                                        </p>
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="tel:<%=ProvTel%>">
                                                <i style="font-size: 20px;" class="fa fa-mobile" aria-hidden="true"></i> Call
                                            </a>
                                        </p>
                                        <p style="background-color: #06adad; padding: 5px; border-radius: 4px; width: 28%; text-align: center;">
                                            <a style="color: white;" href="https://maps.google.com/?q=<%=ProvAddress%>" target="_blank">
                                                <i style="font-size: 20px;" class="fa fa-location-arrow" aria-hidden="true"></i> Map
                                            </a>
                                        </p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p style='font-family: helvetica; text-align: justify; padding: 3px;'><%=Msg%></p>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 0;">
                                    <div>
                                        <%if(MsgPhoto.equals("")){%>
                                        <center><img src="view-wallpaper-7.jpg" width="100%" alt="view-wallpaper-7"/></center>
                                        <%} else{ %>
                                        <center><img src="data:image/jpg;base64,<%=MsgPhoto%>" width="100%" alt="NewsImage"/></center>
                                        <%}%>

                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
            <%
                        if(newsItems > 10)
                            break;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
            %>
            
            </div>
            
            <%
                if(newsItems == 0){
            %>

                <p style="font-weight: bolder; margin-top: 50px; text-align: center;"><i class="fa fa-exclamation-triangle" style="color: orange;"></i> No news items found at this time</p>

            <%
                }
            %>
            
                <div class='eachCSecFlex marginUp20' style='margin-left: -10px; width: 100%; margin-top: 10px;'>
                    <h1>Our businesses keep you posted</h1>
                    <div style='margin: auto; width: 100%; max-width: 300px; padding: 10px; padding-top: 20px;
                           display: flex; justify-content: flex-end; flex-direction: column;'>
                        <p style='text-align: center;'><img src='NewsPic.png'  style='width: 80px; height: 80px'/></p>
                        <p style='color: #37a0f5; padding: 5px;'>Our integrated news feed feature lets businesses post regular ads to keep you informed</p>
                    </div>
                </div>
            
            </div>
            
            <div id="content">
            
            <div id="nav">
                
                <!--h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4-->
                <!--h3>Your Dashboard</a></h3-->
                <!--center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center-->
                
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Search" name="SearchBtn" />
                     </form> 
                        
                </div></center> 
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                <center><div id="providerlist">
                <!--h4 style="color: black; padding-top: 5px;">Finish Here</h4-->
                
                <center><table id="providerdetails" style="">
                        
                    <%
                        
                        for(int i = 0; i < providersList.size(); i++){ 
                            
                            String fullName = providersList.get(i).getFirstName() + " " + providersList.get(i).getMiddleName() + " " + providersList.get(i).getLastName();
                            String Company = providersList.get(i).getCompany();
                            String Email = providersList.get(i).getEmail();
                            String phoneNumber = providersList.get(i).getPhoneNumber();
                            
                                                    
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
                            
                            int PID = providersList.get(i).getID();
                            
                            try{
                                
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String selectAddress = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                                PreparedStatement pst = conn.prepareStatement(selectAddress);
                                pst.setInt(1,PID); //seting value for query place holder to selected provider's ID
                                ResultSet address = pst.executeQuery();

                                while(address.next()){
                                    
                                    providersList.get(i).setAddress(address.getInt("House_Number"), address.getString("Street_Name"), address.getString("Town"),address.getString("City"),address.getString("Country"),address.getInt("Zipcode"));
                                    
                                }
                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            String fullAddress = "address data not found";
                            
                            try{
                                
                                int hNumber = providersList.get(i).Address.getHouseNumber(); 
                                String sName = providersList.get(i).Address.getStreet().trim(); //trimming records to clean records
                                String tName = providersList.get(i).Address.getTown().trim();
                                String cName = providersList.get(i).Address.getCity().trim();
                                String coName = providersList.get(i).Address.getCountry().trim();
                                int zCode = providersList.get(i).Address.getZipcode();
                                fullAddress = Integer.toString(hNumber) + " " + sName + ", " + tName + ", " + cName + ", " + coName + " " + Integer.toString(zCode);

                            }catch(Exception e){}
                            int ratings = providersList.get(i).getRatings();
                            String ServiceCategory = providersList.get(i).getServiceType().trim();

                            /*
                            int totalList = Integer.parseInt(request.getParameter("totallist"));
                            double TotalPrice = 0; //initializing variable with a temporary value for incase loop condition is never met
                            double TaxedPrice = 0;
                            double Tax = 0;
                            
                            String SelectedServicesList = "";
                            
                            for(int w = 1; w <= totalList; w++ ){ //comparison operator (<=) so that loop can reach last ArrayList element
                                
                                String StringW = Integer.toString(w);
                                String getParamString = "CheckboxOfServiceNo"+StringW; 
                                String SelectedService = request.getParameter(getParamString); //check box returns null when not checked and returns its value(Checked) when Checked.
                                String ServiecNameParam = "NameOfServiceNo"+StringW;
                                String ServicePriceParam = "PriceOfServiceNo"+StringW; //concatenate string with integer value to make up the parameter name
                                
                                if(SelectedService != null){
                                    
                                    if(SelectedServicesList == "")
                                        SelectedServicesList += " " + request.getParameter(ServiecNameParam) //don't include a comma for the first round around the loop
                                                + "-$" + request.getParameter(ServicePriceParam);
                                    else
                                        SelectedServicesList += ", "  + request.getParameter(ServiecNameParam) 
                                                + "-$" + request.getParameter(ServicePriceParam);
                                    double eachPrice = Double.parseDouble(request.getParameter(ServicePriceParam));
                                    TotalPrice += eachPrice; //adding each price item to running total(self-assigned)
                                    
                                }
                            }
                            
                            Tax = TotalPrice *(8.45/100); //returns non-rounded values
                            TaxedPrice = (TotalPrice * (8.45/100)) + TotalPrice; //tax percentage to change soon
                            */
                            
                            //allways do this first to reset Cost
                            Double TaxedPrice = Double.parseDouble(request.getParameter("TaxedPrice"));
                            
                            
                    %>
                    
                    <%
                        
                                    int IntervalsValue = 30;
        
                                    try{

                                        Class.forName(Driver);
                                        Connection intervalsConn = DriverManager.getConnection(url, User, Password);
                                        String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                                        PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

                                        intervalsPst.setInt(1, PID);

                                        ResultSet intervalsRec = intervalsPst.executeQuery();

                                        while(intervalsRec.next()){
                                            IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
                                        }
                                    }catch(Exception e){
                                        e.printStackTrace();
                                    }

                                    //getting all the time available to availble times list
                                    //getting all the time available to availble times list
                        
                                        Date CurrentDate = new Date();
                                        String DayOfWeek = CurrentDate.toString().substring(0,3);
                                        SimpleDateFormat CurrentDateSdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDate = CurrentDateSdf.format(CurrentDate);
                                        String CurrentTime = CurrentDate.toString().substring(11,16);
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                        
                                        String DailyStartTime = "";
                                        String DailyClosingTime = "";
                                        //String FormattedStartTime = "";
                                        //String FormattedClosingTime = "";
                                        
                                        int startHour = 0;
                                        int startMinute = 0;
                                        int closeHour = 0;
                                        int closeMinute = 0;
                                        
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
                                            hourPst.setInt(1, PID);
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
                                                        
                                                        /*formatting the time for user convenience
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
                                                        }*/
                                               
                                                closeHour = Integer.parseInt(DailyClosingTime.substring(0,2));
                                                closeMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
                                                        
                                                        /*formatting the time for user convenience
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
                                                        }*/
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
                                            CloseddPst.setInt(1, PID);
                                            
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
                        
                        int TimeBookedFlag = 0;
                        
                        if (CurrentTime.length() == 4)
                            CurrentTime = "0" + CurrentTime;
                        
                        //int CurrentHour = Integer.parseInt(CurrentTime.substring(0,2));
                        //int CurrentMinute = Integer.parseInt(CurrentTime.substring(3,5));
                        
                        //String CurrentStringMinute = Integer.toString(CurrentMinute);
                        //if(Integer.toString(CurrentMinute).length() < 2)
                        //CurrentStringMinute = "0" + CurrentMinute;
                        
                        //if(CurrentHour < StartTimeHour)
                               //CurrenTime = StartHour + CurrentStringMinute;
                               
                        int LastAppointmentTime = 23;
                        
                        if(closeHour != 0)
                            LastAppointmentTime = closeHour;
                        
                            String TimeAfter30Mins = "";
                            String TimeBefore30Mins = "";
                            String TempAppointmentTime = CurrentTime;
                            
                            int TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            
                            if(DailyStartTime != ""){
                                
                                if(TempHour < startHour)
                                    TempAppointmentTime = DailyStartTime;
                            }
                            
                            int TempMinute = 0;

                            if(isTodayClosed == true){
                                                
                                DailyStartTime = "00:00";
                                DailyClosingTime = "00:00";
                                                
                            }
                            
                        while(TempHour < LastAppointmentTime){
                            
                            if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                break;
                            
                            if(TempAppointmentTime.length() == 4)
                               TempAppointmentTime = "0" + TempAppointmentTime;

                            TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            TempMinute = Integer.parseInt(TempAppointmentTime.substring(3,5));

                            TempMinute += IntervalsValue;

                            while(TempMinute >= 60){

                                TempHour++;

                                if(TempMinute > 60 && TempMinute != 60)
                                    TempMinute -= 60;

                                else if(TempMinute == 60)
                                    TempMinute = 0;

                                if(TempHour > 23)
                                    TempHour = 23;

                            }
                            
                            String SMinute = Integer.toString(TempMinute);
                            
                            if(Integer.toString(TempMinute).length() < 2)
                                SMinute = "0" + TempMinute;

                            TimeAfter30Mins = TempHour + ":" + SMinute;

                            //JOptionPane.showMessageDialog(null, TimeAfter30Mins);

//the original algo here is go back an hour and start counting up till its about 30 mins before current time
                            int TempHour2 = Integer.parseInt(TempAppointmentTime.substring(0,2));
                            int TempMinute2 = Integer.parseInt(TempAppointmentTime.substring(3,5));

                            TempHour2 -= 5; //turning this into 300 minutes
                            

                            TempMinute2 += 300; //this makes TempMinute2 greater than IntervalsValue according to the prio algo (30 mins algo)
                            
                            //make TempMinute2 greater the the value of IntervalsValue so you can subtract IntervalsValue from it
                            TempMinute2 -= IntervalsValue;
                            
                            while(TempMinute2 >= 60){
                                
                                /*Avoid incrementing the hour hand as it will skip the start of the day
                                if(DailyStartTime != ""){
                                                
                                    if(TempHour2 == startHour){
                                        break;
                                    }
                                                    
                                }else if(TempHour2 == 1){
                                    break;
                                }*/

                                TempHour2++;

                                if(TempMinute2 > 60 && TempMinute2 != 60)
                                    TempMinute2 -= 60;

                                else if(TempMinute2 == 60)
                                    TempMinute2 = 0;

                                if(TempHour2 > 23)
                                    TempHour2 = 23;
                            }
                            
                             //do this to avoid TempMinute2 being over the normal 60 mins per hour
                            // and also to avoid TempHour2 being lses then the providers opening time is there is
                            // and if there isn't, avoid it being less than at least 1am;
                            if(DailyStartTime != ""){
                                            
                                if(TempHour2 < startHour){
                                    TempHour2 = startHour;
                                    TempMinute2 = startMinute;
                                }
                            }else if(TempHour2 < 1){
                                TempHour2 = 1;
                                TempMinute2 = Integer.parseInt(CurrentTime.substring(3,5));
                            }
                            
                            String SMinute2 = Integer.toString(TempMinute2);
                            
                            if(Integer.toString(TempMinute2).length() < 2)
                                SMinute2 = "0" + TempMinute2;

                            TimeBefore30Mins = TempHour2 + ":" + SMinute2;
                            //JOptionPane.showMessageDialog(null, TimeBefore30Mins);
                            
                            try{
            
                                Class.forName(Driver);
                                Connection TimeRangeConn = DriverManager.getConnection(url, User, Password);
                                String TimeRangeString = "Select * from QueueObjects.BookedAppointment where "
                                        + "(ProviderID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))"
                                        + " or (CustomerID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))";

                                PreparedStatement TimeRangePst = TimeRangeConn.prepareStatement(TimeRangeString);
                                TimeRangePst.setInt(1, PID);
                                TimeRangePst.setString(2, StringDate);
                                TimeRangePst.setString(3, TimeBefore30Mins);
                                TimeRangePst.setString(4, TimeAfter30Mins);
                                TimeRangePst.setInt(5, UserID);
                                TimeRangePst.setString(6, StringDate);
                                TimeRangePst.setString(7, TimeBefore30Mins);
                                TimeRangePst.setString(8, TimeAfter30Mins);

                                ResultSet TimeRangeRow = TimeRangePst.executeQuery();
                                
                                while(TimeRangeRow.next()){
                                    
                                    TimeBookedFlag = 1;
                                    String ThisAppointmentTime = TimeRangeRow.getString("AppointmentTime");
                                    
                                    int ThisAppointmentMinute = Integer.parseInt(ThisAppointmentTime.substring(3,5));
                                    int ThisAppointmentHour = Integer.parseInt(ThisAppointmentTime.substring(0,2));
                                    
                                    //ThisAppointmentHour++;
                                    ThisAppointmentMinute += (IntervalsValue + 1);
                                    
                                    while(ThisAppointmentMinute >= 60){
                                        
                                        ThisAppointmentHour++;
                                        
                                        if(ThisAppointmentMinute > 60 && ThisAppointmentMinute != 60)
                                            ThisAppointmentMinute -= 60;
                                        else if(ThisAppointmentMinute == 60)
                                            ThisAppointmentMinute = 0;
                                        
                                    }
                                    
                                    String ThisAppointmentStringMinute = Integer.toString(ThisAppointmentMinute);
                                    
                                    if(ThisAppointmentStringMinute.length() < 2)
                                        ThisAppointmentStringMinute = "0" + ThisAppointmentStringMinute;
                                    
                                    TempAppointmentTime = ThisAppointmentHour + ":" + ThisAppointmentStringMinute;
                                    break;
                                }

                            }catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            if(TimeBookedFlag == 0){
                            
                                AllAvailableTimeList.add(TempAppointmentTime);
                                TempAppointmentTime = TimeAfter30Mins;
                                
                            }
                            
                            TimeBookedFlag = 0;
                            
                        }

                        
                    %>
                    
                    <%
                        /*/getting coverdata
                        
                        try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,PID);
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
                        }*/
                    %>
                    
                    
                    <tbody>
                        <tr>
                            <td>
                                <div style="display: flex; flex-direction: row;">
                                <div>
                                    <div style='overflow: hidden; width: 50px; height: 50px; border-radius: 100%; margin-left: 10px; margin-top: 5px;'>
                                        <img  style="width: 50px; height: auto;" src="data:image/jpg;base64,<%=base64Image%>"/>
                                    </div>
                                </div>
                                <div class="proinfo" style="margin-top: 0; padding-top: 0; margin-left: 10px;">
                                    
                                 <table id="ProInfoTable" style="width: 100%; border-spacing: 0; box-shadow: 0; margin-left: 0;">
                                <tbody>
                                <tr>
                                    <td>
                                        <b>
                                            <p style="color: #3d6999; font-weight: bolder;">
                                                <!--img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/-->
                                                <%=fullName%>
                                            </p>
                                        </b>
                                        <p style="margin-top: -4px;">
                                            <!--img src="icons/icons8-business-15.png" width="15" height="15" alt="icons8-business-15"/-->
                                            <small style="color: #636363;"><%=Company%></small>
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                       <p style="font-size: 20px; color: #37a0f5; font-weight: bolder; text-align: center; margin-bottom: 10px;">
                                                        <span style="color: tomato;">Overall Rating: </span>
                                                        <span style="font-size: 20px; margin-left: 10px;">
                                                        <%
                                                            if(ratings ==5){

                                                        %> 
                                                        ★★★★★ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Recommended</span></i>
                                                        <%
                                                             }else if(ratings == 4){
                                                        %>
                                                        ★★★★☆ 
                                                        <i class="fa fa-check" style="color: #4ed164; font-size: 18px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Recommended</span></i>
                                                        <%
                                                             }else if(ratings == 3){
                                                        %>
                                                        ★★★☆☆ 
                                                        <i class="fa fa-thumbs-up" style="color: orange; font-size: 16px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Average</span></i>
                                                        <%
                                                             }else if(ratings == 2){
                                                        %>
                                                        ★★☆☆☆ 
                                                        <i class="fa fa-exclamation-triangle" style="color: red; font-size: 17px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Bad rating</span></i>
                                                        <%
                                                             }else if(ratings == 1){
                                                        %>
                                                        ★☆☆☆☆   
                                                        <i class="fa fa-thumbs-down" aria-hidden="true" style="color: red; font-size: 16px; margin-left: 20px;"><span style="color: #8b8b8b; font-size: 10px;"> Worst rating</span></i>
                                                        <%}%>
                                                        </span>
                                                        
                                                    </p> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="width: 100%; display: flex; flex-direction: row; justify-content: center; margin-bottom: 10px;">
                                            <div>
                                                <a style="color: seagreen;" href="https://maps.google.com/?q=<%=fullAddress%>" target="_blank">
                                                    <i class="fa fa-location-arrow" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                   font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">map</span></i>
                                                </a>
                                                <!--img src="icons/icons8-home-15.png" width="15" height="15" alt="icons8-home-15"/>
                                                <=fullAddress-->
                                            </div>
                                            <div>
                                                <a style="color: seagreen;" href="tel:<%=phoneNumber%>">
                                                    <i class="fa fa-phone" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                    font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">call</span></i>
                                                </a>
                                            </div>
                                            <div>
                                                <a style="color: seagreen;" href="mailto:<%=Email%>">
                                                    <i class="fa fa-envelope" aria-hidden="true" style="margin-left: 10px; background-color: darkslateblue; color: navajowhite;
                                                    font-size: 20px; padding: 10px 0; border-radius: 4px; width: 70px; text-align: center;"> <span style="color: white;">email</span></i>
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                                </table>
                                
                                </div>
                                </div>
                                    
                                <form>
                                    
                                    <%
                                        String[] FutureDateParts = request.getParameter("formsDateValue").split("-");
                                        //JOptionPane.showMessageDialog(null,FutureDateParts);
                                        String FutureDate = FutureDateParts[1] + "/" + FutureDateParts[2] + "/" +FutureDateParts[0];
                                        
                                        if(FormattedAppointmentTime != " "){
                                            
                                    %>
                                    
                                    <!--p id="ShowThisAppointmentTimeForFinishAppointmentWindow" style="color: red;">This line spot is for <%=FutureDate%> at <%=FormattedAppointmentTime%></p-->
                                    
                                    <%}%>
                                    
                                    <div>
                                    <p id="showCustomizeTimeBtn" onclick="showCustomizeDate()" style="font-weight: bolder; color: #365266; cursor: pointer;">Customize Your Spot <i style="margin-left: 5px;" class="fa fa-caret-down"></i></p>
                                    
                                    <div id="customizeAppointmentTime">
                                        
                                        <div id="serviceslist" style="border: none; background: none; padding: 0;">
                                        
                                       <p style="color: #334d81; font-weight: bolder">Select Date</p>
                                       <p><input onclick="initializeDate()" style = "background-color: white; border: 1px solid darkgrey; padding: 10px;" type="text" id="datepicker" name="chooseDate" value="<%=FutureDate%>" readonly></p>
                                       <p id="datepickerStatus" style="padding-bottom: 10px; text-align: center; color: darkblue; font-weight: bolder;"></p>
                                       <p id="DateStatus" style="padding-bottom: 10px; color: darkblue; font-weight: bolder; text-align: center;"></p>
                                    </div> 
                                        
                                    <div id="serviceslist" style="background: none; border: none;">
                                        
                                        <p style="color: #334d81; font-weight: bolder;">Select Time</p>
                                    
                                        <center><p><span><select style="width: 50px; background-color: white; padding: 10px; border: 1px solid darkgrey; color: black;" onclick ="showTime()" id="HHSelector" name="hourOptions" 
                                                                         >
                                                                 <option>HH</option>
                                                                 <option>01</option>
                                                                 <option>02</option>
                                                                 <option>03</option>
                                                                 <option>04</option>
                                                                 <option>05</option>
                                                                 <option>06</option>
                                                                 <option>07</option>
                                                                 <option>08</option>
                                                                 <option>09</option>
                                                                 <option>10</option>
                                                                 <option>11</option>
                                                                 <option>12</option>
                                                                 </select> : </span>
                                                <span><select style="width: 50px; background-color: white; padding: 10px; border: 1px solid darkgrey; color: black;" onclick="showTime()" id="MMSelector" name="minuteOptions" 
                                                                        >
                                                                 <option>MM</option>
                                                                 <option>01</option>
                                                                 <option>02</option>
                                                                 <option>03</option>
                                                                 <option>04</option>
                                                                 <option>05</option>
                                                                 <option>06</option>
                                                                 <option>07</option>
                                                                 <option>08</option>
                                                                 <option>09</option>
                                                                 <option>10</option>
                                                                 <option>11</option>
                                                                 <option>12</option>
                                                                 <option>13</option>
                                                                 <option>14</option>
                                                                 <option>15</option>
                                                                 <option>16</option>
                                                                 <option>17</option>
                                                                 <option>18</option>
                                                                 <option>19</option>
                                                                 <option>20</option>
                                                                 <option>21</option>
                                                                 <option>22</option>
                                                                 <option>23</option>
                                                                 <option>24</option>
                                                                 <option>25</option>
                                                                 <option>26</option>
                                                                 <option>27</option>
                                                                 <option>28</option>
                                                                 <option>29</option>
                                                                 <option>30</option>
                                                                 <option>31</option>
                                                                 <option>32</option>
                                                                 <option>33</option>
                                                                 <option>34</option>
                                                                 <option>35</option>
                                                                 <option>36</option>
                                                                 <option>37</option>
                                                                 <option>38</option>
                                                                 <option>39</option>
                                                                 <option>40</option>
                                                                 <option>41</option>
                                                                 <option>42</option>
                                                                 <option>43</option>
                                                                 <option>44</option>
                                                                 <option>45</option>
                                                                 <option>46</option>
                                                                 <option>47</option>
                                                                 <option>48</option>
                                                                 <option>49</option>
                                                                 <option>50</option>
                                                                 <option>51</option>
                                                                 <option>52</option>
                                                                 <option>53</option>
                                                                 <option>54</option>
                                                                 <option>55</option>
                                                                 <option>56</option>
                                                                 <option>57</option>
                                                                 <option>58</option>
                                                                 <option>59</option>
                                                                 <option>00</option>
                                                                 <option></option>
                                                                 </select></span>
                                                <span><select style="width: 50px; background-color: white; padding: 10px; border: 1px solid darkgrey; color: black;" onclick="showTime()" id="AmPmSelector" name="AmPmOptions" 
                                                                         >
                                                                 <option>am</option>
                                                                 <option>pm</option>
                                                                 </select></span>
                                                                 
                                            </p></center>
                                        <p id="timeStatus" style="color: darkblue; padding-bottom: 10px; font-weight: bolder; text-align: center;"></p>
                                        <p id="HideSuggestedTimeDivStatus" style="padding-bottom: 10px; color: darkblue; font-weight: bolder; text-align: center;"></p>
                                    
                                    </div>
                                        
                                    </div>
                                    </div>
                                    
                                    <div id="QueuLineDiv" style="border: none; background: none;">
                                        
                                        <p style="color: #334d81; font-weight: bolder; margin-bottom: 5px;">Suggested Spots Listed Below</p> 
                                      
                                        <p style="margin-bottom: 0;">You may also choose a spot from suggested list below</p>
                                        
                                        <p id="showAllSuggestedTimeBtn" onclick="showSuggestedTime()" style="text-align: center; background-color: darkslateblue; color: pink; padding: 5px; cursor: pointer;">Show All Suggested Spots</p>
                                        
                                        <center><p id="SuggestedTimeDivStatus" style="padding: 10px 0; color: darkblue; font-weight: bolder; text-align: center;"></p></center>
                                   
                                    <center><div id="AllSuggestedTimeDiv" style="display: none;">
                                       
                                    <%
                                        String FormattedAvailableTime = "";
                                        int HourForFormattedTimedAvail = 0;
                                        int MinuteFroFormattedTimeAvail = 0;
                                        
                                        for(int q = 0; q < AllAvailableTimeList.size(); q++){
                                            
                                            FormattedAvailableTime = AllAvailableTimeList.get(q);
                                            HourForFormattedTimedAvail = Integer.parseInt(FormattedAvailableTime.substring(0,2));
                                            MinuteFroFormattedTimeAvail = Integer.parseInt(FormattedAvailableTime.substring(3,5));
                                                        
                                            //formatting the time for user convenience
                                            if( HourForFormattedTimedAvail > 12)
                                            {
                                                int TempHourAvail = HourForFormattedTimedAvail - 12;
                                                FormattedAvailableTime = Integer.toString(TempHourAvail) + ":" +  FormattedAvailableTime.substring(3,5) + " pm";
                                            }
                                            else if(HourForFormattedTimedAvail == 0){
                                                FormattedAvailableTime = "12" + ":" + FormattedAvailableTime.substring(3,5) + " am";
                                            }
                                            else if(HourForFormattedTimedAvail == 12){
                                                FormattedAvailableTime = FormattedAvailableTime + " pm";
                                            }
                                            else{
                                                FormattedAvailableTime = FormattedAvailableTime +" am";
                                            }
                                                        
                                            //if(AllAvailableTimeList.get(q) == CurrentTime)
                                                //continue;
                                        
                                    %>
                                   
                                        <div class="SuggestedTime" onclick="setSuggestedTime(<%=q%>)" id="AvailableTimeDiv<%=q%>" style="cursor: pointer; margin: 2px; margin-bottom: 10px; padding-left: 1px; padding-right: 1px; width: 70px; border: 1px solid darkgray; border-radius: 4px; float: left;">
                                            <p id="FormattedTimeAvalible<%=q%>" style="color: blue; font-size: 13px; font-weight: bold; text-align: center;"><%=FormattedAvailableTime%></p>
                                            <p id="TimeAvailable<%=q%>" style="display: none;"><%=AllAvailableTimeList.get(q)%></p>
                                        </div>
                                              
                                    <%}%> 
                                    
                                    </div></center>
                                    
                                    <%
                                        if(AllAvailableTimeList.size() == 0){
                                    %>
                                    
                                        <p style="font-weight: bolder; color: darkblue; text-align: center; padding: 5px;"><i style="color: red" class="fa fa-exclamation-triangle"></i> No available spot suggestions at this time</p>
                                    
                                    <%}%>
                                    <p style="clear: both;"></p>
                                    </div>
                                    
                                     <% 
                                        //calculating cancellation charge
                                        DecimalFormat decformat = new DecimalFormat("#.00");
                                        double CnclCharge = 0;
                                        if(hasCancellation){
                                            CnclCharge = ((ChargePercent * TaxedPrice) / 100);
                                            CnclCharge = Double.parseDouble(decformat.format(CnclCharge));
                                        }
                                        String tempdouble = "";
                                        tempdouble = decformat.format(TaxedPrice);
                                        TaxedPrice = Double.parseDouble(tempdouble);
                                        
                                        String SelectedServicesList = request.getParameter("ServicesList");
                                        
                                        if(SelectedServicesList.length() > 35)
                                            SelectedServicesList = SelectedServicesList.substring(0, 32) + "...";
                                        
                                    %>
                                    
                                    <div id="serviceslist" style="clear: both; border-top: none;">
                                        
                                        <div id="reviewsheet">
                                        
                                        <p style="color: darkblue; font-weight: bolder; text-align: center;">Review Spot Details</p>
                                        
                                        <p> Type: <span style="color: red; float: right;"><%=ServiceCategory%></span></p>
                                        <p><input id="formsServiceCategory" type="hidden" name="formsServiceCategory" value="<%=ServiceCategory%>" /></p>
                                        <p> Date: <span id="dateDisplay" style="color: red; float: right;"></span></p>
                                        <p><input id="formsDateValue" type="hidden" name="formsDateValue" value="" /></p>
                                        <p> Time: <span id="displayTime" style="color: red; float: right;"><%=FormattedAppointmentTime%></span></p>
                                        <p><input id="formsTimeValue" type="hidden" name="formsTimeValue" value="<%=AppointmentTime%>" /></p>
                                        <p> Reason: <span style="color: red; float: right;"><%=SelectedServicesList%></span>
                                        <input id="formsOrderedServices" type="hidden" name="formsOrderedServices" value="<%=request.getParameter("ServicesList")%>" />
                                            
                                            <%
                                                if(request.getParameter("ServicesList") == ""){
                                            
                                            %><span style="color: red; float: right;">None(Go to previous page)</span> 
                                            
                                            <%  }   //end of condition%>
                                            
                                            </p>
                                        <p id='PaymentOptionsP'> Payment:<span style="color: red; float: right;">
                                                <%
                                                    if(!hasCancellation){
                                                %>
                                                <span onclick="toggleHideCardDetailsDiv()"><input id="Cash" type="radio" name="payment" value="Cash" style="background-color: white;"/><label for="Cash" style="margin-right: 5px">Later</label></span>
                                                 <%}%><span onclick="toggleShowCardDetailsDivforLogoutPage()"><input onclick="toggleShowCardDetailsDivforLogoutPage()" id="Credit/Debit" type="radio" name="payment" value="Debit/Credit Card" style="background-color: white;"/><label for="Credit/Debit">Now</label></span></span></p>
                                       <p style="clear: both;"></p>
                                        <p> Total: <span style="color: red; float: right;">$<%=TaxedPrice%></span></p>
                                        
                                        <script>
                                                //constructing json obj for appointments data
                                                var lastAppointment = {
                                                    ProviderID: '<%=PID%>',
                                                    CustomerID: null,
                                                    Date: '',
                                                    Time: '<%=AppointmentTime%>',
                                                    ServicesList: '<%=SelectedServicesList%>',
                                                    TotalPrice: '<%=TaxedPrice%>',
                                                    PaymentMethod: 'notStated',
                                                    hasCancellation: false,
                                                    PaymentAmount: 0,
                                                    Paid: false
                                                };
                                                
                                                /*document.getElementById("displayTime").addEventListener("click", ()=>{
                                                    alert('changed');
                                                    lastAppointment.Time = document.getElementById("formsTimeValue").value;
                                                });
                                                document.getElementById("formsDateValue").addEventListener("change", ()=>{
                                                    lastAppointment.Date = document.getElementById("formsDateValue").value;
                                                });*/
                                                setInterval(() => {
                                                    lastAppointment.Time = document.getElementById("formsTimeValue").value;
                                                    lastAppointment.Date = document.getElementById("formsDateValue").value;
                                                    localStorage.setItem('lastAppointment', JSON.stringify(lastAppointment));
                                                }, 1);
                                        </script>
                                        
                                        <%
                                            if(hasCancellation){
                                        %>
                                        <p> Cancellation Charge: <span style="color: red; float: right;">$<%=CnclCharge%></span></p>
                                        
                                        <script>
                                            lastAppointment.PaymentMethod = 'Card';
                                            lastAppointment.PaymentAmount = '<%=CnclCharge%>';
                                            lastAppointment.hasCancellation = true;
                                        </script>
                                        
                                        <%}%>
                                        <input id="TaxedPrice" type="hidden" name="TotalToPay" value="<%=TaxedPrice%>" />
                                        
                                        <input id='SendApptPID' type="hidden" name="ProviderID" value="<%=PID%>" />
                                        <p><input id='SendApptCustID' type="hidden" name="CustomerID" value="<%=UserID%>" /></p>
                                        <p><input id='SendApptUserIndex' type="hidden" name="UserIndex" value="<%=UserIndex%>" /></p>
                                        <p><input id='sendApptUser' type="hidden" name="UserName" value="<%=UserName%>" /></p>
                                        <!--input type="hidden" name="ProviderFullName" value="<=fullName%>" />
                                        <input type="hidden" name="ProviderCompany" value="<=Company%>" />
                                        <input type="hidden" name="CustomerID" value="<=UserID%>"/-->
                                        
                                        </div>
                                        
                                    </div>
                                        
                                    <center>
                                        
                                        <script>
                                            var PaymentAmount = '<%=(TaxedPrice * 100)%>';
                                            var BallanceToPay = '0.00';
                                        </script>
                                         
                                        <%
                                            if(hasCancellation == true){
                                        %>
                                        <!--p style="padding: 5px; text-align: center; color: darkgrey;"><i class="fa fa-credit-card"></i> <%=fullName.split(" ")[0]%> has a cancellation policy.</p-->
                                        <script>
                                            PaymentAmount = '<%=(CnclCharge * 100)%>';
                                            BallanceToPay = '<%=Double.parseDouble(decformat.format(TaxedPrice - CnclCharge))%>';
                                        </script>
                                        <%}%>
                                        
                                        <p id="ConfirmAppointmentStatusTxt" style="text-align: center; color: darkblue; font-weight: bolder;"></p>
                                        <input id="submitAppointment" style="border: none; background-color: darkslateblue; border-radius: 5px; color: white;
                                                   padding: 10px;"
                                                  onclick="document.getElementById('PageLoader').style.display = 'block';"  type="button" value="Confirm" />
                                    </center>
                                        
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#submitAppointment').click(function(event) {  
                                                        document.getElementById("PageLoader").style.display = "block";
                                                        localStorage.setItem('lastAppointment', JSON.stringify(lastAppointment));
                                                        var ProviderID = document.getElementById("SendApptPID").value;
                                                        var CustomerID = document.getElementById("SendApptCustID").value;
                                                        var UserIndex = document.getElementById("SendApptUserIndex").value;
                                                        var NewUserName = document.getElementById("sendApptUser").value;
                                                        var TotalPrice = document.getElementById("TaxedPrice").value;
                                                        var ApptDate = document.getElementById("formsDateValue").value;
                                                        var ApptTime = document.getElementById("formsTimeValue").value;
                                                        var ApptReason = document.getElementById("formsOrderedServices").value;
                                                        var PayMeth = $("input:radio[name=payment]:checked").val();
                                                        
                                                        /*alert("ProviderID: "+ProviderID);
                                                        alert("CustomerID: "+CustomerID);
                                                        alert("UserIndex: "+UserIndex);
                                                        alert("TotalPrice: "+TotalPrice);
                                                        alert("ApptDate: "+ApptDate);
                                                        alert("ApptTime: "+ApptTime);
                                                        alert("ApptReason: "+ApptReason);
                                                        alert("Payment Method: "+PayMeth);*/
                                                        
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "SendAppointmentControl",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&TotalPrice="+TotalPrice+"&formsDateValue="+ApptDate+"&formsTimeValue="+ApptTime+"&formsOrderedServices="+ApptReason+"&payment="+PayMeth,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          if(result === "Success"){
                                                              alert("You've been enqueued successfully!");
                                                                document.getElementById("PageLoader").style.display = "none";
                                                                window.location.replace("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
                                                              
                                                          }else{
                                                              alert(result);
                                                              document.getElementById("PageLoader").style.display = "none";
                                                          }
                                                          //document.getElementById("eachClosedDate<>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                                        
                                </form>
                                        
                                        <center><div id="CreditDebitCardDetails" style="padding: 10px; background-color: #eeeeee;">
                                            <p id='PayBelowThenConfirmStatus' style="color: crimson; font-weight: bolder; text-align: center;">Pay below then confirm here</p>
                                            
                                                    
                                            <form name="PaymentForm">
                                              
                                                <input type='hidden' name="ProviderID" value="<%=PID%>" />
                                                <input type="hidden" name="CustomerID" value=""/>
                                                <input type="hidden" name="OrderedServices" value="<%=request.getParameter("ServicesList")%>" />
                                                <input id="PayFormAppointmentDate" type="hidden" name="AppointmentDate" value="" />
                                                <input id="PayFormAppointmentTime" type="hidden" name="AppointmentTime" value="" />
                                                <input type="hidden" name="ServicesCost" value="<%=TaxedPrice%>" />
                                                <input type="hidden" name="CancellationCharge" value="<%=CnclCharge%>" />
                                                
                                                <script>
                                                    
                                                    setInterval(function(){
                                                            var AppointmentDate = document.getElementById("formsDateValue").value;
                                                            var AppointmentTime = document.getElementById("formsTimeValue").value;
                                                            
                                                            document.getElementById("PayFormAppointmentDate").value = AppointmentDate;
                                                            document.getElementById("PayFormAppointmentTime").value = AppointmentTime;
                                                            
                                                        }, 1);                                     
                                                    
                                                    
                                                </script>
                                                
                                                
                                            <%
                                                if(hasCancellation){
                                            %>
                                            <p id='ChargesPercentStatus' style="color: darkgrey; text-align: center; padding: 5px;"><i style="" class="fa fa-info-circle"></i> <%=fullName.split(" ")[0]%> charges <span style=""><%=ChargePercent%>%</span> cancellation fee</p>
                                            <!--p style="color: darkblue; font-weight: bolder; text-align: center; padding: 5px;">cancell at <=CancelElapse%> </p-->
                                            <%}%>
                                                
                                                <!--table id="paymentDetailsTable">
                                                    <tbody>
                                                    
                                                        <tr><td style="border-radius: 0; padding: 4px;">Card Number: </td><td style="border-radius: 0; padding: 4px;"><input onclick="checkMiddleCardNumber();" onkeydown="checkMiddleCardNumber();" id="cardNumber" style="background-color: #eeeeee;" type="text" name="C/DcardNumber" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Card Holder's Name: </td><td style="border-radius: 0; padding: 4px;"><input id="cardName" style="background-color: #eeeeee;" type="text" name="holdersName" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Expiration Date: </td><td style="border-radius: 0; padding: 4px;"><input id="cardDate" style="background-color: #eeeeee; max-width: 100px;" type="text" name="cardExpDate" value="" /></td></tr>
                                                        <tr><td style="border-radius: 0; padding: 4px;">Security Code: </td><td style="border-radius: 0; padding: 4px;"><input id="cardCVV" style="background-color: #eeeeee; max-width: 100px;" type="text" name="secCode" value="" /></td></tr>
                                                        
                                                    </tbody>
                                                </table>
                                            
                                                <script>
                                                    var cardNumber = document.getElementById("cardNumber");

                                                    function numberFuncCardNumber(){

                                                        var number = parseInt((cardNumber.value.substring(cardNumber.value.length - 1)), 10);

                                                        if(isNaN(number)){
                                                            cardNumber.value = cardNumber.value.substring(0, (cardNumber.value.length - 1));
                                                        }

                                                    }

                                                    setInterval(numberFuncCardNumber, 1);

                                                    function checkMiddleCardNumber(){

                                                        for(var i = 0; i < cardNumber.value.length; i++){

                                                            var middleString = cardNumber.value.substring(i, (i+1));
                                                            //window.alert(middleString);
                                                            var middleNumber = parseInt(middleString, 10);
                                                            //window.alert(middleNumber);
                                                            if(isNaN(middleNumber)){
                                                                cardNumber.value = cardNumber.value.substring(0, i);
                                                            }
                                                        }
                                                    }

                                                    //setInterval(checkMiddleNumber, 1000);
                                                </script>
                                                
                                                <script>
                                                    var ExpDateFld = document.getElementById("cardDate");
                                                         
                                                         setInterval(function(){
                                                             
                                                            if(ExpDateFld.value !== ""){
                                                                
                                                               if(ExpDateFld.value.length === 2){
                                                                   
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,2) + "/" + ExpDateFld.value.substring(2);
                                                                  
                                                                   if(ExpDateFld.value === "///" || ExpDateFld.value.substring(1,3) === "//" || ExpDateFld.value.substring(0,1) === "/"){
                                                                       ExpDateFld.value = "";
                                                                   }
                                                                   
                                                               }
                                                               //checking if month is greater than 12
                                                               var month = parseInt((ExpDateFld.value.substring(0,2)), 10);
                                                               var month1 = parseInt((ExpDateFld.value.substring(0,1)), 10);
                                                               var month2 = parseInt((ExpDateFld.value.substring(1,2)), 10);
                                                               var year = parseInt((ExpDateFld.value.substring(3,5)), 10);
                                                               var year1 = parseInt((ExpDateFld.value.substring(3,4)), 10);
                                                               var year2 = parseInt((ExpDateFld.value.substring(4,5)), 10);
                                                               
                                                               if(month !== null){
                                                                    if(month > 12){
                                                                        ExpDateFld.value = "12" + ExpDateFld.value.substring(2,5);
                                                                    }
                                                                }
                                                                //checking if entered date is more than 5 characters
                                                               if(ExpDateFld.value.length > 5){
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,5);
                                                               }
                                                               //checking is what's entered is is not a number 
                                                               if(isNaN(month1))
                                                                   ExpDateFld.value = "";
                                                               if(isNaN(month2))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,1) + "";
                                                               if(isNaN(year1))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,3) + "";
                                                               if(isNaN(year2))
                                                                   ExpDateFld.value = ExpDateFld.value.substring(0,4) + "";
                                                              
                                                            }
                                                         },1);
                                                </script-->
                                            
                                                <p  style="color: darkblue; font-weight: bolder; text-align: center;"><span id="paymentBtnStatus"></span></p>
                                                <input id="submitPaymentBtn" style="color: white; background-color: darkslateblue; border: none; padding: 5px; border-radius: 4px;" type="button" value="Confirm Appointment" name="paymentBtn" />
                                                
                                            </form>
                                            
                                            <script>
                                                // Set your publishable key: remember to change this to your live publishable key in production
                                                // See your keys here: https://dashboard.stripe.com/account/apikeys
                                                var stripe = Stripe('pk_live_8lUzTgKEDL8iLlezPYrQL4so00KOSnuiut');
                                                var elements = stripe.elements();
                                            </script>
                                            <div id='DivForCardPay'>
                                                <p style='display: block; border-bottom: 1px solid darkgrey;'></p>
                                                
                                                <form id="payment-form" style='padding-bottom: 10px;'>

                                                    <p style='text-align: center; font-weight: bolder; padding-bottom: 10px; color: crimson;'>Add your payment card</p>
                                                    
                                                    <%
                                                        if(hasCancellation == true){
                                                    %>
                                                    <p id="SetPaymentFullBtn" onclick="SetPaymentFull();" 
                                                       style="padding: 10px 0; margin-bottom: 10px; background-color: #365266; text-align: center; color: white; cursor: pointer; max-width: 200px; border-radius: 4px;">
                                                        Set Full Payment <span style="color: darkgrey;"> - <%=TaxedPrice%></span> <i style="color: #fa755a; margin-left: 10px;" class="fa fa-arrow-down"></i></p>
                                                    <script>
                                                        function SetPaymentFull(){
                                                            //PaymentAmount = '<=(CnclCharge * 100)%>';
                                                            //BallanceToPay = '<=Double.parseDouble(decformat.format(TaxedPrice - CnclCharge))%>';
                                                            PaymentAmount = '<%=(TaxedPrice * 100)%>';
                                                            lastAppointment.PaymentAmount = '<%=TaxedPrice%>';
                                                            BallanceToPay = '0.00';
                                                            document.getElementById("PaymentSubmit").innerHTML = "Pay $" + (parseInt(PaymentAmount) / 100) + "<span style='color: darkgrey;'> - Balance: $" + BallanceToPay + "</span>";
                                                            document.getElementById("SetPaymentFullBtn").style.display = "none";
                                                        }
                                                    </script>
                                                    <%}%>

                                                    <div id="card-element">
                                                          <!-- Elements will create input elements here -->
                                                    </div>

                                                    <!-- We'll put the error messages in this element -->
                                                    <div id="card-errors" role="alert"></div>

                                                    <button id="PaymentSubmit" style='padding: 10px 5px; border: none; background-color: darkslateblue; color: white; border-radius: 4px; width: 200px; margin-top: 20px;'>Pay $</button>
                                                </form>
                                            </div>
                                            <script>
                                                
                                                setInterval(()=>{
                                                    if(document.getElementById("formsDateValue").value === "" ||
                                                        document.getElementById("formsTimeValue").value === "" ||
                                                        document.getElementById("formsDateValue").value === " " ||
                                                        document.getElementById("formsTimeValue").value === " "){
                                                        document.getElementById("PaymentSubmit").style.backgroundColor = "#eee";
                                                        document.getElementById("PaymentSubmit").style.color = "darkgrey";
                                                        document.getElementById("PaymentSubmit").disabled = true;
                                                    }else{
                                                        document.getElementById("PaymentSubmit").style.backgroundColor = "darkslateblue";
                                                        document.getElementById("PaymentSubmit").disabled = false;
                                                        document.getElementById("PaymentSubmit").style.color = "white";
                                                    }
                                                }, 1);
                                                
                                                document.getElementById("PaymentSubmit").innerHTML += (parseInt(PaymentAmount) / 100) + "<span style='color: darkgrey;'> - Balance: $" + BallanceToPay + "</span>";
                                                
                                                // Set up Stripe.js and Elements to use in checkout form
                                                var style = {
                                                  base: {
                                                    color: "#32325d",
                                                  }
                                                };

                                                var card = elements.create("card", { style: style });
                                                card.mount("#card-element");
                                                
                                                
                                                card.on('change', ({error}) => {
                                                    const displayError = document.getElementById('card-errors');
                                                    if (error) {
                                                      displayError.textContent = error.message;
                                                    } else {
                                                      displayError.textContent = '';
                                                    }
                                                  });
                                                  
                                                  
                                                  var form = document.getElementById('payment-form');

                                                    form.addEventListener('submit', function(ev) {
                                                        document.getElementById("PageLoader").style.display = "block";
                                                        ev.preventDefault();
                                                      
                                                        var CName = document.getElementById("sendApptUser").value;
                                                        let CheckPID = document.getElementById("SendApptPID").value;
                                                        let CheckCID = document.getElementById("SendApptCustID").value;
                                                        let CheckApptDate = document.getElementById("formsDateValue").value;
                                                        let CheckApptTime = document.getElementById("formsTimeValue").value;
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "isAppointmentTimeAvailable",  
                                                        data: "ProviderID="+CheckPID+"&CustomerID="+CheckCID+"&formsDateValue="+CheckApptDate+"&formsTimeValue="+CheckApptTime,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          if(result === "Success"){
                                                              
                                                                $.ajax({
                                                                    type: "GET",
                                                                    url: "./GetStripePaymentIntent",
                                                                    data: "ConnAccID=<%=StripeAccID%>&Charge="+PaymentAmount,
                                                                    success: function(result){
                                                                          //alert(result);
                                                                          if(result === "failed"){
                                                                              document.getElementById("PageLoader").style.display = "none";
                                                                              alert("<%=fullName.split(" ")[0]%> account cannot accept payments at this moment");
                                                                              throw {msg: "server failed to create payment intent"};
                                                                          }
                                                                          let clientSecret = result;
                                                                          stripe.confirmCardPayment(clientSecret, {
                                                                            payment_method: {
                                                                              card: card,
                                                                              billing_details: {
                                                                                name: CName
                                                                              }
                                                                            }
                                                                          }).then(function(result) {
                                                                            if (result.error) {
                                                                              // Show error to your customer (e.g., insufficient funds)
                                                                              document.getElementById("PageLoader").style.display = "none";
                                                                              console.log(result.error.message);
                                                                            } else {
                                                                              // The payment has been processed!
                                                                              if (result.paymentIntent.status === 'succeeded') {
                                                                                  document.getElementById("PageLoader").style.display = "none";
                                                                                  alert("you've Successfully Paid");
                                                                                  isPaymentSuccess = true;
                                                                                  $("#DivForCardPay").slideUp("fast");
                                                                                  lastAppointment.Paid = true;
                                                                                  lastAppointment.PaymentMethod = 'card';
                                                                                  localStorage.setItem('lastAppointment', JSON.stringify(lastAppointment));
                                                                                // Show a success message to your customer
                                                                                // There's a risk of the customer closing the window before callback
                                                                                // execution. Set up a webhook or plugin to listen for the
                                                                                // payment_intent.succeeded event that handles any business critical
                                                                                // post-payment actions.
                                                                              }
                                                                            }
                                                                          });
                                                                      }
                                                                });
                                                            }else{
                                                              alert(result);
                                                              document.getElementById("PageLoader").style.display = "none";
                                                          }
                                                          //document.getElementById("eachClosedDate<>").style.display = "none";
                                                        }                
                                                      });
                                                    });
                                                  
                                            </script>
                                                    
                                            <%
                                            if(hasCancellation == true){
                                        %>
                                        
                                        <script>
                                             document.getElementById("Credit/Debit").checked = true;
                                             document.getElementById("submitAppointment").style.display = "none";
                                             document.getElementById("CreditDebitCardDetails").style.display = "block";
                                        </script>
                                        <%
                                            }

                                            if(status.equalsIgnoreCase("inactive") || status.equalsIgnoreCase("not_added")){
                                        %>
                                        
                                        <script>
                                             alert("Oops! You cannot continue.\nThis account is not active at this time.\nTry again later.");
                                             window.history.go(-1);
                                        </script>
                                        
                                        <%
                                            }
                                        %>
                                            
                                                <script>
                                                    
                                                        /*var cardNumber = document.getElementById("cardNumber");
                                                        var cardName = document.getElementById("cardName");
                                                        var cardDate = document.getElementById("cardDate");
                                                        var cardCVV = document.getElementById("cardCVV");*/
                                                        var formsDateValue = document.getElementById("formsDateValue");
                                                        var formsTimeValue = document.getElementById("formsTimeValue");
                                                        var submitPaymentBtn = document.getElementById("submitPaymentBtn");
                                                        var paymentBtnStatus = document.getElementById("paymentBtnStatus");
                                                        
                                                        /*function checksubmitPaymentBtn(){
                                                            
                                                            if(formsDateValue.value === "" || formsTimeValue.value === "" || formsDateValue.value === " " || formsTimeValue.value === " "
                                                                    || cardNumber.value === "" || cardName.value === "" || cardDate.value === "" || cardCVV.value === ""){
                                                                submitPaymentBtn.style.backgroundColor = "darkgrey";
                                                                submitPaymentBtn.disabled = true;
                                                                paymentBtnStatus.innerHTML = "Please set date or time. Or enter all card information in form above";
                                                            }else{
                                                                submitPaymentBtn.style.backgroundColor = "darkslateblue";
                                                                submitPaymentBtn.disabled = false;
                                                                paymentBtnStatus.innerHTML = "";
                                                            }
                                                             
                                                            
                                                        }*/
    
                                                        var isPaymentSuccess = false;
                                                        
                                                        function checksubmitPaymentBtn(){
                                                            
                                                            if(formsDateValue.value === "" || formsTimeValue.value === "" || formsDateValue.value === " " || formsTimeValue.value === " "){
                                                                submitPaymentBtn.style.backgroundColor = "darkgrey";
                                                                submitPaymentBtn.disabled = true;
                                                                paymentBtnStatus.innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please set appointment date or time.";
                                                            }else if(isPaymentSuccess === false){
                                                                submitPaymentBtn.style.backgroundColor = "darkgrey";
                                                                submitPaymentBtn.disabled = true;
                                                                paymentBtnStatus.innerHTML = "<i style='color: red;' class='fa fa-exclamation-triangle'></i> Please add your card to pay.";
                                                            }else{
                                                                submitPaymentBtn.style.backgroundColor = "darkslateblue";
                                                                submitPaymentBtn.disabled = false;
                                                                paymentBtnStatus.innerHTML = "<i style='color: green;' class='fa fa-check'></i> OK";
                                                            }
                                                             
                                                            
                                                        }
                                                        
                                                        
                                                        setInterval(checksubmitPaymentBtn, 1);
                                                        
                                                        if((parseInt(PaymentAmount) / 100) === 0){
                                                            //alert("here");
                                                            document.getElementById("PaymentOptionsP").style.display = "none";
                                                            if(document.getElementById("Cash"))
                                                                document.getElementById("Cash").checked = true;
                                                            isPaymentSuccess = true;
                                                            $("#DivForCardPay").slideUp("fast");
                                                            if(document.getElementById("ChargesPercentStatus"))
                                                                document.getElementById("ChargesPercentStatus").style.display = "none";
                                                            if(document.getElementById("PayBelowThenConfirmStatus"))
                                                                document.getElementById("PayBelowThenConfirmStatus").style.display = "none";
                                                        }
                                                    
                                                </script>   
                                                
                                        </div></center>
                    
                                        <script>
                                             
                                               $(document).ready(function() {                        
                                                    $('#submitPaymentBtn').click(function(event) {  
                                                        document.getElementById("PageLoader").style.display = "block";
                                                        localStorage.setItem('lastAppointment', JSON.stringify(lastAppointment));
                                                        var ProviderID = document.getElementById("SendApptPID").value;
                                                        var CustomerID = document.getElementById("SendApptCustID").value;
                                                        var UserIndex = document.getElementById("SendApptUserIndex").value;
                                                        var NewUserName = document.getElementById("sendApptUser").value;
                                                        var TotalPrice = document.getElementById("TaxedPrice").value;
                                                        var ApptDate = document.getElementById("formsDateValue").value;
                                                        var ApptTime = document.getElementById("formsTimeValue").value;
                                                        var ApptReason = document.getElementById("formsOrderedServices").value;
                                                        var PayMeth = $("input:radio[name=payment]:checked").val();
                                                        
                                                        /*alert("ProviderID: "+ProviderID);
                                                        alert("CustomerID: "+CustomerID);
                                                        alert("UserIndex: "+UserIndex);
                                                        alert("TotalPrice: "+TotalPrice);
                                                        alert("ApptDate: "+ApptDate);
                                                        alert("ApptTime: "+ApptTime);
                                                        alert("ApptReason: "+ApptReason);
                                                        alert("Payment Method: "+PayMeth);*/
                                                        
                                                        
                                                        $.ajax({  
                                                        type: "POST",  
                                                        url: "SendAppointmentControl",  
                                                        data: "ProviderID="+ProviderID+"&CustomerID="+CustomerID+"&UserIndex="+UserIndex+"&TotalPrice="+TotalPrice+"&formsDateValue="+ApptDate+"&formsTimeValue="+ApptTime+"&formsOrderedServices="+ApptReason+"&payment="+PayMeth,  
                                                        success: function(result){  
                                                          //alert(result);
                                                          if(result === "Success"){
                                                              alert("You've been enqueued successfully!");
                                                                document.getElementById("PageLoader").style.display = "none";
                                                                window.location.replace("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
                                                              
                                                          }else{
                                                              alert(result);
                                                              document.getElementById("PageLoader").style.display = "none";
                                                          }
                                                          //document.getElementById("eachClosedDate<>").style.display = "none";
                                                        }                
                                                      });
                                                        
                                                    });
                                                });
                                            </script>
                            </td> 
                        </tr>
                    </tbody>
                    
                    <%}//end of for loop%>
                    
                    </table></center>
                    
                </div></center>
                
            </div>
                    
        </div>
                    
            <div id="newbusiness">
            
            
            
            <!--p id='QShowNews2' onclick='document.getElementById("Extras2").style.display = "block";'
                style='margin-top: 10px; background-color: #334d81; color: white; padding: 5px; cursor: pointer;'>
                <i style='color: white; font-size: 35px;' class="fa fa-newspaper-o" width="28" height="25" ></i>
                <sup> Show News Updates</sup></p-->
            
            
            
            <p id='addBizTxt' style="text-align: center; font-size: 20px;  margin-bottom: 10px; margin-top: -10px;">
                <b>Add your business or create customer account</b>
            </p>
            
            <div id="businessdetails" >
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    <table border="0">
                        <tbody>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">First Name</span></p>
                                        <input id="signUpFirtNameFld" placeholder="Enter first name here" type="text" name="firstName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Last Name</span></p>
                                        <input id="sigUpLastNameFld" placeholder="Enter last name here" type="text" name="lastName" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i style="font-size: 20px;" class="fa fa-mobile"></i> <span style="margin-left: 10px;">Mobile</span></p>
                                        <input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" id="signUpTelFld" placeholder="Enter mobile here" type="text" name="telNumber" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset class="loginInputFld">
                                        <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-envelope"></i> <span style="margin-left: 10px;">Email</span></p>
                                        <input id="signUpEmailFld" placeholder="Enter email here" type="text" name="email" value="" size="30"/>
                                    </fieldset>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
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
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <input class="button" type="reset" value="Reset" name="resetBtn" />
                    <input id="loginPageSignUpBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <p style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; text-align: center;"><b>Login to view and manage your spots</b></p>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-user"></i> <span style="margin-left: 10px;">Username</span></p>
                                            <input id="LoginPageUserNameFld" placeholder="enter username here" type="text" name="username" value="" size="30"/>
                                        </fieldset>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <fieldset class="loginInputFld">
                                            <p style="border-bottom: #ccc 1px solid; margin-bottom: 10px; padding-bottom: 10px;"><i class="fa fa-key"></i> <span style="margin-left: 10px;">Password</span></p>
                                            <input class="passwordFld" id="LoginPagePasswordFld" placeholder="enter password here" type="password" name="password" value="" size="20"/>
                                            <p style="text-align: right; margin-top: -20px; padding-right: 10px; margin-bottom: 5px;"><i class="fa fa-eye showPassword" aria-hidden="true"></i></p>
                                        </fieldset>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" onclick="document.getElementById('HomePageLoader').style.display = 'block';" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
            
                </div>
                    
        </div>
                    
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                    
    </div>
                    
    <script>
        localStorage.setItem('lastAppointment', JSON.stringify(lastAppointment));
    </script>
                    
    </body>
    
    <script>
    
    document.getElementById("showAllSuggestedTimeBtn").style.display = "none";
    //document.getElementById("showCustomizeTimeBtn").style.display = "none";
    
    //window.scrollTo(0, document.body.scrollHeight);
    //window.scrollTo(0, 100);
    //document.getElementById("customizeAppointmentTime").style.display = "block";
    document.getElementById("AllSuggestedTimeDiv").style.display = "block";
            
            
    </script>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/appointmentDateBehaviors.js"></script>
    <script src="scripts/CreditDebitCardBehavior.js"></script>
    <script src="scripts/SuggestedTime.js"></script>
    <script src="scripts/SignUpandSendAppointmentBtn.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
        
</html>
