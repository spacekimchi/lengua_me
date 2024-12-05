require 'openai'
require 'json'
require 'json-schema'

class PassageGeneratorService
  SCHEMA = {
    type: 'object',
    properties: {
      title: {
        type: 'string',
        description: 'Up to a few words on what the sentences are about. Something more specific than the subject I passed.'
      },
      sentences: {
        type: 'array',
        description: 'An array of sentences that make up the passage.',
        items: {
          type: 'string',
          description: 'Sentence for the passage'
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
  def initialize(subject:, grade_level:, language: 'English', translations: ['Spanish'])
    @client = OpenAI::Client.new
    @model = 'gpt-4' # Correct model name
    @subject = subject
    @grade_level = grade_level
    @translations = translations
  end

  # Public method to execute the service
  def call
    response = request_passage
    parse_response(response)
  end

  private

  # Sends a request to OpenAI's API to generate a passage
  def request_passage
    @client.chat(
      parameters: {
        model: @model,
        messages: [
          {
            role: 'user',
            content: "I am trying to practice my #{@language} conjugations. Give me a passage that uses past tense conjugations for me to read and practice. The sentences should be related to each other and form some sort of situation or story to help learn about using the language in real life while pertaining to this subject:  #{@subject}."

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

