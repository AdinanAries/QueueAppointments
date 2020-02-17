
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

/**
 *
 * @author aries
 */
public class SetAddressMobile extends HttpServlet {

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
        
        String CustomerID = request.getParameter("CustomerID");
           String HouseNumber = request.getParameter("houseNumberFld").trim().replaceAll("( )+", " ");
           String StreetName = request.getParameter("streetAddressFld").trim().replaceAll("( )+", " ");
           String Town = request.getParameter("townFld").trim().replaceAll("( )+", " ");
           String City = request.getParameter("cityFld").trim().replaceAll("( )+", " ");
           String Country = request.getParameter("countryFld").trim().replaceAll("( )+", " ");
           String ZipCode = request.getParameter("zipCodeFld").trim().replaceAll("( )+", " ");
           
           String UserIndex = request.getParameter("UserIndex");
           String NewUserName = request.getParameter("User");
           
           try{
               
               Class.forName(Driver);
               Connection addressConn = DriverManager.getConnection(url, user, password);
               String addressString = "insert into QueueObjects.CustomerAddress values"
                       + "(?,?,?,?,?,?,?)";
               
               PreparedStatement addressPst = addressConn.prepareStatement(addressString);
               addressPst.setString(1, CustomerID);
               addressPst.setString(2, HouseNumber);
               addressPst.setString(3, StreetName);
               addressPst.setString(4, Town);
               addressPst.setString(5, City);
               addressPst.setString(6, Country);
               addressPst.setString(7, ZipCode);
               
               addressPst.executeUpdate();
               //JOptionPane.showMessageDialog(null, "Address added successfully!");
               response.sendRedirect("ProviderCustomerUserAccountWindow.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Address added successfully");
               
           }catch(Exception e){
               
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
