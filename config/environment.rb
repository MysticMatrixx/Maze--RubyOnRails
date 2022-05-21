# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  password: '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', # This is the secret sendgrid API key which was issued during API key creation
  domain: 'yourdomain.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
