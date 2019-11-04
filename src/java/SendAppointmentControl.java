

import com.arieslab.queue.queue_model.ResendAppointmentData;
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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

@WebServlet(urlPatterns = {"/SendAppointmentControl"})
public class SendAppointmentControl extends HttpServlet {
    
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
        
        String Response = "Fail";
        
        String UserIndex = request.getParameter("UserIndex");
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        String OrderedServices = request.getParameter("formsOrderedServices");
        String AppointmentDate = request.getParameter("formsDateValue");
        String AppointmentTime = request.getParameter("formsTimeValue");
        String ServicesCost = request.getParameter("TotalPrice");
        String PaymentMethod = request.getParameter("payment");
        String DebitCreditCardNumber = "0";
        int selectFlag = 0;
        
        //putting neccessery data into
        ResendAppointmentData.CustomerID = CustomerID;
        ResendAppointmentData.ProviderID = ProviderID;
        ResendAppointmentData.SelectedServices = OrderedServices;
        ResendAppointmentData.AppointmentDate = AppointmentDate;
        ResendAppointmentData.AppointmentTime = AppointmentTime;
        ResendAppointmentData.PaymentMethod = PaymentMethod;
        ResendAppointmentData.ServicesCost = ServicesCost;
        ResendAppointmentData.CreditCardNumber = DebitCreditCardNumber;
        
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
                    JOptionPane.showMessageDialog(null, "Provider is closed on chosen date");
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
        JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
            JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
        JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
            JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
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
            
            TempMinute2 -= (IntervalsValue + 1);
            
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
                JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
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
                    JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
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
                    JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                }
                //response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+UserIndex);
                break;
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(selectFlag == 0){
            try{

                Class.forName(Driver);
                Connection appointmentConn = DriverManager.getConnection(url, user, password);
                String appointmentString = "insert into QueueObjects.BookedAppointment values"
                        + " (?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement appointmentPst = appointmentConn.prepareStatement(appointmentString);
                appointmentPst.setString(1, CustomerID);
                appointmentPst.setString(2, ProviderID);
                appointmentPst.setString(3, OrderedServices);
                appointmentPst.setString(4, AppointmentDate);
                appointmentPst.setString(5, AppointmentTime);
                appointmentPst.setString(6, ServicesCost);
                appointmentPst.setString(7, PaymentMethod);
                appointmentPst.setString(8, DebitCreditCardNumber);

                appointmentPst.executeUpdate();

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
                    notiPst.setString(4, AppointmentTime + " of " + AppointmentDate + " has been taken by " + CustName + " - " + CustTel);
                    notiPst.setString(5, date);
                    notiPst.setString(6, time);
                    notiPst.executeUpdate();
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
                
                
                JOptionPane.showMessageDialog(null, "You've been enqueued successfully!");
                Response = "Success";
                
                //request.getRequestDispatcher("ProviderCustomerPage.jsp?UserIndex="+UserIndex).forward(request,response);
                //response.sendRedirect(("ProviderCustomerPage.jsp?UserIndex="+UserIndex));

            }catch(Exception e){
                e.printStackTrace();
            }
        }
        }
    }
        response.getWriter().print(Response);
        
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
