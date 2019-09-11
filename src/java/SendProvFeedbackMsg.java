

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class SendProvFeedbackMsg extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        Date currentDate = new Date();
        SimpleDateFormat currentDateSdf = new SimpleDateFormat("yyyy-MM-dd");
        String StringDate = currentDateSdf.format(currentDate);
        
        String FeedBackMessage = request.getParameter("FeedBackMessage").trim().replaceAll("( )+", " ");
        String ProviderID = request.getParameter("ProviderID");
        
        try{
            
            Class.forName(Driver);
            Connection FeedBackConn = DriverManager.getConnection(url, user, password);
            String FeedBackString = "insert into QueueObjects.FeedBackMessages (If_Provider_ID, FeedBackMessage, FeedBackDate) values(?,?,?)";
            PreparedStatement FeedBackPst = FeedBackConn.prepareStatement(FeedBackString);
            FeedBackPst.setString(1, ProviderID);
            FeedBackPst.setString(2, FeedBackMessage);
            FeedBackPst.setString(3, StringDate);
            FeedBackPst.executeUpdate();
            
            JOptionPane.showMessageDialog(null, "Your feedback was sent successfully!");
            
        }catch(Exception e){
            e.printStackTrace();
        }
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
