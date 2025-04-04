package com.donation;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String message = request.getParameter("message");

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO feedback (name, email, subject, rating, message) VALUES (?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, subject);
                pstmt.setInt(4, rating);
                pstmt.setString(5, message);
                
                if (pstmt.executeUpdate() > 0) {
                    request.setAttribute("name", name);
                    request.setAttribute("email", email);
                    request.setAttribute("subject", subject);
                    request.setAttribute("rating", rating);
                    request.setAttribute("message", message);
                    request.getRequestDispatcher("feedbackConfirmation.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save feedback");
                }
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}