document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Only process internal links
            if (this.getAttribute('href').startsWith('#')) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                if (targetElement) {
                    // Close sidebar if open
                    const sidebar = document.querySelector('.sidebar');
                    const overlay = document.querySelector('.sidebar-overlay');
                    
                    if (sidebar.classList.contains('active')) {
                        sidebar.classList.remove('active');
                        overlay.classList.remove('active');
                        document.body.classList.remove('sidebar-open');
                    }
                    
                    // Scroll to target
                    window.scrollTo({
                        top: targetElement.offsetTop - 70, // Adjust for header
                        behavior: 'smooth'
                    });
                }
            }
        });
    });
});