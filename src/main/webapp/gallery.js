document.addEventListener('DOMContentLoaded', function() {
    // Gallery image switcher
    const thumbnails = document.querySelectorAll('.thumbnail');
    const mainImage = document.getElementById('mainGalleryImage');
    const caption = document.getElementById('galleryCaption');
    
    thumbnails.forEach(thumbnail => {
        thumbnail.addEventListener('click', function() {
            // Update main image
            mainImage.src = this.getAttribute('data-img');
            caption.textContent = this.getAttribute('data-caption');
            
            // Update active thumbnail
            thumbnails.forEach(thumb => thumb.classList.remove('active'));
            this.classList.add('active');
            
            // Add animation to main image
            mainImage.classList.add('fade');
            setTimeout(() => {
                mainImage.classList.remove('fade');
            }, 500);
        });
    });
    
    // Auto rotate gallery images
    let currentIndex = 0;
    
    function rotateGallery() {
        currentIndex = (currentIndex + 1) % thumbnails.length;
        thumbnails[currentIndex].click();
    }
    
    // Start the rotation with a 5-second interval
    const galleryInterval = setInterval(rotateGallery, 5000);
    
    // Pause rotation when hovering over the gallery
    const gallery = document.querySelector('.about-image-gallery');
    
    gallery.addEventListener('mouseenter', () => {
        clearInterval(galleryInterval);
    });
    
    gallery.addEventListener('mouseleave', () => {
        clearInterval(galleryInterval);
        // Restart the gallery rotation
        currentIndex = currentIndex; // Keep the current image
        rotateGallery(); // This will move to the next image
    });
});