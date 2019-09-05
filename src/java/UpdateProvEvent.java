
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateProvEvent extends HttpServlet {

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String EvntID = request.getParameter("EventID");
        String Title = request.getParameter("Title").trim().replaceAll("( )+", " ");
        String Desc = request.getParameter("Desc").trim().replaceAll("( )+", " ");
        String Time = request.getParameter("Time");
        String Date = request.getParameter("Date");
        String CalDate = request.getParameter("CalDate");
        String QueryDate = "";
        
        try{
            SimpleDateFormat DtObjFormat = new SimpleDateFormat("MM/dd/yyyy");
            Date SQLDate = DtObjFormat.parse(Date);
            
            SimpleDateFormat SQLFormat = new SimpleDateFormat("yyyy-MM-dd");
            QueryDate = SQLFormat.format(SQLDate);
            
            
        }catch(Exception e){
            QueryDate = Date;
        }
        //JOptionPane.showMessageDialog(null, QueryDate);
        
        try{
            String NewDate = CalDate.substring(4);
            SimpleDateFormat CalDtFormat = new SimpleDateFormat("MMMMMMMMMMMMMMMMM dd, yyyy");
            Date CalDtObj = CalDtFormat.parse(NewDate.trim());
            
            SimpleDateFormat JQDtFormat = new SimpleDateFormat("MM/dd/yyyy");
            CalDate = JQDtFormat.format(CalDtObj);
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(QueryDate.equals(Date)){
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd/yyyy");
            
            try{
                Date tempDate = sdf2.parse(CalDate);
                CalDate = sdf.format(tempDate);
            }catch(Exception e){
                e.printStackTrace();
            }
            
        }
        //JOptionPane.showMessageDialog(null, CalDate);
        /*JOptionPane.showMessageDialog(null, EvntID);
        JOptionPane.showMessageDialog(null, Time);
        JOptionPane.showMessageDialog(null, Title);
        JOptionPane.showMessageDialog(null, Desc);
        JOptionPane.showMessageDialog(null, QueryDate);*/
        
        try{
            Class.forName(Driver);
            Connection EvntConn = DriverManager.getConnection(url, user, password);
            String EvntQuery = "update QueueServiceProviders.CalenderEvents set EventDate = ?, EventTime = ?, EventTitle = ?, EventDesc = ? where EvntID = ?";
            PreparedStatement EvntPst = EvntConn.prepareStatement(EvntQuery);
            
            EvntPst.setString(1, QueryDate);
            EvntPst.setString(2, Time);
            EvntPst.setString(3, Title);
            EvntPst.setString(4, Desc);
            EvntPst.setString(5, EvntID);
            
            EvntPst.executeUpdate();
            
        
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
