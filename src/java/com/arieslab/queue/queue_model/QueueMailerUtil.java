
package com.arieslab.queue.queue_model;

import java.util.Properties;  
  
import javax.mail.*;  
import javax.mail.internet.InternetAddress;  
import javax.mail.internet.*;
import javax.swing.JOptionPane;

import java.io.*;
import java.util.*;
import javax.activation.*;



public class QueueMailerUtil {
    
        public void send(String to, String subject, String msg) {
        final String user="aries.tutorials.videos@gmail.com";//change accordingly  
        final String pass="Password@2014";  

        //1st step) Get the session object    
        Properties props = new Properties();  
        props.put("mail.smtp.host", "smtp.gmail.com");//change accordingly  
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true"); 
        
        props.put("mail.smtp.user", "aries.tutorials.videos@gmail.com");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.socketFactory.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "true");
        props.put("mail.smtp.ssl.enable", "true");
        /*prop key="mail.smtp.starttls.enable"   */
       SecurityManager security = System.getSecurityManager();

        Session session = Session.getInstance(props,  
        new javax.mail.Authenticator() {  
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {  
                return new PasswordAuthentication(user,pass);  
            }  
        });  
        //2nd step)compose message  
        try {  
            MimeMessage message = new MimeMessage(session);  
            message.setFrom(new InternetAddress(user));  
            message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));  
            message.setSubject(subject);  
            
            MimeBodyPart textPart = new MimeBodyPart();
            Multipart multipart = new MimeMultipart();
            String finalText = "";
            textPart.setText(msg);
            multipart.addBodyPart(textPart);
            message.setContent(multipart);
            //message.setText(msg);  

            //3rd step)send message  
            Transport.send(message);  

            //System.out.println("Done");
            JOptionPane.showMessageDialog(null, "Email sent");

         }catch (MessagingException e) {  
            throw new RuntimeException(e);  
         }
        
        }
    /*
    final String senderEmailID = "aries.tutorials.videos@gmail.com";
    final String senderPassword = "Password@2014";
    final String emailSMTPserver = "smtp.gmail.com";
    //final String emailSMTPserver = "Smtp.live.com";
    final String emailServerPort = "587";
    String receiverEmailID = null;
    String emailSubject = "Test Mail";
    String emailBody = ":)";

    //mail.smtp.ssl.enable = "true";
    public void send(String receiverEmailID, String Subject, String Body) {
        this.receiverEmailID = receiverEmailID;
        this.emailSubject = Subject;
        this.emailBody = Body;
        Properties props = new Properties();
        //System.setProperty("java.protocol.handler.pkgs", "com.sun.net.ssl.internal.www.protocol");
        props.put("mail.smtp.user", senderEmailID);
        props.put("mail.smtp.host", emailSMTPserver);
        props.put("mail.smtp.port", emailServerPort);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.socketFactory.port", emailServerPort);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");
        props.put("mail.smtp.ssl.enable", "true");
        /*prop key="mail.smtp.starttls.enable"   /
        SecurityManager security = System.getSecurityManager();
        //mail.smtp.ssl.enable "true"
        
        

        try {
            
            //SMTPAuthenticator auth = new SMTPAuthenticator();
            Session session = Session.getInstance(props, new SMTPAuthenticator("aries.tutorials.videos@gmail.com", "Password@2014"));
            
            MimeMessage msg = new MimeMessage(session);
            msg.setText(emailBody);
            msg.setSubject(emailSubject);
            msg.setFrom(new InternetAddress(senderEmailID));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(receiverEmailID));
            JOptionPane.showMessageDialog(null, "About to send email to " + receiverEmailID + ": MSG from " + senderEmailID);
            Transport.send(msg);
            //sendMessage(msg, msg.getAllRecipients());
            JOptionPane.showMessageDialog(null, "Message sent Successfully:)");
        }

        catch (Exception mex) {
            mex.printStackTrace();
        }
    }

    public class SMTPAuthenticator extends Authenticator {
        String user;
        String pwd;

        SMTPAuthenticator(String senderEmailID, String senderPassword) {

            super();
            this.user = senderEmailID;
            this.pwd = senderPassword;

        }

        @Override
        public PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(user, pwd);
        }
    }

*/
    
}
