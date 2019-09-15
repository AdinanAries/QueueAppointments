
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


public class DeleteClientController extends HttpServlet {

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
        
        String clientID = request.getParameter("EachClientID");
        String providerID = request.getParameter("ProviderID");
        
        
        try{
            Class.forName(Driver);
            Connection DltClientConn = DriverManager.getConnection(url, user, password);
            String DltClientString = "Delete from QueueServiceProviders.ClientsList where ProvID = ? and CustomerID = ?";
            PreparedStatement DltClientPst = DltClientConn.prepareStatement(DltClientString);
            
            DltClientPst.setString(1, providerID);
            DltClientPst.setString(2, clientID);
            
            
            DltClientPst.executeUpdate();
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            JOptionPane.showMessageDialog(null, "Client Deleted Successfully!");
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
