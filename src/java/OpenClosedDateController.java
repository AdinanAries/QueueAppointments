

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


public class OpenClosedDateController extends HttpServlet {

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
        
        String ClosedID = request.getParameter("ClosedID");
        
        try{
            Class.forName(Driver);
            Connection OpenConn = DriverManager.getConnection(url, user, password);
            String OpenString = "Delete from QueueServiceProviders.ClosedDays where closedID = ?";
            PreparedStatement OpenPst = OpenConn.prepareStatement(OpenString);
            OpenPst.setString(1, ClosedID);
            
            OpenPst.executeUpdate();
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            //JOptionPane.showMessageDialog(null, "Closed Day Openned");
            response.getWriter().print("Closed Day Openned");
            
            
        }catch(Exception e){}
        
       
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
