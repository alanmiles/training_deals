class UserMailer < ActionMailer::Base
  default from: "admin@hroomph.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #

  def password_reset(user)
    @user = user
    mail :to => recipient(user.email), subject: "Password Reset"
  end

  private

    def recipient(email_address)
      return 'alanpqs@gmail.com' if Rails.env.development?
      email_address
    end

end
