class PaymentMethodConfiguration < ActiveRecord::Base
  belongs_to :event, inverse_of: :payment_method_configurations

  serialize :options, JSON

  validate :validate_options

  def payment_method
    @payment_method ||= PaymentMethod.payment_method_instance(payment_method_name, enabled?, options)
  end

  def options=(new_options)
    options.merge!(new_options.stringify_keys)
  end

  protected

  def validate_options
    if enabled?
      payment_method.validate
      payment_method.errors.each { |attr, message| errors.add(attr, message) }
    end
  end
end
