class ApplicationMailer < ActionMailer::Base
  default from: "Rails Girls Kraków <#{Rails.application.secrets.mandrill['sender_email']}>"
  layout 'mailer'
end
