class UserMailer < ApplicationMailer
  default from: 'jin@basedlingo.com'

  def send_verification_email(user)
    @user = user
    return if @user.verified?
    @user.generate_verification_token
    @url  = edit_verification_url(@user.verification_token)
    mail(from: 'welcome@basedlingo.com', to: @user.email, subject: 'Account Verification')
  end
end
