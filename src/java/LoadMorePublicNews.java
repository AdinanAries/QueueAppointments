

import com.google.gson.Gson;
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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoadMorePublicNews extends HttpServlet {

    String Driver = "";
    String url = "";
    String User = "";
    String Password = "";
        
    @Override
    public void init(ServletConfig config){
                
        url = config.getServletContext().getAttribute("DBUrl").toString(); 
        Driver = config.getServletContext().getAttribute("DBDriver").toString();
        User = config.getServletContext().getAttribute("DBUser").toString();
        Password = config.getServletContext().getAttribute("DBPassword").toString();
        
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //response.setContentType("application/json");
        
        Gson gson = new Gson();
        
        //Using location for querying news for only specific area
                        String IDList = "(";
                        String PCity = "";
                        String PTown = "";
                        String PZipCode = "";
                        try{
                            PCity = request.getSession().getAttribute("UserCity").toString().trim();
                            PTown = request.getSession().getAttribute("UserTown").toString().trim();
                            PZipCode = request.getSession().getAttribute("UserZipCode").toString().trim();
                        }catch(Exception e){
                            PCity = "";
                            PTown = "";
                            PZipCode = "";
                        }

                        try{

                            Class.forName(Driver);
                            Connection conn = DriverManager.getConnection(url, User, Password);
                            String AddressQuery = "Select top 1000 ProviderID from QueueObjects.ProvidersAddress where City like '"+PCity+"%' and Town like '"+PTown+"%' ORDER BY NEWID()";
                             // and Zipcode = "+zipCode;//+" ORDER BY NEWID()"; adding zipcode to search filter is going to narrow down search results. keeping search result up to whole town coverage
                            PreparedStatement AddressPst = conn.prepareStatement(AddressQuery);
                            ResultSet ProvAddressRec = AddressPst.executeQuery();

                            boolean isFirst = true;
                            while(ProvAddressRec.next()){

                                if(!isFirst)
                                    IDList += ",";

                                IDList += ProvAddressRec.getString("ProviderID");
                                //JOptionPane.showMessageDialog(null, ProvAddressRec.getInt("ProviderID"));
                                //ProviderIDsFromAddress.add(ProvAddressRec.getInt("ProviderID"));
                                isFirst = false;
                            }
                            IDList += ")";
                            //JOptionPane.showMessageDialog(null, IDList);

                        }catch(Exception e){}
                        //This code snippet is need to be finished and replicated to all needed pages
        
        String JSONData = "[ ";
        
        try{
            Class.forName(Driver);
            Connection newsConn = DriverManager.getConnection(url, User, Password);
            String newsQuery = "Select top 10 * from QueueServiceProviders.MessageUpdates where ProvID in "+IDList+" and VisibleTo like 'Public%' ORDER BY NEWID()";
            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
            ResultSet newsRec = newsPst.executeQuery();
            int newsItems = 0;
                        
            while(newsRec.next()){
                            
                String base64Profile = "";
                newsItems++;
                            
                String ProvID = newsRec.getString("ProvID");
                String ProvFirstName = "";
                String ProvCompany = "";
                String ProvAddress = "";
                String ProvTel = "";
                String ProvEmail = "";
                            
                String Msg = newsRec.getString("Msg").trim();
                String MsgPhoto = "";
                            
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob Pic = newsRec.getBlob("MsgPhoto"); 
                    InputStream inputStream = Pic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                    MsgPhoto = Base64.getEncoder().encodeToString(imageBytes);


                }
                catch(Exception e){}
                            
                try{
                    Class.forName(Driver);
                    Connection ProvConn = DriverManager.getConnection(url, User, Password);
                    String ProvQuery = "Select * from QueueServiceProviders.ProviderInfo where Provider_ID = ?";
                    PreparedStatement ProvPst = ProvConn.prepareStatement(ProvQuery);
                    ProvPst.setString(1, ProvID);
                                    
                    ResultSet ProvRec = ProvPst.executeQuery();
                                    
                    while(ProvRec.next()){
                        ProvFirstName = ProvRec.getString("First_Name").trim();
                        ProvCompany = ProvRec.getString("Company").trim();
                        ProvTel = ProvRec.getString("Phone_Number").trim();
                        ProvEmail = ProvRec.getString("Email").trim();
                                        
                        try{    
                            //put this in a try catch block for incase getProfilePicture returns nothing
                            Blob Pic = ProvRec.getBlob("Profile_Pic"); 
                            InputStream inputStream = Pic.getBinaryStream();
                            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                            byte[] buffer = new byte[4096];
                            int bytesRead = -1;

                            while ((bytesRead = inputStream.read(buffer)) != -1) {
                                outputStream.write(buffer, 0, bytesRead);
                            }

                            byte[] imageBytes = outputStream.toByteArray();

                            base64Profile = Base64.getEncoder().encodeToString(imageBytes);


                        }
                        catch(Exception e){}
                                        
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
                                
                try{
                    Class.forName(Driver);
                    Connection ProvLocConn = DriverManager.getConnection(url, User, Password);
                    String ProvLocQuery = "select * from QueueObjects.ProvidersAddress where ProviderID = ?";
                    PreparedStatement ProvLocPst = ProvLocConn.prepareStatement(ProvLocQuery);
                    ProvLocPst.setString(1, ProvID);
                                    
                    ResultSet ProvLocRec = ProvLocPst.executeQuery();
                                    
                    while(ProvLocRec.next()){
                        String HouseNumber = ProvLocRec.getString("House_Number").trim();
                        String Street = ProvLocRec.getString("Street_Name").trim();
                        String Town = ProvLocRec.getString("Town").trim();
                        String City = ProvLocRec.getString("City").trim();
                        String ZipCode = ProvLocRec.getString("Zipcode").trim();
                                        
                        ProvAddress = HouseNumber + " " + Street + ", " + Town + ", " + City + " " + ZipCode;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
                    //append each JSON object here
                    //base64Profile, ProvFirstName, ProvCompany, ProvEmail, ProvTel, ProvAddress, Msg, MsgPhoto
                    JSONData += "{"
                            + "\"base64Profile\":\""+base64Profile+"\","
                            + "\"ProvFirstName\":\""+ProvFirstName+"\","
                            + "\"ProvCompany\":\""+ProvCompany+"\","
                            + "\"ProvEmail\":\""+ProvEmail+"\","
                            + "\"ProvTel\":\""+ProvTel+"\","
                            + "\"ProvAddress\":\""+ProvAddress+"\","
                            + "\"Msg\":\""+Msg+"\","
                            + "\"MsgPhoto\":\""+MsgPhoto+"\""
                            + "},";
                                
                    if(newsItems > 10)
                        break;
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        JSONData = JSONData.substring(0,JSONData.length()-1);
        JSONData += " ]";
        response.getWriter().print(JSONData);
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
