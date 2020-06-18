<%-- 
    Document   : Queue
    Created on : Feb 10, 2019, 8:05:36 PM
    Author     : aries
--%>

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
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
        
        <title>Queue</title>
        
    </head>
    
    <body style="background: none; background-color: white;">
            
        <div style="min-height: 100vh; display: flex; flex-direction: column; justify-content: center;">
            
            <div style="">
                <p style="text-align: center; padding: 5px;"><img src="QueueLogo.png" style="opacity: 0.2; height: 50px; width: 120px;"/></p>
            </div>
         
            
            
            <div style="min-height: 100%;">
                
                <p style="text-align: center; font-family: roboto;">
                    <i style="color: orangered; text-align: center; font-size: 30px;" class="fa fa-exclamation-triangle" aria-hidden="true"> Oops!</i>
                </p>
                
                <p style="font-family: roboto; font-size: 18px; color: darkblue;  padding-bottom: 50px; text-align: center;">
                    Something went wrong... 
                    <br/>
                    <span style="font-size: 15px; color: #37a0f5">
                        <!--i style="color: orange;" class="fa fa-info-circle"></i-->
                        Make sure your Internet is working then try again.
                    </span>
                </p>
                
            </div>        
                          
        
                            
            <div style="font-family: roboto; width: 100vw; text-align: center; color: #8b8b8b; font-weight: bolder; padding: 5px;">
                <p>Theomotech Inc. &copy;2020</p>
            </div>
                            
        </div>
                            
    </body>
    
</html>
