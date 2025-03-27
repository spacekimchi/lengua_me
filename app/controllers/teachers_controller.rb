class TeachersController < ApplicationController
  def index
  end

  private

  def require_teacher
    redirect_to root_path unless current_user&.teacher? || current_user&.super_admin?
  end
end
