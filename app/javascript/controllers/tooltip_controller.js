import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["arrow", "content", "tooltip"];

  initialize() {
    // Bind event handlers once and store the references
    this.boundHandleDocumentClick = this.handleDocumentClick.bind(this);
    this.boundHandleWindowChange = this.handleWindowChange.bind(this);
  }

  connect() {
    this.hide();
    this.currentParent = null;

    // Attach event listeners using the stored bound functions
    window.addEventListener('resize', this.boundHandleWindowChange);
    window.addEventListener('scroll', this.boundHandleWindowChange, { passive: true });
  }

  disconnect() {
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

  displayTooltip(event) {
    event.preventDefault();
    const element = this.element.querySelector('button[data-action="tooltip#displayTooltip"]');
    this.show(element, element.getBoundingClientRect());
  }

  show(parent, parentRect, contentHTML) {
    this.currentParent = parent;
    // Update content if provided
    if (contentHTML) {
      this.contentTarget.innerHTML = "";
      this.contentTarget.appendChild(contentHTML);
    }

    // Make visible to measure sizes
    this.tooltipTarget.classList.remove('hidden');

    const tooltipWidth = this.tooltipTarget.offsetWidth;
    const tooltipHeight = this.tooltipTarget.offsetHeight;

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
    this.tooltipTarget.classList.remove('tooltip--above', 'tooltip--below');

    // Check vertical space below; if not enough, try above
    if (top + tooltipHeight > window.scrollY + viewportHeight - margin) {
      // Try placing above
      const abovePos = parentRect.top + window.scrollY - tooltipHeight - 10;
      if (abovePos > window.scrollY + margin) {
        top = abovePos;
        this.tooltipTarget.classList.add('tooltip--above');
      } else {
        top = Math.min(top, window.scrollY + viewportHeight - margin - tooltipHeight);
        this.tooltipTarget.classList.add('tooltip--below');
      }
    } else {
      this.tooltipTarget.classList.add('tooltip--below');
      if (top < window.scrollY + margin) {
        top = window.scrollY + margin;
      }
    }

    this.tooltipTarget.style.left = `${left}px`;
    this.tooltipTarget.style.top = `${top}px`;

    // Position arrow
    const parentCenterX = parentRect.left + (parentRect.width / 2) + window.scrollX;
    const tooltipLeftX = left;
    let arrowX = parentCenterX - tooltipLeftX;

    const arrowMargin = 10;
    arrowX = Math.max(arrowMargin, Math.min(tooltipWidth - arrowMargin, arrowX));
    this.arrowTarget.style.left = `${arrowX - 3}px`;

    // Add a global click listener to detect clicks outside the tooltip
    document.addEventListener('click', this.boundHandleDocumentClick);
  }

  hide() {
    this.tooltipTarget.classList.add('hidden');
    this.currentParent = null;
    document.removeEventListener('click', this.boundHandleDocumentClick);
  }

  /**
   * Handle global click events to determine if the tooltip should be hidden.
   * @param {Event} event - The click event.
   */
  handleDocumentClick(event) {
    // If the click is inside the tooltip, do nothing
    if (this.tooltipTarget.contains(event.target)) {
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
    const tooltipElement = this.tooltipTarget;
    if (!tooltipElement) return; // Avoid TypeError if the element is missing

    if (!tooltipElement.classList.contains('hidden') && this.currentParent) {
      const rect = this.currentParent.getBoundingClientRect();
      this.show(this.currentParent, rect);
    }
  }
}

