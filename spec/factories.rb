FactoryGirl.define do
  factory :user, aliases: [:hermione] do
    name "Hermione Granger"
    email { "#{name.downcase.gsub(/\s+/, ".")}@hogwarts.ac.uk" }
    password "p4ssw0rd"
    password_confirmation "p4ssw0rd"

    factory :harry do
      name "Harry Potter"
    end

    factory :ron do
      name "Ron Weasley"
    end

    factory :dumbledore do
      name "Dumbledore"
    end
  end

  factory :event, aliases: [:tri_wizard] do
    name "Tri-Wizard Tournament"
    start_time Time.zone.parse("1994-10-31 19:00:00")
    end_time Time.zone.parse("1995-06-24 19:00:00")
  end

  factory :activity_type, aliases: [:trial] do
    name "trial"
    association :event, factory: :tri_wizard
  end

  factory :activity, aliases: [:dragon_fighting] do
    name "Dragon Fighting"
    association :activity_type, factory: :trial
  end

  factory :time_slot do
    start_time { Time.current }
    end_time { Time.current + 1.hour }
    association :event, factory: :tri_wizard
  end

  factory :scheduled_activity do
    association :activity, factory: :dragon_fighting
    association :time_slot
  end

  factory :location, aliases: [:hogwarts] do
    address "1 Kent Tce, Wellington"
  end

  factory :package do
    name "Standard"
    association :event, factory: :tri_wizard
  end

  factory :facilitator do
    name "Mad-Eye Moody"
    email "moody@hogwarts.ac.uk"
  end

  factory :registration do
    association :user, factory: :hermione
    association :package
    association :event, factory: :tri_wizard
  end

  factory :room do
    name "Room of Requirement"
    location nil
  end

  factory :payment_method_configuration do
    payment_method_name "internet_banking"
    options account_name: "H Potter", account_number: "01-2345-6789012-34"
    enabled true
    event
  end
end
