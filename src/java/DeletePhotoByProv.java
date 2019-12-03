

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeletePhotoByProv extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
            //JOptionPane.showMessageDialog(null, "Photo Deleted");
            response.getWriter().print("Photo Deleted");
            
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
