<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    // Get username and email from session
    String username = (String) session.getAttribute("user");
    String email = (String) session.getAttribute("email"); // Retrieve email from session

    // Redirect to login page if user is not logged in
    if (username == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Information</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .profile-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 2px solid #ff7f33; /* Orange border */
            text-align: center;
        }
        .profile-container h1 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .profile-info {
            margin-top: 20px;
        }
        .profile-info p {
            font-size: 18px;
            color: #555;
            margin-bottom: 15px;
        }
        .profile-info strong {
            color: #ff7f33; /* Orange color for labels */
        }
        .btn-custom {
            background-color: #ff7f33; /* Orange color for buttons */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-custom:hover {
            background-color: #e66a2b; /* Darker orange on hover */
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-container {
                margin: 20px auto;
                padding: 15px;
            }
            .profile-container h1 {
                font-size: 20px; /* Smaller heading for smaller screens */
            }
            .profile-info p {
                font-size: 16px; /* Smaller text for smaller screens */
            }
            .btn-custom {
                padding: 8px 16px; /* Smaller button for smaller screens */
                font-size: 14px;
            }
        }

        @media (max-width: 480px) {
            .profile-container {
                margin: 10px auto;
                padding: 10px;
            }
            .profile-container h1 {
                font-size: 18px; /* Even smaller heading for mobile */
            }
            .profile-info p {
                font-size: 14px; /* Even smaller text for mobile */
            }
            .btn-custom {
                width: 100%; /* Full-width button on mobile */
            }
        }
    </style>
</head>
<body>

    <!-- Profile Information Section -->
    <div class="profile-container">
        <h1>Profile Information</h1>
        <div class="profile-info">
            <p><strong>Username:</strong> <%= username %></p>
            <p><strong>Email:</strong> <%= email %></p> <!-- Display email from session -->
        </div>
        <button onclick="location.href='editprofile.jsp'" class="btn-custom">Edit Profile</button>
    </div>

</body>
</html>