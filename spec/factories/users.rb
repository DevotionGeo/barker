FactoryGirl.define do
  factory :user, aliases: [:author, :receiver] do
    first_name "Sacha"
    last_name "Monneger"
    sequence(:profile_name) { |n| "satch#{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password "password"

      factory :user_with_posts do
        after(:create) { |user| create_list(:message, 3, { author: user, receiver: user }) }
      end
  end
end
