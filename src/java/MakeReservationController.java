
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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class MakeReservationController extends HttpServlet {
    
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
           
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        String OrderedServices = request.getParameter("formsOrderedServices");
        String AppointmentDate = request.getParameter("formsDateValue");
        
        String TimeValue = request.getParameter("formsTimeValue");
        
        if(TimeValue.length() == 7)
            TimeValue = "0" + TimeValue;
        
        String ActualTime = TimeValue.substring(0,5);
        String AmPm = TimeValue.substring(6,8);
        //JOptionPane.showMessageDialog(null, AmPm);
        
        
        int Hour = Integer.parseInt(ActualTime.substring(0,2));
        String Minute = ActualTime.substring(2,5);
        
        if(AmPm.equals("PM")){
            
            Hour += 12;
            if(Hour == 24)
                Hour = 12;
            
        }
        else if(AmPm.equals("AM")){
            
            if(Hour == 12)
                Hour = 0;
            
        }
        
        String AppointmentTime = Hour + Minute;
        
        if(AppointmentTime.length() == 4)
            AppointmentTime = "0" + AppointmentTime;
        
        //JOptionPane.showMessageDialog(null, AppointmentTime);
        
        //String ServicesCost = OrderedServices.substring(1,5);
        String ServicesCost = "00.00";
        String PaymentMethod = "Reservation";
        String DebitCreditCardNumber = "0";
        int selectFlag = 0;
        
        /*putting neccessery data into
        ResendAppointmentData.CustomerID = CustomerID;
        ResendAppointmentData.ProviderID = ProviderID;
        ResendAppointmentData.SelectedServices = OrderedServices;
        ResendAppointmentData.AppointmentDate = AppointmentDate;
        ResendAppointmentData.AppointmentTime = AppointmentTime;
        ResendAppointmentData.PaymentMethod = PaymentMethod;
        ResendAppointmentData.ServicesCost = ServicesCost;
        ResendAppointmentData.CreditCardNumber = DebitCreditCardNumber;*/
        
        
        //calculate for the next and last 30 mins
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
        
        
        
        //StatusesClass.AppointmentStatus = "";
        
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
                                //JOptionPane.showMessageDialog(null, DailyStartTime);
                                //JOptionPane.showMessageDialog(null, DailyClosingTime);
     
    String CompareTime = AppointmentTime;
    if(CompareTime.length() == 4)
        CompareTime = "0" + CompareTime;
    
    if(Integer.parseInt(CompareTime.substring(0,2)) < Integer.parseInt(DailyStartTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ServiceProviderPage.jsp");
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
        response.getWriter().print("Not Successful. Time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ServiceProviderPage.jsp");
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
            response.getWriter().print("Not Successful; time chosen is earlier than your opening time\nYou open at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        //response.sendRedirect("ServiceProviderPage.jsp");
        //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
        response.getWriter().print("Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            //response.sendRedirect("ServiceProviderPage.jsp");
            //JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
            response.getWriter().print("Not Successful; time chosen is later than your closing time\nYou close at " + DailyClosingTime);
        }
    }
    
//----------------------------------------------------------------------------------------------------------------------
        if(selectFlag != 2){
            
            boolean isCustSpot = false;
            boolean isDoubleBooking = false;
            
        try{
            //this is for when customer is already booked with another provider
            Class.forName(Driver);
            Connection selectConn = DriverManager.getConnection(url, user, password);
            String selectString = "Select * from QueueObjects.BookedAppointment where "
                    + "CustomerID = ? and ProviderID = ? and AppointmentDate=? and AppointmentTime=?";
            
            PreparedStatement selectPst = selectConn.prepareStatement(selectString);
            selectPst.setString(1, CustomerID);
            selectPst.setString(2, ProviderID);
            selectPst.setString(3, AppointmentDate);
            selectPst.setString(4, AppointmentTime);
            
            ResultSet selectRow = selectPst.executeQuery();
            
            while(selectRow.next()){
                selectFlag = 1;
                isCustSpot = true;
                //StatusesClass.AppointmentStatus = "Warning: " + AppointmentTime + 
                //        ", " + AppointmentDate + ".\n This Customer may not be available at chosen time. They already have a booking at " + AppointmentTime;
                //JOptionPane.showMessageDialog(null, "Reservation Not Allowed: This customer already has this spot");
                response.getWriter().print("Reservation Not Allowed: This customer already has this spot");
                //response.sendRedirect("ServiceProviderPage.jsp");
                break;
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
                isDoubleBooking = true;
                //selectFlag = 1;
                //StatusesClass.AppointmentStatus = ;
                if(!isCustSpot)
                    /*JOptionPane.showMessageDialog(null, "Warning: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nTime chosen may cause double booking");*/
                response.getWriter().print("Warning: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nTime chosen may cause double booking");
                //response.sendRedirect("ServiceProviderPage.jsp");
                break;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        //checking for time range;
        try{
            
            Class.forName(Driver);
            Connection TimeRangeConn = DriverManager.getConnection(url, user, password);
            String TimeRangeString = "Select * from QueueObjects.BookedAppointment where "
                    + "(ProviderID = ? and  AppointmentDate = ? and (AppointmentTime between ? and ?))";
            
            PreparedStatement TimeRangePst = TimeRangeConn.prepareStatement(TimeRangeString);
            TimeRangePst.setString(1, ProviderID);
            TimeRangePst.setString(2, AppointmentDate);
            TimeRangePst.setString(3, TimeBefore30Mins);
            TimeRangePst.setString(4, TimeAfter30Mins);
            
            ResultSet TimeRangeRow = TimeRangePst.executeQuery();
            while(TimeRangeRow.next()){
                
                //selectFlag = 1;
                //StatusesClass.AppointmentStatus = ;
                if(!isCustSpot && !isDoubleBooking)
                    /*JOptionPane.showMessageDialog(null, "Warning: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot");*/
                response.getWriter().print("Warning: " + AppointmentTime + 
                        ", " + AppointmentDate + ".\nThe spot you've chosen overlaps with another spot");
                //response.sendRedirect("ServiceProviderPage.jsp");
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
                
                String ProvName = "", Company = "";
                
                try{
                    Class.forName(Driver);
                    Connection ProvConn = DriverManager.getConnection(url, user, password);
                    String ProvQuery = "select First_Name, Company from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                    ProvPst.setString(1, ProviderID);
                    
                    ResultSet ProvRec = ProvPst.executeQuery();
                    
                    while(ProvRec.next()){
                        ProvName = ProvRec.getString("First_Name").trim();
                        Company = ProvRec.getString("Company").trim();
                    }
                    
                
                }catch(Exception e){
                    e.printStackTrace();
                }
                
                //nofitying customer
                try{
                    Class.forName(Driver);
                    Connection notiConn = DriverManager.getConnection(url, user, password);
                    String notiString = "insert into ProviderCustomers.Notifications (Noti_Type, CustID, If_From_Prov, What, Noti_Date, Noti_Time)"
                            + "values (?,?,?,?,?,?)";
                    PreparedStatement notiPst = notiConn.prepareStatement(notiString);
                    notiPst.setString(1, "Reservation");
                    notiPst.setString(2, CustomerID);
                    notiPst.setString(3, ProviderID);
                    notiPst.setString(4, ProvName + " of " + Company + " has " + AppointmentTime + " reserved for you on " + AppointmentDate);
                    notiPst.setString(5, date);
                    notiPst.setString(6, time);
                    notiPst.executeUpdate();
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
                //JOptionPane.showMessageDialog(null, "Reservation made successfully!");
                response.getWriter().print("Reservation made successfully");
                //response.sendRedirect("ServiceProviderPage.jsp");

            }catch(Exception e){
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
