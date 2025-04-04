package com.donation;




import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.html?error=passwordMismatch");
            return;
        }

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
                // Check if user exists
                try (PreparedStatement checkStmt = con.prepareStatement(
                        "SELECT email FROM users WHERE email = ? OR phone = ?")) {
                    checkStmt.setString(1, email);
                    checkStmt.setString(2, phone);
                    
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next()) {
                            response.sendRedirect("register.html?error=exists");
                            return;
                        }
                    }
                }

                // Insert new user
                try (PreparedStatement pst = con.prepareStatement(
                        "INSERT INTO users (fullname, email, phone, password) VALUES (?, ?, ?, ?)")) {
                    
                    pst.setString(1, fullname);
                    pst.setString(2, email);
                    pst.setString(3, phone);
                    pst.setString(4, hashPassword(password));
                    
                    if (pst.executeUpdate() > 0) {
                        response.sendRedirect("registersucess.jsp");
                    } else {
                        response.sendRedirect("register.html?error=failed");
                    }
                }
            }
        } catch (Exception e) {
            response.sendRedirect("register.html?error=database");
        }
    }

    private String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}