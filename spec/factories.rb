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

  factory :activity do
    name "Dragon Fighting"
  end

  factory :time_slot do
    start_time { Time.current }
    end_time { Time.current + 1.hour }
    event
  end
end
