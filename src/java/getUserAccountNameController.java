

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class getUserAccountNameController extends HttpServlet {

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
        
        String CustomerID = request.getParameter("CustomerID");
        String UserName = "";
        
        try{
            Class.forName(Driver);
            Connection nameConn = DriverManager.getConnection(url, user, password);
            String nameQuery = "Select * from ProviderCustomers.UserAccount where CustomerId = ?";
            PreparedStatement namePst = nameConn.prepareStatement(nameQuery);
            namePst.setString(1,CustomerID);
            
            ResultSet nameRec = namePst.executeQuery();
            
            while(nameRec.next()){
                UserName = nameRec.getString("UserName").trim();
            }
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        response.getWriter().print(UserName);
        
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
