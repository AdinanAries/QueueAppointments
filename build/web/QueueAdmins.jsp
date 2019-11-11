<%-- 
    Document   : QueueAdmins
    Created on : Nov 6, 2019, 10:05:11 AM
    Author     : aries
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Queue Administrator</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        
        <script src="http://code.jquery.com/jquery-latest.js"></script>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
        
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <style>
            *{
                margin: 0;
                padding: 0;
            }
            .Container{
                
            }
            .Header{
                background-color: #d8d8d8;
                min-height: 160px;
                padding-bottom: 5px;
                padding-top: 5px;
                border-bottom: 1px solid darkgrey;
            }
            .Content{
                
                
            }
            .SettingsNav{
                float: left;
                margin-left: 5px;
                width: 77.65%;
                border: 1px solid darkgray;
                border-bottom: 0;
            }
            .SettingsNav li{
                display: inline-block;
                list-style-type: none;
                border: 1px solid white;
                color: white;
                margin: 4px;
                background-color: #ccc;
                padding: 5px;
                cursor: pointer;
                width: 14%;
                text-align: center;
            }
            .SettingsNav .active{
                background-color: #eeeeee;
                border-color: black;
                color: black;
            }
            .SettingsNav li:hover{
                background-color: #eeeeee;
                color: black;
                border-color: black;
            }
            .AdminInfoDiv{
                width: 19.7%;
                float: right;
                margin-right: 5px;
                background-color: #ccc;
                padding: 5px;
                
            }
            .SettingsCompartments{
                margin-top: 5px;
                background-color:  #d8d8d8;
                
            }
            .SearchFld{
                width: 80%;
                border: 1px solid darkgrey;
                background-color: #ccc;
                padding: 5px;
                margin-top: 5px;
            }
            
            .SearchDiv{
                padding: 5px;
                float: left;
                border: 1px solid darkgray;
                margin-left: 5px;
                width: 77%;
            }
            .SearchBtn{
                height: 26px;
            }
            
            .settingsCompartment{
                margin: 1px;
            }
            .svrStatus{
                width: 19.7%;
                float: right;
                margin-right: 5px;
                background-color: #ccc;
                padding: 5px;
                margin-top: 5px;
                min-height: 70px;
                
            }
            .detailedSearchDiv{
                float: right;
                width: 55%;
            }
            .OneParamSearch{
                width: 42%;
                float: left;
                border-right: 1px solid darkgrey;
            }
            .SettingsOutPutPane table tbody tr td{
                border: 1px solid darkgray;
                background-color: slategrey;
                color: white;
                cursor: pointer;
            }
            .SettingsOutPutPane .active{
                background-color: #907998;
            }
            .QueueCommand{
                width: 99%;
                background-color: black;
                color: white;
                min-height: 365px;
                padding: 5px;
                padding-left: 10px;
                
            }
            .CommandsInput{
                width: 100%;
                height: 310px;
                overflow-x: auto;
                overflow-y: auto;
                padding-top: 20px;
                background-color: black;
                color: white;
                border: 0;
                font-family: monospace;
                font-size: 13px;
            }
            .svrStatusInfo .inactive{
                display: none;
            }
            .CommandLine{
                width: 90%;
                background-color: black;
                font-family: monospace;
                font-size: 13px;
                color: white;
                border: 0;
            }
            .LoginDiv{
                display: none;
                background-color: #eeeeee;
                padding-top: 10px;
                padding-bottom: 0;
            }
            .QueueFld{
                width: 400px;
                border: 1px solid darkgrey;
                background-color: #ccc;
                padding: 5px;
                margin-top: 5px;
                
            }
            .LoginBtn{
                border: 1px solid darkgrey;
                padding: 5px;
                margin-top: 5px;
                text-align: center;
            }
            .footer{
                text-align: right;
                background-color: red;
                color: white;
                height: 20px;
                font-family: monospace;
                padding-right: 10px;
            }
        </style>
    </head>
    <body>
        <center><div class='LoginDiv' id='LoginDiv'>
            <img src="QueueLogo.png" width="342" height="125" alt="QueueLogo"/>
            <p id='LoginStatus' style='color: white; background-color: red; margin-top: 20px; width: 400px;'>You are not logged in</p>
            <h3 style='margin-top: 20px; margin-bottom: 20px; color: #000099;'>Please provide your admin credentials below</h3>
            <p>Username</p>
            <input id='MainUserNameFld' class='QueueFld' type='text' placeholder="Please enter your admin username" /><br/>
            <p style='margin-top: 10px;'>Password</p>
            <input id='MainPasswordFld' class='QueueFld' type='password' placeholder='Please enter your admin password' /><br>
            <input style='margin-top: 10px; width: 412.5px;' id='MainLoginBtn' class='LoginBtn' type='button' value='Login' />
            <p style='margin-top: 20px;' class='footer'>(c) 2019 AriesLab. All rights reserved.</p>
            <script>
                $(document).ready(function(){
                    $("#MainLoginBtn").click(function(event){
                        
                        var UserName = document.getElementById("MainUserNameFld").value;
                        var Password = document.getElementById("MainPasswordFld").value;
                        
                        //alert(UserName);
                        //alert(Password);
                        
                        if(UserName === "Admin" && Password === "Admin"){
                            document.getElementById("LoginDiv").style.display = "none";
                            document.getElementById("Container").style.display = "block";
                        }else{
                            document.getElementById("LoginStatus").innerHTML = "Please enter correct user credentials";
                        }
                        
                        /*$.ajax({
                            type: "POST",
                            url: "",
                            data: "",
                            success: function(result){
                                
                            }
                        });*/
                    });
                });
            </script>
        </div></center>
        <div id='Container' class="Container">
            <script>
                var LoggedinFlag = false;
                
                if(LoggedinFlag === false){
                    document.getElementById("Container").style.display = "none";
                    document.getElementById("LoginDiv").style.display = "block";
                }else{
                    document.getElementById("LoginDiv").style.display = "none";
                }
            </script>
            <div class="Header">
                <center><ul class="SettingsNav">
                    <li>Server</li>
                    <li>Database</li>
                    <li>Users Feedback</li>
                    <li class="active">Search</li>
                    <li>Settings Option</li>
                    <li>Misc</li>
                </ul></center>
                <div class="AdminInfoDiv">
                    <div style="width: 70%;float:right;">
                        <h4 style="margin:0;padding:0; color: blue;">Your Admin name here</h4>
                        <p style="margin:0;padding:0; color: #000099;">Admin Role</p>
                        <p style="margin: 0;padding:0; color: #000099;;">Admin Other</p>
                    </div>
                    <div style="width: 27%; height: 60px; background-color: #333333;">
                        
                    </div>
                    <p></p>
                </div>
                <div class="SearchDiv">
                    <div class="OneParamSearch">
                        <p>Search Queue User</p>
                        <input class="SearchFld" id="ClientEmailSearchFld" type="text" name="ClientSearchFld" placeholder="Enter person's email address to search">
                        <input class="SearchBtn" id='EmailSearchBtn' type='button'  value='Search'/><br/>
                        <input class="SearchFld" id="ClientTelSearchFld" type="text" name="ClientSearchFld" placeholder="Enter person's phone number to search">
                        <input class="SearchBtn" id='TelSearchBtn' type='button'  value='Search'/><br/>
                        <input class="SearchFld" id="ClientIDSearchFld" type="text" name="ClientSearchFld" placeholder="Enter person's ID number to search">
                        <input class="SearchBtn" id='IDSearchBtn' type='button'  value='Search'/>
                    </div>
                    <div class="detailedSearchDiv">
                        <p>Detailed Search</p>
                        <span style="width: 100%">
                            <input class="SearchFld" style="width: 30%;" id="FNameFld" type="text" placeholder="first name"/>
                            <input class="SearchFld" style="width: 30%;" id="MNameFld" type="text" placeholder="middle name" />
                            <input class="SearchFld" style="width: 30%;" id="LNameFld" type="text" placeholder="last name" />
                        </span>
                        <span style="width: 100%;">
                            <input class="SearchFld" style="width: 45.5%;" id="EmailFld" type="text" placeholder="email" />
                            <input class="SearchFld" style="width: 47%" id="MobileFld" type="text" placeholder="mobile number" />
                        </span>
                        <input class="SearchBtn" style="width: 97%; margin-top: 5px;" id="DetailedSearchBtn" type="button" value="Search"/>
                    </div>
                    <p style="clear: both;"></p>
                </div>
                <div class="svrStatus">
                    <p>Server Summary</p> 
                    <table style="width: 100%;">
                        <tbody>
                            <tr>
                                <td>
                                    <p style="color: rosybrown;">Server Status:</p> 
                                </td>
                                <td class="svrStatusInfo">
                                    <p id="svrOffLineStatus" class="inactive" style="color: red; text-align: right;">
                                        Offline <img style="width: 10px; height: 10px;" src="icons/icons8-new-moon-20.png" alt="icons8-new-moon-20"/>
                                    </p>
                                    <p id="svrOnlineStatus" style="color: green; text-align: right;">
                                        Online <img style="width: 10px; height: 10px;" src="icons/icons8-new-moon-20 (1).png" alt="icons8-new-moon-20 (1)"/>

                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p style="color: rosybrown;">Login Counts:</p>
                                </td>
                                <td>
                                    <p style="color: red; text-align: right;">0</p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <p style="color: rosybrown;">Total Queue Users</p>
                                </td>
                                <td>
                                    <p style="color: red; text-align: right;">0</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                </div>
                <p style="clear: both; height: 0;"></p>
            </div>
            <div class="Content">
                
                <div class="SettingsCompartments">
                    <div class='settingsCompartment' style="width: 24.7%; border: 1px solid darkgrey; height: 100px; float: left;">
                        
                    </div>
                    <div class='settingsCompartment' style="width: 24.7%; border: 1px solid darkgrey; height: 100px; float: left;">
                        
                    </div>
                    <div class='settingsCompartment' style="width: 24.7%; border: 1px solid darkgrey; height: 100px; float: left;">
                        
                    </div>
                    <div class='settingsCompartment' style="width: 24.7%; border: 1px solid darkgrey; height: 100px; float: left;">
                        
                    </div>
                    <div class="SettingsOutPutPane" class="settingsCompartment" style="clear: both; width: 99.63%; border: 1px solid darkgrey; height: 400px;">
                        <table style="width: 100%; text-align: center;">
                            <tbody>
                                <tr>
                                    <td>Results</td>
                                    <td>Message</td>
                                    <td>Settings</td>
                                    <td class="active">Terminal</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="QueueCommand">
                            <p style="font-size: 13px; font-family: monospace;">Queue [Version 10.0.18362.418]<p>
                            <p style="font-size: 13px; font-family: monospace;">(c) 2019 AriesLab. All rights reserved.</p>
                            <div id="MainCommandsInput" class="CommandsInput">
                                <p>Queue/UserName >> <input id="ActiveLine" class="CommandLine" type="text" /></p>
                                
                            </div>
                            <script>
                                //document.getElementById("MainCommandsInput").innerHTML = "";
                            </script>
                        </div>
                        
                    </div>
                    <div class="settingsCompartment" style="width: 49.5%; border: 1px solid darkgrey; height: 200px; float: left;">
                        
                    </div>
                    <div class="settingsCompartment" style="width: 49.8%; border: 1px solid darkgrey; height: 200px; float: left;">
                        
                    </div>
                    <div class="settingsCompartment" style="width: 49%; border: 1px solid darkgrey; height: 200px; float: left;">
                        
                    </div>
                    <div class="settingsCompartment" style="width: 25%; border: 1px solid darkgrey; height: 200px; float: left;">
                        
                    </div>
                    <div class="settingsCompartment" style="width: 25%; border: 1px solid darkgrey; height: 200px; float: left;">
                        
                    </div>
                    <p style="clear: both;"></p>
                </div>
            </div>
        </div>
    </body>
</html>
