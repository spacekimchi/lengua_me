// app/javascript/controllers/sentence_writer_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "writerContainer",
    "prevButton",
    "nextButton",
    "textArea",
    "checkButton",
    "skipButton",
    "checkResult"
  ]

  connect() {
    this.sentences = JSON.parse(this.element.dataset.sentences)
    this.currentIndex = parseInt(this.element.dataset.currentIndex, 10) || 0
    this.renderSentence(this.currentIndex)
  }

  check() {
    const inputText = this.textAreaTarget.value;
    const currentSentence = this.sentences[this.currentIndex].content;

    // Extract words (alphanumeric sequences) from both input and actual
    const actualWords = currentSentence.match(/\w+/g) || [];
    const inputWords = inputText.match(/\w+/g) || [];

    let wordIndex = 0; // track which word we're comparing
    const tokens = currentSentence.match(/\w+|\W+/g) || [];

    // Keep track of normalization for final correctness check
    const normalizedActualFull = actualWords.join('').toLowerCase();
    const normalizedInputFull = inputWords.join('').toLowerCase();

    const resultTokens = tokens.map(token => {
      if (/\w+/.test(token)) {
        // Word token
        const actualWord = token;
        const actualChars = actualWord.split('');
        const normalizedActual = actualWord.replace(/[^a-z0-9]/gi, '').toLowerCase();

        const inputWord = inputWords[wordIndex] || '';
        wordIndex++;

        const normalizedInput = inputWord.replace(/[^a-z0-9]/gi, '').toLowerCase();

        let inputPos = 0;
        let actualPos = 0;

        const newChars = actualChars.map(ch => {
          if (/[a-z0-9]/i.test(ch)) {
            const actualChar = normalizedActual[actualPos] || '';
            const inputChar = normalizedInput[inputPos] || '';
            actualPos++;
            inputPos++;

            if (actualChar === inputChar) {
              return ch;
            } else {
              return '*';
            }
          } else {
            return ch; // punctuation inside word stays the same
          }
        });

        return newChars.join('');
      } else {
        // Non-word token (spaces, punctuation)
        return token;
      }
    });

    this.checkResultTarget.textContent = resultTokens.join('');

    // After constructing the result, check if normalized strings match
    if (normalizedActualFull === normalizedInputFull) {
      // Append a div indicating correctness
      const correctDiv = document.createElement('div');
      correctDiv.textContent = 'Correct!';
      this.checkResultTarget.appendChild(correctDiv);
    } else {
      // Append a div indicating incorrectness
      const correctDiv = document.createElement('div');
      correctDiv.textContent = 'Incorrect!';
      this.checkResultTarget.appendChild(correctDiv);
    }
  }




  skip() {
    // You can define what should happen on skip, for now do nothing or implement logic
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex -= 1
      this.renderSentence(this.currentIndex)
    }
  }

  next() {
    if (this.currentIndex < this.sentences.length - 1) {
      this.currentIndex += 1
      this.renderSentence(this.currentIndex)
    }
  }

  renderSentence(index) {
    const writerContainer = this.writerContainerTarget
    const sentence = this.sentences[index]

    // Clear current content
    writerContainer.innerHTML = ''

    // If there is an audio file, add an audio player
    if (sentence.audio_url) {
      const audio = document.createElement('audio')
      audio.controls = true
      audio.src = sentence.audio_url
      writerContainer.appendChild(audio)
    }

    // Show the correct sentence (this might be optional if you want to hide it from the user)
    const sentenceDiv = document.createElement('div')
    sentenceDiv.classList.add('sentence-writer')
    sentenceDiv.textContent = sentence.content
    writerContainer.appendChild(sentenceDiv)

    // Update current index data attribute
    this.element.dataset.currentIndex = index

    // Clear the textarea and check result whenever we load a new sentence
    this.textAreaTarget.value = ''
    this.checkResultTarget.textContent = ''
  }
}

