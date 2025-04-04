<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful</title>
    <style>
        /* General Styles */
        body {
            background-color: #ffffff;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .success-container {
            text-align: center;
            width: 100%;
            max-width: 450px;
        }

        .success-box {
            background: #ffffff;
            color: #333;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            box-sizing: border-box;
        }

        .success-icon {
            width: 80px;
            height: 80px;
        }

        /* Heading */
        h2 {
            font-size: 24px;
            margin: 20px 0;
            color: #ff6600;
        }

        /* Text */
        p {
            font-size: 16px;
            color: #555;
            margin-bottom: 20px;
        }

        /* Login Button */
        .login-link {
            display: inline-block;
            background: #ff6600;
            color: #ffffff;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: 0.3s;
        }

        .login-link:hover {
            background: #cc5500;
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .success-box {
                padding: 20px;
            }

            h2 {
                font-size: 22px;
            }

            p {
                font-size: 14px;
            }

            .login-link {
                padding: 10px 18px;
            }
        }

        @media screen and (max-width: 480px) {
            .success-box {
                padding: 15px;
            }

            h2 {
                font-size: 20px;
            }

            p {
                font-size: 13px;
            }

            .login-link {
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-box">
            <img src="registrationsucessfully img.png" alt="Success" class="success-icon">
            <h2>Registration Successful!</h2>
            <p>Thank you for registering. You can now log in to your account.</p>
            <a href="login.html" class="login-link">Go to Login</a>
        </div>
    </div>
</body>
</html>
