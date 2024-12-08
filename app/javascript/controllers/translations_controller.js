import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="translations"
export default class extends Controller {
  static values = {
    id: String
  }

  static targets = ["languageSelect", "translationsOutput"]

  connect() {
    const defaultLanguage = 'en'
    const storedLanguageCode = localStorage.getItem('languageCode') || defaultLanguage

    // Set the selected language in the dropdown based on localStorage
    this.languageSelectTarget.value = storedLanguageCode

    // Fetch initial translations
    this.fetchTranslations(storedLanguageCode)
  }

  changeLanguage() {
    const newLanguageCode = this.languageSelectTarget.value
    // Update localStorage with the new language selection
    localStorage.setItem('languageCode', newLanguageCode)
    // Fetch new translations
    this.fetchTranslations(newLanguageCode)
  }

  fetchTranslations(languageCode) {
    const passageId = this.idValue
    fetch(`/passages/${passageId}/translations?language_code=${languageCode}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      this.displayTranslations(data.sentences)
    })
    .catch(error => {
      console.error("Error fetching translations:", error)
    })
  }

  displayTranslations(sentences) {
    this.translationsOutputTarget.innerHTML = ''
    sentences.forEach(sentence => {
      const p = document.createElement('p')
      p.textContent = `${sentence.content} => ${sentence.translation_text}`
      this.translationsOutputTarget.appendChild(p)
    })
  }
}

