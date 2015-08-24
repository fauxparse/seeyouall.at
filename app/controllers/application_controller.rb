class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  protected

  def ssl_configured?
    Rails.env.production?
  end

  def event
    nil
  end

  helper_method :event
end
