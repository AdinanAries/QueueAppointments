/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aries
 */
public class LogoutController extends HttpServlet {
    
    String Driver = "";
    String url = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
        try{
            url = config.getServletContext().getAttribute("DBUrl").toString(); 
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            user = config.getServletContext().getAttribute("DBUser").toString();
            password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            //JOptionPane.showMessageDialog(null, UserIndex);
            //this message displays in the login status area of the main Queue page
            String Message = "You are not logged in";
            
            //UserAccount.UserID = 0;
            //UserAccount.AccountType = "";
            //UserAccount.UserName = "";
            
            try{
                Class.forName(Driver);
                Connection DltSesConn = DriverManager.getConnection(url, user, password);
                String DltSesString = "delete from QueueObjects.UserSessions where UserIndex = ?";
                PreparedStatement DltSesPst = DltSesConn.prepareStatement(DltSesString);
                DltSesPst.setInt(1, UserIndex);
                DltSesPst.executeUpdate();
            }
            catch(Exception e){
                System.out.println(e.getMessage());
            }
             
            if(request.getSession().getAttribute("ThisUserName")!= null && request.getSession().getAttribute("ThisUserPassword") != null){
                request.getSession().removeAttribute("ThisUserName");
                request.getSession().removeAttribute("ThisUserPassword");
            }
            
            if(request.getSession().getAttribute("ThisProvUserName") != null && request.getSession().getAttribute("ThisProvUserPassword") != null){
                request.getSession().removeAttribute("ThisProvUserName");
                request.getSession().removeAttribute("ThisProvUserPassword");
            }
            
            //setting UserAccount Fields to defaults
            try{
                UserAccount.LoggedInUsers.get(UserIndex).setAccountType(null);
                UserAccount.LoggedInUsers.get(UserIndex).setUserID(0);
            }catch(Exception e){
                System.out.println(e.getMessage());
            }
            
            response.sendRedirect("Queue.jsp?Message="+Message);
            
            
        
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
