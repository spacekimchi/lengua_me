class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Clearance::Controller

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
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_app_name
    @app_name = 'BasedLingo'
  end
end
