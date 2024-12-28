require 'csv'

class Tmp
  def self.translate_passages
    languages = %w[Spanish Korean Japanese Hindi French Italian Portuguese German Russian Mandarin Arabic Vietnamese]

    difficulties = Difficulty.find_by(level: 5)
    passages = Passage.where(difficulty: difficulties, title: "Embracing Sustainable Living Practices").includes(:sentences).limit(1)
    passages.each do |passage|
      languages.each do |lang|
        sentences = passage.sentences.order(:order_idx).pluck(:content, :id)
        language = Language.find_by(name: lang)
        res = PassageTranslatorService.new(sentences: sentences, language: language).call
      end
    end
  end
end
