package com.donation;




import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String oldEmail = (String) session.getAttribute("email");
        String newFullname = request.getParameter("fullname");
        String newEmail = request.getParameter("email");

        try {
            Class.forName("org.postgresql.Driver");
            
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pst = con.prepareStatement(
                     "UPDATE users SET fullname = ?, email = ? WHERE email = ?")) {
                
                pst.setString(1, newFullname);
                pst.setString(2, newEmail);
                pst.setString(3, oldEmail);

                if (pst.executeUpdate() > 0) {
                    session.setAttribute("user", newFullname);
                    session.setAttribute("email", newEmail);
                    response.sendRedirect("editprofile.jsp?status=success");
                } else {
                    response.sendRedirect("editprofile.jsp?status=updateFailed");
                }
            }
        } catch (Exception e) {
            response.sendRedirect("editprofile.jsp?status=dbError");
        }
    }
}