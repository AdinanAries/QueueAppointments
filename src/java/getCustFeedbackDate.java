
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

public class getCustFeedbackDate extends HttpServlet {

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String CustomerID = request.getParameter("CustomerID");
        String FeedBackDate = "";
        
        //Database connection parameters
           String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
           String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
           String user = "sa";
           String password = "Password@2014";
           
           try{
               Class.forName(Driver);
               Connection dateConn = DriverManager.getConnection(url, user, password);
               String dateQuery = "Select * from QueueObjects.FeedBackMessages where If_Customer_ID = ?";
               PreparedStatement datePst = dateConn.prepareStatement(dateQuery);
               datePst.setString(1, CustomerID);
               
               ResultSet dateRec = datePst.executeQuery();
               
               while(dateRec.next()){
                   FeedBackDate = dateRec.getString("FeedBackDate");
               }
               
               
           }catch(Exception e){
               e.printStackTrace();
           }
        
           response.getWriter().print(FeedBackDate);
        
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
