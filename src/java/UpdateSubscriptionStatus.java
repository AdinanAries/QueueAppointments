/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aries
 */
public class UpdateSubscriptionStatus extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    String url = "";
    String user = "";
    String Driver = "";
    String password = "";
    
    @Override
    public void init(ServletConfig config){
        url = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //String StripeProductId = request.getParameter("ProductId");
        //String StripeSubscriptionID = request.getParameter("SubscriptionID");
        //String StripePriceID = request.getParameter("PriceID");
        String status = request.getParameter("status");
        int DB_status = 0;
        String ProviderID = request.getParameter("ProviderID");
        
        if(status.equalsIgnoreCase("active")){
            DB_status = 1;
        }else if(status.equalsIgnoreCase("inactive")){
            DB_status = 0;
        }
        
        
        try{
            
            Class.forName(Driver);
            Connection saveConn = DriverManager.getConnection(url, user, password);
            String saveString = "UPDATE  QueueObjects.StripSubscriptions SET status = ?"
                    + " where ProvId = ?";
            PreparedStatement savePst = saveConn.prepareStatement(saveString);
            savePst.setInt(1, DB_status);
            savePst.setString(2, ProviderID);
            
            savePst.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
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
