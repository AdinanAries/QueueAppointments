/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */

public class PageController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        try{
            int UserID = 0;

            int redirected = 0;
            int UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            String UserName = request.getParameter("User");
            //JOptionPane.showMessageDialog(null, UserIndex);

            String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();

            if(tempAccountType.equals("CustomerAccount")){
                //request.setAttribute("UserIndex", UserIndex);
                redirected = 1;
                response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+UserName);
            }

            if(tempAccountType.equals("BusinessAccount")){
                //request.setAttribute("UserIndex", UserIndex);
                if(redirected == 0){
                    response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+UserIndex+"&User="+UserName);
                    redirected = 1;
                }
            }

            else if(UserID == 0){
                if(redirected == 0){
                    redirected = 1;
                    response.sendRedirect("LogInPage.jsp");
                }
            }
        
        }
        catch(Exception e){
            
            response.sendRedirect("LogInPage.jsp");
        
        }
        
            //if(UserAccount.AccountType == "CustomerAccount")
                //response.sendRedirect("ProviderCustomerPage.jsp");
            
            //else if(UserAccount.AccountType == "BusinessAccount")
                //response.sendRedirect("ServiceProviderPage.jsp");
            
            //else if(UserAccount.AccountType == ""){
                //response.sendRedirect("LogInPage.jsp");
                //UserAccount.LoginStatusMessage = "You are not logged in. Login to view your user dashboard";
            //}

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
