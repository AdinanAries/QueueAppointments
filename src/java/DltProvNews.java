
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

/**
 *
 * @author aries
 */
public class DltProvNews extends HttpServlet {

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
        
        String MessageID = request.getParameter("MessageID");
        String LastMessageID = "";
        String ProvID = "";
        String Visibility = "";
        
        try{
            Class.forName(Driver);
            Connection SlctConn = DriverManager.getConnection(url, user, password);
            String SlctString = "Select ProvID, VisibleTo from QueueServiceProviders.MessageUpdates where MsgID = ?";
            PreparedStatement SlctPst = SlctConn.prepareStatement(SlctString);
            SlctPst.setString(1, MessageID);
            ResultSet SlctRec = SlctPst.executeQuery();
            
            while(SlctRec.next()){
                Visibility = SlctRec.getString("VisibleTo").trim();
                ProvID = SlctRec.getString("ProvID").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection DltConn = DriverManager.getConnection(url, user, password);
            String DltString = "Delete from QueueServiceProviders.MessageUpdates where MsgID = ?";
            PreparedStatement DltPst = DltConn.prepareStatement(DltString);
            DltPst.setString(1, MessageID);
            DltPst.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(Visibility.contains("Customer")){
            try{
                Class.forName(Driver);
                Connection DltConn2 = DriverManager.getConnection(url, user, password);
                String DltString2 = "Delete from ProviderCustomers.ProvNewsForClients where MessageID = ?";
                PreparedStatement DltPst2 = DltConn2.prepareStatement(DltString2);
                DltPst2.setString(1, MessageID);
                DltPst2.executeUpdate();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        try{
            Class.forName(Driver);
            Connection lastNewsConn = DriverManager.getConnection(url, user, password);
            String lastNewsString = "Select * from QueueServiceProviders.MessageUpdates where ProvID = ? order by MsgID desc";
            PreparedStatement lastNewsPst = lastNewsConn.prepareStatement(lastNewsString);
            lastNewsPst.setString(1, ProvID);
            
            ResultSet lastNewsRec = lastNewsPst.executeQuery();
            
            while(lastNewsRec.next()){
                LastMessageID = lastNewsRec.getString("MsgID");
                break;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print(LastMessageID);
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
