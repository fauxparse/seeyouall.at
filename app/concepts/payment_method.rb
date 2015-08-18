class PaymentMethod
  include ActiveModel::Validations

  attr_reader :enabled, :options

  def initialize(enabled = false, options = {})
    @enabled = enabled
    @options = options
  end

  def enabled?
    !!enabled
  end

  def method_missing(method, *args)
    _, option, punc = method.to_s.match(/^([^\?=]+)([\?=])?$/).to_a
    if default_options.key?(option)
      if punc == "?"
        get_option_or_default(option).present?
      elsif punc == "="
        options[option] = args.first
      else
        get_option_or_default(option)
      end
    else
      super
    end
  end

  def get_option_or_default(option)
    options[option] || default_options[option]
  end

  def default_options
    {}
  end

  def self.all_payment_methods
    [InternetBanking]
  end

  def self.payment_method_instance(class_name, enabled = false, options = {})
    const_get(class_name.classify).new(enabled, options)
  end
end
