/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.arieslab.queue.queue_model.ExistingProviderAccountsModel;
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
public class SignupBeforeFinishApptControl extends HttpServlet {
    
    String Driver = "";
    String URL = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
                
        URL = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int UserID = 0;
        int UserIndex = ExistingProviderAccountsModel.getUserIndex();
        
        /*ExistingProviderAccountsModel aUser = new ExistingProviderAccountsModel();
        int UserIndex = 0;
        ExistingProviderAccountsModel.SignupUserList.add(aUser);*/
        
        String fName = request.getParameter("firstName").trim().replaceAll("( )+", " ");
        String mName = request.getParameter("middleName").trim().replaceAll("( )+", " ");
        String lName = request.getParameter("lastName").trim().replaceAll("( )+", " ");
        String email = request.getParameter("email").trim().replaceAll("( )+", " ");
        String phoneNumber = request.getParameter("phoneNumber").trim().replaceAll("( )+", " ");
        String userName = request.getParameter("userName");
        String Password = request.getParameter("firstPassword");
        
        //hashing Password
        Password = QueuePWHash.GetHash(Password);
        
        
        //UserAccount.UserID = 0;
        //UserAccount.AccountType = "";
        
        boolean isExistingAccount= false;
        
        //ExistingProviderAccountsModel.AccountsList.clearAccountsList();
        
        //checking if telephone number already exists
        try{
            Class.forName(Driver);
            Connection checkTelConn = DriverManager.getConnection(URL, user, password);
            String checkTelString = "Select Customer_ID from  ProviderCustomers.CustomerInfo where Phone_Number = ?";
            PreparedStatement checkTelPst = checkTelConn.prepareStatement(checkTelString);
            checkTelPst.setString(1, phoneNumber);
            ResultSet checkTelRow = checkTelPst.executeQuery();
            
            int istel = 0;
            while(checkTelRow.next()){
                
                istel = 1;
                isExistingAccount = true;
                //JOptionPane.showMessageDialog(null, UserIndex);
                //ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkTelRow.getInt("Customer_ID"));
                //JOptionPane.showMessageDialog(null, "An account associated with this mobile number already exists");
            }
            
            if(istel == 1){
                String jsonRes = "{\"status\":\"fail\","
                        + "\"msg\":\"An existing account is associated with the provided mobile number\"}";
                response.getWriter().print(jsonRes);
                //response.sendRedirect("NotSuccessfulPageCustomerAccount.jsp?UserIndex="+UserIndex);
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        //checking if this user account already exists
        try{
            Class.forName(Driver);
            Connection checkAccountConn = DriverManager.getConnection(URL, user, password);
            String checkAccountString = "Select * from ProviderCustomers.CustomerInfo where Email = ?";
            
           PreparedStatement checkAccountPst = checkAccountConn.prepareStatement(checkAccountString);
           
           checkAccountPst.setString(1, email);
           
           ResultSet checkAccountRows = checkAccountPst.executeQuery();
           
           int isuser = 0;
           while(checkAccountRows.next()){
               
               isuser = 1;
               isExistingAccount = true;
               
               //ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkAccountRows.getInt("Customer_ID"));
               //JOptionPane.showMessageDialog(null, "User Account Already Exists");
               
           }
           
           if(isuser == 1){
               String jsonRes = "{\"status\":\"fail\","
                        + "\"msg\":\"An existing account is associated with the provided email\"}";
                response.getWriter().print(jsonRes);
               //response.sendRedirect("NotSuccessfulPageCustomerAccount.jsp?UserIndex="+UserIndex);
           }
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        if(isExistingAccount == false){
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String insert = "Insert into ProviderCustomers.CustomerInfo (First_Name, Middle_Name, "
                    + "Last_Name, Date_Of_Birth, Phone_Number, Email) values (?,?,?,'1990-01-01',?,?)";
            PreparedStatement pst = conn.prepareStatement(insert);
            pst.setString(1,fName);
            pst.setString(2,mName);
            pst.setString(3,lName);
            pst.setString(4, phoneNumber);
            pst.setString(5, email);
            
            pst.executeUpdate();
           
        }
        catch(Exception e){
            e.printStackTrace();
        }
          
                try{
                    
                    Class.forName(Driver);
                    Connection conn2 = DriverManager.getConnection(URL, user, password);
                    String select = "Select * from ProviderCustomers.CustomerInfo where First_Name = ? and Middle_Name = ? and "
                            + " Last_Name = ? and Phone_Number = ? and Email = ?";
                    PreparedStatement pst2 = conn2.prepareStatement(select);
                    pst2.setString(1,fName);
                    pst2.setString(2,mName);
                    pst2.setString(3,lName);
                    pst2.setString(4, phoneNumber);
                    pst2.setString(5, email);
                    
                    ResultSet row = pst2.executeQuery();
                    
                    while(row.next()){
                        
                        UserID = row.getInt("Customer_ID");
                        
                    }
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
               
                try{
                    
                    Class.forName(Driver);
                    Connection conn3 = DriverManager.getConnection(URL, user, password);
                    String insert2 = "Insert into ProviderCustomers.UserAccount values "
                            + "(?, ?, ? )";
                    PreparedStatement pst3 = conn3.prepareStatement(insert2);
                    pst3.setInt(1, UserID);
                    pst3.setString(2,userName);
                    pst3.setString(3, Password);
                    pst3.executeUpdate();
                    
                    if(UserID != 0){
                        
                        /*/Send Queue admin an email for newly created accounts
                        {
                            String to = "tech.arieslab@outlook.com";
                            String subject = "Customer Account Added";
                            String msg = "Customer account has been added with the following details:\n";
                            msg += "CustomerID: " + UserID + "\n";
                            msg += "Customer Name: " + fName + " " + mName + " " + lName + "\n";
                            msg += "Email: " + email + "\n";
                            msg += "Tel: " + phoneNumber + "\n";


                            QueueMailerUtil EmailObj = new QueueMailerUtil();
                            EmailObj.send(to, subject, msg);
                        }*/
                        
                        savePassword (request.getSession(), userName, Password);
                        
                        int yourIndex = UserAccount.newUser(UserID, userName, "CustomerAccount");
                        //request.setAttribute("UserIndex", yourIndex);
                        
                        String jsonRes = "{\"status\":\"success\","
                            +          "\"customerID\":\""+UserID+"\","
                            +          "\"customerName\":\""+userName+"\","
                            +          "\"loginIndex\":\""+yourIndex+"\"}";
                    
                        response.getWriter().print(jsonRes);
                        
                        //response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+yourIndex+"&User="+userName);
                        
                        //UserAccount.AccountType = "CustomerAccount";
                        //response.sendRedirect("ProviderCustomerPage.jsp");
                    }
                   else{
                        //response.sendRedirect("SignUpPage.jsp");
                        String jsonRes = "{\"status\":\"fail\","
                        + "\"msg\":\"server was unable to fullfill this request\"}";
                        response.getWriter().print(jsonRes);
                    }
                    
                    
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                
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
