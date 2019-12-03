

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GetUpdateSpotInfo extends HttpServlet {

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
        String AppointmentDate = "";
        String AppointmentTime = "";
        
        
        try{
            Class.forName(Driver);
            Connection SpotConn = DriverManager.getConnection(url, user, password);
            String SpotQuery = "Select * from QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement SpotPst = SpotConn.prepareStatement(SpotQuery);
            SpotPst.setString(1, AppointmentID);
            
            ResultSet SpotRec = SpotPst.executeQuery();
            
            while(SpotRec.next()){
                String DateRec = SpotRec.getString("AppointmentDate").trim();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date DateObj = sdf.parse(DateRec);
                sdf = new SimpleDateFormat("MMMMMMMMMMMMMMMMMM dd, yyyy");
                AppointmentDate = sdf.format(DateObj);
                
                String TimeRec = SpotRec.getString("AppointmentTime").trim();
                
                String HH = TimeRec.substring(0,2);
                String Rest = TimeRec.substring(2,5);
                int intHH = Integer.parseInt(HH);
                if(intHH > 12){
                    intHH -= 12;
                    AppointmentTime = intHH + Rest + "pm";
                }else if(intHH == 12){
                    AppointmentTime = TimeRec.substring(0,5) + "pm";
                }
                else if(intHH < 12 && intHH != 0){
                    AppointmentTime = TimeRec.substring(0,5) + "am";
                }else if(intHH == 0){
                    AppointmentTime = "12" + Rest + "am";
                }
            }
                    
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"AppointmentDate\":\""+AppointmentDate+"\",\"AppointmentTime\":\""+AppointmentTime+"\"}");
        
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
