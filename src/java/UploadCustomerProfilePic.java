
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/UploadCustomerProfilePic"})
@MultipartConfig(maxFileSize = 16177215)
public class UploadCustomerProfilePic extends HttpServlet {
    
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
        
        int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
        String NewUserName = request.getParameter("User");
        
        
        String CustomerID = request.getParameter("CustomerID");
        
        InputStream inputStream = null; // input stream of the upload file
         
        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("file");
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
            String UpdateString = "Update ProviderCustomers.CustomerInfo set Profile_Pic = ? where Customer_ID = ?";
            PreparedStatement UpdatePst = UpdateConn.prepareStatement(UpdateString);
                
            if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
                UpdatePst.setBlob(1, inputStream);
            }
            
            UpdatePst.setString(2, CustomerID);
                
            int row = UpdatePst.executeUpdate();
                
            if (row > 0) {

                response.sendRedirect("UploadPhotoWindow.jsp?UserIndex="+UserIndex+"&User="+NewUserName+"&result=Profile Photo Updated Successfully");
                //JOptionPane.showMessageDialog(null, "Profile Photo Updated Successfully!");

            }
                
                
        }catch(Exception e){
            e.printStackTrace();
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
