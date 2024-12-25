class PassageProgressesController < ApplicationController
  before_action :require_login

  def update_progress
    passage = Passage.find(params[:passage_id])
    passage_progress = PassageProgress.find_or_create_by(passage: passage, user: current_user)
    respond_to do |format|
      if passage_progress.update(current_index: params[:current_index])
        status_code = passage_progress.previous_changes.key?(:id) ? :created : :ok
        format.json { render json: { message: 'Passage progress updated!' }, status: status_code }
      else
        format.json { render json: { message: 'Failed to update progress!' }, status: :unprocessable_entity }
      end
      format.html { redirect_back fallback_location: :passages_path, status: :ok }
    end
  rescue StandardError => e
    respond_to do |format|
      format.json { render json: { error: "Internal server error" }, status: :internal_server_error }
      format.html { redirect_back fallback_location: :passages_path, status: :internal_server_error }
    end
  end
end
