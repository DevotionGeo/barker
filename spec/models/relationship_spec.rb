require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it { expect(Relationship.attribute_names.include? "accepted").to be true }

  it { should belong_to :user }
  it { should belong_to :friend }
  it { should validate_presence_of :user }
  it { should validate_presence_of :friend }
  #it { should validate_inclusion_of(:accepted).in_array([true, false]) }
  it 'should validate uniqueness of user_id scoped to friend_id' do
     user = FactoryGirl.create(:user)
     friend = FactoryGirl.create(:user)
     FactoryGirl.create(:relationship, user: user, friend: friend)
     should validate_uniqueness_of(:user_id).scoped_to(:friend_id)
  end

  describe ".friends?" do
    it "returns false if no relationship" do
      user_list = FactoryGirl.create_list(:user, 2)
      expect(Relationship.friends?(user_list[0], user_list[1])).to be(false)
      expect(Relationship.friends?(user_list[1], user_list[0])).to be(false)
    end

    it "returns false if pending relationship" do
      user_list = FactoryGirl.create_list(:user, 2)
      FactoryGirl.create(:relationship, user: user_list[0], friend: user_list[1], accepted: false)
      expect(Relationship.friends?(user_list[0], user_list[1])).to be(false)
      expect(Relationship.friends?(user_list[1], user_list[0])).to be(false)
    end

    it "returns true if friends" do
      user_list = FactoryGirl.create_list(:user, 2)
      FactoryGirl.create(:relationship, user: user_list[0], friend: user_list[1], accepted: true)
      expect(Relationship.friends?(user_list[0], user_list[1])).to be(true)
      expect(Relationship.friends?(user_list[1], user_list[0])).to be(true)
    end
  end

  describe ".pending_friends?" do
    it "returns false if no relationship" do
      user_list = FactoryGirl.create_list(:user, 2)
      expect(Relationship.pending_friends?(user_list[0], user_list[1])).to be(false)
      expect(Relationship.pending_friends?(user_list[1], user_list[0])).to be(false)
    end

    it "returns true if pending relationship" do
      user_list = FactoryGirl.create_list(:user, 2)
      FactoryGirl.create(:relationship, user: user_list[0], friend: user_list[1], accepted: false)
      expect(Relationship.pending_friends?(user_list[0], user_list[1])).to be(true)
      expect(Relationship.pending_friends?(user_list[1], user_list[0])).to be(true)
    end

    it "returns false if friends" do
      user_list = FactoryGirl.create_list(:user, 2)
      FactoryGirl.create(:relationship, user: user_list[0], friend: user_list[1], accepted: true)
      expect(Relationship.pending_friends?(user_list[0], user_list[1])).to be(false)
      expect(Relationship.pending_friends?(user_list[1], user_list[0])).to be(false)
    end
  end
end
