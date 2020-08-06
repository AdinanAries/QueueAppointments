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
public class GetApptID extends HttpServlet {

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
        
        String ApptDate = request.getParameter("ApptDate");
        String ApptTime = request.getParameter("ApptTime");
        String CustID = request.getParameter("CustID");
        String ProvID = request.getParameter("ProvID");
        boolean isIDFound = false;
        String ApptID = "";
        String JSonRes = "{ ";
        
        try{
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String IDQuery = "Select AppointmentID from QueueObjects.BookedAppointment where CustomerID = ? and ProviderID = ? and AppointmentDate = ? and AppointmentTime = ?";
            PreparedStatement IDPst = conn.prepareStatement(IDQuery);
            IDPst.setString(1, CustID);
            IDPst.setString(2, ProvID);
            IDPst.setString(3, ApptDate);
            IDPst.setString(4, ApptTime);
            
            ResultSet IDRec = IDPst.executeQuery();
            
            while(IDRec.next()){
                isIDFound = true;
                ApptID = IDRec.getString("AppointmentID").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(!isIDFound){
            JSonRes += "\"status\": \"fail\", ";
            JSonRes += "\"msg\": \"the appointment fields provided doesn't match any appointment record\"";
            JSonRes += " }";
        }else{
            JSonRes += "\"status\": \"success\", ";
            JSonRes += "\"id\": \""+ ApptID+ "\"";
            JSonRes += " }";
        }
        
        response.getWriter().print(JSonRes);
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
