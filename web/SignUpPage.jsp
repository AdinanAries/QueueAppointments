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
        <title>Queue</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
       
         
    </head>
    
    <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
    
    <%
        
        String fName = "";
        String lName = "";
        String telNumber = "";
        String email = "";
        
        try{
            
            fName = request.getParameter("firstName");
            lName = request.getParameter("lastName");
            telNumber = request.getParameter("telNumber");
            email = request.getParameter("email");
            
        }
        catch(Exception e){
            
        }
        
        if(fName == null || fName.equalsIgnoreCase("enter your first name")){
            fName = "";
        }
        if(lName == null || lName.equalsIgnoreCase("enter your last name")){
            lName = "";
        }
        if(telNumber == null || telNumber.equalsIgnoreCase("enter your telephone/mobile number here")){
            telNumber = "";
        }
        if(email == null || email.equalsIgnoreCase("enter your email address here")){
            email = "";
        }
        
    %>
    
    <body>
        
        <div id="container">
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><a href="LoginPageToQueue" style=" color: black;"><image src="QueueLogo.png" style="margin-top: 5px;"/></a></center>
            <center><h3 style="color: #000099;">Find Your Spot Now!</h3></center>
            
        </div>
            
        <div id="content">
            
            <div id="nav">
                
                <h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center>
                
            </div>
            
            <div id="main">
                
                <cetnter><p> </p></cetnter>
                
                <center><div id ="logindetails" style="padding-top: 10px;">
                        
                <center><h2 style="margin-bottom: 20px;">Sign-Up Here</h2></center>
                
                <center><div id="accountTypeOptions">
                <center><h3 style="color: white; margin-bottom: 10px; ">Choose account type</h3></center>
                <table>
                    <tbody>
                        <tr>
                            <td id="ShowBizForm" onclick="toggleHideAddBusinessForm()" style="padding-right: 45px; border-right: 1px solid black; cursor: pointer;"><center><img src="icons/icons8-business-50.png" width="50" height="50" alt="icons8-business-50"/><p>Business</p>
                                </center></td>
                        
                            <td id="ShowCustForm" onclick="toggleHideAddCustomerForm()" style="padding-left: 45px; cursor: pointer;" ><center><img src="icons/icons8-user-50 (1).png" width="50" height="50" alt="icons8-user-50 (1)"/><p>Customer</p>

                                </center></td>
                        </tr>
                    </tbody>
                </table>
                </div><center>
                    
                <div class="scrolldiv" style=" height: 450px; overflow-y: auto; width: auto;">
                <center><h4 style = "margin-bottom: 15px;">__________________________________________</h4></center>
                <center><h3 style="color: white; margin-bottom: 15px; background-color: red;"></h3></center>
                
                <form style=" display: none;" name="customerForm" id="customerForm" action="CustomoerSignUpController" method="POST">
                    <p style="color: white; font-size: 20px;">Add Customer Account<p>
                    <center><h2 style="margin-bottom: 20px;">Provide your information below</h2></center>
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input type="text" id="firstName" name="firstName" value="<%=fName%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Middle Name</p><input type="text" id="middleName" name="middleName" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input type="text" id="lastName" name="lastName" value="<%=lName%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Email</p><input type="text" id="email" name="email" value="<%=email%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Phone Number</p><input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" type="text" id="phoneNumber" name="phoneNumber" value="<%=telNumber%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                    <script>
                        var TelFld = document.getElementById("phoneNumber");
                        
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
                    
                    <h2 style="margin: 5px; margin-top: 30px; ">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>User Name</p><input onkeyup="CustUserNameCheck();" type="text" id="userName" name="userName" value="" size="50" style="background-color: #6699ff;"/>
                                        <p id="CustUserNameStatus" style="color: white; background-color: red; text-align: center; max-width: 355px;"></p></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input type="password" id="firstPassword" name="firstPassword" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password (Again)</p><input type="password" id="secondPassword" name="secondPassword" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="width: 180px; background-color: red; color: white;" id="passwordStatus"></p></center>
                        <center><p style="width: 180px; background-color: green; color: white;" id="formStatus"></p></center>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input class="button" id="AddUserSignUpBtn" type="submit" value="Sign up" name="submitbtn" />
                    </form>
                                
                    <script>
                                    
                        function CustUserNameCheck(){
                            
                            var userName = document.getElementById("userName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckCustUserNameExists",
                                data: "UserName="+userName,
                                success: function(result){
                                    if(result === "true"){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = 'Username: <span style="color: blue;">"' + userName + '"</span> is not available. Choose a different Username';
                                        document.getElementById("CustUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("userName").value = "";
                                        
                                    }else if(result === "false" && document.getElementById("userName").value !== ""){
                                        
                                        document.getElementById("CustUserNameStatus").innerHTML = 'Username: <span style="color: orange;">"' + userName + '"</span> is available.';
                                        document.getElementById("CustUserNameStatus").style.backgroundColor = "green";
                                        
                                    }else if(document.getElementById("userName").value === ""){
                                        
                                        //document.getElementById("CustUserNameStatus").innerHTML = "";
                                        
                                    }
                                }
                            });
                        }  
                        
                    </script>
                    
                    <form style=" display: none;" name="businessForm" id="businessForm" action="ProviderSignUpController" method="POST">
                    
                    <p style="color: white; font-size: 20px;">Add Business Account<p>
                    <center><h2 style="margin-bottom: 20px;">Provide your personal information below</h2></center>
                        
                    <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>First Name</p><input id="firstProvName" type="text" name="firstProvName" value="<%=fName%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Middle Name</p><input id="middleProvName" type="text" name="middleProvName" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Last Name</p><input id="lastProvName" type="text" name="lastProvName" value="<%=lName%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Email</p><input id="provEmail" type="text" name="provEmail" value="<%=email%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Phone Number</p><input onclick="checkMiddleNumberProPer();" onkeydown="checkMiddleNumberProPer();" id="provPhoneNumber" type="text" name="provPhoneNumber" value="<%=telNumber%>" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                                
                        <script>
                        var TelFldProPer = document.getElementById("provPhoneNumber");
                        
                        function numberFuncProvPer(){
                            
                            var number = parseInt((TelFldProPer.value.substring(TelFldProPer.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProPer.value = TelFldProPer.value.substring(0, (TelFldProPer.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProvPer, 1);
                        
                        function checkMiddleNumberProPer(){
                            
                            for(var i = 0; i < TelFldProPer.value.length; i++){

                                var middleString = TelFldProPer.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProPer.value = TelFldProPer.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>
                    
                    <center><h2 style="margin: 5px; margin-top: 30px;">Add your business information below</h2></center>
                        
                    <center><table border="0">
                            <tbody>
                                <tr>
                                    <td style="padding-bottom: 10px;"><p>Business Name</p><input id="businessName" type="text" name="businessName" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                
                                <tr>
                                    <td  style="padding-top: 15px; padding-left: 5px; padding-bottom: 15px; border-top: 1px solid white; border: 1px solid white;">
                                        
                                        <p style="color: white;">Business Location (Address)</p>
                                        
                                        <p style="margin: 5px; text-align: center;">Providing accurate address information<br/>will help customers locate your business</p>
                                        
                                        <h3 style="text-align: center; color: #000099;">Enter your address in the fields below</h3>
                                        
                                        <p> House<input onkeydown="checkMiddleNumberHNumber();" onclick="checkMiddleNumberHNumber();" id="HouseNumber" type="text" name="HouseNumber" placeholder='123...' value="" size="4" style="background-color: #6699ff;"/>
                                           Street:<input id="Street" type="text" name="Street" placeholder='street/avenue' value="" size="24" style="background-color: #6699ff;"/></p>
                                        <p>Town:<input id="Town" type="text" name="Town" placeholder='town' value="" size="43" style="background-color: #6699ff;"/></p>
                                        <p>City:<input id="City" type="text" name="City" placeholder='city' value="" size="22" style="background-color: #6699ff;"/>
                                            Zip Code:<input onclick="checkMiddleNumberZCode();" onkeydown="checkMiddleNumberZCode();" id="ZCode" type="text" name="ZCode" placeholder='123...' value="" size="4" style="background-color: #6699ff;"/></p>
                                        <p>Country:<input id="Country" type="text" name="Country" placeholder='country' value="" size="40" style="background-color: #6699ff;"/></p>
                                        
                                        <p><input id="businessLocation" type="text" name="businessLocation" value="" readonly size="50" style="background-color: #6699ff; border: 1px solid black;"/></p>
                                       </td>
                                </tr>
                                
                                <script>
                                    var HouseNumber = document.getElementById("HouseNumber");

                                    function numberFuncHNumber(){

                                        var number = parseInt((HouseNumber.value.substring(HouseNumber.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            HouseNumber.value = HouseNumber.value.substring(0, (HouseNumber.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncHNumber, 1);

                                    function checkMiddleNumberHNumber(){

                                        for(var i = 0; i < HouseNumber.value.length; i++){

                                            var middleString = HouseNumber.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                HouseNumber.value = HouseNumber.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <script>
                                    var ZCode = document.getElementById("ZCode");

                                    function numberFuncZCode(){

                                        var number = parseInt((ZCode.value.substring(ZCode.value.length - 1)), 10);

                                        if(isNaN(number)){
                                            ZCode.value = ZCode.value.substring(0, (ZCode.value.length - 1));
                                        }

                                    }

                                    setInterval(numberFuncZCode, 1);

                                    function checkMiddleNumberZCode(){

                                        for(var i = 0; i < ZCode.value.length; i++){

                                            var middleString = ZCode.value.substring(i, (i+1));
                                            //window.alert(middleString);
                                            var middleNumber = parseInt(middleString, 10);
                                            //window.alert(middleNumber);
                                            if(isNaN(middleNumber)){
                                                ZCode.value = ZCode.value.substring(0, i);
                                            }
                                        }
                                    }

                                    //setInterval(checkMiddleNumber, 1000);
                                </script>
                                
                                <tr>
                                    <td style="padding-top: 10px;"><p>Business Email</p><input id="businessEmail" type="text" name="businessEmail" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Business Telephone</p><input onclick="checkMiddleNumberProBiz();" onkeydown="checkMiddleNumberProBiz();" id="businessTel" type="text" name="businessTel" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><select id="businessType" name="businessType">
                                            <option>Business Type</option>
                                            <option>Barber Shop</option>
                                            <option>Beauty Salon</option>
                                            <option>Day Spa</option>
                                            <option>Dentist</option>
                                            <option>Dietician</option>
                                            <option>Eyebrows and Eyelashes</option>
                                            <option>Hair Removal</option>
                                            <option>Hair Salon</option>
                                            <option>Holistic Medicine</option>
                                            <option>Home Services</option>
                                            <option>Makeup Artist</option>
                                            <option>Massage</option>
                                            <option>Medical Aesthetician</option>
                                            <option>Medical Center</option>
                                            <option>Nail Salon</option>
                                            <option>Personal Trainer</option>
                                            <option>Pet Services</option>
                                            <option>Physical Therapy</option>
                                            <option>Piercing</option>
                                            <option>Podiatry</option>
                                            <option>Tattoo Shop</option>
                                            <option>Other</option>
                                        </select></td>
                                </tr>
                                <tr>
                                    <td><input id="otherBusinessType" type="text" name="otherBusinessType" value="Specify business type here if not in categories" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table></center>
                    
                    <script>
                        var TelFldProBiz = document.getElementById("businessTel");
                        
                        function numberFuncProBiz(){
                            
                            var number = parseInt((TelFldProBiz.value.substring(TelFldProBiz.value.length - 1)), 10);
                            
                            if(isNaN(number)){
                                TelFldProBiz.value = TelFldProBiz.value.substring(0, (TelFldProBiz.value.length - 1));
                            }
                            
                        }
                        
                        setInterval(numberFuncProBiz, 1);
                        
                        function checkMiddleNumberProBiz(){
                            
                            for(var i = 0; i < TelFldProBiz.value.length; i++){

                                var middleString = TelFldProBiz.value.substring(i, (i+1));
                                //window.alert(middleString);
                                var middleNumber = parseInt(middleString, 10);
                                //window.alert(middleNumber);
                                if(isNaN(middleNumber)){
                                    TelFldProBiz.value = TelFldProBiz.value.substring(0, i);
                                }
                            }
                        }
                        
                        //setInterval(checkMiddleNumber, 1000);
                    </script>

                    <h2 style="margin: 5px; margin-top: 30px; ">Add login information</h2>
                    
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><p>User Name</p><input onkeyup="ProvUserNameCheck();" id="provUserName" type="text" name="provUserName" value="" size="50" style="background-color: #6699ff;"/>
                                        <p id="provUserNameStatus" style="background-color: red; color: white; text-align: center; max-width: 355px;"></p></td>
                                </tr>
                                <tr>
                                    <td><p>Password</p><input id="firstProvPassword" type="password" name="firstProvPassword" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                                <tr>
                                    <td><p>Password (Again)</p><input id="secondProvPassword" type="password" name="secondProvPassword" value="" size="50" style="background-color: #6699ff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                        <center><p style="width: 180px; background-color: red; color: white;" id="provPasswordStatus"></p></center>
                        <center><p style="width: 180px; background-color: green; color: white;" id="provFormStatus"></p></center>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="provSignUpBtn" class="button" type="submit" value="Sign up" name="provSignUpBtn" />
                    </form>
                                
                    <script>
                                    
                        function ProvUserNameCheck(){
                            
                            var userName = document.getElementById("provUserName").value;
                            
                            $.ajax({
                                type: "POST",
                                url: "CheckProvUserNameExist",
                                data: "UserName="+userName,
                                success: function(result){
                                    if(result === "true"){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = 'Username: <span style="color: blue;">"' + userName + '"</span> is not available. Choose a different Username';
                                        document.getElementById("provUserNameStatus").style.backgroundColor = "red";
                                        document.getElementById("provUserName").value = "";
                                        
                                    }else if(result === "false" && document.getElementById("provUserName").value !== ""){
                                        
                                        document.getElementById("provUserNameStatus").innerHTML = 'Username: <span style="color: orange;">"' + userName + '"</span> is available.';
                                        document.getElementById("provUserNameStatus").style.backgroundColor = "green";
                                        
                                    }else if(document.getElementById("provUserName").value === ""){
                                        
                                        //document.getElementById("provUserNameStatus").innerHTML = "";
                                        
                                    }
                                    
                                }
                            });
                        }  
                        
                    </script>
                
                <!--center><h4 style="margin-top: 15px;">Click here to go to Queue home page</a></h4></center-->
                </div>
                </div></center>
                
                <center><h4 style = "margin-bottom: 15px;">__________________________________________</h4></center>
                <center><p id="alreadyAccountStatus" ><a style="color: #000099;" href="LogInPage.jsp">Already have an account? <span style="color: #ffffff">Login now.</span></a></p></center>
            </div>
            
        </div>
                
        <div id="newbusiness" style=" height: 75%;">
            
        <center><div id ="logindetailsSignUP" style="padding-top: 100px;">
                <center><h4 style="margin-bottom: 30px;"><a href="LoginPageToQueue" style=" color: white; background-color: blue; border: 1px solid black; padding: 4px;">Click here to go to Queue home page</a></h2></center>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center>
                  
                <center><h2 style="margin-bottom: 20px;">Login Here</h2></center>
                
                <form name="login" action="LoginControllerMain" method="POST"><table border="0"> 
                        
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="45" style="background-color: #ccccff;"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder='enter your password here' type="password" name="password" value="" size="45" style="background-color: #ccccff;"/></td>
                                </tr>
                            </tbody>
                        </table>
                    
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                <center><h4 style = "margin-bottom: 15px;">____________________________________________</h4></center>
                </div></center>
            
            </div>
        </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/signUpPageScript.js"></script>
    <script src="scripts/script.js"></script>
    <script src="scripts/CollectAddressInfo.js"></script>
    
</html>
