RSpec::Matchers.define :assign do |attribute|
  match do |record|
    assigns(attribute).present? &&
      (!@klass.present? || assigns(attribute).instance_of?(@klass))
  end

  chain :as do |klass|
    @klass = klass
  end

  failure_message do |record|
    "expected #{record} to assign #{attribute}#{" as #{@klass}" if @klass.present?}"
  end
end
