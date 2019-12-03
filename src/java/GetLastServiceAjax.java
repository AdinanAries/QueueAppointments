
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


public class GetLastServiceAjax extends HttpServlet {

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
        
        int ExistsFlag = 0;
        
        String ServiceName = request.getParameter("SerivceNameFld");
        String PriceDollar = request.getParameter("ServicePriceFldDD");
        String PriceCent = request.getParameter("ServicePriceFldCC");
        String DurationHH = request.getParameter("DurationFldHH");
        String DurationMM = request.getParameter("DurationFldMM");
        String ServiceDesc = request.getParameter("DescriptionFld");
        String ProviderID = request.getParameter("ProviderID");
        
        //JSON fields
        String SVCID = "";
        String Name = "";
        String Price = "";
        String Dur = "";
        String Desc = "";
        
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
            Connection GetSVCConn = DriverManager.getConnection(url, user, password);
            String GetSVCString = "Select * from QueueServiceProviders.ServicesAndPrices where ProviderID = ? and ServiceName = ? and Price = ? and ServiceDescription = ? and ServiceDuration = ?";
            PreparedStatement GetSVCPst = GetSVCConn.prepareStatement(GetSVCString);
            GetSVCPst.setString(1,ProviderID);
            GetSVCPst.setString(2, ServiceName);
            GetSVCPst.setString(3, ServicePrice);
            GetSVCPst.setString(4, ServiceDesc);
            GetSVCPst.setInt(5, Duration);
            
            ResultSet SVCRec = GetSVCPst.executeQuery();
            
            while(SVCRec.next()){
                SVCID = SVCRec.getString("ServiceID").trim();
                Name = SVCRec.getString("ServiceName").trim();
                Price = SVCRec.getString("Price").trim();
                Desc = SVCRec.getString("ServiceDescription").trim();
                Dur = SVCRec.getString("ServiceDuration").trim();
            }
            
            //response.sendRedirect("ServiceProviderPage.jsp");
            //JOptionPane.showMessageDialog(null, "Service Added Successfully!");
            response.getWriter().print(
                "{"
                  +"\"ID\":\""+SVCID+"\","
                  +"\"Name\":\""+Name+"\","
                  +"\"Price\":\""+Price+"\","
                  +"\"Desc\":\""+Desc+"\","
                  +"\"Dur\":\""+Dur+"\""+
                "}"
            );
            
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
