package com.donation;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.JSONObject;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {
    // Using Render environment variables
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        try {
            Class.forName("org.postgresql.Driver");
            
            // Get database configuration from environment variables
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pstmt = conn.prepareStatement(
                     // PostgreSQL-compatible query (unchanged from original)
                     "SELECT email FROM otp WHERE email = ? AND otp = ? AND expiry > NOW()")) {
                
                pstmt.setString(1, email);
                pstmt.setString(2, otp);
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        json.put("success", true);
                        json.put("message", "OTP verified");
                    } else {
                        json.put("success", false);
                        json.put("message", "Invalid OTP");
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            json.put("success", false);
            json.put("message", "Database configuration error");
        } catch (SQLException e) {
            json.put("success", false);
            json.put("message", "Database connection error");
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "Unexpected error: " + e.getMessage());
        }
        
        out.print(json.toString());
        out.flush();
    }
}