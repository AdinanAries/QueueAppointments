<%-- 
    Document   : ProviderSubscription
    Created on : Jun 20, 2019, 9:07:55 PM
    Author     : aries
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="manifest" href="/manifest.json" />
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <title>Queue: Subscribe</title>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ccccff" />
        
    </head>
    
    <%
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        String SelectedCost = request.getParameter("SubscPlan");
        
        //JOptionPane.showMessageDialog(null, SelectedCost);
        
        //card parameters
        String CardNumber = request.getParameter("CardNumber");
        String CardName = request.getParameter("CardName");
        String CardExpDate = request.getParameter("CardExpDate");
        String CardSecCode = request.getParameter("CardSecCode");
        
        String SelectedPlan = "";
        String SelectedPlanCost = "";
        String TaxOnly = "";
        String PlusTaxCost = "";
        
        String Monthly = "";
        String Annual = "";
        String SixMonths = "";
        
        try{
            Class.forName(Driver);
            Connection SubsConn = DriverManager.getConnection(url, User, Password);
            String SubsString = "select * from QueueObjects.SubcriptionsInfo where Cost like '%"+SelectedCost+"%'";
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
                                        
            ResultSet SubsRec = SubsPst.executeQuery();
                                        
            while(SubsRec.next()){
                                            
                String SubsType = SubsRec.getString("_Type").trim();
                Double SubsCost = SubsRec.getDouble("Cost");
                Double Tax = ((8.875/100) * SubsCost);
                Double PlusTax = ((8.875/100) * SubsCost) + SubsCost;
                                            
                DecimalFormat Dcf = new DecimalFormat("#.##");
                SelectedPlanCost = Dcf.format(SubsCost);
                TaxOnly = Dcf.format(Tax);
                PlusTaxCost = Dcf.format(PlusTax);
                
                SelectedPlan = SubsType + "($" + SelectedPlanCost + ")";
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        Calendar cal = Calendar.getInstance(); 
        SimpleDateFormat calSdf = new SimpleDateFormat("MMMMMMMMMMMMM dd, yyyy");
        String calDate = calSdf.format(cal.getTime());
        
        if(SelectedPlan.contains("Annual")){
            cal.add(Calendar.MONTH, 12);
        }else if(SelectedPlan.contains("Monthly")){
            cal.add(Calendar.MONTH, 1);
        }else if(SelectedPlan.contains("6Months")){
            cal.add(Calendar.MONTH, 6);
        }
        String SubsExpDate = calSdf.format(cal.getTime());
        
        //JOptionPane.showMessageDialog(null, SubsExpDate);
        
        
    %>
    
    <body style="margin: 0;">
        
        <center><div style="width: 100%; max-width: 700px; background-color: #6699ff; padding-bottom: 10px; min-height: 800px;">
                
                <div style="background-color: #ccccff; padding: 4px;">
                    <img src="QueueLogo.png" width="195" height="61" alt="QueueLogo"/>
                </div>
                <div>
                    
                    <h3>Add your payment to complete your subscription</h3>
                    <p style="color: white; background-color: green;">Your subscription will expire on <%=SubsExpDate%></p>
                    
                    <center><div style="background-color: white; width: 80%; max-width: 500px; padding: 5px;">
                <form name="PaymentsForm" action="PaymentsForm" method="POST">
                   
                    <div style="padding: 5px;  border-bottom: 1px solid darkgray;">
                        <p style="text-align: right; margin:0; color: #7e7e7e">Subscription Plan: 
                            <!--select name="SubscriptionType">
                                
                                <option value="<=SelectedPlanCost%>"><=SelectedPlan%></option>
                                
                                <
                                    try{
                                        Class.forName(Driver);
                                        Connection SubsConn = DriverManager.getConnection(url, User, Password);
                                        String SubsString = "select * from QueueObjects.SubcriptionsInfo";
                                        PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
                                        
                                        ResultSet SubsRec = SubsPst.executeQuery();
                                        
                                        while(SubsRec.next()){
                                            
                                            String SubsType = SubsRec.getString("_Type").trim();
                                            Double SubsCost = SubsRec.getDouble("Cost");
                                            
                                            DecimalFormat Dcf = new DecimalFormat("#.##");
                                            String SubsStringCost = Dcf.format(SubsCost);
                                            
                                            String DisplaySubscription = SubsType + "($" + SubsStringCost + ")";
                                    
                                %>
                                
                                            <option value="<=SubsStringCost%>"><=DisplaySubscription%></option>
                                    
                                < 
                                        }
                                    }catch(Exception e){
                                        e.printStackTrace();
                                    }
                                %>
                            </select--><%=SelectedPlan%></p>
                    <P style="text-align: right; margin: 0; color: #7e7e7e;">Tax: <%=TaxOnly%></P>
                    <p style="text-align: right; margin: 0; color: #7e7e7e;">Total: $<%=PlusTaxCost%></p>
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
                                        <input type="text" name="CardNumber" value="<%=CardNumber%>" size="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="margin: 0;">Card Holder's Name</p>
                                        <input type="text" name="CardName" value="<%=CardName%>" size="40" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style='margin: 0;'><span style="margin: 0;">CVV</span><span style="margin: 0; margin-left: 65px;">Exp. Date</span></p>
                                        <input type="text" name="CardCVV" value="<%=CardSecCode%>" size="10" />
                                        <input type="text" name="CardExp" value="<%=CardExpDate%>" size="23" />
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
                    <div style="border-bottom: 1px solid darkgrey; padding: 5px;">
                        <p style="text-align: left; color: #000099; font-weight: bolder;">Your Business Bank Card Below (Optional)</p>
                        <div >
                        </div>
                    </div>
                    <input style=' margin: 5px; background-color: pink; border: 1px solid black; padding: 5px; border-radius: 4px;' type="submit" value="Submit" />
                </form>
            </div></center>
        
                </div>
            
        </div></center>
        
    </body>
</html>
