# Configure Resend delivery method for Action Mailer.
# Reads API key from encrypted credentials at `resend: { api_key: '...' }`
# or from ENV['RESEND_API_KEY'] as a fallback.

require Rails.root.join("lib/resend_delivery_method")

ActionMailer::Base.add_delivery_method :resend, ResendDeliveryMethod
