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
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class GetSubscriptionStatus extends HttpServlet {

    String DBURL = "";
    String DBDriver = "";
    String DBUser = "";
    String DBPassword = "";
    
    @Override
    public void init(ServletConfig config){
       DBURL = config.getServletContext().getAttribute("DBUrl").toString(); 
       DBDriver = config.getServletContext().getAttribute("DBDriver").toString();
       DBUser = config.getServletContext().getAttribute("DBUser").toString();
       DBPassword = config.getServletContext().getAttribute("DBPassword").toString(); 
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = "not_added";
        String ProviderID = request.getParameter("ProviderID");
        
        try{
            Class.forName(DBDriver);
            Connection SubsConn = DriverManager.getConnection(DBURL, DBUser, DBPassword);
            String SubsString = "select status from QueueObjects.StripSubscriptions where ProvId = ?";
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
            
            SubsPst.setString(1,ProviderID);
            
            ResultSet SubsRec = SubsPst.executeQuery();
            
            while(SubsRec.next()){
                //JOptionPane.showMessageDialog(null, SubsRec.getString("status"));
                if(SubsRec.getString("status").equalsIgnoreCase("0")){
                    status = "inactive";
                } else if (SubsRec.getString("status").equalsIgnoreCase("1")){
                    status = "active";
                }
            }
            
        }catch(Exception e){
            
        }
        
        response.getWriter().print(status);
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
