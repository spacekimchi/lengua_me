class ApplicationController < ActionController::Base
  before_action :set_app_name

  include Clearance::Controller

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
