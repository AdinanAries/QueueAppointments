

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


public class UpdateProvPerInfoController extends HttpServlet {

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        String FirstName = request.getParameter("FirstNameFld");
        String MiddleName = request.getParameter("MiddleNameFld");
        String LastName = request.getParameter("LastNameFld");
        String MobileNumber = request.getParameter("MobileNumberFld");
        String Email = request.getParameter("EmailFld");
        
        try{
            Class.forName(Driver);
            Connection ProvInfoConn = DriverManager.getConnection(url, user, password);
            String ProvInfoString = "Update QueueServiceProviders.ProviderInfo set First_Name = ?, Middle_Name = ?, Last_Name = ?, Phone_Number = ?, Email = ? "
                    + "where Provider_ID = ?";
            PreparedStatement ProvInfoPst = ProvInfoConn.prepareStatement(ProvInfoString);
            ProvInfoPst.setString(1, FirstName);
            ProvInfoPst.setString(2, MiddleName);
            ProvInfoPst.setString(3, LastName);
            ProvInfoPst.setString(4, MobileNumber);
            ProvInfoPst.setString(5, Email);
            ProvInfoPst.setString(6, ProviderID);
            
            ProvInfoPst.executeUpdate();
            //response.sendRedirect("ServiceProviderPage.jsp");
            JOptionPane.showMessageDialog(null, "Update successful");
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
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
