
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


public class SaveProviderBizBankCard extends HttpServlet {

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
        
        String ProviderID = request.getParameter("");
        String AccNo = request.getParameter("");
        String AccHName = request.getParameter("");
        String AccRNo = request.getParameter("");
        String AccSecCode = request.getParameter("");
        String AccExpDate = request.getParameter("");
        String Verified = request.getParameter("");
        
        try{
            
            Class.forName(Driver);
            Connection saveConn = DriverManager.getConnection(url, user, password);
            String saveString = "insert into QueueServiceProviders.BizAccount (ProvID, AccNo, AccHName, AccRNo, AccSecCode, AccExpDate, Verified)"
                    + "values (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement savePst = saveConn.prepareStatement(saveString);
            savePst.setString(1, ProviderID);
            savePst.setString(2, AccNo);
            savePst.setString(3, AccHName);
            savePst.setString(4, AccRNo);
            savePst.setString(5, AccSecCode);
            savePst.setString(6, AccExpDate);
            savePst.setString(7, Verified);
            
            savePst.executeUpdate();
            
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
