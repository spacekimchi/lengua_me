class VerificationsController < ApplicationController
  def edit
    user = User.find_by(verification_token: params[:verification_token])

    if user && !user.verified?
      user.complete_verification
      sign_in user
      redirect_to root_url, notice: t('controllers.verifications.edit.success')
    else
      redirect_to sign_in_path, alert: t('controllers.verifications.edit.error')
    end
  end
end

