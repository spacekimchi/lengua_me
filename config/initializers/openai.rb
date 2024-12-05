OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openai, :access_token)
  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
  config.log_errors = Rails.env.production?
end

