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
    description: 'Generates a passage containing English sentences for practice.',
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
    parse_response(response)
  end

  private

  # Sends a request to OpenAI's API to generate a passage
  def request_translation
    @client.chat(
      parameters: {
        model: @model,
        messages: [
          {
            role: 'user',
            content: "I am giving a list of sentences. I want you to translate each sentence to this language: `#{@language}`. I am trying to use this to learn languages so make sure the translations are accurate and fit in with the overall sentences. The translated sentences should follow the same order and there should be the same amount of translated sentences as original ones. These are the sentences: #{@sentences.to_s}"

          }
        ],
        temperature: 1.2,
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

    parsed
  end

  # Validates the response against the predefined SCHEMA using json-schema gem
  def validate_schema(response)
    JSON::Validator.validate!(SCHEMA, response)
  end
end

