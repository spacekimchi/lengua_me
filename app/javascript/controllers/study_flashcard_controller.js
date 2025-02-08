import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="study-flashcard"
export default class extends Controller {
  static values = {
    id: String
  };

  static targets = [
    "hiddenCard",
    "revealedCard",
    "againButton",
    "hardButton",
    "goodButton",
    "easyButton"
  ];

  initialize() {
    this.boundHandleKeyDown = this.handleKeyDown.bind(this);
  }

  connect() {
    document.addEventListener("keydown", this.boundHandleKeyDown);
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleKeyDown);
  }

  handleKeyDown(event) {
    if (this.hiddenCardTarget.classList.contains("hidden")) {
      switch(event.key) {
        case "ArrowLeft":
          this.toggleFlashcard();
          break;
        case "Enter":
        case " ":
        case "ArrowRight":
        case "ArrowDown":
        case 3:
          this.goodButtonTarget.click();
          break;
        case 1:
          this.againButtonTarget.click();
          break;
        case 2:
          this.hardButtonTarget.click();
          break;
        case 4:
          this.easyButtonTarget.click();
      }
    } else {
      switch(event.key) {
        case "Enter":
        case " ":
        case "ArrowRight":
        case "ArrowDown":
        case 1:
        case 2:
        case 3:
        case 4:
          this.toggleFlashcard();
      }
    }
  }

  toggleFlashcard() {
    if (this.hiddenCardTarget.classList.contains("hidden")) {
      this.hiddenCardTarget.classList.remove("hidden");
      this.revealedCardTarget.classList.add("hidden");
    } else {
      this.hiddenCardTarget.classList.add("hidden");
      this.revealedCardTarget.classList.remove("hidden");
    }
  }
}
