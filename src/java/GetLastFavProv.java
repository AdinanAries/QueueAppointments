
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


public class GetLastFavProv extends HttpServlet {

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
        
        boolean isProvAdded = false;
        
        String FullName = "";
        String CoverPic = "";
        String ProfilePic = "";
        String Company = "";
        int Ratings = 0;
        
        try{
            Class.forName(Driver);
            Connection checkFavConn = DriverManager.getConnection(url, user, password);
            String checkQuery = "Select * from ProviderCustomers.FavoriteProviders where ProviderId = ? and CustomerId = ?";
            PreparedStatement checkPst = checkFavConn.prepareStatement(checkQuery);
            checkPst.setString(1, ProviderID);
            checkPst.setString(2, CustomerID);
            
            ResultSet checkRec = checkPst.executeQuery();
            
            while(checkRec.next()){
                isProvAdded = true;
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isProvAdded == true){
            
            try{
                
                Class.forName(Driver);
                Connection ProvInfoConn = DriverManager.getConnection(url, user, password);
                String ProvInfoQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                PreparedStatement ProvInfoPst = ProvInfoConn.prepareStatement(ProvInfoQuery);
                ProvInfoPst.setString(1, ProviderID);
                ResultSet ProvInfoRec = ProvInfoPst.executeQuery();
                
                while(ProvInfoRec.next()){
                    String FirstName = ProvInfoRec.getString("First_Name").trim();
                    String MiddleName = ProvInfoRec.getString("Middle_Name").trim();
                    String LastName = ProvInfoRec.getString("Last_Name").trim();
                    FullName = FirstName + " " + MiddleName + " " + LastName;
                    Company = ProvInfoRec.getString("Company").trim();
                    Ratings = ProvInfoRec.getInt("Ratings");
                    
                    try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob profilepic = ProvInfoRec.getBlob("Profile_Pic"); 
                            InputStream inputStream = profilepic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                             ProfilePic = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}
                    
                }
                
                
            }catch(Exception e){
                e.printStackTrace();
            }
            
            try{
                
                Class.forName(Driver);
                Connection CoverConn = DriverManager.getConnection(url, user, password);
                String CoverQuery = "Select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
                PreparedStatement CoverPst = CoverConn.prepareStatement(CoverQuery);
                CoverPst.setString(1, ProviderID);
                ResultSet CoverRec = CoverPst.executeQuery();
                
                while(CoverRec.next()){
                    
                    Blob Cover = CoverRec.getBlob("CoverPhoto");
                    
                    //JOptionPane.showMessageDialog(null, Cover);
                    
                    if(Cover != null){
                    
                        try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing

                                InputStream inputStream = Cover.getBinaryStream();
                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead = -1;

                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    outputStream.write(buffer, 0, bytesRead);
                                }

                                byte[] imageBytes = outputStream.toByteArray();

                                 CoverPic = Base64.getEncoder().encodeToString(imageBytes);


                            }
                            catch(Exception e){}
                    
                        //JOptionPane.showMessageDialog(null, "Added");
                    }
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        response.getWriter().print(
        
        "{"
            + "\"Name\":\"" + FullName + "\","
            + "\"Rating\":\"" + Ratings + "\","
            + "\"ProfilePic\":\"" + ProfilePic + "\","
            + "\"CoverPic\":\"" + CoverPic + "\","
            + "\"Company\":\"" + Company + "\"" +
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
