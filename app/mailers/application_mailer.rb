class ApplicationMailer < ActionMailer::Base
  default from: "Rails Girls Kraków <#{Rails.application.secrets.mandrill.fetch('sender_email')}>"
  layout 'mailer'
end
