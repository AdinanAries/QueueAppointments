
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

public class SendProvCustFeedBackController extends HttpServlet {
    
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
        
        Date currentDate = new Date();
        SimpleDateFormat currentDateSdf = new SimpleDateFormat("yyyy-MM-dd");
        String StringDate = currentDateSdf.format(currentDate);
        
        String FeedBackMessage = request.getParameter("FeedBackMessage").trim().replaceAll("( )+", " ");
        String CustomerID = request.getParameter("CustomerID");
        
        try{
            
            Class.forName(Driver);
            Connection FeedBackConn = DriverManager.getConnection(url, user, password);
            String FeedBackString = "insert into QueueObjects.FeedBackMessages (If_Customer_ID, FeedBackMessage, FeedBackDate) values(?,?,?)";
            PreparedStatement FeedBackPst = FeedBackConn.prepareStatement(FeedBackString);
            FeedBackPst.setString(1, CustomerID);
            FeedBackPst.setString(2, FeedBackMessage);
            FeedBackPst.setString(3, StringDate);
            FeedBackPst.executeUpdate();
            
            JOptionPane.showMessageDialog(null, "Your feedback was sent successfully!");
            //response.sendRedirect("ProviderCustomerPage.jsp");
            
            
            
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
