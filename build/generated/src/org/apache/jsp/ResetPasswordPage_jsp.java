package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.swing.JOptionPane;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.Connection;
import com.arieslab.queue.queue_model.*;
import java.util.*;
import com.arieslab.queue.queue_model.UserAccount;

public final class ResetPasswordPage_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

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
      out.write("        <link href=\"QueueCSS.css\" rel=\"stylesheet\" media=\"screen\" type=\"text/css\"/>\n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n");
      out.write("        <script src=\"https://code.jquery.com/jquery-1.12.4.js\"></script>\n");
      out.write("        <script src=\"https://code.jquery.com/ui/1.12.1/jquery-ui.js\"></script>\n");
      out.write("        \n");
      out.write("        <title>Queue</title>\n");
      out.write("    </head>\n");
      out.write("    \n");
      out.write("    ");

        
        config.getServletContext().setAttribute("DBUrl", config.getInitParameter("databaseUrl"));
        config.getServletContext().setAttribute("DBDriver", config.getInitParameter("databaseDriver"));
        config.getServletContext().setAttribute("DBUser", config.getInitParameter("user"));
        config.getServletContext().setAttribute("DBPassword", config.getInitParameter("password"));
        
        String url = config.getServletContext().getAttribute("DBUrl").toString();
        String Driver = config.getServletContext().getAttribute("DBDriver").toString();
        String User = config.getServletContext().getAttribute("DBUser").toString();
        String Password = config.getServletContext().getAttribute("DBPassword").toString();
        
        String Message = "";
        String Email = "";
        String AccountType = "";
        
        try{
            AccountType = request.getParameter("AccountType");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Email = request.getParameter("Email");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        try{
            Message = request.getParameter("Message");
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(Message == null){
            Message = "Please enter your existing username and your new password";
        }
        
        /*try{
        
        int UserID = 0;
        
        int UserIndex = Integer.parseInt(session.getAttribute("UserIndex").toString());
        
        String tempAccountType = UserAccount.LoggedInUsers.get(UserIndex).getAccountType();
        
        if(tempAccountType.equals("CustomerAccount"))
            UserID = UserAccount.LoggedInUsers.get(UserIndex).getUserID();
        
        if(tempAccountType.equals("BusinessAccount")){
            request.setAttribute("UserIndex", UserIndex);
            request.getRequestDispatcher("ServiceProviderPage.jsp").forward(request, response);
        }
        
        else if(UserID == 0)
            response.sendRedirect("LogInPage.jsp");
        }catch(Exception e){}*/
    
      out.write("\n");
      out.write("    \n");
      out.write("    <body>\n");
      out.write("        \n");
      out.write("        <div id=\"PermanentDiv\" style=\"\">\n");
      out.write("            \n");
      out.write("            <a href=\"Queue.jsp\" id='ExtraDrpDwnBtn' style='margin-top: 2px; margin-left: 2px;float: left; width: 70px; font-weight: bolder; padding: 4px; cursor: pointer; background-color: #334d81; color: white; border: 2px solid white; border-radius: 4px;'>\n");
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
      out.write("                    <center><div style=\"width: 100%; max-width: 360px; text-align: left; padding-top: 3px; margin-bottom: 0; padding-bottom: 0;\">\n");
      out.write("                        <img style='border: 2px solid black; background-color: beige; border-radius: 100%; margin-bottom: 20px; position: absolute;' src=\"icons/icons8-user-filled-100.png\" width=\"30\" height=\"30\" alt=\"icons8-user-filled-100\"/>\n");
      out.write("                    </div></center>\n");
      out.write("            </div>\n");
      out.write("        \n");
      out.write("            <ul>\n");
      out.write("                <a  href=\"Queue.jsp\">\n");
      out.write("                    <li onclick=\"\" style='cursor: pointer; background-color: #334d81;'><img style='background-color: white;' src=\"icons/icons8-home-50.png\" width=\"20\" height=\"17\" alt=\"icons8-home-50\"/>\n");
      out.write("                    Home</li></a>\n");
      out.write("                <li style='cursor: pointer;'><img style='background-color: white;' src=\"icons/icons8-calendar-50.png\" width=\"20\" height=\"17\" alt=\"icons8-calendar-50\"/>\n");
      out.write("                    Calender</li>\n");
      out.write("                <li style='cursor: pointer;'><img style='background-color: white;' src=\"icons/icons8-user-50 (1).png\" width=\"20\" height=\"17\" alt=\"icons8-user-50 (1)\"/>\n");
      out.write("                    Account</li>\n");
      out.write("            </ul>\n");
      out.write("        \n");
      out.write("        </div>\n");
      out.write("        \n");
      out.write("        <div id=\"container\">\n");
      out.write("            \n");
      out.write("        <div id=\"header\">\n");
      out.write("            \n");
      out.write("            <cetnter><p> </p></cetnter>\n");
      out.write("            <center><a href=\"LoginPageToQueue\"><image src=\"QueueLogo.png\" style=\"margin-top: 5px;\"/></a></center>\n");
      out.write("            <center><h3 style=\"color: #000099;\">Find Your Spot Now!</h3></center>\n");
      out.write("            \n");
      out.write("        </div>\n");
      out.write("            \n");
      out.write("            <div id=\"Extras\">\n");
      out.write("            \n");
      out.write("            <center><p style=\"color: #254386; font-size: 19px; font-weight: bolder; margin-bottom: 10px;\">Updates from service providers</p></center>\n");
      out.write("            \n");
      out.write("            <div style=\"max-height: 600px; overflow-y: auto;\">\n");
      out.write("                ");

                    try{
                        Class.forName(Driver);
                        Connection newsConn = DriverManager.getConnection(url, User, Password);
                        String newsQuery = "Select * from QueueServiceProviders.MessageUpdates where VisibleTo like 'Public%' order by MsgID desc";
                        PreparedStatement newsPst = newsConn.prepareStatement(newsQuery);
                        ResultSet newsRec = newsPst.executeQuery();
                        int newsItems = 0;
                        
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
                
      out.write("\n");
      out.write("                \n");
      out.write("                <table  id=\"ExtrasTab\" cellspacing=\"0\" style=\"margin-bottom: 3px;\">\n");
      out.write("                    <tbody>\n");
      out.write("                        <tr style=\"background-color: #333333;\">\n");
      out.write("                            <td>\n");
      out.write("                                <div id=\"ProvMsgBxOne\">\n");
      out.write("                                    <p style='font-weight: bolder; margin-bottom: 4px;'><span style='color: #eeeeee;'>");
      out.print(ProvFirstName);
      out.write(" - ");
      out.print(ProvCompany);
      out.write("</p></p>\n");
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
            
      out.write("\n");
      out.write("            </div>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("        <div id=\"content\">\n");
      out.write("            \n");
      out.write("            <div id=\"nav\">\n");
      out.write("                \n");
      out.write("                <h3><a href=\"index.jsp\" style =\"color: blanchedalmond\">AriesLab.com</a></h3>\n");
      out.write("                <center><p style = \"width: 130px; margin: 5px;\"><span id=\"displayDate\" style=\"\"></span></p></center>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <div id=\"main\">\n");
      out.write("                \n");
      out.write("                <cetnter><p> </p></cetnter>\n");
      out.write("                \n");
      out.write("                <center><div id =\"logindetails\" style=\"padding-top: 15px;\">\n");
      out.write("                <center><h4 style=\"margin-bottom: 30px;\"><a href=\"LoginPageToQueue\" style=\" color: white; background-color: blue; border: 1px solid black; padding: 4px;\">Click here to go to Queue home page</a></h2></center>\n");
      out.write("                <center><h4 style = \"margin-bottom: 15px;\">____________________________________________</h4></center>\n");
      out.write("                \n");
      out.write("                ");
if(Message != null){
      out.write("\n");
      out.write("                    <center><h4 style=\"color: white; margin-bottom: 15px; background-color: red; max-width: 350px;\">");
      out.print(Message);
      out.write("</h4></center>\n");
      out.write("                ");
}
      out.write("\n");
      out.write("                    \n");
      out.write("                <center><h2 style=\"margin-bottom: 20px;\">Reset Your Password</h2></center>\n");
      out.write("                \n");
      out.write("                <form id=\"LoginForm\" name=\"login\" method=\"POST\">\n");
      out.write("                    \n");
      out.write("                    <table border=\"0\"> \n");
      out.write("                            <tbody>\n");
      out.write("                                <tr>\n");
      out.write("                                    <td><input id=\"LoginPageUserNameFld\" placeholder=\"enter your current username here\" type=\"text\" name=\"username\" value=\"\" size=\"45\" style=\"background-color: #6699ff;\"/></td>\n");
      out.write("                                </tr>\n");
      out.write("                                <tr>\n");
      out.write("                                    <td><input id=\"LoginPagePasswordFld\" placeholder='enter your new password' type=\"password\" name=\"password\" value=\"\" size=\"45\" style=\"background-color: #6699ff;\"/></td>\n");
      out.write("                                </tr>\n");
      out.write("                            </tbody>\n");
      out.write("                        </table>\n");
      out.write("                    \n");
      out.write("                        <input class=\"button\" type=\"reset\" value=\"Reset\" name=\"resetbtn\" />\n");
      out.write("                        <input id=\"loginPageBtn\" class=\"button\" type=\"button\" value=\"Update\" name=\"submitbtn\" />\n");
      out.write("                    </form>\n");
      out.write("                \n");
      out.write("                <script>\n");
      out.write("                    \n");
      out.write("                    $(document).ready(function(){\n");
      out.write("                        $(\"#loginPageBtn\").click(function(event){\n");
      out.write("                            \n");
      out.write("                            var UserName = document.getElementById(\"LoginPageUserNameFld\").value;\n");
      out.write("                            var NewPassword = document.getElementById(\"LoginPagePasswordFld\").value;\n");
      out.write("                            var Email = ");
      out.print(Email);
      out.write(";\n");
      out.write("                            var ACCountType = ");
      out.print(AccountType);
      out.write(";\n");
      out.write("                            alert(UserName);\n");
      out.write("                            alert(NewPassword);\n");
      out.write("                            \n");
      out.write("                            $.ajax({\n");
      out.write("                                type: \"POST\",\n");
      out.write("                                url: \"\",\n");
      out.write("                                data: \"UserName=\"+UserName+\"&Password=\"+NewPassword+\"&Email=\"+Email,\n");
      out.write("                                success: function(result){\n");
      out.write("                                    \n");
      out.write("                                }\n");
      out.write("                            });\n");
      out.write("                            \n");
      out.write("                        });\n");
      out.write("                    });\n");
      out.write("                    \n");
      out.write("                </script>\n");
      out.write("                \n");
      out.write("                    \n");
      out.write("                <h5  style = \"margin: 10px;\" ><a href=\"SignUpPage.jsp\" style=\"color: white; background-color: blue; padding: 4px; border: 1px solid black;\">I don't have a user account. Sign-up now!</a></h5>\n");
      out.write("                </div></center>\n");
      out.write("                <center><h4 style = \"margin-bottom: 15px;\">____________________________________________</h4></center>\n");
      out.write("            \n");
      out.write("            </div>\n");
      out.write("                \n");
      out.write("        </div>\n");
      out.write("                \n");
      out.write("        <div id=\"newbusiness\" style=\"height: 525px;\">\n");
      out.write("            \n");
      out.write("            <center><h2 style=\"margin-top: 30px; margin-bottom: 20px; color: #000099\">Sign-up to add your business or to find a spot</h2></center>\n");
      out.write("            \n");
      out.write("            <div id=\"businessdetails\">\n");
      out.write("            <center><form name=\"AddBusiness\" action=\"SignUpPage.jsp\" method=\"POST\">\n");
      out.write("                    \n");
      out.write("                    <table border=\"0\">\n");
      out.write("                        <tbody>\n");
      out.write("                            <tr>\n");
      out.write("                                <td><h3 style=\"color: white; text-align: center;\">Provide your information below</h3></td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td><input id=\"signUpFirtNameFld\" placeholder=\"enter your first name\" type=\"text\" name=\"firstName\" value=\"\" size=\"45\"/></td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td><input id=\"sigUpLastNameFld\" placeholder=\"enter your last name\" type=\"text\" name=\"lastName\" value=\"\" size=\"45\"/></td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td><input onclick='checkMiddleNumber()' onkeydown=\"checkMiddleNumber()\" id=\"signUpTelFld\" placeholder=\"enter your telephone/mobile number here\" type=\"text\" name=\"telNumber\" value=\"\" size=\"45\"/></td>\n");
      out.write("                            </tr>\n");
      out.write("                            <tr>\n");
      out.write("                                <td><input id=\"signUpEmailFld\" placeholder=\"enter your email address here\" type=\"text\" name=\"email\" value=\"\" size=\"45\"/></td>\n");
      out.write("                            </tr>\n");
      out.write("                        </tbody>\n");
      out.write("                    </table>\n");
      out.write("                    \n");
      out.write("                    <input class=\"button\" type=\"reset\" value=\"Reset\" name=\"resetBtn\" />\n");
      out.write("                    <input id=\"loginPageSignUpBtn\" class=\"button\" type=\"submit\" value=\"Submit\" name=\"submitBtn\" />\n");
      out.write("                </form></center>\n");
      out.write("                <script>\n");
      out.write("                    var TelFld = document.getElementById(\"signUpTelFld\");\n");
      out.write("                        \n");
      out.write("                        function numberFunc(){\n");
      out.write("                            \n");
      out.write("                            var number = parseInt((TelFld.value.substring(TelFld.value.length - 1)), 10);\n");
      out.write("                            \n");
      out.write("                            if(isNaN(number)){\n");
      out.write("                                TelFld.value = TelFld.value.substring(0, (TelFld.value.length - 1));\n");
      out.write("                            }\n");
      out.write("                            \n");
      out.write("                        }\n");
      out.write("                        \n");
      out.write("                        setInterval(numberFunc, 1);\n");
      out.write("                        \n");
      out.write("                        function checkMiddleNumber(){\n");
      out.write("                            \n");
      out.write("                            for(var i = 0; i < TelFld.value.length; i++){\n");
      out.write("\n");
      out.write("                                var middleString = TelFld.value.substring(i, (i+1));\n");
      out.write("                                //window.alert(middleString);\n");
      out.write("                                var middleNumber = parseInt(middleString, 10);\n");
      out.write("                                //window.alert(middleNumber);\n");
      out.write("                                if(isNaN(middleNumber)){\n");
      out.write("                                    TelFld.value = TelFld.value.substring(0, i);\n");
      out.write("                                }\n");
      out.write("                            }\n");
      out.write("                        }\n");
      out.write("                        \n");
      out.write("                </script>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            </div>\n");
      out.write("                \n");
      out.write("        <div id=\"footer\">\n");
      out.write("            <p>AriesLab &copy;2019</p>\n");
      out.write("        </div>\n");
      out.write("                \n");
      out.write("    </div>\n");
      out.write("                \n");
      out.write("    </body>\n");
      out.write("    \n");
      out.write("    <script src=\"scripts/script.js\"></script>\n");
      out.write("    <script src=\"scripts/loginPageBtn.js\"></script>\n");
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
