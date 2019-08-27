

import com.arieslab.queue.queue_model.ProcedureClass;
import com.arieslab.queue.queue_model.ResendAppointmentData;
import com.arieslab.queue.queue_model.StatusesClass;
import com.arieslab.queue.queue_model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;


public class LoginAndSendAppointmentController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int yourIndex = -1;
        
        int UserID = 0;
        
        int Flag = 0;
        
        String UserName = request.getParameter("username");
        String UserPassword = request.getParameter("password");
        String SessionID = "";
        
        String ProviderID = request.getParameter("ProviderID");
        String CustomerID = "";
        String OrderedServices = request.getParameter("OrderedServices");
        String AppointmentDate = request.getParameter("AppointmentDate");
        String AppointmentTime = request.getParameter("AppointmentTime");
        String ServicesCost = request.getParameter("ServiceCost");
        String PaymentMethod = request.getParameter("PaymentMethod");
        String DebitCreditCardNumber = request.getParameter("DebitCreditCard");
        
        String VerifiedName = "";
        
        //putting neccessery data into
        request.setAttribute("CustomerID",CustomerID);
        request.setAttribute("ProviderID",ProviderID);
        request.setAttribute("OrderedServices",OrderedServices);
        request.setAttribute("AppointmentDate",AppointmentDate);
        request.setAttribute("AppointmentTime",AppointmentTime);
        request.setAttribute("PaymentMethod",PaymentMethod);
        request.setAttribute("ServiceCost",ServicesCost);
        request.setAttribute("DebitCreditCard",DebitCreditCardNumber);
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";

        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String loginString = "Select * from ProviderCustomers.UserAccount where UserName = ? and Password = ?";
            
            PreparedStatement loginPst = conn.prepareStatement(loginString);
            loginPst.setString(1, UserName);
            loginPst.setString(2, UserPassword);
            
            ResultSet loginAccount = loginPst.executeQuery();
            
            while(loginAccount.next()){
                
                String DatabaseUserName = loginAccount.getString("UserName").trim();
                String DatabasePassword = loginAccount.getString("Password").trim();
                
                if(DatabaseUserName.equals(UserName) && DatabasePassword.equals(UserPassword)){
                    
                    Flag = 1;
                   
                    CustomerID = loginAccount.getString("CustomerId");
                    UserID = loginAccount.getInt("CustomerId");
                    VerifiedName = DatabaseUserName;
                    
                    yourIndex = UserAccount.newUser(Integer.parseInt(CustomerID), DatabaseUserName, "CustomerAccount");
                    request.setAttribute("UserName", DatabaseUserName);
                    request.setAttribute("UserIndex", yourIndex);
                    
                    SessionID = request.getRequestedSessionId();
                    
                    try{
                        Class.forName(Driver);
                        Connection SessionConn = DriverManager.getConnection(url, user, password);
                        String SessionString = "insert into QueueObjects.UserSessions(UserIndex,SessionNo) values(?,?)";
                        PreparedStatement SessionPst = SessionConn.prepareStatement(SessionString);
                        SessionPst.setInt(1, yourIndex);
                        SessionPst.setString(2, SessionID);
                                
                        SessionPst.executeUpdate();
                                
                    }catch(Exception e){}
                    
                    
                   //UserAccount.UserID = loginAccount.getInt("CustomerId");
                    ProcedureClass.CustomerID = loginAccount.getInt("CustomerId");
                    //UserAccount.AccountType = "CustomerAccount";
                    
                }
                else{
                    
                    Flag = 0;
                    
                }
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(Flag == 1){
            
            int selectFlag = 0;
            boolean blockedYou = false;

            //checking to see if this provider blocked you 

            try{

                Class.forName(Driver);
                Connection BlockedYouConn = DriverManager.getConnection(url, user, password);
                String BlockedYouString = "Select * from QueueServiceProviders.BlockedCustomers where ProviderId = ? and CustomerID = ?";
                PreparedStatement BlockedYouPst = BlockedYouConn.prepareStatement(BlockedYouString);
                BlockedYouPst.setString(1, ProviderID);
                BlockedYouPst.setInt(2, UserID);

                ResultSet BlockedYouRec = BlockedYouPst.executeQuery();
                
                while(BlockedYouRec.next()){

                    blockedYou = true;
                    selectFlag = 2;
                    JOptionPane.showMessageDialog(null, "Logged in successfully");
                    JOptionPane.showMessageDialog(null, "You're not allowed to schedule with this provider");
                    response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);

                }
                 


            }catch(Exception e){
                e.printStackTrace();
            }
    
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

                if(blockedYou == false){
                
                    while(ClosedRec.next()){

                        if(StringDateForCompare.equals(ClosedRec.getString("DateToClose").trim())){
                            isTodayClosed = true;
                            response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                            JOptionPane.showMessageDialog(null, "Logged in successfully");
                            JOptionPane.showMessageDialog(null, "Provider is closed on chosen date");
                        }

                    }
                
                }

                }catch(Exception e){
                    e.printStackTrace();
                }

            if(isTodayClosed == false){
            
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
                        if(blockedYou == false){
                            response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                            JOptionPane.showMessageDialog(null, "Logged in successfully");
                            JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
                        }
                    }

                    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
                        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
                            selectFlag = 2;
                            if(blockedYou == false){
                                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                                JOptionPane.showMessageDialog(null, "Logged in successfully");
                                JOptionPane.showMessageDialog(null,"Not Successful; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
                            }
                        }
                    }

                    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
                        selectFlag = 2;
                        if(blockedYou == false){
                            response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                            JOptionPane.showMessageDialog(null, "Logged in successfully");
                            JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
                        }
                    }

                    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
                        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
                            selectFlag = 2;
                            if(blockedYou == false){
                                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                                JOptionPane.showMessageDialog(null, "Logged in successfully");
                                JOptionPane.showMessageDialog(null,"Not Successful; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
                            }
                        }
                    }

//----------------------------------------------------------------------------------------------------------------------
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
                                JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
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
                                JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
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
                                JOptionPane.showMessageDialog(null, StatusesClass.AppointmentStatus);
                                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                                break;

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }


                        //____________________________________________________________________________________

                        if(selectFlag == 0){
                            try{

                                Class.forName(Driver);
                                Connection conn2 = DriverManager.getConnection(url, user, password);
                                String insertString = "Insert into QueueObjects.BookedAppointment values "
                                        + "(?, ?, ?, ?, ?, ?, ?, ?)";

                                PreparedStatement insertPst = conn2.prepareStatement(insertString);
                                insertPst.setString(1, CustomerID);
                                insertPst.setString(2, ProviderID);
                                insertPst.setString(3, OrderedServices);
                                insertPst.setString(4, AppointmentDate);
                                insertPst.setString(5, AppointmentTime);
                                insertPst.setString(6, ServicesCost);
                                insertPst.setString(7, PaymentMethod);
                                insertPst.setString(8, DebitCreditCardNumber);

                                insertPst.executeUpdate();

                                JOptionPane.showMessageDialog(null, "You've been enqueued successfully!");
                                response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+yourIndex+"&User="+VerifiedName);
                                //response.sendRedirect("ProviderCustomerPage.jsp");

                            }catch(Exception e){
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
        else{
            
            JOptionPane.showMessageDialog(null, "Incorrect user login information; enter valid user account");
            request.setAttribute("ProviderID", ProviderID);
            String Message = "Incorrect user login information; enter valid user account";
            request.getRequestDispatcher("FinishAppointmentReLogin.jsp?Message="+Message).forward(request, response);
            //response.sendRedirect("FinishAppointmentReLogin.jsp");
            
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
