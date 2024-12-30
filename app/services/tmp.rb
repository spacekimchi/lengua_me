require 'csv'

class Tmp
  def self.available_languages
    ["Spanish (Spain)", "Spanish (Latin America)", "Korean", "Japanese", "Hindi", "French", "Italian", "Portuguese", "German", "Russian", "Mandarin", "Vietnamese", "Cantonese"]
  end
  def self.translate_passages
    languages = available_languages
    passages = passages_without_any_translations
    passages.each do |passage|
      languages.each do |lang|
        sentences = passage.sentences.order(:order_idx).pluck(:content, :id)
        language = Language.find_by(name: lang)
        res = PassageTranslatorService.new(sentences: sentences, language: language).call
      end
    end
  end

  def self.passages_with_all_translations
    languages = available_languages
    target_languages = Language.where(name: languages)

    Passage
      .joins(sentences: :translations)
      .where(sentence_translations: { language_id: target_languages })
      .group("passages.id")
      .having("COUNT(DISTINCT sentence_translations.language_id) = ?", target_languages.size)
      .distinct
  end

  def self.passages_without_any_translations
    # 1) Find the corresponding Language records for your target names:
    languages = available_languages
    target_languages = Language.where(name: languages)

    # 2) Get all passages that do NOT have any SentenceTranslations
    #    for any of the above languages:
    Passage
      .left_joins(sentences: :translations)
      .where(sentences: { id: Sentence.select(:id) })  # ensure we only consider passages that actually have sentences
      .group("passages.id")
      .having("SUM(CASE WHEN sentence_translations.language_id IN (?) THEN 1 ELSE 0 END) = 0", target_languages.ids)
      .distinct
  end

  def self.fix_category_conversations
    titles = ["Emma's Public Speaking Experience", "Online Photography Course", "Marathon Training Goal", "Volunteering at the Food Bank", "Charity Drive Organization", "Beach Clean-Up Event", "Learning to Ride a Bike", "Taking the Bus", "Driving Lessons Plan", "Trip to Japan", "Ordering at Bella Italia", "First Dance Lesson at the Studio", "Booking a Hotel Room", "At the Grocery Store", "Playing Soccer with Friends", "Meeting at the Café", "Planning a Trip to Paris", "Gardening as a Hobby", "Career Decisions After High School", "Planning an Evening Out", "Volunteering at a Community Event", "Planning a Trip with Friends", "Starting a Cooking Class", "Balancing Work and Personal Life", "Exploring Career Opportunities Abroad", "Navigating Mental Health Challenges", "Embracing Sustainable Living Practices", "The Influence of Social Media on Relationships"]
    titles.each do |title|
      Passage.where(title: titles).update_all(category: :conversation)
    end
  end
end
