document.addEventListener('DOMContentLoaded', function() {
    const projectsGrid = document.querySelector('.projects-grid');
    const filterContainer = document.querySelector('.projects-filter');
    const viewMoreBtn = document.querySelector('.view-more-btn');
    
    // Function to ensure a filter button exists for a category
    function ensureFilterExists(category) {
        // Check if we already have this filter
        const filterValue = category.toLowerCase();
        const displayName = category.charAt(0).toUpperCase() + category.slice(1);
        const existingFilter = document.querySelector(`.filter-btn[data-filter="${filterValue}"]`);
        
        if (!existingFilter) {
            // Create new filter button
            const newButton = document.createElement('button');
            newButton.className = 'filter-btn';
            newButton.setAttribute('data-filter', filterValue);
            newButton.textContent = displayName;
            
            // Add click event to the new button
            newButton.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(btn => 
                    btn.classList.remove('active')
                );
                
                // Add active class to this button
                this.classList.add('active');
                
                // Apply filter
                applyFilter(filterValue);
            });
            
            // Add to filter container
            filterContainer.appendChild(newButton);
            return newButton;
        }
        
        return existingFilter;
    }
    
    // Function to apply filters
    function applyFilter(filterValue) {
        // Get all project cards
        const projectCards = document.querySelectorAll('.project-card');
        
        // Show/hide project cards based on filter
        let visibleCount = 0;
        
        projectCards.forEach(card => {
            if (filterValue === 'all') {
                card.style.display = 'block';
                visibleCount++;
            } else {
                if (card.getAttribute('data-category') === filterValue) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            }
        });
        
        // Check if no projects match the filter
        const existingEmptyState = document.querySelector('.empty-state');
        
        // Remove existing empty state if it exists
        if (existingEmptyState) {
            existingEmptyState.remove();
        }
        
        // Add empty state if no projects match
        if (visibleCount === 0) {
            const emptyState = document.createElement('div');
            emptyState.className = 'empty-state';
            emptyState.innerHTML = `
                <i class="fas fa-search"></i>
                <h3>No projects found</h3>
                <p>There are currently no projects in this category. Please check back later or explore other categories.</p>
            `;
            projectsGrid.appendChild(emptyState);
        }
    }
    
    // Scan for all unique categories in existing project cards and create filters
    function setupInitialFilters() {
        const projectCards = document.querySelectorAll('.project-card');
        const categories = new Set();
        
        // Add 'all' category first if it doesn't exist yet
        categories.add('all');
        
        // Collect all unique categories from project cards
        projectCards.forEach(card => {
            const category = card.getAttribute('data-category');
            if (category) {
                categories.add(category);
            }
        });
        
        // Create filter buttons for each unique category
        categories.forEach(category => {
            ensureFilterExists(category);
        });
    }
    
    // Call this function on page load to create initial filters
    setupInitialFilters();
    
    // Add click event to all filter buttons (both existing and newly created)
    function setupFilterButtonEvents() {
        const filterButtons = document.querySelectorAll('.filter-btn');
        filterButtons.forEach(button => {
            // Remove existing event listeners to prevent duplicates
            const newButton = button.cloneNode(true);
            button.parentNode.replaceChild(newButton, button);
            
            newButton.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(btn => 
                    btn.classList.remove('active')
                );
                
                // Add active class to clicked button
                this.classList.add('active');
                
                // Get filter value and apply filter
                const filterValue = this.getAttribute('data-filter');
                applyFilter(filterValue);
            });
        });
    }
    
    setupFilterButtonEvents();
    
    // Initialize - ensure "All" filter is active by default
    const allFilter = document.querySelector('.filter-btn[data-filter="all"]');
    if (allFilter) {
        allFilter.classList.add('active');
        applyFilter('all');
    }
    
    // Modify the View More button to work with hidden projects
    // instead of dynamically creating new ones
    if (viewMoreBtn) {
        // Create a flag to track if more projects are shown
        let showingMore = false;
        
        viewMoreBtn.addEventListener('click', function() {
            const hiddenProjects = document.querySelectorAll('.project-card.hidden');
            
            if (!showingMore && hiddenProjects.length > 0) {
                // Show hidden projects
                hiddenProjects.forEach(project => {
                    project.classList.remove('hidden');
                });
                this.innerHTML = 'Show Less <i class="fas fa-arrow-up"></i>';
                showingMore = true;
            } else if (showingMore) {
                // Hide projects again
                const allProjects = document.querySelectorAll('.project-card');
                // Keep the first 4 visible, hide the rest
                allProjects.forEach((project, index) => {
                    if (index >= 4) {
                        project.classList.add('hidden');
                    }
                });
                this.innerHTML = 'View More Projects <i class="fas fa-arrow-right"></i>';
                showingMore = false;
            }
            
            // Reapply current filter
            const activeFilter = document.querySelector('.filter-btn.active');
            if (activeFilter) {
                applyFilter(activeFilter.getAttribute('data-filter'));
            }
        });
    }
    
    // Monitor DOM changes to detect new project cards added manually
    // This will create filter buttons for any new categories
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                let needsUpdate = false;
                
                mutation.addedNodes.forEach(function(node) {
                    // Check if the added node is a project card or contains project cards
                    if (node.classList && node.classList.contains('project-card')) {
                        needsUpdate = true;
                    } else if (node.querySelectorAll) {
                        const cards = node.querySelectorAll('.project-card');
                        if (cards.length > 0) {
                            needsUpdate = true;
                        }
                    }
                });
                
                if (needsUpdate) {
                    setupInitialFilters();
                    setupFilterButtonEvents();
                }
            }
        });
    });
    
    // Start observing the projects grid for changes
    observer.observe(projectsGrid, { childList: true, subtree: true });
});