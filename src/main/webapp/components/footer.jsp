<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer" style="background: linear-gradient(135deg, var(--color-primary) 0%, #059669 100%); color: white; padding: var(--spacing-2xl) var(--spacing-md); margin-top: auto;">
    <div class="app-container">
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
            
            <!-- Copyright Section -->
            <div style="flex: 1; min-width: 250px;">
                <p style="margin: 0; color: rgba(255,255,255,0.95); font-size: var(--text-sm); font-weight: 600;">
                    © 2026 <strong>ThueXeMay</strong>. All rights reserved.
                </p>
                <p style="margin: var(--spacing-xs) 0 0 0; color: rgba(255,255,255,0.7); font-size: 0.75rem;">
                    Your trusted bike rental partner
                </p>
            </div>

            <!-- Footer Links -->
            <div style="display: flex; gap: var(--spacing-lg); flex-wrap: wrap; justify-content: center; flex: 1;">
                <a href="#" 
                   style="color: rgba(255,255,255,0.85); text-decoration: none; font-size: var(--text-sm); transition: all var(--transition-normal);"
                   onmouseover="this.style.color='white'; this.style.textDecoration='underline';"
                   onmouseout="this.style.color='rgba(255,255,255,0.85)'; this.style.textDecoration='none';">
                    About
                </a>
                <a href="#" 
                   style="color: rgba(255,255,255,0.85); text-decoration: none; font-size: var(--text-sm); transition: all var(--transition-normal);"
                   onmouseover="this.style.color='white'; this.style.textDecoration='underline';"
                   onmouseout="this.style.color='rgba(255,255,255,0.85)'; this.style.textDecoration='none';">
                    Contact
                </a>
                <a href="#" 
                   style="color: rgba(255,255,255,0.85); text-decoration: none; font-size: var(--text-sm); transition: all var(--transition-normal);"
                   onmouseover="this.style.color='white'; this.style.textDecoration='underline';"
                   onmouseout="this.style.color='rgba(255,255,255,0.85)'; this.style.textDecoration='none';">
                    Privacy
                </a>
                <a href="#" 
                   style="color: rgba(255,255,255,0.85); text-decoration: none; font-size: var(--text-sm); transition: all var(--transition-normal);"
                   onmouseover="this.style.color='white'; this.style.textDecoration='underline';"
                   onmouseout="this.style.color='rgba(255,255,255,0.85)'; this.style.textDecoration='none';">
                    Terms
                </a>
            </div>

            <!-- Social Links -->
            <div style="display: flex; gap: var(--spacing-md); align-items: center; justify-content: flex-end;">
                <a href="https://facebook.com" 
                   target="_blank"
                   rel="noopener noreferrer"
                   class="social-link"
                   style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: var(--radius-full); background-color: rgba(255,255,255,0.15); color: white; text-decoration: none; transition: all var(--transition-normal);"
                   onmouseover="this.style.backgroundColor='rgba(255,255,255,0.3)'; this.style.transform='translateY(-3px)';"
                   onmouseout="this.style.backgroundColor='rgba(255,255,255,0.15)'; this.style.transform='translateY(0)';">
                    <iconify-icon icon="mdi:facebook" style="width: 20px; height: 20px;"></iconify-icon>
                </a>
                
                <a href="https://twitter.com" 
                   target="_blank"
                   rel="noopener noreferrer"
                   class="social-link"
                   style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: var(--radius-full); background-color: rgba(255,255,255,0.15); color: white; text-decoration: none; transition: all var(--transition-normal);"
                   onmouseover="this.style.backgroundColor='rgba(255,255,255,0.3)'; this.style.transform='translateY(-3px)';"
                   onmouseout="this.style.backgroundColor='rgba(255,255,255,0.15)'; this.style.transform='translateY(0)';">
                    <iconify-icon icon="mdi:twitter" style="width: 20px; height: 20px;"></iconify-icon>
                </a>
                
                <a href="https://instagram.com" 
                   target="_blank"
                   rel="noopener noreferrer"
                   class="social-link"
                   style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: var(--radius-full); background-color: rgba(255,255,255,0.15); color: white; text-decoration: none; transition: all var(--transition-normal);"
                   onmouseover="this.style.backgroundColor='rgba(255,255,255,0.3)'; this.style.transform='translateY(-3px)';"
                   onmouseout="this.style.backgroundColor='rgba(255,255,255,0.15)'; this.style.transform='translateY(0)';">
                    <iconify-icon icon="mdi:instagram" style="width: 20px; height: 20px;"></iconify-icon>
                </a>
            </div>
        </div>

        <!-- Divider -->
        <div style="border-top: 1px solid rgba(255,255,255,0.2); margin: var(--spacing-md) 0;"></div>

        <!-- Bottom Footer -->
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: var(--spacing-md); font-size: var(--text-xs); color: rgba(255,255,255,0.7);">
            <p style="margin: 0;">Made with <iconify-icon icon="mdi:heart" style="width: 16px; height: 16px; color: #ff69b4; vertical-align: middle;"></iconify-icon> in Vietnam</p>
            <p style="margin: 0;">Last updated: <span id="lastUpdate"></span></p>
        </div>
    </div>
</footer>

<!-- Footer Year Auto-Update Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const year = new Date().getFullYear();
    const footerText = document.querySelector('footer p:nth-child(1)');
    if (footerText) {
        footerText.textContent = '© ' + year + ' ThueXeMay. All rights reserved.';
    }
});
</script>
