FactoryBot.define do
  factory :user do
    trait :admin do
      username { "admin" }
      password { "admin" }
    end

    trait :dummy do
      username { Faker::Internet.unique.username(specifier: 5..8) }
      password { "password" }
    end
  end
end
