

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.swing.JOptionPane;

@MultipartConfig(maxFileSize = 16177215)

public class PostProvNews extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //request.getParameter('Photo');
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String Message = request.getParameter("Message");
        String Visibility = request.getParameter("NewsVisibility");
        String Date = request.getParameter("Date");
        String Time = request.getParameter("Time");
        String ProviderID = request.getParameter("ProviderID");
        
        String ID = "";
        
        InputStream inputStream2 = null; // input stream of the upload file
        
        Part filePart2 = request.getPart("Photo");
        if (filePart2 != null) {
            // prints out some information for debugging
            System.out.println(filePart2.getName());
            System.out.println(filePart2.getSize());
            System.out.println(filePart2.getContentType());
             
            // obtains input stream of the upload file
            inputStream2 = filePart2.getInputStream();
        }
        
        
                try{

                    Class.forName(Driver);
                    Connection UpdateConn = DriverManager.getConnection(url, user, password);
                    String UpdateString = "Insert into QueueServiceProviders.MessageUpdates (ProvID, Msg, MsgPhoto, DateOfUpdate, TimeOfUpdate, VisibleTo) "
                            + "values (?, ?, ?, ?, ?, ?)";
                    PreparedStatement UpdatePst = UpdateConn.prepareStatement(UpdateString);
                    UpdatePst.setString(1, ProviderID);
                    UpdatePst.setString(2, Message);
                    UpdatePst.setString(4, Date);
                    UpdatePst.setString(5, Time);
                    UpdatePst.setString(6, Visibility);

                    if (inputStream2 != null) {
                        // fetches input stream of the upload file for the blob column
                        UpdatePst.setBlob(3, inputStream2);
                    }
                    
                    int row = UpdatePst.executeUpdate();
                    

                }catch(Exception e){
                    e.printStackTrace();
                }
                
                
                    try{
                        Class.forName(Driver);
                        Connection IDConn = DriverManager.getConnection(url, user, password);
                        String IDString = "Select * from QueueServiceProviders.MessageUpdates where ProvID = ? and DateOfUpdate = ? and TimeOfUpdate = ? and VisibleTo = ?";
                        PreparedStatement IDPst = IDConn.prepareStatement(IDString);
                        
                        IDPst.setString(1, ProviderID);
                        IDPst.setString(2, Date);
                        IDPst.setString(3, Time);
                        IDPst.setString(4, Visibility);
                        
                        
                        ResultSet IDRec = IDPst.executeQuery();
                        
                        while(IDRec.next()){
                            ID = IDRec.getString("MsgID");
                        }
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                    
            if(Visibility.equals("Customer")){
                
                try{
                
                    Class.forName(Driver);
                    Connection ClientConn = DriverManager.getConnection(url, user, password);
                    String ClientQuery = "select * from QueueServiceProviders.ClientsList where ProvID = ?";
                    PreparedStatement ClientPst = ClientConn.prepareStatement(ClientQuery);
                    ClientPst.setString(1, ProviderID);
                    
                    ResultSet ClientsRec = ClientPst.executeQuery();
                    
                    while(ClientsRec.next()){
                        
                        String CustID = ClientsRec.getString("CustomerID").trim();
                        
                        try{
                            Class.forName(Driver);
                            Connection CustConn = DriverManager.getConnection(url, user, password);
                            String CustString = "insert into ProviderCustomers.ProvNewsForClients (MessageID, ProvID, CustID) values (?,?,?)";
                            PreparedStatement CustPst = CustConn.prepareStatement(CustString);
                            CustPst.setString(1, ID);
                            CustPst.setString(2, ProviderID);
                            CustPst.setString(3, CustID);
                            
                            CustPst.executeUpdate();
                            
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
            
                response.getWriter().print(ID);
                //JOptionPane.showMessageDialog(null, ID);
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
