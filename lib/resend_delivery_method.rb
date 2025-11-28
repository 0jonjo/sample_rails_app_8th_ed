require 'resend'

class ResendDeliveryMethod
  def initialize(options = {})
    raw_key = Rails.application.credentials.dig(:resend, :api_key) || ENV['RESEND_API_KEY']
    # Accept string-like values but reject nil/empty/non-string-like values early with a helpful message
    @api_key = raw_key.respond_to?(:to_str) ? raw_key.to_str : (raw_key.nil? ? nil : raw_key.to_s)
    @api_key = @api_key.strip unless @api_key.nil?
    if @api_key.nil? || @api_key.empty?
      raise "Resend API key not configured or invalid (expected non-empty string). Got: #{raw_key.inspect}"
    end
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
