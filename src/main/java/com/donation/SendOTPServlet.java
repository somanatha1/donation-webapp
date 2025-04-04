package com.donation;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/SendOTPServlet")
public class SendOTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Environment variables for database
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    // Environment variables for SMTP
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            out.println("Invalid Email!");
            return;
        }

        String otp = String.format("%06d", generateOTP());
        boolean isStored = storeOTPInDatabase(email, otp);

        if (isStored) {
            boolean isEmailSent = sendOTPEmail(email, otp);
            if (isEmailSent) {
                out.println("OTP sent successfully to " + email);
            } else {
                out.println("OTP stored, but email failed to send!");
            }
        } else {
            out.println("Failed to generate OTP!");
        }
    }

    private int generateOTP() {
        return 100000 + new Random().nextInt(900000);
    }

    private boolean storeOTPInDatabase(String email, String otp) {
        String query = "INSERT INTO otp (email, otp, expiry) VALUES (?, ?, NOW() + INTERVAL '10 minutes') " +
                      "ON CONFLICT (email) DO UPDATE SET otp = EXCLUDED.otp, expiry = EXCLUDED.expiry";

        try {
            Class.forName("org.postgresql.Driver");
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, email);
                pstmt.setString(2, otp);
                return pstmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            return false;
        }
    }

    private boolean sendOTPEmail(String email, String otp) {
        // Get credentials from environment variables
        String smtpEmail = System.getenv("SMTP_EMAIL");
        String smtpPassword = System.getenv("SMTP_PASSWORD");

        if (smtpEmail == null || smtpPassword == null) {
            System.err.println("SMTP credentials not configured!");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpEmail, smtpPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Your OTP Code");
            
            String htmlMessage = "<div style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f8f9fa; " +
                               "border-radius: 10px; border: 4px solid #ffcc80;'>" +
                               "<h2 style='color: #ff8c00;'>Jagannath Anugrah Trust</h2>" +
                               "<p style='font-size: 18px; color: #333;'>Use the OTP below to reset your password:</p>" +
                               "<div style='display: inline-block; padding: 15px; border: 3px solid #ff8c00; border-radius: 5px; margin: 10px 0;'>" +
                               "<h1 style='color: #007bff; font-size: 32px; margin: 0;'>" + otp + "</h1>" +
                               "</div>" +
                               "<p style='font-size: 14px; color: #777;'>This OTP is valid for 10 minutes.</p>" +
                               "<p style='font-size: 14px; color: #ff0000;'>If you did not request this, please ignore this email.</p>" +
                               "</div>";

            message.setContent(htmlMessage, "text/html");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}