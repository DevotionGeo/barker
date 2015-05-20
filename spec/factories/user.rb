FactoryGirl.define do
  factory :user do
    first_name "Sacha"
    last_name "Monneger"
    profile_name "satch"
    email "smonneger@gmail.com"
    password "password"

    factory :user_with_posts do
      after(:create) { |user| create_list(:message, 3, user: user) }
    end
  end
end
