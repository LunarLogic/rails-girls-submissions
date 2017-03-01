class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.mailchimp["contact_email"]
  layout 'mailer'
end
