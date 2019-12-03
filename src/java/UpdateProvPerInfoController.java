

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


public class UpdateProvPerInfoController extends HttpServlet {

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
        
        String ProviderID = request.getParameter("ProviderID");
        String FirstName = request.getParameter("FirstNameFld").trim().replace("( )+", " ");
        String MiddleName = request.getParameter("MiddleNameFld").trim().replace("( )+", " ");
        String LastName = request.getParameter("LastNameFld").trim().replace("( )+", " ");
        String MobileNumber = request.getParameter("MobileNumberFld").trim().replace("( )+", " ");
        String Email = request.getParameter("EmailFld").trim().replace("( )+", " ");
        
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
            //JOptionPane.showMessageDialog(null, "Update successful");
            response.getWriter().print("Update successful");
            
            
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
