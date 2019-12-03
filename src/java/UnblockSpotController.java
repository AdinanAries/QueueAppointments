

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

public class UnblockSpotController extends HttpServlet {
    
    String Driver = "";
    String URL = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
                
        URL = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String BlockedAppointmentID = request.getParameter("BlockedAppointmentID");
        String UserIndex = request.getParameter("UserIndex");
        String NewUserName = request.getParameter("User");
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String Delete = "Delete From QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement pst = conn.prepareStatement(Delete);
            pst.setString(1, BlockedAppointmentID);
            pst.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Spot Unblocked");
        //JOptionPane.showMessageDialog(null, "Spot Unblocked");
      
       
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
