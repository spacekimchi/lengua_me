require 'openai'
require 'json'
require 'json-schema'

class PassageGeneratorService
  SCHEMA = {
    type: 'object',
    properties: {
      title: {
        type: 'string',
        description: 'Up to a few words on what the sentences are about. Something more specific than the topic I passed.'
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
    required: ['sentences', 'title']
  }.freeze

  FUNCTION = {
    name: 'generate_passage',
    description: 'Generates a passage containing English sentences for practice.',
    parameters: SCHEMA
  }.freeze

  # difficulty: difficulty level for the generator
  # language: sentence language
  def initialize(difficulty:, language: 'English')
    @client = OpenAI::Client.new
    @model = 'gpt-4o-mini-2024-07-18' # Correct model name
    @difficulty = difficulty
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
            content: "TODO"
          }
        ],
        temperature: 1.2,
        functions: [FUNCTION],
        function_call: { name: 'generate_passage' }
      }
    )


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

    parsed
  end

  # Validates the response against the predefined SCHEMA using json-schema gem
  def validate_schema(response)
    JSON::Validator.validate!(SCHEMA, response)
  end
end

