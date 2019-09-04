
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DltEvntAjax extends HttpServlet {


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String EventID = request.getParameter("EventID");
        
        try{
            Class.forName(Driver);
            Connection DltConn = DriverManager.getConnection(url, user, password);
            String DltString = "delete from ProviderCustomers.CalenderEvents where EvntID = ?";
            PreparedStatement DltPst = DltConn.prepareStatement(DltString);
            DltPst.setString(1, EventID);
            
            DltPst.executeUpdate();
            
            response.getWriter().print("success");
            
        }catch(Exception e){
            e.printStackTrace();
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
