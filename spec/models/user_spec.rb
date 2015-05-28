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

  describe "#is_allowed_to_see_profile" do
    it "returns false if passed user is nil" do
      user = FactoryGirl.create(:user)
      expect(user.is_allowed_to_see_profile(nil)).to be(false)
    end

    it "returns false if there is no relationship with passed user" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      expect(user.is_allowed_to_see_profile(user2)).to be(false)
      expect(user2.is_allowed_to_see_profile(user)).to be(false)
    end

    it "returns false if there is a pending/non accepted relationship with passed user" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      FactoryGirl.create(:relationship, user: user, friend: user2, accepted: false)
      expect(user.is_allowed_to_see_profile(user2)).to be(false)
      expect(user2.is_allowed_to_see_profile(user)).to be(false)

    end

    it "return true if there is a accepted relationship with passed user" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      FactoryGirl.create(:relationship, user: user, friend: user2, accepted: true)
      expect(user.is_allowed_to_see_profile(user2)).to be(true)
      expect(user2.is_allowed_to_see_profile(user)).to be(true)

    end

    it "returns true if passed user is self" do
      user = FactoryGirl.create(:user)
      expect(user.is_allowed_to_see_profile(user)).to be(true)
    end
  end
end
