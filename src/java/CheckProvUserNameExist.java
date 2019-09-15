

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

public class CheckProvUserNameExist extends HttpServlet {

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
        
        String UserName = request.getParameter("UserName");
        String NameExists = "false";
        
        try{
            Class.forName(Driver);
            Connection nameConn = DriverManager.getConnection(url, user, password);
            String nameQuery = "Select * from QueueServiceProviders.UserAccount where UserName = ?";
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
