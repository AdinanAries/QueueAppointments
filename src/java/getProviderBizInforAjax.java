

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class getProviderBizInforAjax extends HttpServlet {

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
        
        String ProviderID = request.getParameter("ProviderID");
        
        String BizName = "";
        String BizType = "";
        String BizEmail = "";
        String BizTel = "";
        String ProvName = "";
        
        String HouseNumber = "";
        String Street = "";
        String Town = "";
        String City = "";
        String Country = "";
        String ZCode = "";
        
        try{
            Class.forName(Driver);
            Connection nameConn = DriverManager.getConnection(url, user, password);
            String nameQuery = "Select First_Name from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement namePst = nameConn.prepareStatement(nameQuery);
            namePst.setString(1, ProviderID);
            
            ResultSet nameRec = namePst.executeQuery();
            while(nameRec.next()){
                ProvName = nameRec.getString("First_Name").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection BizInfoConn = DriverManager.getConnection(url, user, password);
            String BizQuery = "Select * from QueueServiceProviders.BusinessInfo where Provider_ID = ?";
            PreparedStatement BizPst = BizInfoConn.prepareStatement(BizQuery);
            BizPst.setString(1, ProviderID);
            
            ResultSet BizRec = BizPst.executeQuery();
            
            while(BizRec.next()){
                BizName = BizRec.getString("Business_Name").trim();
                BizType = BizRec.getString("Business_Type").trim();
                BizEmail = BizRec.getString("Business_Email").trim();
                BizTel = BizRec.getString("Business_Tel").trim();
            }
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection AddressConn = DriverManager.getConnection(url, user, password);
            String AddressQuery = "select * from QueueObjects.ProvidersAddress where ProviderID = ?";
            PreparedStatement AddressPst = AddressConn.prepareStatement(AddressQuery);
            AddressPst.setString(1, ProviderID);
            
            ResultSet AddressRec = AddressPst.executeQuery();
            
            while(AddressRec.next()){
                HouseNumber = AddressRec.getString("House_Number").trim();
                Street = AddressRec.getString("Street_Name").trim();
                Town = AddressRec.getString("Town").trim();
                City = AddressRec.getString("City").trim();
                Country = AddressRec.getString("Country").trim();
                ZCode = AddressRec.getString("Zipcode").trim();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"ProvName\":\""+ProvName+"\",\"BusinessName\":\""+BizName+"\",\"BusinessEmail\":\"" + BizEmail + "\",\"BusinessTel\":\"" + BizTel + "\",\"BusinessType\":\""+BizType+
                "\",\"Address\":{\"HouseNumber\":\""+HouseNumber+"\",\"Street\":\""+Street+"\",\"Town\":\""+Town+"\",\"City\":\""+City+"\",\"Country\":\""+Country+"\",\"ZipCode\":\""+ZCode
                + "\"}}");
        
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
