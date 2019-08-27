

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


public class ChangeServiceController extends HttpServlet {

  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        int ExistsFlag = 0;
        
        String ServiceName = request.getParameter("SerivceNameFld");
        String PriceDollar = request.getParameter("ServicePriceFldDD");
        String PriceCent = request.getParameter("ServicePriceFldCC");
        String DurationHH = request.getParameter("DurationFldHH");
        String DurationMM = request.getParameter("DurationFldMM");
        String ServiceDesc = request.getParameter("DescriptionFld");
        String ServiceID = request.getParameter("ServiceID");
        
        String ServicePrice = PriceDollar + "." + PriceCent;
        
        int HH = Integer.parseInt(DurationHH);
        int MM = Integer.parseInt(DurationMM);
        int Duration = 0;
        
        switch(HH){
            case 1:
                Duration = 60 + MM;
                break;
            case 2: 
                Duration = 120 + MM;
                break;
            case 3:
                Duration = 180 + MM;
                break;
            case 4:
                Duration = 240 + MM;
            case 5:
                Duration = 300 + MM;
                break;
            default: Duration = MM;
            
        } 
        
        try{
            Class.forName(Driver);
            Connection AddSVCConn = DriverManager.getConnection(url, user, password);
            String AddSVCString = "Update QueueServiceProviders.ServicesAndPrices set ServiceName = ?, Price = ?, ServiceDescription = ?, ServiceDuration = ? where ServiceID = ?";
            PreparedStatement AddSVCPst = AddSVCConn.prepareStatement(AddSVCString);
            AddSVCPst.setString(1, ServiceName);
            AddSVCPst.setString(2, ServicePrice);
            AddSVCPst.setString(3, ServiceDesc);
            AddSVCPst.setInt(4, Duration);
            AddSVCPst.setString(5, ServiceID);
            
            AddSVCPst.executeUpdate();
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            JOptionPane.showMessageDialog(null, "Service Updated Successfully!");
            
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
