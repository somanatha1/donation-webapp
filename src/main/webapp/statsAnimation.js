document.addEventListener('DOMContentLoaded', function() {
    // Animate stats when visible
    const statSection = document.querySelector('.about-stats-container');
    const statNumbers = document.querySelectorAll('.stat-number');
    
    let animated = false;
    
    function animateStats() {
        if (animated) return;
        
        const observer = new IntersectionObserver((entries) => {
            if (entries[0].isIntersecting) {
                statNumbers.forEach(stat => {
                    const target = parseInt(stat.getAttribute('data-count'));
                    let current = 0;
                    const increment = target / 60; // Animate over ~1 second at 60fps
                    
                    const timer = setInterval(() => {
                        current += increment;
                        stat.textContent = Math.floor(current);
                        
                        if (current >= target) {
                            stat.textContent = target;
                            clearInterval(timer);
                        }
                    }, 16);
                });
                
                animated = true;
                observer.disconnect();
            }
        });
        
        observer.observe(statSection);
    }
    
    // Start animations when page loads
    animateStats();
});