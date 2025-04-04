package com.donation;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.time.*;
import java.time.format.*;

@WebServlet("/UploadProfileImageServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class UploadProfileImageServlet extends HttpServlet {
    
    private static final String DB_URL_ENV = "JDBC_DATABASE_URL";
    private static final String DB_USER_ENV = "JDBC_DATABASE_USERNAME";
    private static final String DB_PASSWORD_ENV = "JDBC_DATABASE_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if (session == null || session.getAttribute("email") == null) {
            if (isAjaxRequest) {
                sendJsonResponse(response, false, "Not logged in");
            } else {
                response.sendRedirect("login.html");
            }
            return;
        }

        try {
            String email = (String) session.getAttribute("email");
            Part filePart = request.getPart("profileImage");

            if (filePart == null || filePart.getSize() == 0) {
                if (isAjaxRequest) {
                    sendJsonResponse(response, false, "No file selected");
                } else {
                    response.sendRedirect("userprofile.jsp?error=nofile");
                }
                return;
            }

            // Generate unique filename
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            String uniqueFileName = email.replaceAll("[^a-zA-Z0-9]", "_") + "_" + timestamp + fileExtension;

            // Save to uploads directory
            String uploadPath = getServletContext().getRealPath("") + "uploads";
            Files.createDirectories(Paths.get(uploadPath));
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Update database
            String imageUrl = "uploads/" + uniqueFileName;
            Class.forName("org.postgresql.Driver");
            String dbUrl = System.getenv(DB_URL_ENV);
            String dbUser = System.getenv(DB_USER_ENV);
            String dbPassword = System.getenv(DB_PASSWORD_ENV);

            try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pst = con.prepareStatement(
                     "UPDATE users SET profile_image = ? WHERE email = ?")) {
                
                pst.setString(1, imageUrl);
                pst.setString(2, email);
                
                if (pst.executeUpdate() > 0) {
                    session.setAttribute("profileImage", imageUrl + "?t=" + System.currentTimeMillis());
                    if (isAjaxRequest) {
                        sendJsonResponse(response, true, "Profile picture updated");
                    } else {
                        response.sendRedirect("userprofile.jsp?success=true");
                    }
                } else {
                    if (isAjaxRequest) {
                        sendJsonResponse(response, false, "Database update failed");
                    } else {
                        response.sendRedirect("userprofile.jsp?error=dberror");
                    }
                }
            }
        } catch (Exception e) {
            if (isAjaxRequest) {
                sendJsonResponse(response, false, "Error: " + e.getMessage());
            } else {
                response.sendRedirect("userprofile.jsp?error=unknown");
            }
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(String.format("{\"success\":%b,\"message\":\"%s\"}", success, message));
        out.flush();
    }
}