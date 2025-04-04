document.addEventListener('DOMContentLoaded', function() {
    // Get carousel elements
    const carousel = document.querySelector('.carousel');
    const members = document.querySelectorAll('.member');
    
    // Clone members for infinite scrolling
    members.forEach(member => {
        const clone = member.cloneNode(true);
        carousel.appendChild(clone);
    });
    
    // Set initial position
    let position = 0;
    
    // Set scrolling speed - consistent regardless of hover
    const scrollSpeed = 1.5; // pixels per frame (higher = faster)
    
    // Continuous scrolling function
    function scrollCarousel() {
        position -= scrollSpeed;
        
        // Check if we need to reset position (when first set of members is scrolled past)
        const carouselWidth = members.length * (members[0].offsetWidth + 30); // Width + gap
        
        if (Math.abs(position) >= carouselWidth) {
            position = 0;
        }
        
        carousel.style.transform = `translateX(${position}px)`;
        requestAnimationFrame(scrollCarousel);
    }
    
    // Start scrolling - no hover effect
    let scrollCarouselId = requestAnimationFrame(scrollCarousel);
    
    // Update carousel width to accommodate all items
    function updateCarouselWidth() {
        const totalWidth = members.length * 2 * (members[0].offsetWidth + 30); // Double width for clones
        carousel.style.width = `${totalWidth}px`;
    }
    
    // Update on load and resize
    updateCarouselWidth();
    window.addEventListener('resize', updateCarouselWidth);
});