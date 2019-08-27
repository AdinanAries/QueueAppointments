

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.swing.JOptionPane;

@MultipartConfig(maxFileSize = 16177215)

public class UploadCoverPhotoControl extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        boolean isAnyUploadSuccessful = false;
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        String NewUserName = request.getParameter("User");
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        
        InputStream inputStream2 = null; // input stream of the upload file
        
        Part filePart2 = request.getPart("coverPic");
        if (filePart2 != null) {
            // prints out some information for debugging
            System.out.println(filePart2.getName());
            System.out.println(filePart2.getSize());
            System.out.println(filePart2.getContentType());
             
            // obtains input stream of the upload file
            inputStream2 = filePart2.getInputStream();
        }
        
        boolean hasCoverPhoto  = false;

            try{

                Class.forName(Driver);
                Connection SelectConn = DriverManager.getConnection(url, user, password);
                String SelectString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID = ?";
                PreparedStatement SelectPst = SelectConn.prepareStatement(SelectString);

                SelectPst.setString(1, ProviderID);

                ResultSet Rec = SelectPst.executeQuery();

                while(Rec.next()){
                    hasCoverPhoto = true;
                }

            }catch(Exception e){
                e.printStackTrace();
            }


            if(hasCoverPhoto){

                try{

                    Class.forName(Driver);
                    Connection UpdateConn = DriverManager.getConnection(url, user, password);
                    String UpdateString = "Update QueueServiceProviders.CoverPhotos set CoverPhoto = ? where ProviderID = ?";
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
            }
            else{

                try{

                    Class.forName(Driver);
                    Connection UpdateConn = DriverManager.getConnection(url, user, password);
                    String UpdateString = "Insert into QueueServiceProviders.CoverPhotos (CoverPhoto, ProviderID) values (?, ?)";
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

            }
            
            if(isAnyUploadSuccessful){
            
                String Url = "UploadProviderProfilePhoto.jsp?UserIndex="+UserIndex+"&User="+NewUserName;

                response.sendRedirect(Url);
                JOptionPane.showMessageDialog(null, "Cover Photo Updated Successfully!");

            
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
