FactoryGirl.define do
  factory :event, aliases: [:tri_wizard] do
    name "Tri-Wizard Tournament"
  end

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
end
