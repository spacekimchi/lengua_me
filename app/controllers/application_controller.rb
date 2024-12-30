class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Clearance::Controller
  include HttpAcceptLanguage::AutoLocale

  before_action :set_app_name
  before_action :set_locale

  helper_method :super_admin?

  def super_admin?
    current_user&.super_admin?
  end

  def deurlify(urlified_string)
    urlified_string.tr('-', ' ')
  end

  private

  def set_locale
    I18n.locale = if params[:locale].present?
                    params[:locale]
                  else
                    # http_accept_language helper picks the best match
                    http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
                  end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_app_name
    @app_name = 'BasedLingo'
  end
end
