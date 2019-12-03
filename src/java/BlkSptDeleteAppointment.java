
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

public class BlkSptDeleteAppointment extends HttpServlet {

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
    
        String AppointmentID = request.getParameter("AppointmentID");
        String UserIndex = request.getParameter("UserIndex");
        String GetDate = request.getParameter("GetDate");
        String NewUserName = request.getParameter("User");
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String Delete = "Delete From QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement pst = conn.prepareStatement(Delete);
            pst.setString(1, AppointmentID);
            pst.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Appointment%20deleted%20successfully");
        //JOptionPane.showMessageDialog(null, "Appointment deleted successfully");
        
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
