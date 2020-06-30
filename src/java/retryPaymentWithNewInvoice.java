/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.RetryInvoiceBody;
import com.google.gson.Gson;
import com.stripe.Stripe;
import com.stripe.exception.CardException;
import com.stripe.model.Customer;
import com.stripe.model.Invoice;
import com.stripe.model.PaymentMethod;
import com.stripe.param.PaymentMethodAttachParams;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class retryPaymentWithNewInvoice extends HttpServlet {

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
        // Set your secret key. Remember to switch to your live secret key in production!
        // See your keys here: https://dashboard.stripe.com/account/apikeys
        Stripe.apiKey = "sk_live_dlnn4nlqjZg8vTmD4umnzOS900GsfWmpMF";
        response.setContentType("application/json");
        Gson gson = new Gson();
        
        String JsonData = "";
       
        //reading the body content of the post request
       if ("POST".equalsIgnoreCase(request.getMethod())) 
        {
           JsonData = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        }
            
        // Set the default payment method on the customer
        RetryInvoiceBody postBody = gson.fromJson(JsonData, RetryInvoiceBody.class);
        Customer customer = null; 
        
        /*JOptionPane.showMessageDialog(null, postBody);
        JOptionPane.showMessageDialog(null, postBody.getCustomerId());
        JOptionPane.showMessageDialog(null, postBody.getPaymentMethodId());
        JOptionPane.showMessageDialog(null, postBody.getInvoiceId());*/
        
        try{ 
            customer = Customer.retrieve(postBody.getCustomerId());
        }catch(Exception e){
            System.out.println(e.getMessage());
        }

        try {
            // Set the default payment method on the customer
            PaymentMethod pm = PaymentMethod.retrieve(postBody.getPaymentMethodId());
            pm.attach(PaymentMethodAttachParams.builder().setCustomer(customer.getId()).build());
        } catch (Exception e) {
            // Since it's a decline, CardException will be caught
            Map<String, String> responseErrorMessage = new HashMap<>();
            responseErrorMessage.put("message", e.getLocalizedMessage());
            Map<String, Object> responseError = new HashMap<>();
            responseError.put("error", responseErrorMessage);
                
            response.getWriter().print(responseError);
        }

        Map<String, Object> customerParams = new HashMap<String, Object>();
        Map<String, String> invoiceSettings = new HashMap<String, String>();
        invoiceSettings.put("default_payment_method", postBody.getPaymentMethodId());
        customerParams.put("invoice_settings", invoiceSettings);
            
        try{
            customer.update(customerParams);
        }catch(Exception e){
            System.out.println(e.getMessage());
        }

        List<String> expandList = new ArrayList<>();
        expandList.add("payment_intent");

        Map<String, Object> params = new HashMap<>();
        params.put("expand", expandList);

        Invoice invoice = null;
        try{
            invoice = Invoice.retrieve(postBody.getInvoiceId(), params, null);
        }catch(Exception e){
            System.out.println(e.getMessage());
        }

        response.getWriter().print(invoice.toJson());
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
