

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
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class PasswordResetController extends HttpServlet {

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
        
        String UserID = request.getParameter("UserID");
        String AccountType = request.getParameter("AccountType");
        String Password = request.getParameter("Password");
        
        if(AccountType.equals("Business")){
            try{

                Class.forName(Driver);
                Connection PswdConn = DriverManager.getConnection(url, user, password);
                String PswdUpdate = "update QueueServiceProviders.UserAccount set Password = ? where Provider_ID = ?";
                PreparedStatement PswdPst = PswdConn.prepareStatement(PswdUpdate);

                PswdPst.setString(1, Password);
                PswdPst.setString(2, UserID);

                PswdPst.executeUpdate();

                //JOptionPane.showMessageDialog(null, "Prrovider Password Updated");

            }catch(Exception e){
                e.printStackTrace();
            }
        }
        else if(AccountType.equals("Customer")){
            try{

                Class.forName(Driver);
                Connection PswdConn = DriverManager.getConnection(url, user, password);
                String PswdUpdate = "update ProviderCustomers.UserAccount set Password = ? where CustomerId = ?";
                PreparedStatement PswdPst = PswdConn.prepareStatement(PswdUpdate);

                PswdPst.setString(1, Password);
                PswdPst.setString(2, UserID);

                PswdPst.executeUpdate();
                //JOptionPane.showMessageDialog(null, "Customer Password Updated");


            }catch(Exception e){
                e.printStackTrace();
            }
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
