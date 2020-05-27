/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


//import com.stripe.model.billingportal.Session;
//import com.stripe.model.Review.Session;
import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.stripe.net.RequestOptions;
import com.stripe.param.checkout.SessionCreateParams;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class StripePaymentControl extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try{
            Stripe.apiKey = "sk_test_EC7e1f7iodwPa8U1GTIECHsR00zWDKWZdD";
            
            /*Map<String, Object> params = new HashMap<String, Object>();
            ArrayList<String> paymentMethodTypes = new ArrayList<>();
            paymentMethodTypes.add("card");
            params.put("payment_method_types", paymentMethodTypes);

            HashMap<String, Object> subscriptionData = new HashMap<String, Object>();
            ArrayList<HashMap<String, Object>> lineItems = new ArrayList<>();
            HashMap<String, Object> lineItem = new HashMap<String, Object>();

            lineItem.put("name", "Queue");
            lineItem.put("amount", "999");
            lineItem.put("currency", "usd");
            lineItem.put("quantity", 1);
            lineItems.add(lineItem);
            params.put("line_items", lineItems);
            params.put("mode", "payment");

            //subscriptionData.put("trial_period_days", 30);
            //params.put("subscription_data", subscriptionData);

            params.put("success_url", "https://example.com/success");
            params.put("cancel_url", "https://example.com/cancel");
 
            Session session = Session.create(params);*/
            
            // Set your secret key. Remember to switch to your live secret key in production!
// See your keys here: https://dashboard.stripe.com/account/apikeys


Map<String, Object> params = new HashMap<String, Object>();

ArrayList<String> paymentMethodTypes = new ArrayList<>();
paymentMethodTypes.add("card");
params.put("payment_method_types", paymentMethodTypes);

HashMap<String, Object> subscriptionData = new HashMap<String, Object>();
ArrayList<HashMap<String, Object>> lineItems = new ArrayList<>();
HashMap<String, Object> lineItem = new HashMap<String, Object>();

lineItem.put("price", "price_HM3ZrFMxbmVBcP");
lineItem.put("quantity", 1);
lineItems.add(lineItem);
params.put("line_items", lineItems);
params.put("mode", "subscription");

subscriptionData.put("trial_period_days", 30);
params.put("subscription_data", subscriptionData);

params.put("success_url", "https://example.com/success");
params.put("cancel_url", "https://example.com/cancel");

Session session = Session.create(params);
            
            JOptionPane.showMessageDialog(null, "session created");
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e.getMessage());
            
        }
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
