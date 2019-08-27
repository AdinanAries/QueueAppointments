

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

public class addFavProvController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int flag = 0;
        
        String ProviderID = request.getParameter("ProviderID");
        String CustomerID = request.getParameter("CustomerID");
        
        //Database connection parameters
           String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
           String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
           String user = "sa";
           String password = "Password@2014";
           
           try{
               
               Class.forName(Driver);
               Connection selectFavConn = DriverManager.getConnection(url, user, password);
               String selectFavString = "select * from ProviderCustomers.FavoriteProviders where ProviderId =? and CustomerId =?";
               
               PreparedStatement selectFavPst = selectFavConn.prepareStatement(selectFavString);
               selectFavPst.setString(1,ProviderID);
               selectFavPst.setString(2,CustomerID);
               
               ResultSet favRow = selectFavPst.executeQuery();
               
               while(favRow.next()){
                   flag = 1;
                   //response.sendRedirect("ProviderCustomerPage.jsp");
                   JOptionPane.showMessageDialog(null, "Provider already in your favorites list");
               }
               
           }catch(Exception e){
               e.printStackTrace();
           }
           
           
        if(flag == 0){
            
            try{

                Class.forName(Driver);
                Connection addFavConn = DriverManager.getConnection(url, user, password);
                String addFavString = "insert into ProviderCustomers.FavoriteProviders values (?, ?)";

                PreparedStatement addFavPst = addFavConn.prepareStatement(addFavString);
                addFavPst.setString(1, ProviderID);
                addFavPst.setString(2, CustomerID);

                addFavPst.executeUpdate();

                //response.sendRedirect("ProviderCustomerPage.jsp");
                JOptionPane.showMessageDialog(null, "Provider added to your favorites list");
                response.getWriter().print("NewAdded");

            }catch(Exception e){
                e.printStackTrace();
            }
            
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
