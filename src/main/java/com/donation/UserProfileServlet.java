package com.donation;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String email = (String) session.getAttribute("email");

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pst = con.prepareStatement(
                     "SELECT fullname, TO_CHAR(registration_date, 'YYYY-MM-DD') as reg_date, " +
                     "profile_image FROM users WHERE email = ?")) {
                
                pst.setString(1, email);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        String regDate = rs.getString("reg_date");
                        session.setAttribute("fullname", rs.getString("fullname"));
                        session.setAttribute("memberSince", regDate.substring(0, 4));
                        session.setAttribute("profileImage", rs.getString("profile_image"));
                        request.getRequestDispatcher("userprofile.jsp").forward(request, response);
                    } else {
                        session.invalidate();
                        response.sendRedirect("login.html?error=usernotfound");
                    }
                }
            }
        } catch (Exception e) {
            response.sendRedirect("error.html");
        }
    }
}