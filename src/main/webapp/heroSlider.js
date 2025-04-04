// Hero Slider
const heroSlides = document.querySelectorAll('.hero-slide');
const totalHeroSlides = heroSlides.length;

heroSlides.forEach((slide, index) => {
    slide.style.setProperty('--total-slides', totalHeroSlides);
    slide.style.animationDelay = `${index * 3}s`; // Delay each slide by 3s
});