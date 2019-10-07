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
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aries
 */
public class FGPasswordEmailExists extends HttpServlet {

    String Driver = "";
    String url = "";
    String user = "";
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
        
        String Email = request.getParameter("Email");
        
        String Exists = "false";
        String AccountType = "";
        
        try{
            Class.forName(Driver);
            Connection pswdConn = DriverManager.getConnection(url, user, password);
            String pswdQuery = "Select * from ProviderCustomers.CustomerInfo where Email like '"+Email+"%'";
            PreparedStatement pswdPst = pswdConn.prepareStatement(pswdQuery);
            ResultSet pswdRec = pswdPst.executeQuery();
            
            while(pswdRec.next()){
                Exists = pswdRec.getString("Customer_ID").trim();
                AccountType = "Customer";
            }
            
        }catch(Exception e){}
        
        try{
            Class.forName(Driver);
            Connection pswdConn = DriverManager.getConnection(url, user, password);
            String pswdQuery = "Select * from QueueServiceProviders.ProviderInfo where Email like '"+Email+"%'";
            PreparedStatement pswdPst = pswdConn.prepareStatement(pswdQuery);
            ResultSet pswdRec = pswdPst.executeQuery();
            
            while(pswdRec.next()){
                
                Exists = pswdRec.getString("Provider_ID").trim();
                AccountType = "Business";
            }
            
        }catch(Exception e){}
        
        response.getWriter().print(
                "{" +
                    "\"Exists\": \"" + Exists + "\","+
                    "\"AccountType\": \"" + AccountType + "\"" +
                "}"
        );
       
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
