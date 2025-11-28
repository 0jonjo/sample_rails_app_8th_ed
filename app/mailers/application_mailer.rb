class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:email, :default_from) || ENV.fetch("DEFAULT_FROM_EMAIL", "user@realdomain.com")
  layout "mailer"
end
