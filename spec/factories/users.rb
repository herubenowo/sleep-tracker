FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..8) }
    password { "password" }

    trait :admin do
      username { "admin" }
      password { "admin" }
    end
  end
end
