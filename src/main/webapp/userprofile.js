// Toggle sidebar function
function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('active');
    document.getElementById('sidebar-overlay').classList.toggle('active');
}

// Close sidebar when clicking overlay
const sidebarOverlay = document.getElementById('sidebar-overlay');
if (sidebarOverlay) {
    sidebarOverlay.addEventListener('click', function() {
        document.getElementById('sidebar').classList.remove('active');
        this.classList.remove('active');
    });
}

// Function to get URL parameters - moved to global scope
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    const results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

// Function to refresh image with timestamp to prevent caching
function refreshImage(imgElement) {
    if (imgElement) {
        const src = imgElement.src.split('?')[0];
        imgElement.src = src + '?t=' + new Date().getTime();
    }
}

// Function to handle profile picture upload
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('profileImageInput');
    const uploadForm = document.getElementById('uploadForm');
    const profileImageContainer = document.querySelector('.profile-image');
    const notification = document.getElementById('uploadNotification');

    const urlParams = new URLSearchParams(window.location.search);
    if (notification) {
        if (urlParams.has('success')) {
            notification.textContent = "Profile picture updated successfully!";
            notification.style.display = "block";
            notification.style.backgroundColor = "#d4edda";
            setTimeout(() => { notification.style.display = "none"; }, 3000);
        } else if (urlParams.has('error')) {
            const error = urlParams.get('error');
            let message = "An error occurred.";
            if (error === 'nofile') message = "No file was selected.";
            if (error === 'dberror') message = "Database error occurred.";

            notification.textContent = message;
            notification.style.display = "block";
            notification.style.backgroundColor = "#f8d7da";
            setTimeout(() => { notification.style.display = "none"; }, 3000);
        }
    }

    if (profileImageContainer && fileInput && uploadForm) {
        profileImageContainer.addEventListener('click', function() {
            fileInput.click();
        });
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                if (notification) {
                    notification.textContent = "Uploading...";
                    notification.style.display = "block";
                    notification.style.backgroundColor = "#cce5ff";
                }
                uploadForm.submit();
            }
        });
    }

    // Fetch user data from session and update UI - fixed to use JSON response
    fetch("UserProfileServlet")
        .then(response => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.json();
        })
        .then(data => {
            const fullname = data.fullname || "User";
            const memberSince = data.memberSince || "Unknown";

            const usernameEl = document.getElementById("username");
            if (usernameEl) usernameEl.textContent = fullname;

            const profileUsernameEl = document.getElementById("profileUsername");
            if (profileUsernameEl) profileUsernameEl.textContent = fullname;

            const memberSinceEl = document.getElementById("memberSince");
            if (memberSinceEl) memberSinceEl.textContent = `Member since ${memberSince}`;

            const profileImg = document.querySelector(".profile-image img");
            if (profileImg) {
                profileImg.src = data.profileImage || "default-profile.png";
            }
        })
        .catch(error => console.error("Error fetching user data:", error));
});

// Helper function to extract session attributes from HTML response
function getSessionAttribute(htmlText, attributeName) {
    const regex = new RegExp(`<%= session.getAttribute\\("${attributeName}"\\) %>`, 'g');
    const match = htmlText.match(regex);
    return match ? match[0].replace(/<%=|%>/g, '').trim() : null;
}

// Function to animate counting up for statistics
function animateStatCounters() {
    const statValues = document.querySelectorAll('.stat-value');
    
    statValues.forEach(el => {
        // Get target value from data attribute
        const target = parseInt(el.getAttribute('data-value'));
        const duration = 2000; // ms
        const startTime = Date.now();
        const startValue = 0;
        
        // Animate the counter
        const updateCounter = () => {
            const currentTime = Date.now();
            const elapsed = currentTime - startTime;
            
            if (elapsed < duration) {
                // Calculate current value based on easeOutQuad function
                const progress = elapsed / duration;
                const easedProgress = 1 - (1 - progress) * (1 - progress);
                const currentValue = Math.floor(startValue + (target - startValue) * easedProgress);
                
                // Update the element's text
                el.textContent = currentValue.toLocaleString();
                
                // Continue animation
                requestAnimationFrame(updateCounter);
            } else {
                // Ensure final value is exactly the target
                el.textContent = target.toLocaleString();
            }
        };
        
        // Start the animation when the element is in viewport
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    updateCounter();
                    observer.disconnect();
                }
            });
        }, { threshold: 0.1 });
        
        observer.observe(el);
    });
}

// Function to animate stats with easing function
function initAnimatedStats() {
    const statNumbers = document.querySelectorAll('.stat-number');
    
    statNumbers.forEach(counter => {
        const targetValue = parseInt(counter.getAttribute('data-value') || "0");
        const duration = 2500; // ms
        let startTime = null;
        
        function animation(currentTime) {
            if (!startTime) startTime = currentTime;
            const timeElapsed = currentTime - startTime;
            const progress = Math.min(timeElapsed / duration, 1);
            const easing = 1 - Math.pow(1 - progress, 4); // easeOutQuart
            
            const currentValue = Math.floor(targetValue * easing);
            counter.textContent = currentValue.toLocaleString();
            
            if (progress < 1) {
                requestAnimationFrame(animation);
            } else {
                counter.textContent = targetValue.toLocaleString();
            }
        }
        
        // Start the animation when the element is in viewport
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    requestAnimationFrame(animation);
                    observer.disconnect();
                }
            });
        }, { threshold: 0.1 });
        
        observer.observe(counter);
    });
}

// Parallax effect for hero background
function initParallaxEffect() {
    const heroBackground = document.querySelector('.hero-background');
    
    if (heroBackground) {
        window.addEventListener('scroll', function() {
            let scrollPosition = window.pageYOffset;
            
            // Only apply parallax if element is in view
            if (scrollPosition < window.innerHeight) {
                // Move background slightly slower than scroll for parallax effect
                heroBackground.style.transform = `scale(1.1) translateY(${scrollPosition * 0.4}px)`;
            }
        });
    }
}

// Smooth scroll functionality for the scroll indicator
function initSmoothScroll() {
    const scrollIndicator = document.querySelector('.scroll-indicator');
    
    if (scrollIndicator) {
        scrollIndicator.addEventListener('click', function() {
            // Scroll to the section after hero (first section following the hero)
            const heroContainer = document.querySelector('.hero-container');
            if (heroContainer) {
                const heroHeight = heroContainer.offsetHeight;
                
                window.scrollTo({
                    top: heroHeight,
                    behavior: 'smooth'
                });
            }
        });
    }
    
    // Smooth scrolling for all anchor links (both in sidebar and main content)
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const targetId = this.getAttribute('href').substring(1);
            
            // Only prevent default and apply smooth scroll if target exists on this page
            const targetSection = document.getElementById(targetId);
            if (targetSection) {
                e.preventDefault();
                
                // Add offset for fixed navbar (50px height + some padding)
                const navbarHeight = 60;
                const targetPosition = targetSection.getBoundingClientRect().top + window.pageYOffset - navbarHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });

                // Close the sidebar if it's open
                const sidebar = document.getElementById('sidebar');
                const sidebarOverlay = document.getElementById('sidebar-overlay');
                if (sidebar) sidebar.classList.remove('active');
                if (sidebarOverlay) sidebarOverlay.classList.remove('active');
            }
        });
    });
}

// Enhanced interactive elements on hover
function initInteractiveElements() {
    // Add hover effects to CTA buttons
    const ctaButtons = document.querySelectorAll('.cta-button');
    
    ctaButtons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
}

// Function to completely rebuild social icons in sidebar
function fixSocialIconsAlignment() {
    // Get the sidebar footer social links container
    const sidebarSocialLinks = document.querySelector('.sidebar-footer .social-links');
    
    if (sidebarSocialLinks) {
        // Clear existing content first
        sidebarSocialLinks.innerHTML = '';
        
        // Recreate all social links
        const socialPlatforms = [
            { icon: 'facebook-f', url: '#' },
            { icon: 'twitter', url: '#' },
            { icon: 'instagram', url: '#' },
            { icon: 'linkedin-in', url: '#' }
        ];
        
        // Add each social link
        socialPlatforms.forEach(platform => {
            const link = document.createElement('a');
            link.href = platform.url;
            link.className = 'social-link';
            link.innerHTML = `<i class="fab fa-${platform.icon}"></i>`;
            sidebarSocialLinks.appendChild(link);
        });
        
        // Apply styling to container
        sidebarSocialLinks.style.display = 'inline-flex';
        sidebarSocialLinks.style.justifyContent = 'center';
        sidebarSocialLinks.style.width = '200px';
        sidebarSocialLinks.style.padding = '0 20px';
        sidebarSocialLinks.style.margin = '15px auto';
        
        // Style each link
        const socialLinks = sidebarSocialLinks.querySelectorAll('.social-link');
        socialLinks.forEach(link => {
            link.style.width = '30px';
            link.style.height = '30px';
            link.style.margin = '0 5px';
            link.style.borderRadius = '50%';
            link.style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
            link.style.display = 'flex';
            link.style.alignItems = 'center';
            link.style.justifyContent = 'center';
            link.style.flex = '0 0 30px';
            link.style.transition = 'all 0.3s ease';
        });
    }
}

// Set default profile picture if none exists
function setDefaultProfilePicture() {
    const profileImages = document.querySelectorAll('.profile-image img');
    
    profileImages.forEach(img => {
        // Set default image if current one fails to load
        img.onerror = function() {
            this.src = 'jagapng-modified.png'; // First try the logo
            
            // If logo also fails, use a reliable fallback
            this.onerror = function() {
                this.src = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgZmlsbD0iY3VycmVudENvbG9yIiBjbGFzcz0iYmkgYmktcGVyc29uLWNpcmNsZSIgdmlld0JveD0iMCAwIDE2IDE2Ij48cGF0aCBkPSJNMTEgNmEzIDMgMCAxIDEtNiAwIDMgMyAwIDAgMSA2IDB6Ii8+PHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBkPSJNMCA4YTggOCAwIDEgMSAxNiAwQTggOCAwIDAgMSAwIDh6bTgtN2E3IDcgMCAwIDAtNS40NjggMTEuMzdDMy4yNDIgMTEuMjI2IDQuODA1IDEwIDggMTBzNC43NTcgMS4yMjUgNS40NjggMi4zN0E3IDcgMCAwIDAgOCAxeiIvPjwvc3ZnPg==';
                this.onerror = null; // Prevent infinite loop
            };
        };
        
        // Force error check for already loaded images with invalid source
        if (img.complete && (img.naturalWidth === 0 || img.naturalHeight === 0)) {
            img.src = 'jagapng-modified.png';
        }
    });
}

// Function to handle profile picture upload
function setupProfilePictureUpload() {
    let fileInput = document.getElementById('hiddenProfileFileInput');
    // Create file input if it doesn't exist
    if (!fileInput) {
        fileInput = document.createElement('input');
        fileInput.id = 'hiddenProfileFileInput';
        fileInput.type = 'file';
        fileInput.accept = 'image/*';
        fileInput.style.display = 'none';
        fileInput.name = 'profileImage'; // Important: set name for servlet
        document.body.appendChild(fileInput);
    }

    // Create upload form if it doesn't exist
    let uploadForm = document.getElementById('hiddenUploadForm');
    if (!uploadForm) {
        uploadForm = document.createElement('form');
        uploadForm.id = 'hiddenUploadForm';
        uploadForm.action = 'UploadProfileImageServlet';
        uploadForm.method = 'post';
        uploadForm.enctype = 'multipart/form-data';
        uploadForm.style.display = 'none';
        document.body.appendChild(uploadForm);
        
        // Move file input to form
        if (fileInput.parentNode) {
            fileInput.parentNode.removeChild(fileInput);
        }
        uploadForm.appendChild(fileInput);
    }

    const profileImageContainer = document.querySelector('.profile-image');
    if (profileImageContainer) {
        // Add edit overlay if it doesn't exist
        if (!profileImageContainer.querySelector('.edit-overlay')) {
            const editOverlay = document.createElement('div');
            editOverlay.className = 'edit-overlay';
            editOverlay.innerHTML = '<i class="fas fa-camera"></i>';
            profileImageContainer.appendChild(editOverlay);
        }

        // Click handler for profile image container
        profileImageContainer.addEventListener('click', function() {
            fileInput.click();
        });

        // Change handler for file input
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                // Show upload notification
                const notification = document.getElementById('uploadNotification');
                if (notification) {
                    notification.textContent = "Uploading...";
                    notification.style.display = "block";
                    notification.style.backgroundColor = "#cce5ff";
                }

                // Preview image
                const reader = new FileReader();
                reader.onload = function(e) {
                    const profileImgs = document.querySelectorAll('.profile-image img');
                    profileImgs.forEach(img => {
                        img.src = e.target.result;
                    });
                };
                reader.readAsDataURL(this.files[0]);

                // Submit the form instead of using fetch
                uploadForm.submit();
            }
        });
    }
}

// Initialize donation tabs
function initDonationTabs() {
    const tabs = document.querySelectorAll('.payment-tab');
    const tabContents = document.querySelectorAll('.tab-content');
    
    if (tabs.length > 0 && tabContents.length > 0) {
        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                // Remove active class from all tabs
                tabs.forEach(t => t.classList.remove('active'));
                
                // Add active class to clicked tab
                this.classList.add('active');
                
                // Hide all tab contents
                tabContents.forEach(content => content.classList.remove('active'));
                
                // Show the corresponding tab content
                const tabId = this.getAttribute('data-tab');
                const tabContent = document.getElementById(tabId);
                if (tabContent) {
                    tabContent.classList.add('active');
                }
            });
        });
        
        // Handle donation options
        const donationOptions = document.querySelectorAll('.donation-option');
        const amountInput = document.getElementById('amount');
        
        if (donationOptions.length > 0 && amountInput) {
            donationOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove active class from all options
                    donationOptions.forEach(o => o.classList.remove('active'));
                    
                    // Add active class to clicked option
                    this.classList.add('active');
                    
                    // Update amount input
                    const value = this.textContent;
                    if (value === 'Custom') {
                        amountInput.value = '';
                        amountInput.focus();
                    } else {
                        amountInput.value = value.replace('₹', '');
                    }
                });
            });
        }
    }
}

// Function to handle session data
function loadUserSessionData() {
    // Fetch user data from session
    fetch('GetUserSessionData')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Update welcome message
            const welcomeMessageElement = document.querySelector('.welcome-message');
            if (welcomeMessageElement) {
                welcomeMessageElement.innerHTML = `
                    <img src="logo-png-removebg-preview.png" alt="Logo">
                    Welcome, ${data.fullname || 'User'} 🙏😊
                `;
            }
            
            // Update user profile section
            const profileNameElement = document.querySelector('.profile-info h4');
            if (profileNameElement) {
                profileNameElement.textContent = data.fullname || 'User';
            }
            
            const memberSinceElement = document.querySelector('.profile-info p');
            if (memberSinceElement) {
                memberSinceElement.textContent = `Member since ${data.memberSince || 'Unknown'}`;
            }
            
            // Update all username elements
            const usernameElements = document.querySelectorAll('.username');
            usernameElements.forEach(el => {
                el.textContent = data.fullname || 'User';
            });
            
            // Update all memberSince elements
            const memberSinceElements = document.querySelectorAll('.member-since');
            memberSinceElements.forEach(el => {
                el.textContent = data.memberSince || 'Unknown';
            });
        })
		.catch(error => {
		    console.error('Error fetching user data:', error);

		    // Fallback for fullname
		    const fullnameMeta = document.querySelector('meta[name="user-fullname"]');
		    const fullname = fullnameMeta ? fullnameMeta.content : 'User';

		    // Fallback for memberSince
		    const memberSinceMeta = document.querySelector('meta[name="user-member-since"]');
		    const memberSince = memberSinceMeta ? memberSinceMeta.content : 'Unknown';

		    // Update elements with fallback data
		    document.querySelectorAll('.username').forEach(el => {
		        el.textContent = fullname;
		    });
		    document.querySelectorAll('.member-since').forEach(el => {
		        el.textContent = memberSince;
		    });
		});
}

// Initialize hero section animations
function initHeroAnimations() {
    // Add animation classes to elements
    const heroContentWrapper = document.querySelector('.hero-content-wrapper');
    if (heroContentWrapper) {
        const heroElements = heroContentWrapper.querySelectorAll(':scope > *');
        heroElements.forEach((element, index) => {
            // Add staggered fade-in animation
            element.style.opacity = '0';
            element.style.transform = 'translateY(20px)';
            element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, 200 * index);
        });
    }
}

// Initialize carousel if it exists
function initCarousel() {
    const imageSlider = document.getElementById('imageSlider');
    if (imageSlider && typeof bootstrap !== 'undefined' && bootstrap.Carousel) {
        const carousel = new bootstrap.Carousel(imageSlider, {
            interval: 3000,
            wrap: true,
            pause: 'hover'
        });
    }
}

// Document ready handler - main initialization function
document.addEventListener('DOMContentLoaded', function() {
    // Initialize user data
    loadUserSessionData();
    
    // Initialize animations and interactive elements
    initAnimatedStats();
    initParallaxEffect();
    initSmoothScroll();
    initInteractiveElements();
    
    // Initialize donation tabs if they exist
    initDonationTabs();
    
    // Initialize carousel
    initCarousel();
    
    // Create notification element if it doesn't exist
    if (!document.getElementById('uploadNotification')) {
        const notification = document.createElement('div');
        notification.id = 'uploadNotification';
        notification.style.display = 'none';
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.padding = '10px 20px';
        notification.style.borderRadius = '5px';
        notification.style.zIndex = '9999';
        document.body.appendChild(notification);
    }
    
    // Wait a short time to ensure all resources are loaded
    setTimeout(function() {
        // Set default profile picture
        setDefaultProfilePicture();
        
        // Setup profile picture upload
        setupProfilePictureUpload();
        
        // Fix social icons alignment
        fixSocialIconsAlignment();
    }, 100);
});

// Window load event for animations and final adjustments
window.addEventListener('load', function() {
    // Initialize hero animations
    initHeroAnimations();
    
    // Re-run animations to ensure they trigger properly
    animateStatCounters();
    initAnimatedStats();
});

