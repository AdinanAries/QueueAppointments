

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

public class UploadProviderPhotosControl extends HttpServlet {

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
        String NewUserName = request.getParameter("User");
        
        String ProviderID = request.getParameter("ProviderID");
        
        InputStream inputStream = null; // input stream of the upload file
         
        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("profilePic");
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());
             
            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }
        
        
            
            try{

                Class.forName(Driver);
                Connection UpdateConn = DriverManager.getConnection(url, user, password);
                String UpdateString = "Update QueueServiceProviders.ProviderInfo set Profile_Pic = ? where Provider_ID = ?";
                PreparedStatement UpdatePst = UpdateConn.prepareStatement(UpdateString);

                if (inputStream != null) {
                    // fetches input stream of the upload file for the blob column
                    UpdatePst.setBlob(1, inputStream);
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
            
            response.sendRedirect("UploadProviderProfilePhoto.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Profile Photo Updated Successfully");
            //JOptionPane.showMessageDialog(null, "Profile Photo Updated Successfully!");

            
        }
        
        
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
