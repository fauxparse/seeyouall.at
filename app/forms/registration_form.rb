class RegistrationForm < SimpleDelegator
  alias_method :registration, :__getobj__

  extend ActiveModel::Naming

  def initialize(event, user, params = {})
    super event.registrations.find_or_initialize_by(user: user || User.new)

    sanitize(params).each_pair do |key, value|
      self.public_send :"#{key}=", value
    end
  end

  def packages
    event.packages.map { |p| PackagePresenter.new(p) }
  end

  def user
    @user ||= UserPresenter.new(registration.user)
  end

  def user=(params)
    user.attributes = params
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self).tap do |errors|
      [registration, user].each do |model|
        model.errors.each { |key, msg| errors[key] = msg }
      end
      errors.delete(:user)
    end
  end

  protected

  def sanitize(params)
    return params if params.empty?
    params.require(:registration).permit(*permitted_attributes)
  end

  def permitted_attributes
    [:package_id].tap do |attrs|
      if user.new_record?
        attrs << { user: [:name, :email, :password, :password_confirmation] }
      end
    end
  end
end
