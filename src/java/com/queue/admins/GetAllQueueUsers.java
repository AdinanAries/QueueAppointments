
package com.queue.admins;

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
import javax.swing.JOptionPane;


public class GetAllQueueUsers extends HttpServlet {

    String url = "";
    String user = "";
    String password = "";
    String Driver = "";
    
    @Override
    public void init(ServletConfig config){
        
        url = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String JSONRes = "{ \"TotalBusinesses\": ";
        int TotalUsers = 0;
        
        try{
            Class.forName(Driver);
            Connection BizCountConn = DriverManager.getConnection(url, user, password);
            String BizCountQuery = "Select Count(Provider_ID) from QueueServiceProviders.ProviderInfo";
            PreparedStatement BizCountPst = BizCountConn.prepareStatement(BizCountQuery);
            ResultSet BizCountRec = BizCountPst.executeQuery();
            
            while(BizCountRec.next()){
                int BizCount = BizCountRec.getInt(1);
                TotalUsers += BizCount;
                JSONRes += BizCount;
                JSONRes += ", ";
                //JOptionPane.showMessageDialog(null, BizCount);
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        JSONRes += "\"TotalCustomers\": ";
        
        try{
            Class.forName(Driver);
            Connection CustCountConn = DriverManager.getConnection(url, user, password);
            String CustCountQuery = "Select Count(Customer_ID) from ProviderCustomers.CustomerInfo";
            PreparedStatement CustCountPst = CustCountConn.prepareStatement(CustCountQuery);
            ResultSet CustCountRec = CustCountPst.executeQuery();
            
            while(CustCountRec.next()){
                int CustCount = CustCountRec.getInt(1);
                TotalUsers += CustCount;
                JSONRes += CustCount;
                JSONRes += ", ";
                //JOptionPane.showMessageDialog(null, BizCount);
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        JSONRes += "\"TotalUsers\": ";
        JSONRes += TotalUsers;
        JSONRes += " }";
        
        response.getWriter().print(JSONRes);
        
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
