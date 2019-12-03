
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

public class DeleteNewService extends HttpServlet {

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
        
        String ServiceID = request.getParameter("ServiceID");
        String UserIndex = request.getParameter("UserIndex");
        String NewUserName = request.getParameter("User");
        
        try{
            Class.forName(Driver);
            Connection RMVSVCConn = DriverManager.getConnection(url, user, password);
            String RMVSVCString = "Delete from QueueServiceProviders.ServicesAndPrices where ServiceID = ?";
            PreparedStatement RMVSVCPst = RMVSVCConn.prepareStatement(RMVSVCString);
            RMVSVCPst.setString(1, ServiceID);
            
            
            RMVSVCPst.executeUpdate();
            
            response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Service Deleted Successfully");
            //JOptionPane.showMessageDialog(null, "Service Deleted Successfully!");
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
