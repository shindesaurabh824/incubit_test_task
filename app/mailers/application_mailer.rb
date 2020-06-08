class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.SUPPORT_EMAIL
  layout 'mailer'
end
