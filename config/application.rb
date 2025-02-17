require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LenguaMe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.action_mailer.default_url_options = { host: "basedlingo.com" }

    config.generators do |g|
      # These will create a stub for a model when a new one is generated
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.i18n.available_locales = [:en, :es, :ko, :"zh-CN", :"zh-HK", :vi, :ja, :hi, :it, :fr, :pt, :de, :ru]
    config.i18n.default_locale = :en

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
