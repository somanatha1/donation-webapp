document.addEventListener('DOMContentLoaded', function() {
    // Toggle sidebar
    const menuToggle = document.querySelector('.menu-toggle');
    const sidebarClose = document.querySelector('.sidebar-close');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (menuToggle) {
        menuToggle.addEventListener('click', function() {
            sidebar.classList.add('active');
            overlay.classList.add('active');
            document.body.classList.add('sidebar-open');
        });
    }
    
    if (sidebarClose) {
        sidebarClose.addEventListener('click', function() {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            document.body.classList.remove('sidebar-open');
        });
    }
    
    if (overlay) {
        overlay.addEventListener('click', function() {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            document.body.classList.remove('sidebar-open');
        });
    }
    
    // Expand/collapse submenu items
    const menuItems = document.querySelectorAll('.menu > li > a');
    
    menuItems.forEach(item => {
        if (item.nextElementSibling && item.nextElementSibling.classList.contains('submenu')) {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const submenu = this.nextElementSibling;
                
                // Toggle submenu visibility
                if (submenu.style.maxHeight) {
                    submenu.style.maxHeight = null;
                    this.classList.remove('expanded');
                } else {
                    submenu.style.maxHeight = submenu.scrollHeight + "px";
                    this.classList.add('expanded');
                }
            });
        }
    });
});