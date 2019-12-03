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
public class GetApptForExtra extends HttpServlet {

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
            String CustomerID = request.getParameter("CustomerID");
            
            String ProvComp = "";
            String ProvName = "";
            String ApptTime = "";
            
            String JSONArray = "{\"Data\":[";
            
            
            try{
                
                SimpleDateFormat DtObjFormat = new SimpleDateFormat("MM/dd/yyyy");
                Date QueryDate = DtObjFormat.parse(SDate);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                SDate = sdf.format(QueryDate);
                
                
                Class.forName(Driver);
                Connection DtConn = DriverManager.getConnection(url, user, password);
                String DateQuery = "Select * from QueueObjects.BookedAppointment where CustomerID = ? and AppointmentDate = ?";
                PreparedStatement DtPst = DtConn.prepareStatement(DateQuery);
                DtPst.setString(1, CustomerID);
                DtPst.setString(2, SDate);
                
                ResultSet DtRec = DtPst.executeQuery();
                
                boolean firstCount = true;
                
                while(DtRec.next()){
                    
                    //ApptID = DtRec.getString("AppointmentID");
                    if(!firstCount)
                        JSONArray += ",";
                    
                    ApptTime = DtRec.getString("AppointmentTime").trim();
                    if(ApptTime.length() > 5)
                        ApptTime = ApptTime.substring(0,5);
                    
                    String ProvID = DtRec.getString("ProviderID");
                    
                    try{
                        Class.forName(Driver);
                        Connection provConn = DriverManager.getConnection(url, user, password);
                        String provString = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                        PreparedStatement provPst = provConn.prepareStatement(provString);
                        provPst.setString(1, ProvID);
                        
                        ResultSet provRec = provPst.executeQuery();
                        
                        while(provRec.next()){
                            ProvName = provRec.getString("First_Name").trim();
                            ProvComp = provRec.getString("Company").trim();
                        }
                        
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                    
                    String EachJSON = "{\"ProvComp\":\""+ProvComp+"\",\"ProvName\":\""+ProvName+"\", \"ApptTime\":\""+ApptTime+"\"}";
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
