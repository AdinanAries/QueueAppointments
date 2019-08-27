

import com.arieslab.queue.queue_model.StatusesClass;
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

public class SetUserAddress extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //Database connection parameters
           String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
           String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
           String user = "sa";
           String password = "Password@2014";
           
           String CustomerID = request.getParameter("CustomerID");
           String HouseNumber = request.getParameter("houseNumberFld");
           String StreetName = request.getParameter("streetAddressFld");
           String Town = request.getParameter("townFld");
           String City = request.getParameter("cityFld");
           String Country = request.getParameter("countryFld");
           String ZipCode = request.getParameter("zipCodeFld");
           
           String UserIndex = request.getParameter("UserIndex");
           String NewUserName = request.getParameter("User");
           
           try{
               
               Class.forName(Driver);
               Connection addressConn = DriverManager.getConnection(url, user, password);
               String addressString = "insert into QueueObjects.CustomerAddress values"
                       + "(?,?,?,?,?,?,?)";
               
               PreparedStatement addressPst = addressConn.prepareStatement(addressString);
               addressPst.setString(1, CustomerID);
               addressPst.setString(2, HouseNumber);
               addressPst.setString(3, StreetName);
               addressPst.setString(4, Town);
               addressPst.setString(5, City);
               addressPst.setString(6, Country);
               addressPst.setString(7, ZipCode);
               
               addressPst.executeUpdate();
               JOptionPane.showMessageDialog(null, "Address added successfully!");
               response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
               
           }catch(Exception e){
               
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
