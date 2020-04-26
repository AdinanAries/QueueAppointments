<%-- 
    Document   : BlockFutureSpots
    Created on : Jun 3, 2019, 10:13:16 AM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
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
        <link rel="manifest" href="/manifest.json" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Available Future Spots</title>
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <!--link rel="stylesheet" href="/resources/demos/style.css"-->
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />

    </head>
    
    <body onload="document.getElementById('PageLoader').style.display = 'none';" style="background-color: #7e7e7e; position: absolute; width: 100%;">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <h3 style="text-align: center; margin: 5px; color: white;">Available Future Spots</h3>
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------>
               
                <center><div id="QueuLineDiv" style="width: 100%; max-width: 600px;">
                                        
                <%
                    
                        String NewUserName = "";
                        int UserID = 0;
                        int UserIndex = 0;
                        String tempAccountType = "";

                        String Url = "";
                        String Driver = "";
                        String user = "";
                        String password = "";

                        try{
                            NewUserName = request.getParameter("User");

                            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
                            //JOptionPane.showMessageDialog(null, UserIndex);

                            tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

                            if(tempAccountType.equals("CustomerAccount"))
                                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();

                            if(tempAccountType.equals("BusinessAccount")){
                                request.setAttribute("UserIndex", UserIndex);
                                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
                            }

                            /*else if(UserID == 0)
                                response.sendRedirect("LogInPage.jsp");*/

                            Url = config.getServletContext().getAttribute("DBUrl").toString();
                            Driver = config.getServletContext().getAttribute("DBDriver").toString();
                            user = config.getServletContext().getAttribute("DBUser").toString();
                            password = config.getServletContext().getAttribute("DBPassword").toString();
                        }catch(Exception e){
                            response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
                        }
                        
                        String ProviderID = request.getParameter("ProviderID");
                        int CustomerID = UserID;
                        String SpotsDate = request.getParameter("GetDate");
                        
                        String ServicesList = request.getParameter("ServicesList");
                        String TaxedPrice = request.getParameter("TaxedPrice"); 
                         
                        int IntervalsValue = 30;
        
                        try{

                            Class.forName(Driver);
                            Connection intervalsConn = DriverManager.getConnection(Url, user, password);
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
                        
                        int d = 0;
                        
                        
                        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                        java.util.Date DayOfAppointment = sdf.parse(SpotsDate);
                        String QueueDate = sdf.format(DayOfAppointment);

                         
                        String CurrentTime = DayOfAppointment.toString().substring(11,16);
                        
            
        
                                        Date currentDate = DayOfAppointment;//default date constructor returns current date 
                                        String JSCurrentTime = currentDate.toString().substring(11,16); //forJavaScript;
                                        String DayOfWeek = currentDate.toString().substring(0,3);
                                        SimpleDateFormat formattedDate = new SimpleDateFormat("MMM dd"); //formatting date to a string value of month day, year
                                        String stringDate = formattedDate.format(currentDate); //calling format function to format date object
                                        SimpleDateFormat QuerySdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String QueryDate = QuerySdf.format(currentDate);
                                        
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllAvailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllThisProviderBlockedTime = new ArrayList<>();
                                        ArrayList<String> AllThisProviderBlockedFormattedTakenTime = new ArrayList<>();
                                        ArrayList<String> BlockedAppointmentIDs = new ArrayList<>();
                                        
                                        String DailyStartTime = "";
                                        String DailyClosingTime = "";
                                        String FormattedStartTime = "";
                                        String FormattedClosingTime = "";
                                        int startHour = 0;
                                        int startMinute = 0;
                                        int closeHour = 0;
                                        int closeMinute = 0;
                                        
                                        int TotalAvailableList = 0;
                                        int TotalUnavailableList = 0;
                                        int TotalThisCustomerTakenList = 0;
                                    %>
                                    
                                    <%
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
                                            DateForCompareSdf = new SimpleDateFormat("MM/dd/yyyy");
                                            DateForClosedCompare = sdf.parse(SpotsDate);
                                        
                                        }catch(Exception e){}
                                        
                                        //Date DateForClosedCompare = new Date();
                                        SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare);
                                        
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection CloseddConn = DriverManager.getConnection(Url, user, password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setString(1, ProviderID);
                                            
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
                                        
                                        
                                        //do all this for status led
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
                                        
                                        String NextAvailableTime = "" ;
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
                                        
                                        while(NextThirtyMinutes >= 60){
                                            
                                            ++NextHour;
                                            
                                            if(DailyClosingTime != ""){
                                                
                                                if(NextHour > closeHour && closeHour != 0){

                                                    NextHour = closeHour - 1;

                                                }
                                                else if(closeHour == 0)
                                                    NextHour = 23;
                                                    
                                            }else if(NextHour > 23){
                                                NextHour = 23;
                                            }
                                            
                                            
                                            
                                            if(NextThirtyMinutes > 60)
                                                NextThirtyMinutes -= 60;
                                            
                                            else if(NextThirtyMinutes == 60)
                                                NextThirtyMinutes = 0;
                                        }
                                        
                                        //use this if there is no appointment for the next hour
                                        while(ActualThirtyMinutesAfter >= 60){
                                            
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
                                        int twoHours = CurrentHour + 23;
                                        
                                        if(DailyClosingTime != ""){
                                            
                                            if(twoHours > closeHour && closeHour != 0){

                                                    twoHours = closeHour - 1;

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
                                                 
                                    <p style="color: tomato;">Not open on <%=DayOfWeek%>...</p>
                                    
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
                                    <center><p>Select any <span style="color: blue;">blue </span> spot take the position</p></center>
                                    
                                    <center><div class="scrolldiv" style="width: 95%; max-width: 600px; overflow-x: auto;">
                                    
                                    <table style="width:100%; max-width: 600px;">
                                        <tbody>
                                            <tr>
                                                
                                            <%
                                                int HowManyColums = 0;
                                                int BookedSpots = 0;
                                                boolean isLineAvailable = false;
                                                boolean broken = false;
                                                
                                                for(int x = CurrentHour; x < twoHours;){
                                                    
                                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                                        break;
                                                   
                                                    for(y = CurrentMinute; y <= 60;){
                                                        
                                                        if(broken){
                                                            break;
                                                        }
                                                        
                                            %>
                                            
                                            <%
                                                String AppointmentID = "";
                                                 
                                                try{
                                                    
                                                    Class.forName(Driver);
                                                    Connection LineDivConn = DriverManager.getConnection(Url, user, password);
                                                    String LineDivString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                                    
                                                    PreparedStatement LineDivPst = LineDivConn.prepareStatement(LineDivString);
                                                    LineDivPst.setString(1, ProviderID);
                                                    LineDivPst.setString(2, QueryDate);
                                                    LineDivPst.setString(3, CurrentTime);
                                                    LineDivPst.setString(4, NextAvailableTime);
                                                    
                                                    ResultSet LineDivRow = LineDivPst.executeQuery();
                                                    
                                                    while(LineDivRow.next()){
                                                        
                                                        bookedTimeFlag = 1;
                                                        
                                                        int CustID = LineDivRow.getInt("CustomerID");
                                                        
                                                        
                                                        if(CustID == CustomerID){
                                                            
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
                                                
                                            <%  }
                                            
                                                bookedTimeFlag = 0;
                                            
                                            %>
                                                <!--td>9:30am<img src="icons/icons8-standing-man-filled-50.png" width="50" height="50" alt="icons8-standing-man-filled-50"/>
                                                </td-->
                                            <% 
                                                        
                                                        y += IntervalsValue;
                                                        
                                                        while(y >= 60){
                                                             
                                                            x++;
                                                            
                                                            if(y > 60)
                                                                y -= 60;
                                                            else if(y == 60)
                                                                y = 0;
                                                             
                                                            if(x > twoHours){
                                                               //breaking out of this inner loop  
                                                               //incidentally the condition of outer loop becomes false
                                                               //thereby exiting as well
                                                               broken = true;
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
                                        
                                   <p style="background-color: green; color: white; text-align: center;">Position at <%=NextThisAvailableTimeForDisplay%> is your spot.</p>
                                        
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
                                        
                                        
                                    
                                    <%      }
                                        }else if(TempThisHour < AppointmentHour && QueueDate.equals(Today)) {
                                    %>
                                    
                                        
                                    
                                    <%} else if(!QueueDate.equals(Today)){%>
                                    
                                        
                                    
                                    <%}%>
                                    
                                    </form>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        for(int z = 0; z < AllUnavailableTimeList.size(); z++){
                                            
                                            String NextUnavailableTimeForMessage = AllUnavailableFormattedTimeList.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>
                                   
                                    <p style="background-color: red; margin-bottom: 5px; color: white; text-align: center; display: none;" id="LineTakenMessage<%=t%><%=q%>"><%=NextUnavailableTimeForMessage%> is unavailable. This and every red spot has been taken.</p>
                                    
                                    <%}%>
                                    
                                    <%
                                        if(!isLineAvailable){
                                    %>
                                    
                                    <p style="background-color: red; color: white; text-align: center;">There is no line currently available for this service provider</p>
                                    
                                    <%}%>
                                    
                                    <%
                                        
                                        for(int z = 0; z < AllAvailableTimeList.size(); z++){
                                            
                                            String NextAvailableTimeForForm = AllAvailableTimeList.get(z);
                                            String NextAvailableTimeForFormDisplay = AllAvailableFormattedTimeList.get(z);
                                            
                                            int t = d + 1;
                                            int q = z + 1;
                                            
                                    %>
                                    
                                    <form style="display: none;" id="bookAppointmentFromLineDiv<%=t%><%=q%>" name="bookAppointmentFromLineDiv" action="FinishAppointmentFromFutureLoggedIn.jsp" method="POST">
                                       
                                        
                                        
                                        <input type="hidden" name="formsDateValue" value="<%=QueryDate%>" />
                                        <input type="hidden" name="AppointmentTime" value="<%=NextAvailableTimeForForm%>" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                        <input type="hidden" name="ServicesList" value="<%=ServicesList%>" />
                                        <input type="hidden" name="TaxedPrice" value="<%=TaxedPrice%>" />
                                        
                                        <%
                                            //ResendAppointmentData.AppointmentDate = SpotsDate;
                                        %>
                                        
                                        
                                        
                                        
                                        <%
                                        if(thisTime.length() == 4)
                                            thisTime = "0" + thisTime;
                                        if(NextAvailableTimeForForm.length() == 4)
                                            NextAvailableTimeForForm = "0" + NextAvailableTimeForForm;
                                        
                                        int TempThisHour = Integer.parseInt(thisTime.substring(0,2));
                                        int TempThisMinute = Integer.parseInt(thisTime.substring(3,5));
                                        int AppointmentHour = Integer.parseInt(NextAvailableTimeForForm.substring(0,2));
                                        int AppointmentMinute = Integer.parseInt(NextAvailableTimeForForm.substring(3,5));
                                        
                                        if(TempThisHour > AppointmentHour && (QueueDate.equals(Today))){
                                        %>
                                        
                                        <p style="text-align: center; background-color: red; color: white; margin-bottom: 5px;"><%=NextAvailableTimeForFormDisplay%> is past. You cannot take this spot</p>
                                        
                                        <%}
                                        
                                        else if(TempThisHour == AppointmentHour && (QueueDate.equals(Today))){
                                            
                                            if(TempThisMinute <= AppointmentMinute){
                                        
                                    
                                    %>
                                    
                                        
                                        <input style="" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Take this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                       
                                    <%      }else{   %>

                                        <p style="text-align: center; background-color: red; color: white; margin-bottom: 5px;"><%=NextAvailableTimeForFormDisplay%> is past. You cannot take this spot</p>

                                    <%       }
                                        }else if(TempThisHour < AppointmentHour && (QueueDate.equals(Today))) {
                                    %>
                                    
                                        <input style="" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Take this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                    
                                    <%}else if(!QueueDate.equals(Today)){%>
                                    
                                        <input style="" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Take this spot - [ <%=NextAvailableTimeForFormDisplay%> ]" name="QueueLineDivBookAppointment" />
                                    
                                    <%}%>
                                    
                                    </form>
                                        
                                    <%}%>
                                    
                                        <!--center><p style="padding-bottom: 10px;">Summary: <span style="color: blue;"><=HowManyColums%> spots,</span> <span style="color: red;"> <=TotalUnavailableList%> booked,</span> <span style="color: green;"> <=TotalThisCustomerTakenList%> blocked</span></p></center-->
                                    
                                        <p style=""><span style="color: blue; border: 1px solid blue;"><img src="icons/icons8-standing-man-filled-50 (1).png" width="30" height="25" alt="icons8-standing-man-filled-50 (1)"/>
                                        Available </span> <span style="color: red; border: 1px solid red;"><img src="icons/icons8-standing-man-filled-50.png" width="30" height="25" alt="icons8-standing-man-filled-50"/>
                                        Taken </span> <span style="color: green; border: 1px solid green; padding-right: 3px;"><img src="icons/icons8-standing-man-filled-50 (2).png" width="30" height="25" alt="icons8-standing-man-filled-50 (2)"/>
                                        Your Spot </span> </p>

                                    </div></center>
                <!------------------------------------------------------------------------------------------------------------------------------------------------------------>
                            
                <center><div style="width: 100%; max-width: 600px;">
                            <div style="background-color: #eeeeee; padding: 2px; border-top: 1px solid darkgray; border-bottom: 1px solid darkgray;">
                                <p id="showFutureSpotsBtn" style="text-align: center; cursor: pointer;">Find More Spots</p>
                                    
                                    <center><div>
                                    <form style="" id="BlockFutureSpotsForm" name="BlockFutureSpots" action="GenerateFutureSpots.jsp">
                                        <p style="text-align: center; color: #000099; margin-top: 5px;">Choose date to get spots</p>
                                        <input style="border: 1px solid black; background-color: white; padding: 2px;" id="Fdatepicker" type="text" name="GetDate" value="" readonly/><br/>
                                        
                                        <!--input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" /-->
                                        
                                        <input type="hidden" name="UserIndex" value="<%=UserIndex%>" />
                                        <input type="hidden" name="User" value="<%=NewUserName%>" />
                                        <input type="hidden" name="ProviderID" value="<%=ProviderID%>" />
                                        <input type="hidden" name="ServicesList" value="<%=ServicesList%>" />
                                        <input type="hidden" name="TaxedPrice" value="<%=TaxedPrice%>" />
                                        
                                        <input id="GenerateSpotsBtn" style="padding: 5px; border: none; background-color: darkslateblue; border-radius: 4px;" onclick="document.getElementById('PageLoader').style.display = 'block';" type="submit" value="Generate Spots" name="GenerateSpots" />
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
                                            GenerateSpotsBtn.style.backgroundColor = "darkslateblue";
                                            GenerateSpotsBtn.disabled = false;
                                            
                                        }
                                            
                                        
                                    }
                                    
                                    setInterval(checkFdatePicker,1);
                                   
                                    
                                </script>
                                
                            </div>
                            <a onclick="document.getElementById('PageLoader').style.display = 'block';" href="ProviderCustomerPage.jsp?UserIndex=<%=UserIndex%>&User=<%=NewUserName%>"><p style="padding: 5px; background-color: pink; text-align: center; ">Go to your dashboard</p></a>
    
                    </div></center>
    </body>
    
    <script src="scripts/script.js"></script>
    <script src="scripts/QueueLineDivBehavior.js"></script>
    
</html>
