import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleOutsideClickBound = this.handleOutsideClick.bind(this)
    this.handleEscapeBound = this.handleEscape.bind(this)
    this.handleTabBound = this.handleTab.bind(this)

    // Listen for clicks on the modal overlay
    this.element.addEventListener('click', this.handleOutsideClickBound)
    // Listen for keydown events (e.g., Escape key)
    document.addEventListener('keydown', this.handleEscapeBound)
    document.addEventListener('keydown', this.handleTabBound)

    // Focus management for accessibility
    this.focusableElements = this.element.querySelectorAll(
      'a[href], button, textarea, input, select, [tabindex]:not([tabindex="-1"])'
    )
    this.firstFocusable = this.focusableElements[0]
    this.lastFocusable = this.focusableElements[this.focusableElements.length - 1]

    if (this.firstFocusable) {
      this.firstFocusable.focus()
    }
  }

  disconnect() {
    this.element.removeEventListener('click', this.handleOutsideClickBound)
    document.removeEventListener('keydown', this.handleEscapeBound)
    document.removeEventListener('keydown', this.handleTabBound)
  }

  close(event) {
    event.preventDefault()
    // Remove only the modal overlay (this.element), leaving the turbo frame intact
    this.element.remove()
  }

  handleOutsideClick(event) {
    // If user clicked directly on the overlay (not the modal content), close the modal
    if (event.target === this.element) {
      this.close(event)
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.close(event)
    }
  }

  handleTab(event) {
    if (event.key === 'Tab' && this.focusableElements.length > 0) {
      if (event.shiftKey) {
        // Shift + Tab
        if (document.activeElement === this.firstFocusable) {
          event.preventDefault()
          this.lastFocusable.focus()
        }
      } else {
        // Tab
        if (document.activeElement === this.lastFocusable) {
          event.preventDefault()
          this.firstFocusable.focus()
        }
      }
    }
  }
}

