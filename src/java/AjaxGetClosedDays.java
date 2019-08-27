

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AjaxGetClosedDays extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        String ClosedDate = "";
        String ClosedID = "";
        
        try{
            Class.forName(Driver);
            Connection ClosedConn = DriverManager.getConnection(url, user, password);
            String ClosedString = "Select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
            PreparedStatement ClosedPst = ClosedConn.prepareStatement(ClosedString);
            ClosedPst.setString(1, ProviderID);
            
            ResultSet ClosedRow = ClosedPst.executeQuery();
            
            while(ClosedRow.next()){
                
                SimpleDateFormat closedFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date closedDateObj = closedFormat.parse(ClosedRow.getString("DateToClose"));
                String DayOfWeek = closedDateObj.toString().substring(0,3);
                SimpleDateFormat dateValueFormat = new SimpleDateFormat("MMMMMMMMM dd, yyyy");
                String StringDate = dateValueFormat.format(closedDateObj);
                
                ClosedDate = DayOfWeek + ", "+StringDate;
                ClosedID = ClosedRow.getString("closedID");
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"ClosedDate\":\""+ClosedDate+"\""+",\"ClosedID\":\""+ClosedID+"\"}");
        
    }
    
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
