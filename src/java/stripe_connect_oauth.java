/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.google.gson.Gson;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.exception.oauth.InvalidGrantException;
import com.stripe.model.oauth.TokenResponse;
import com.stripe.net.OAuth;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;
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
public class stripe_connect_oauth extends HttpServlet {
    
    private static String DBURL = "";
    private static String DBDriver = "";
    private static String DBUser = "";
    private static String DBPassword = "";
    //private static String ProviderID = "";
    
    @Override
    public void init(ServletConfig config){
       DBURL = config.getServletContext().getAttribute("DBUrl").toString(); 
       DBDriver = config.getServletContext().getAttribute("DBDriver").toString();
       DBUser = config.getServletContext().getAttribute("DBUser").toString();
       DBPassword = config.getServletContext().getAttribute("DBPassword").toString(); 
    }
    
    private static Gson gson = null;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        gson =  new Gson();
        response.setContentType("application/json");
        
        // Set your secret key. Remember to switch to your live secret key in production!
        // See your keys here: https://dashboard.stripe.com/account/apikeys
        Stripe.apiKey = "sk_live_dlnn4nlqjZg8vTmD4umnzOS900GsfWmpMF";

        //staticFiles.externalLocation("../client");

        // Assert the state matches the state you provided in the OAuth link (optional).
        String state = request.getParameter("state");
        String ProviderID = state.substring(0, 1);
        //JOptionPane.showMessageDialog(null, UserID);
        /*if (!stateMatches(state)) {
            return buildResponse(
              response, 403, "error", "Incorrect state parameter: " + state
            );
        }*/
        
        // Send the authorization code to Stripe's API.
        String code = request.getParameter("code");
        Map<String, Object> params = new HashMap<>();
        params.put("grant_type", "authorization_code");
        params.put("code", code);
        
        try {
            TokenResponse stripeResponse = OAuth.token(params, null);
            // Save the connected account ID from the response to your database.
            String connectedAccountId = stripeResponse.getStripeUserId();
            saveAccountId(connectedAccountId, ProviderID);

            // Render some HTML or redirect to a different page.
            //return buildResponse(response, 200, "success", "Request succeeded.");
            response.sendRedirect("QueueConfirmPage.jsp?message=Your bank has been added successfully to receive online payments");
        } catch (InvalidGrantException e) {
            // There's a problem with the authorization code.
            response.getWriter().print(buildResponse("error", "Invalid authorization code: " + code));
        } catch (StripeException e) {
            // All other errors.
            response.getWriter().print(buildResponse( "error", "An unknown error occurred."));
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
    
    private static boolean stateMatches(String parameterState) {
        // Load the same state value that you randomly generated for your OAuth link.
        String savedState = "{{ STATE }}";

        return savedState.equals(parameterState);
    }

    private static void saveAccountId(String id, String ProvID) {
        //System.out.println("Connected account ID: " + id);
        try{
            Class.forName(DBDriver);
            Connection SaveIDConn = DriverManager.getConnection(DBURL, DBUser, DBPassword);
            String SaveIDSql = "INSERT INTO QueueServiceProviders.StripeConnectedAccountIDs (ProvID, StripeConnectID, CardAdded) values (?,?,?)";
            PreparedStatement SaveIDPst = SaveIDConn.prepareStatement(SaveIDSql);
            SaveIDPst.setString(1, ProvID);
            SaveIDPst.setString(2, id);
            SaveIDPst.setInt(3, 1);
            
            SaveIDPst.executeUpdate();
            
        }catch(Exception e){}
    }
    
    private static String buildResponse(String type, String message){
        
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put(type, message);
        return gson.toJson(errorResponse);
        
    }

    /*private static String buildResponse(
        Response response, int statusCode, String type, String message
    ){
        response.status(statusCode);
        Map<String, String> errorResponse = new HashMap<>();
        errorResponse.put(type, message);
        return gson.toJson(errorResponse);
    }*/

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
