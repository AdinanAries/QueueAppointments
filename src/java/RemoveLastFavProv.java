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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class RemoveLastFavProv extends HttpServlet {

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
        
          //Database connection parameters
           String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
           String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
           String user = "sa";
           String password = "Password@2014";
           
           String FavProvID = request.getParameter("UserID");
           String UserIndex = request.getParameter("UserIndex");
           
           try{
               
               Class.forName(Driver);
               Connection delProvConn = DriverManager.getConnection(url, user, password);
               String delProvString = "delete from ProviderCustomers.FavoriteProviders where ProviderId =?";
               
               PreparedStatement delProvPst = delProvConn.prepareStatement(delProvString);
               delProvPst.setString(1, FavProvID);
               
               delProvPst.executeUpdate();
               
               response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex);
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
