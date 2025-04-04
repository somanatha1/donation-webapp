document.addEventListener('DOMContentLoaded', function() {
    // Simple tab switching functionality
    document.querySelectorAll('.payment-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            // Remove active class from all tabs
            document.querySelectorAll('.payment-tab').forEach(t => {
                t.classList.remove('active');
            });
            
            // Add active class to clicked tab
            tab.classList.add('active');
            
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            
            // Show the corresponding tab content
            const tabId = tab.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
        });
    });
    
    // Donation amount selection
    document.querySelectorAll('.donation-option').forEach(option => {
        option.addEventListener('click', () => {
            // Remove active class from all options
            document.querySelectorAll('.donation-option').forEach(o => {
                o.classList.remove('active');
            });
            
            // Add active class to clicked option
            option.classList.add('active');
            
            // Update the amount input if it's not "Custom"
            if (option.textContent !== 'Custom') {
                const amount = option.textContent.replace('₹', '');
                document.querySelectorAll('#amount, #upi-amount, #card-amount').forEach(input => {
                    input.value = amount;
                });
            }
        });
    });
});