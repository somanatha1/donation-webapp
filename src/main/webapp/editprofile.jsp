<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
    // Get fullname and email from session
    String fullname = (String) session.getAttribute("user");
    String email = (String) session.getAttribute("email");
    String status = request.getParameter("status");

    // Redirect to login page if user is not logged in
    if (fullname == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
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
            justify-content: center;
            align-items: center;
        }
        .edit-profile-container {
            max-width: 600px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 2px solid #ff7f33; /* Orange border */
            text-align: center;
        }
        .edit-profile-container h1 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }
        .form-group label {
            font-weight: bold;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }
        .btn-custom {
            background-color: #ff7f33; /* Orange color */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s;
            display: block;
            width: 100%;
            text-decoration: none; /* Remove underline */
        }
        .btn-custom:hover {
            background-color: #e66a2b; /* Darker orange on hover */
        }
        .btn-home {
            margin-top: 10px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .edit-profile-container {
                margin: 20px auto;
                padding: 15px;
            }
            .edit-profile-container h1 {
                font-size: 20px;
            }
            .form-group input {
                font-size: 14px;
            }
            .btn-custom {
                font-size: 14px;
            }
        }
    </style>
    <script>
        function validateForm() {
            let fullname = document.getElementById("fullname").value.trim();
            let email = document.getElementById("email").value.trim();
            let nameError = document.getElementById("nameError");
            let emailError = document.getElementById("emailError");
            let emailFormatError = document.getElementById("emailFormatError");

            let isValid = true;

            // Reset error messages
            nameError.style.display = "none";
            emailError.style.display = "none";
            emailFormatError.style.display = "none";

            // Full Name Validation
            if (fullname === "") {
                nameError.style.display = "block";
                isValid = false;
            }

            // Email Empty Validation
            if (email === "") {
                emailError.style.display = "block";
                isValid = false;
            }

            // Email Format Validation
            let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (email !== "" && !emailPattern.test(email)) {
                emailFormatError.style.display = "block";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>

    <!-- Edit Profile Form -->
    <div class="edit-profile-container">
        <h1>Edit Profile</h1>

        <!-- Display success message -->
        <% if ("success".equals(status)) { %>
            <div class="alert alert-success">Profile updated successfully!</div>
        <% } %>

        <form action="EditProfileServlet" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="fullname">Full Name</label>
                <input type="text" id="fullname" name="fullname" value="<%= fullname %>" required>
                <div id="nameError" class="error-message">Full Name cannot be empty or spaces!</div>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
                <div id="emailError" class="error-message">Email cannot be empty or spaces!</div>
                <div id="emailFormatError" class="error-message">Enter a valid email (e.g., abc@xyz.com)!</div>
            </div>
            <button type="submit" class="btn-custom">Save Changes</button>
        </form>

        <!-- Back to Home Button -->
        <% if ("success".equals(status)) { %>
            <form action="userprofile.jsp" method="get">
                <button type="submit" class="btn-custom btn-home">Back to Home</button>
            </form>
        <% } %>

    </div>

</body>
</html>



