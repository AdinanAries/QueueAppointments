

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

public class AddEventProv extends HttpServlet {


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProvID = request.getParameter("ProviderID");
        String Title = request.getParameter("Title").trim().replaceAll("( )+", " ");
        String Desc = request.getParameter("Desc").trim().replaceAll("( )+", " ");
        String Time = request.getParameter("Time");
        String Date = request.getParameter("Date");
        String CalDate = request.getParameter("CalDate");
        String QueryDate = "";
        String EvntID = "";
        
        try{
            SimpleDateFormat DtObjFormat = new SimpleDateFormat("MM/dd/yyyy");
            Date SQLDate = DtObjFormat.parse(Date);
            
            SimpleDateFormat SQLFormat = new SimpleDateFormat("yyyy-MM-dd");
            QueryDate = SQLFormat.format(SQLDate);
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
         
        try{
            String NewDate = CalDate.substring(4);
            SimpleDateFormat CalDtFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMM dd, yyyy");
            Date CalDtObj  = CalDtFormat.parse(NewDate.trim());

            SimpleDateFormat JQDtFormat = new SimpleDateFormat("MM/dd/yyyy");
            CalDate = JQDtFormat.format(CalDtObj);

            }catch(Exception e){}
        
        
        try{
            Class.forName(Driver);
            Connection EvntConn = DriverManager.getConnection(url, user, password);
            String EvntQuery = "Insert into QueueServiceProviders.CalenderEvents (ProvID, EventDate, EventTime, EventTitle, EventDesc) values (?,?,?,?,?)";
            PreparedStatement EvntPst = EvntConn.prepareStatement(EvntQuery);
            EvntPst.setString(1, ProvID);
            EvntPst.setString(2, QueryDate);
            EvntPst.setString(3, Time);
            EvntPst.setString(4, Title);
            EvntPst.setString(5, Desc);
            
            EvntPst.executeUpdate();
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection getEvntConn = DriverManager.getConnection(url, user ,password);
            String getEvntQuery = "Select * from QueueServiceProviders.CalenderEvents  where ProvID = ? and EventDate = ? and EventTime = ? and EventTitle = ? and EventDesc = ?";
            PreparedStatement getEvntPst = getEvntConn.prepareStatement(getEvntQuery);
            
            getEvntPst.setString(1, ProvID);
            getEvntPst.setString(2, QueryDate);
            getEvntPst.setString(3, Time);
            getEvntPst.setString(4, Title);
            getEvntPst.setString(5, Desc);
            
            ResultSet getEvntRec = getEvntPst.executeQuery();
            
            while(getEvntRec.next()){
                EvntID = getEvntRec.getString("EvntID");
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"JQDate\": \""+CalDate+"\", \"EvntID\": \""+EvntID+"\"}");
        
        
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
