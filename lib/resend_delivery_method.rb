require 'resend'

class ResendDeliveryMethod
  def initialize(options = {})
    @api_key = Rails.application.credentials.dig(:resend, :api_key) || ENV['RESEND_API_KEY']
    raise "Resend API key not configured" if @api_key.nil? || @api_key.empty?
    @client = Resend::Client.new(api_key: @api_key)
  end

  # mail is a Mail::Message
  def deliver!(mail)
    to = Array(mail.to)
    from = Array(mail.from).first || Rails.application.credentials.dig(:email, :default_from) || ENV['DEFAULT_FROM_EMAIL']
    subject = mail.subject

    # prefer the HTML part if present
    html_body = if mail.html_part
                  mail.html_part.body.decoded
                else
                  mail.body.decoded
                end

    payload = {
      from: from,
      to: to,
      subject: subject,
      html: html_body
    }

    # Use the Resend client to send email via the Emails API
    @client.emails.send(payload)
  end
end
