

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

public class UpdateProvBizInfoController extends HttpServlet {

  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String ProviderID = request.getParameter("ProviderID");
        String BusinessName = request.getParameter("BusinessNameFld");
        String BusinessEmail = request.getParameter("BusinessEmailFld");
        String BusinessTel = request.getParameter("BusinessTelephoneNumberFld");
        String BusinessType = request.getParameter("BusinessType");
        
        //getting AddressInfo
        String HouseNumber = request.getParameter("HouseNumber");
        String Street = request.getParameter("Street");
        String Town = request.getParameter("Town");
        String City = request.getParameter("City");
        String Country = request.getParameter("Country");
        String ZipCode = request.getParameter("ZCode");
        
        /*JOptionPane.showMessageDialog(null, ProviderID);
        JOptionPane.showMessageDialog(null, BusinessName);
        JOptionPane.showMessageDialog(null, BusinessEmail);
        JOptionPane.showMessageDialog(null, BusinessTel);
        JOptionPane.showMessageDialog(null, BusinessType);
        JOptionPane.showMessageDialog(null, HouseNumber);
        JOptionPane.showMessageDialog(null, Street);
        JOptionPane.showMessageDialog(null, City);
        JOptionPane.showMessageDialog(null, Country);
        JOptionPane.showMessageDialog(null, ZipCode);
        JOptionPane.showMessageDialog(null, Town);*/
        
        
        try{
            Class.forName(Driver);
            Connection BizInfoConn = DriverManager.getConnection(url, user, password);
            String BizInfoString = "Update QueueServiceProviders.ProviderInfo set Company = ?, Service_Type = ? where Provider_ID = ?";
            PreparedStatement BizInfoPst = BizInfoConn.prepareStatement(BizInfoString);
            BizInfoPst.setString(1, BusinessName);
            BizInfoPst.setString(2, BusinessType);
            BizInfoPst.setString(3, ProviderID);
            
            BizInfoPst.executeUpdate();
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection BizInfoConn = DriverManager.getConnection(url, user, password);
            String BizInfoString = "Update QueueServiceProviders.BusinessInfo set Business_Name = ?, Business_Email = ?, "
                    + "Business_Tel = ?, Business_Type = ? where Provider_ID = ?";
            PreparedStatement BizInfoPst = BizInfoConn.prepareStatement(BizInfoString);
            BizInfoPst.setString(1, BusinessName);
            BizInfoPst.setString(2, BusinessEmail);
            BizInfoPst.setString(3, BusinessTel);
            BizInfoPst.setString(4, BusinessType);
            BizInfoPst.setString(5, ProviderID);
            
            BizInfoPst.executeUpdate();
            
            BizInfoPst.executeUpdate();
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Class.forName(Driver);
            Connection BizInfoConn = DriverManager.getConnection(url, user, password);
            String BizInfoString = "Update QueueObjects.ProvidersAddress set House_Number = ?, Street_Name = ?, Town = ?,"
                    + " City = ?, Country = ?,  Zipcode = ? where ProviderID = ?";
            PreparedStatement BizInfoPst = BizInfoConn.prepareStatement(BizInfoString);
            BizInfoPst.setString(1, HouseNumber);
            BizInfoPst.setString(2, Street);
            BizInfoPst.setString(3, Town);
            BizInfoPst.setString(4, City);
            BizInfoPst.setString(5, Country);
            BizInfoPst.setString(6, ZipCode);
            BizInfoPst.setString(7, ProviderID);
            
            BizInfoPst.executeUpdate();
            
            JOptionPane.showMessageDialog(null, "Update Successful");
            //response.sendRedirect("ServiceProviderPage.jsp");
            
            
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
