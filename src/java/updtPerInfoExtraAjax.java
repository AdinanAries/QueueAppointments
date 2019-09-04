
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class updtPerInfoExtraAjax extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String FirstName = request.getParameter("FirstName");
        String MiddleName = request.getParameter("MiddleName");
        String LastName = request.getParameter("LastName");
        String Email = request.getParameter("Email");
        String Phone = request.getParameter("Phone");
        String CustID = request.getParameter("CustomerID");
        
        try{
            Class.forName(Driver);
            Connection updtConn = DriverManager.getConnection(url, user, password);
            String updtString = "update ProviderCustomers.CustomerInfo set First_Name = ?, Middle_Name = ?, Last_Name = ?, Phone_Number = ?, Email = ? where Customer_ID = ?";
            PreparedStatement updtPst = updtConn.prepareStatement(updtString);
            updtPst.setString(1,FirstName);
            updtPst.setString(2,MiddleName);
            updtPst.setString(3,LastName);
            updtPst.setString(4,Phone);
            updtPst.setString(5,Email);
            updtPst.setString(6,CustID);
            
            updtPst.executeUpdate();
            
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

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
