
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class getProvUserAccountName extends HttpServlet {

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        String AccountName = "";
        
        
        try{
            Class.forName(Driver);
            Connection nameConn = DriverManager.getConnection(url, user, password);
            String nameString = "Select * from QueueServiceProviders.UserAccount where Provider_ID = ?";
            PreparedStatement namePst = nameConn.prepareStatement(nameString);
            namePst.setString(1, ProviderID);
            ResultSet nameRec = namePst.executeQuery();
            
            while(nameRec.next()){
                AccountName = nameRec.getString("UserName").trim();
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print(AccountName);
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
