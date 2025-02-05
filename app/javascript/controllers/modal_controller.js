import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Query the modal element inside the controller's element.
    this.modal = this.element.querySelector('.modal')
    if (!this.modal) {
      console.error("No modal element found!")
      return
    }

    // Bind event handlers.
    this.handleOutsideClickBound = this.handleOutsideClick.bind(this)
    this.handleEscapeBound = this.handleEscape.bind(this)
    this.handleTabBound = this.handleTab.bind(this)

    // Listen for clicks on the modal overlay (the modal element).
    this.modal.addEventListener('click', this.handleOutsideClickBound)
    // Listen for keydown events (e.g., Escape key) on the document.
    document.addEventListener('keydown', this.handleEscapeBound)
    document.addEventListener('keydown', this.handleTabBound)
  }

  disconnect() {
    if (this.modal) {
      this.modal.removeEventListener('click', this.handleOutsideClickBound)
    }
    document.removeEventListener('keydown', this.handleEscapeBound)
    document.removeEventListener('keydown', this.handleTabBound)
  }

  open(event) {
    event.preventDefault()
    console.log("I am here")
    if (!this.modal) return

    // Remove the "hidden" class from the modal element.
    this.modal.classList.remove("hidden")

    // Set up focusable elements for accessibility.
    this.setFocusableElements()
    if (this.firstFocusable) {
      this.firstFocusable.focus()
    }
  }

  close(event) {
    event.preventDefault()
    if (!this.modal) return

    // Hide the modal by adding the "hidden" class.
    this.modal.classList.add("hidden")
  }

  handleOutsideClick(event) {
    // If the click happened on the modal overlay (not inside the modal content), close it.
    if (event.target === this.modal) {
      this.close(event)
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.close(event)
    }
  }

  handleTab(event) {
    if (event.key === 'Tab' && this.focusableElements && this.focusableElements.length > 0) {
      if (event.shiftKey) {
        // If Shift+Tab and focus is on the first focusable element, cycle to the last.
        if (document.activeElement === this.firstFocusable) {
          event.preventDefault()
          this.lastFocusable.focus()
        }
      } else {
        // If Tab and focus is on the last focusable element, cycle to the first.
        if (document.activeElement === this.lastFocusable) {
          event.preventDefault()
          this.firstFocusable.focus()
        }
      }
    }
  }

  setFocusableElements() {
    // Query only within the modal.
    this.focusableElements = this.modal.querySelectorAll(
      'a[href], button, textarea, input, select, [tabindex]:not([tabindex="-1"])'
    )
    this.firstFocusable = this.focusableElements[0]
    this.lastFocusable = this.focusableElements[this.focusableElements.length - 1]
  }
}

