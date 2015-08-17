class EventForm < SimpleDelegator
  def initialize(event = nil, params = {})
    super event || Event.new

    params.each_pair do |key, value|
      self.public_send :"#{key}=", value
    end
  end

  def event
    __getobj__
  end

  def present
    EventPresenter.new(self)
  end

  def start_date=(value)
    event.start_time = value.present? ? Time.zone.parse(value.to_s) : nil
  end

  def end_date=(value)
    event.end_time = value.present? ? Time.zone.parse(value.to_s) : nil
  end

  def payment_methods=(hash)
    hash.each_pair do |key, options|
      config = event.payment_method_configurations.detect { |c| c.payment_method_name == key.to_s } ||
        event.payment_method_configurations.build(payment_method_name: key.to_s)
      config.enabled = !!options[:enabled]
      config.options = options.except(:enabled)
    end
  end

  def self.permitted_parameters
    [:name, :slug, :start_date, :end_date, payment_method_parameters]
  end

  def self.payment_method_parameters
    configurations = PaymentMethod.all_payment_methods.each_with_object({}) do |klass, hash|
      hash[klass.name.demodulize.underscore] = [:enabled] + klass.new.default_options.keys
    end
    { :payment_methods => configurations }
  end

  def self.wrapped_parameters
    permitted_parameters.flat_map do |param|
      param.try(:keys) || param
    end
  end
end
