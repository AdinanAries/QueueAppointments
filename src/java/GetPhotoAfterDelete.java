

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


public class GetPhotoAfterDelete extends HttpServlet {


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        
        String base64Photo = "";
        int PhID = 0;
        
        try{
            
            Class.forName(Driver);
            Connection photoConn = DriverManager.getConnection(url, user, password);
            String photoQuery = "Select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
            PreparedStatement photoPst = photoConn.prepareStatement(photoQuery);
            photoPst.setString(1, ProviderID);
            
            ResultSet photoRec = photoPst.executeQuery();
            
            while(photoRec.next()){
                
                Blob eachPic = photoRec.getBlob("GalaryPhoto");
                int id = photoRec.getInt("PicID");
                
                if(eachPic != null){
                    PhID = id;
                    try{    
                
                        InputStream inputStream = eachPic.getBinaryStream();
                        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[4096];
                        int bytesRead = -1;

                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }

                        byte[] imageBytes = outputStream.toByteArray();

                        base64Photo = Base64.getEncoder().encodeToString(imageBytes);


                    }
                    catch(Exception e){}
                    break;
                }
            }
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print(
                  "{"
                + "\"ID\":\"" + PhID + "\"," 
                + "\"Image\":\"" + base64Photo + "\""
                + "}");
        
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
