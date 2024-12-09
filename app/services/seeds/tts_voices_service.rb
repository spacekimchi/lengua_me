module Seeds
  class TtsVoicesService
    def self.call
      languages = Constants::LANGUAGE_CODES
      languages.each do |language|
        Language.find_or_create_by(code: language[0], name: language[1])
      end
    end
  end
end
