

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

public class GetProvPerInfo extends HttpServlet {

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
        
        String ProviderID = request.getParameter("ProviderID");
        String FirstName = "";
        String MiddleName = "";
        String LastName = "";
        String Email = "";
        String Tel = "";
        String Company = "";
        
        try{
            
            Class.forName(Driver);
            Connection PerConn = DriverManager.getConnection(url, user, password);
            String PerQuery = "Select First_Name, Middle_Name, Last_Name, Phone_Number, Email, Company from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
            PreparedStatement PerPst = PerConn.prepareStatement(PerQuery);
            PerPst.setString(1, ProviderID);
            
            ResultSet PerRec = PerPst.executeQuery();
            
            while(PerRec.next()){
                
                FirstName = PerRec.getString("First_Name").trim();
                MiddleName = PerRec.getString("Middle_Name").trim();
                LastName = PerRec.getString("Last_Name").trim();
                Email = PerRec.getString("Email").trim();
                Tel = PerRec.getString("Phone_Number").trim();
                Company = PerRec.getString("Company").trim();
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"FirstName\":\""+FirstName+"\",\"MiddleName\":\""+MiddleName
                +"\",\"LastName\":\""+LastName+"\",\"Email\":\""+Email+"\",\"Mobile\":\""+Tel+"\",\"Company\":\""+Company+"\"}");
        
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
