Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.enabled = false unless Rails.env.production?

  config.person_username_method = "name"
  config.person_email_method = "email"
end
