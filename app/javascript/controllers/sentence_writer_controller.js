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
    "pronunciationTooltip"
  ];

  connect() {
    const defaultLanguage = "en";
    const storedTranslateLanguageCode = localStorage.getItem("translateLanguageCode") || defaultLanguage;

    // Set the selected language in the dropdown based on localStorage
    this.translateLanguageSelectTarget.value = storedTranslateLanguageCode;

    // Fetch initial translations
    this.sentences = JSON.parse(this.element.dataset.sentences);
    this.currentIndex = parseInt(this.element.dataset.currentIndex, 10) || 0;
    this.finishedSentence = false;
    this.initialLoad = true;
    this.renderSentence(this.currentIndex);
    this.fetchTranslations(storedTranslateLanguageCode);
    this.textAreaTarget.focus();
    this.wordPronunciations = {};

    document.addEventListener("keydown", this.handleKeyDown.bind(this));
    this.textAreaTarget.addEventListener('input', this.handleInput.bind(this));
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
      this.displayTranslation();
      return data;
    })
    .catch(error => {
      console.error("Error fetching translations:", error);
    });
  }

  displayTranslation() {
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
    const word = parent.querySelector(".pronunciation-word").innerText;
    const wordTranslation = this.fetchWordPronunciation(word);

    const tooltip = this.pronunciationTooltipTarget
    tooltip.innerHTML = '<div style="display: flex; flex-direction: row;"><div style="height: 200px; width: 200px;">Block 1</div><div style="height: 125px; width: 125px;">Block 2</div></div>';
    tooltip.style.display = 'block'; // Show it first so getBoundingClientRect() on tooltip is accurate if needed

    this.positionTooltip(parent, tooltip);

    // Attach event listeners to update position on resize (and scroll if needed)
    window.addEventListener('resize', this.handleWindowChange.bind(this));
    window.addEventListener('scroll', this.handleWindowChange.bind(this), { passive: true });
  }

  handleWindowChange() {
    // Recalculate tooltip position if it's visible
    if (this.pronunciationTooltipTarget.style.display !== 'none') {
      const parent = document.querySelector(".pronunciation-word-container:hover, .pronunciation-word-container:focus");
      // If we can't detect the hovered/focused parent, you may want to store the current parent element in a variable.
      // For simplicity, let's assume we stored the last clicked parent in `this.currentWordParent`.
      if (this.currentWordParent) {
        this.positionTooltip(this.currentWordParent, this.pronunciationTooltipTarget);
      }
    }
  }

  positionTooltip(parent, tooltip) {
    this.currentWordParent = parent;

    const rect = parent.getBoundingClientRect();
    const tooltipWidth = tooltip.offsetWidth;
    const tooltipHeight = tooltip.offsetHeight;

    // Desired baseline positioning
    let left = rect.left + window.scrollX + (rect.width / 2) - (tooltipWidth / 2);
    let top = rect.bottom + window.scrollY + 10; // 10px below the parent

    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;
    const margin = 11; // Minimum margin from viewport edges

    // Clamp horizontally
    if (left < (window.scrollX + margin)) {
      left = window.scrollX + margin;
    } else if (left + tooltipWidth > window.scrollX + viewportWidth - margin) {
      left = window.scrollX + viewportWidth - margin - tooltipWidth;
    }

    // Check vertical space below; if not enough, try above
    if (top + tooltipHeight > window.scrollY + viewportHeight - margin) {
      // Try placing above the element
      const abovePos = rect.top + window.scrollY - tooltipHeight - 10;
      if (abovePos > window.scrollY + margin) {
        top = abovePos;
      } else {
        // If not enough room above, clamp to bottom of viewport
        top = Math.min(top, window.scrollY + viewportHeight - margin - tooltipHeight);
      }
    } else {
      // Also ensure top doesn't go above the top margin
      if (top < window.scrollY + margin) {
        top = window.scrollY + margin;
      }
    }

    tooltip.style.left = `${left}px`;
    tooltip.style.top = `${top}px`;
  }


  fetchWordPronunciation(word) {
    if (this.wordPronunciations[word]) {
      return this.wordPronunciations[word]
    } else {
      const originalLanguage = "en";
      fetch(`/pronunciations/${word}?translate_language=${this.translateLanguageSelectTarget.value}&original_language=${originalLanguage}`, {
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
          console.error("Error fetching translations:", error);
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
    if (!event.ctrlKey) { return; }
    this.playAudio();
    if (event.key === "]" && this.currentIndex < this.sentences.length) {
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
    document.removeEventListener("keydown", this.handleKeyDown.bind(this));
    this.textAreaTarget.removeEventListener('input', this.handleInput.bind(this));
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

    // Extract words (alphanumeric sequences) from both input and actual
    const actualWords = currentSentence.match(/\w+/g) || [];
    const inputWords = inputText.match(/\w+/g) || [];

    let wordIndex = 0; // track which word we're comparing
    const tokens = currentSentence.match(/\w+|\W+/g) || [];

    // Keep track of normalization for final correctness check
    const normalizedActualFull = actualWords.join("").toLowerCase();
    const normalizedInputFull = inputWords.join("").toLowerCase();

    const resultTokens = tokens.map(token => {
      if (/\w+/.test(token)) {
        // Word token
        const actualWord = token;
        const actualChars = actualWord.split("");
        const normalizedActual = actualWord.replace(/[^a-z0-9]/gi, "").toLowerCase();

        const inputWord = inputWords[wordIndex] || "";
        wordIndex++;

        const normalizedInput = inputWord.replace(/[^a-z0-9]/gi, "").toLowerCase();

        let inputPos = 0;
        let actualPos = 0;

        const newChars = actualChars.map(ch => {
          if (/[a-z0-9]/i.test(ch)) {
            const actualChar = normalizedActual[actualPos] || "";
            const inputChar = normalizedInput[inputPos] || "";
            actualPos++;
            inputPos++;

            if (actualChar === inputChar) {
              return ch;
            } else {
              return "*";
            }
          } else {
            return ch; // punctuation inside word stays the same
          }
        });

        return newChars.join("");
      } else {
        // Non-word token (spaces, punctuation)
        return token;
      }
    });


    // After constructing the result, check if normalized strings match
    if (normalizedActualFull === normalizedInputFull) {
      // Append a div indicating correctness
      this.showCorrectDiv();
      this.checkResultTarget.textContent = "";
      this.textAreaTarget.value = this.sentences[this.currentIndex].content;
      this.textAreaTarget.classList = "success";
      this.finishedSentence = true;
    } else {
      // Append a div indicating incorrectness
      this.checkResultTarget.textContent = resultTokens.join("");
      this.showIncorrectDiv();
    }
  }

  skip() {
    // You can define what should happen on skip, for now do nothing or implement logic
    this.showSkipDiv();
    this.skippedSentence = true;
    this.textAreaTarget.value = this.sentences[this.currentIndex].content;
  }

  showCorrectDiv() {
    this.correctDivTarget.style.display = "flex";
    this.incorrectDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";

    // For the right part
    this.showPronunciationsDiv();
  }

  showSkipDiv() {
    this.skipDivTarget.style.display = "flex";
    this.correctDivTarget.style.display = "none";
    this.incorrectDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";

    // For the right part
    this.showPronunciationsDiv();
  }

  showIncorrectDiv() {
    this.incorrectDivTarget.style.display = "flex";
    this.correctDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";
    this.wordPronunciationsDivTarget.style.display = "none";
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
    }
  }

  renderSentence(index) {
    const writerContainer = this.writerContainerTarget;
    const sentence = this.sentences[index];

    // Clear current content
    writerContainer.innerHTML = "";

    // If there is an audio file, add an audio player
    if (sentence.audio_url) {
      const audio = document.createElement("audio");
      audio.id = `audio-${this.currentIndex}`;
      audio.className = "sentence-writer-audio";
      audio.controls = true;
      audio.src = sentence.audio_url;
      audio.onplay = this.focusTextArea.bind(this);

      writerContainer.appendChild(audio);
    }

    // Show the correct sentence (this might be optional if you want to hide it from the user)
    const sentenceDiv = document.createElement("div");
    sentenceDiv.classList.add("sentence-writer");
    sentenceDiv.textContent = sentence.content;
    writerContainer.appendChild(sentenceDiv);

    this.element.dataset.currentIndex = index;

    this.resetValues();

    // If not the initial load, autoplay the audio
    if (!this.initialLoad) {
      this.displayTranslation();
      this.playAudio();
    }
    this.initialLoad = false;
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
    this.resetActionDivs();
  }

  resetActionDivs() {
    this.correctDivTarget.style.display = "none";
    this.incorrectDivTarget.style.display = "none";
    this.skipDivTarget.style.display = "none";
    this.checkAndSkipDivTarget.style.display = "flex";
  }
}

