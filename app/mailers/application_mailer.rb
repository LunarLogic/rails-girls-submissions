class ApplicationMailer < ActionMailer::Base
  default from: "Rails Girls Kraków <#{ENV['SENDER_EMAIL']}>"
  layout 'mailer'
end
