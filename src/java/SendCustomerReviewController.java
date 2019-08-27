

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author aries
 */
public class SendCustomerReviewController extends HttpServlet {

   
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String CustomerID = request.getParameter("CustomerID");
        String ProviderID = request.getParameter("ProviderID");
        String Ratings = request.getParameter("rate");
        String Review = request.getParameter("Review");
        
        String ReviewID = "";
        
        String Driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String url = "jdbc:sqlserver://DESKTOP-8LC73JA:1433;databaseName=Queue";
        String user = "sa";
        String password = "Password@2014";
        
        Date currentDate = new Date();
        SimpleDateFormat currentDateSdf = new SimpleDateFormat("yyyy-MM-dd");
        String StringDate = currentDateSdf.format(currentDate);
        
        
        
        try{
            
            Class.forName(Driver);
            Connection selectReviewConn = DriverManager.getConnection(url, user, password);
            String selectReviewString = "Select * from QueueServiceProviders.ProviderCustomersReview where ProviderID = ? and CustomerID = ?";
            PreparedStatement selectReviewPst = selectReviewConn.prepareStatement(selectReviewString);
            selectReviewPst.setString(1,ProviderID);
            selectReviewPst.setString(2,CustomerID);
            
            ResultSet ReviewRow = selectReviewPst.executeQuery();
            
            while(ReviewRow.next()){
                
                ReviewID = ReviewRow.getString("ReviewID");
                
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(!ReviewID.equalsIgnoreCase("")){
            
            try{
                
                Class.forName(Driver);
                Connection updateReviewConn = DriverManager.getConnection(url, user, password);
                String updateReviewString = "Update QueueServiceProviders.ProviderCustomersReview set ReviewMessage = ?, CustomerRating =?, ReviewDate = ? where ReviewID = ?";
                PreparedStatement updateReviewPst = updateReviewConn.prepareStatement(updateReviewString);
                updateReviewPst.setString(1, Review);
                updateReviewPst.setString(2, Ratings);
                updateReviewPst.setString(3, StringDate);
                updateReviewPst.setString(4, ReviewID);
                
                updateReviewPst.executeUpdate();
                
                //JOptionPane.showMessageDialog(null, "Your review was added sucessfully");
                //response.sendRedirect("ProviderCustomerPage.jsp");
                
            }catch(Exception e){
                e.printStackTrace();
            }
            
        }else{
            
            try{
                
                Class.forName(Driver);
                Connection insertReviewConn = DriverManager.getConnection(url, user, password);
                String insertReviewString = "Insert into QueueServiceProviders.ProviderCustomersReview values (?,?,?,?,?)";
                PreparedStatement insertReviewPst = insertReviewConn.prepareStatement(insertReviewString);
                insertReviewPst.setString(1,ProviderID);
                insertReviewPst.setString(2, CustomerID);
                insertReviewPst.setString(3, Review);
                insertReviewPst.setString(4, Ratings);
                insertReviewPst.setString(5, StringDate);
                
                insertReviewPst.executeUpdate();
                
                //JOptionPane.showMessageDialog(null, "Your review was added sucessfully");
                //response.sendRedirect("ProviderCustomerPage.jsp");
            
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        //calculating the overall review and update the ProviderRatings Table
        
        int NumberOfRatings = 0;
        int TotalRatings = 0;
        int RatingsAverage = 0;
        
        try{
            
            Class.forName(Driver);
            Connection selectReviewConn = DriverManager.getConnection(url, user, password);
            String selectReviewString = "Select * from QueueServiceProviders.ProviderCustomersReview where ProviderID = ?";
            PreparedStatement selectReviewPst = selectReviewConn.prepareStatement(selectReviewString);
            selectReviewPst.setString(1,ProviderID);
            
            ResultSet ReviewRow = selectReviewPst.executeQuery();
            
            while(ReviewRow.next()){
                
                ++NumberOfRatings;
                TotalRatings +=  ReviewRow.getInt("CustomerRating");
                
            }
            
            RatingsAverage = (int)Math.round((TotalRatings/NumberOfRatings));
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        //now inserting into the CustomerRating table
        
        String RatingsID = "";
        try{
            
            Class.forName(Driver);
            Connection selectRatingsConn = DriverManager.getConnection(url, user, password);
            String selectRatingsString = "Select * from QueueServiceProviders.ProviderRatings where ProviderID = ?";
            PreparedStatement selectRatingsPst = selectRatingsConn.prepareStatement(selectRatingsString);
            selectRatingsPst.setString(1, ProviderID);
            
            ResultSet selectRatingsRow = selectRatingsPst.executeQuery();
            
            while(selectRatingsRow.next()){
                
                RatingsID = selectRatingsRow.getString("RatingsID");
                
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
        
        if(!RatingsID.equalsIgnoreCase("")){
            
            try{
                
                Class.forName(Driver);
                Connection updateRatingsConn = DriverManager.getConnection(url, user, password);
                String updateRatingsString = "Update QueueServiceProviders.ProviderRatings set NumberOfRatings = ?, TotalRatings =?, RatingsAvg =? where RatingsID = ?";
                PreparedStatement updateRatingsPst = updateRatingsConn.prepareStatement(updateRatingsString);
                updateRatingsPst.setInt(1, NumberOfRatings);
                updateRatingsPst.setInt(2, TotalRatings);
                updateRatingsPst.setInt(3, RatingsAverage);
                updateRatingsPst.setString(4, RatingsID);
                
                updateRatingsPst.executeUpdate();
                
                //JOptionPane.showMessageDialog(null, "Your review was added sucessfully");
                //response.sendRedirect("ProviderCustomerPage.jsp");
            
            }catch(Exception e){
                e.printStackTrace();
            }
        
        }else{
            
            try{

                Class.forName(Driver);
                Connection insertRatingsConn = DriverManager.getConnection(url, user, password);
                String insertRatingsString = "insert into QueueServiceProviders.ProviderRatings values(?,?,?,?)";
                PreparedStatement insertRatingsPst = insertRatingsConn.prepareStatement(insertRatingsString);
                insertRatingsPst.setString(1, ProviderID);
                insertRatingsPst.setInt(2, NumberOfRatings);
                insertRatingsPst.setInt(3, TotalRatings);
                insertRatingsPst.setInt(4, RatingsAverage);
                
                insertRatingsPst.executeUpdate();
                
                //JOptionPane.showMessageDialog(null, "Your review was added sucessfully");
                //response.sendRedirect("ProviderCustomerPage.jsp");

            }catch(Exception e){
                e.printStackTrace();
            }
            
        }
        
        //updating ProviderInfo Records
        try{
            
            Class.forName(Driver);
            Connection updateProvInfo = DriverManager.getConnection(url, user, password);
            String updateProvInfoString = "Update QueueServiceProviders.ProviderInfo set Ratings = ? where Provider_ID = ?";
            PreparedStatement updateProvInfoPst = updateProvInfo.prepareStatement(updateProvInfoString);
            updateProvInfoPst.setInt(1, RatingsAverage);
            updateProvInfoPst.setString(2, ProviderID);
            
            updateProvInfoPst.executeUpdate();
            
            JOptionPane.showMessageDialog(null, "Your review was added sucessfully");
            //response.sendRedirect("ProviderCustomerPage.jsp");
        
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
