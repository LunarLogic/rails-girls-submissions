class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.contact_email
  layout 'mailer'
end
