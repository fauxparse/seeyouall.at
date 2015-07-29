RSpec::Matchers.define :strip_spaces_from do |attribute|
  match do |record|
    value = record.send(attribute)
    record.send(:"#{attribute}=", " #{value} ")
    record.valid? && record.send(attribute) == value
  end

  failure_message do |record|
    "expected whitespace to be stripped from #{attribute}"
  end
end
