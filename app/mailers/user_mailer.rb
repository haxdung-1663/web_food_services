class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: (t "mailer.user_mailer.account_activation")
  end

  def order_mail user
    @user = user
    mail to: @user.email, subject: "order detail"
  end

  def password_reset
    @greeting = "Hi"

      mail to: "to@example.org"
  end
end