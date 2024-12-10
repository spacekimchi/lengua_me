require 'openai'
require 'json'
require 'json-schema'

class PassageTranslatorService
  SCHEMA = {
    type: 'object',
    properties: {
      sentences: {
        type: 'array',
        description: 'An array of sentence translation that make up the passage.',
        items: {
          type: 'string',
          description: 'Translated sentence for the passage'
        }
      }
    },
    additionalProperties: false,
    required: ['sentences']
  }.freeze

  FUNCTION = {
    name: 'generate_passage',
    description: 'Generates a passage containing sentences translated in the target language for practice.',
    parameters: SCHEMA
  }.freeze

  # subject: subject matter for generator
  # grade_level: grade level for the generator
  def initialize(sentences:, language:)
    @client = OpenAI::Client.new
    @model = 'gpt-4' # Correct model name
    @language = language
    @sentences = sentences
  end

  # Public method to execute the service
  def call
    response = request_translation
    sentences = parse_response(response)
    ActiveRecord::Base.transaction do
      sentences.each_with_index do |sentence, idx|
        SentenceTranslation.create!(language: @language, sentence_id: @sentences[idx][1], text: sentence)
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    nil
  end

  private

  # Sends a request to OpenAI's API to generate a passage
  def request_translation
    @client.chat(
      parameters: {
        model: @model,
        messages: [
          {
            role: 'system',
            content: "You are a translator. You will be given a list of sentences separated by new lines. Translate each sentence to #{@language.name}. The translated sentences should also follow the same order and there should be the same number of sentences and translated sentences. It is imperative that all spelling and grammar are correct."

          },
          {
            role: 'user',
            content: @sentences.map { |content, id| content }.join("\n")

          }
        ],
        temperature: 0.8,
        functions: [FUNCTION],
        function_call: { name: 'generate_passage' }
      }
    )
  end

  # Parses the OpenAI API response to extract sentences
  def parse_response(response)
    choice = response.dig('choices', 0, 'message', 'function_call')
    return nil unless choice

    arguments = choice['arguments']
    parsed = JSON.parse(arguments, symbolize_names: true)

    # Validate the parsed response against the SCHEMA
    unless validate_schema(parsed)
      Rails.logger.error("Response does not match the expected schema: #{parsed}")
      return nil
    end

    parsed[:sentences]
  end

  # Validates the response against the predefined SCHEMA using json-schema gem
  def validate_schema(response)
    JSON::Validator.validate!(SCHEMA, response)
  end
end

