<%-- 
    Document   : ProviderSubscription
    Created on : Jun 20, 2019, 9:07:55 PM
    Author     : aries
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <title>Queue: Subscribe</title>
    </head>
    <body style="margin: 0; padding-bottom: 0; background-color: #ccccff;">
        
        <center><div style="width: 100%; max-width: 700px; background-color: #6699ff; padding-bottom: 10px; min-height: 800px;">
                
                <div style="background-color: #ccccff; padding: 4px;">
                    <img src="QueueLogo.png" width="195" height="61" alt="QueueLogo"/>
                </div>
                <div>
                    
                    <h3>Add your payment to renew your subscription</h3>
                    <p style="color: white; background-color: red">Your subscription expired on DATE</p>
                    
                    <center><div style="background-color: white; width: 80%; max-width: 500px; padding: 5px;">
                <form name="PaymentsForm" action="PaymentsForm" method="POST">
                   
                    <div style="padding: 5px;  border-bottom: 1px solid darkgray;">
                        <p style="text-align: right; margin:0; color: #7e7e7e">Subscription Plan: 
                            <select name="SubscriptionType">
                                <option>Monthly(price)</option>
                                <option>Annual(price)</option>
                            </select></p>
                    <p style="text-align: right; margin: 0; color: #7e7e7e;">Total: $30.00</p>
                    </div>
                    
                    <table  style="max-width: 300px;">
                        <tbody>
                            <tr>
                                <td style="width: 100px; height: 50px; border: 0; opacity: 0.3"><img src="visa-logo-vector.png" width="50" height="40" alt="visa-logo-vector"/>
                                </td>
                                <td style="width: 100px; height: 50px; border: 0; opacity: 0.3"><img src="American_Express_card_logo.png" width="50" height="40" alt="American_Express_card_logo"/>
                                </td>
                                <td style="width: 100px; height: 50px; border: 0; opacity: 0.3"><img src="DiscoverLogo.png" width="50" height="40" alt="DiscoverLogo"/>
                                </td>
                                <td style="width: 100px; height: 50px; border: 0; opacity: 0.3"><img src="MasterCardLogo.png" width="50" height="40" alt="MasterCardLogo"/>
                                </td>
                                <td style="width: 100px; height: 50px; border: 0; opacity: 0.3"><img src="paypal_logo.jpg" width="50" height="40" alt="paypal_logo"/>
                                </td>
                                
                            </tr>
                        </tbody>
                    </table>
                    <div style="border-bottom: 1px solid darkgrey; padding: 5px;">
                        <p style="margin: 0; text-align: left; margin: 4px; color: #000099; font-weight: bolder;">Credit/Debit Card <span style="color: red;">*</span></p>
                        
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <p style="margin: 0;">Card Number</p>
                                        <input type="text" name="Card Number" value="" size="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="margin: 0;">Card Holder's Name</p>
                                        <input type="text" name="Card Number" value="" size="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style='margin: 0;'><span style="margin: 0;">CVV</span><span style="margin: 0; margin-left: 65px;">Exp. Date</span></p>
                                        <input type="text" name="Card Number" value="" size="10" />
                                        <input type="text" name="Card Number" value="" size="23" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                    </div>
                    <div style="border-bottom: 1px solid darkgrey; padding: 5px;">
                        <p style="text-align: left; margin-bottom: 4px; color: #000099; font-weight: bolder;">Billing Address <span style="color: red;">*</span></p>
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <p style='margin: 0;'>Street Address</p>
                                        <input type="text" name="Street Address" value="" size="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style='margin: 0;'> Town <span style='margin-left: 95px;'>City</span></p>
                                        <input type="text" name="Street Address" value="" size="17" />
                                        <input type="text" name="Street Address" value="" size="16" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style='margin: 0;'> Zip Code <span style='margin-left: 35px;'>Country</span></p>
                                        <input type="text" name="Street Address" value="" size="10" />
                                        <input type="text" name="Street Address" value="" size="23" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <input style=' margin: 5px; background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;' type="submit" value="Submit" />
                </form>
            </div></center>
        
                </div>
            
        </div></center>
        
    </body>
</html>
