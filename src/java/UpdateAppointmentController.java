/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.StatusesClass;
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

/**
 *
 * @author aries
 */
public class UpdateAppointmentController extends HttpServlet {
    
    String Driver = "";
    String url = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
                
        url= config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        String AppointmentID = request.getParameter("AppointmentID");
        String AppointmentDate = request.getParameter("AppointmentDate");
        String AppointmentTime = request.getParameter("ApointmentTime");
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

        if(DailyStartTime.length() < 5)
            DailyStartTime = "0" + DailyStartTime;
        if(DailyClosingTime.length() < 5)
            DailyClosingTime = "0" + DailyClosingTime;
        
        int startHour = Integer.parseInt(DailyStartTime.substring(0,2));
        int startMinute = Integer.parseInt(DailyStartTime.substring(3,5));
        int closingHour = Integer.parseInt(DailyClosingTime.substring(0,2));
        int closingMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
        int IntervalsValue = 30;
        String CurrentTime = new Date().toString().substring(11,16);
        
        try{

            Class.forName(Driver);
            Connection intervalsConn = DriverManager.getConnection(url, user, password);
            String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
            PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

            intervalsPst.setString(1, ProviderID);

            ResultSet intervalsRec = intervalsPst.executeQuery();

            while(intervalsRec.next()){
                IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
            }
        }catch(Exception e){
                e.printStackTrace();
        }
        //JOptionPane.showMessageDialog(null, DailyStartTime);
        //JOptionPane.showMessageDialog(null, DailyClosingTime);
     
    String CompareTime = AppointmentTime;
    if(CompareTime.length() == 4)
        CompareTime = "0" + CompareTime;
    
    if(Integer.parseInt(CompareTime.substring(0,2)) < Integer.parseInt(DailyStartTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ProviderCustomerPage.jsp");
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
        response.getWriter().print("Not Successful. Time chosen is earlier than providers opening time.\nProvider opens at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ProviderCustomerPage.jsp");
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
            response.getWriter().print("Not Successful. Time chosen is earlier than providers opening time.\nProvider opens at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ProviderCustomerPage.jsp");
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
        response.getWriter().print("Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ProviderCustomerPage.jsp");
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
            response.getWriter().print("Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
        }
    }
    
if(selectFlag != 2){
        
        //calculate for the next and last 30 mins
            String TimeAfter30Mins = "";
            String TimeBefore30Mins = "";
            String TempAppointmentTime = AppointmentTime;
            
        {
            if(TempAppointmentTime.length() == 4)
               TempAppointmentTime = "0" + TempAppointmentTime;
        
            int TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
            int TempMinute = Integer.parseInt(TempAppointmentTime.substring(3,5));
        
            //adding one minute to the intervals time makes it go one min ahead of the next appointment time
            TempMinute += (IntervalsValue - 1);
        
            if(TempMinute >= 60){
            
                TempHour++;
        
                if(TempMinute > 60 && TempMinute != 60)
                    TempMinute -= 60;
        
                else if(TempMinute == 60)
                    TempMinute = 0;
                
                if(TempHour > 23)
                    TempHour = 23;
        
            }
        
            String StringMinute = Integer.toString(TempMinute);
            if(Integer.toString(TempMinute).length() < 2)
                StringMinute = "0" + StringMinute;
            
            TimeAfter30Mins = TempHour + ":" + StringMinute;
            
            //JOptionPane.showMessageDialog(null, TimeAfter30Mins);
            
        
            int TempHour2 = Integer.parseInt(TempAppointmentTime.substring(0,2));
            int TempMinute2 = Integer.parseInt(TempAppointmentTime.substring(3,5));
        
            TempHour2 -= 5;
                           
            TempMinute2 += 300; 
              
            //removing one minute from the intervals value makes it reach up to one min less than the most recent previous spot
            TempMinute2 -= (IntervalsValue - 1);
             
            while(TempMinute2 >= 60){
                                
                /*Avoid incrementing the hour hand as it will skip the start of the day
                if(DailyStartTime != ""){
                                                
                    if(TempHour2 == startHour){
                         break;
                    }
                                                    
                }else if(TempHour2 == 1){
                    break;
                }*/

                TempHour2++;

                if(TempMinute2 > 60 && TempMinute2 != 60)
                    TempMinute2 -= 60;

                else if(TempMinute2 == 60)
                    TempMinute2 = 0;

                if(TempHour2 > 23)
                    TempHour2 = 23;
            }
            
            if(DailyStartTime != ""){
                                            
                if(TempHour2 < startHour){
                    TempHour2 = startHour;
                    TempMinute2 = startMinute + 1;
                }
            }else if(TempHour2 < 1){
                TempHour2 = 1;
                TempMinute2 = 1;
            }
                            
            String SMinute2 = Integer.toString(TempMinute2);
                            
            if(Integer.toString(TempMinute2).length() < 2)
                SMinute2 = "0" + TempMinute2;

            TimeBefore30Mins = TempHour2 + ":" + SMinute2;
                            
        }
        //JOptionPane.showMessageDialog(null, TimeBefore30Mins);
    
        StatusesClass.AppointmentStatus = "";
        
        boolean isYourSpot = false;
        boolean isSpotTaken = false;
        
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
                isYourSpot = true;
                StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nYou've alreay taken a spot for this same time";
                //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                response.getWriter().print("Unavailable Appointment time: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nYou've alreay taken a spot for this same time");
                //response.sendRedirect("ProviderCustomerPage.jsp");
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
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
                isSpotTaken = true;
                if(!isYourSpot){
                    StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you selected is already taken";
                    //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                    response.getWriter().print("Unavailable Appointment time: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you selected is already taken");
                }
                //response.sendRedirect("ProviderCustomerPage.jsp");
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
                if(!isYourSpot && isSpotTaken){
                    StatusesClass.AppointmentStatus = "Unavailable Appointment time: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot or \n is less than 15 minutes before or after a spot you've taken.";
                    //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                    response.getWriter().print("Unavailable Appointment time: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot or \n is less than 15 minutes before or after a spot you've taken.");
                }
                //response.sendRedirect("ProviderCustomerPage.jsp");
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
            
            //JOptionPane.showMessageDialog(null,AppointmentDate);
            
            int updateSuccess = updatePst.executeUpdate();
            
            //-------------------------------------------------------------------------------------------
                Date NotiDate = new Date();
                String NotiSDate = NotiDate.toString();
                SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
                String date = NotiDformat.format(NotiDate);
                String time = NotiSDate.substring(11,16);
                
                String CustName = "", CustTel = "";
                
                try{
                    Class.forName(Driver);
                    Connection CustConn = DriverManager.getConnection(url, user, password);
                    String CustQuery = "select First_Name, Phone_Number from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                    PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                    CustPst.setString(1, CustomerID);
                    
                    ResultSet CustRec = CustPst.executeQuery();
                    
                    while(CustRec.next()){
                        CustName = CustRec.getString("First_Name").trim();
                        CustTel = CustRec.getString("Phone_Number").trim();
                    }
                    
                
                }catch(Exception e){
                    e.printStackTrace();
                }
                
                //nofitying Provider
                try{
                    Class.forName(Driver);
                    Connection notiConn = DriverManager.getConnection(url, user, password);
                    String notiString = "insert into QueueServiceProviders.Notifications (Noti_Type, ProvID, If_From_Cust, What, Noti_Date, Not_Time)"
                            + "values (?,?,?,?,?,?)";
                    PreparedStatement notiPst = notiConn.prepareStatement(notiString);
                    notiPst.setString(1, "Appointment");
                    notiPst.setString(2, ProviderID);
                    notiPst.setString(3, CustomerID);
                    notiPst.setString(4,  CustName + " - " + CustTel + " - moved his spot to " + AppointmentTime + " on " + AppointmentDate);
                    notiPst.setString(5, date);
                    notiPst.setString(6, time);
                    notiPst.executeUpdate();
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
                
            //response.sendRedirect("ProviderCustomerPage.jsp");
            //JOptionPane.showMessageDialog(null, "Spot moved successfully!");
            response.getWriter().print("Spot moved successfully");
            
            
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
