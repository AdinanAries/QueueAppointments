

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


public class ProvSubscriptionControl extends HttpServlet {

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
        
        String ProviderID = "";
        String SubsType = "";
        String RenewDate = "";
        String ExpDate = "";
        int AutoPay = 0;
        int PaySuccess = 0;
        
        
        //Subscription ExpDate calculation below
        
        
        try{
            Class.forName(Driver);
            Connection SubsConn = DriverManager.getConnection(url, user, password);
            String SubsInsert = "Insert into QueueServiceProviders.Subscription (ProviderID, SubscriptionType, RenewDate, ExpDate, AutoPay, PaySuccess) values(?, ?, ?, ?, ?, ?)";
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsInsert);
            SubsPst.setString(1, ProviderID);
            SubsPst.setString(2, SubsType);
            SubsPst.setString(3, RenewDate);
            SubsPst.setString(4, ExpDate);
            SubsPst.setInt(5, AutoPay);
            SubsPst.setInt(6, PaySuccess);
            
            SubsPst.executeUpdate();
            
            //JOptionPane.showMessageDialog(null, "Subscription finished successfully");
            response.getWriter().print("Subscription finished successfully");
            
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
