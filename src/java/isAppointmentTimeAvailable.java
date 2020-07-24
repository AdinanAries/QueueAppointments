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
public class isAppointmentTimeAvailable extends HttpServlet {
    
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Response = "";
        
        
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        String AppointmentDate = request.getParameter("formsDateValue");
        String AppointmentTime = request.getParameter("formsTimeValue");
        int selectFlag = 0;
        
       
        SimpleDateFormat DateForCompareSdf = null;
        
        boolean isTodayClosed = false;
        java.util.Date DateForClosedCompare = null;
        
        try{
            DateForCompareSdf = new SimpleDateFormat("MM/dd/yyyy");
            DateForClosedCompare = DateForCompareSdf.parse(AppointmentDate);
                                        
            }catch(Exception e){}
        
        try{
            DateForCompareSdf = new SimpleDateFormat("yyyy-MM-dd");
            DateForClosedCompare = DateForCompareSdf.parse(AppointmentDate);
        
        }catch(Exception e){}
                                        
             //Date DateForClosedCompare = new Date();
            SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
            String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare);
                                        
        try{
                                            
            Class.forName(Driver);
            Connection CloseddConn = DriverManager.getConnection(url, user, password);
            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
            CloseddPst.setString(1, ProviderID);
                                            
            ResultSet ClosedRec = CloseddPst.executeQuery();
                                            
            while(ClosedRec.next()){
                                               
                if(StringDateForCompare.equals(ClosedRec.getString("DateToClose").trim())){
                    isTodayClosed = true;
                    //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
                    //JOptionPane.showMessageDialog(null, "Provider is closed on chosen date");
                    response.getWriter().print("Provider is closed on chosen date");
                }
                                                
            }
                                            
            }catch(Exception e){
                e.printStackTrace();
            }
        
        if(isTodayClosed == false){
        
        
        StatusesClass.AppointmentStatus = "";
        
        
//getting the day for chosen date------------------------------------------------------------------------------------------
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
        //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
        response.getWriter().print("Not Successful. Time chosen is earlier than providers opening time.\nProvider opens at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
            response.getWriter().print("Not Successful. Time chosen is earlier than providers opening time.\nProvider opens at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
        response.getWriter().print("Not Successful. Time chosen is later than providers closing time.\nProvider closes at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
            response.getWriter().print("Not Successful. Time chosen is later than providers closing time.\nProvider closes at " + DailyClosingTime);
        }
    }
    
    //calculate for the next and last 30 mins
            String TimeAfter30Mins = "";
            String TimeBefore30Mins = "";
            String TempAppointmentTime = AppointmentTime;
            
        {
            if(TempAppointmentTime.length() == 4)
               TempAppointmentTime = "0" + TempAppointmentTime;
        
            int TempHour = Integer.parseInt(TempAppointmentTime.substring(0,2));
            int TempMinute = Integer.parseInt(TempAppointmentTime.substring(3,5));
        
            TempMinute += (IntervalsValue - 1);
        
            while(TempMinute >= 60){
            
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
    
//----------------------------------------------------------------------------------------------------------------------
        if(selectFlag != 2){
        
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
                StatusesClass.AppointmentStatus = "Unavailable spot: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nYou've alreay taken a spot for this same time";
                //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                response.getWriter().print("Unavailable spot: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nYou've alreay taken a spot for this same time");
                //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
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
                    StatusesClass.AppointmentStatus = "Unavailable spot: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you selected is already taken";
                    //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                    response.getWriter().print("Unavailable spot: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you selected is already taken");
                }
                //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
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
                if(!isYourSpot && !isSpotTaken){
                    StatusesClass.AppointmentStatus = "Unavailable spot: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot.";
                    //JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                    response.getWriter().print("Unavailable spot: " + AppointmentTime + 
                            ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot.");
                }
                //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
                break;
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(selectFlag == 0){
            
                Response = "Success";
             
        }
        }
    }
        response.getWriter().print(Response);
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
