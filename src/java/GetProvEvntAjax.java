

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

public class GetProvEvntAjax extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
            String user = "sa";
            String password = "Password@2014";

            String SDate = request.getParameter("Date");
            String ProviderID = request.getParameter("ProviderID");
            
            String EvntID = "";
            String EvntDate = "";
            String EvntTime = "";
            String EvntTtle = "";
            String EvntDesc = "";
            
            String JSONArray = "{\"Data\":[";
            
            
            try{
                
                SimpleDateFormat DtObjFormat = new SimpleDateFormat("MM/dd/yyyy");
                Date QueryDate = DtObjFormat.parse(SDate);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                SDate = sdf.format(QueryDate);
                
                
                Class.forName(Driver);
                Connection DtConn = DriverManager.getConnection(url, user, password);
                String DateQuery = "Select * from QueueServiceProviders.CalenderEvents where ProvID = ? and EventDate = ?";
                PreparedStatement DtPst = DtConn.prepareStatement(DateQuery);
                DtPst.setString(1, ProviderID);
                DtPst.setString(2, SDate);
                
                ResultSet DtRec = DtPst.executeQuery();
                
                boolean firstCount = true;
                
                while(DtRec.next()){
                    
                    //ApptID = DtRec.getString("AppointmentID");
                    if(!firstCount)
                        JSONArray += ",";
                    
                    EvntID = DtRec.getString("EvntID").trim();
                    EvntTtle = DtRec.getString("EventTitle").trim();
                    EvntTtle = EvntTtle.replace("\"", "");
                    EvntTtle = EvntTtle.replace("'", "");
                    EvntTtle = EvntTtle.replaceAll("( )+", " ");
                    //JOptionPane.showMessageDialog(null, EvntTtle);
                    EvntDesc = DtRec.getString("EventDesc").trim();
                    EvntDesc = EvntDesc.replace("\"", "");
                    EvntDesc = EvntDesc.replace("'", "");
                    EvntDesc = EvntDesc.replaceAll("( )+", " ");
                    //JOptionPane.showMessageDialog(null, EvntDesc);
                    EvntDate = DtRec.getString("EventDate").trim();
                    EvntTime = DtRec.getString("EventTime").trim();
                    if(EvntTime.length() > 5)
                        EvntTime = EvntTime.substring(0,5);
                    
                    String EachJSON = "{\"EvntID\":\""+EvntID+"\",\"EvntTtle\":\""+EvntTtle+"\", \"EvntTime\":\""+EvntTime+"\", \"EvntDate\":\""+EvntDate+"\", \"EvntDesc\":\""+EvntDesc+"\"}";
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
