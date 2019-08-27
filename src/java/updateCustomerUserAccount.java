

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


public class updateCustomerUserAccount extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //Database connection parameters
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String CustomerID = request.getParameter("CustomerID");
        
        String FirstName = request.getParameter("firstNameFld");
        String MiddleName = request.getParameter("middleNameFld");
        String LastName = request.getParameter("lastNameFld");
        String PhoneNumber = request.getParameter("phoneNumberFld");
        String Email = request.getParameter("emailFld");
        String UserIndex = request.getParameter("UserIndex");
        
        String HouseNumber = request.getParameter("houseNumberFld");
        String StreetName = request.getParameter("streetAddressFld");
        String Town = request.getParameter("townFld");
        String City = request.getParameter("cityFld");
        String Country = request.getParameter("countryFld");
        String ZipCode = request.getParameter("zipCodeFld");
        
        try{
            
            Class.forName(Driver);
            Connection conn = DriverManager.getConnection(url, user, password);
            String updateString = "update ProviderCustomers.CustomerInfo set First_Name =?, "
                    + "Middle_Name =?, Last_Name =?, Phone_Number =?, "
                    + "Email =? where Customer_ID=?";
            
            PreparedStatement updatePst = conn.prepareStatement(updateString);
            updatePst.setString(1,FirstName);
            updatePst.setString(2,MiddleName);
            updatePst.setString(3,LastName);
            updatePst.setString(4,PhoneNumber);
            updatePst.setString(5,Email);
            updatePst.setString(6, CustomerID);
            
            updatePst.executeUpdate();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            
            Class.forName(Driver);
            Connection addressConn = DriverManager.getConnection(url, user, password);
            String addressString = "update QueueObjects.CustomerAddress set House_Number =?, Street_Name =?, "
                    + "Town =?, City =?, Country =?, Zipcode =? where Customer_ID =?";
            
            PreparedStatement addressPst = addressConn.prepareStatement(addressString);
            addressPst.setString(1, HouseNumber);
            addressPst.setString(2, StreetName);
            addressPst.setString(3, Town);
            addressPst.setString(4, City);
            addressPst.setString(5, Country);
            addressPst.setString(6, ZipCode);
            addressPst.setString(7, CustomerID);
            
            addressPst.executeUpdate();
            
            //response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex);
            JOptionPane.showMessageDialog(null, "Profile updated successfully!");
            
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

}
