

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

public class DeletePhotoByProv extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String PhotoID = request.getParameter("PhotoID");
        String UserIndex = request.getParameter("UserIndex");
        //JOptionPane.showMessageDialog(null, PhotoID);
        
        try{
            
            Class.forName(Driver);
            Connection dltConn = DriverManager.getConnection(url, user, password);
            String dltQuery = "Delete from QueueServiceProviders.CoverPhotos where PicID = ?";
            PreparedStatement dltPST = dltConn.prepareStatement(dltQuery);
            dltPST.setString(1, PhotoID);
            
            dltPST.executeUpdate();
            JOptionPane.showMessageDialog(null, "Photo Deleted");
            
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
