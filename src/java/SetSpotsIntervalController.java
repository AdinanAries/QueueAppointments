

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


public class SetSpotsIntervalController extends HttpServlet {

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
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        
        String SpotIntervals = request.getParameter("SpotsIntervals");
        String ProviderID = request.getParameter("ProviderID");
        String NewUserName = request.getParameter("User");
        
        try{
            Class.forName(Driver);
            Connection intervalConn = DriverManager.getConnection(url, user, password);
            String intervalString = "Update QueueServiceProviders.Settings set CurrentValue = ? where If_providerID = ? and Settings like 'SpotsIntervals%'";
            PreparedStatement intervalPst = intervalConn.prepareStatement(intervalString);
            intervalPst.setString(1, SpotIntervals);
            intervalPst.setString(2, ProviderID);
            
            intervalPst.executeUpdate();
            
            response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
            JOptionPane.showMessageDialog(null, "New spot intervals set");
            
            
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
