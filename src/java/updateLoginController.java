

import com.arieslab.queue.queue_model.QueuePWHash;
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

/**
 *
 * @author aries
 */
public class updateLoginController extends HttpServlet {
    
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
        
        String UserName = request.getParameter("userName").trim().replaceAll("( )+", " ");
        //String CurrentPassword = request.getParameter("");
        String NewPassword = request.getParameter("newPassword");
        String CustomerID = request.getParameter("CustomerID");
        String UserIndex = request.getParameter("UserIndex");
        String oldPassword = request.getParameter("currentPassword");
        
        //hashing old password
        oldPassword = QueuePWHash.GetHash(oldPassword);
        //hashing new password
        NewPassword = QueuePWHash.GetHash(NewPassword);
        
        String result = "fail";
        boolean isPasswordCorrect = false;
        
        try{
            Class.forName(Driver);
            Connection selectConn = DriverManager.getConnection(url, user, password);
            String selectString = "Select * from ProviderCustomers.UserAccount where CustomerId = ?";
            PreparedStatement selectPst = selectConn.prepareStatement(selectString);
            selectPst.setString(1, CustomerID);
            ResultSet selectRow = selectPst.executeQuery();
            
            while(selectRow.next()){
                
                String recPass = selectRow.getString("Password").trim();
                if(recPass.equals(oldPassword)){
                    isPasswordCorrect = true;
                }
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(isPasswordCorrect == true){
            
            try{

                Class.forName(Driver);
                Connection accountConn = DriverManager.getConnection(url, user, password);
                String accountString = "Update ProviderCustomers.UserAccount set UserName = ?, Password = ? where CustomerId = ?";
                PreparedStatement accountPst = accountConn.prepareStatement(accountString);
                accountPst.setString(1,UserName);
                accountPst.setString(2,NewPassword);
                accountPst.setString(3,CustomerID);

                accountPst.executeUpdate();

                //response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex);
                //JOptionPane.showMessageDialog(null, "Login updated successfully!");
                result = "success";

            }catch(Exception e){
                e.printStackTrace();
            }
            
        }
       
        response.getWriter().print(result);
        
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
