
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


public class SetProviderHoursController extends HttpServlet {

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
        
        String SundayStart = request.getParameter("SundayStart");
        if(SundayStart == null){
            SundayStart = "12:00 am";
        }
        if(SundayStart.length() == 7){
            SundayStart = "0" + SundayStart;
        }
        
        String SundayClose = request.getParameter("SundayClose");
        if(SundayClose == null)
            SundayClose = "12:00 am";
        if(SundayClose.length() == 7)
            SundayClose = "0" + SundayClose;
        
        String MondayStart = request.getParameter("MondayStart");
        if(MondayStart == null)
            MondayStart = "12:00 am";
        if(MondayStart.length() == 7)
            MondayStart = "0" + MondayStart;
        
        String MondayClose = request.getParameter("MondayClose");
        if(MondayClose == null)
            MondayClose = "12:00 am";
        if(MondayClose.length() == 7)
            MondayClose = "0" + MondayClose;
        
        String TuesdayStart = request.getParameter("TuesdayStart");
        if(TuesdayStart == null)
            TuesdayStart = "12:00 am";
        if(TuesdayStart.length() == 7)
            TuesdayStart = "0" + TuesdayStart;
        
        String TuesdayClose = request.getParameter("TuesdayClose");
        if(TuesdayClose == null)
            TuesdayClose = "12:00 am";
        if(TuesdayClose.length() == 7)
            TuesdayClose = "0" + TuesdayClose;
        
        String WednesdayStart = request.getParameter("WednesdayStart");
        if(WednesdayStart == null)
            WednesdayStart = "12:00 am";
        if(WednesdayStart.length() == 7)
            WednesdayStart = "0" + WednesdayStart;
        
        String WednesdayClose = request.getParameter("WednesdayClose");
        if(WednesdayClose == null)
            WednesdayClose = "12:00 am";
        if(WednesdayClose.length() == 7)
            WednesdayClose = "0" + WednesdayClose;
        
        String ThursdayStart = request.getParameter("ThursdayStart");
        if(ThursdayStart == null)
            ThursdayStart = "12:00 am";
        if(ThursdayStart.length() == 7)
            ThursdayStart = "0" + ThursdayStart;
        
        String ThursdayClose = request.getParameter("ThursdayClose");
        if(ThursdayClose == null)
            ThursdayClose = "12:00 am";
        if(ThursdayClose.length() == 7)
            ThursdayClose = "0" + ThursdayClose;
        
        String FridayStart = request.getParameter("FridayStart");
        if(FridayStart == null)
            FridayStart = "12:00 am";
        if(FridayStart.length() == 7)
            FridayStart = "0" + FridayStart;
        
        String FridayClose = request.getParameter("FridayClose");
        if(FridayClose == null)
            FridayClose = "12:00 am";
        if(FridayClose.length() == 7)
            FridayClose = "0" + FridayClose;
        
        String SaturdayStart = request.getParameter("SaturdayStart");
        if(SaturdayStart == null)
            SaturdayStart = "12:00 am";
        if(SaturdayStart.length() == 7)
            SaturdayStart = "0" + SaturdayStart;
        
        String SaturdayClose = request.getParameter("SaturdayClose");
        if(SaturdayClose == null)
            SaturdayClose = "12:00 am";
        if(SaturdayClose.length() == 7)
            SaturdayClose = "0" + SaturdayClose;
        
        //formatting input values so database can recieve it
        if(SundayStart.substring(6,8).equals("AM") || SundayStart.substring(6,8).equals("am")){
            if(SundayStart.equals("12:00 am") || SundayStart.equals("12:00 AM"))
                SundayStart = "00:00";
            else
                SundayStart = SundayStart.substring(0,5);
        }
        
        else if(SundayStart.substring(6,8).equals("PM") || SundayStart.substring(6,8).equals("pm")){
            int SundayHour = Integer.parseInt(SundayStart.substring(0,2));
            SundayHour += 12;
            if(SundayHour == 24)
                SundayHour = 12;
            
            SundayStart = SundayHour + SundayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, SundayStart);
        
        if(SundayClose.substring(6,8).equals("AM") || SundayClose.substring(6,8).equals("am")){
            if(SundayClose.equals("12:00 am") || SundayClose.equals("12:00 AM"))
                SundayClose = "00:00";
            else
                SundayClose = SundayClose.substring(0,5);
        }
        
        else if(SundayClose.substring(6,8).equals("PM") || SundayClose.substring(6,8).equals("pm")){
            int SundayHour = Integer.parseInt(SundayClose.substring(0,2));
            SundayHour += 12;
            if(SundayHour == 24)
                SundayHour = 12;
            
            SundayClose = SundayHour + SundayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, SundayClose);
        
        if(MondayStart.substring(6,8).equals("AM") || MondayStart.substring(6,8).equals("am")){
            if(MondayStart.equals("12:00 am") || MondayStart.equals("12:00 AM"))
                MondayStart = "00:00";
            else
                MondayStart = MondayStart.substring(0,5);
        }
        
        else if(MondayStart.substring(6,8).equals("PM") || MondayStart.substring(6,8).equals("pm")){
            int MondayHour = Integer.parseInt(MondayStart.substring(0,2));
            MondayHour += 12;
            if(MondayHour == 24)
                MondayHour = 12;
            
            MondayStart = MondayHour + MondayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, MondayStart);
        
        if(MondayClose.substring(6,8).equals("AM") || MondayClose.substring(6,8).equals("am")){
            if(MondayClose.equals("12:00 am") || MondayClose.equals("12:00 AM"))
                MondayClose = "00:00";
            else
                MondayClose = MondayClose.substring(0,5);
        }
        
        else if(MondayClose.substring(6,8).equals("PM") || MondayClose.substring(6,8).equals("pm")){
            int MondayHour = Integer.parseInt(MondayClose.substring(0,2));
            MondayHour += 12;
            if(MondayHour == 24)
                MondayHour = 12;
            
            MondayClose = MondayHour + MondayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, MondayClose);
        
        if(TuesdayStart.substring(6,8).equals("AM") || TuesdayStart.substring(6,8).equals("am")){
            if(TuesdayStart.equals("12:00 am") || TuesdayStart.equals("12:00 AM"))
                TuesdayStart = "00:00";
            else
                TuesdayStart = TuesdayStart.substring(0,5);
        }
        
        else if(TuesdayStart.substring(6,8).equals("PM") || TuesdayStart.substring(6,8).equals("pm")){
            int TuesdayHour = Integer.parseInt(TuesdayStart.substring(0,2));
            TuesdayHour += 12;
            if(TuesdayHour == 24)
                TuesdayHour = 12;
            
            TuesdayStart = TuesdayHour + TuesdayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, TuesdayStart);
        
        if(TuesdayClose.substring(6,8).equals("AM") || TuesdayClose.substring(6,8).equals("am")){
            if(TuesdayClose.equals("12:00 am") || TuesdayClose.equals("12:00 AM"))
                TuesdayClose = "00:00";
            else
                TuesdayClose = TuesdayClose.substring(0,5);
        }
        
        else if(TuesdayClose.substring(6,8).equals("PM") || TuesdayClose.substring(6,8).equals("pm")){
            int TuesdayHour = Integer.parseInt(TuesdayClose.substring(0,2));
            TuesdayHour += 12;
            if(TuesdayHour == 24)
                TuesdayHour = 12;
            
            TuesdayClose = TuesdayHour + TuesdayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, TuesdayClose);
        
        if(WednesdayStart.substring(6,8).equals("AM") || WednesdayStart.substring(6,8).equals("am")){
            if(WednesdayStart.equals("12:00 am") || WednesdayStart.equals("12:00 AM"))
                WednesdayStart = "00:00";
            else
                WednesdayStart = WednesdayStart.substring(0,5);
        }
        
        else if(WednesdayStart.substring(6,8).equals("PM") || WednesdayStart.substring(6,8).equals("pm")){
            int WednesdayHour = Integer.parseInt(WednesdayStart.substring(0,2));
            WednesdayHour += 12;
            if(WednesdayHour == 24)
                WednesdayHour = 12;
            
            WednesdayStart = WednesdayHour + WednesdayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, WednesdayStart);
        
        if(WednesdayClose.substring(6,8).equals("AM") || WednesdayClose.substring(6,8).equals("am")){
            if(WednesdayClose.equals("12:00 am") || WednesdayClose.equals("12:00 AM"))
                WednesdayClose = "00:00";
            else
                WednesdayClose = WednesdayClose.substring(0,5);
        }
        
        else if(WednesdayClose.substring(6,8).equals("PM") || WednesdayClose.substring(6,8).equals("pm")){
            int WednesdayHour = Integer.parseInt(WednesdayClose.substring(0,2));
            WednesdayHour += 12;
            if(WednesdayHour == 24)
                WednesdayHour = 12;
            
            WednesdayClose = WednesdayHour + WednesdayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, WednesdayClose);
        
        if(ThursdayStart.substring(6,8).equals("AM") || ThursdayStart.substring(6,8).equals("am")){
            if(ThursdayStart.equals("12:00 am") || ThursdayStart.equals("12:00 AM"))
                ThursdayStart = "00:00";
            else
                ThursdayStart = ThursdayStart.substring(0,5);
        }
        
        else if(ThursdayStart.substring(6,8).equals("PM") || ThursdayStart.substring(6,8).equals("pm")){
            int ThursdayHour = Integer.parseInt(ThursdayStart.substring(0,2));
            ThursdayHour += 12;
            if(ThursdayHour == 24)
                ThursdayHour = 12;
            
            ThursdayStart = ThursdayHour + ThursdayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, ThursdayStart);
        
        if(ThursdayClose.substring(6,8).equals("AM") || ThursdayClose.substring(6,8).equals("am")){
            if(ThursdayClose.equals("12:00 am") || ThursdayClose.equals("12:00 AM"))
                ThursdayClose = "00:00";
            else
                ThursdayClose = ThursdayClose.substring(0,5);
        }
        
        else if(ThursdayClose.substring(6,8).equals("PM") || ThursdayClose.substring(6,8).equals("pm")){
            int ThursdayHour = Integer.parseInt(ThursdayClose.substring(0,2));
            ThursdayHour += 12;
            if(ThursdayHour == 24)
                ThursdayHour = 12;
            
            ThursdayClose = ThursdayHour + ThursdayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, ThursdayClose);
        
        if(FridayStart.substring(6,8).equals("AM") || FridayStart.substring(6,8).equals("am")){
            if(FridayStart.equals("12:00 am") || FridayStart.equals("12:00 AM"))
                FridayStart = "00:00";
            else
                FridayStart = FridayStart.substring(0,5);
        }
        
        else if(FridayStart.substring(6,8).equals("PM") || FridayStart.substring(6,8).equals("pm")){
            int FridayHour = Integer.parseInt(FridayStart.substring(0,2));
            FridayHour += 12;
            if(FridayHour == 24)
                FridayHour = 12;
            
            FridayStart = FridayHour + FridayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, FridayStart);
        
        if(FridayClose.substring(6,8).equals("AM") || FridayClose.substring(6,8).equals("am")){
            if(FridayClose.equals("12:00 am") || FridayClose.equals("12:00 AM"))
                FridayClose = "00:00";
            else
                FridayClose = FridayClose.substring(0,5);
        }
        
        else if(FridayClose.substring(6,8).equals("PM") || FridayClose.substring(6,8).equals("pm")){
            int FridayHour = Integer.parseInt(FridayClose.substring(0,2));
            FridayHour += 12;
            if(FridayHour == 24)
                FridayHour = 12;
            
            FridayClose = FridayHour + FridayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, FridayClose);
        
        if(SaturdayStart.substring(6,8).equals("AM") || SaturdayStart.substring(6,8).equals("am")){
            if(SaturdayStart.equals("12:00 am") || SaturdayStart.equals("12:00 AM"))
                SaturdayStart = "00:00";
            else
                SaturdayStart = SaturdayStart.substring(0,5);
        }
        
        else if(SaturdayStart.substring(6,8).equals("PM") || SaturdayStart.substring(6,8).equals("pm")){
            int SaturdayHour = Integer.parseInt(SaturdayStart.substring(0,2));
            SaturdayHour += 12;
            if(SaturdayHour == 24)
                SaturdayHour = 12;
            
            SaturdayStart = SaturdayHour + SaturdayStart.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, SaturdayStart);
        
        if(SaturdayClose.substring(6,8).equals("AM") || SaturdayClose.substring(6,8).equals("am")){
            if(SaturdayClose.equals("12:00 am") || SaturdayClose.equals("12:00 AM"))
                SaturdayClose = "00:00";
            else
                SaturdayClose = SaturdayClose.substring(0,5);
        }
        
        else if(SaturdayClose.substring(6,8).equals("PM") || SaturdayClose.substring(6,8).equals("pm")){
            int SaturdayHour = Integer.parseInt(SaturdayClose.substring(0,2));
            SaturdayHour += 12;
            if(SaturdayHour == 24)
                SaturdayHour = 12;
            
            SaturdayClose = SaturdayHour + SaturdayClose.substring(2,5);
        }
        //JOptionPane.showMessageDialog(null, SaturdayClose);
        
        String SundayChck = request.getParameter("SundayChck");
        String MondayChck = request.getParameter("MondayChck");
        String TuesdayChck = request.getParameter("TuesdayChck");
        String WednesdayChck = request.getParameter("WednesdayChck");
        String ThursdayChck = request.getParameter("ThursdayChck");
        String FridayChck = request.getParameter("FridayChck");
        String SaturdayChck = request.getParameter("SaturdayChck");
        
        
        String ProviderID = request.getParameter("ProviderID");
        String UserIndex = request.getParameter("UserIndex");
        
        try{
            Class.forName(Driver);
            Connection HoursConn = DriverManager.getConnection(url, user, password);
            String HoursString = "Update QueueServiceProviders.ServiceHours set MondayStart = ?, MondayClose = ?, TuesdayStart = ?,"
                    + " TuesdayClose = ?, WednessdayStart = ?, WednessdayClose = ?, ThursdayStart = ?, ThursdayClose = ?, FridayStart = ?,"
                    + " FridayClose = ?, SaturdayStart = ?, SaturdayClose = ?,  SundayStart = ?, SundayClose = ? where ProviderID = ?";
            
            PreparedStatement HoursPst = HoursConn.prepareStatement(HoursString);
            HoursPst.setString(1,MondayStart);
            HoursPst.setString(2, MondayClose);
            HoursPst.setString(3, TuesdayStart);
            HoursPst.setString(4, TuesdayClose);
            HoursPst.setString(5, WednesdayStart);
            HoursPst.setString(6, WednesdayClose);
            HoursPst.setString(7, ThursdayStart);
            HoursPst.setString(8, ThursdayClose);
            HoursPst.setString(9, FridayStart);
            HoursPst.setString(10, FridayClose);
            HoursPst.setString(11, SaturdayStart);
            HoursPst.setString(12, SaturdayClose);
            HoursPst.setString(13, SundayStart);
            HoursPst.setString(14, SundayClose);
            HoursPst.setString(15, ProviderID);
            
            HoursPst.executeUpdate();
            
            response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex);
            JOptionPane.showMessageDialog(null, "Hours Updated Successfuly!");
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
