

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
import javax.swing.JOptionPane;

public class EmailMobileValidation extends HttpServlet {

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
        
        //JOptionPane.showMessageDialog(null, "Servlet Called!");
        
        boolean Found = false;
        String UserID = "";
        
        String Email = request.getParameter("Email");
        String Mobile = request.getParameter("Mobile");
        String AccountType = request.getParameter("AccountType");
        
        
        if(AccountType.equals("Business")){
            try{
                Class.forName(Driver);
                Connection validateConn = DriverManager.getConnection(url, user, password);
                String validateQuery = "select Provider_ID from QueueServiceProviders.ProviderInfo where Email = ? and Phone_Number = ? ";
                PreparedStatement validatePst = validateConn.prepareStatement(validateQuery);
                validatePst.setString(1,Email);
                validatePst.setString(2,Mobile);
                
                ResultSet validateRec = validatePst.executeQuery();
                
                while(validateRec.next()){
                    //JOptionPane.showMessageDialog(null, "Provider Account Found");
                    Found = true;
                    UserID = validateRec.getString("Provider_ID").trim();
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        if(AccountType.equals("Customer")){
            try{
                Class.forName(Driver);
                Connection validateConn = DriverManager.getConnection(url, user, password);
                String validateQuery = "select Customer_ID from ProviderCustomers.CustomerInfo where Email = ? and Phone_Number = ? ";
                PreparedStatement validatePst = validateConn.prepareStatement(validateQuery);
                validatePst.setString(1,Email);
                validatePst.setString(2,Mobile);
                
                ResultSet validateRec = validatePst.executeQuery();
                
                while(validateRec.next()){
                    //JOptionPane.showMessageDialog(null, "Customer Account Found");
                    Found = true;
                    UserID = validateRec.getString("Customer_ID").trim();
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        response.getWriter().print(
                "{"
                    + "\"Found\": \"" +Found+ "\","
                    + "\"UserID\": \"" +UserID+ "\"" +
                "}"
        );
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
