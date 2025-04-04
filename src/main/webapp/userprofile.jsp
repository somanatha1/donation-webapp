<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Jagannath Anugrah Trust</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="userprofile.css"> 
    <link rel="icon" href="jagapng-modified.png">
</head>
<body>
    <% 
        String fullname = (String) session.getAttribute("fullname");
        String memberSince = (String) session.getAttribute("memberSince");
        String profileImage = (String) session.getAttribute("profileImage");
        if (fullname == null) {
            response.sendRedirect("login.html");
            return;
        }
    %>
    
    <!-- Top Navbar -->
    <div class="navbar">
        <div class="welcome-message">
            <img src="logo-png-removebg-preview.png" alt="Logo">
            Welcome, <%= fullname %> 🙏😊
        </div>
        <button class="menu-btn" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
    </div>

    <!-- Sidebar -->
    <div id="sidebar" class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-title">Jagannath Anugrah Trust</div>
            <button class="close-btn" onclick="toggleSidebar()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        
        <!-- User Profile Section -->
        <div class="user-profile">
           <div class="profile-image">
    <img src="${pageContext.request.contextPath}/${profileImage != null ? profileImage : 'default_profile-removebg-preview.png'}" alt="User Avatar">
    <div class="edit-overlay">
        <i class="fas fa-camera"></i>
    </div>
    <form id="uploadForm" action="UploadProfileImageServlet" method="post" enctype="multipart/form-data" style="display: none;">
        <input type="file" name="profileImage" id="profileImageInput" accept="image/*">
    </form>
</div>

<!-- Add this notification div below the profile-image div -->
<div id="uploadNotification" style="display: none; margin-top: 10px; padding: 8px; text-align: center;"></div>

            <div class="profile-info">
                <h4><%= fullname %></h4>
                <p>Member since <%= memberSince %></p>
            </div>
        </div>
        
        <div class="menu-section"><span>Main Menu</span></div>
        
        <a href="profile.jsp"><i class="fas fa-user-circle"></i><span>Profile Information</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        <a href="#give-donation"><i class="fas fa-hand-holding-heart"></i><span>Give Donation</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        <a href="#donation-history"><i class="fas fa-history"></i><span>Donation History</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        <a href="#contribution"><i class="fas fa-donate"></i><span>Contribution</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        
        <div class="menu-section"><span>Account</span></div>
        
        <a href="#support-feedback"><i class="fas fa-question-circle"></i><span>Support & Feedback</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        <a href="editprofile.jsp"><i class="fas fa-user-edit"></i><span>Edit Profile</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        <a href="./LogoutServlet"><i class="fas fa-sign-out-alt"></i><span>Logout</span><i class="fas fa-chevron-right arrow-icon"></i></a>
        
        <!-- Sidebar Footer -->
        <div class="sidebar-footer">
            <div class="social-links">
                <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
            </div>
            <div class="copyright">
                &copy; 2023 Jagannath Anugrah Trust
            </div>
        </div>
    </div>

    <!-- Sidebar Overlay -->
    <div id="sidebar-overlay" class="sidebar-overlay"></div>

    <!-- Main Content -->
    <div class="content">
        <div class="hero-container">
            <div class="hero-content-wrapper">
                <!-- Trust Logo with Animation -->
                <div class="hero-logo-container">
                    <img src="logo-png-removebg-preview.png" alt="Jagannath Anugrah Trust Logo" class="hero-logo">
                </div>
                
                <!-- Headline with Impact Statement -->
                <h1 class="hero-title">Empowering Lives Through Compassion</h1>
                
                <!-- Animated Tagline -->
                <div class="hero-tagline-container">
                    <p class="hero-tagline">Join us in creating a world where every child has the opportunity to thrive</p>
                </div>
                
                <!-- Impact Statistics -->
                <div class="impact-stats">
                    <div class="stat-item">
                        <div class="stat-number" data-value="5000">0</div>
                        <div class="stat-label">Children Supported</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" data-value="120">0</div>
                        <div class="stat-label">Communities Reached</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" data-value="15">0</div>
                        <div class="stat-label">Years of Service</div>
                    </div>
                </div>
                
                <!-- CTA Buttons with Enhanced Design -->
                <div class="hero-cta-container">
                    <a href="#donation" class="cta-button primary-cta">
                        <i class="fas fa-heart"></i>
                        <span>Donate Now</span>
                    </a>
                    <a href="projects.html" class="cta-button secondary-cta">
                        <i class="fas fa-hands-helping"></i>
                        <span>Our Projects</span>
                    </a>
                </div>
            </div>
            
            <div class="scroll-indicator-container">
                <a href="#content-section" class="scroll-indicator">
                    <span class="scroll-text">Scroll to explore</span>
                    <span class="scroll-arrow"><i class="fas fa-chevron-down"></i></span>
                </a>
            </div>
        </div>

        <!-- Donation Section -->
        <section id="donation" class="donation-section">
            <h2>Support Our Cause</h2>
            <p>Your donation makes a difference in the lives of those we serve. Together, we can create a better future for everyone in our community.</p>
            
            <div class="donation-form">
                <div class="payment-tabs">
                    <button class="payment-tab active" data-tab="quick-donate">Quick Donate</button>
                    <button class="payment-tab" data-tab="upi">UPI</button>
                    <button class="payment-tab" data-tab="card">Card</button>
                </div>
                
                <!-- Quick Donate Tab -->
                <div class="tab-content active" id="quick-donate">
                    <div class="donation-options">
                        <div class="donation-option">₹100</div>
                        <div class="donation-option active">₹500</div>
                        <div class="donation-option">₹1000</div>
                        <div class="donation-option">₹2500</div>
                        <div class="donation-option">Custom</div>
                    </div>
                    
                    <div class="input-group amount-input">
                        <label for="amount">Donation Amount</label>
                        <span>₹</span>
                        <input type="number" id="amount" value="500" min="1" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" placeholder="Raj Sharma" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" placeholder="raj.sharma@example.com" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="phone">Mobile Number</label>
                        <input type="tel" id="phone" placeholder="9876543210" required>
                    </div>
                    
                    <button type="submit" class="donate-button">Donate Now</button>
                </div>
                
                <!-- UPI Tab -->
                <div class="tab-content" id="upi">
                    <div class="input-group amount-input">
                        <label for="upi-amount">Donation Amount</label>
                        <span>₹</span>
                        <input type="number" id="upi-amount" value="500" min="1" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="upi-id">UPI ID</label>
                        <input type="text" id="upi-id" placeholder="yourname@upi" required>
                    </div>
                    
                    <div class="upi-options">
                        <div class="upi-option">
                            <img src="/api/placeholder/40/40" alt="Google Pay">
                            <span>Google Pay</span>
                        </div>
                        <div class="upi-option">
                            <img src="/api/placeholder/40/40" alt="PhonePe">
                            <span>PhonePe</span>
                        </div>
                        <div class="upi-option">
                            <img src="/api/placeholder/40/40" alt="Paytm">
                            <span>Paytm</span>
                        </div>
                        <div class="upi-option">
                            <img src="/api/placeholder/40/40" alt="BHIM">
                            <span>BHIM</span>
                        </div>
                    </div>
                    
                    <button type="submit" class="donate-button">Pay via UPI</button>
                </div>
                
                <!-- Card Tab -->
                <div class="tab-content" id="card">
                    <div class="input-group amount-input">
                        <label for="card-amount">Donation Amount</label>
                        <span>₹</span>
                        <input type="number" id="card-amount" value="500" min="1" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="card-name">Name on Card</label>
                        <input type="text" id="card-name" placeholder="Raj Sharma" required>
                    </div>
                    
                    <div class="input-group">
                        <label for="card-number">Card Number</label>
                        <input type="text" id="card-number" placeholder="1234 5678 9012 3456" required>
                    </div>
                    
                    <div class="card-details">
                        <div class="input-group">
                            <label for="expiry">Expiry Date</label>
                            <input type="text" id="expiry" placeholder="MM/YY" required>
                        </div>
                        
                        <div class="input-group">
                            <label for="cvv">CVV</label>
                            <input type="text" id="cvv" placeholder="123" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="donate-button">Pay via Card</button>
                </div>
                
                <div class="trust-indicators">
                    <div class="trust-indicator">
                        <i>🔒</i> <span>Secure Payment</span>
                    </div>
                    <div class="trust-indicator">
                        <i>📃</i> <span>80G Tax Benefits</span>
                    </div>
                    <div class="trust-indicator">
                        <i>✓</i> <span>Verified NGO</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Enhanced Donation History Section -->
        <div id="donation-history" class="content-section">
            <div class="donation-history-container">
                <h2>Your Donation Journey</h2>
                
                <div class="history-stats">
                    <div class="history-stat-item">
                        <div class="stat-number">12</div>
                        <div class="stat-label">Total Donations</div>
                    </div>
                    <div class="history-stat-item">
                        <div class="stat-number">₹92,300</div>
                        <div class="stat-label">Amount Donated</div>
                    </div>
                    <div class="history-stat-item">
                        <div class="stat-number">8</div>
                        <div class="stat-label">Lives Impacted</div>
                    </div>
                </div>
                
                <div class="history-description">
                    <p>
                        Track your giving journey and see the real impact your generosity has made. Every contribution 
                        helps build a better future and creates positive change in our community.
                    </p>
                </div>
                
                <div class="recent-donation">
                    <div class="recent-label">
                        <i class="fas fa-star"></i> Latest Donation
                    </div>
                    <div class="recent-details">
                        <div class="recent-amount">₹8,950</div>
                        <div class="recent-date">March 10, 2025</div>
                        <div class="recent-cause">Education Fund</div>
                    </div>
                </div>
                
                <div class="history-actions">
                     <button onclick="location.href='underdevlopement.html'" class="primary-cta">
                        <i class="fas fa-history"></i>
                        <span>View Full History</span>
                    </button>
                    <button onclick="location.href='underdevlopement.html'" class="secondary-cta">
                        <i class="fas fa-chart-line"></i>
                        <span>See Your Impact</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Enhanced Contribution Section -->
        <div id="contribution" class="content-section">
            <div class="contribution-container">
                <h2>Join Our Mission</h2>
                
                <div class="contribution-description">
                    <p>
                        Your involvement is the heart of our community. Discover meaningful ways to contribute 
                        your time, skills, and resources to create lasting positive change in the world around us.
                    </p>
                </div>
                
                <div class="contribution-options">
                    <div class="contribution-option-item">
                        <div class="option-icon">
                            <span class="rupee-symbol">₹</span>
                        </div>
                        <div class="option-title">Financial Support</div>
                        <div class="option-description">Make a one-time or recurring donation to fund our vital initiatives</div>
                    </div>
                    
                    <div class="contribution-option-item">
                        <div class="option-icon">
                            <i class="fas fa-hands-helping"></i>
                        </div>
                        <div class="option-title">Volunteer</div>
                        <div class="option-description">Share your time and talents with communities that need it most</div>
                    </div>
                    
                    <div class="contribution-option-item">
                        <div class="option-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="option-title">Advocacy</div>
                        <div class="option-description">Help spread awareness and amplify our message for greater impact</div>
                    </div>
                </div>
                
                <div class="contribution-actions">
                    <button onclick="location.href='join.html'" class="primary-cta">
                        <i class="fas fa-heart"></i>
                        <span>Get Involved</span>
                    </button>
                    <button onclick="location.href='projects.html'" class="secondary-cta">
                        <i class="fas fa-project-diagram"></i>
                        <span>Current Projects</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Support and Feedback Section -->
        <div id="support-feedback" class="content-section">
            <h2>We're Here to Help</h2>
            <p>Your satisfaction is our priority. If you have any questions, concerns, or feedback, please reach out to us. We value your input and are committed to providing the best experience possible.</p>
            
            <div class="contact-methods">
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h4>Email Support</h4>
                    <p>Get a response within 24 hours</p>
                    <a href="mailto:jagannathanugrahtrust@gmail.com
                    ">jagannathanugrahtrust@gmail.com
                    </a>
                </div>
                
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                    <h4>Phone Support</h4>
                    <p>Available 9 AM - 6 PM (Mon-Fri)</p>
                    <a href="tel:+1234567890">9348177375</a>
                </div>
            </div>
            
            <div class="action-buttons">
                <button onclick="location.href='#support-feedback'" class="btn-custom">
                    <i class="fas fa-headset me-2"></i> Contact Support
                </button>
                <button onclick="location.href='feedback.html'" class="btn-secondary">
                    <i class="fas fa-comment-dots me-2"></i> Share Feedback
                </button>
            </div>
            
            <div class="faq-preview">
                <h3 style="text-align: center; margin: 30px 0 20px; color: #333;">Frequently Asked Questions</h3>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How can I track my donation?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        You can track your donation by logging into your account and visiting the "My Donations" section where all your contribution details are available.
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        Are donations tax-deductible?
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        Yes, all donations to Jagannath Anugrah Trust are tax-deductible. You will receive a receipt that can be used for tax purposes.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-column">
                    <div class="footer-logo">
                        <img src="logo-png-removebg-preview.png" alt="Jagannath Anugrah Trust Logo">
                    </div>
                    <p>Empowering communities through sustainable initiatives, education, and support for those in need.</p>
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                
                <div class="footer-column">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="index.html">Home</a></li>
                        <li><a href="about.html">About Us</a></li>
                        <li><a href="projects.html">Our Projects</a></li>
                        <li><a href="gallery.html">Gallery</a></li>
                        <li><a href="donate.html">Donate Now</a></li>
                    </ul>
                </div>
                
                <div class="footer-column">
                    <h4>Get Involved</h4>
                    <ul>
                        <li><a href="volunteer.html">Volunteer</a></li>
                        <li><a href="events.html">Upcoming Events</a></li>
                        <li><a href="fundraising.html">Fundraising</a></li>
                        <li><a href="careers.html">Careers</a></li>
                        <li><a href="partners.html">Partnerships</a></li>
                    </ul>
                </div>
                
                <div class="footer-column">
                    <h4>Contact Us</h4>
                    <div class="contact-info">
                        <p><i class="fas fa-map-marker-alt"></i> 123 Charity Street, New Delhi, India 110001</p>
                        <p><i class="fas fa-phone"></i>9348177375</p>
                        <p><i class="fas fa-envelope"></i> info@jagannathanugrahtrust.com</p>
                    </div>
                    <h4>Newsletter</h4>
                    <form class="newsletter-form">
                        <input type="email" placeholder="Your email address">
                        <button type="submit"><i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2023 Jagannath Anugrah Trust. All Rights Reserved.</p>
            </div>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="userprofile.js"></script>
    
</body>
</html>


