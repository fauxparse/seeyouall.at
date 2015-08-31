class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  rescue_from CanCan::AccessDenied do |exception|
    if Rails.env.test?
      raise exception
    else
      redirect_to root_url, :alert => exception.message
    end
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
