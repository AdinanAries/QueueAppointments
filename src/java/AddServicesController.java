

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


public class AddServicesController extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        int ExistsFlag = 0;
        
        String ServiceName = request.getParameter("SerivceNameFld").trim().replaceAll("( )+", " ");
        String PriceDollar = request.getParameter("ServicePriceFldDD");
        String PriceCent = request.getParameter("ServicePriceFldCC");
        String DurationHH = request.getParameter("DurationFldHH");
        String DurationMM = request.getParameter("DurationFldMM");
        String ServiceDesc = request.getParameter("DescriptionFld").trim().replaceAll("( )+", " ");
        String ProviderID = request.getParameter("ProviderID");
        
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
            String AddSVCString = "insert into QueueServiceProviders.ServicesAndPrices(ProviderID, ServiceName, Price, ServiceDescription, ServiceDuration) values(?,?,?,?,?)";
            PreparedStatement AddSVCPst = AddSVCConn.prepareStatement(AddSVCString);
            AddSVCPst.setString(1,ProviderID);
            AddSVCPst.setString(2, ServiceName);
            AddSVCPst.setString(3, ServicePrice);
            AddSVCPst.setString(4, ServiceDesc);
            AddSVCPst.setInt(5, Duration);
            
            AddSVCPst.executeUpdate();
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            JOptionPane.showMessageDialog(null, "Service Added Successfully!");
            
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
