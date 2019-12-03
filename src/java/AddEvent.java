
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

public class AddEvent extends HttpServlet {
    
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
        
        String CustID = request.getParameter("CustomerID");
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
            String EvntQuery = "Insert into ProviderCustomers.CalenderEvents (CustID, EventDate, EventTime, EventTitle, EventDesc) values (?,?,?,?,?)";
            PreparedStatement EvntPst = EvntConn.prepareStatement(EvntQuery);
            EvntPst.setString(1, CustID);
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
            String getEvntQuery = "Select * from ProviderCustomers.CalenderEvents where CustID = ? and EventDate = ? and EventTime = ? and EventTitle = ? and EventDesc = ?";
            PreparedStatement getEvntPst = getEvntConn.prepareStatement(getEvntQuery);
            
            getEvntPst.setString(1, CustID);
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
        
        //-------------------------------------------------------------------------------------------
                Date NotiDate = new Date();
                String NotiSDate = NotiDate.toString();
                SimpleDateFormat NotiDformat = new SimpleDateFormat("yyyy-MM-dd");
                String date = NotiDformat.format(NotiDate);
                String time = NotiSDate.substring(11,16);
                
                //nofitying customer
                try{
                    Class.forName(Driver);
                    Connection notiConn = DriverManager.getConnection(url, user, password);
                    String notiString = "insert into ProviderCustomers.Notifications (Noti_Type, CustID, If_From_Cust, What, Noti_Date, Noti_Time)"
                            + "values (?,?,?,?,?,?)";
                    PreparedStatement notiPst = notiConn.prepareStatement(notiString);
                    notiPst.setString(1, "Today's Event");
                    notiPst.setString(2, CustID);
                    notiPst.setString(3, CustID);
                    notiPst.setString(4, Title + " at " + Time + " - " + Desc);
                    notiPst.setString(5, QueryDate);
                    notiPst.setString(6, Time);
                    notiPst.executeUpdate();
                    
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
