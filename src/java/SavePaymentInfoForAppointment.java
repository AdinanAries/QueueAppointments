
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

/**
 *
 * @author aries
 */
public class SavePaymentInfoForAppointment extends HttpServlet {

    
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
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String ApptID = request.getParameter("ApptID");
        String CustID = request.getParameter("CustID");
        String ProvID = request.getParameter("ProvID");
        String PercentPaid = request.getParameter("PercentPaid");
        String AmountPaid = request.getParameter("AmountPaid");
        String BalanceToPay = request.getParameter("BalanceToPay");
        
        String JSonRes = "";
        boolean ResStatus = false;
        
        try{
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String SQL = "Insert into QueueObjects.PaymentBalance (ApptID, CustID, ProvID, PercentPaid, AmountPaid, BalanceToPay) values (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(SQL);
            pst.setString(1, ApptID);
            pst.setString(2, CustID);
            pst.setString(3, ProvID);
            pst.setString(4, PercentPaid);
            pst.setString(5, AmountPaid);
            pst.setString(6, BalanceToPay);
            
            pst.executeUpdate();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection SlctConn = DriverManager.getConnection(url, user, password);
            String SlctQuery = "Select id from QueueObjects.PaymentBalance where ApptID = ? and CustID = ? and ProvID = ? and PercentPaid = ? and AmountPaid = ? and BalanceToPay = ?";
            PreparedStatement SlctPst = SlctConn.prepareStatement(SlctQuery);
            
            SlctPst.setString(1, ApptID);
            SlctPst.setString(2, CustID);
            SlctPst.setString(3, ProvID);
            SlctPst.setString(4, PercentPaid);
            SlctPst.setString(5, AmountPaid);
            SlctPst.setString(6, BalanceToPay);
            
            ResultSet SlctRec = SlctPst.executeQuery();
            
            while(SlctRec.next()){
                ResStatus = true;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(ResStatus){
            JSonRes += 
                "{ " +
                    "\"status\": \"success\", " +
                    "\"msg\": \"payment and balance has been logged successfuly\"" +
                " }";
        }else{
            JSonRes += 
                "{ " +
                    "\"status\": \"fail\", " +
                    "\"msg\": \"logging of payment and balance was not completed\"" +
                " }";
        }
        
        response.getWriter().print(JSonRes);
        
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
