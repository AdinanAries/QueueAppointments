
import com.arieslab.queue.queue_model.ProcedureClass;
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
import com.arieslab.queue.queue_model.UserAccount;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;

public class LoginControllerMain extends HttpServlet {

    //Database connection parameters
    String Driver = "";
    String url = "";
    String user = "";
    String password = "";
    
    @Override
    public void init(ServletConfig config){
                
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
                
        url = config.getInitParameter("databaseUrl");
        Driver = config.getInitParameter("databaseDriver");
        user = config.getInitParameter("user");
        password = config.getInitParameter("password");
                
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      //JOptionPane.showMessageDialog(null, "called");
           int Flag = 0;
           int UserID = 0;
           String SessionID = "";
        
           //get user provided information
           String UserName = request.getParameter("username");
           String Password = request.getParameter("password");
           
           if(UserName == null || UserName.equalsIgnoreCase("")){
               UserName = " ";
           }
           if(Password == null || Password.equalsIgnoreCase("")){
               Password = " ";
           }
           
           //resetting UserAccount fields
           //UserAccount.UserID = 0;
           //UserAccount.AccountType = "";
           //UserAccount.LoginStatusMessage = "";
           
        try{
            //first connection query attempt (to customers table)
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String Query = "Select * from ProviderCustomers.UserAccount where UserName=? and Password=?";
            PreparedStatement pst = conn.prepareStatement(Query);
            pst.setString(1,UserName);
            pst.setString(2,Password);
            ResultSet account = pst.executeQuery();
            
            while(account.next()){
                Flag = 1;
                String DatabaseUserName = account.getString("UserName").trim();
                String DatabasePassword = account.getString("Password").trim();
                        
                if(DatabaseUserName.equals(UserName) && DatabasePassword.equals(Password)){
                            
                    int yourIndex = UserAccount.newUser(account.getInt("CustomerId"), DatabaseUserName, "CustomerAccount");
                    request.setAttribute("UserName", DatabaseUserName);
                    request.setAttribute("UserIndex", yourIndex);
                    
                    SessionID = request.getRequestedSessionId();
                            
                    try{
                        Class.forName(Driver);
                        Connection SessionConn = DriverManager.getConnection(url, user, password);
                        String SessionString = "insert into QueueObjects.UserSessions(UserIndex,SessionNo) values(?,?)";
                        PreparedStatement SessionPst = SessionConn.prepareStatement(SessionString);
                        SessionPst.setInt(1, yourIndex);
                        SessionPst.setString(2, SessionID);
                                
                        SessionPst.executeUpdate();
                                
                    }catch(Exception e){}
                    
                    savePassword (request.getSession(), UserName, Password);
                    
                    request.getRequestDispatcher("ProviderCustomerPage.jsp").forward(request, response);
                    
                    UserID = account.getInt("CustomerId");
                    ProcedureClass.CustomerID = account.getInt("CustomerId");
                    //UserAccount.AccountType = "CustomerAccount";
                    //response.sendRedirect("ProviderCustomerPage.jsp");
                            
                }
                else{
                    Flag = 0;
                }
                
            }
            
            //if query from outer try block was did not return any value(s)
            //send query to providers table
            if(UserID == 0){
                try{
                    Class.forName(Driver);
                    Connection conn2 = DriverManager.getConnection(url, user, password);
                    String Query2 = "Select * from QueueServiceProviders.UserAccount where UserName =? and Password =?";
                    PreparedStatement pst2 = conn2.prepareStatement(Query2);
                    pst2.setString(1,UserName);
                    pst2.setString(2,Password);
                    ResultSet account2 = pst2.executeQuery();
                    
                    while(account2.next()){
                        Flag = 1;
                        String DatabaseUserName = account2.getString("UserName").trim();
                        String DatabasePassword = account2.getString("Password").trim();
                        
                        if(DatabaseUserName.equals(UserName) && DatabasePassword.equals(Password)){
                            
                            int yourIndex = UserAccount.newUser(account2.getInt("Provider_ID"), DatabaseUserName , "BusinessAccount");
                            
                            request.setAttribute("UserIndex", yourIndex);
                            request.setAttribute("UserName", DatabaseUserName);
                            
                            SessionID = request.getRequestedSessionId();
                            
                            try{
                                Class.forName(Driver);
                                Connection SessionConn = DriverManager.getConnection(url, user, password);
                                String SessionString = "insert into QueueObjects.UserSessions(UserIndex,SessionNo) values(?,?)";
                                PreparedStatement SessionPst = SessionConn.prepareStatement(SessionString);
                                SessionPst.setInt(1, yourIndex);
                                SessionPst.setString(2, SessionID);
                                
                                SessionPst.executeUpdate();
                                
                            }catch(Exception e){}
                            
                            saveProvPassword (request.getSession(), UserName, Password);
                            
                            request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
                            
                            //UserAccount.UserID = account2.getInt("Provider_ID");
                            //UserAccount.AccountType = "BusinessAccount";
                            //response.sendRedirect("ServiceProviderPage.jsp");
                            
                            
                            
                        }
                        else{
                            Flag = 0;
                        }
                        
                    }
                    
                    //JOptionPane.showMessageDialog(null, SessionID);
                    
                }catch(Exception e ){
                    e.printStackTrace();
                }
                
                
                if(Flag == 0){
                    String Message = "Unable to login. Enter valid Username and Password";
                    response.sendRedirect("LogInPage.jsp?Message="+Message);
                }
            }
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

    public void savePassword (HttpSession session, String username, String password){
        if(session.getAttribute("ThisUserName") != null && session.getAttribute("ThisUserPassword") != null){
            session.removeAttribute("ThisProvUserName");
            session.removeAttribute("ThisProvUserPassword");
        }
        session.setAttribute("ThisUserName", username);
        session.setAttribute("ThisUserPassword", password);
    }
    
    public void saveProvPassword (HttpSession session, String username, String password){
        if(session.getAttribute("ThisProvUserName") != null && session.getAttribute("ThisProvUserPassword") != null){
            session.removeAttribute("ThisProvUserName");
            session.removeAttribute("ThisProvUserPassword");
        }
        session.setAttribute("ThisProvUserName", username);
        session.setAttribute("ThisProvUserPassword", password);
    }
}
