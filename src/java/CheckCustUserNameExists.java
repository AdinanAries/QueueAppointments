

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

public class CheckCustUserNameExists extends HttpServlet {

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String UserName = request.getParameter("UserName");
        String NameExists = "false";
        
        try{
            Class.forName(Driver);
            Connection nameConn = DriverManager.getConnection(url, user, password);
            String nameQuery = "Select * from ProviderCustomers.UserAccount where UserName = ?";
            PreparedStatement namePst = nameConn.prepareStatement(nameQuery);
            namePst.setString(1, UserName);
            
            ResultSet nameRec = namePst.executeQuery();
            
            while(nameRec.next()){
                String Name = nameRec.getString("UserName").trim();
                
                if(UserName.equals(Name))
                    NameExists = "true";
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print(NameExists);
        
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
