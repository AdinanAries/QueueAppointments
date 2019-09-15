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
import javax.swing.JOptionPane;


public class DeleteAppointment extends HttpServlet {
        
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
    
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String AppointmentID = request.getParameter("AppointmentID");
        String AppointmentTime = "";
        String AppointmentDate = "";
        String CustomerID = "";
        String ProviderID = "";
        
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
                if(AppointmentTime.length() > 5)
                    AppointmentTime = AppointmentTime.substring(0,5);
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
        
        //-------------------------------------------------------------------------------------------
                Date NotiDate = new Date();
                String NotiSDate = NotiDate.toString();
                SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
                String date = NotiDformat.format(NotiDate);
                String time = NotiSDate.substring(11,16);
                
                String CustName = "", CustTel = "";
                
                try{
                    Class.forName(Driver);
                    Connection CustConn = DriverManager.getConnection(URL, user, password);
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
                    Connection notiConn = DriverManager.getConnection(URL, user, password);
                    String notiString = "insert into QueueServiceProviders.Notifications (Noti_Type, ProvID, If_From_Cust, What, Noti_Date, Not_Time)"
                            + "values (?,?,?,?,?,?)";
                    PreparedStatement notiPst = notiConn.prepareStatement(notiString);
                    notiPst.setString(1, "Appointment");
                    notiPst.setString(2, ProviderID);
                    notiPst.setString(3, CustomerID);
                    notiPst.setString(4,  CustName + " - " + CustTel + " - Cancelled his spot for " + AppointmentTime + " on " + AppointmentDate);
                    notiPst.setString(5, date);
                    notiPst.setString(6, time);
                    notiPst.executeUpdate();
                    
                }catch(Exception e){
                    e.printStackTrace();
                }
        
        //response.sendRedirect("ProviderCustomerPage.jsp");
        JOptionPane.showMessageDialog(null, "Spot deleted successfully");
      
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
