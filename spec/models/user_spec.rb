require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(User.attribute_names.include? "email").to be true }
  it { should validate_presence_of :email }

  it { expect(User.attribute_names.include? "first_name").to be true }
  it { should validate_presence_of :first_name }
  it { should validate_length_of(:first_name).is_at_least(2) }

  it { expect(User.attribute_names.include? "last_name").to be true }
  it { should validate_presence_of :last_name }
  it { should validate_length_of(:last_name).is_at_least(2) }

  it { expect(User.attribute_names.include? "profile_name").to be true }
  it { should validate_presence_of :profile_name }
  it { should validate_length_of(:profile_name).is_at_least(2) }

  it { should have_many :sent_messages }
  it { should have_many :received_messages }

  it { should have_many :relationships }
  it { should have_many(:friends).through(:relationships) }
end
