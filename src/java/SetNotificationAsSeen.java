
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SetNotificationAsSeen extends HttpServlet {


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ID = request.getParameter("ID");
        
        try{
            Class.forName(Driver);
            Connection SeenConn = DriverManager.getConnection(url, user, password);
            String SeenString = "update ProviderCustomers.Notifications set Noti_Status = 'seen' where ID = ?";
            PreparedStatement SeenPst = SeenConn.prepareStatement(SeenString);
            SeenPst.setString(1, ID);
            
            SeenPst.executeUpdate();
            
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
