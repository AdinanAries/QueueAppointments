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
public class IsBizBankCardAdded extends HttpServlet {

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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String ProvID = request.getParameter("ProviderID");
        String isCardAddedStatus = "NoRecordFound";
        
        try{
            Class.forName(DBDriver);
            Connection SaveIDConn = DriverManager.getConnection(DBURL, DBUser, DBPassword);
            String SaveIDSql = "select * from QueueServiceProviders.StripeConnectedAccountIDs where ProvID = ?";
            PreparedStatement GetStatusPst = SaveIDConn.prepareStatement(SaveIDSql);
            GetStatusPst.setString(1, ProvID);
            ResultSet GetStatusRec = GetStatusPst.executeQuery();
            
            while(GetStatusRec.next()){
                if(GetStatusRec.getString("CardAdded").trim().equalsIgnoreCase("0")){
                    isCardAddedStatus = "notAdded";
                }else if(GetStatusRec.getString("CardAdded").trim().equalsIgnoreCase("1")){
                    isCardAddedStatus = "Added";
                }
            }
            
            response.getWriter().print(isCardAddedStatus);
            
        }catch(Exception e){}
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
