import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["arrow", "content"];

  connect() {
    // Initially hide the tooltip
    this.element.style.display = 'none';
    this.hide();
  }

  show(parentRect, contentHTML) {
    // Update content if provided
    if (contentHTML) {
      this.contentTarget.innerHTML = contentHTML;
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
    this.arrowTarget.style.left = arrowX + 'px';
  }

  hide() {
    this.element.style.display = 'none';
  }
}

