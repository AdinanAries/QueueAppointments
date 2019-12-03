package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.OutputStream;
import java.util.Base64;
import java.io.File;
import java.io.FileInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import com.arieslab.queue.queue_model.*;
import java.sql.Statement;
import javax.swing.JOptionPane;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Connection;

public final class QueueSelectBusinessLoggedIn_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


        
       class getUserDetails{
           
           //class instance fields
           private Connection conn; //connection object variable
           private ResultSet records; //Resultset object variable
           private Statement st;
           private String Driver;
           private String url;
           private String User;
           private String Password;
           private String IDList = "(";
           
           public void initializeDBParams(String driver, String url, String user, String password){
               
               this.Driver = driver;
               this.url = url;
               this.User = user;
               this.Password = password;
           }
           
           public void getIDsFromAddress(String city, String town, String zipCode){
               
               try{
                   
                   Class.forName(Driver);
                   conn = DriverManager.getConnection(url, User, Password);
                   String AddressQuery = "Select ProviderID from QueueObjects.ProvidersAddress where City like '"+city+"%' and Town like '"+town+"%'";// and Zipcode = "+zipCode;//+" ORDER BY NEWID()";
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
               
           }
           
           public ResultSet getRecords(){
               
               try{
                    Class.forName(Driver); //registering driver class
                    conn = DriverManager.getConnection(url,User,Password); //creating a connection object
                    st = conn.createStatement();  //Creating a statement object
                    String  select = "Select top 10 * from QueueServiceProviders.ProviderInfo where Provider_ID in "+ IDList + " ORDER BY NEWID()"; //SQL query string
                    records = st.executeQuery(select); //execute Query

               }
               catch(Exception e){
                  e.printStackTrace();
                }
               
                return records;
            }
       }
       
    
  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write(" \n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("    \n");
      out.write("    <head>\n");
      out.write("        \n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("        <title>Queue</title>\n");
      out.write("        <link href=\"QueueCSS.css\" rel=\"stylesheet\" media=\"screen\" type=\"text/css\"/>\n");
      out.write("        \n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n");
      out.write("        <link rel=\"stylesheet\" href=\"//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css\">\n");
      out.write("        <link rel=\"stylesheet\" href=\"/resources/demos/style.css\">\n");
      out.write("        <script src=\"https://code.jquery.com/jquery-1.12.4.js\"></script>\n");
      out.write("        <script src=\"https://code.jquery.com/ui/1.12.1/jquery-ui.js\"></script>\n");
      out.write("        <script src=\"scripts/QueueLineDivBehavior.js\"></script>\n");
      out.write("        \n");
      out.write("        \n");
      out.write("        <!-- cdnjs -->\n");
      out.write("    <script type=\"text/javascript\" src=\"//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js\"></script>\n");
      out.write("    <script type=\"text/javascript\" src=\"//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js\"></script>\n");
      out.write("             \n");
      out.write("        \n");
      out.write("    </head>\n");
      out.write("    \n");
      out.write("    ");
 
        
        
        String ServiceType = "";
        String NewUserName = "";
        int UserID = 0;
        String Base64Pic = "";
        int UserIndex = 0;
        String tempAccountType = "";
        
        String url = "";
        String Driver = "";
        String User = "";
        String Password = "";
        
        String PCity = "New York";
        String PTown = "BX";
        String PZipCode = "10457";
        
        try{
            NewUserName = request.getParameter("User");
        
            UserIndex = Integer.parseInt(request.getParameter("UserIndex"));
            //JOptionPane.showMessageDialog(null, UserIndex);
        
            tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
            if(tempAccountType.equals("CustomerAccount"))
                UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();

            if(tempAccountType.equals("BusinessAccount")){
                request.setAttribute("UserIndex", UserIndex);
                request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
            }

            /*else if(UserID == 0)
                response.sendRedirect("LogInPage.jsp");*/
            
            url = config.getServletContext().getAttribute("DBUrl").toString();
            Driver = config.getServletContext().getAttribute("DBDriver").toString();
            User = config.getServletContext().getAttribute("DBUser").toString();
            Password = config.getServletContext().getAttribute("DBPassword").toString();
        }catch(Exception e){
            response.sendRedirect("ProviderCustomerPage.jsp?UserIndex="+UserIndex+"&User="+NewUserName);
        }
        
        try{
            
            Class.forName(Driver);
            Connection PicConn = DriverManager.getConnection(url, User, Password);
            String PicQuery = "Select Profile_Pic from ProviderCustomers.CustomerInfo where Customer_ID = ?";
            PreparedStatement PicPst = PicConn.prepareStatement(PicQuery);
            PicPst.setInt(1, UserID);
            
            ResultSet PicRec = PicPst.executeQuery();
            
            while(PicRec.next()){
                
                try{    
                    //put this in a try catch block for incase getProfilePicture returns nothing
                    Blob profilepic = PicRec.getBlob("Profile_Pic"); 
                    InputStream inputStream = profilepic.getBinaryStream();
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    byte[] imageBytes = outputStream.toByteArray();

                     Base64Pic = Base64.getEncoder().encodeToString(imageBytes);


                }
                catch(Exception e){}
                
            }
            
        }catch(Exception e){e.printStackTrace();}
    
      out.write("\n");
      out.write("    \n");
      out.write("    ");
      out.write("\n");
      out.write("        \n");
      out.write("        ");

            
            getUserDetails details = new getUserDetails();
            details.initializeDBParams(Driver, url, User, Password);
            details.getIDsFromAddress(PCity, PTown, PZipCode);
            
            ArrayList <ProviderInfo> providersList = new ArrayList<>();
            ResultSet rows = details.getRecords();
            
            try{
                ProviderInfo eachrecord;
                while(rows.next()){
                    eachrecord = new ProviderInfo(rows.getInt("Provider_ID"),rows.getString("First_Name"), rows.getString("Middle_Name"), rows.getString("Last_Name"), rows.getDate("Date_Of_Birth"), rows.getString("Phone_Number"),
                                                    rows.getString("Company"), rows.getInt("Ratings"), rows.getString("Service_Type"), rows.getString("First_Name") + " - " +rows.getString("Company"),rows.getBlob("Profile_Pic"), rows.getString("Email"));
                    providersList.add(eachrecord);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            
        
      out.write("\n");
      out.write("        \n");
      out.write("    <body>\n");
      out.write("        \n");
      out.write("        <div id=\"PermanentDiv\" style=\"\">\n");
      out.write("            \n");
      out.write("            <a href=\"PageController?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 80px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>\n");
      out.write("                        <p><img style='background-color: white;' src=\"icons/icons8-home-50.png\" width=\"20\" height=\"17\" alt=\"icons8-home-50\"/>\n");
      out.write("                            Home</p></a>\n");
      out.write("            \n");
      out.write("            <div style=\"float: left; width: 350px; margin-top: 5px; margin-left: 10px;\">\n");
      out.write("                <p style=\"color: white;\"><img style=\"background-color: white; padding: 1px;\" src=\"icons/icons8-new-post-15.png\" width=\"15\" height=\"15\" alt=\"icons8-new-post-15\"/>\n");
      out.write("                    tech.arieslab@outlook.com | \n");
      out.write("                    <img style=\"background-color: white; padding: 1px;\" src=\"icons/icons8-phone-15.png\" width=\"15\" height=\"15\" alt=\"icons8-phone-15\"/>\n");
      out.write("                    (1) 732-799-9546\n");
      out.write("                </p>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <div style=\"float: right; width: 50px;\">\n");
      out.write("                ");

                    if(Base64Pic != ""){
                
      out.write("\n");
      out.write("                    <center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\">\n");
      out.write("                        <img id=\"\" style=\"border-radius: 100%; border: 2px solid green; margin-bottom: 20px; position: absolute; background-color: darkgray;\" src=\"data:image/jpg;base64,");
      out.print(Base64Pic);
      out.write("\" width=\"30\" height=\"30\"/>\n");
      out.write("                    </div></center>\n");
      out.write("                ");

                    }else{
                
      out.write("\n");
      out.write("                \n");
      out.write("                        <center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\">\n");
      out.write("                                <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src=\"icons/icons8-user-filled-100.png\" width=\"30\" height=\"30\" alt=\"icons8-user-filled-100\"/>\n");
      out.write("                            </div></center>\n");
      out.write("                \n");
      out.write("                ");
}
      out.write("\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <ul>\n");
      out.write("                <a  href=\"PageController?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\">\n");
      out.write("                    <li onclick=\"\" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src=\"icons/icons8-home-50.png\" width=\"20\" height=\"17\" alt=\"icons8-home-50\"/>\n");
      out.write("                    Home</li></a>\n");
      out.write("                <li style='cursor: pointer;'><img style='background-color: white;' src=\"icons/icons8-calendar-50.png\" width=\"20\" height=\"17\" alt=\"icons8-calendar-50\"/>\n");
      out.write("                    Calender</li>\n");
      out.write("                <li style='cursor: pointer;'><img style='background-color: white;' src=\"icons/icons8-user-50 (1).png\" width=\"20\" height=\"17\" alt=\"icons8-user-50 (1)\"/>\n");
      out.write("                    Account</li>\n");
      out.write("            </ul>\n");
      out.write("            <div id=\"ExtraDivSearch\" style='background-color: #334d81; padding: 3px; padding-right: 5px; padding-left: 5px; border-radius: 4px; max-width: 590px; float: right; margin-right: 5px;'>\n");
      out.write("                <form action=\"QueueSelectBusinessSearchResultLoggedIn.jsp\" method=\"POST\">\n");
      out.write("                    <input style=\"width: 450px; margin: 0; background-color: #3d6999; color: #eeeeee; height: 30px; border: 1px solid darkblue; border-radius: 4px; font-weight: bolder;\"\n");
      out.write("                            placeholder=\"Search service provider\" name=\"SearchFld\" type=\"text\"  value=\"\" />\n");
      out.write("                    <input style=\"font-weight: bolder; margin: 0; border: 1px solid white; background-color: navy; color: white; border-radius: 4px; padding: 7px; font-size: 15px;\" \n");
      out.write("                            type=\"submit\" value=\"Search\" />\n");
      out.write("                    <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                    <input type='hidden' name='User' value='");
      out.print(NewUserName);
      out.write("' />\n");
      out.write("                </form>\n");
      out.write("            </div>\n");
      out.write("                <p style='clear: both;'></p>\n");
      out.write("        </div>\n");
      out.write("        \n");
      out.write("        <div id=\"container\">\n");
      out.write("            \n");
      out.write("            <div id=\"miniNav\" style=\"display: none;\">\n");
      out.write("                <center>\n");
      out.write("                    <ul id=\"miniNavIcons\" style=\"float: left;\">\n");
      out.write("                        <a href=\"PageController?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><li><img src=\"icons/icons8-home-24.png\" width=\"24\" height=\"24\" alt=\"icons8-home-24\"/>\n");
      out.write("                            </li></a>\n");
      out.write("                        <!--li onclick=\"scrollToTop()\" style=\"padding-left: 2px; padding-right: 2px;\"><img src=\"icons/icons8-up-24.png\" width=\"24\" height=\"24\" alt=\"icons8-up-24\"/>\n");
      out.write("                        </li-->\n");
      out.write("                    </ul>\n");
      out.write("                    <form name=\"miniDivSearch\" action=\"QueueSelectBusinessSearchResultLoggedIn.jsp\" method=\"POST\">\n");
      out.write("                            <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                            <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                            <input style=\"margin-right: 0; background-color: pink; height: 30px; font-size: 13px; border: 1px solid red; border-radius: 4px;\"\n");
      out.write("                                   placeholder=\"Search provider\" name=\"SearchFld\" type=\"text\"  value=\"\"/>\n");
      out.write("                            <input style=\"margin-left: 0; border: 1px solid black; background-color: red; border-radius: 4px; padding: 5px; font-size: 15px;\" \n");
      out.write("                                   type=\"submit\" value=\"Search\" />\n");
      out.write("                    </form>\n");
      out.write("                </center>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("        <div id=\"header\">\n");
      out.write("            \n");
      out.write("            <cetnter><p> </p></cetnter>\n");
      out.write("            <center><a href=\"PageController?UserIndex=");
      out.print(Integer.toString(UserIndex));
      out.write("&User=");
      out.print(NewUserName);
      out.write("\" style=\" color: black;\"><image src=\"QueueLogo.png\" style=\"margin-top: 5px;\"/></a></center>\n");
      out.write("            \n");
      out.write("        </div>\n");
      out.write("            \n");
      out.write("        <div id=\"Extras\">\n");
      out.write("            \n");
      out.write("            <center><p style=\"color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;\">News updates from your providers</p></center>\n");
      out.write("            \n");
      out.write("                <div style=\"max-height: 600px; overflow-y: auto;\">\n");
      out.write("                    \n");
      out.write("                    ");

                        int newsItems = 0;
                        String newsQuery = "";
                        String base64Profile = "";
                        
                       // while(newsItems < 10){
                            
                            try{
                                Class.forName(Driver);
                                Connection CustConn = DriverManager.getConnection(url, User, Password);
                                String CustQuery = "select * from ProviderCustomers.ProvNewsForClients where CustID = ? order by ID desc";
                                PreparedStatement CustPst = CustConn.prepareStatement(CustQuery);
                                CustPst.setInt(1, UserID);
                                ResultSet CustRec = CustPst.executeQuery();
                                
                                while(CustRec.next()){
                                    
                                    String MessageID = CustRec.getString("MessageID").trim();
                                    
                                    try{
                                        Class.forName(Driver);
                                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                                        newsQuery = "Select * from QueueServiceProviders.MessageUpdates where MsgID = ?";
                                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                                        newsPst.setString(1, MessageID);
                                        ResultSet newsRec = newsPst.executeQuery();

                                        while(newsRec.next()){

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
                                                catch(Exception e){

                                                }


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
                                                        catch(Exception e){

                                                        }
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
                                                        String NHouseNumber = ProvLocRec.getString("House_Number").trim();
                                                        String NStreet = ProvLocRec.getString("Street_Name").trim();
                                                        String NTown = ProvLocRec.getString("Town").trim();
                                                        String NCity = ProvLocRec.getString("City").trim();
                                                        String NZipCode = ProvLocRec.getString("Zipcode").trim();

                                                        ProvAddress = NHouseNumber + " " + NStreet + ", " + NTown + ", " + NCity + " " + NZipCode;
                                                    }
                                                }catch(Exception e){
                                                    e.printStackTrace();
                                                }
                    
      out.write("\n");
      out.write("\n");
      out.write("                    <table  id=\"ExtrasTab\" cellspacing=\"0\" style=\"margin-bottom: 3px;\">\n");
      out.write("                        <tbody>\n");
      out.write("                            <tr style=\"background-color: #333333;\">\n");
      out.write("                                <td>\n");
      out.write("                                    <div id=\"ProvMsgBxOne\">\n");
      out.write("                                        \n");
      out.write("                                        <div style='font-weight: bolder; margin-bottom: 4px; color: #eeeeee;'>\n");
      out.write("                                            <!--div style=\"float: right; width: 65px;\" -->\n");
      out.write("                                                ");

                                                    if(base64Profile != ""){
                                                
      out.write("\n");
      out.write("                                                    <!--center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\"-->\n");
      out.write("                                                        <img id=\"\" style=\"margin: 4px; width:35px; height: 35px; border-radius: 100%; border: 1px solid green; float: left; background-color: darkgray;\" src=\"data:image/jpg;base64,");
      out.print(base64Profile);
      out.write("\"/>\n");
      out.write("                                                    <!--/div></center-->\n");
      out.write("                                                ");

                                                    }else{
                                                
      out.write("\n");
      out.write("\n");
      out.write("                                                <!--center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\"-->\n");
      out.write("                                                    <img style='width:35px; height: 35px; border: 1px solid black; background-color: beige; border-radius: 100%; float: left;' src=\"icons/icons8-user-filled-100.png\" alt=\"icons8-user-filled-100\"/>\n");
      out.write("                                                <!--/div></center-->\n");
      out.write("\n");
      out.write("                                                ");
}
      out.write("\n");
      out.write("                                            <!--/div-->\n");
      out.write("                                            <div>\n");
      out.write("                                                <p>");
      out.print(ProvFirstName);
      out.write("</p>\n");
      out.write("                                                <p style='color: violet;'>");
      out.print(ProvCompany);
      out.write("</p>\n");
      out.write("                                            </div>\n");
      out.write("                                        </div>\n");
      out.write("                                        \n");
      out.write("                                        ");
if(MsgPhoto.equals("")){
      out.write("\n");
      out.write("                                        <center><img src=\"view-wallpaper-7.jpg\" width=\"98%\" alt=\"view-wallpaper-7\"/></center>\n");
      out.write("                                        ");
} else{ 
      out.write("\n");
      out.write("                                        <center><img src=\"data:image/jpg;base64,");
      out.print(MsgPhoto);
      out.write("\" width=\"98%\" alt=\"NewsImage\"/></center>\n");
      out.write("                                        ");
}
      out.write("\n");
      out.write("\n");
      out.write("                                    </div>\n");
      out.write("                                </td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td>\n");
      out.write("                                    <p style='font-family: helvetica; text-align: justify; border: 1px solid #d8d8d8; padding: 3px;'>");
      out.print(Msg);
      out.write("</p>\n");
      out.write("                                </td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr style=\"background-color: #eeeeee;\">\n");
      out.write("                                <td>\n");
      out.write("                                    <p style='margin-bottom: 5px; color: #ff3333;'>Contact:</p>\n");
      out.write("                                    <p style=\"color: seagreen;\"><img src=\"icons/icons8-new-post-15.png\" width=\"15\" height=\"15\" alt=\"icons8-new-post-15\"/>\n");
      out.write("                                        ");
      out.print(ProvEmail);
      out.write("</p>\n");
      out.write("                                    <p style=\"color: seagreen;\"><img src=\"icons/icons8-phone-15.png\" width=\"15\" height=\"15\" alt=\"icons8-phone-15\"/>\n");
      out.write("                                        ");
      out.print(ProvTel);
      out.write("</p>\n");
      out.write("                                </td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td>\n");
      out.write("                                    <p style=\"color: seagreen;\"><img src=\"icons/icons8-business-15.png\" width=\"15\" height=\"15\" alt=\"icons8-business-15\"/>\n");
      out.write("                                        ");
      out.print(ProvCompany);
      out.write("</p>\n");
      out.write("                                    <p style=\"color: seagreen;\"><img src=\"icons/icons8-marker-filled-30.png\" width=\"15\" height=\"15\" alt=\"icons8-marker-filled-30\"/>\n");
      out.write("                                        ");
      out.print(ProvAddress);
      out.write("</p>\n");
      out.write("                                </td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr style=\"background-color: #eeeeee;\">\n");
      out.write("                                <td>\n");
      out.write("                                    <!--p><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Previous'><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Next' /></p-->\n");
      out.write("                                </td>\n");
      out.write("                            </tr>\n");
      out.write("                        </tbody>\n");
      out.write("                    </table>\n");
      out.write("                ");
  
                                        if(newsItems > 10)
                                            break;
                                    }
                                }catch(Exception e){
                                    e.printStackTrace();
                                }

                            }

                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    //}
                
                    if(newsItems < 10){
               
                        try{
                            Class.forName(Driver);
                            Connection newsConn = DriverManager.getConnection(url, User, Password);
                            String newsQuery2 = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                            PreparedStatement newsPst = newsConn.prepareStatement(newsQuery2);
                            ResultSet newsRec = newsPst.executeQuery();

                            while(newsRec.next()){

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
                                    catch(Exception e){

                                    }


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
                                            catch(Exception e){

                                            }
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
                                            String NHouseNumber = ProvLocRec.getString("House_Number").trim();
                                            String NStreet = ProvLocRec.getString("Street_Name").trim();
                                            String NTown = ProvLocRec.getString("Town").trim();
                                            String NCity = ProvLocRec.getString("City").trim();
                                            String NZipCode = ProvLocRec.getString("Zipcode").trim();

                                            ProvAddress = NHouseNumber + " " + NStreet + ", " + NTown + ", " + NCity + " " + NZipCode;
                                        }
                                    }catch(Exception e){
                                        e.printStackTrace();
                                    }
                
      out.write("\n");
      out.write("                \n");
      out.write("                <table  id=\"ExtrasTab\" cellspacing=\"0\" style=\"margin-bottom: 3px;\">\n");
      out.write("                    <tbody>\n");
      out.write("                        <tr style=\"background-color: #333333;\">\n");
      out.write("                            <td>\n");
      out.write("                                <div id=\"ProvMsgBxOne\">\n");
      out.write("                                    \n");
      out.write("                                    <div style='font-weight: bolder; margin-bottom: 4px; color: #eeeeee;'>\n");
      out.write("                                            <!--div style=\"float: right; width: 65px;\" -->\n");
      out.write("                                                ");

                                                    if(base64Profile != ""){
                                                
      out.write("\n");
      out.write("                                                    <!--center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\"-->\n");
      out.write("                                                        <img id=\"\" style=\"margin: 4px; width:35px; height: 35px; border-radius: 100%; border: 1px solid green; float: left; background-color: darkgray;\" src=\"data:image/jpg;base64,");
      out.print(base64Profile);
      out.write("\"/>\n");
      out.write("                                                    <!--/div></center-->\n");
      out.write("                                                ");

                                                    }else{
                                                
      out.write("\n");
      out.write("\n");
      out.write("                                                <!--center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\"-->\n");
      out.write("                                                    <img style='width:35px; height: 35px; border: 1px solid black; background-color: beige; border-radius: 100%; float: left;' src=\"icons/icons8-user-filled-100.png\" alt=\"icons8-user-filled-100\"/>\n");
      out.write("                                                <!--/div></center-->\n");
      out.write("\n");
      out.write("                                                ");
}
      out.write("\n");
      out.write("                                            <!--/div-->\n");
      out.write("                                            <div>\n");
      out.write("                                                <p>");
      out.print(ProvFirstName);
      out.write("</p>\n");
      out.write("                                                <p style='color: violet;'>");
      out.print(ProvCompany);
      out.write("</p>\n");
      out.write("                                            </div>\n");
      out.write("                                        </div>\n");
      out.write("                                    \n");
      out.write("                                    ");
if(MsgPhoto.equals("")){
      out.write("\n");
      out.write("                                    <center><img src=\"view-wallpaper-7.jpg\" width=\"98%\" alt=\"view-wallpaper-7\"/></center>\n");
      out.write("                                    ");
} else{ 
      out.write("\n");
      out.write("                                    <center><img src=\"data:image/jpg;base64,");
      out.print(MsgPhoto);
      out.write("\" width=\"98%\" alt=\"NewsImage\"/></center>\n");
      out.write("                                    ");
}
      out.write("\n");
      out.write("                                    \n");
      out.write("                                </div>\n");
      out.write("                            </td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr>\n");
      out.write("                            <td>\n");
      out.write("                                <p style='font-family: helvetica; text-align: justify; border: 1px solid #d8d8d8; padding: 3px;'>");
      out.print(Msg);
      out.write("</p>\n");
      out.write("                            </td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr style=\"background-color: #eeeeee;\">\n");
      out.write("                            <td>\n");
      out.write("                                <p style='margin-bottom: 5px; color: #ff3333;'>Contact:</p>\n");
      out.write("                                <p style=\"color: seagreen;\"><img src=\"icons/icons8-new-post-15.png\" width=\"15\" height=\"15\" alt=\"icons8-new-post-15\"/>\n");
      out.write("                                    ");
      out.print(ProvEmail);
      out.write("</p>\n");
      out.write("                                <p style=\"color: seagreen;\"><img src=\"icons/icons8-phone-15.png\" width=\"15\" height=\"15\" alt=\"icons8-phone-15\"/>\n");
      out.write("                                    ");
      out.print(ProvTel);
      out.write("</p>\n");
      out.write("                            </td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr>\n");
      out.write("                            <td>\n");
      out.write("                                <p style=\"color: seagreen;\"><img src=\"icons/icons8-business-15.png\" width=\"15\" height=\"15\" alt=\"icons8-business-15\"/>\n");
      out.write("                                    ");
      out.print(ProvCompany);
      out.write("</p>\n");
      out.write("                                <p style=\"color: seagreen;\"><img src=\"icons/icons8-marker-filled-30.png\" width=\"15\" height=\"15\" alt=\"icons8-marker-filled-30\"/>\n");
      out.write("                                    ");
      out.print(ProvAddress);
      out.write("</p>\n");
      out.write("                            </td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr style=\"background-color: #eeeeee;\">\n");
      out.write("                            <td>\n");
      out.write("                                <!--p><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Previous'><input style='border: 1px solid black; background-color: pink; width: 45%;' type='button' value='Next' /></p-->\n");
      out.write("                            </td>\n");
      out.write("                        </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                </table>\n");
      out.write("            ");

                            if(newsItems > 10)
                                break;
                        }
                    }catch(Exception e){
                        e.printStackTrace();
                    }
            
                }
            
      out.write("\n");
      out.write("               </div>\n");
      out.write("            </div>\n");
      out.write("        \n");
      out.write("            \n");
      out.write("        <div id=\"content\">\n");
      out.write("            \n");
      out.write("            <div id=\"nav\">\n");
      out.write("                \n");
      out.write("                <!--h4><a href=\"index.jsp\" style =\"color: blanchedalmond\">AriesLab.com</a></h4-->\n");
      out.write("                <!--h3>Your Dashboard</a></h3-->\n");
      out.write("                <!--center><p style = \"width: 130px; margin: 5px;\"><span id=\"displayDate\" style=\"\"></span></p></center-->\n");
      out.write("                <script src=\"scripts/script.js\"></script>\n");
      out.write("                \n");
      out.write("                <center><div class =\" SearchObject\">\n");
      out.write("                        \n");
      out.write("                    <form name=\"searchForm\" action=\"QueueSelectBusinessSearchResultLoggedIn.jsp\" method=\"POST\">\n");
      out.write("                        <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                        <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                        <input placeholder='Search Service Provider' class=\"searchfld\" value=\"\" type=\"text\" name=\"SearchFld\" size=\"\" /><input class=\"searchbtn\" type=\"submit\" value=\"Search\" name=\"SearchBtn\" />\n");
      out.write("                    </form> \n");
      out.write("                        \n");
      out.write("                </div></center> \n");
      out.write("                \n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <div id=\"main\">\n");
      out.write("                \n");
      out.write("                <cetnter><p> </p></cetnter>\n");
      out.write("                <center><div id=\"providerlist\" >\n");
      out.write("                \n");
      out.write("                <center><table id=\"providerdetails\" style=\"\">\n");
      out.write("                        \n");
      out.write("                    ");

                        for(int i = 0; i < providersList.size(); i++){ 
                            
                            String fullName = providersList.get(i).getFirstName() + " " + providersList.get(i).getMiddleName() + " " + providersList.get(i).getLastName();
                            String Company = providersList.get(i).getCompany();
                            String Email = providersList.get(i).getEmail();
                            String phoneNumber = providersList.get(i).getPhoneNumber();
                            ServiceType = providersList.get(i).getServiceType().trim();
                                                    
                            String base64Image = "";
                            String base64Cover = "";

                            try{    
                                //put this in a try catch block for incase getProfilePicture returns nothing
                                Blob profilepic = providersList.get(i).getProfilePicture(); 
                                InputStream inputStream = profilepic.getBinaryStream();
                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead = -1;

                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    outputStream.write(buffer, 0, bytesRead);
                                }

                                byte[] imageBytes = outputStream.toByteArray();

                                base64Image = Base64.getEncoder().encodeToString(imageBytes);


                            }
                            catch(Exception e){

                            }
                            
                            int ID = providersList.get(i).getID();
                            String SID = Integer.toString(ID);
                            
                            try{
                                
                                Class.forName(details.Driver);
                                Connection conn = DriverManager.getConnection(details.url, details.User, details.Password);
                                String selectAddress = "Select * from QueueObjects.ProvidersAddress where ProviderID =?";
                                PreparedStatement pst = conn.prepareStatement(selectAddress);
                                pst.setInt(1,ID);
                                ResultSet address = pst.executeQuery();
                                
                                while(address.next()){
                                    providersList.get(i).setAddress(address.getInt("House_Number"), address.getString("Street_Name"), address.getString("Town"),address.getString("City"),address.getString("Country"),address.getInt("Zipcode"));
                                }
                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                            
                            int hNumber = 0;
                            String sName = "";
                            String tName = "";
                            String cName = "";
                            String coName = "";
                            int zCode = 0;
                            String fullAddress = "";
                            
                            int ratings = 0;
                            
                            try{
                                
                                hNumber = providersList.get(i).Address.getHouseNumber();
                                sName = providersList.get(i).Address.getStreet().trim();
                                tName = providersList.get(i).Address.getTown().trim();
                                cName = providersList.get(i).Address.getCity().trim();
                                coName = providersList.get(i).Address.getCountry().trim();
                                zCode = providersList.get(i).Address.getZipcode();
                                fullAddress = Integer.toString(hNumber) + " " + sName + ", " + tName + ", " + cName + ", " + coName + " " + Integer.toString(zCode);

                                ratings = providersList.get(i).getRatings();
                                
                            }catch(Exception e){}
                            
                    
      out.write("\n");
      out.write("                    \n");
      out.write("                    \n");
      out.write("                    \n");
      out.write("                    ");

                        //getting coverdata
                        
                       try{
                            
                            Class.forName(Driver);
                            Connection coverConn = DriverManager.getConnection(url, User, Password);
                            String coverString = "Select * from QueueServiceProviders.CoverPhotos where ProviderID =?";
                            PreparedStatement coverPst = coverConn.prepareStatement(coverString);
                            coverPst.setInt(1,ID);
                            ResultSet cover = coverPst.executeQuery();
                            
                            while(cover.next()){
                                
                                 try{    
                                    //put this in a try catch block for incase getProfilePicture returns nothing
                                    Blob profilepic = cover.getBlob("CoverPhoto"); 
                                    InputStream inputStream = profilepic.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;

                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }

                                    byte[] imageBytes = outputStream.toByteArray();

                                    base64Cover = Base64.getEncoder().encodeToString(imageBytes);


                                }
                                catch(Exception e){

                                }
                                 
                                if(!base64Cover.equals(""))
                                    break;
                                
                            }
                            
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    
      out.write("\n");
      out.write("                    \n");
      out.write("                            <tbody>\n");
      out.write("                            <tr>\n");
      out.write("                            <td>\n");
      out.write("                                \n");
      out.write("                            <center>\n");
      out.write("                            <div class=\"propic\" style=\"background-image: url('data:image/jpg;base64,");
      out.print(base64Cover);
      out.write("');\">\n");
      out.write("                                <img src=\"data:image/jpg;base64,");
      out.print(base64Image);
      out.write("\" width=\"150\" height=\"150\"/>\n");
      out.write("                            </div>\n");
      out.write("                            \n");
      out.write("                            <div class=\"proinfo\">\n");
      out.write("                                \n");
      out.write("                                <b><p style=\"font-size: 20px; text-align: center; margin-bottom: 0;\"><span><!--img src=\"icons/icons8-user-15.png\" width=\"15\" height=\"15\" alt=\"icons8-user-15\"/-->\n");
      out.write("                                            ");
      out.print(fullName);
      out.write("</span></p></b>\n");
      out.write("                                \n");
      out.write("                                <p style=\"text-align: center; margin: 0;\">");
      out.print(ServiceType);
      out.write("</P>\n");
      out.write("                                <p style='text-align: center; color:#7e7e7e; margin: 0; padding: 0;'><small>");
      out.print(fullAddress);
      out.write("</small></p>\n");
      out.write("                                         \n");
      out.write("                                ");

                                    if(ServiceType.equals("Barber Shop")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left;\" src=\"icons/icons8-barber-pole-50.png\" width=\"30\" height=\"30\" alt=\"icons8-barber-pole-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Day Spa")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-spa-50.png\" width=\"25\" height2=\"30\" alt=\"icons8-spa-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                 ");

                                    if(ServiceType.equals("Beauty Salon")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-hair-dryer-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-hair-dryer-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Dentist")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-tooth-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-tooth-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Dietician")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-dairy-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-dairy-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Eyebrows and Eyelashes")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-eye-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-eye-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Hair Salon")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-woman's-hair-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-woman's-hair-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Hair Removal")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-skin-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-skin-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Tattoo Shop")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-tattoo-machine-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-tattoo-machine-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Home Services")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-home-50 (1).png\" width=\"30\" height2=\"30\" alt=\"icons8-home-50 (1)\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Holistic Medicine")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-hospital-3-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-hospital-3-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Medical Center")){
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-hospital-3-50.png\" width=\"30\" height2=\"30\" alt=\"icons8-hospital-3-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");

                                    if(ServiceType.equals("Medical Aesthetician")){
                                
      out.write("\n");
      out.write("                                   \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-business-50.png\" width=\"30\" height=\"30\" alt=\"icons8-business-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                ");
 
                                    
                                    if(ServiceType.equals("Physical Therapy")){
                                    
                                
      out.write("\n");
      out.write("                                \n");
      out.write("                                <div>\n");
      out.write("                                    <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-business-50.png\" width=\"30\" height=\"30\" alt=\"icons8-business-50\"/>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                <p style=\"\"><span>\n");
      out.write("                                        \n");
      out.write("                                ");

                                    if(!ServiceType.equals("Barber Shop") && !ServiceType.equals("Day Spa") && !ServiceType.equals("Beauty Salon") && !ServiceType.equals("Dentist") && !ServiceType.equals("Dietician") && !ServiceType.equals("Eyebrows and Eyelashes") && !ServiceType.equals("Hair Salon") && !ServiceType.equals("Hair Removal") && !ServiceType.equals("Tattoo Shop") && !ServiceType.equals("Home Services") && !ServiceType.equals("Holistic Medicine") && !ServiceType.equals("Medical Center") && !ServiceType.equals("Medical Aesthetician") && !ServiceType.equals("Physical Therapy")){
                                
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        <img style=\"float: left; margin-right: 3px;\" src=\"icons/icons8-business-50.png\" width=\"30\" height=\"30\" alt=\"icons8-business-50\"/>\n");
      out.write("                                ");
}
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        ");
      out.print(Company);
      out.write("</span><span style=\"color: blue; font-size: 22px;\">\n");
      out.write("                                \n");
      out.write("                                        ");

                                            if(ratings ==5){
                                        
                                        
      out.write(" \n");
      out.write("                                        ★★★★★\n");
      out.write("                                        ");

                                             }else if(ratings == 4){
                                        
      out.write("\n");
      out.write("                                        ★★★★☆\n");
      out.write("                                        ");

                                             }else if(ratings == 3){
                                        
      out.write("\n");
      out.write("                                        ★★★☆☆\n");
      out.write("                                        ");

                                             }else if(ratings == 2){
                                        
      out.write("\n");
      out.write("                                        ★★☆☆☆\n");
      out.write("                                        ");

                                             }else if(ratings == 1){
                                        
      out.write("\n");
      out.write("                                        ★☆☆☆☆\n");
      out.write("                                        ");
}
      out.write("\n");
      out.write("                                        </span>\n");
      out.write("                                </p>\n");
      out.write("                                \n");
      out.write("                            </div>\n");
      out.write("                               \n");
      out.write("                                <div id=\"QueuLineDiv\">\n");
      out.write("                                        \n");
      out.write("                                    ");

                                        int IntervalsValue = 30;

                                        try{

                                            Class.forName(Driver);
                                            Connection intervalsConn = DriverManager.getConnection(url, User, Password);
                                            String intervalsString = "Select * from QueueServiceProviders.Settings where If_providerID = ? and Settings like 'SpotsIntervals%'";
                                            PreparedStatement intervalsPst = intervalsConn.prepareStatement(intervalsString);

                                            intervalsPst.setInt(1, ID);

                                            ResultSet intervalsRec = intervalsPst.executeQuery();

                                            while(intervalsRec.next()){
                                                IntervalsValue = Integer.parseInt(intervalsRec.getString("CurrentValue").trim());
                                            }
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                        Date currentDate = new Date();//default date constructor returns current date 
                                        String CurrentTime = currentDate.toString().substring(11,16);
                                        String DayOfWeek = currentDate.toString().substring(0,3);
                                        SimpleDateFormat formattedDate = new SimpleDateFormat("MMM dd"); //formatting date to a string value of month day, year
                                        String stringDate = formattedDate.format(currentDate); //calling format function to format date object
                                        SimpleDateFormat QuerySdf = new SimpleDateFormat("yyyy-MM-dd");
                                        String QueryDate = QuerySdf.format(currentDate);
                                        
                                        ArrayList<String> AllAvailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllAvailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableTimeList = new ArrayList<>();
                                        ArrayList<String> AllUnavailableFormattedTimeList = new ArrayList<>();
                                        ArrayList<String> AllThisCustomerTakenTime = new ArrayList<>();
                                        ArrayList<String> AllThisCustomerTakenFormattedTakenTime = new ArrayList<>();
                                        
                                        String DailyStartTime = "";
                                        String DailyClosingTime = "";
                                        String FormattedStartTime = "";
                                        String FormattedClosingTime = "";
                                        
                                        int startHour = 0;
                                        int startMinute = 0;
                                        int closeHour = 0;
                                        int closeMinute = 0;
                                        
                                        int TotalAvailableList = 0;
                                        int TotalUnavailableList = 0;
                                        int TotalThisCustomerTakenList = 0;
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    ");

                                        String MonDailyStartTime = "";
                                        String MonDailyClosingTime = "";
                                        String TueDailyStartTime = "";
                                        String TueDailyClosingTime = "";
                                        String WedDailyStartTime = "";
                                        String WedDailyClosingTime = "";
                                        String ThursDailyStartTime = "";
                                        String ThursDailyClosingTime = "";
                                        String FriDailyStartTime = "";
                                        String FriDailyClosingTime = "";
                                        String SatDailyStartTime = "";
                                        String SatDailyClosingTime = "";
                                        String SunDailyStartTime = "";
                                        String SunDailyClosingTime = "";
                                        
                                        //getting starting and closing hours for eah day
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection hoursConn = DriverManager.getConnection(url, User, Password);
                                            String hourString = "Select * from QueueServiceProviders.ServiceHours where ProviderID = ?";
                                            
                                            PreparedStatement hourPst = hoursConn.prepareStatement(hourString);
                                            hourPst.setInt(1, ID);
                                            ResultSet hourRow = hourPst.executeQuery();
                                            
                                            while(hourRow.next()){
                                                
                                                
                                                MonDailyStartTime = hourRow.getString("MondayStart");
                                                MonDailyClosingTime = hourRow.getString("MondayClose");
                                                
                                                TueDailyStartTime = hourRow.getString("TuesdayStart");
                                                TueDailyClosingTime = hourRow.getString("TuesdayClose");
                                                
                                                WedDailyStartTime = hourRow.getString("WednessdayStart");
                                                WedDailyClosingTime = hourRow.getString("WednessdayClose");
                                               
                                                ThursDailyStartTime = hourRow.getString("ThursdayStart");
                                                ThursDailyClosingTime = hourRow.getString("ThursdayClose");
                                               
                                                FriDailyStartTime = hourRow.getString("FridayStart");
                                                FriDailyClosingTime = hourRow.getString("FridayClose");
                                                
                                                SatDailyStartTime = hourRow.getString("SaturdayStart");
                                                SatDailyClosingTime = hourRow.getString("SaturdayClose");
                                                
                                                SunDailyStartTime = hourRow.getString("SundayStart");
                                                SunDailyClosingTime = hourRow.getString("SundayClose");
                                                
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                        try{
                                                if(DayOfWeek.equalsIgnoreCase("Mon")){
                                                    DailyStartTime = MonDailyStartTime.substring(0,5);
                                                    DailyClosingTime = MonDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Tue")){
                                                    DailyStartTime = TueDailyStartTime.substring(0,5);
                                                    DailyClosingTime = TueDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Wed")){
                                                    
                                                    DailyStartTime = WedDailyStartTime.substring(0,5);
                                                    DailyClosingTime = WedDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Thu")){
                                                    DailyStartTime = ThursDailyStartTime.substring(0,5);
                                                    DailyClosingTime = ThursDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Fri")){
                                                    DailyStartTime = FriDailyStartTime.substring(0,5);
                                                    DailyClosingTime = FriDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sat")){
                                                    DailyStartTime = SatDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SatDailyClosingTime.substring(0,5);
                                                }
                                                if(DayOfWeek.equalsIgnoreCase("Sun")){
                                                    DailyStartTime = SunDailyStartTime.substring(0,5);
                                                    DailyClosingTime = SunDailyClosingTime.substring(0,5);
                                                }
                                                
                                                
                                                
                                                startHour = Integer.parseInt(DailyStartTime.substring(0,2));
                                                startMinute = Integer.parseInt(DailyStartTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
                                                        if( startHour > 12)
                                                        {
                                                             int TempHour = startHour - 12;
                                                             FormattedStartTime = Integer.toString(TempHour) + ":" +  DailyStartTime.substring(3,5) + " pm";
                                                        }
                                                        else if(startHour == 0){
                                                            FormattedStartTime = "12" + ":" + DailyStartTime.substring(3,5) + " am";
                                                        }
                                                        else if(startHour == 12){
                                                            FormattedStartTime = DailyStartTime + " pm";
                                                        }
                                                        else{
                                                            FormattedStartTime = DailyStartTime +" am";
                                                        }
                                               
                                                closeHour = Integer.parseInt(DailyClosingTime.substring(0,2));
                                                closeMinute = Integer.parseInt(DailyClosingTime.substring(3,5));
                                                        
                                                        //formatting the time for user convenience
                                                        if( closeHour > 12)
                                                        {
                                                             int TempHour = closeHour - 12;
                                                             FormattedClosingTime = Integer.toString(TempHour) + ":" +  DailyClosingTime.substring(3,5) + " pm";
                                                        }
                                                        else if(closeHour == 0){
                                                            FormattedClosingTime = "12" + ":" + DailyClosingTime.substring(3,5) + " am";
                                                        }
                                                        else if(closeHour == 12){
                                                            FormattedClosingTime = DailyClosingTime + " pm";
                                                        }
                                                        else{
                                                            FormattedClosingTime = DailyClosingTime +" am";
                                                        }
                                                        
                                                        if(closeHour == 0)
                                                            closeHour = 23;
                                            }
                                            catch(Exception e){}
                                        
                                        
                                    
      out.write("\n");
      out.write("                                     \n");
      out.write("                                    ");

                                        //getting the closed days data
                                        ArrayList<String> ClosedDates = new ArrayList<>();
                                        ArrayList<Integer> ClosedIDs = new ArrayList<>();
                                        boolean isTodayClosed = false;
                                        
                                       
                                        
                                        Date DateForClosedCompare = new Date();
                                        SimpleDateFormat DateForCompareSdf2 = new SimpleDateFormat("yyyy-MM-dd");
                                        String StringDateForCompare = DateForCompareSdf2.format(DateForClosedCompare);
                                        
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection CloseddConn = DriverManager.getConnection(url, User, Password);
                                            String CloseddString = "select * from QueueServiceProviders.ClosedDays where ProviderID = ?";
                                            PreparedStatement CloseddPst = CloseddConn.prepareStatement(CloseddString);
                                            CloseddPst.setInt(1, ID);
                                            
                                            ResultSet ClosedRec = CloseddPst.executeQuery();
                                            
                                            while(ClosedRec.next()){
                                                
                                                ClosedDates.add(ClosedRec.getString("DateToClose").trim());
                                                ClosedIDs.add(ClosedRec.getInt("closedID"));
                                                
                                                if(StringDateForCompare.equals(ClosedRec.getString("DateToClose").trim())){
                                                    isTodayClosed = true;
                                                }
                                                
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                    
      out.write("\n");
      out.write("                                   \n");
      out.write("                                    ");

                                        int CurrentHour = Integer.parseInt(CurrentTime.substring(0,2));
                                        int CurrentMinute = Integer.parseInt(CurrentTime.substring(3,5));
                                        
                                        int CurrentHourForStatusLed = CurrentHour;
                                        
                                        if(DailyStartTime != ""){
                                            
                                            if(CurrentHour < startHour){
                                                
                                                CurrentHour = startHour;
                                                CurrentMinute = startMinute;
                                                
                                            }
                                        
                                        }
                                        
                                        String NextAvailableTime = "" ;
                                        String NextAvailableFormattedTime = "";
                                        
                                        int y = 0;
                                        int isFirstAppointmentFound = 0;
                                        int bookedTimeFlag = 0;
                                        int myAppointmentTimeFlag = 0;
                                        
                                        int NextThirtyMinutes = CurrentMinute + 30;
                                        
                                        //use this if there is no appointment for the next hour
                                        int ActualThirtyMinutesAfter = CurrentMinute + 30;
                                        
                                        int NextHour = CurrentHour;
                                        
                                        //use this if there is no appointment for the next hour
                                        int Hourfor30Mins = CurrentHour;
                                        
                                        while(NextThirtyMinutes >= 60){
                                            
                                            ++NextHour;
                                            
                                            if(DailyClosingTime != ""){
                                                
                                                    if(NextHour > closeHour && closeHour != 0){

                                                        NextHour = closeHour - 1;

                                                    }
                                                    else if(closeHour == 0)
                                                        NextHour = 23;

                                                    }else if(NextHour > 23){
                                                        NextHour = 23;
                                                    }
                                            
                                            if(NextThirtyMinutes > 60)
                                                NextThirtyMinutes -= 60;
                                            
                                            else if(NextThirtyMinutes == 60)
                                                NextThirtyMinutes = 0;
                                        }
                                        
                                        //Calculate for time of most recent past appointment possibility
                                        String LastAppointmentTime = "";
                                        
                                        int LATHour = Integer.parseInt(CurrentTime.substring(0,2));
                                        int LATMinute = Integer.parseInt(CurrentTime.substring(3,5)) + 300;
                                        
                                        LATHour -= 5;
                                        
                                        LATMinute -= IntervalsValue;
                                            
                                        while(LATMinute >= 60){
                                            
                                            /*Avoid incrementing the hour hand as it will skip the start of the day
                                            if(DailyStartTime != ""){
                                                
                                                if(LATHour == startHour){
                                                    break;
                                                }
                                                    
                                            }else if(LATHour == 1){
                                                break;
                                            }*/
                                            
                                            LATHour++;
                                            
                                            /*if(DailyStartTime != ""){

                                                if(LATHour < startHour){
                                                    LATHour = startHour;
                                                    LATMinute = closeMinute;
                                                    break;
                                                }
                                            }else if(LATHour < 1){
                                                LATHour = 1;
                                                break;
                                            }*/
                                            
                                            if(LATMinute > 60)
                                                LATMinute -= 60;
                                            
                                            else if(LATMinute == 60)
                                                LATMinute = 0;
                                            
                                                
                                        }
                                        
                                        if(DailyStartTime != ""){
                                            
                                            if(LATHour <= startHour){
                                                LATHour = startHour;
                                                LATMinute = startMinute;
                                            }
                                        }else if(LATHour < 1){
                                            LATHour = 1;
                                            LATMinute = Integer.parseInt(CurrentTime.substring(3,5));
                                        }
                                        
                                        if(Integer.toString(LATMinute).length() < 2){
                                            LastAppointmentTime = Integer.toString(LATHour) + ":0" + Integer.toString(LATMinute);
                                        }else{
                                            LastAppointmentTime = Integer.toString(LATHour) + ":" + Integer.toString(LATMinute);
                                        }
                                        
                                        //JOptionPane.showMessageDialog(null, LastAppointmentTime);
                                        
                                        //use this if there is no appointment for the next hour
                                        while(ActualThirtyMinutesAfter >= 60){
                                            
                                            ++Hourfor30Mins;
                                            
                                            if(DailyClosingTime != ""){
                                                
                                                if(Hourfor30Mins > closeHour && closeHour != 0){

                                                    Hourfor30Mins = closeHour - 1;

                                                }
                                                else if(closeHour == 0)
                                                    Hourfor30Mins = 23;

                                            }else if(Hourfor30Mins > 23){
                                                Hourfor30Mins = 23;
                                            }
                                            
                                            if(ActualThirtyMinutesAfter > 60)
                                                ActualThirtyMinutesAfter -= 60;
                                            
                                            else if(ActualThirtyMinutesAfter == 60)
                                                ActualThirtyMinutesAfter = 0;
                                        }
                                        
                                        String p = Integer.toString(NextThirtyMinutes);
                                        String h = Integer.toString(ActualThirtyMinutesAfter);
                                        
                                        if(p.length() < 2)
                                            p = "0" + p;
                                        
                                        if(h.length() < 2)
                                            h = "0" + h;
                                        
                                        String TimeAfter30Mins = NextHour + ":" + p;
                                        String TimeWith30Mins = Hourfor30Mins + ":" + h;
                                        
                                        int Next30MinsAppointmentFlag = 0;
                                        
                                        try{
                                            
                                            Class.forName(Driver);
                                            Connection ThirtyMinsConn = DriverManager.getConnection(url, User, Password);
                                            String ThirtyMinsString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                            
                                            PreparedStatement ThirtyPst = ThirtyMinsConn.prepareStatement(ThirtyMinsString);
                                            ThirtyPst.setInt(1, providersList.get(i).getID());
                                            ThirtyPst.setString(2, QueryDate);
                                            ThirtyPst.setString(3, LastAppointmentTime);
                                            ThirtyPst.setString(4, TimeAfter30Mins);
                                            
                                            ResultSet ThirtyMinsRow = ThirtyPst.executeQuery();
                                            
                                            while(ThirtyMinsRow.next()){
                                                
                                                Next30MinsAppointmentFlag = 1;
                                                isFirstAppointmentFound = 1;
                                                
                                                String TempTime = ThirtyMinsRow.getString("AppointmentTime");
                                                
                                                CurrentHour = Integer.parseInt(TempTime.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TempTime.substring(3,5));
                                                CurrentTime = CurrentHour + ":" + CurrentMinute;
                                                
                                                //getting the next 30 minute time from the current time;
                                                int TempMinute = CurrentMinute + 30;
                                        
                                                int TempHour = CurrentHour;

                                                while(TempMinute >= 60){

                                                    ++TempHour;

                                                    if(DailyClosingTime != ""){
                                                
                                                        if(TempHour > closeHour && closeHour != 0){

                                                            TempHour = closeHour - 1;

                                                        }
                                                        else if(closeHour == 0)
                                                            TempHour = 23;

                                                    }else if(TempHour > 23){
                                                        TempHour = 23;
                                                    }

                                                    if(TempMinute > 60)
                                                        TempMinute -= 60;

                                                    else if(TempMinute == 60)
                                                        TempMinute = 0;
                                                }
                                                
                                                String StringTempMinute = Integer.toString(TempMinute);
                                                
                                                if(StringTempMinute.length() < 2)
                                                    StringTempMinute = "0" + StringTempMinute;
                                                
                                                NextAvailableTime = TempHour + ":" + StringTempMinute;
                                                
                                                break;
                                                
                                            }
                                            if(Next30MinsAppointmentFlag == 0){
                                                
                                                if(TimeWith30Mins.length() == 4)
                                                    TimeWith30Mins = "0" + TimeWith30Mins;
                                                
                                                CurrentHour = Integer.parseInt(TimeWith30Mins.substring(0,2));
                                                CurrentMinute = Integer.parseInt(TimeWith30Mins.substring(3,5));
                                                
                                                String thisMinute = Integer.toString(CurrentMinute);
                                                        
                                                if(thisMinute.length() < 2){
                                                    thisMinute = "0" + thisMinute;
                                                }
                                                
                                                NextAvailableTime = CurrentHour + ":" + CurrentMinute;
                                                 
                                            }
                                            
                                        }catch(Exception e){
                                            e.printStackTrace();
                                        }
                                        
                                        //this part of algorithm changed
                                        int twoHours = CurrentHour + 23;
                                        
                                        if(DailyClosingTime != ""){
                                            
                                            if(twoHours > closeHour && closeHour != 0){

                                                twoHours = closeHour - 1;

                                                }
                                            else if(closeHour == 0)
                                                twoHours = 23;
                                            
                                        }else if(twoHours > 23){
                                                twoHours = 23;
                                            }
                                        
                                            if(isTodayClosed == true){
                                                
                                                DailyStartTime = "00:00";
                                                DailyClosingTime = "00:00";
                                                
                                            }
                                        
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    ");

                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00")){
                                    
      out.write("\n");
      out.write("                                                 \n");
      out.write("                                    <p style=\"color: tomato;\">Not open on ");
      out.print(DayOfWeek);
      out.write("...</p>\n");
      out.write("                                    \n");
      out.write("                                    ");

                                        }else if(FormattedStartTime != "" || FormattedClosingTime != "" && !(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))){
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                        <p><span>\n");
      out.write("                                            \n");
      out.write("                                        ");

                                            if((startHour > CurrentHourForStatusLed || closeHour < CurrentHourForStatusLed) && closeHour != 0){
                                        
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        <img src=\"icons/icons8-new-moon-20.png\" width=\"10\" height=\"10\" alt=\"icons8-new-moon-20\"/>\n");
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        ");

                                            }else{
                                        
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        <img src=\"icons/icons8-new-moon-20 (1).png\" width=\"10\" height=\"10\" alt=\"icons8-new-moon-20 (1)\"/>\n");
      out.write("\n");
      out.write("                                        \n");
      out.write("                                        ");

                                            }
                                        
      out.write("\n");
      out.write("                                            \n");
      out.write("                                        </span>Hours: <span style=\"color: tomato\">");
      out.print(FormattedStartTime);
      out.write("</span> -\n");
      out.write("                                        <span style=\"color: tomato\">");
      out.print(FormattedClosingTime);
      out.write("</span>,\n");
      out.write("                                        <span style=\"color: tomato\">");
      out.print(DayOfWeek);
      out.write(',');
      out.write(' ');
      out.print(stringDate);
      out.write("</span>.</p>\n");
      out.write("                                        \n");
      out.write("                                    ");

                                        }
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                        <!--p>Next Appointment: ");
      out.print(NextAvailableTime);
      out.write("</p-->\n");
      out.write("                                        <center><p>Select any <span style=\"color: blue;\">blue</span> spot to take position on this line</p></center>\n");
      out.write("                                    \n");
      out.write("                                    <div class=\"scrolldiv\" style=\"width: 280px; max-width: 500px; overflow-x: auto;\"> \n");
      out.write("                                    <table>\n");
      out.write("                                        <tbody>\n");
      out.write("                                            <tr>\n");
      out.write("                                                \n");
      out.write("                                            ");

                                                int HowManyColums = 0;
                                                boolean isLineAvailable = false;
                                                boolean broken = false;
                                                
                                                for(int x = CurrentHour; x < twoHours;){
                                                    
                                                    if(DailyStartTime.equals("00:00") && DailyClosingTime.equals("00:00"))
                                                        break;
                                                   
                                                    for(y = CurrentMinute; y <= 60;){
                                                        
                                                        //use current time when no appointment no appointment exists in the range of current time spot
                                                        //----------------------------------------------------------------------------------------
                                                        //Hour Setting
                                                        if(isFirstAppointmentFound == 0){

                                                            if(DailyStartTime != ""){
                                                                
                                                                //Reversing the increment in hour when minute is greater than 30mins with an increment of 30mins
                                                                if(Integer.parseInt(CurrentTime.substring(0,2)) > startHour){

                                                                    if(Integer.parseInt(CurrentTime.substring(3,5)) >= 30){
                                                                        x = x - 1;
                                                                    }

                                                                }
                                                            }
                                                            //if this provider doesn't have hour open set then check to make sure that hour is reduces of previous increment for 30mim increment
                                                            else if(Integer.parseInt(CurrentTime.substring(3,5)) >= 30){
                                                                x = x - 1;
                                                            }
                                                            
                                                            //now working on assigning the value of minute to current time minute for when first appointment isn't booked
                                                            //-----------------------------------------------------------------------------------------------
                                                            //Minute Setting
                                                            if(DailyStartTime != ""){
                                                              
                                                                if(Integer.parseInt(CurrentTime.substring(0,2)) < startHour){
                                                                    
                                                                    if(x > startHour)
                                                                        x = startHour;
                                                                    
                                                                    //if calculated time is before opening time, use the start minute of this providers starting time
                                                                    y = startMinute;
                                                                    isFirstAppointmentFound = 2;
                                                                }else{
                                                                    
                                                                    //else if the calculated time isn't before opening time, then use the current minute of current time
                                                                    y = Integer.parseInt(CurrentTime.substring(3,5));
                                                                    isFirstAppointmentFound = 2;
                                                                }
                                                                
                                                            }else{
                                                                
                                                                //else if this provider doen't have hours open set, use the current minute of current time
                                                                y = Integer.parseInt(CurrentTime.substring(3,5));
                                                                isFirstAppointmentFound = 2;
                                                            }
                                                                
                                                                //JOptionPane.showMessageDialog(null, y);
                                                        }
                                                        
                                                        if(broken)
                                                            break;
                                                        
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                            ");

                                                
                                                try{
                                                    
                                                    Class.forName(Driver);
                                                    Connection LineDivConn = DriverManager.getConnection(url, User, Password);
                                                    String LineDivString = "Select * from QueueObjects.BookedAppointment where ProviderID = ? and AppointmentDate = ? and (AppointmentTime between ? and ?)";
                                                    
                                                    PreparedStatement LineDivPst = LineDivConn.prepareStatement(LineDivString);
                                                    LineDivPst.setInt(1, providersList.get(i).getID());
                                                    LineDivPst.setString(2, QueryDate);
                                                    LineDivPst.setString(3, CurrentTime);
                                                    LineDivPst.setString(4, NextAvailableTime);
                                                    
                                                    ResultSet LineDivRow = LineDivPst.executeQuery();
                                                    
                                                    while(LineDivRow.next()){
                                                        
                                                        bookedTimeFlag = 1;
                                                        
                                                        int CustomerID = LineDivRow.getInt("CustomerID");
                                                        
                                                        if(UserID == CustomerID){
                                                            bookedTimeFlag = 2;
                                                        }
                                                        
                                                        CurrentTime = LineDivRow.getString("AppointmentTime");
                                                        
                                                        
                                                        int k = Integer.parseInt(CurrentTime.substring(0,2));
                                                        int l = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        x = Integer.parseInt(CurrentTime.substring(0,2));
                                                        y = Integer.parseInt(CurrentTime.substring(3,5));
                                                        
                                                        ++l;
                                                        CurrentTime = k + ":" + l;
                                                      
                                                        
                                                    }
                                                }
                                                catch(Exception e){
                                                    e.printStackTrace();
                                                }
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                            ");

                                                        
                                                    
                                                        String thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                        //formatting the time for user convenience
                                                        if( x > 12)
                                                        {
                                                             int TempHour = x - 12;
                                                             NextAvailableFormattedTime = Integer.toString(TempHour) + ":" +  thisMinute + "pm";
                                                        }
                                                        else if(x == 0){
                                                            NextAvailableFormattedTime = "12" + ":" + thisMinute + "am";
                                                        }
                                                        else if(x == 12){
                                                            NextAvailableFormattedTime = NextAvailableTime + "pm";
                                                        }
                                                        else{
                                                            NextAvailableFormattedTime = NextAvailableTime +"am";
                                                        }
                                                     
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                            ");
 
                                                if(bookedTimeFlag == 1){
                                                    
                                                    HowManyColums++;
                                                    isLineAvailable = true;
                                                    
                                                    TotalUnavailableList++;
                                                    AllUnavailableTimeList.add(NextAvailableTime);
                                                    AllUnavailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                    int t = i + 1;
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                            <td onclick=\"showLineTakenMessage(");
      out.print(t);
      out.print(TotalUnavailableList);
      out.write(")\">\n");
      out.write("                                                <p  style=\"font-size: 12px; font-weight: bold; color: red;\">");
      out.print(NextAvailableFormattedTime);
      out.write("</p>\n");
      out.write("                                                <img src=\"icons/icons8-standing-man-filled-50.png\" width=\"50\" height=\"50\" alt=\"icons8-standing-man-filled-50\"/>\n");
      out.write("                                            </td>\n");
      out.write("                                                \n");
      out.write("                                            ");
  
                                                    
                                                }
                                            
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                                <!--td>8:00am<img src=\"icons/icons8-standing-man-filled-50 (1).png\" width=\"50\" height=\"50\" alt=\"icons8-standing-man-filled-50 (1)\"/>\n");
      out.write("                                                </td-->\n");
      out.write("                                                \n");
      out.write("                                            ");
 
                                                if(bookedTimeFlag == 0){
                                                    
                                                    HowManyColums++;
                                                    isLineAvailable = true;
                                                    
                                                    TotalAvailableList++;
                                                    AllAvailableTimeList.add(NextAvailableTime);
                                                    AllAvailableFormattedTimeList.add(NextAvailableFormattedTime);
                                                    int t = i + 1;
                                            
      out.write("\n");
      out.write("                                                \n");
      out.write("                                                 <td onclick=\"ShowQueueLinDivBookAppointment(");
      out.print(t);
      out.print(TotalAvailableList);
      out.write(")\">\n");
      out.write("                                                     <p style=\"font-size: 12px; font-weight: bold; color: blue;\">");
      out.print(NextAvailableFormattedTime);
      out.write("</p>\n");
      out.write("                                                     <img src=\"icons/icons8-standing-man-filled-50 (1).png\" width=\"50\" height=\"50\" alt=\"icons8-standing-man-filled-50 (1)\"/>\n");
      out.write("                                                </td>\n");
      out.write("                                                \n");
      out.write("                                            ");
 
                                                  }

                                            
      out.write("\n");
      out.write("                                                \n");
      out.write("                                            ");

                                            if(bookedTimeFlag == 2){
                                                
                                                HowManyColums++;
                                                isLineAvailable = true;
                                                
                                                TotalThisCustomerTakenList++;
                                                AllThisCustomerTakenTime.add(NextAvailableTime);
                                                AllThisCustomerTakenFormattedTakenTime.add(NextAvailableFormattedTime);
                                                int t = i + 1;
                                                
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                                <td onclick=\"showYourPositionMessage(");
      out.print(t);
      out.print(TotalThisCustomerTakenList);
      out.write(")\">\n");
      out.write("                                                    <p style=\"font-size: 12px; font-weight: bold; color: green;\">");
      out.print(NextAvailableFormattedTime);
      out.write("</p>\n");
      out.write("                                                    <img src=\"icons/icons8-standing-man-filled-50 (2).png\" width=\"50\" height=\"50\" alt=\"icons8-standing-man-filled-50 (2)\"/>\n");
      out.write("                                                </td>\n");
      out.write("                                                \n");
      out.write("                                            ");
  }
                                            
                                                bookedTimeFlag = 0;
                                            
                                            
      out.write("\n");
      out.write("                                                <!--td>9:30am<img src=\"icons/icons8-standing-man-filled-50.png\" width=\"50\" height=\"50\" alt=\"icons8-standing-man-filled-50\"/>\n");
      out.write("                                                </td-->\n");
      out.write("                                            ");
 
                                                        
                                                        y += IntervalsValue;
                                                        
                                                        while(y >= 60){
                                                             
                                                            x++;
                                                            
                                                            if(y > 60)
                                                                y -= 60;
                                                            else if(y == 60)
                                                                y = 0;
                                                             
                                                            if(x > twoHours){
                                                               //breaking out of this inner loop  
                                                               //incidentally the condition of outer loop becomes false
                                                               //thereby exiting as well
                                                               broken = true;
                                                               break;
                                                            }
                                                        }
                                                        
                                                        thisMinute = Integer.toString(y);
                                                        
                                                        if(thisMinute.length() < 2){
                                                            thisMinute = "0" + thisMinute;
                                                        }
                                                        
                                                        NextAvailableTime = x + ":" + thisMinute;
                                                        
                                                        /*formatting the time for user convenience
                                                        if( x > 12)
                                                        {
                                                             int TempHour = x - 12;
                                                             NextAvailableFormattedTime = Integer.toString(TempHour) + ":" +  thisMinute + "pm";
                                                        }
                                                        else if(x == 0){
                                                            NextAvailableFormattedTime = "12" + ":" + thisMinute + "am";
                                                        }
                                                        else if(x == 12){
                                                            NextAvailableFormattedTime = NextAvailableTime + "pm";
                                                        }
                                                        else{
                                                            NextAvailableFormattedTime = NextAvailableTime +"am";
                                                        }*/
                                                    
                                                        //CurrentMinute = y;
                                                        
                                                        //if(HowManyColums >= 5)
                                                            //break;
                                                  
                                                    }
                                                      
                                                    //if(HowManyColums >= 5)
                                                        //break;
                                                }
                                            
      out.write("\n");
      out.write("                                            \n");
      out.write("                                            </tr>\n");
      out.write("                                        </tbody>\n");
      out.write("                                    </table>\n");
      out.write("                                            \n");
      out.write("                                    </div>\n");
      out.write("                                        \n");
      out.write("                                     ");

                                        
                                        for(int z = 0; z < AllThisCustomerTakenFormattedTakenTime.size(); z++){
                                            
                                            String NextThisAvailableTimeForDisplay = AllThisCustomerTakenFormattedTakenTime.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    
      out.write("     \n");
      out.write("                                            \n");
      out.write("                                    <p style=\"background-color: green; color: white; display: none; text-align: center;\" id=\"YourLinePositionMessage");
      out.print(t);
      out.print(q);
      out.write("\">Position at ");
      out.print(NextThisAvailableTimeForDisplay);
      out.write(" is your spot on ");
      out.print(fullName);
      out.write("'s line.</p>\n");
      out.write("                                    \n");
      out.write("                                    ");
}
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    ");

                                        
                                        for(int z = 0; z < AllUnavailableTimeList.size(); z++){
                                            
                                            String NextUnavailableTimeForMessage = AllUnavailableFormattedTimeList.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    <p style=\"background-color: red; color: white; text-align: center; display: none;\" id=\"LineTakenMessage");
      out.print(t);
      out.print(q);
      out.write('"');
      out.write('>');
      out.print(NextUnavailableTimeForMessage);
      out.write(" is unavailable. This and every red spot has been taken.</p>\n");
      out.write("                                    \n");
      out.write("                                    ");
}
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    ");

                                        if(!isLineAvailable){
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    <p style=\"background-color: red; color: white; text-align: center;\">There is no line currently available for this service provider</p>\n");
      out.write("                                    \n");
      out.write("                                    ");
}
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    <p style=\"\"><span style=\"color: blue; border: 1px solid blue;\"><img src=\"icons/icons8-standing-man-filled-50 (1).png\" width=\"30\" height=\"25\" alt=\"icons8-standing-man-filled-50 (1)\"/>\n");
      out.write("                                        Available </span> <span style=\"color: red; border: 1px solid red;\"><img src=\"icons/icons8-standing-man-filled-50.png\" width=\"30\" height=\"25\" alt=\"icons8-standing-man-filled-50\"/>\n");
      out.write("                                        Taken </span> <span style=\"color: green; border: 1px solid green; padding-right: 3px;\"><img src=\"icons/icons8-standing-man-filled-50 (2).png\" width=\"30\" height=\"25\" alt=\"icons8-standing-man-filled-50 (2)\"/>\n");
      out.write("                                        Your Spot </span> </p>\n");
      out.write("                                      \n");
      out.write("                                    ");

                                        
                                        for(int z = 0; z < AllAvailableTimeList.size(); z++){
                                            
                                            String NextAvailableTimeForForm = AllAvailableTimeList.get(z);
                                            String NextAvailableTimeForFormDisplay = AllAvailableFormattedTimeList.get(z);
                                            
                                            int t = i + 1;
                                            int q = z + 1;
                                            
                                    
      out.write("\n");
      out.write("                                    \n");
      out.write("                                    <form style=\"display: none;\" id=\"bookAppointmentFromLineDiv");
      out.print(t);
      out.print(q);
      out.write("\" name=\"bookAppointmentFromLineDiv\" action=\"EachSelectedProviderLoggedIn.jsp\" method=\"POST\">\n");
      out.write("                                        <input type=\"hidden\" name=\"AppointmentTime\" value=\"");
      out.print(NextAvailableTimeForForm);
      out.write("\" />\n");
      out.write("                                        <input type=\"hidden\" name=\"UserID\" value=\"");
      out.print(SID);
      out.write("\" />\n");
      out.write("                                        <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                                        <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                                        <input style=\"background-color: lightblue; padding: 5px; border: 1px solid black;\" type=\"submit\" value=\"Take this spot - [ ");
      out.print(NextAvailableTimeForFormDisplay);
      out.write(" ]\" name=\"QueueLineDivBookAppointment\" />\n");
      out.write("                                        <p style=\"margin-top: 5px; color: red; text-align: center;\">OR</p>\n");
      out.write("                                    </form>\n");
      out.write("                                        \n");
      out.write("                                    ");
}
      out.write("\n");
      out.write("                                \n");
      out.write("                                </div></center>\n");
      out.write("                                                \n");
      out.write("                            <center><form action=\"EachSelectedProviderLoggedIn.jsp\" method=\"POST\" id=\"SID\">   \n");
      out.write("                            <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                            <input type=\"hidden\" name=\"UserID\" value=\"");
      out.print(SID);
      out.write("\" />\n");
      out.write("                            <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                            <input id=\"eachprov\" type=\"submit\" value=\"I will choose a different spot\" name=\"submit\" />\n");
      out.write("                            </form></center>\n");
      out.write("                            \n");
      out.write("                            </td> \n");
      out.write("                            </tr>\n");
      out.write("                            </tbody>\n");
      out.write("                            \n");
      out.write("                            ");
}//end of for loop
      out.write("\n");
      out.write("                            \n");
      out.write("                            </table></center>\n");
      out.write("                            \n");
      out.write("                </div></center>\n");
      out.write("                <form name=\"GetMoreRecords\" action=\"QueueSelectBusinessLoggedIn.jsp\">\n");
      out.write("                    <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                    <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                    <input style=\"border: 0; color: white; background-color: #6699ff;\" type=\"submit\" value=\"See More...\" name=\"MoreRecBtn\" />\n");
      out.write("                </form>\n");
      out.write("            </div>\n");
      out.write("                            \n");
      out.write("        </div>\n");
      out.write("                            \n");
      out.write("        <div id=\"newbusiness\">\n");
      out.write("            \n");
      out.write("            <div id=\"ExtraproviderIcons\" style=\"padding-top: 10px;\">\n");
      out.write("             \n");
      out.write("                <div id=\"SearchDivNB\">\n");
      out.write("                <center><form action=\"ByAddressSearchResultLoggedIn.jsp\" method=\"POST\" style=\"background-color: #6699ff; border: 1px solid buttonshadow; padding: 5px; border-radius: 5px; width: 90%;\">\n");
      out.write("                    <input type=\"hidden\" name=\"UserIndex\" value=\"");
      out.print(UserIndex);
      out.write("\" />\n");
      out.write("                    <input type=\"hidden\" name=\"User\" value=\"");
      out.print(NewUserName);
      out.write("\" />\n");
      out.write("                    <p style=\"color: #000099;\"><img src=\"icons/icons8-marker-filled-30.png\" width=\"15\" height=\"15\" alt=\"icons8-marker-filled-30\"/>\n");
      out.write("                        Find services at location below</p>\n");
      out.write("                    <p>City: <input style=\"width: 80%; background-color: #6699ff;\" type=\"text\" name=\"city4Search\" placeholder=\"\" value=\"\"/></p> \n");
      out.write("                    <p>Town: <input style=\"background-color: #6699ff; width: 40%;\" type=\"text\" name=\"town4Search\" value=\"\"/> Zip Code: <input style=\"width: 19%; background-color: #6699ff;\" type=\"text\" name=\"zcode4Search\" value=\"\" /></p>\n");
      out.write("                    <p><input type=\"submit\" style=\"background-color: #6699ff; color: white; padding: 5px; border-radius: 5px; border: 1px solid white; width: 95%;\" value=\"Search\" /></p>\n");
      out.write("                    </form></center>\n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("             <center><h4 style=\"margin: 5px; margin-top: 15px;\">Explore Service Providers</h4></center>\n");
      out.write("                \n");
      out.write("                <div id=\"firstSetProvIcons\">\n");
      out.write("                <center><table id=\"providericons\">\n");
      out.write("                        <tbody>\n");
      out.write("                        <tr>\n");
      out.write("                            <td style=\"width: 33.3%;  background-color: pink;\"><center><a href=\"QueueSelectBusinessLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">All Services</p><img src=\"icons/icons8-ellipsis-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-ellipsis-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectBarberBusinessLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"BarberShopSelect\">Barber Shop</p><img src=\"icons/icons8-barber-clippers-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-barber-clippers-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectMakeUpArtistLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"MakeupArtistSelect\">Makeup Artist</p><img src=\"icons/icons8-cosmetic-brush-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-cosmetic-brush-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr>\n");
      out.write("                            <td><center><a href=\"QueueSelectPodiatryLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"PodiatrySelect\">Podiatry</p><img src=\"icons/icons8-foot-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-foot-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectHairSalonLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Hair Salon</p><img src=\"icons/icons8-woman's-hair-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-woman's-hair-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectMassageLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"MassageSelect\">Massage</p><img src=\"icons/icons8-massage-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-massage-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr>\n");
      out.write("                            <td><center><a href=\"QueueSelectHolisticMedicineLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"HolMedSelect\">Holistic Medicine</p><img src=\"icons/icons8-pill-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-pill-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectMedAesthetLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"MedEsthSelect\">Aesthetician</p><img src=\"icons/icons8-cleansing-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-cleansing-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectDentistLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Dentist</p><img src=\"icons/icons8-tooth-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-tooth-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                    </table></center>\n");
      out.write("                    \n");
      out.write("                    <center><p onclick=\"showSecondSetProvIcons()\" style=\"text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; margin-top: 5px; cursor: pointer; border-radius: 4px;\">Next</p></center>\n");
      out.write("                \n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <div id=\"secondSetProvIcons\" style=\"display: none;\">\n");
      out.write("                    <center><table id=\"providericons\">\n");
      out.write("                        <tbody>\n");
      out.write("                        <tr>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectBrowLashLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"EyebrowsSelect\">Eyebrows and Lashes</p><img src=\"icons/icons8-eye-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-eye-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                             <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectDieticianLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"DieticianSelect\">Dietician</p><img src=\"icons/icons8-dairy-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-dairy-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectPetServLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"PetServicesSelect\">Pet Services</p><img src=\"icons/icons8-dog-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-dog-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        </tr>\n");
      out.write("                        <tr>\n");
      out.write("                            <td><center><a href=\"QueueSelectHomeServLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"HomeServicesSelect\">Home Services</p><img src=\"icons/icons8-home-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-home-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectPiercingLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"PiercingSelect\">Piercing</p><img src=\"icons/icons8-piercing-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-piercing-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectTattooLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Tattoo Shop</p><img src=\"icons/icons8-tattoo-machine-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-tattoo-machine-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        <tr>\n");
      out.write("                            <td><center><a href=\"QueueSelectNailSalonLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"NailSalonSelect\">Nail Salon</p><img src=\"icons/icons8-nails-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-nails-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectPersonalTrainerLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"PersonalTrainSelect\">Personal Trainer</p><img src=\"icons/icons8-personal-trainer-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-personal-trainer-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td><center><a href=\"QueueSelectPhysicalTherapyLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"PhysicalTherapySelect\">Physical Therapy</p><img src=\"icons/icons8-physical-therapy-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-physical-therapy-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                        </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                    </table></center>\n");
      out.write("                    \n");
      out.write("                    <center><p style=\"margin-bottom: 7px; margin-top: 10px;\"><span onclick=\"showFirstSetProvIcons()\" style=\"text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 50px; cursor: pointer; border-radius: 4px;\">Previous</span>\n");
      out.write("                            <span onclick=\"showThirdSetProvIcons()\" style=\"text-align: center; background-color: pink; padding: 5px; border: 1px solid black; padding-left: 17px; padding-right: 18px; width: 50px; cursor: pointer; border-radius: 4px;\">Next</span></p></center>\n");
      out.write("                \n");
      out.write("                </div>\n");
      out.write("                \n");
      out.write("                <div id=\"thirdSetProvIcons\" style=\"display: none;\">\n");
      out.write("                        <center><table id=\"providericons\">\n");
      out.write("                        <tbody>\n");
      out.write("                            <tr>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectDaySpaLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Day Spa</p><img src=\"icons/icons8-sauna-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-sauna-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectHairRemovalLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Hair Removal</p><img src=\"icons/icons8-skin-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-skin-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectBeautySalonLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\" name=\"BeautySalonSelect\">Beauty Salon</p><img src=\"icons/icons8-cleansing-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-cleansing-filled-70\"/>\n");
      out.write("                            </a></center></td>\n");
      out.write("                            </tr> \n");
      out.write("                            <tr>\n");
      out.write("                                <td style=\"width: 33.3%;\"><center><a href=\"QueueSelectMedicalCenterLoggedIn.jsp?UserIndex=");
      out.print(UserIndex);
      out.write("&User=");
      out.print(NewUserName);
      out.write("\"><p style=\"margin:0;\">Medical Center</p><img src=\"icons/icons8-hospital-3-filled-70.png\" width=\"70\" height=\"70\" alt=\"icons8-hospital-3-filled-70\"/>\n");
      out.write("                                </a></center></td>\n");
      out.write("                            </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                    </table></center>\n");
      out.write("                    \n");
      out.write("                    <center><p onclick=\"showSecondFromThirdProvIcons()\" style=\"text-align: center; background-color: pink; padding: 5px; border: 1px solid black; width: 55px; margin-top: 5px; cursor: pointer; border-radius: 4px;\">Previous</p></center>\n");
      out.write("\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("        </div>\n");
      out.write("                            \n");
      out.write("        <div id=\"footer\">\n");
      out.write("            <p>AriesLab &copy;2019</p>\n");
      out.write("        </div>\n");
      out.write("                            \n");
      out.write("    </div>\n");
      out.write("                            \n");
      out.write("    </body>\n");
      out.write("    \n");
      out.write("    \n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
