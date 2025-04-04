package com.donation;




import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pst = con.prepareStatement(
                     "SELECT fullname FROM users WHERE email = ? AND password = ?")) {
                
                pst.setString(1, email);
                pst.setString(2, hashPassword(password));
                
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("user", rs.getString("fullname"));
                        session.setAttribute("email", email);
                        response.sendRedirect("UserProfileServlet");
                    } else {
                        response.sendRedirect("login.html?error=invalid");
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            response.sendRedirect("login.html?error=configuration");
        } catch (SQLException e) {
            response.sendRedirect("login.html?error=database");
        } catch (Exception e) {
            response.sendRedirect("login.html?error=unexpected");
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