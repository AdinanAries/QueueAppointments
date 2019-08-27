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
        
        //resetting ResendAppointmentData data feilds
        ResendAppointmentData.CustomerID = "";
        ResendAppointmentData.ProviderID = "";
        ResendAppointmentData.SelectedServices = "";
        ResendAppointmentData.AppointmentDate = "";
        ResendAppointmentData.AppointmentTime = "";
        ResendAppointmentData.PaymentMethod = "";
        ResendAppointmentData.ServicesCost = "";
        ResendAppointmentData.CreditCardNumber = "";
        
        
        String Message = "You are not logged in";
        
        //if(UserAccount.AccountType.equals("CustomerAccount"))
            //response.sendRedirect("ProviderCustomerPage.jsp");
        
        //if(UserAccount.AccountType.equals("BusinessAccount"))
            //response.sendRedirect("ServiceProviderPage.jsp");
        
    %>
    
    <body>
        
        <div id="container">
            
            <div id="miniNav" style="display: none;">
                <center>
                    <ul id="miniNavIcons" style="float: left;">
                        <li onclick="scrollToTop()" style="padding-left: 2px; padding-right: 2px;"><img src="icons/icons8-up-24.png" width="24" height="24" alt="icons8-up-24"/>
                        </li>
                    </ul>
                    <form name="miniDivSearch" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                            <input style="margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;"
                                   placeholder="Search provider" name="SearchFld" type="text"  value="" size="30" />
                            <input style="margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;" 
                                   type="submit" value="Search" />
                    </form>
                </center>
            </div>
            
        <div id="header">
            
            <cetnter><p> </p></cetnter>
            <center><image src="QueueLogo.png" style="margin-top: 5px;"/></center>
            <center><p style="font-size: 25px; font-family: serif; margin: 5px;"><b>Find medical & beauty places</b></p></center>
            
        </div>
            
        <div id="content">
            
            <div id="nav">
                
                <h4><a href="index.jsp" style ="color: blanchedalmond">AriesLab.com</a></h4>
                <h4><a href="SignUpPage.jsp" style=" color: #000099;">First time on Queue (Sign-up now)</a></h4>
                <h4><a href="PageController?Message=<%=Message%>" style=" color: black;">Go to your dashboard/Login now</a></h4>
                <center><p style = "width: 130px; margin: 5px;"><span id="displayDate" style=""></span></p></center>
                        
                <center><div class =" SearchObject">
                        
                    <form name="searchForm" action="QueueSelectBusinessSearchResult.jsp" method="POST">
                        <input placeholder='Search Service Provider' class="searchfld" value="" type="text" name="SearchFld" size="" /><input class="searchbtn" type="submit" value="Search" name="SearchBtn" />
                    </form> 
                        
                </div></center>
                
                <div id="SearchDivNB" style="margin-top: 5px;">
                <center><form action="ByAddressSearchResult.jsp" method="POST" style="background-color: #6699ff; border: 1px solid darkblue; padding: 5px; border-radius: 5px; width: 500px;">
                    <p style="color: #000099;"><img src="icons/icons8-marker-filled-30.png" width="15" height="15" alt="icons8-marker-filled-30"/>
                        Find services at location below</p>
                    <p>City: <input style="width: 400px; background-color: #6699ff;" type="text" name="city4Search" placeholder="" value=""/></p> 
                    <p>Town: <input style="background-color: #6699ff;" type="text" name="town4Search" value=""/> Zip Code: <input style="width: 60px; background-color: #6699ff;" type="text" name="zcode4Search" value="" /></p>
                    <p><input type="submit" style="background-color: #6699ff; color: white; padding: 5px; border-radius: 5px; border: 1px solid white; width: 490px;" value="Search" /></p>
                    </form></center>
                </div>
                
            </div>
            
            <div id="main" class="Main" style="padding-top: 5px;">
               
                <center><p style="max-width: 350px; color: white; background-color: red; margin-bottom: 10px;"><%=Message%></p><center>
               
                <!--h1>Academic Appointments</h1>
                <h2>Select Service category</h2>
                
                <h1>Health Services Appointments</h1>
                <h2>Select Service category</h2>
                
                
                <h1>Beaty Services Appointments</h1-->
                <h4>Select Service category</h4>
                
                 <div id="firstSetProvIcons">
                <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBusiness.jsp"><p style="margin:0;">All Services</p><img src="icons/icons8-ellipsis-filled-70.png" width="70" height="70" alt="icons8-ellipsis-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBarberBusiness.jsp"><p style="margin:0;" name="BarberShopSelect">Barber Shop</p><img src="icons/icons8-barber-clippers-filled-70.png" width="70" height="70" alt="icons8-barber-clippers-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectMakeUpArtist.jsp"><p style="margin:0;" name="MakeupArtistSelect">Makeup Artist</p><img src="icons/icons8-cosmetic-brush-filled-70.png" width="70" height="70" alt="icons8-cosmetic-brush-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectPodiatry.jsp"><p style="margin:0;" name="PodiatrySelect">Podiatry</p><img src="icons/icons8-foot-filled-70.png" width="70" height="70" alt="icons8-foot-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectHairSalon.jsp"><p style="margin:0;">Hair Salon</p><img src="icons/icons8-woman's-hair-filled-70.png" width="70" height="70" alt="icons8-woman's-hair-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMassage.jsp"><p style="margin:0;" name="MassageSelect">Massage</p><img src="icons/icons8-massage-filled-70.png" width="70" height="70" alt="icons8-massage-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHolisticMed.jsp"><p style="margin:0;" name="HolMedSelect">Holistic Medicine</p><img src="icons/icons8-pill-filled-70.png" width="70" height="70" alt="icons8-pill-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectMedAesthet.jsp"><p style="margin:0;" name="MedEsthSelect">Medical Aesthetician</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectDentist.jsp"><p style="margin:0;">Dentist</p><img src="icons/icons8-tooth-filled-70.png" width="70" height="70" alt="icons8-tooth-filled-70"/>
                            </a></center></td>
                        </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Next</p></center>
                
                </div>
                
                <div id="secondSetProvIcons" style="display: none;">
                    <center><table id="providericons">
                        <tbody>
                        <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBrowsLashes.jsp"><p style="margin:0;" name="EyebrowsSelect">Eyebrows and Lashes</p><img src="icons/icons8-eye-filled-70.png" width="70" height="70" alt="icons8-eye-filled-70"/>
                            </a></center></td>
                             <td style="width: 33.3%;"><center><a href="QueueSelectDietician.jsp"><p style="margin:0;" name="DieticianSelect">Dietician</p><img src="icons/icons8-dairy-filled-70.png" width="70" height="70" alt="icons8-dairy-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectPetServe.jsp"><p style="margin:0;" name="PetServicesSelect">Pet Services</p><img src="icons/icons8-dog-filled-70.png" width="70" height="70" alt="icons8-dog-filled-70"/>
                            </a></center></td>
                        </tr>
                        <tr>
                            <td><center><a href="QueueSelectHomeServe.jsp"><p style="margin:0;" name="HomeServicesSelect">Home Services</p><img src="icons/icons8-home-filled-70.png" width="70" height="70" alt="icons8-home-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPiercing.jsp"><p style="margin:0;" name="PiercingSelect">Piercing</p><img src="icons/icons8-piercing-filled-70.png" width="70" height="70" alt="icons8-piercing-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectTattoo.jsp"><p style="margin:0;">Tattoo Shop</p><img src="icons/icons8-tattoo-machine-filled-70.png" width="70" height="70" alt="icons8-tattoo-machine-filled-70"/>
                            </a></center></td>
                        <tr>
                            <td><center><a href="QueueSelectNailSalon.jsp"><p style="margin:0;" name="NailSalonSelect">Nail Salon</p><img src="icons/icons8-nails-filled-70.png" width="70" height="70" alt="icons8-nails-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPersonalTrainer.jsp"><p style="margin:0;" name="PersonalTrainSelect">Personal Trainer</p><img src="icons/icons8-personal-trainer-filled-70.png" width="70" height="70" alt="icons8-personal-trainer-filled-70"/>
                            </a></center></td>
                            <td><center><a href="QueueSelectPhisicalTherapy.jsp"><p style="margin:0;" name="PhysicalTherapySelect">Physical Therapy</p><img src="icons/icons8-physical-therapy-filled-70.png" width="70" height="70" alt="icons8-physical-therapy-filled-70"/>
                            </a></center></td>
                        </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p style="margin-bottom: 7px; margin-top: 10px;"><span onclick="showFirstSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; cursor: pointer; border-radius: 4px;">Previous</span>
                            <span onclick="showThirdSetProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; padding-left: 17px; padding-right: 18px; width: 50px; cursor: pointer; border-radius: 4px;">Next</span></p></center>
                
                </div>
                
                <div id="thirdSetProvIcons" style="display: none;">
                        <center><table id="providericons">
                        <tbody>
                            <tr>
                            <td style="width: 33.3%;"><center><a href="QueueSelectDaySpa.jsp"><p style="margin:0;">Day Spa</p><img src="icons/icons8-sauna-filled-70.png" width="70" height="70" alt="icons8-sauna-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectHairRemoval.jsp"><p style="margin:0;">Hair Removal</p><img src="icons/icons8-skin-filled-70.png" width="70" height="70" alt="icons8-skin-filled-70"/>
                            </a></center></td>
                            <td style="width: 33.3%;"><center><a href="QueueSelectBeautySalon.jsp"><p style="margin:0;" name="BeautySalonSelect">Beauty Salon</p><img src="icons/icons8-cleansing-filled-70.png" width="70" height="70" alt="icons8-cleansing-filled-70"/>
                            </a></center></td>
                            </tr> 
                            <tr>
                                <td><center><a href="QueueSelectMedicalCenter.jsp"><p style="margin:0;">Medical Center</p><img src="icons/icons8-hospital-3-filled-70.png" width="70" height="70" alt="icons8-hospital-3-filled-70"/>
                                </a></center></td>
                            </tr>
                    </tbody>
                    </table></center>
                    
                    <center><p onclick="showSecondFromThirdProvIcons()" style="text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;">Previous</p></center>

                </div>
                
            </div>
                
        </div>
                
        <div id="newbusiness" style="height: 525px;">
            
            <center><p id='addBizTxt' style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; color: #000099"><b>Add your business or create customer account here</b>
                </p></center>
            
            <div id="businessdetails" >
                
            <center><form name="AddBusiness" action="SignUpPage.jsp" method="POST">
                    <table border="0">
                        <tbody>
                            <tr>
                                <td><p style="color: white; text-align: center;">Provide your information below<p></td>
                            </tr>
                            <tr>
                                <td><input id="signUpFirtNameFld" placeholder="enter your first name" type="text" name="firstName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="sigUpLastNameFld" placeholder="enter your last name" type="text" name="lastName" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input onclick="checkMiddleNumber();" onkeydown="checkMiddleNumber();" id="signUpTelFld" placeholder="enter your telephone/mobile number here" type="text" name="telNumber" value="" size="50"/></td>
                            </tr>
                            <tr>
                                <td><input id="signUpEmailFld" placeholder="enter your email address here" type="text" name="email" value="" size="50"/></td>
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
                    <input id="loginPageSignUpBtn" class="button" type="submit" value="Submit" name="submitBtn" />
                </form></center>
                
            </div>
            
            <center><p style="font-size: 20px; margin-top: 30px; margin-bottom: 20px; color: #000099"><b>Login to view and manage your spots</b></p></center>
            
            <center><div id ="logindetails">
                    
                    <form name="login" action="LoginControllerMain" method="POST">
                        
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td><input id="LoginPageUserNameFld" placeholder="enter your Queue user name here" type="text" name="username" value="" size="50"/></td>
                                </tr>
                                <tr>
                                    <td><input id="LoginPagePasswordFld" placeholder="enter your password" type="password" name="password" value="" size="51"/></td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <input class="button" type="reset" value="Reset" name="resetbtn"/>
                        <input id="loginPageBtn" class="button" type="submit" value="Login" name="submitbtn" />
                    </form>
                    
                </div></center>
            
                </div>
                
        <div id="footer">
            <p>AriesLab &copy;2019</p>
        </div>
                
    </div>
                
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/loginPageBtn.js"></script>
    
</html>
