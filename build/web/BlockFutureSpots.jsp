<%-- 
    Document   : BlockFutureSpots
    Created on : Jun 3, 2019, 10:13:16 AM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="com.arieslab.queue.queue_model.BookedAppointmentList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Driver"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.arieslab.queue.queue_model.UserAccount"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Block Future Spots</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="/resources/demos/style.css">
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
    
    </head>
   
    <script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
    
    <body style="background-color: #7e7e7e;">
        <h3 style="text-align: center; margin: 5px; color: white;">Block Future Spots</h3>
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------>
               
                <center><div id="QueuLineDiv" style="width: 100%; max-width: 600px;">
                        
                                        
                <%
                        
                        //connection arguments
                        String Url = config.getServletContext().getAttribute("DBUrl").toString();
                        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
                        String user = config.getServletContext().getAttribute("DBUser").toString();
                        String password = config.getServletContext().getAttribute("DBPassword").toString();
                        
                        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
                        String NewUserName = request.getParameter("User");
                        
                        //Since this is services provider page.
                        int ProviderID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
                        
                         String SpotsDate = request.getParameter("GetDate");
                        int IntervalsValue = 30;
        
                        //Getting Spot intervals from Settings DB table
                        try{

                            Class.forName(Driver);
                            Connection intervalsConn = DriverManager.getConnection(Url, user, password);
                            String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                            PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

                            intervalsPst.setInt(1, ProviderID);

                            ResultSet intervalsRec = intervalsPst.executeQuery();

                            while(intervalsRec.next()){
                                IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
                            }
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                        

                        //Provides unique ID for each provider at bookAppointmentFromLineDivForm
                        int d = 0;
                        
                        //formatting date value from request object in order to be used in database to get all 
                        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                        //This date obj is not based on current date (new Date()), it is from Date value from request Obj
                        java.util.Date DayOfAppointment = sdf.parse(SpotsDate);
                        String QueueDate = sdf.format(DayOfAppointment);

                        //Gettring Current Time 
                        String CurrentTime = DayOfAppointment.toString().substring(11,16); //this contains 00:00 since date isn't created from new Date()
                        
        
                        Date currentDate = DayOfAppointment; 
                        
                        String JSCurrentTime = currentDate.toString().substring(11,16); //forJavaScript, initial value is 00:00; 
                        
                        String DayOfWeek = currentDate.toString().substring(0,3);
                        SimpleDateFormat formattedDate = new SimpleDateFormat("MMM dd"); //formatting date to a string value of month day, year
                        String stringDate = formattedDate.format(currentDate); //calling format function to format date object
                        SimpleDateFormat QuerySdf = new SimpleDateFormat("yyyy-MM-dd");
                        String QueryDate = QuerySdf.format(currentDate);
                                        
                        //List Items to contain various varying spot times (Available, taken and blocked) 
                        //Some List Items store formatted varying spot times for user display.
                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                        ArrayList<String> AllAvailableFormattedTimeList = new ArrayList<>();
                        ArrayList<String> AllUnavailableTimeList = new ArrayList<>();
                        ArrayList<String> AllUnavailableFormattedTimeList = new ArrayList<>();
                        ArrayList<String> AllThisProviderBlockedTime = new ArrayList<>();
                        ArrayList<String> AllThisProviderBlockedFormattedTakenTime = new ArrayList<>();
                        ArrayList<String> BlockedAppointmentIDs = new ArrayList<>();
                                        
                        //Variables to store Start and Closing times both farmatted and non-formatted
                        String DailyStartTime = "";
                        String DailyClosingTime = "";
                        String FormattedStartTime = "";
                        String FormattedClosingTime = "";
                        
                        //Used to store time parts for starting and closing times
                        int startHour = 0;
                        int startMinute = 0;
                        int closeHour = 0;
                        int closeMinute = 0;
                               
                        //Stores total number items in various spots lists
                        int TotalAvailableList = 0;
                        int TotalUnavailableList = 0;
                        int TotalThisCustomerTakenList = 0;
                %>
                                    
                <%
                    
                                        //needed to collect each individual starting and closing days for all week long
                                        //then assigning the right value based on day of week as presented from Date created from SpotsDate(Mon, Tue, Wed, etc.)
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
                                            Connection hoursConn = DriverManager.getConnection(Url, user, password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setInt(1, ProviderID);
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
                                                
                                                
                                                if(DailyStartTime == "")
                                                    DailyStartTime = "01:00";
                                                if(DailyClosingTime == "")
                                                    DailyClosingTime = "23:00";
                                                
                                                
                                                startHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                                startMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
                                                        if( startHour > 12)
                                                        {
                                                             int TempHour = startHour - 12;
                                                             FormattedStartTime = Integer.toString(TempHour) + ":" +  DailyStartTime.substring(3,5) + " pm";
                                                        }
                                                        else if(startHour == 0){
                                                            FormattedStartTime = "12" + ":" + DailyStartTime.substring(3,5) + " am";
                                                        }
                                                        else if(startHour == 12){
                                                            FormattedStartTime = DailyStartTime + " pm";
                                                        }
                                                        else{
                                                            FormattedStartTime = DailyStartTime +" am";
                                                        }
                                               
                                                closeHour = Integer.parseInt(DailyClosingTime.substring(0,2));
                                                closeMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
                                                        if( closeHour > 12)
                                                        {
                                                             int TempHour = closeHour - 12;
                                                             FormattedClosingTime = Integer.toString(TempHour) + ":" +  DailyClosingTime.substring(3,5) + " pm";
                                                        }
                                                        else if(closeHour == 0){
                                                            FormattedClosingTime = "12" + ":" + DailyClosingTime.substring(3,5) + " am";
                                                        }
                                                        else if(closeHour == 12){
                                                            FormattedClosingTime = DailyClosingTime + " pm";
                                                        }
                                                        else{
                                                            FormattedClosingTime = DailyClosingTime +" am";
                                                        }
                                                        
                                                        if(closeHour == 0)
                                                            closeHour = 23;
                                            }
                                            catch(Exception e){}
                                        
                                        
                                    %>
                                    
                                    <%
                                        //getting the closed days data
                                        ArrayList<String> ClosedDates = new ArrayList<>();
                                        ArrayList<Integer> ClosedIDs = new ArrayList<>();
                                        boolean isTodayClosed = false;
                                        
                                        SimpleDateFormat DateForCompareSdf = null;
                                        java.util.Date DateForClosedCompare = null;
                                        try{
                                            DateForCompareSdf = new SimpleDateFormat("MM/dd/yyyy"); //Use default java date format because SpotsDate is in this format
                                            DateForClosedCompare = sdf.parse(SpotsDate);//Parsing SpotsDate String which is in the format provided above
                                        
                                        }catch(Exception e){}
                                        
                                        //Date DateForClosedCompare = new Date();
                                        SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                        //the below StringDate Compares with SQL Date to make sure its not a closed date
                                        String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare); //Creating String Date from Date Object into format provider above
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection CloseddConn = DriverManager.getConnection(Url, user, password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setInt(1, ProviderID);
                                            
                                            ResultSet ClosedRec = CloseddPst.executeQuery();
                                            
                                            while(ClosedRec.next()){
                                                
                                                ClosedDates.add(ClosedRec.getString("DateToClose").trim());
                                                ClosedIDs.add(ClosedRec.getInt("closedID"));
                                                
                                                if(StringDateForCompare.equals(ClosedRec.getString("DateToClose").trim())){
                                                    isTodayClosed = true;
                                                }
                                                
                                                //JOptionPane.showMessageDialog(null, StringDateForCompare);
                                                //JOptionPane.showMessageDialog(null, ClosedRec.getString("DateToClose").trim());
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                    %>
                                    
                                    <%
                                        if(DailyStartTime == "")
                                            DailyStartTime = "01:00";
                                        if(DailyClosingTime == "")
                                            DailyClosingTime = "23:00";
                                                
                                        CurrentTime = DailyStartTime;
                                        int CurrentHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                        int CurrentMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                        
                                        
                                        //do all this for open or closed status led
                                        String StatusLedCurrentTime = currentDate.toString().substring(11,16);
                                        int StatusLedCurrentHour = Integer.parseInt(StatusLedCurrentTime.substring(0,2));
                                        int StatusLedCurrentMinute = Integer.parseInt(StatusLedCurrentTime.substring(3,5));
                                        
                                        int CurrentHourForStatusLed = StatusLedCurrentHour;
                                        int CurrentMinuteForStatusLed = StatusLedCurrentMinute;
                                        
                                        if(DailyStartTime != ""){
                                            
                                            if(CurrentHour < startHour){
                                            
                                                CurrentHour = startHour;
                                                CurrentMinute = startMinute;
                                                
                                            }
                                        
                                        }
                                        
                                        //Used to store and keep track of time after 30mins intervals
                                        String NextAvailableTime = "" ;
                                        //Used to store and keep track of 12hour format time after 30mins for display
                                        String NextAvailableFormattedTime = "";
                                        
                                        int y = 0;
                                        int isFirstAppointmentFound = 0;
                                        int bookedTimeFlag = 0;
                                        int myAppointmentTimeFlag = 0;
                                        
                                        int NextThirtyMinutes = CurrentMinute + 30;
                                        
                                        //use this if there is no appointment for the next hour
                                        int ActualThirtyMinutesAfter = CurrentMinute + 30;
                                        
                                        int NextHour = CurrentHour;
                                        
                                        //use this if there is no appointment for the next hour
                                        int Hourfor30Mins = CurrentHour;
                                        
                                        if(NextThirtyMinutes >= 60){
                                        //this is code is only to increment Hour and make sure it doesn't exceed providers closing time 
                                        //first increment hour when Minutes is greater than 60 after increment
                                            
                                            ++NextHour;
                                            
                                            if(DailyClosingTime != ""){
                                                //Perform these operations when provider has a closing time
                                                
                                                if(NextHour > closeHour && closeHour != 0){
                                                    //make sure that next hour hasn't exceeded providers closing time hour
                                                    NextHour = closeHour - 1;

                                                }
                                                else if(closeHour == 0)//if data returned from database is 00 for 12am then use 23
                                                    NextHour = 23;
                                                    
                                            }else if(NextHour > 23){//this is neccessary because closing hour may not necessarily be up to 23
                                                NextHour = 23;
                                            }
                                            
                                            
                                            
                                            if(NextThirtyMinutes > 60)
                                                NextThirtyMinutes -= 60;
                                            
                                            else if(NextThirtyMinutes == 60)
                                                NextThirtyMinutes = 0;
                                        }
                                        
                                        //use this if there is no appointment for the next hour
                                        if(ActualThirtyMinutesAfter >= 60){
                                            
                                            ++Hourfor30Mins;
                                            
                                            if(Hourfor30Mins > 23)
                                                Hourfor30Mins = 23;
                                            
                                            if(ActualThirtyMinutesAfter > 60)
                                                ActualThirtyMinutesAfter -= 60;
                                            
                                            else if(ActualThirtyMinutesAfter == 60)
                                                ActualThirtyMinutesAfter = 0;
                                        }
                                        
                                        String p = Integer.toString(NextThirtyMinutes);
                                        String h = Integer.toString(ActualThirtyMinutesAfter);
                                        
                                        if(p.length() < 2)
                                            p = "0" + p;
                                        
                                        if(h.length() < 2)
                                            h = "0" + h;
                                        
                                        String TimeAfter30Mins = NextHour + ":" + p;
                                        String TimeWith30Mins = Hourfor30Mins + ":" + h;
                                        NextAvailableTime = NextHour + ":" + p;
                                        //JOptionPane.showMessageDialog(null, CurrentTime);
                                        //JOptionPane.showMessageDialog(null, NextAvailableTime);
                                        int Next30MinsAppointmentFlag = 0;
                                        
                                        /*
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection ThirtyMinsConn = DriverManager.getConnection(Url, user, password);
                                            String ThirtyMinsString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                            
                                            PreparedStatement ThirtyPst = ThirtyMinsConn.prepareStatement(ThirtyMinsString);
                                            ThirtyPst.setInt(1, UserID);
                                            ThirtyPst.setString(2, QueryDate);
                                            ThirtyPst.setString(3, CurrentTime);
                                            ThirtyPst.setString(4, TimeAfter30Mins);
                                            
                                            ResultSet ThirtyMinsRow = ThirtyPst.executeQuery();
                                            
                                            while(ThirtyMinsRow.next()){
                                                
                                                Next30MinsAppointmentFlag = 1;
                                                isFirstAppointmentFound = 1;
                                                
                                                String TempTime = ThirtyMinsRow.getString("AppointmentTime");
                                                
                                                CurrentHour = Integer.parseInt(TempTime.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TempTime.substring(3,5));
                                                CurrentTime = CurrentHour + ":" + CurrentMinute;
                                                
                                                //getting the next 30 minute time from the current time;
                                                int TempMinute = CurrentMinute + 30;
                                        
                                                int TempHour = CurrentHour;

                                                if(TempMinute >= 60){

                                                    ++TempHour;

                                                    if(TempHour > 23)
                                                        TempHour = 23;

                                                    if(TempMinute > 60)
                                                        TempMinute -= 60;

                                                    else if(TempMinute == 60)
                                                        TempMinute = 0;
                                                }
                                                
                                                String StringTempMinute = Integer.toString(TempMinute);
                                                
                                                if(StringTempMinute.length() < 2)
                                                    StringTempMinute = "0" + StringTempMinute;
                                                
                                                NextAvailableTime = TempHour + ":" + StringTempMinute;
                                                
                                                break;
                                                
                                            }
                                            if(Next30MinsAppointmentFlag == 0){
                                                
                                                if(TimeWith30Mins.length() == 4)
                                                    TimeWith30Mins = "0" + TimeWith30Mins;
                                                
                                                CurrentHour = Integer.parseInt(TimeWith30Mins.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TimeWith30Mins.substring(3,5));
                                                String thisMinute = Integer.toString(CurrentMinute);
                                                        
                                                if(thisMinute.length() < 2){
                                                    thisMinute = "0" + thisMinute;
                                                }
                                                
                                                NextAvailableTime = CurrentHour + ":" + CurrentMinute;
                                                 
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                    */
                                        
                                        //this part of the algorithm changed
                                        int twoHours = CurrentHour + 23; //two hours determins how long should outer loop run
                                        
                                        if(DailyClosingTime != ""){ //Making sure that loop doesn't run past the closing time if there is and not doesn't go past 23
                                            
                                            if(twoHours > closeHour && closeHour != 0){

                                                    twoHours = closeHour - 1; //remove 1 from closing time so that there is spot up to the next hour after closing time 

                                                }
                                            else if(closeHour == 0)
                                                twoHours = 23;
                                            
                                        }else if(twoHours > 23){
                                                twoHours = 23;
                                            }
                                        
                                        if(isTodayClosed == true){
                                                
                                            DailyStartTime = "00:00";
                                            DailyClosingTime = "00:00";
                                                
                                        }
                                            
                                        
                                    %>
                                      
                                    <%
                                        if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00")){
                                    %>
                                                 
                                    <p style="color: tomato;">You're not open on <%=DayOfWeek%>...</p>
                                    
                                    <%
                                        }else if(FormattedStartTime != "" || FormattedClosingTime != "" && !(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))){
                                    %>
                                    
                                        <p><span>
                                            
                                        <%
                                            if((startHour > CurrentHourForStatusLed || closeHour < CurrentHourForStatusLed) && closeHour != 0){
                                        %>
                                        
                                        <img src="icons/icons8-new-moon-20.png" width="10" height="10" alt="icons8-new-moon-20"/>

                                        
                                        <%
                                            }else{
                                        %>
                                        
                                        <img src="icons/icons8-new-moon-20 (1).png" width="10" height="10" alt="icons8-new-moon-20 (1)"/>

                                        
                                        <%
                                            }
                                        %>
                                            
                                        </span>Hours: <span style="color: tomato"><%=FormattedStartTime%></span> -
                                        <span style="color: tomato"><%=FormattedClosingTime%></span>,
                                        <span style="color: tomato"><%=DayOfWeek%>, <%=stringDate%></span>.</p>
                                        
                                    <%
                                        }
                                    %>
                                    
                                        <!--p>Next Appointment: <%=NextAvailableTime%></p-->
                                    
                                    <center><p style='color: darkblue; font-weight: bold; padding-top: 10px;'>Available Queue</p></center>
                                    
                                    <center><div class="scrolldiv" style="width: 95%; max-width: 600px; overflow-x: auto;">
                                    
                                    <table style="width:100%; max-width: 600px;">
                                        <tbody>
                                            <tr>
                                                
                                            <%
                                                
                                                int HowManyColums = 0;
                                                int BookedSpots = 0;
                                                
                                                //use this variable to flag when there isn't any spot available
                                                boolean isLineAvailable = false;
                                                
                                                for(int x = CurrentHour; x < twoHours;){
                                                    
                                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                                        break;
                                                   
                                                    for(y = CurrentMinute; y <= 60;){ //CurrentMinute is needed to start from current minute of current time
                                                        
                                            %>
                                            
                                            <%
                                                        String AppointmentID = "";

                                                        try{

                                                            Class.forName(Driver);
                                                            Connection LineDivConn = DriverManager.getConnection(Url, user, password);
                                                            String LineDivString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";

                                                            PreparedStatement LineDivPst = LineDivConn.prepareStatement(LineDivString);
                                                            LineDivPst.setInt(1, ProviderID);
                                                            LineDivPst.setString(2, QueryDate);
                                                            LineDivPst.setString(3, CurrentTime);
                                                            LineDivPst.setString(4, NextAvailableTime);

                                                            ResultSet LineDivRow = LineDivPst.executeQuery();

                                                            while(LineDivRow.next()){

                                                                bookedTimeFlag = 1;

                                                                String Reason = LineDivRow.getString("OrderedServices").trim();


                                                                if(Reason.equals("Blocked Time")){

                                                                    bookedTimeFlag = 2;
                                                                    AppointmentID = LineDivRow.getString("AppointmentID");
                                                                    BlockedAppointmentIDs.add(AppointmentID);

                                                                }

                                                                CurrentTime = LineDivRow.getString("AppointmentTime");


                                                                int k = Integer.parseInt(CurrentTime.substring(0,2));
                                                                int l = Integer.parseInt(CurrentTime.substring(3,5));

                                                                x = Integer.parseInt(CurrentTime.substring(0,2));
                                                                y = Integer.parseInt(CurrentTime.substring(3,5));

                                                                ++l;
                                                                CurrentTime = k + ":" + l;

                                                                break;


                                                            }
                                                        }
                                                        catch(Exception e){
                                                            e.printStackTrace();
                                                        }
                                            %>
                                            
                                            <%
                                                        
                                                    
                                                        String thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                        //formatting the time for user convenience
                                                        if( x > 12)
                                                        {
                                                             int TempHour = x - 12;
                                                             NextAvailableFormattedTime = Integer.toString(TempHour) + ":" +  thisMinute + "pm";
                                                        }
                                                        else if(x == 0){
                                                            NextAvailableFormattedTime = "12" + ":" + thisMinute + "am";
                                                        }
                                                        else if(x == 12){
                                                            NextAvailableFormattedTime = NextAvailableTime + "pm";
                                                        }
                                                        else{
                                                            NextAvailableFormattedTime = NextAvailableTime +"am";
                                                        }
                                                     
                                            %>
                                            
                                            <% 
                                                
                                                        if(bookedTimeFlag == 1){

                                                            HowManyColums++;
                                                            isLineAvailable = true;

                                                            TotalUnavailableList++;
                                                            AllUnavailableTimeList.add(NextAvailableTime);
                                                            AllUnavailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                            int t = d + 1;
                                            %>
                                            
                                                            <td onclick="showLineTakenMessage(<%=t%><%=TotalUnavailableList%>)">
                                                                <p style="font-size: 12px; font-weight: bold; color: red;"><%=NextAvailableFormattedTime%></p>
                                                                <img src="icons/icons8-standing-man-filled-50.png" width="50" height="50" alt="icons8-standing-man-filled-50"/>
                                                            </td>

                                            <%  
                                                    
                                                        }
                                            
                                            %>
                                            
                                                <!--td>8:00am<img src="icons/icons8-standing-man-filled-50 (1).png" width="50" height="50" alt="icons8-standing-man-filled-50 (1)"/>
                                                </td-->
                                                
                                            <% 
                                                        if(bookedTimeFlag == 0){

                                                            HowManyColums++;
                                                            isLineAvailable = true;

                                                            TotalAvailableList++;
                                                            AllAvailableTimeList.add(NextAvailableTime);
                                                            AllAvailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                            int t = d + 1;
                                            %>
                                                
                                                            <td onclick="ShowQueueLinDivBookAppointment(<%=t%><%=TotalAvailableList%>)">
                                                                <p style="font-size: 12px; font-weight: bold; color: blue;"><%=NextAvailableFormattedTime%></p>
                                                                <img src="icons/icons8-standing-man-filled-50 (1).png" width="50" height="50" alt="icons8-standing-man-filled-50 (1)"/>
                                                           </td>
                                                
                                            <% 
                                                        }

                                            %>
                                                
                                            <%
                                                        if(bookedTimeFlag == 2){

                                                            HowManyColums++;
                                                            isLineAvailable = true;

                                                            TotalThisCustomerTakenList++;
                                                            AllThisProviderBlockedTime.add(NextAvailableTime);
                                                            AllThisProviderBlockedFormattedTakenTime.add(NextAvailableFormattedTime);

                                                            int t = d + 1;

                                            %>
                                            
                                                            <td onclick="showYourPositionMessage(<%=t%><%=TotalThisCustomerTakenList%>)">
                                                                <p style="font-size: 12px; font-weight: bold; color: green;"><%=NextAvailableFormattedTime%></p>
                                                                <img src="icons/icons8-standing-man-filled-50 (2).png" width="50" height="50" alt="icons8-standing-man-filled-50 (2)"/>
                                                            </td>
                                                
                                            <%          }
                                            
                                                        bookedTimeFlag = 0;
                                            
                                            %>
                                                <!--td>9:30am<img src="icons/icons8-standing-man-filled-50.png" width="50" height="50" alt="icons8-standing-man-filled-50"/>
                                                </td-->
                                            <% 
                                                        
                                                        y += IntervalsValue;
                                                        
                                                        if(y >= 60){
                                                             
                                                            x++;
                                                            
                                                            if(y > 60)
                                                                y -= 60;
                                                            else if(y == 60)
                                                                y = 0;
                                                             
                                                            if(x > twoHours){
                                                               //breaking out of this inner loop  
                                                               //incidentally the condition of outer loop becomes false
                                                               //thereby exiting as well
                                                               break;
                                                            }
                                                        }
                                                        
                                                        thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                        /*formatting the time for user convenience
                                                        if( x > 12)
                                                        {
                                                             int TempHour = x - 12;
                                                             NextAvailableFormattedTime = Integer.toString(TempHour) + ":" +  thisMinute + "pm";
                                                        }
                                                        else if(x == 0){
                                                            NextAvailableFormattedTime = "12" + ":" + thisMinute + "am";
                                                        }
                                                        else if(x == 12){
                                                            NextAvailableFormattedTime = NextAvailableTime + "pm";
                                                        }
                                                        else{
                                                            NextAvailableFormattedTime = NextAvailableTime +"am";
                                                        }*/
                                                    
                                                        //CurrentMinute = y;
                                                        
                                                        //if(HowManyColums >= 5)
                                                            //break;
                                                  
                                                    }
                                                      
                                                    //if(HowManyColums >= 5)
                                                        //break;
                                                }
                                            %>
                                            
                                            </tr>
                                        </tbody>
                                    </table>
                                    
                                    </div></center>
                                        
                                     <%
                                         Date thisDate = new Date();
                                         SimpleDateFormat thisDateFormat = new SimpleDateFormat("MM/dd/yyyy");
                                         String Today = thisDateFormat.format(thisDate);
                                         String thisTime = thisDate.toString().substring(11,16);
                                        
                                        for(int z = 0; z < AllThisProviderBlockedFormattedTakenTime.size(); z++){
                                            
                                            String NextThisAvailableTimeForDisplay = AllThisProviderBlockedFormattedTakenTime.get(z);
                                            String NextThisProviderBlockedTime = AllThisProviderBlockedTime.get(z);
                                            String AppointmentID = BlockedAppointmentIDs.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>     
                                            
                                    
                                    <form name="ReleaseSpot" style='background-color: green; display: none; margin-bottom: 5px;' id='YourLinePositionMessage<%=t%><%=q%>' action="UnblockSpotController" method="POST">
                                        
                                   <p style="color: white; text-align: center;" id="">You blocked <%=NextThisAvailableTimeForDisplay%></p>
                                        
                                    <%
                                        if(thisTime.length() == 4)
                                            thisTime = "0" + thisTime;
                                        if(NextThisProviderBlockedTime.length() == 4)
                                            NextThisProviderBlockedTime = "0" + NextThisProviderBlockedTime;
                                        
                                        int TempThisHour = Integer.parseInt(thisTime.substring(0,2));
                                        int TempThisMinute = Integer.parseInt(thisTime.substring(3,5));
                                        int AppointmentHour = Integer.parseInt(NextThisProviderBlockedTime.substring(0,2));
                                        int AppointmentMinute = Integer.parseInt(NextThisProviderBlockedTime.substring(3,5));
                                        
                                        if(TempThisHour > AppointmentHour && (QueueDate.equals(Today))){}
                                        
                                        else if(TempThisHour == AppointmentHour && QueueDate.equals(Today)){
                                            
                                            if(TempThisMinute <= AppointmentMinute){
                                        
                                    
                                    %>
                                        
                                        <input type="hidden" name="BlockedAppointmentID" value="<%=AppointmentID%>" />
                                        <input type="submit" style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 5px;" value="Unblock this spot" />
                                    
                                    <%      }
                                        }else if(TempThisHour < AppointmentHour && QueueDate.equals(Today)) {
                                    %>
                                    
                                        <input type="hidden" name="BlockedAppointmentID" value="<%=AppointmentID%>" />
                                        <input type="submit" style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 5px;" value="Unblock this spot" />
                                    
                                    <%} else if(!QueueDate.equals(Today)){%>
                                    
                                        <input type="hidden" name="BlockedAppointmentID" value="<%=AppointmentID%>" />
                                        <input type="submit" style="background-color: pink; border: 1px solid black; padding: 5px; border-radius: 5px;" value="Unblock this spot" />
                                    
                                    <%}%>
                                    
                                    </form>
                                    
                                    <%}%>
                                    
                                    <%
                                        //this code lines copied from different page. Not really Usefull for this page.
                                        for(int z = 0; z < AllUnavailableTimeList.size(); z++){
                                            
                                            String NextUnavailableTimeForMessage = AllUnavailableFormattedTimeList.get(z);
                                            //JOptionPane.showMessageDialog(null, NextUnavailableTimeForMessage);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>
                                   
                                    <%}%>
                                    
                                    <%
                                        if(!isLineAvailable){
                                    %>
                                    
                                        <p style="background-color: red; color: white; text-align: center;">There is no line available on <%=DayOfWeek%>, <%=stringDate%></p>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        //untaken time spots that can be blocked by services provider
                                        
                                        for(int z = 0; z < AllAvailableTimeList.size(); z++){
                                            
                                            String NextAvailableTimeForForm = AllAvailableTimeList.get(z);//Time data to be sent to BlockFutureSpotController
                                            
                                            String NextAvailableTimeForFormDisplay = AllAvailableFormattedTimeList.get(z);//Time data to be displayed for User (12hour formatted)
                                            
                                            //variables that help make HTML Element IDs unique
                                            int t = d + 1; //this changes per provider information
                                            int q = z + 1; //this changes per form for each provider
                                            
                                    %>
                                    
                                            <form style="display: none;" id="bookAppointmentFromLineDiv<%=t%><%=q%>" name="bookAppointmentFromLineDiv" action="BlockFutureSpotController" method="POST">
                                                <input type="hidden" name="CustomerID" value="1" />
                                                <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                                <input type="hidden" name="GetDate" value="<%=SpotsDate%>" />
                                                <input type="hidden" name="formsOrderedServices" value="Blocked Time" />
                                                <input type="hidden" name="formsDateValue" value="<%=QueryDate%>" />
                                                <input type="hidden" name="formsTimeValue" value="<%=NextAvailableTimeForForm%>" />
                                                <input type="hidden" name="TotalPrice" value="00.00" />
                                                <input type="hidden" name="payment" value="None" />
                                                <input type="hidden" name="UserIndex" value="<%=UserIndex%>"/>
                                                <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        
                                    <%
                                            //making sure thisTime is 5 characters long string. needed to avoid string out-of-bounds indices
                                            if(thisTime.length() == 4)
                                                thisTime = "0" + thisTime;

                                            //making sure NextAvailableTimeForForm is 5 characters long string. needed to avoid string out-of-bounds indices
                                            if(NextAvailableTimeForForm.length() == 4)
                                                NextAvailableTimeForForm = "0" + NextAvailableTimeForForm;

                                            //Getting Time parts (HH and MM)
                                            int TempThisHour = Integer.parseInt(thisTime.substring(0,2));
                                            int TempThisMinute = Integer.parseInt(thisTime.substring(3,5));
                                            int AppointmentHour = Integer.parseInt(NextAvailableTimeForForm.substring(0,2));
                                            int AppointmentMinute = Integer.parseInt(NextAvailableTimeForForm.substring(3,5));

                                            if(TempThisHour > AppointmentHour && (QueueDate.equals(Today))){}

                                            else if(TempThisHour == AppointmentHour && (QueueDate.equals(Today))){

                                                if(TempThisMinute <= AppointmentMinute){
                                        
                                    
                                    %>
                                    
                                        
                                                    <input style="background-color: lightblue; padding: 5px; border: 1px solid black;" type="submit" value="Block this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                       
                                    <%          }
                                            }else if(TempThisHour < AppointmentHour && (QueueDate.equals(Today))) {
                                    %>
                                    
                                                    <input style="background-color: lightblue; padding: 5px; border: 1px solid black;" type="submit" value="Block this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                    
                                    <%      }else if(!QueueDate.equals(Today)){%>
                                    
                                                    <input style="background-color: lightblue; padding: 5px; border: 1px solid black;" type="submit" value="Block this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                    
                                    <%}%>
                                    
                                            </form>
                                        
                                    <%}%>
                                    
                                        <center><p style="padding-bottom: 10px;">Summary: <span style="color: blue;"><%=HowManyColums%> spots,</span> <span style="color: red;"> <%=TotalUnavailableList%> booked,</span> <span style="color: green;"> <%=TotalThisCustomerTakenList%> blocked</span></p></center>
                                    
                                        <p style=""><span style="color: blue; border: 1px solid blue;"><img src="icons/icons8-standing-man-filled-50 (1).png" width="30" height="25" alt="icons8-standing-man-filled-50 (1)"/>
                                        Not Taken </span> <span style="color: red; border: 1px solid red;"><img src="icons/icons8-standing-man-filled-50.png" width="30" height="25" alt="icons8-standing-man-filled-50"/>
                                        Taken </span> <span style="color: green; border: 1px solid green; padding-right: 3px;"><img src="icons/icons8-standing-man-filled-50 (2).png" width="30" height="25" alt="icons8-standing-man-filled-50 (2)"/>
                                        Blocked Spot </span> </p>

                                    </div></center>
                <!------------------------------------------------------------------------------------------------------------------------------------------------------------>
                                
                                <center><div style="width: 100%; max-width: 600px; background-color: #eeeeee;">
                                    <form style="" id="BlockFutureSpotsForm" name="BlockFutureSpots" action="BlockFutureSpots.jsp">
                                        <p style="text-align: center;">Get More Spots</p>
                                        <p style="text-align: center; color: #000099; margin-top: 5px;">Choose date to block future spots</p>
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <input style="border: 1px solid black; background-color: white; padding: 2px;" id="Fdatepicker" type="text" name="GetDate" value="" readonly/><br/>
                                        <input id="GenerateSpotsBtn" style="padding: 5px; border: 1px solid black; background-color: pink; border-radius: 4px;" type="submit" value="Generate Spots" name="GenerateSpots" />
                                    </form>
                                </div></center>
                    
                                <script>
                                    $( 
                                        function(){
                                            $( "#Fdatepicker" ).datepicker({
                                                minDate: 0
                                            });
                                        } 
                                    );

                                    function checkFdatePicker(){

                                        var Fdatepicker = document.getElementById("Fdatepicker");
                                        var GenerateSpotsBtn = document.getElementById("GenerateSpotsBtn");

                                        if(Fdatepicker.value === ""){
                                            GenerateSpotsBtn.style.backgroundColor = "darkgrey";
                                            GenerateSpotsBtn.disabled = true;
                                        }
                                        else{
                                            GenerateSpotsBtn.style.backgroundColor = "pink";
                                            GenerateSpotsBtn.disabled = false;

                                        }


                                    }

                                     setInterval(checkFdatePicker,1);

                                </script>

                                <center><a href="ServiceProviderPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="width: 100%; max-width: 590px; padding: 5px; background-color: pink; color: white; text-align:center; ">Go to your dashboard</p></a></center>

                <%
                        
                    //ArrayList that stores all Appointments for selected date on this page
                    ArrayList<BookedAppointmentList> AppointmentList = new ArrayList<>();
                        
                    //Getting this day's Appointments
                    try{
                        
                        /*
                           MM/dd/yyyy is the default Java Date Format
                           yyyy-MM-dd is the default SQL Date
                        */
                        
                        //SpotsDate is in this formate which looks similar from default date format from java Date() class
                        SimpleDateFormat appointmentsSdf = new SimpleDateFormat("MM/dd/yyyy");
                        java.util.Date MainAppointmentDate = appointmentsSdf.parse(SpotsDate); //Parsing String SpotsDate to a date Obj in the format of appointmentSdf

                        SimpleDateFormat currentDateFormat = new SimpleDateFormat("yyyy-MM-dd"); //Another Date format that can be understood by SQL
                        String StrinCurrentdate = currentDateFormat.format(MainAppointmentDate); //Now Formatting previously created date obj for SQL
                        //JOptionPane.showMessageDialog(null, StrinCurrentdate);

                        Class.forName(Driver);
                        Connection appointmentConn = DriverManager.getConnection(Url, user, password);
                        String appointment = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? order by AppointmentTime asc";
                        PreparedStatement appointmentPst = appointmentConn.prepareStatement(appointment);

                        appointmentPst.setInt(1,ProviderID);
                        appointmentPst.setString(2, StrinCurrentdate); //StringCurrentDate Contains SQL Date Format Equivalent of SpotsDate from Request Obj
                        ResultSet rows = appointmentPst.executeQuery();

                        BookedAppointmentList ListItem;

                        while(rows.next()){
                            
                            //skip Blocked Spots (don't include them in the appointments list
                            String Reason = rows.getString("OrderedServices").trim();
                            if(Reason.equals("Blocked Time")){

                                continue;

                            }

                            String CustomerID = rows.getString("CustomerID");
                            String customerFirstName = "";
                            String customerMiddleName = "";
                            String customerLastName = "";
                            String customerFullName = "";
                            String customerEmail = "";
                            String customerPhone = "";
                            Blob customerPic = null;


                            try{
                                Class.forName(Driver);
                                Connection customerConn = DriverManager.getConnection(Url, user, password);
                                String customerSelect = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                                PreparedStatement customerPst = customerConn.prepareStatement(customerSelect);
                                customerPst.setString(1, CustomerID);
                                ResultSet customerInfo = customerPst.executeQuery();


                                while(customerInfo.next()){

                                    customerFirstName = customerInfo.getString("First_Name").trim();
                                    customerMiddleName = customerInfo.getString("Middle_Name").trim();
                                    customerLastName = customerInfo.getString("Last_Name").trim();
                                    customerFullName = customerFirstName + " " + customerMiddleName + " " + customerLastName;
                                    customerEmail = customerInfo.getString("Email").trim();
                                    customerPhone = customerInfo.getString("Phone_Number").trim();
                                    customerPic = customerInfo.getBlob("Profile_Pic");

                                }

                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }

                            String AppointmentTime = rows.getString("AppointmentTime").substring(0,5);

                            int AppointmentID = rows.getInt("AppointmentID");
                            int providerID = ProviderID;

                            Date AppointmentDate = rows.getDate("AppointmentDate");

                            ListItem = new BookedAppointmentList(AppointmentID, providerID, customerFullName, null, customerPhone, customerEmail, AppointmentDate, AppointmentTime, customerPic);
                            ListItem.setAppointmentReason(Reason);
                            AppointmentList.add(ListItem);

                        }
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                %>

            <div class="scrolldiv" style=" height: 400px; overflow-y: auto;">
                
                <%
                    Date JSCurrentDate = new Date();
                    JSCurrentTime = JSCurrentDate.toString().substring(11,16);
                %>
                
                <script>
                                    
                        var currentDate = new Date();
                        var currentTime = '<%=JSCurrentTime%>';
                                                        
                        var currentHour = currentTime.substring(0,2);
                        var currentMinute = currentTime.substring(3,5);

                        var currentMonth = currentDate.getMonth();
                        currentMonth += 1;
                        currentMonth += "";

                        if(currentMonth.length < 2)
                        currentMonth = "0" + currentMonth;

                        var currentDay = currentDate.getDate() + "";

                        if(currentDay.length < 2)
                            currentDay = "0" + currentDay;

                        var currentYear = currentDate.getFullYear();

                        currentDate = currentMonth + "/" + currentDay + "/" + currentYear;
                        var currentDate2 = currentYear + "-" + currentMonth + "-" + currentDay;
                                                         
                </script>
                    
                <%
                    //formatting date for taken spots list
                    SimpleDateFormat TKSDF1 = new SimpleDateFormat("MM/dd/yyyy");
                    Date TKDate = TKSDF1.parse(SpotsDate);
                    String TKDayOfWeek = TKDate.toString().substring(0,3);
                    SimpleDateFormat TKSDF = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMM dd, yyyy");
                    String TKStringDate = TKSDF.format(TKDate);
                    
                    
                %>
                
                <div id="CurrentProvAppointmentsDiv">
                            <center><h4 style="margin: 5px; color: white;">Taken Spots on <%=TKDayOfWeek%>, <%=TKStringDate%></h4></center>
                <center><table id="ProviderAppointmentList" style="border-spacing: 5px; border: 0; width: 100%; max-width: 600px;">
                        <tbody>
                            
    <%
                      for(int w = 0; w < AppointmentList.size(); w++){
                      
                          String WString = Integer.toString(w);
                          int AppointmentID = AppointmentList.get(w).getAppointmentID();
                          
                          //note all providerinfo here is customer instead but this is an error from DataStructure inconsistency
                          String Name = AppointmentList.get(w).getProviderName();
                          String Tel = AppointmentList.get(w).getProviderTel();
                          String email = AppointmentList.get(w).getProviderEmail();
                          String Time = AppointmentList.get(w).getTimeOfAppointment();
                          String AppointmentReason = AppointmentList.get(w).getReason().trim();
                          String Base64CustPic = "";
                          
                          try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = AppointmentList.get(w).getDisplayPic(); 
                            InputStream inputStream = profilepic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                             Base64CustPic = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}

                          
                        String TimeToUse = "";
                        int Hours = Integer.parseInt(Time.substring(0,2));
                        String Minutes = Time.substring(2,5);

                        if( Hours > 12)
                        {
                            int TempHour = Hours - 12;
                            TimeToUse = Integer.toString(TempHour) + Minutes + "pm";
                        }
                        else if(Hours == 0){
                            TimeToUse = "12" + Minutes + "am";
                        }
                        else if(Hours == 12){
                            TimeToUse = Time + "pm";
                        }
                        else{
                            TimeToUse = Time +"am";
                        }
                
                          
                        Date date = AppointmentList.get(w).getDateOfAppointment();
                          
                        SimpleDateFormat sdf2 = new SimpleDateFormat("MMMMMMMMMMMMMMMMMMMMMMM dd, yyyy");
                        String DateOfAppointment = sdf2.format(date);
                          
    %>
                        <tr>
                            <td style = "padding: 5px; background-color: white; margin: 5px; border: 0; border-right: 1px solid darkgrey; border-bottom: 1px solid darkgray;">
                <%
                    if(Base64CustPic != ""){
                %>
                <center><div style="width: 100%; max-width: 600px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;">
                 <img style="border-radius: 100%; border: 2px solid green; margin-bottom: 0; float: left; background-color: darkgray;" src="data:image/jpg;base64,<%=Base64CustPic%>" width="40" height="40"/>
                    </div></center>
                <%
                    }
                %>
                   
                        <center><p><img src="icons/icons8-user-15.png" width="15" height="15" alt="icons8-user-15"/>
                                <span style="color: red;"><%=Name%></span> at <span style="color: red;"><%=TimeToUse%></span></p></center>
                                <center><p><img src="icons/icons8-new-post-15.png" width="15" height="15" alt="icons8-new-post-15"/> <%=email%>, 
                                    <img src="icons/icons8-phone-15.png" width="15" height="15" alt="icons8-phone-15"/> <%=Tel%></p></center>
                                    <p style="text-align: center; color: darkgrey;">- <%=AppointmentReason%> -</p>
                              
                                <center>
                                    <form style=" display: none;" id="changeBookedAppointmetForm<%=WString%>" class="changeBookedAppointmentForm" name="changeAppointment" action="BlkSptUpdateAppointment" method="POST">
                                        <p style ="margin-top: 10px;">Reschedule This Customer</p>
                                        <input id="datepicker<%=WString%>" style="background-color: white;" type="text" name="AppointmentDate" value="<%=date%>"/>
                                        <input id="timeFld<%=WString%>" style="background-color: white;" type="hidden" name="ApointmentTime" value="<%=Time%>"/>
                                        <input id="timePicker<%=WString%>" style="background-color: white;" type="text" name="ApointmentTimePicker" value="<%=Time%>"/>
                                        <p id="timePickerStatus<%=WString%>" style="margin-bottom: 3px; background-color: red; color: white; text-align: center;"></p>
                                        <p id="datePickerStatus<%=WString%>" style="background-color: red; color: white; text-align: center;"></p>
                                        <input type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="GetDate" value="<%=SpotsDate%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <input id="changeAppointmentBtn<%=WString%>" style="background-color: pink; border: 1px solid black; color: black; padding: 3px;" name="<%=WString%>changeAppointment" type="submit" value="Reschedule" />
                                        
                                        <script>
                                               
                                                    $('#timePicker<%=WString%>').timepicker({
                                                         timeFormat: 'h:mm p',
                                                         interval: 15,
                                                         minTime: '00',
                                                         maxTime: '11:59pm',
                                                         defaultTime: '00',
                                                         startTime: '00',
                                                         dynamic: false,
                                                         dropdown: true,
                                                         scrollbar: true
                                                     });

                                                     function CheckCurrentTimeChooser(){
                                                         
                                                         var tempTime = document.getElementById("timePicker<%=WString%>").value;
                                                         var tempDate = document.getElementById("datepicker<%=WString%>").value;

                                                         if(tempTime.length === 7)
                                                              tempTime = "0" + tempTime;

                                                          var tempHour = "";
                                                          var tempMinute = tempTime.substring(2,5);
                                                         
                                                         if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) !== '12'){
                                                             document.getElementById("timeFld<%=WString%>").value = tempTime.substring(0,5);
                                                         }
                                                         else if(tempTime.substring(6,8) === 'AM' && tempTime.substring(0,2) === '12'){
                                                             document.getElementById("timeFld<%=WString%>").value = "00" + tempMinute;
                                                         }
                                                         else{


                                                             tempHour = parseInt(tempTime.substring(0,2),10) + 12;
                                                             if(tempHour === 24)
                                                                 tempHour = 12;
                                                             
                                                             document.getElementById("timeFld<%=WString%>").value = tempHour + tempMinute;
                                                             
                                                         }
                                                         
                                                        if( currentDate === tempDate || currentDate2 === tempDate ){
                                                             
                                                            if( (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(0,2), 10)) < (parseInt(currentHour, 10)) ){
                                                                document.getElementById("timeFld<%=WString%>").value = currentTime;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkgrey";
                                                                document.getElementById("timePickerStatus<%=WString%>").innerHTML = "Time cannot be in the past";
                                                            }
                                                            else if( (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(0,2), 10)) === (parseInt(currentHour, 10)) &&
                                                                     (parseInt(document.getElementById("timeFld<%=WString%>").value.substring(3,5), 10)) < (parseInt(currentMinute, 10)) ){
                                                                        document.getElementById("timeFld<%=WString%>").value = currentTime;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = true;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "darkgrey";
                                                                        document.getElementById("timePickerStatus<%=WString%>").innerHTML = "Time cannot be in the past";
                                                            }else{

                                                                document.getElementById("timePickerStatus<%=WString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "pink";

                                                            }
                                                        
                                                        }else{
                                                            
                                                            document.getElementById("timePickerStatus<%=WString%>").innerHTML = "";
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").disabled = false;
                                                            document.getElementById("changeAppointmentBtn<%=WString%>").style.backgroundColor = "pink";
                                                            
                                                        }

                                                     }

                                                     setInterval(CheckCurrentTimeChooser,1);
                                                     
                                                 </script>
                                        
                                        <script>
                                                
                                                            $( 
                                                                    function(){
                                                                            $( "#datepicker<%=WString%>" ).datepicker({
                                                                                minDate: 0,
                                                                            });
                                                                    } 
                                                             );
                                                            
                                                        //---------------------------------------------
                                                         //var datepicker = document.getElementById("datepicker<%=WString%>");
                                                         //var datePickerStatus = document.getElementById("datePickerStatus<%=WString%>");

                                                         
                                                         document.getElementById("datePickerStatus<%=WString%>").innerHTML = "";


                                                         function checkDateUpdateValue(){

                                                                 if((new Date(document.getElementById("datepicker<%=WString%>").value)) < (new Date())){

                                                                                 if(document.getElementById("datepicker<%=WString%>").value === currentDate){

                                                                                         if(document.getElementById("datePickerStatus<%=WString%>").innerHTML === ""){
                                                                                                 document.getElementById("datePickerStatus<%=WString%>").innerHTML = "Today's Date: " + currentDate;
                                                                                                 document.getElementById("datePickerStatus<%=WString%>").style.backgroundColor = "green";
                                                                                         }

                                                                                 }
                                                                                 else{
                                                                                         //document.getElementById("datePickerStatus<=WString%>").innerHTML = "Only today's date or future date allowed";
                                                                                         //document.getElementById("datePickerStatus<=WString%>").style.backgroundColor = "red";
                                                                                         //document.getElementById("datepicker<=WString%>").value = currentDate;
                                                                                 }
                                                                 }
                                                                 else{

                                                                         document.getElementById("datePickerStatus<%=WString%>").innerHTML = "";
                                                                         //datePickerStatus.innerHTML = "Chosen Date: " + datepicker.value;
                                                                         //datePickerStatus.style.backgroundColor = "green";
                                                                 }

                                                         }

                                                         setInterval(checkDateUpdateValue, 1);                                        
                                                             
                                            </script>
                                        
                                    </form>
                                </center>
                                    
                                    <form id="addFavProvForm<%=WString%>">
                                    </form>
                                
                                <center><form style=" display: none;" id="deleteAppointmentForm<%=WString%>" class="deleteAppointmentForm" name="confirmDeleteAppointment" action="BlkSptDeleteAppointment" method="POST">
                                    <p style="color: red; margin-top: 10px;">Are you sure you want to remove this customer</p>
                                    <p><input style="background-color: red; border: 1px solid black; color: white; padding: 3px; cursor: pointer;" name="<%=WString%>deleteAppointment" type="submit" value="Yes" />
                                    <span onclick = "hideDelete(<%=WString%>)" style="background-color: blue; border: 1px solid black; color: white; padding: 3px; cursor: pointer;"> NO</span></p>
                                    <input type="hidden" name="AppointmentID" value="<%=AppointmentID%>" />
                                    <input type="hidden" name="GetDate" value="<%=SpotsDate%>" />
                                    <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                    <input type="hidden" name="User" value="<%=NewUserName%>" />
                                    </form></center>
                                
                                <p style="text-align: right; padding-right: 20px;">
                                    <a style="margin-right: 5px; cursor: pointer;" ><img onclick = "toggleChangeAppointment(<%=WString%>)" style="margin-top: 10px;" src="icons/icons8-pencil-20.png" width="20" height="20" alt="icons8-pencil-20"/></a> 
                                    <a><img style="cursor: pointer;" onclick = "toggleHideDelete(<%=WString%>)" src="icons/icons8-trash-20.png" width="20" height="20" alt="icons8-trash-20"/></a></p>
                            </td>
                        </tr>
                        
                        <%} //end of for loop
                            
                            if(AppointmentList.size() == 0){
                        
                        %>
                        
                        <center><p style="color: white; background-color: red; margin-bottom: 30px; margin-top: 30px;">No line for selected date</p></center>
                        <%} //end of if block%>
                    </tbody>
                    </table></center>
                
                </div>
            </div>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    
</html>
