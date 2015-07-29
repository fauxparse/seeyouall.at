class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
