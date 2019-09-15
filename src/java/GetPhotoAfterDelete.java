

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


public class GetPhotoAfterDelete extends HttpServlet {

    
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
