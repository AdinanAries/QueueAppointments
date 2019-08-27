

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class GetBlockedClientAjax extends HttpServlet {

  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        
        boolean isCustBlocked = false;
        String CustName = "";
        String Email = "";
        String Tel = "";
        String Base64Pic = "";
        String BlockedID = "";
        
        try{
            
            Class.forName(Driver);
            Connection blockedConn = DriverManager.getConnection(url, user, password);
            String blockedString = "Select * from QueueServiceProviders.BlockedCustomers where CustomerID = ? and ProviderId = ?";
            PreparedStatement blockedPst = blockedConn.prepareStatement(blockedString);
            blockedPst.setString(1, CustomerID);
            blockedPst.setString(2, ProviderID);
            
            ResultSet blockedRec = blockedPst.executeQuery();
            
            while(blockedRec.next()){
                isCustBlocked = true;
                BlockedID = blockedRec.getString("BlockedID").trim();
            }
           
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isCustBlocked == true){
            
            try{
                Class.forName(Driver);
                Connection custConn = DriverManager.getConnection(url, user, password);
                String custQuery = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                PreparedStatement custPst = custConn.prepareStatement(custQuery);
                custPst.setString(1, CustomerID);
                
                ResultSet custRec = custPst.executeQuery();
                
                while(custRec.next()){
                    
                    String FirstName = custRec.getString("First_Name").trim();
                    String MiddleName = custRec.getString("Middle_Name").trim();
                    String LastName = custRec.getString("Last_Name").trim();
                    
                    try{    
                       //put this in a try catch block for incase getProfilePicture returns nothing
                        Blob profilepic = custRec.getBlob("Profile_Pic"); 
                        InputStream inputStream = profilepic.getBinaryStream();
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[4096];
                        int bytesRead = -1;

                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }

                        byte[] imageBytes = outputStream.toByteArray();

                        Base64Pic = Base64.getEncoder().encodeToString(imageBytes);


                    }catch(Exception e){}
                    
                    CustName = FirstName + " " + MiddleName + " " + LastName;
                    Email = custRec.getString("Email").trim();
                    Tel = custRec.getString("Phone_Number").trim();
                    
                }
                
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        
        response.getWriter().print(
                "{" +
                   "\"Name\":\""+CustName+"\"," +
                   "\"Email\":\""+Email+"\"," +
                   "\"Tel\":\""+Tel+"\"," +
                    "\"Propic\":\""+Base64Pic+ "\"," +
                    "\"ID\":\""+BlockedID +"\""+
                "}"
        );
        
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
