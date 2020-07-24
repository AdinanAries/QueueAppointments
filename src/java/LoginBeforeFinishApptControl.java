/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.ProcedureClass;
import com.arieslab.queue.queue_model.QueuePWHash;
import com.arieslab.queue.queue_model.UserAccount;
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
import javax.servlet.http.HttpSession;

/**
 *
 * @author aries
 */
public class LoginBeforeFinishApptControl extends HttpServlet {

    //Database connection parameters
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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
           
           //hashing Password
           Password = QueuePWHash.GetHash(Password);
           
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
                    
                    UserID = account.getInt("CustomerId");
                    ProcedureClass.CustomerID = account.getInt("CustomerId");
                    
                    String jsonRes = "{\"status\":\"success\","
                            +          "\"customerID\":\""+UserID+"\","
                            +          "\"customerName\":\""+DatabaseUserName+"\","
                            +          "\"loginIndex\":\""+yourIndex+"\"}";
                    
                    response.getWriter().print(jsonRes);
                    //UserAccount.AccountType = "CustomerAccount";
                    //response.sendRedirect("ProviderCustomerPage.jsp");
                            
                }
                else{
                    Flag = 0;
                }
                
                break;
                
            }
        
        }catch(Exception e){}
        
        if(Flag == 0){
            String jsonRes = "{\"status\":\"fail\","
                            +          "\"customerID\":\"N/A\","
                            +          "\"customerName\":\"N/A\","
                            +          "\"loginIndex\":\"N/A\"}";
            response.getWriter().print(jsonRes);
        }
    
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
 
    public void savePassword (HttpSession session, String username, String password){
        if(session.getAttribute("ThisUserName") != null && session.getAttribute("ThisUserPassword") != null){
            session.removeAttribute("ThisUserName");
            session.removeAttribute("ThisUserPassword");
        }
        session.setAttribute("ThisUserName", username);
        session.setAttribute("ThisUserPassword", password);
    }
    
}
