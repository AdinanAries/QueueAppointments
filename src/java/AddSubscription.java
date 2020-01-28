
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;


public class AddSubscription extends HttpServlet {
    String DBURL = "";
    String DBUser = "";
    String DBPassword = "";
    String DBDriver = "";
    
    @Override
    public void init(ServletConfig config){
        DBURL = config.getServletContext().getAttribute("DBUrl").toString(); 
        DBDriver = config.getServletContext().getAttribute("DBDriver").toString();
        DBUser = config.getServletContext().getAttribute("DBUser").toString();
        DBPassword = config.getServletContext().getAttribute("DBPassword").toString();
    }
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String ProviderID = request.getParameter("ProviderID");
        
        SimpleDateFormat DBDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String SubsDate = DBDateFormat.format(new Date());
        //JOptionPane.showMessageDialog(null, SubsDate);
        
        Calendar cal = Calendar.getInstance(); 
        cal.add(Calendar.MONTH, 3);
        String SubsExpDate = DBDateFormat.format(cal.getTime());
        //JOptionPane.showMessageDialog(null, SubsExpDate);
        
        try{
            
            Class.forName(DBDriver);
            Connection SubsConn = DriverManager.getConnection(DBURL, DBUser, DBPassword);
            String SubsString = "insert into QueueServiceProviders.Subscription (ProviderID,SubscriptionType,RenewDate,ExpDate,AutoPay,PaySuccess) "
                    + "values (?,?,?,?,?,?)";
            
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
            SubsPst.setString(1, ProviderID);
            SubsPst.setString(2, "Starter");
            SubsPst.setString(3, SubsDate);
            SubsPst.setString(4, SubsExpDate);
            SubsPst.setInt(5, 0);
            SubsPst.setInt(6, 0);
            
            SubsPst.executeUpdate();
            //JOptionPane.showMessageDialog(null, "Added");
        }
        catch(Exception e){}
        
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
