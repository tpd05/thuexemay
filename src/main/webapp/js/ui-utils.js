/* ========================================
   UI UTILITY FUNCTIONS - Modern Modal & Interaction
   Lightweight, vanilla JavaScript
   ======================================== */

/**
 * Global UI utilities object
 */
const UI = {
    /* ===== MODAL MANAGEMENT ===== */
    
    /**
     * Open modal by ID
     * @param {string} modalId - Element ID của modal div
     */
    openModal: function(modalId) {
        const overlay = document.getElementById(modalId);
        if (overlay) {
            overlay.classList.add('open');
            document.body.style.overflow = 'hidden';
        }
    },
    
    /**
     * Close modal by ID
     * @param {string} modalId - Element ID của modal div
     */
    closeModal: function(modalId) {
        const overlay = document.getElementById(modalId);
        if (overlay) {
            overlay.classList.remove('open');
            document.body.style.overflow = 'auto';
        }
    },
    
    /**
     * Close all open modals
     */
    closeAllModals: function() {
        document.querySelectorAll('.modal-overlay.open').forEach(modal => {
            modal.classList.remove('open');
        });
        document.body.style.overflow = 'auto';
    },
    
    /**
     * Setup modal trigger (open on click)
     * @param {string} triggerId - Button/link ID
     * @param {string} modalId - Modal overlay ID
     */
    setupModalTrigger: function(triggerId, modalId) {
        const trigger = document.getElementById(triggerId);
        if (trigger) {
            trigger.addEventListener('click', (e) => {
                e.preventDefault();
                this.openModal(modalId);
            });
        }
    },
    
    /**
     * Setup modal close button & overlay click
     * @param {string} modalId - Modal overlay ID
     */
    setupModalClose: function(modalId) {
        const overlay = document.getElementById(modalId);
        if (overlay) {
            // Close button (X)
            const closeBtn = overlay.querySelector('.modal-close');
            if (closeBtn) {
                closeBtn.addEventListener('click', () => this.closeModal(modalId));
            }
            
            // Overlay background click
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) {
                    this.closeModal(modalId);
                }
            });
            
            // ESC key
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    if (overlay.classList.contains('open')) {
                        this.closeModal(modalId);
                    }
                }
            });
        }
    },
    
    /**
     * Confirm dialog
     * @param {string} title - Dialog title
     * @param {string} message - Dialog message
     * @param {function} onConfirm - Callback khi nhấn Xác nhận
     * @param {function} onCancel - Callback khi hủy (optional)
     */
    confirm: function(title, message, onConfirm, onCancel) {
        const dialogId = 'confirmDialog_' + Date.now();
        const html = `
            <div id="${dialogId}" class="modal-overlay open">
                <div class="modal modal-sm">
                    <div class="modal-header">
                        <h3 class="modal-title">${title}</h3>
                        <button class="modal-close">&times;</button>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary cancel-btn">Hủy</button>
                        <button class="btn btn-primary confirm-btn">Xác nhận</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.insertAdjacentHTML('beforeend', html);
        const dialog = document.getElementById(dialogId);
        
        dialog.querySelector('.confirm-btn').addEventListener('click', () => {
            if (onConfirm) onConfirm();
            dialog.remove();
        });
        
        dialog.querySelector('.cancel-btn').addEventListener('click', () => {
            if (onCancel) onCancel();
            dialog.remove();
        });
        
        dialog.querySelector('.modal-close').addEventListener('click', () => {
            if (onCancel) onCancel();
            dialog.remove();
        });
        
        dialog.addEventListener('click', (e) => {
            if (e.target === dialog) {
                if (onCancel) onCancel();
                dialog.remove();
            }
        });
    },
    
    /* ===== TOAST NOTIFICATIONS ===== */
    
    /**
     * Show temporary toast notification
     * @param {string} message - Message text
     * @param {string} type - 'success', 'error', 'warning', 'info' (default: 'info')
     * @param {number} duration - Duration in ms (default: 3000)
     */
    toast: function(message, type = 'info', duration = 3000) {
        const toastId = 'toast_' + Date.now();
        const icons = {
            success: '✓',
            error: '✕',
            warning: '!',
            info: 'ⓘ'
        };
        
        const html = `
            <div id="${toastId}" class="alert alert-${type}" style="position: fixed; top: var(--spacing-lg); right: var(--spacing-lg); z-index: 2000; width: 300px;">
                <div class="alert-icon">${icons[type] || '•'}</div>
                <div class="alert-content">
                    <p class="alert-message">${message}</p>
                </div>
            </div>
        `;
        
        document.body.insertAdjacentHTML('beforeend', html);
        const toast = document.getElementById(toastId);
        
        setTimeout(() => {
            toast.style.animation = 'fadeOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    },
    
    /* ===== LOADING STATES ===== */
    
    /**
     * Show loading spinner overlay
     * @param {string} message - Loading message (optional)
     */
    showLoading: function(message = 'Đang tải...') {
        const loadingId = 'loading_' + Date.now();
        const html = `
            <div id="${loadingId}" class="modal-overlay open" style="background-color: rgba(0, 0, 0, 0.3);">
                <div style="text-align: center;">
                    <div class="loading loading-lg" style="margin-bottom: 1rem;"></div>
                    <p style="color: white; font-size: 0.9rem;">${message}</p>
                </div>
            </div>
        `;
        
        document.body.insertAdjacentHTML('beforeend', html);
        return loadingId;
    },
    
    /**
     * Hide loading spinner
     * @param {string} loadingId - ID returned from showLoading()
     */
    hideLoading: function(loadingId) {
        const loading = document.getElementById(loadingId);
        if (loading) {
            loading.remove();
        }
    },
    
    /* ===== FORM VALIDATION ===== */
    
    /**
     * Validate form fields
     * @param {string} formId - Form element ID
     * @returns {boolean} True if valid
     */
    validateForm: function(formId) {
        const form = document.getElementById(formId);
        if (!form) return false;
        
        let isValid = true;
        const inputs = form.querySelectorAll('input[required], textarea[required], select[required]');
        
        inputs.forEach(input => {
            const group = input.closest('.form-group');
            const errorMsg = group ? group.querySelector('.form-error') : null;
            
            if (!input.value.trim()) {
                isValid = false;
                if (group) group.classList.add('has-error');
                if (errorMsg) errorMsg.textContent = 'Trường này bắt buộc';
            } else {
                if (group) group.classList.remove('has-error');
                if (errorMsg) errorMsg.textContent = '';
            }
        });
        
        return isValid;
    },
    
    /**
     * Clear form errors
     * @param {string} formId - Form element ID
     */
    clearFormErrors: function(formId) {
        const form = document.getElementById(formId);
        if (form) {
            form.querySelectorAll('.form-group').forEach(group => {
                group.classList.remove('has-error');
                const errorMsg = group.querySelector('.form-error');
                if (errorMsg) errorMsg.textContent = '';
            });
        }
    },
    
    /**
     * Set form field error
     * @param {string} fieldId - Input field ID
     * @param {string} message - Error message
     */
    setFieldError: function(fieldId, message) {
        const field = document.getElementById(fieldId);
        if (field) {
            const group = field.closest('.form-group');
            if (group) {
                group.classList.add('has-error');
                const errorMsg = group.querySelector('.form-error');
                if (errorMsg) errorMsg.textContent = message;
            }
        }
    },
    
    /* ===== DOM UTILITIES ===== */
    
    /**
     * Toggle CSS class
     * @param {string} elementId - Element ID
     * @param {string} className - Class name
     */
    toggleClass: function(elementId, className) {
        const el = document.getElementById(elementId);
        if (el) el.classList.toggle(className);
    },
    
    /**
     * Add CSS class
     * @param {string} elementId - Element ID
     * @param {string} className - Class name
     */
    addClass: function(elementId, className) {
        const el = document.getElementById(elementId);
        if (el) el.classList.add(className);
    },
    
    /**
     * Remove CSS class
     * @param {string} elementId - Element ID
     * @param {string} className - Class name
     */
    removeClass: function(elementId, className) {
        const el = document.getElementById(elementId);
        if (el) el.classList.remove(className);
    },
    
    /**
     * Hide element
     * @param {string} elementId - Element ID
     */
    hide: function(elementId) {
        const el = document.getElementById(elementId);
        if (el) el.classList.add('hidden');
    },
    
    /**
     * Show element
     * @param {string} elementId - Element ID
     */
    show: function(elementId) {
        const el = document.getElementById(elementId);
        if (el) el.classList.remove('hidden');
    },
    
    /**
     * Set text content
     * @param {string} elementId - Element ID
     * @param {string} text - Text content
     */
    setText: function(elementId, text) {
        const el = document.getElementById(elementId);
        if (el) el.textContent = text;
    },
    
    /**
     * Set HTML content
     * @param {string} elementId - Element ID
     * @param {string} html - HTML content
     */
    setHTML: function(elementId, html) {
        const el = document.getElementById(elementId);
        if (el) el.innerHTML = html;
    }
};

// Fade out animation definition (used by toast)
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
`;
document.head.appendChild(style);
