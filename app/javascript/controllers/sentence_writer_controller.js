import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: String
  };

  static targets = [
    "writerContainer",
    "textArea",
    "checkResult",
    "checkAndSkip",
    "incorrectDiv",
    "correctDiv",
    "checkAndSkipDiv",
    "translateLanguageSelect",
    "translationsOutput",
    "skipDiv",
    "wordPronunciationsDiv",
    "wordPronunciationsText",
    "infoContainerDiv",
    "currentIndexNavigation",
    "leftNav",
    "rightNav",
    "mainContainer",
    "completedContainer",
    "navigation"
  ];

  initialize() {
    this.boundHandleKeyDown = this.handleKeyDown.bind(this);
    this.boundHandleInput = this.handleInput.bind(this);
  }

  connect() {
    const defaultLanguage = "en";
    const storedTranslateLanguageCode = localStorage.getItem("translateLanguageCode") || defaultLanguage;

    // Set the selected language in the dropdown based on localStorage
    this.translateLanguageSelectTarget.value = storedTranslateLanguageCode;

    // Fetch initial translations
    this.sentences = JSON.parse(this.element.dataset.sentences);
    this.currentIndex = parseInt(this.element.dataset.currentIndex, 10) || 0;
    this.progressIndex = this.currentIndex;
    this.finishedSentence = false;
    this.initialLoad = true;
    this.renderSentence(this.currentIndex);
    this.fetchTranslations(storedTranslateLanguageCode);
    this.textAreaTarget.focus();
    this.wordPronunciations = {};

    // Event Listeners
    document.addEventListener("keydown", this.boundHandleKeyDown);
    this.textAreaTarget.addEventListener('input', this.boundHandleInput);
  }

  changeLanguage() {
    const newLanguageCode = this.translateLanguageSelectTarget.value;
    // Update localStorage with the new language selection
    localStorage.setItem('translateLanguageCode', newLanguageCode);
    // Fetch new translations
    this.fetchTranslations(newLanguageCode);
  }

  fetchTranslations(languageCode) {
    const passageId = this.idValue;
    fetch(`/passages/${passageId}/translations?language_code=${languageCode}`, {
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      this.translations = data.sentences;
      return data;
    })
    .catch(error => {
      console.error("Error fetching translations:", error);
    });
  }

  setTranslations() {
    this.translationsOutputTarget.innerHTML = "";
    if (this.translations && this.translations[this.currentIndex]) {
      const p = document.createElement('p');
      p.textContent = this.translations[this.currentIndex].translation_text;
      this.translationsOutputTarget.appendChild(p);
    }
  }

  showPronunciationsDiv() {
    this.wordPronunciationsDivTarget.style.display = "flex";
    this.wordPronunciationsTextTarget.innerHTML = "";

    const sentence = this.normalizeWhitespace(this.sentences[this.currentIndex].content);

    const separators = {
      ",": true, ";": true, ":": true, ".": true, "!": true, "?": true, "-": true,
      "—": true, "(": true, ")": true, "[": true, "]": true, "{": true, "}": true,
      "\"": true, "`": true, "/": true, "\\": true, "|": true, "@": true, "#": true,
      "$": true, "%": true, "^": true, "&": true, "*": true, "_": true, "+": true,
      "=": true, "<": true, ">": true, "~": true
    };

    let curWord = "";

    for (let i = 0; i < sentence.length; i++) {
      const c = sentence[i];

      if (this.isWhitespace(c) || separators[c]) {
        if (curWord) {
          // Create and append a span for the current word
          const span = document.createElement('span');
          span.className = "pronunciation-word-container";
          span.onclick = this.showWordPronunciationDiv.bind(this);
          const wordSpan = document.createElement('span');
          wordSpan.textContent = curWord;
          wordSpan.className = "pronunciation-word";
          span.appendChild(wordSpan);

          const punctuationSpan = document.createElement('span');
          if (separators[c]) {
            punctuationSpan.appendChild(document.createTextNode(c));
          }
          punctuationSpan.appendChild(document.createTextNode("\u00A0")); // Non-breaking space
          span.appendChild(punctuationSpan);

          this.wordPronunciationsTextTarget.appendChild(span);
          curWord = "";
        }
      } else {
        curWord += c; // Build the current word
      }
    }

    // Add the last word if present
    if (curWord) {
      const span = document.createElement('span');
      span.textContent = curWord;
      this.wordPronunciationsTextTarget.appendChild(span);
    }
  }

  normalizeWhitespace(str) {
    return str.replace(/\s+/g, ' ');
  }

  isWhitespace(char) {
    return char.match(/\s/) !== null;
  }

  showWordPronunciationDiv(event) {
    const parent = event.target.parentElement;
    const rect = parent.getBoundingClientRect();
    const word = parent.querySelector(".pronunciation-word").innerText;

    const tooltipElement = document.querySelector('[data-controller="tooltip"]');
    const tooltipController = this.application.getControllerForElementAndIdentifier(tooltipElement, "tooltip")

    // Show a loader first
    tooltipController.showLoadingDiv(parent, rect);
    // Fetch the pronunciation (ensure this method returns a promise or handles async correctly)
    this.fetchWordPronunciation(word).then(wordPronunciation => {
      // Get the TooltipController instance
      let contentHTML = this.createPronunciationContent(word, wordPronunciation);
      tooltipController.show(parent, rect, contentHTML); // Adjust based on your fetchWordPronunciation response

      // Optionally, manage event listeners in the main controller if needed
    })
    this.currentWordParent = parent;
  }

  createPronunciationContent(word, pronunciation) {
    // Get the TooltipController instance
    let contentHTML = document.createElement('div');
    contentHTML.className = 'word-pronunciation-container';

    if (pronunciation.error) {
      const noPronunciation = document.createElement('p');
      noPronunciation.textContent = "Pronunciation not available.";
      contentHTML.appendChild(noPronunciation);
    } else {
      // Show the tooltip with the parent element and fetched content
      const headerContainer = document.createElement('div');
      headerContainer.className = 'word-pronunciation-header';
      headerContainer.innerHTML = word;

      contentHTML.appendChild(headerContainer);
      const buttonContainer = document.createElement('div');
      buttonContainer.className = 'word-pronunciation-buttons';
      if (pronunciation.male) {
        const maleButton = this.createPlayButton(
          "Male",
          word,
          "Play male pronunciation"
       );
        maleButton.setAttribute('data-gender', 'male')
        buttonContainer.appendChild(maleButton);

        const url = pronunciation['male'].url;
        const audio = new Audio(url);
        audio.play().catch(error => console.error("Error playing audio:", error));
      }

      if (pronunciation.female) {
        const femaleButton = this.createPlayButton(
          "Female",
          word,
          "Play female pronunciation"
        );
        femaleButton.setAttribute('data-gender', 'female');
        buttonContainer.appendChild(femaleButton);
      }
      contentHTML.appendChild(buttonContainer);
    }
    return contentHTML;
  }

  /**
   * Create a play button element.
   * @param {String} buttonText - The text to display on the button.
   * @param {String} pronunciationUrl - The URL of the pronunciation audio.
   * @param {String} ariaLabel - The ARIA label for accessibility.
   * @returns {HTMLButtonElement} - The configured button element.
   */
  createPlayButton(buttonText, word, ariaLabel) {
    const button = document.createElement('button');
    button.className = 'button action-button';
    button.textContent = `🔊 ${buttonText}`;
    button.setAttribute('data-action', 'click->sentence-writer#playPronunciation');
    button.setAttribute('data-word', word);
    button.setAttribute('aria-label', ariaLabel);
    return button;
  }

  /**
   * Handle playing the pronunciation audio.
   * @param {Event} event - The click event on the play button.
   */
  playPronunciation(event) {
    const word = event.target.getAttribute('data-word');
    const gender = event.target.getAttribute('data-gender');
    const pronunciation = this.wordPronunciations[word];
    if (pronunciation && pronunciation[gender]) {
      const url = pronunciation[gender].url;
      const audio = new Audio(url);
      audio.play().catch(error => console.error("Error playing audio:", error));
    }
  }

  fetchWordPronunciation(word) {
    if (this.wordPronunciations[word]) {
      // Return a resolved promise with the cached data
      return Promise.resolve(this.wordPronunciations[word]);
    } else {
      const originalLanguage = "en";
      return fetch(`/pronunciations/${word}?translate_language=${this.translateLanguageSelectTarget.value}&original_language=${originalLanguage}`, {
        headers: {
          'Accept': 'application/json'
        }
      })
        .then(response => {
          if (!response.ok) {
            throw new Error("Network response was not ok");
          }
          return response.json();
        })
        .then(data => {
          this.wordPronunciations[word] = data;
          return data;
        })
        .catch(error => {
          console.error("Error fetching pronunciations:", error);
          return { error: "Pronunciation not available." }; // Fallback content
        });
    }
  }

  handleInput(event) {
    // Check if the value actually changed
    if (["insertText", "deleteContentBackward", "deleteContentForward", "deleteSoftLineBackward", "deleteWordBackward", "insertFromPaste"].includes(event.inputType)) {
      this.resetActionDivs();
    }
  }

  handleKeyDown(event) {
    if (this.onCompletedViewPage && this.currentIndex == this.sentences.length) {
      if (event.key === "Enter") {
        if (this.enterCount === 0) {
          this.enterCount += 1;
        } else if (this.completedContainerTarget.querySelector('#completed-next-link')) {
          this.enterCount = 0;
          this.completedContainerTarget.querySelector('#completed-next-link').click();
        }
      } else if (!event.ctrlKey && (event.key === 'p' || event.key === 'P')) {
        if (this.completedContainerTarget.querySelector('#completed-prev-link')) {
          this.completedContainerTarget.querySelector('#completed-prev-link').click();
        }
      } else if (!event.ctrlKey && (event.key === 'r' || event.key === 'R')) {
        if (this.completedContainerTarget.querySelector('#completed-repeat-link')) {
          this.completedContainerTarget.querySelector('#completed-repeat-link').click();
        }
      } else if (!event.ctrlKey && event.key === 'b') {
        if (this.completedContainerTarget.querySelector('#all-passages-link')) {
          this.completedContainerTarget.querySelector('#all-passages-link').click();
        }
      }
      return;
    }
    if (!event.ctrlKey) { return; }
    this.playAudio();
    if (event.key === "]" && this.currentIndex < this.sentences.length - 1) {
      this.next();
    } else if (event.key === "[" && 0 < this.currentIndex) {
      this.prev();
    }
  }

  playAudio() {
    const audio = document.querySelector(`audio#audio-${this.currentIndex}`);
    if (audio) {
      audio.play().catch(() => {});
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundHandleKeyDown);
    this.textAreaTarget.removeEventListener('input', this.boundHandleInput);
  }

  check(event) {
    if (event.type === "keydown" && event.key !== "Enter") { return; }

    event.preventDefault();
    if (event.type === "keydown" && event.key === "Enter" && (this.finishedSentence || this.skippedSentence)) {
      this.next();
      return;
    }

    const inputText = this.textAreaTarget.value;
    const currentSentence = this.sentences[this.currentIndex].content;
    this.displayNextButtons();

    // Normalize function: Decompose accented characters and remove diacritics
    const normalizeText = (text) => {
      return text
        .normalize("NFD") // Decompose characters
        .replace(/[\u0300-\u036f]/g, "") // Remove diacritics
        .toLowerCase(); // Convert to lowercase
    };

    // Function to remove punctuation
    const removePunctuation = (text) => {
      return text.replace(/[^\w\s]|_/g, "").replace(/\s+/g, " ");
    };

    // Normalize and remove punctuation from actual and input texts
    const normalizedActual = normalizeText(currentSentence);
    const normalizedInput = normalizeText(inputText);

    const cleanActual = removePunctuation(normalizedActual);
    const cleanInput = removePunctuation(normalizedInput);

    // Extract words (alphanumeric sequences) from both input and actual
    const actualWords = cleanActual.match(/\w+/g) || [];
    const inputWords = cleanInput.match(/\w+/g) || [];

    let wordIndex = 0; // Track which word we're comparing
    const tokens = currentSentence.match(/\w+|\W+/g) || []; // Original tokens with punctuation

    // Comparison tokens
    const resultTokens = tokens.map(token => {
      if (/\w+/.test(token)) {
        // Word token
        const actualWord = token;
        const actualChars = actualWord.split("");
        const normalizedActualWord = normalizeText(actualWord);

        const inputWord = inputWords[wordIndex] || "";
        wordIndex++;

        const normalizedInputWord = normalizeText(inputWord);

        let inputPos = 0;
        let actualPos = 0;

        const newChars = actualChars.map(ch => {
          if (/[a-z0-9]/i.test(ch)) {
            const actualChar = normalizedActualWord[actualPos] || "";
            const inputChar = normalizedInputWord[inputPos] || "";
            actualPos++;
            inputPos++;

            if (actualChar === inputChar) {
              return ch;
            } else {
              return "\u2217"; // Indicate mismatch
            }
          } else {
            return ch; // Punctuation inside word stays the same
          }
        });

        return newChars.join("");
      } else {
        // Non-word token (spaces, punctuation) - Keep as is
        return token;
      }
    });

    // After constructing the result, check if normalized and cleaned strings match
    if (cleanActual === cleanInput) {
      // Append a div indicating correctness
      this.showCorrectDiv();
      if (this.progressIndex <= this.currentIndex) {
        this.updatePassageProgress(this.currentIndex + 1);
      }
    } else {
      // Append a div indicating incorrectness
      this.checkResultTarget.textContent = resultTokens.join("");
      this.showIncorrectDiv();
    }
  }

  updatePassageProgress(idx) {
    this.progressIndex = idx;
    const loggedIn = document.querySelector('meta[name="current-user"]').content === "true";

    if (!loggedIn) {
      console.warn("User not logged in, skipping sentence completion.");
      return;
    }
    const passageId = this.idValue;

    // Define the request payload
    const payload = {
      passage_id: passageId,
      current_index: idx
    };

    fetch(`/update_passage_progress`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error("Failed to complete the sentence.");
        }
      })
      .then((data) => {
        console.log("SENTENCE COMPLETED:", data); // Success message
      })
      .catch((error) => {
        console.error(error.message);
      });
  }

  toggleMismatch() {
      // this.checkResultTarget.textContent = resultTokens.join("");
  }

  skip() {
    // You can define what should happen on skip, for now do nothing or implement logic
    this.showSkipDiv();
    this.skippedSentence = true;
    this.textAreaTarget.value = this.sentences[this.currentIndex].content;
    this.checkResultTarget.textContent = "";
  }

  displayNextButtons() {
    if (this.currentIndex === this.sentences.length - 1) {
      // this.correctDivTarget.querySelector('button.success-button').classList.add('hidden');
      this.skipDivTarget.querySelector('button.action-button').classList.add('hidden');
      this.checkAndSkipDivTarget.querySelector('button.neutral-button').classList.add('hidden');
    } else {
      this.correctDivTarget.querySelector('button.success-button').classList.remove('hidden');
      this.skipDivTarget.querySelector('button.action-button').classList.remove('hidden');
      this.checkAndSkipDivTarget.querySelector('button.neutral-button').classList.remove('hidden');
      this.incorrectDivTarget.querySelector('button.warning-button').classList.remove('hidden');
    }
  }

  showCorrectDiv() {
    this.correctDivTarget.style.display = "flex";
    this.incorrectDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";
    this.textAreaTarget.classList = "success";
    this.checkResultTarget.textContent = "";
    this.textAreaTarget.value = this.sentences[this.currentIndex].content;
    this.finishedSentence = true;

    this.showInfoContent();
  }

  showSkipDiv() {
    this.skipDivTarget.style.display = "flex";
    this.correctDivTarget.style.display = "none";
    this.incorrectDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";
    this.textAreaTarget.classList = "warning";

    this.showInfoContent();
  }

  showIncorrectDiv() {
    this.incorrectDivTarget.style.display = "flex";
    this.correctDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";
    this.textAreaTarget.classList = "warning";
    this.wordPronunciationsDivTarget.style.display = "none";
    this.finishedSentence = false;
  }

  showInfoContent() {
    this.setTranslations();
    this.showPronunciationsDiv();
    this.setDisplayInfoDiv(true);
  }

  setDisplayInfoDiv(shouldShow) {
    if (shouldShow) {
      this.infoContainerDivTarget.style.display = "flex";
    } else {
      this.infoContainerDivTarget.style.display = "none";
    }
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex -= 1;
      this.renderSentence(this.currentIndex);
    }
  }

  next() {
    if (this.currentIndex < this.sentences.length - 1) {
      this.currentIndex += 1;
      this.renderSentence(this.currentIndex);
      this.focusTextArea();
    } else if (this.currentIndex === this.sentences.length - 1) {
      this.currentIndex += 1;
      this.renderCompletedView();
    }
  }

  renderCompletedView() {
    this.mainContainerTarget.style.display = 'none';
    this.navigationTarget.style.display = 'none';
    this.completedContainerTarget.classList.remove('hidden');
    this.onCompletedViewPage = true;
    this.enterCount = 0;
  }

  renderSentence(index) {
    const writerContainer = this.writerContainerTarget;
    const sentence = this.sentences[index];

    // If there is an audio file, add an audio player
    if (sentence.audio_url) {
      const audio = writerContainer.querySelector('audio');
      audio.id = `audio-${index}`;
      audio.src = sentence.audio_url;
      audio.onplay = this.focusTextArea.bind(this);

      writerContainer.appendChild(audio);
    }

    // Show the correct sentence (this might be optional if you want to hide it from the user)
    const sentenceDiv = writerContainer.querySelector('div#sentence-blur-hint');
    if (sentence.prefix) {
      sentenceDiv.querySelector('.sentence-prefix').textContent = `${sentence.prefix}:`;
    }
    sentenceDiv.querySelector('.content-blur').classList.add("blur");
    sentenceDiv.querySelector('.content-blur').textContent = sentence.content;

    this.element.dataset.currentIndex = index;

    if (this.currentIndex < this.progressIndex) {
      this.showCorrectDiv();
    } else {
      this.resetValues();
    }
    this.setNav();

    // If not the initial load, autoplay the audio
    if (!this.initialLoad) {
      this.playAudio();
    }
    this.initialLoad = false;
  }

  setNav() {
    if (this.currentIndex === 0) {
      this.leftNavTarget.classList.add('hidden-vis');
    } else {
      this.leftNavTarget.classList.remove('hidden-vis');
    }
    if (this.currentIndex === this.sentences.length - 1) {
      this.rightNavTarget.classList.add('hidden-vis');
    } else {
      this.rightNavTarget.classList.remove('hidden-vis');
    }
    this.currentIndexNavigationTarget.innerText = `${this.currentIndex + 1} / ${this.sentences.length}`;
  }

  focusTextArea() {
    this.textAreaTarget.focus();
  }

  resetValues() {
    this.textAreaTarget.value = "";
    this.checkResultTarget.textContent = "";
    this.textAreaTarget.classList = "";
    this.finishedSentence = false;
    this.skippedSentence = false;
    this.setDisplayInfoDiv(false);
    this.textAreaTarget.classList = "";
    this.resetActionDivs();
  }

  resetActionDivs() {
    this.correctDivTarget.style.display = "none";
    this.incorrectDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "flex";
    this.displayNextButtons();
  }
}

