
package com.queue.admins;

import com.arieslab.queue.queue_model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aries
 */
public class GetLogins extends HttpServlet {

    //LinkedList<UserAccount> LoggedInUsers = UserAccount.LoggedInUsers;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        /*String JSONRes = "{ \"TotalLogins\": " + LoggedInUsers.size() + ", \"UsersIDs\": ";
        String UserIDs = " [ ";

                boolean isFirstRound = true;

                for(int i = 0; i < LoggedInUsers.size(); i++){

                    if(!isFirstRound)
                        UserIDs += ", ";

                    UserIDs += Integer.toString(LoggedInUsers.get(i).getUserID());

                    isFirstRound = false;
                }

            UserIDs += " ] ";

            JSONRes += UserIDs;
            JSONRes += "}";

            response.getWriter().print(JSONRes);*/

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

}
