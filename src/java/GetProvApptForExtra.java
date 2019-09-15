
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

public class GetProvApptForExtra extends HttpServlet {

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
        
            String SDate = request.getParameter("Date");
            String ProviderID = request.getParameter("ProviderID");
            
            String Service = "";
            String CustName = "";
            String ApptTime = "";
            
            String JSONArray = "{\"Data\":[";
            
            
            try{
                
                SimpleDateFormat DtObjFormat = new SimpleDateFormat("MM/dd/yyyy");
                Date QueryDate = DtObjFormat.parse(SDate);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                SDate = sdf.format(QueryDate);
                
                
                Class.forName(Driver);
                Connection DtConn = DriverManager.getConnection(url, user, password);
                String DateQuery = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ?";
                PreparedStatement DtPst = DtConn.prepareStatement(DateQuery);
                DtPst.setString(1, ProviderID);
                DtPst.setString(2, SDate);
                
                ResultSet DtRec = DtPst.executeQuery();
                
                boolean firstCount = true;
                
                while(DtRec.next()){
                    
                    //ApptID = DtRec.getString("AppointmentID");
                    if(!firstCount)
                        JSONArray += ",";
                    
                    ApptTime = DtRec.getString("AppointmentTime").trim();
                    Service = DtRec.getString("OrderedServices").trim();
                    
                    if(ApptTime.length() > 5)
                        ApptTime = ApptTime.substring(0,5);
                    
                    String CustID = DtRec.getString("CustomerID");
                    
                    try{
                        Class.forName(Driver);
                        Connection provConn = DriverManager.getConnection(url, user, password);
                        String provString = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                        PreparedStatement provPst = provConn.prepareStatement(provString);
                        provPst.setString(1, CustID);
                        
                        ResultSet provRec = provPst.executeQuery();
                        
                        while(provRec.next()){
                            CustName = provRec.getString("First_Name").trim();
                        }
                        
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                    
                    String EachJSON = "{\"Service\":\""+Service+"\",\"CustName\":\""+CustName+"\", \"ApptTime\":\""+ApptTime+"\"}";
                    JSONArray += EachJSON;
                    
                    firstCount = false;
                    
                }
                
                JSONArray += "]}";
                
                response.getWriter().print(JSONArray);
                
                //JOptionPane.showMessageDialog(null, JSONArray);
                
            }catch(Exception e){
                e.printStackTrace();
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
