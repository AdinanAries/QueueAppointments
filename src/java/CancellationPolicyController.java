

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

public class CancellationPolicyController extends HttpServlet {

    String Driver = "";
    String url = "";
    String user = "";
    String password = "";
        
    @Override
    public void init(ServletConfig config){
                
        url = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        user = config.getServletContext().getAttribute("DBUser").toString();
        password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }
   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Percentage = request.getParameter("ChargePercent");
        String DurationHH = request.getParameter("DurationFldHH");
        String DurationMM = request.getParameter("DurationFldMM");
        String RMVCnclPlcy = request.getParameter("RMVCnclPlcy");
        String TimeElapsePlcy = request.getParameter("TimeElapse");
        String ChargePlcy = request.getParameter("ChargeCost");
        String ProviderID = request.getParameter("ProviderID");
        
        /*JOptionPane.showMessageDialog(null, "ProviderID: "+ ProviderID);
        JOptionPane.showMessageDialog(null, "Percent: " + Percentage);
        JOptionPane.showMessageDialog(null, "DurationHH: " + DurationHH);
        JOptionPane.showMessageDialog(null, "DurationMM: " +DurationMM);
        JOptionPane.showMessageDialog(null, "RMVCnclPlcy: " + RMVCnclPlcy);
        JOptionPane.showMessageDialog(null, "TimeElapse: "+ TimeElapsePlcy);
        JOptionPane.showMessageDialog(null, "ChargePlcy: " + ChargePlcy);*/
        
        
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
                break;
            case 5:
                Duration = 300 + MM;
                break;
            default: Duration = MM;
            
        } 
        
        
        if(RMVCnclPlcy.equals("ON")){
            
            //setting charge percent to zero
            try{
                Class.forName(Driver);
                Connection DltPolicyConn = DriverManager.getConnection(url, user, password);
                String DltPolicyString = "Update QueueServiceProviders.Settings set CurrentValue = ? where If_providerID = ? and Settings like 'CnclPlcyChargeCost%'";
                PreparedStatement DltPolicyPst = DltPolicyConn.prepareStatement(DltPolicyString);
                DltPolicyPst.setString(1, "0");
                DltPolicyPst.setString(2, ProviderID);
                
                DltPolicyPst.executeUpdate();
                
            }catch(Exception e){
                e.printStackTrace();
            }
            
            //setting time elapse to zero
            try{
                Class.forName(Driver);
                Connection DltPolicyConn = DriverManager.getConnection(url, user, password);
                String DltPolicyString = "Update QueueServiceProviders.Settings set CurrentValue = ? where If_providerID = ? and Settings like 'CnclPlcyTimeElapse%'";
                PreparedStatement DltPolicyPst = DltPolicyConn.prepareStatement(DltPolicyString);
                DltPolicyPst.setString(1, "0");
                DltPolicyPst.setString(2, ProviderID);
                
                DltPolicyPst.executeUpdate();
                
                //response.sendRedirect("ServiceProviderPage.jsp");
                JOptionPane.showMessageDialog(null, "Update Successful");
                
            }catch(Exception e){
                e.printStackTrace();
            }
            
        }
        else{
            
            //inserting charge percentage settings
            try{

                Class.forName(Driver);
                Connection PolicyConn = DriverManager.getConnection(url, user, password);
                String PolicyString = "Update QueueServiceProviders.Settings set CurrentValue = ? where If_providerID = ? and Settings like 'CnclPlcyChargeCost%'";
                PreparedStatement PolicyPst = PolicyConn.prepareStatement(PolicyString);
                PolicyPst.setString(1, Percentage);
                PolicyPst.setString(2, ProviderID);
                
                PolicyPst.executeUpdate();
                
            }catch(Exception e){
                e.printStackTrace();
            }


            //inserting time elapse settings
             try{

                Class.forName(Driver);
                Connection PolicyConn = DriverManager.getConnection(url, user, password);
                String PolicyString = "Update QueueServiceProviders.Settings set CurrentValue = ? where If_providerID = ? and Settings like 'CnclPlcyTimeElapse%'";
                PreparedStatement PolicyPst = PolicyConn.prepareStatement(PolicyString);
                PolicyPst.setString(1, Integer.toString(Duration));
                PolicyPst.setString(2, ProviderID);
                
                PolicyPst.executeUpdate();

                //response.sendRedirect("ServiceProviderPage.jsp");
                JOptionPane.showMessageDialog(null, "Update Successful");
            }catch(Exception e){
                e.printStackTrace();
            }
             
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
