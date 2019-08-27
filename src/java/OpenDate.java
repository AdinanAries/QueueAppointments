
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


public class OpenDate extends HttpServlet {

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ClosedID = request.getParameter("ClosedID");
        String UserIndex = request.getParameter("UserIndex");
        
        try{
            Class.forName(Driver);
            Connection OpenConn = DriverManager.getConnection(url, user, password);
            String OpenString = "Delete from QueueServiceProviders.ClosedDays where closedID = ?";
            PreparedStatement OpenPst = OpenConn.prepareStatement(OpenString);
            OpenPst.setString(1, ClosedID);
            
            OpenPst.executeUpdate();
            
            response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex);
            JOptionPane.showMessageDialog(null, "Closed Day Openned");
            
            
        }catch(Exception e){}
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
