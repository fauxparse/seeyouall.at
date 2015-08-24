Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.person_username_method = "name"
  config.person_email_method = "email"
end
