package com.donation;



import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.JSONObject;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("password");

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
                // Verify OTP
                try (PreparedStatement verifyStmt = conn.prepareStatement(
                        "SELECT email FROM otp WHERE email = ? AND otp = ? AND expiry > NOW()")) {
                    verifyStmt.setString(1, email);
                    verifyStmt.setString(2, otp);
                    
                    try (ResultSet rs = verifyStmt.executeQuery()) {
                        if (!rs.next()) {
                            jsonResponse.put("success", false);
                            jsonResponse.put("message", "Invalid OTP or expired.");
                            out.print(jsonResponse.toString());
                            return;
                        }
                    }
                }

                // Update password
                try (PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE users SET password = ? WHERE email = ?")) {
                    updateStmt.setString(1, hashPassword(newPassword));
                    updateStmt.setString(2, email);
                    
                    if (updateStmt.executeUpdate() > 0) {
                        // Delete OTP
                        try (PreparedStatement deleteStmt = conn.prepareStatement(
                                "DELETE FROM otp WHERE email = ?")) {
                            deleteStmt.setString(1, email);
                            deleteStmt.executeUpdate();
                        }
                        jsonResponse.put("success", true);
                        jsonResponse.put("message", "Password reset successfully.");
                    }
                }
            }
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
        }
        out.print(jsonResponse.toString());
    }

    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return null;
        }
    }
}