
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;


public class isProviderSubscriptionExpired extends HttpServlet {
    
    String DBURL = "";
    String DBDriver = "";
    String DBUser = "";
    String DBPassword = "";
    
    @Override
    public void init(ServletConfig config){
       DBURL = config.getServletContext().getAttribute("DBUrl").toString(); 
       DBDriver = config.getServletContext().getAttribute("DBDriver").toString();
       DBUser = config.getServletContext().getAttribute("DBUser").toString();
       DBPassword = config.getServletContext().getAttribute("DBPassword").toString(); 
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String SubscriptionStatus = "";
        String ProviderID = request.getParameter("ProviderID");
        SimpleDateFormat DBDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date SubsExpDate = null;
        
        try{
            Class.forName(DBDriver);
            Connection SubsConn = DriverManager.getConnection(DBURL, DBUser, DBPassword);
            String SubsString = "select ExpDate from QueueServiceProviders.Subscription where ProviderID = ?";
            PreparedStatement SubsPst = SubsConn.prepareStatement(SubsString);
            
            SubsPst.setString(1,ProviderID);
            
            ResultSet SubsRec = SubsPst.executeQuery();
            
            while(SubsRec.next()){
                String ExpDate = SubsRec.getString("ExpDate").trim();
                SubsExpDate = DBDateFormat.parse(ExpDate);
                JOptionPane.showMessageDialog(null, SubsExpDate.toString());
            }
            
        }catch(Exception e){
            
        }
        
        if(SubsExpDate.compareTo(new Date()) < 0){
            SubscriptionStatus = "Expired";
        }else{
            SubscriptionStatus = "NotExpired";
        }
        
        response.getWriter().print(SubscriptionStatus);
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
