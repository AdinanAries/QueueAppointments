

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

@WebServlet(urlPatterns = {"/AddClientsListController"})
public class AddClientsListController extends HttpServlet {
    
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
        
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        
        try{
            Class.forName(Driver);
            Connection getClientConn = DriverManager.getConnection(url, user, password);
            String getClientString = "select * from QueueServiceProviders.ClientsList where ProvID = ? and CustomerID = ?";
            PreparedStatement getClientPST = getClientConn.prepareStatement(getClientString);
            getClientPST.setString(1,ProviderID);
            getClientPST.setString(2,CustomerID);
            
            ResultSet clientRec = getClientPST.executeQuery();
            
            while(clientRec.next()){
                
                ExistsFlag = 1;
                JOptionPane.showMessageDialog(null, "Client already in your list");
                //response.sendRedirect("ServiceProviderPage.jsp");
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        if(ExistsFlag == 0){
        
            try{
                Class.forName(Driver);
                Connection AddClientConn = DriverManager.getConnection(url, user, password);
                String AddClientString = "Insert into QueueServiceProviders.ClientsList(ProvID,CustomerID) values (?,?)";
                PreparedStatement AddClientPST = AddClientConn.prepareStatement(AddClientString);
                AddClientPST.setString(1, ProviderID);
                AddClientPST.setString(2, CustomerID);

                AddClientPST.executeUpdate();

                //response.sendRedirect("ServiceProviderPage.jsp");
                JOptionPane.showMessageDialog(null, "Client added to your clients list");
                response.getWriter().print("notInList");

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

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
