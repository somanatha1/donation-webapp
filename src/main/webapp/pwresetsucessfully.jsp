<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset Successful - Jagannath Anugrah Trust</title>
    <link rel="icon" href="jagapng-modified.png">
    <style>
        /* General Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffffff, #f2f2f2);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .container {
            text-align: center;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }

        h2 {
            font-size: 22px;
            color: #ff6a00;
            margin-bottom: 10px;
        }

        p {
            font-size: 14px;
            color: #555;
            line-height: 1.5;
            margin-bottom: 20px;
        }

        /* Button Container */
        .button-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        /* Button Styles */
        .btn {
            background: #ff6a00;
            color: white;
            padding: 12px 20px;
            font-size: 14px;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease-in-out;
            text-align: center;
            flex: 1 1 auto;
            min-width: 120px;
            max-width: 140px;
            display: inline-block;
        }

        .btn-home {
            background: #444;
        }

        .btn:hover {
            opacity: 0.9;
            transform: scale(1.05);
        }

        /* Fully Responsive */
        @media (max-width: 600px) {
            .button-container {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 250px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Password Reset Successful 🎉</h2>
        <p>Your password has been reset successfully. You can now log in with your new password.</p>
        
        <div class="button-container">
            <a href="login.html" class="btn">Login</a>
            <a href="donation.html" class="btn btn-home">Go to Home</a>
        </div>
    </div>
</body>
</html>





