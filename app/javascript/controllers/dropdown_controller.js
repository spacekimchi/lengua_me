import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu'];

  connect() {
    // Hide the menu on first load
    this.hide();
    // Optional: set up a listener to close the dropdown if user clicks outside
    document.addEventListener('click', this.#closeOnClickOutside);
  }

  disconnect() {
    // Clean up the listener
    document.removeEventListener('click', this.#closeOnClickOutside);
  }

  toggle(event) {
    // Prevent the click from bubbling up (so it doesn't trigger #closeOnClickOutside)
    event.stopPropagation();
    this.isOpen ? this.hide() : this.show();
  }

  show() {
    this.menuTarget.classList.remove('hidden');
    this.isOpen = true;
  }

  hide() {
    this.menuTarget.classList.add('hidden');
    this.isOpen = false;
  }

  // Private method to detect clicks outside the dropdown
  #closeOnClickOutside = (event) => {
    // If the click happened inside this controller's element, do nothing
    if (this.element.contains(event.target)) return;
    // Otherwise, hide the menu
    this.hide();
  }
}

