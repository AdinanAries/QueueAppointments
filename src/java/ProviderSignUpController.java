

import com.arieslab.queue.queue_model.UserAccount;
import com.arieslab.queue.queue_model.*;
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
import javax.swing.JOptionPane;

public class ProviderSignUpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int UserID = 0;
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String URL = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        int UserIndex = ExistingProviderAccountsModel.getUserIndex();
        
        /*ExistingProviderAccountsModel aUser = new ExistingProviderAccountsModel();
        int UserIndex = 0;
        ExistingProviderAccountsModel.SignupUserList.add(aUser);*/
        
        String fName = request.getParameter("firstProvName");
        String mName = request.getParameter("middleProvName");
        String lName = request.getParameter("lastProvName");
        String email = request.getParameter("provEmail");
        String phoneNumber = request.getParameter("provPhoneNumber");
        
        String businessName = request.getParameter("businessName");
        String businessLocation = request.getParameter("businessLocation");
        String businessEmail = request.getParameter("businessEmail");
        String businessTel = request.getParameter("businessTel");
        String businessType = request.getParameter("businessType");
        
        if(businessType.equalsIgnoreCase("Other"))
            businessType = request.getParameter("otherBusinessType");
        
        //address fields
        String House_Number = "";
        String Street_Name = "";
        String Town = "";
        String City = "";
        String Country = "";
        String Zipcode = "";
        
        boolean isExistingAccount = false;
        
        //ExistingProviderAccountsModel.AccountsList.clearAccountsList();
        
        //checking if telephone number already exists
        try{
            Class.forName(Driver);
            Connection checkTelConn = DriverManager.getConnection(URL, user, password);
            String checkTelString = "Select * from QueueServiceProviders.ProviderInfo where Phone_Number = ?";
            PreparedStatement checkTelPst = checkTelConn.prepareStatement(checkTelString);
            checkTelPst.setString(1, phoneNumber);
            ResultSet checkTelRow = checkTelPst.executeQuery();
            
            int istel = 0;
            while(checkTelRow.next()){
                
                istel = 1;
                isExistingAccount = true;
                ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkTelRow.getInt("Provider_ID"));
                //JOptionPane.showMessageDialog(null, "A services provider account associated with this mobile number already exists");
                
            }
            
            if(istel == 1)
                response.sendRedirect("NotSuccessfulPageProviderAccount.jsp?UserIndex="+UserIndex);
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        //checking if this user account already exists
        try{
            Class.forName(Driver);
            Connection checkAccountConn = DriverManager.getConnection(URL, user, password);
            String checkAccountString = "Select * from QueueServiceProviders.ProviderInfo where "
                    + "Email = ?";
            
           PreparedStatement checkAccountPst = checkAccountConn.prepareStatement(checkAccountString);
           
           checkAccountPst.setString(1, email);
           
           ResultSet checkAccountRows = checkAccountPst.executeQuery();
           
           int isuser = 0;
           while(checkAccountRows.next()){
               
               isuser = 1;
               isExistingAccount = true;
               ExistingProviderAccountsModel.SignupUserList.get(UserIndex).addAccountToList(checkAccountRows.getInt("Provider_ID"));
               //JOptionPane.showMessageDialog(null, "User Account Already Exists");
           }
           
            if(isuser == 1)
                response.sendRedirect("NotSuccessfulPageProviderAccount.jsp?UserIndex="+UserIndex);
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        
        
        
        if(isExistingAccount == false){
        //getting address request parameters
        try{
            
            House_Number = request.getParameter("HouseNumber");
            Street_Name = request.getParameter("Street");
            Town = request.getParameter("Town");
            City = request.getParameter("City");
            Country = request.getParameter("Country");
            Zipcode = request.getParameter("ZCode");
            
        }catch(Exception e){}
        
        
        String userName = request.getParameter("provUserName");
        String Password = request.getParameter("firstProvPassword");
        
        //UserAccount.UserID = 0;
        //UserAccount.AccountType = "";
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String insert = "Insert into QueueServiceProviders.ProviderInfos (First_Name, Middle_Name, "
                    + "Last_Name, Date_Of_Birth, Phone_Number, Email, Company, Ratings, Service_Type) values "
                    + "(?, ?, ?,'1990-01-01', ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(insert);
            pst.setString(1,fName);
            pst.setString(2,mName);
            pst.setString(3,lName);
            pst.setString(4, phoneNumber);
            pst.setString(5, email);
            pst.setString(6, businessName);
            pst.setInt(7, 1);
            pst.setString(8, businessType);
            
            pst.executeUpdate();
           
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
                    
                    Class.forName(Driver);
                    Connection connSelect = DriverManager.getConnection(URL, user, password);
                    String select = "Select * from QueueServiceProviders.ProviderInfos where First_Name = ? and Middle_Name = ? and "
                            + " Last_Name = ? and Phone_Number = ? and Email = ? and Company = ? and Service_Type = ?";
                    PreparedStatement selectPst = connSelect.prepareStatement(select);
                    
                    selectPst.setString(1,fName);
                    selectPst.setString(2,mName);
                    selectPst.setString(3,lName);
                    selectPst.setString(4, phoneNumber);
                    selectPst.setString(5, email);
                    selectPst.setString(6, businessName);
                    selectPst.setString(7, businessType);
                    
                    ResultSet rows = selectPst.executeQuery();
                    
                    while(rows.next()){
                        
                        UserID = rows.getInt("Provider_ID");
                    }
                    
                }
        catch(Exception e){
                e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(URL, user, password);
            String insert = "Insert into QueueServiceProviders.ProviderInfo (Provider_ID, First_Name, Middle_Name, "
                    + "Last_Name, Date_Of_Birth, Phone_Number, Email, Company, Ratings, Service_Type) values "
                    + "(?, ?, ?, ?,'1990-01-01', ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(insert);
            pst.setInt(1, UserID);
            pst.setString(2, fName);
            pst.setString(3, mName);
            pst.setString(4, lName);
            pst.setString(5, phoneNumber);
            pst.setString(6, email);
            pst.setString(7, businessName);
            pst.setInt(8, 1);
            pst.setString(9, businessType);
            
            pst.executeUpdate();
           
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
                    
            Class.forName(Driver);
            Connection connBusiness = DriverManager.getConnection(URL, user, password);
            String insertBusiness = "Insert into QueueServiceProviders.BusinessInfo values  (?, ?, ?, ?, ?)";
            PreparedStatement pstBusiness = connBusiness.prepareStatement(insertBusiness);

            pstBusiness.setInt(1, UserID);
            pstBusiness.setString(2, businessName);
            pstBusiness.setString(3, businessEmail);
            pstBusiness.setString(4, businessTel);
            pstBusiness.setString(5, businessType);


            pstBusiness.executeUpdate();

        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        //address insert here
        try{
            
            Class.forName(Driver);
            Connection Addressconn = DriverManager.getConnection(URL, user, password);
            String AddressString = "Insert into QueueObjects.ProvidersAddress values ( ?,?,?,?,?,?,? )";
            PreparedStatement AddressPst = Addressconn.prepareStatement(AddressString);
            AddressPst.setInt(1, UserID);
            AddressPst.setString(2, House_Number);
            AddressPst.setString(3, Street_Name);
            AddressPst.setString(4, Town);
            AddressPst.setString(5, City);
            AddressPst.setString(6, Country);
            AddressPst.setString(7, Zipcode);
            
            AddressPst.executeUpdate();
           
        }
        catch(Exception e){
            e.printStackTrace();
        }  
      
            

               
        try{
                    
            Class.forName(Driver);
            Connection conn3 = DriverManager.getConnection(URL, user, password);
            String insert2 = "Insert into QueueServiceProviders.UserAccount values (?, ?, ?)";
            PreparedStatement pst3 = conn3.prepareStatement(insert2);
            pst3.setInt(1, UserID);
            pst3.setString(2,userName);
            pst3.setString(3, Password);
                    
            pst3.executeUpdate();
                    
            if(UserID != 0){
                
                int yourIndex = UserAccount.newUser(UserID, userName, "BusinessAccount");
                //request.setAttribute("UserIndex", yourIndex);
                response.sendRedirect("ServiceProviderPage.jsp?UserIndex="+yourIndex+"&User="+userName);
                //UserAccount.AccountType = "BusinessAccount";
                //response.sendRedirect("ServiceProviderPage.jsp");
            }
            else{
                response.sendRedirect("SignUpPage.jsp");
            }
                    
                    
        }
        catch(Exception e){
            e.printStackTrace();
        }

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

}
