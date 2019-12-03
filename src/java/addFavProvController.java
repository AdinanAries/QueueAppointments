

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

public class addFavProvController extends HttpServlet {

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
        
        int flag = 0;
        
        String ProviderID = request.getParameter("ProviderID");
        String CustomerID = request.getParameter("CustomerID");
        
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
                   //JOptionPane.showMessageDialog(null, "Provider already in your favorites list");
                   response.getWriter().print("Provider already in your favorites list");
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
                //JOptionPane.showMessageDialog(null, "Provider added to your favorites list");
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
