/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
public class providerDeleteAppointment extends HttpServlet {
    
    String Driver = "";
    String URL = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
                
        URL = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String AppointmentID = request.getParameter("AppointmentID");
        String ProviderID = "";
        String CustomerID = "";
        String AppointmentTime = "";
        String AppointmentDate = "";
        
        //getting Provider and CustomerIDs
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String Delete = "Select * From QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement pst = conn.prepareStatement(Delete);
            pst.setString(1, AppointmentID);
            ResultSet ApptRecs = pst.executeQuery();
            
            while(ApptRecs.next()){
                ProviderID = ApptRecs.getString("ProviderID");
                CustomerID = ApptRecs.getString("CustomerID");
                AppointmentTime = ApptRecs.getString("AppointmentTime").trim();
                AppointmentDate = ApptRecs.getString("AppointmentDate").trim();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String Delete = "Delete From QueueObjects.BookedAppointment where AppointmentID = ?";
            PreparedStatement pst = conn.prepareStatement(Delete);
            pst.setString(1, AppointmentID);
            pst.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        //response.sendRedirect("ServiceProviderPage.jsp");
        
        //-------------------------------------------------------------------------------------------
                Date NotiDate = new Date();
                String NotiSDate = NotiDate.toString();
                SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
                String date = NotiDformat.format(NotiDate);
                String time = NotiSDate.substring(11,16);
                
                String ProvName = "", Company = "";
                
                try{
                    Class.forName(Driver);
                    Connection ProvConn = DriverManager.getConnection(URL, user, password);
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
                    Connection notiConn = DriverManager.getConnection(URL, user, password);
                    String notiString = "insert into ProviderCustomers.Notifications (Noti_Type, CustID, If_From_Prov, What, Noti_Date, Noti_Time)"
                            + "values (?,?,?,?,?,?)";
                    PreparedStatement notiPst = notiConn.prepareStatement(notiString);
                    notiPst.setString(1, "Appointment");
                    notiPst.setString(2, CustomerID);
                    notiPst.setString(3, ProviderID);
                    notiPst.setString(4, "Your spot (" + AppointmentTime.substring(0,5) + " - " + AppointmentDate + ") with " + ProvName + " of " + Company + " has been removed by " + ProvName);
                    notiPst.setString(5, date);
                    notiPst.setString(6, time);
                    notiPst.executeUpdate();
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
        
        //JOptionPane.showMessageDialog(null, "Appointment deleted successfully");
        response.getWriter().print("Appointment deleted successfully");
        
       
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
