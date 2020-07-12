/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stripe.Stripe;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.Event;
import com.stripe.model.EventDataObjectDeserializer;
import com.stripe.model.StripeObject;
import com.stripe.net.Webhook;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class SubscriptionStatusWebHookHandler extends HttpServlet {
    
    private String DBDriver = "";
    private String DBUrl = "";
    private String DBUser = "";
    private String DBPassword = "";
    
    @Override
    public void init(ServletConfig config){
        
        DBDriver = config.getServletContext().getAttribute("").toString();
        DBUrl = config.getServletContext().getAttribute("").toString();
        DBUser = config.getServletContext().getAttribute("").toString();
        DBPassword = config.getServletContext().getAttribute("").toString();
    }

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //needed request handler global values
        String ProviderID = "";
        String StripeCustomerID = "";
        
        
        // Set your secret key. Remember to switch to your live secret key in production!
        // See your keys here: https://dashboard.stripe.com/account/apikeys
        Stripe.apiKey = "sk_live_dlnn4nlqjZg8vTmD4umnzOS900GsfWmpMF";

        String payload = "";
        
        //reading the body content of the post request
       if ("POST".equalsIgnoreCase(request.getMethod())) 
        {
           payload = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        }
        
        String sigHeader = request.getHeader("Stripe-Signature");
        String endpointSecret = "whsec_jSAb3EjfEzDas68nPXXsO2cSiHG87I1u";
        Event event = null;
        try {
            event = Webhook.constructEvent(payload, sigHeader, endpointSecret);
        } catch (SignatureVerificationException e) {
            // Invalid signature
            response.setStatus(400);
            response.getWriter().print("");
        }

        // Deserialize the nested object inside the event
        EventDataObjectDeserializer dataObjectDeserializer = event.getDataObjectDeserializer();
        StripeObject stripeObject = null;
        if (dataObjectDeserializer.getObject().isPresent()) {
            stripeObject = dataObjectDeserializer.getObject().get();
            
            // Converting event object to map
            ObjectMapper m = new ObjectMapper();
            @SuppressWarnings("unchecked")
            Map<String, Object> props = m.convertValue(event.getData(), Map.class);
            
            // Getting required data
            Object dataObj = props.get("object");

            // Converting data object to map
            @SuppressWarnings("unchecked")
            Map<String, String> objectMapper = m.convertValue(dataObj, Map.class);

            StripeCustomerID = objectMapper.get("customer");
            
            //JOptionPane.showMessageDialog(null, StripeCustomerID);
            
            //Getting User ID from database
            /*try{
                Class.forName(DBDriver);
                Connection GetIDConn = DriverManager.getConnection(DBUrl, DBUser, DBPassword);
                String GetIDSQL = "select ProvId from QueueObjects.StripSubscriptions where StripeCustomerId = ?";
                PreparedStatement GetIDPst = GetIDConn.prepareStatement(GetIDSQL);
                GetIDPst.setString(1, StripeCustomerID);
                
                ResultSet IDRec = GetIDPst.executeQuery();
                
                while(IDRec.next()){
                    ProviderID = IDRec.getString("ProvId").trim();
                }
            }catch(Exception e){}*/
            
        } else {
            // Deserialization failed, probably due to an API version mismatch.
            // Refer to the Javadoc documentation on `EventDataObjectDeserializer` for
            // instructions on how to handle this case, or return an error here.
        }

        switch (event.getType()) {
            
            case "invoice.paid":
                // Used to provision services after the trial has ended.
                // The status of the invoice will show up as paid. Store the status in your
                // database to reference when a user accesses your service to avoid hitting rate
                // limits.
                break;
            case "invoice.payment_failed":
                {// If the payment fails or the customer does not have a valid payment method,
                    // an invoice.payment_failed event is sent, the subscription becomes past_due.
                    // Use this webhook to notify your user that their payment has
                    // failed and to retrieve new card details.

                    //setting status to 0
                    try{
                        Class.forName(DBDriver);
                        Connection DltConn = DriverManager.getConnection(DBUrl, DBUser, DBPassword);
                        String DltSQL = "update QueueObjects.StripSubscriptions set status = 0 where StripeCustomerId = ?";
                        PreparedStatement DltPst = DltConn.prepareStatement(DltSQL);
                        DltPst.setString(1, StripeCustomerID);

                        DltPst.executeUpdate();

                        System.out.println("Service Provider Unsubscribed!");

                    }catch(Exception e){}

                    break;
                }
            case "invoice.finalized":
                // If you want to manually send out invoices to your customers
                // or store them locally to reference to avoid hitting Stripe rate limits.
                break;
            case "customer.subscription.deleted":
                // handle subscription cancelled automatically based
                // upon your subscription settings. Or if the user
                // cancels it.
                break;
            case "customer.subscription.trial_will_end":
                // Send notification to your user that the trial will end
                break;
            default:
                // Unhandled event type
        }

        response.setStatus(200);
        response.getWriter().print("");

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
