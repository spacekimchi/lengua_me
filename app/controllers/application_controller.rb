class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Clearance::Controller

  before_action :set_app_name

  helper_method :super_admin?

  def super_admin?
    current_user&.super_admin?
  end

  def deurlify(urlified_string)
    urlified_string.tr('-', ' ')
  end

  private

  def set_app_name
    @app_name = 'BasedLingo'
  end
end
