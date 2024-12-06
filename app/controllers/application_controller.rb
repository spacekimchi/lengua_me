class ApplicationController < ActionController::Base
  include Clearance::Controller

  helper_method :super_admin?

  def super_admin?
    current_user&.super_admin?
  end

  def deurlify(urlified_string)
    urlified_string.tr('-', ' ')
  end
end
