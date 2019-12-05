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
public class RemoveLastFavProv extends HttpServlet {

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
            doPost(request, response);
        
        }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
           String FavProvID = request.getParameter("UserID");
           String UserIndex = request.getParameter("UserIndex");
           String NewUserName = request.getParameter("User");
           
           try{
               
               Class.forName(Driver);
               Connection delProvConn = DriverManager.getConnection(url, user, password);
               String delProvString = "delete from ProviderCustomers.FavoriteProviders where ProviderId =?";
               
               PreparedStatement delProvPst = delProvConn.prepareStatement(delProvString);
               delProvPst.setString(1, FavProvID);
               
               delProvPst.executeUpdate();
               
               response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Provider removed from your favorites");
               //JOptionPane.showMessageDialog(null, "Provider removed from your favorites");
               
               
           }catch(Exception e){
                e.printStackTrace();
           }
        
        
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
