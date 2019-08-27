
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

/**
 *
 * @author aries
 */
public class BlockCustController extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        String CustomerID = request.getParameter("CustomerID");
        
        boolean isCustBlocked = false;
        
        try{
            Class.forName(Driver);
            Connection BlckCustConn = DriverManager.getConnection(url, user, password);
            String BlckCustString = "Select * from QueueServiceProviders.BlockedCustomers where ProviderId = ? and CustomerID = ?";
            PreparedStatement BlckCustPst = BlckCustConn.prepareStatement(BlckCustString);
            BlckCustPst.setString(1, ProviderID);
            BlckCustPst.setString(2, CustomerID);

            ResultSet BlckCustRec = BlckCustPst.executeQuery();
            
            while(BlckCustRec.next()){
                isCustBlocked = true;
                JOptionPane.showMessageDialog(null, "Person already Blocked");
                //response.sendRedirect("ServiceProviderPage.jsp");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        if(isCustBlocked == false){
            try{
                Class.forName(Driver);
                Connection BlckCustConn = DriverManager.getConnection(url, user, password);
                String BlckCustString = "insert into QueueServiceProviders.BlockedCustomers (ProviderId, CustomerID) values (?,?)";
                PreparedStatement BlckCustPst = BlckCustConn.prepareStatement(BlckCustString);
                BlckCustPst.setString(1, ProviderID);
                BlckCustPst.setString(2, CustomerID);

                BlckCustPst.executeUpdate();
                JOptionPane.showMessageDialog(null, "Person Blocked Successfully");
                response.getWriter().print("notInList");
                //response.sendRedirect("ServiceProviderPage.jsp");
            }
            catch(Exception e){
                e.printStackTrace();
            }
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
