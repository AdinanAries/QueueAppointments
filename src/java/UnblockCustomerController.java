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
public class UnblockCustomerController extends HttpServlet {
    
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String BlockedID = request.getParameter("BlockedID");
        
        try{
            Class.forName(Driver);
            Connection unblockConn = DriverManager.getConnection(url, user, password);
            String unblockString = "Delete from QueueServiceProviders.BlockedCustomers where BlockedID = ?";
            PreparedStatement unblockPst = unblockConn.prepareStatement(unblockString);
            unblockPst.setString(1, BlockedID);
            
            unblockPst.executeUpdate();
            //JOptionPane.showMessageDialog(null, "Person Unblocked Successfully");
            response.getWriter().print("Person Unblocked Successfully");
            //response.sendRedirect("ServiceProviderPage.jsp");
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
       
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
