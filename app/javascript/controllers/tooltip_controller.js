import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["arrow", "content"];

  initialize() {
    // Bind event handlers once and store the references
    this.boundHandleDocumentClick = this.handleDocumentClick.bind(this);
    this.boundHandleWindowChange = this.handleWindowChange.bind(this);
  }

  connect() {
    console.log("Tooltip controller connected");

    this.hide();
    this.currentParent = null;

    // Attach event listeners using the stored bound functions
    window.addEventListener('resize', this.boundHandleWindowChange);
    window.addEventListener('scroll', this.boundHandleWindowChange, { passive: true });
  }

  disconnect() {
    console.log("Tooltip controller disconnected");

    // Ensure tooltip is hidden
    this.hide();

    // Remove event listeners using the stored bound functions
    window.removeEventListener('resize', this.boundHandleWindowChange);
    window.removeEventListener('scroll', this.boundHandleWindowChange, { passive: true });

    // Remove document click listener if it was added
    document.removeEventListener('click', this.boundHandleDocumentClick);
  }

  showLoadingDiv(parent, rect) {
    const loadingDiv = document.createElement("div");
    loadingDiv.className = 'loader';
    this.show(parent, rect, loadingDiv);
  }

  show(parent, parentRect, contentHTML) {
    this.currentParent = parent;
    // Update content if provided
    if (contentHTML) {
      this.contentTarget.innerHTML = "";
      this.contentTarget.appendChild(contentHTML);
    }

    // Make visible to measure sizes
    this.element.style.display = 'block';

    const tooltipWidth = this.element.offsetWidth;
    const tooltipHeight = this.element.offsetHeight;

    // Position the tooltip (this logic can be similar to what you had before)
    let left = parentRect.left + window.scrollX + (parentRect.width / 2) - (tooltipWidth / 2);
    let top = parentRect.bottom + window.scrollY + 10; // baseline attempt: place below

    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;
    const margin = 11;

    // Horizontal clamp
    if (left < (window.scrollX + margin)) {
      left = window.scrollX + margin;
    } else if (left + tooltipWidth > window.scrollX + viewportWidth - margin) {
      left = window.scrollX + viewportWidth - margin - tooltipWidth;
    }

    // Remove any old classes
    this.element.classList.remove('tooltip--above', 'tooltip--below');

    // Check vertical space below; if not enough, try above
    if (top + tooltipHeight > window.scrollY + viewportHeight - margin) {
      // Try placing above
      const abovePos = parentRect.top + window.scrollY - tooltipHeight - 10;
      if (abovePos > window.scrollY + margin) {
        top = abovePos;
        this.element.classList.add('tooltip--above');
      } else {
        top = Math.min(top, window.scrollY + viewportHeight - margin - tooltipHeight);
        this.element.classList.add('tooltip--below');
      }
    } else {
      this.element.classList.add('tooltip--below');
      if (top < window.scrollY + margin) {
        top = window.scrollY + margin;
      }
    }

    this.element.style.left = `${left}px`;
    this.element.style.top = `${top}px`;

    // Position arrow
    const parentCenterX = parentRect.left + (parentRect.width / 2) + window.scrollX;
    const tooltipLeftX = left;
    let arrowX = parentCenterX - tooltipLeftX;

    const arrowMargin = 10;
    arrowX = Math.max(arrowMargin, Math.min(tooltipWidth - arrowMargin, arrowX));
    this.arrowTarget.style.left = `${arrowX - 3}px`;

    // Add a global click listener to detect clicks outside the tooltip
    document.addEventListener('click', this.handleDocumentClick);
  }

  hide() {
    this.element.style.display = 'none'
    this.currentParent = null
    document.removeEventListener('click', this.handleDocumentClick)
  }

  /**
   * Handle global click events to determine if the tooltip should be hidden.
   * @param {Event} event - The click event.
   */
  handleDocumentClick(event) {
    // If the click is inside the tooltip, do nothing
    if (this.element.contains(event.target)) {
      return
    }

    // If the click is on the parent element, do nothing (prevents immediate hiding when re-clicking the parent)
    if (this.currentParent && this.currentParent.contains(event.target)) {
      return
    }

    // Otherwise, hide the tooltip
    this.hide()
  }

  disconnect() {
    // Ensure the tooltip is hidden and listeners are removed when the controller is disconnected
    this.hide()
  }

  handleWindowChange() {
    const tooltipElement = document.querySelector('[data-controller="tooltip"]');
    if (!tooltipElement) return; // Avoid TypeError if the element is missing

    const tooltipController = this.application.getControllerForElementAndIdentifier(tooltipElement, "tooltip");

    if (tooltipElement.style.display !== 'none' && this.currentParent) {
      const rect = this.currentParent.getBoundingClientRect();
      tooltipController.show(this.currentParent, rect);
    }
  }
}

