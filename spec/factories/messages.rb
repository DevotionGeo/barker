FactoryGirl.define do
  sequence(:content) { |n| "Mon message numero #{n}" }

  factory :message do
    content
    author
    receiver
  end
end
