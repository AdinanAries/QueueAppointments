

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


public class GetCustPerInfo extends HttpServlet {

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
        
        String CustomerID = request.getParameter("CustomerID");
        String FirstName = "";
        String MiddleName = "";
        String LastName = "";
        String Email = "";
        String Tel = "";
        
        //address info
        String HouseNumber = "";
        String Street = "";
        String Town = "";
        String City = "";
        String Country = "";
        String ZCode = "";
        
        //getting personal infomation
        try{
            Class.forName(Driver);
            Connection PerConn = DriverManager.getConnection(url, user, password);
            String PerQuery = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
            PreparedStatement PerPst = PerConn.prepareStatement(PerQuery);
            PerPst.setString(1, CustomerID);
            
            ResultSet PerRec = PerPst.executeQuery();
            
            while(PerRec.next()){
                
                FirstName = PerRec.getString("First_Name").trim();
                MiddleName = PerRec.getString("Middle_Name").trim();
                LastName = PerRec.getString("Last_Name").trim();
                Email = PerRec.getString("Email").trim();
                Tel = PerRec.getString("Phone_Number").trim();
                
            }
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        //getting address information
        try{
            Class.forName(Driver);
            Connection addressConn = DriverManager.getConnection(url, user, password);
            String addressQuery = "Select * from QueueObjects.CustomerAddress where Customer_ID = ?";
            PreparedStatement addressPst = addressConn.prepareStatement(addressQuery);
            addressPst.setString(1, CustomerID);
            
            ResultSet addressRec = addressPst.executeQuery();
            
            while(addressRec.next()){
                
                HouseNumber = addressRec.getString("House_Number").trim();
                Street = addressRec.getString("Street_Name").trim();
                Town = addressRec.getString("Town").trim();
                City = addressRec.getString("City").trim();
                Country = addressRec.getString("Country").trim();
                ZCode = addressRec.getString("Zipcode").trim();
                
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"FirstName\":\""+FirstName+"\",\"MiddleName\":\""+MiddleName+"\",\"LastName\":\""+LastName
                +"\",\"Email\":\""+Email+"\",\"Tel\":\""+Tel+"\",\"Address\":{\"HouseNumber\":\""+HouseNumber+"\",\"Street\":\""+Street+"\",\"Town\":\""+Town+
                "\",\"City\":\""+City+"\",\"Country\":\""+Country+"\",\"ZipCode\":\""+ZCode+"\"}}");
       
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
