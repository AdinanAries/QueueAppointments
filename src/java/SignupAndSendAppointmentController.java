

import com.arieslab.queue.queue_model.ExistingProviderAccountsModel;
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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;


@WebServlet(urlPatterns = {"/SignupAndSendAppointmentController"})
public class SignupAndSendAppointmentController extends HttpServlet {
    
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
        
        int yourIndex = 0;
       
        String FirstName = request.getParameter("firstName").trim().replaceAll("( )+", " ");
        String MiddleName = request.getParameter("middleName").trim().replaceAll("( )+", " ");
        String LastName = request.getParameter("lastName").trim().replaceAll("( )+", " ");
        String Phone_Number = request.getParameter("telNumber").trim().replaceAll("( )+", " ");
        String Email = request.getParameter("email").trim().replaceAll("( )+", " ");
        
        String UserName = request.getParameter("username").trim().replaceAll("( )+", " ");
        String Password = request.getParameter("password").trim().replaceAll("( )+", " ");
        
        String ProviderID = request.getParameter("ProviderID");
        String CustomerID = "";
        String OrderedServices = request.getParameter("OrderedServices");
        String AppointmentDate = request.getParameter("AppointmentDate");
        String AppointmentTime = request.getParameter("AppointmentTime");
        String ServicesCost = request.getParameter("ServicesCost");
        String PaymentMethod = request.getParameter("PaymentMethod");
        String DebitCreditCardNumber = request.getParameter("DebitCreditCard");
        
        //putting neccessery data into
        ResendAppointmentData.CustomerID = CustomerID;
        ResendAppointmentData.ProviderID = ProviderID;
        ResendAppointmentData.SelectedServices = OrderedServices;
        ResendAppointmentData.AppointmentDate = AppointmentDate;
        ResendAppointmentData.AppointmentTime = AppointmentTime;
        ResendAppointmentData.PaymentMethod = PaymentMethod;
        ResendAppointmentData.ServicesCost = ServicesCost;
        ResendAppointmentData.CreditCardNumber = DebitCreditCardNumber;
        
        int UserIndex = ExistingProviderAccountsModel.getUserIndex();
        
        boolean isExistingAccount = false;
        
        
        //ExistingProviderAccountsModel.AccountsList.clearAccountsList();
        
        //checking if telephone number already exists
        try{
            Class.forName(Driver);
            Connection checkTelConn = DriverManager.getConnection(url, user, password);
            String checkTelString = "Select Customer_ID from  ProviderCustomers.CustomerInfo where Phone_Number = ?";
            PreparedStatement checkTelPst = checkTelConn.prepareStatement(checkTelString);
            checkTelPst.setString(1, Phone_Number);
            ResultSet checkTelRow = checkTelPst.executeQuery();
            
            int istel = 0;
            while(checkTelRow.next()){
                
                istel = 1;
                isExistingAccount = true;
                ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkTelRow.getInt("Customer_ID"));
                //JOptionPane.showMessageDialog(null, "An account associated with this mobile number already exists");
            }
            
            if(istel == 1)
                response.sendRedirect("NotSuccessfulPageCustomerSendApp.jsp?UserIndex="+UserIndex);
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        //checking if this user account already exists
        try{
            Class.forName(Driver);
            Connection checkAccountConn = DriverManager.getConnection(url, user, password);
            String checkAccountString = "Select * from ProviderCustomers.CustomerInfo where First_Name = ? and Middle_Name = ? "
                    + " and Last_Name = ? and Email = ?";
            
           PreparedStatement checkAccountPst = checkAccountConn.prepareStatement(checkAccountString);
           checkAccountPst.setString(1, FirstName);
           checkAccountPst.setString(2, MiddleName);
           checkAccountPst.setString(3, LastName);
           checkAccountPst.setString(4, Email);
           
           ResultSet checkAccountRows = checkAccountPst.executeQuery();
           
           int isuser = 0;
           while(checkAccountRows.next()){
               
               isuser = 1;
               isExistingAccount = true;
               ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkAccountRows.getInt("Customer_ID"));
               //JOptionPane.showMessageDialog(null, "User Account Already Exists");
               
           }
           
           if(isuser == 1)
               response.sendRedirect("NotSuccessfulPageCustomerSendApp.jsp?UserIndex="+UserIndex);
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        
        
        if(isExistingAccount == false){
             
        
        try{
            
            Class.forName(Driver);
            Connection createUserConn = DriverManager.getConnection(url, user, password);
            String createUserString = "Insert into ProviderCustomers.CustomerInfo "
                    + "(First_Name, Middle_Name, Last_Name, Date_Of_Birth, Phone_Number, Email) "
                    + "values (?, ?, ?, '1991-01-01', ?, ?)";
            
            PreparedStatement createUserPst = createUserConn.prepareStatement(createUserString);
            createUserPst.setString(1,FirstName);
            createUserPst.setString(2,MiddleName);
            createUserPst.setString(3,LastName);
            createUserPst.setString(4,Phone_Number);
            createUserPst.setString(5,Email);
            
            createUserPst.executeUpdate();
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection getUserConn = DriverManager.getConnection(url, user, password);
            String getUserString = "Select * from ProviderCustomers.CustomerInfo where"
                    + " First_Name = ? and Middle_Name = ? and Last_Name = ? and Phone_Number = ? "
                    + "and Email = ?";
            
            PreparedStatement getUserPst = getUserConn.prepareStatement(getUserString);
            getUserPst.setString(1,FirstName);
            getUserPst.setString(2,MiddleName);
            getUserPst.setString(3,LastName);
            getUserPst.setString(4,Phone_Number);
            getUserPst.setString(5,Email);
            
            ResultSet userAccount = getUserPst.executeQuery();
            
            while(userAccount.next()){
                
                CustomerID = userAccount.getString("Customer_ID");
                
                yourIndex = UserAccount.newUser(userAccount.getInt("Customer_ID"), UserName, "CustomerAccount");
                request.setAttribute("UserIndex", yourIndex);
                request.setAttribute("UserName", UserName);
                
                //UserAccount.UserID = userAccount.getInt("Customer_ID");
                ProcedureClass.CustomerID = userAccount.getInt("Customer_ID");
                //UserAccount.AccountType = "CustomerAccount";
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection createAccountConn = DriverManager.getConnection(url, user, password);
            String createAccountString = "insert into ProviderCustomers.UserAccount values (?, ?, ?)";
            
            PreparedStatement createAccountPst = createAccountConn.prepareStatement(createAccountString);
            createAccountPst.setString(1,CustomerID);
            createAccountPst.setString(2,UserName);
            createAccountPst.setString(3,Password);
            
            createAccountPst.executeUpdate();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
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
                    response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
                    JOptionPane.showMessageDialog(null, "Provider is closed on chosen date");
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
        response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
        JOptionPane.showMessageDialog(null, "Account Created Successfully");
        JOptionPane.showMessageDialog(null,"Queue was not finished; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyStartTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) < Integer.parseInt(DailyStartTime.substring(3,5))){
            selectFlag = 2;
            response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
            JOptionPane.showMessageDialog(null, "Account Created Successfully");
            JOptionPane.showMessageDialog(null,"Queue was not finished; time chosen is earlier than providers opening time\nProvider opens at " + DailyStartTime);
        }
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) > Integer.parseInt(DailyClosingTime.substring(0,2))){
        selectFlag = 2;
        response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
        JOptionPane.showMessageDialog(null, "Account Created Successfully");
        JOptionPane.showMessageDialog(null,"Queue was not finished; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
    }
    
    if(Integer.parseInt(CompareTime.substring(0,2)) == Integer.parseInt(DailyClosingTime.substring(0,2))){
        if(Integer.parseInt(CompareTime.substring(3,5)) > Integer.parseInt(DailyClosingTime.substring(3,5))){
            selectFlag = 2;
            response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
            JOptionPane.showMessageDialog(null, "Account Created Successfully");
            JOptionPane.showMessageDialog(null,"Queue was not finished; time chosen is later than providers closing time\nProvider closes at " + DailyClosingTime);
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
                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
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
                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
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
                response.sendRedirect("ResetAppointmentParameters.jsp?UserIndex="+yourIndex+"&User="+UserName);
                break;
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        //____________________________________________________________________________________
        
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

                request.getRequestDispatcher("ProviderCustomerPage.jsp").forward(request, response);
                //response.sendRedirect("ProviderCustomerPage.jsp");
                JOptionPane.showMessageDialog(null, "You've been enqueued Successfully");
                JOptionPane.showMessageDialog(null, "Your user account was created successfully!");

            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
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
