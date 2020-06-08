# frozen_string_literal: true

# User Mailer
class UserMailer < ApplicationMailer
  def welcome_user(email)
    @body = t('mailer.user.welcome_email.body', email: email)
    mail(to: email, subject: t('mailer.user.welcome_email.subject'))
  end

  def reset_password(email)
    @user = User.find_by(email: email)
    mail(to: email, subject: t('mailer.user.reset_password.subject'))
  end
end
