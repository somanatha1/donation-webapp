<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Submitted</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"></noscript>
    <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        /* Confirmation Container */
        .confirmation-container {
            position: relative;
            width: 100%;
            max-width: 800px;
            padding: 40px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin: 20px 0;
        }
        
        .confirmation-container::before {
            content: "";
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 128, 0, 0.08);
            border-radius: 50%;
            z-index: 0;
        }
        
        .confirmation-container::after {
            content: "";
            position: absolute;
            bottom: -100px;
            left: -100px;
            width: 300px;
            height: 300px;
            background: rgba(255, 128, 0, 0.05);
            border-radius: 50%;
            z-index: 0;
        }
        
        .confirmation-content {
            position: relative;
            z-index: 1;
        }
        
        /* Header */
        .confirmation-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .confirmation-header .success-icon {
            font-size: 4rem;
            color: #ff8000;
            margin-bottom: 20px;
            display: inline-block;
            animation: bounce 1.5s ease;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            60% {
                transform: translateY(-10px);
            }
        }
        
        .confirmation-header h1 {
            font-size: clamp(2rem, 5vw, 2.5rem);
            font-weight: 700;
            margin-bottom: 15px;
            color: #ff8000;
            position: relative;
            display: inline-block;
        }
        
        .confirmation-header h1::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #ff8000, #ffb366);
            border-radius: 2px;
        }
        
        .confirmation-header p {
            font-size: clamp(1rem, 2.5vw, 1.1rem);
            color: #666;
            font-weight: 300;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.5;
        }
        
        /* Feedback Details */
        .feedback-details {
            background-color: #fff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        
        .feedback-details h2 {
            font-size: 1.4rem;
            color: #444;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .detail-item {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        
        .detail-item:last-child {
            margin-bottom: 0;
        }
        
        .detail-item .label {
            font-weight: 600;
            color: #555;
            width: 120px;
            flex-shrink: 0;
        }
        
        .detail-item .value {
            color: #333;
            flex-grow: 1;
        }
        
        .detail-item .rating {
            color: #ff8000;
            font-size: 1.2rem;
        }
        
        .detail-item .message {
            background-color: #fff8f0;
            padding: 15px;
            border-radius: 8px;
            border-left: 3px solid #ffd8b6;
            font-style: italic;
        }
        
        /* Back Button */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 25px;
            background: #ff8000;
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(255, 128, 0, 0.3);
            text-decoration: none;
        }
        
        .back-btn:hover {
            background: #e67300;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 128, 0, 0.4);
        }
        
        .back-btn i {
            transition: transform 0.3s ease;
        }
        
        .back-btn:hover i {
            transform: translateX(-5px);
        }
        
        .button-container {
            text-align: center;
        }
        
        /* Responsive Breakpoints */
        @media (max-width: 768px) {
            .confirmation-container {
                padding: 30px;
            }
            
            .detail-item {
                flex-direction: column;
            }
            
            .detail-item .label {
                width: 100%;
                margin-bottom: 5px;
            }
        }
        
        @media (max-width: 576px) {
            .confirmation-container {
                padding: 25px 20px;
            }
            
            .confirmation-container::before,
            .confirmation-container::after {
                display: none;
            }
            
            .feedback-details {
                padding: 20px 15px;
            }
            
            .detail-item .message {
                padding: 12px;
            }
            
            .confirmation-header .success-icon {
                font-size: 3rem;
            }
            
            .back-btn {
                width: 100%;
                justify-content: center;
                padding: 12px 20px;
            }
        }
    </style>
</head>
<body>
    <main class="confirmation-container">
        <div class="confirmation-content">
            <div class="confirmation-header">
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h1>Thank You!</h1>
                <p>Your feedback has been successfully submitted. We appreciate your time and input.</p>
            </div>
            
            <div class="feedback-details">
                <h2>Feedback Summary</h2>
                
                <div class="detail-item">
                    <div class="label">Name:</div>
                    <div class="value">${name}</div>
                </div>
                
                <div class="detail-item">
                    <div class="label">Email:</div>
                    <div class="value">${email}</div>
                </div>
                
                <div class="detail-item">
                    <div class="label">Subject:</div>
                    <div class="value">
                        <%-- Convert subject code to readable text --%>
                        <% 
                            String subject = (String)request.getAttribute("subject");
                            if(subject != null) {
                                switch(subject) {
                                    case "general":
                                        out.print("General Feedback");
                                        break;
                                    case "bug":
                                        out.print("Bug Report");
                                        break;
                                    case "suggestion":
                                        out.print("Feature Suggestion");
                                        break;
                                    case "other":
                                        out.print("Other");
                                        break;
                                    default:
                                        out.print(subject);
                                }
                            }
                        %>
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="label">Rating:</div>
                    <div class="value">
                        <div class="rating">
                            <%-- Display rating as stars --%>
                            <% 
                                Integer rating = (Integer)request.getAttribute("rating");
                                if(rating != null) {
                                    for(int i = 0; i < rating; i++) {
                                        out.print("<i class=\"fas fa-star\"></i>");
                                    }
                                    for(int i = rating; i < 5; i++) {
                                        out.print("<i class=\"far fa-star\"></i>");
                                    }
                                    
                                    // Add text description
                                    String ratingText = "";
                                    switch(rating) {
                                        case 1:
                                            ratingText = " (Poor)";
                                            break;
                                        case 2:
                                            ratingText = " (Fair)";
                                            break;
                                        case 3:
                                            ratingText = " (Good)";
                                            break;
                                        case 4:
                                            ratingText = " (Very Good)";
                                            break;
                                        case 5:
                                            ratingText = " (Excellent)";
                                            break;
                                    }
                                    out.print(ratingText);
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="label">Message:</div>
                    <div class="value">
                        <div class="message">${message}</div>
                    </div>
                </div>
            </div>
            
            <div class="button-container">
                <a href="feedback.html" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    <span>Back to Feedback Form</span>
                </a>
            </div>
        </div>
    </main>
</body>
</html>