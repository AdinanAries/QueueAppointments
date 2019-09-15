
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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class getLastAddedClientAjax extends HttpServlet {

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
        String CustomerID = request.getParameter("CustomerID");
        
        String Name = "";
        String Mobile = "";
        String Email = "";
        String Propic = "";
        
        boolean isClientAdded = false;
        
        try{
            
            Class.forName(Driver);
            Connection ClientConn = DriverManager.getConnection(url, user, password);
            String ClientQuery = "Select * from QueueServiceProviders.ClientsList where ProvID = ? and CustomerID = ?";
            PreparedStatement ClientPst = ClientConn.prepareStatement(ClientQuery);
            ClientPst.setString(1, ProviderID);
            ClientPst.setString(2, CustomerID);
            
            ResultSet ClientRec = ClientPst.executeQuery();
            
            while(ClientRec.next()){
                isClientAdded = true;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isClientAdded == true){
            
            try{
                
                Class.forName(Driver);
                Connection CustConn = DriverManager.getConnection(url, user, password);
                String CustQuery = "Select * from ProviderCustomers.CustomerInfo where Customer_ID = ?";
                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                CustPst.setString(1, CustomerID);
                
                ResultSet CustRec = CustPst.executeQuery();
                
                while(CustRec.next()){
                    String FirstName = CustRec.getString("First_Name").trim();
                    String MiddleName = CustRec.getString("Middle_Name").trim();
                    String LastName = CustRec.getString("Last_Name").trim();
                    
                    Name = FirstName + " " + MiddleName + " " + LastName;
                    Email = CustRec.getString("Email").trim();
                    Mobile = CustRec.getString("Phone_Number").trim();
                    
                    try{    
                       //put this in a try catch block for incase getProfilePicture returns nothing
                        Blob profilepic = CustRec.getBlob("Profile_Pic"); 
                        InputStream inputStream = profilepic.getBinaryStream();
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[4096];
                        int bytesRead = -1;

                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }

                        byte[] imageBytes = outputStream.toByteArray();

                        Propic = Base64.getEncoder().encodeToString(imageBytes);


                    }catch(Exception e){}
                }
            
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        response.getWriter().print(
            "{" +
                "\"Name\":\"" + Name + "\"," +
                "\"Email\":\"" + Email + "\"," +
                "\"Mobile\":\"" + Mobile + "\"," +
                "\"ProfilePic\":\"" + Propic + "\"" +
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
