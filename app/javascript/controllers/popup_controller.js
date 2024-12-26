import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["popupFrame"];

  connect() {
    this.handleDocumentClickBound = this.handleDocumentClick.bind(this);
    document.addEventListener('click', this.handleDocumentClickBound);
  }

  disconnect() {
    document.removeEventListener('click', this.handleDocumentClickBound);
  }

  displayPopup() {
    this.popupFrameTarget.classList.remove('hidden');
  }

  hidePopup() {
    this.popupFrameTarget.classList.add('hidden');
  }

  showLoading(event) {
    this.popupFrameTarget.innerHTML = `
      <div class="popup" style="position:absolute; top:100%; left:0; background:#fff; border:1px solid #ddd; box-shadow:0 4px 8px rgba(0,0,0,0.1); padding:1rem;">
        <div class="spinner" style="margin-bottom: 0.5rem;"></div>
        Loading...
      </div>
    `;
  }

  handleDocumentClick(event) {
    const popup = this.popupFrameTarget.querySelector('.popup');
    if (popup && !this.element.contains(event.target)) {
      this.hidePopup();
    }
  }
}

