
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

public class GetEachServiceDetails extends HttpServlet {

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
        
        String ServiceID = request.getParameter("ServiceID");
        
        String ServiceName = "";
        String Price = "";
        String Description = "";
        String Duration = "";
        
        try{
            Class.forName(Driver);
            Connection ServConn = DriverManager.getConnection(url, user, password);
            String ServQuery = "Select * from QueueServiceProviders.ServicesAndPrices where ServiceID = ?";
            PreparedStatement ServPst = ServConn.prepareStatement(ServQuery);
            ServPst.setString(1, ServiceID);
            
            ResultSet ServRec = ServPst.executeQuery();
            
            while(ServRec.next()){
                
                ServiceName = ServRec.getString("ServiceName").trim();
                Price = ServRec.getString("Price").trim();
                Description = ServRec.getString("ServiceDescription").trim();
                Duration = ServRec.getString("ServiceDuration").trim();
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print("{\"Name\":\""+ServiceName+"\",\"Price\":\""+Price+"\",\"Description\":\""+Description+"\",\"Duration\":\""+Duration+"\"}");
        
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
