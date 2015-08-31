class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def ssl_configured?
    ENV["SSL"].present?
  end

  def event
    nil
  end

  helper_method :event
end
