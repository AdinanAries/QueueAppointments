
package com.queue.admins;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.arieslab.queue.queue_model.UserAccount;
import java.util.ArrayList;
import java.util.LinkedList;
import javax.servlet.ServletConfig;

public class GetLoggedInUsersCount extends HttpServlet {
    
    String JSONRes = "";
    String UserIDs = "";
    
    String url = "";
    String user = "";
    String password = "";
    String Driver = "";
    //LinkedList<UserAccount> LoggedInUsers = UserAccount.LoggedInUsers;
    
   /* @Override
    public void init(ServletConfig config){
        
        url = config.getServletContext().getAttribute("").toString();
        user = config.getServletContext().getAttribute("").toString();
        password = config.getServletContext().getAttribute("").toString();
        Driver = config.getServletContext().getAttribute("").toString();
        
    }*/

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            int CustCounts = 0;
            int ProvCounts = 0;
            
            JSONRes = "{ \"TotalLogins\": " + UserAccount.LoggedInUsers.size() + ", \"UsersIDs\": ";
            UserIDs = " [ ";
           
            boolean isFirstRound = true;
            
            for(int i = 0; i < UserAccount.LoggedInUsers.size(); i++){
                
                if(UserAccount.LoggedInUsers.get(i).getAccountType().equals("CustomerAccount"))
                    CustCounts++;
                if(UserAccount.LoggedInUsers.get(i).getAccountType().equals("BusinessAccount"))
                    ProvCounts++;
                
                if(!isFirstRound)
                    UserIDs += ", ";
                
                UserIDs += "{ \"ID\":" + Integer.toString(UserAccount.LoggedInUsers.get(i).getUserID()) + ", \"AccountType\": \""+ UserAccount.LoggedInUsers.get(i).getAccountType() +"\"}";
                
                isFirstRound = false;
            }
            
        UserIDs += " ]";
        
        JSONRes += UserIDs;
        JSONRes += ", \"CustLogins\": " + CustCounts;
        JSONRes += ", \"ProvLogins\": " + ProvCounts;
        JSONRes += "}";
        
        response.getWriter().print(JSONRes);
        
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
