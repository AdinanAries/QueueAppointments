

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


public class CloseDayController extends HttpServlet {

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String DaysDate = request.getParameter("GetDate");
        String ProviderID = request.getParameter("ProviderID");
        
        SimpleDateFormat sdf = null;
        java.util.Date DayOfAppointment = null;
        try{
            sdf = new SimpleDateFormat("MM/dd/yyyy");
            DayOfAppointment = sdf.parse(DaysDate);
        }catch(Exception e){}
        
        sdf = new SimpleDateFormat("yyyy-MM-dd");
        String DateToUse = sdf.format(DayOfAppointment);
        
        boolean isClosed = false;
        
        try{
            
            Class.forName(Driver);
            Connection CheckConn = DriverManager.getConnection(url, user, password);
            String CheckString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ? and DateToClose = ?";
            PreparedStatement CheckPst = CheckConn.prepareStatement(CheckString);
            CheckPst.setString(1, ProviderID);
            CheckPst.setString(2, DateToUse);
            
            ResultSet CheckRec = CheckPst.executeQuery();
            
            while(CheckRec.next()){
                isClosed = true;
                //response.sendRedirect("ServiceProviderPage.jsp");
                JOptionPane.showMessageDialog(null, "Date Already Closed");
                
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        if(isClosed == false){
        try{
            
            Class.forName(Driver);
            Connection CloseConn = DriverManager.getConnection(url, user, password);
            String CloseString = "insert into QueueServiceProviders.ClosedDays (ProviderID, DateToClose) values (?,?)";
            PreparedStatement ClosePst = CloseConn.prepareStatement(CloseString);
            ClosePst.setString(1, ProviderID);
            ClosePst.setString(2, DateToUse);
            
            ClosePst.executeUpdate();
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            JOptionPane.showMessageDialog(null, "Date Closed");
            response.getWriter().print("notInList");
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        }
        
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
