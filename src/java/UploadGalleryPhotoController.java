

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215)

public class UploadGalleryPhotoController extends HttpServlet {

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
        
        boolean isAnyUploadSuccessful = false;
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        
        String ProviderID = request.getParameter("ProviderID");
        String NewUserName = request.getParameter("User");
        
        InputStream inputStream2 = null; // input stream of the upload file
        
        Part filePart2 = request.getPart("file");
        if (filePart2 != null) {
            // prints out some information for debugging
            System.out.println(filePart2.getName());
            System.out.println(filePart2.getSize());
            System.out.println(filePart2.getContentType());
             
            // obtains input stream of the upload file
            inputStream2 = filePart2.getInputStream();
        }
        
        
                try{

                    Class.forName(Driver);
                    Connection UpdateConn = DriverManager.getConnection(url, user, password);
                    String UpdateString = "Insert into QueueServiceProviders.CoverPhotos (GalaryPhoto, ProviderID) values (?, ?)";
                    PreparedStatement UpdatePst = UpdateConn.prepareStatement(UpdateString);

                    if (inputStream2 != null) {
                        // fetches input stream of the upload file for the blob column
                        UpdatePst.setBlob(1, inputStream2);
                    }

                    UpdatePst.setString(2, ProviderID);

                    int row = UpdatePst.executeUpdate();

                    if (row > 0) {

                        isAnyUploadSuccessful = true;

                    }


                }catch(Exception e){
                    e.printStackTrace();
                }

            
            
            if(isAnyUploadSuccessful){
            
            response.sendRedirect("UploadGalleryPhotoWindow.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Photo Uploaded Successfully");
            //JOptionPane.showMessageDialog(null, "Photo Uploaded Successfully!");

            
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
