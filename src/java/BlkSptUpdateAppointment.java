
import com.arieslab.queue.queue_model.StatusesClass;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class BlkSptUpdateAppointment extends HttpServlet {

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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String UserIndex = request.getParameter("UserIndex");
        String GetDate = request.getParameter("GetDate");
        String AppointmentID = request.getParameter("AppointmentID");
        String AppointmentDate = request.getParameter("AppointmentDate");
        String AppointmentTime = request.getParameter("ApointmentTime");
        String NewUserName = request.getParameter("User");
        String ProviderID = "";
        String CustomerID = "";
        
        //JOptionPane.showMessageDialog(null, AppointmentTime);
        
        try{
            Class.forName(Driver);
            Connection AppointmentConn = DriverManager.getConnection(url, user, password);
            String AppointmentString = "Select * from QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement AppointmentPst = AppointmentConn.prepareStatement(AppointmentString);
            AppointmentPst.setString(1, AppointmentID);
            
            ResultSet AppointmentRec = AppointmentPst.executeQuery();
            
            while(AppointmentRec.next()){
                
                ProviderID = AppointmentRec.getString("ProviderID");
                CustomerID = AppointmentRec.getString("CustomerID");
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        int selectFlag = 0;
        
        String DayOfWeek = "";
        String DailyStartTime = "";
        String DailyClosingTime = "";
        
        try{
            
            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
            java.util.Date DayOfAppointment = sdf.parse(AppointmentDate);
            DayOfWeek = DayOfAppointment.toString().substring(0,3);
            
        }catch(Exception e){}
        
        try{
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date DayOfAppointment = sdf.parse(AppointmentDate);
            DayOfWeek = DayOfAppointment.toString().substring(0,3);
            
        }catch(Exception e){}
        
                                        String MonDailyStartTime = "";
                                        String MonDailyClosingTime = "";
                                        String TueDailyStartTime = "";
                                        String TueDailyClosingTime = "";
                                        String WedDailyStartTime = "";
                                        String WedDailyClosingTime = "";
                                        String ThursDailyStartTime = "";
                                        String ThursDailyClosingTime = "";
                                        String FriDailyStartTime = "";
                                        String FriDailyClosingTime = "";
                                        String SatDailyStartTime = "";
                                        String SatDailyClosingTime = "";
                                        String SunDailyStartTime = "";
                                        String SunDailyClosingTime = "";
                                        
                                        //getting starting and closing hours for eah day
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection hoursConn = DriverManager.getConnection(url, user, password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setString(1, ProviderID);
                                            ResultSet hourRow = hourPst.executeQuery();
                                            
                                            while(hourRow.next()){
                                                
                                                
                                                MonDailyStartTime = hourRow.getString("MondayStart");
                                                MonDailyClosingTime = hourRow.getString("MondayClose");
                                                
                                                TueDailyStartTime = hourRow.getString("TuesdayStart");
                                                TueDailyClosingTime = hourRow.getString("TuesdayClose");
                                                
                                                WedDailyStartTime = hourRow.getString("WednessdayStart");
                                                WedDailyClosingTime = hourRow.getString("WednessdayClose");
                                               
                                                ThursDailyStartTime = hourRow.getString("ThursdayStart");
                                                ThursDailyClosingTime = hourRow.getString("ThursdayClose");
                                               
                                                FriDailyStartTime = hourRow.getString("FridayStart");
                                                FriDailyClosingTime = hourRow.getString("FridayClose");
                                                
                                                SatDailyStartTime = hourRow.getString("SaturdayStart");
                                                SatDailyClosingTime = hourRow.getString("SaturdayClose");
                                                
                                                SunDailyStartTime = hourRow.getString("SundayStart");
                                                SunDailyClosingTime = hourRow.getString("SundayClose");
                                                
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                        try{
                                                if(DayOfWeek.equalsIgnoreCase("Mon")){
                                                    DailyStartTime = MonDailyStartTime.substring(0,5);
                                                    DailyClosingTime = MonDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Tue")){
                                                    DailyStartTime = TueDailyStartTime.substring(0,5);
                                                    DailyClosingTime = TueDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Wed")){
                                                    
                                                    DailyStartTime = WedDailyStartTime.substring(0,5);
                                                    DailyClosingTime = WedDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Thu")){
                                                    DailyStartTime = ThursDailyStartTime.substring(0,5);
                                                    DailyClosingTime = ThursDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Fri")){
                                                    DailyStartTime = FriDailyStartTime.substring(0,5);
                                                    DailyClosingTime = FriDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sat")){
                                                    DailyStartTime = SatDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SatDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sun")){
                                                    DailyStartTime = SunDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SunDailyClosingTime.substring(0,5);
                                                }
                                        }catch(Exception e){}
                                 
                                 if(DailyStartTime == "")
                                    DailyStartTime = "01:00";
                                if(DailyClosingTime == "")
                                    DailyClosingTime = "23:00";
                                //JOptionPane.showMessageDialog(null, DailyStartTime);
                                //JOptionPane.showMessageDialog(null, DailyClosingTime);
     
    String CompareTime = AppointmentTime;
    if(CompareTime.length() == 4)
        CompareTime = "0" + CompareTime;
    
    if(Integer.parseInt(CompareTime.substring(0,2)) < Integer.parseInt(DailyStartTime.substring(0,2))){
        selectFlag = 2;
        response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Not%20Successful.%20Time%20chosen%20is%20earlier%20than%20your%20opening%20time.\nYou%20open%20at%20" + DailyStartTime);
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Not%20Successful.%20Time%20chosen%20is%20earlier%20than%20your%20opening%20time.\nYou%20open%20at%20" + DailyStartTime);
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&user=Not%20Successful.%20Time%20chosen%20is%20later%20than%20your%20closing%20time.\nYou%20close%20at%20" + DailyClosingTime);
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Not%20Successful.%20Time%20chosen%20is%20later%20than%20your%20closing%20time.\nYou%20close%20at%20" + DailyClosingTime);
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
        }
    }
    
if(selectFlag != 2){
        
        //calculate for the next and last 30 mins_______________________________
            
            String TimeAfter30Mins = "";
            String TimeBefore30Mins = "";
            String TempAppointmentTime = AppointmentTime;
            
        {
            if(TempAppointmentTime.length() == 4)
               TempAppointmentTime = "0" + TempAppointmentTime;
        
            int TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
            int TempMinute = Integer.parseInt(TempAppointmentTime.substring(3,5));
        
            TempMinute += 15;
        
            if(TempMinute >= 60){
            
                TempHour++;
        
                if(TempMinute > 60 && TempMinute != 60)
                    TempMinute -= 60;
        
                else if(TempMinute == 60)
                    TempMinute = 0;
                
                if(TempHour > 23)
                    TempHour = 23;
        
            }
        
            TimeAfter30Mins = TempHour + ":" + TempMinute;
            
            //JOptionPane.showMessageDialog(null, TimeAfter30Mins);
            
        
            int TempHour2 = Integer.parseInt(TempAppointmentTime.substring(0,2));
            int TempMinute2 = Integer.parseInt(TempAppointmentTime.substring(3,5));
        
            TempHour2 -= 1; //turning this into 60 minutes
        
            TempMinute2 += 60;
            
            TempMinute2 -= 15;
        
            while(TempMinute2 >= 60){
                
                TempHour2++;
                
                if(TempMinute2 > 60 && TempMinute2 != 60)
                    TempMinute2 -= 60;
        
                else if(TempMinute2 == 60)
                    TempMinute2 = 0;
                
                if(TempHour2 > 23)
                    TempHour2 = 23;
            }
        
            TimeBefore30Mins = TempHour2 + ":" + TempMinute2;
            //JOptionPane.showMessageDialog(null, TimeBefore30Mins);
        
        }
        
        
        
        StatusesClass.AppointmentStatus = "";
        
        
        try{
            
            Class.forName(Driver);
            Connection selectConn = DriverManager.getConnection(url, user, password);
            String selectString = "Select * from QueueObjects.BookedAppointment where "
                    + "ProviderID =? and AppointmentDate=? and AppointmentTime=?";
            
            PreparedStatement selectPst = selectConn.prepareStatement(selectString);
            selectPst.setString(1, ProviderID);
            selectPst.setString(2, AppointmentDate);
            selectPst.setString(3, AppointmentTime);
            
            ResultSet selectRow = selectPst.executeQuery();
            
            while(selectRow.next()){
                selectFlag = 1;
                StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nThe spot you selected is already taken";
                //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Unavailable%20Appointment%20time:%20" + AppointmentTime + 
                        ",%20" + AppointmentDate + ".\nThe%20spot%20you%20selected%20is%20already%20taken");
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection selectConn = DriverManager.getConnection(url, user, password);
            String selectString = "Select * from QueueObjects.BookedAppointment where "
                    + "CustomerID =? and AppointmentDate=? and AppointmentTime=?";
            
            PreparedStatement selectPst = selectConn.prepareStatement(selectString);
            selectPst.setString(1, CustomerID);
            selectPst.setString(2, AppointmentDate);
            selectPst.setString(3, AppointmentTime);
            
            ResultSet selectRow = selectPst.executeQuery();
            
            while(selectRow.next()){
                selectFlag = 1;
                StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nYou've alreay taken a spot for this same time";
                //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Unavailable%20Appointment%20time:%20" + AppointmentTime + 
                        ",%20" + AppointmentDate + ".\nYou've%20alreay%20taken%20a%20spot%20for%20this%20same%20time");
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        //checking for time range;
        try{
            
            Class.forName(Driver);
            Connection TimeRangeConn = DriverManager.getConnection(url, user, password);
            String TimeRangeString = "Select * from QueueObjects.BookedAppointment where "
                    + "(ProviderID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))"
                    + " or (CustomerID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))";
            
            PreparedStatement TimeRangePst = TimeRangeConn.prepareStatement(TimeRangeString);
            TimeRangePst.setString(1, ProviderID);
            TimeRangePst.setString(2, AppointmentDate);
            TimeRangePst.setString(3, TimeBefore30Mins);
            TimeRangePst.setString(4, TimeAfter30Mins);
            TimeRangePst.setString(5, CustomerID);
            TimeRangePst.setString(6, AppointmentDate);
            TimeRangePst.setString(7, TimeBefore30Mins);
            TimeRangePst.setString(8, TimeAfter30Mins);
            
            ResultSet TimeRangeRow = TimeRangePst.executeQuery();
            while(TimeRangeRow.next()){
                
                selectFlag = 1;
                StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot or \n is less than 15 minutes before or after a spot you've taken.";
                //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Unavailable%20Appointment%20time:%20" + AppointmentTime + 
                        ",%20" + AppointmentDate + ".\nThe%20spot%20you've%20chosen%20overlaps%20with%20another%20spot%20or%20\n%20is%20less%20than%2015%20minutes%20before%20or%20after%20a%20spot%20you've%20taken.");
                break;
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
       
    if(selectFlag == 0){
        
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String updateQuery = "Update QueueObjects.BookedAppointment set AppointmentDate= ?,  AppointmentTime = ? where AppointmentID = ?";
            PreparedStatement updatePst = conn.prepareStatement(updateQuery);
            updatePst.setString(1, AppointmentDate);
            updatePst.setString(2, AppointmentTime);
            updatePst.setString(3, AppointmentID);
            
            int updateSuccess = updatePst.executeUpdate();
            
            response.sendRedirect("BlockFutureSpots.jsp?UserIndex="+UserIndex+"&GetDate="+GetDate+"&User="+NewUserName+"&result=Spot%20Changed%20Successfully");
            //JOptionPane.showMessageDialog(null, "Spot Changed Successfully");
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
    }
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
