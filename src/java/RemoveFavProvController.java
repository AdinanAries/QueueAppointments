

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

public class RemoveFavProvController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
          //Database connection parameters
           String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
           String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
           String user = "sa";
           String password = "Password@2014";
           
           String FavProvID = request.getParameter("UserID");
           
           try{
               
               Class.forName(Driver);
               Connection delProvConn = DriverManager.getConnection(url, user, password);
               String delProvString = "delete from ProviderCustomers.FavoriteProviders where ProviderId =?";
               
               PreparedStatement delProvPst = delProvConn.prepareStatement(delProvString);
               delProvPst.setString(1, FavProvID);
               
               delProvPst.executeUpdate();
               
               //response.sendRedirect("ProviderCustomerPage.jsp");
               JOptionPane.showMessageDialog(null, "Provider removed from your favorites");
               
               
           }catch(Exception e){
                e.printStackTrace();
           }
        
   
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
