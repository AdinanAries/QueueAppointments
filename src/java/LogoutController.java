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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class LogoutController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
            String user = "sa";
            String password = "Password@2014";
        
            int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            //JOptionPane.showMessageDialog(null, UserIndex);
            //this message displays in the login status area of the main Queue page
            String Message = "You are not logged in";
            
            //setting UserAccount Fields to defaults
            UserAccount.LoggedInUsers.get(UserIndex).setAccountType("");
            UserAccount.LoggedInUsers.get(UserIndex).setUserID(0);
            
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
            catch(Exception e){}
            
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
