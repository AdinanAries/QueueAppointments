

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author aries
 */
public class getLastProvNews extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        String MessageID = request.getParameter("MessageID");
        String MsgJSON = "";
        
        String Message = "";
        String ID = "";
        String Photo = "";
        
        try{
            Class.forName(Driver);
            Connection NewsConn = DriverManager.getConnection(url, user, password);
            String NewsQuery = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
            PreparedStatement NewsPst = NewsConn.prepareStatement(NewsQuery);
            NewsPst.setString(1, MessageID);
            ResultSet NewsRec = NewsPst.executeQuery();
            
            while(NewsRec.next()){
                
                ID = NewsRec.getString("MsgID").trim();
                Message = NewsRec.getString("Msg").trim();
                Message = Message.replace("\"", "");
                Message = Message.replace("'", "");
                Message = Message.replaceAll("\\s+", " ");
                Message = Message.replaceAll("( )+", " ");
                
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob NewsPic = NewsRec.getBlob("MsgPhoto"); 
                    InputStream inputStream = NewsPic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                    Photo = Base64.getEncoder().encodeToString(imageBytes);


                }
                catch(Exception e){}
                
                
                MsgJSON = "{"
                        +   "\"ID\": \"" + ID + "\", "
                        +   "\"Message\": \"" + Message + "\","
                        +   "\"Photo\": \"" + Photo + "\""
                        + "}";
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        response.getWriter().print(MsgJSON);
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
