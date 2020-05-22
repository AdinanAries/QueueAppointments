

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

public class updateProvLoginInfo extends HttpServlet {
    
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
        
        String CurrentPassword = request.getParameter("OldPasswordFld");
        String UserName = request.getParameter("UserNameFld").trim().replaceAll("( )+", " ");
        String Password = request.getParameter("NewPasswordFld");
        String ProviderID = request.getParameter("ProviderID");
        String UserIndex = request.getParameter("UserIndex");
        
        //hashing current password
        CurrentPassword = QueuePWHash.GetHash(CurrentPassword);
        //hashing new password
        Password = QueuePWHash.GetHash(Password);
        
        //JOptionPane.showMessageDialog(null, CurrentPassword);
        
        boolean isCurrentPasswordCorrect = false;
        String result = "fail";
        
        try{
            
            Class.forName(Driver);
            Connection passConn = DriverManager.getConnection(url, user, password);
            String passString = "select * from QueueServiceProviders.UserAccount where Provider_ID = ?";
            PreparedStatement passPst = passConn.prepareStatement(passString);
            passPst.setString(1, ProviderID);
            
            ResultSet passRec = passPst.executeQuery();
            
            while(passRec.next()){
                
                String RecPass = passRec.getString("Password").trim();
                
                if(RecPass.equals(CurrentPassword)){
                
                isCurrentPasswordCorrect = true;
                
                }
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        if(isCurrentPasswordCorrect == true){
            try{
                Class.forName(Driver);
                Connection LoginConn = DriverManager.getConnection(url, user, password);
                String LoginString = "Update QueueServiceProviders.UserAccount set UserName = ?, Password = ? where Provider_ID = ?";
                PreparedStatement LoginPst = LoginConn.prepareStatement(LoginString);
                LoginPst.setString(1, UserName);
                LoginPst.setString(2, Password);
                LoginPst.setString(3, ProviderID);

                LoginPst.executeUpdate();
                //response.sendRedirect("ServiceProviderPage.jsp");
                //JOptionPane.showMessageDialog(null, "Update Successful");
                result = "success";

            }
            catch(Exception e){
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
