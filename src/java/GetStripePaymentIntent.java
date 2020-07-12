/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.RoundingMode;
import java.text.NumberFormat;
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
public class GetStripePaymentIntent extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String ConnAccID = request.getParameter("ConnAccID");
        float ChargeAmount = Float.parseFloat(request.getParameter("Charge"));
        
        /*NumberFormat nf = NumberFormat.getNumberInstance();
        nf.setRoundingMode(RoundingMode.FLOOR);
        String truncated = nf.format(ChargeAmount);*/
        String truncated = String.valueOf((int) ChargeAmount);

        
        try{
            truncated = truncated.replace(",", "");
        }catch(Exception e){}
        
        int IntChargeAmount = Integer.parseInt(truncated);
        //JOptionPane.showMessageDialog(null, IntChargeAmount);
        
        
        //Gson gson = new Gson();
        
        // Set your secret key. Remember to switch to your live secret key in production!
        // See your keys here: https://dashboard.stripe.com/account/apikeys
        Stripe.apiKey = "sk_live_dlnn4nlqjZg8vTmD4umnzOS900GsfWmpMF";

        ArrayList paymentMethodTypes = new ArrayList();
        paymentMethodTypes.add("card");

        Map<String, Object> params = new HashMap<>();
        params.put("payment_method_types", paymentMethodTypes);
        params.put("amount", IntChargeAmount);
        params.put("currency", "usd");
        params.put("application_fee_amount", 123);
        Map<String, Object> transferDataParams = new HashMap<>();
        transferDataParams.put("destination", ConnAccID);
        params.put("transfer_data", transferDataParams);
        PaymentIntent paymentIntent = null;
        try{
            paymentIntent = PaymentIntent.create(params);
        }catch(Exception e){
            System.out.println("could not create payment intent");
        }
        if(paymentIntent == null){
            response.getWriter().print("failed");
        }else{
            response.getWriter().print(paymentIntent.getClientSecret());
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
