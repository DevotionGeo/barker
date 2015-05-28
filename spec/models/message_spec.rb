require 'rails_helper'

RSpec.describe Message, type: :model do
  it { expect(Message.attribute_names.include? "content").to be true }
  it { expect(Message.attribute_names.include? "author_id").to be true }
  it { expect(Message.attribute_names.include? "receiver_id").to be true }
  it { should validate_presence_of :content }
  it { should validate_presence_of :author }
  it { should validate_presence_of :receiver }
  it { should belong_to :author }
  it { should belong_to :receiver }

  describe "before_save validation" do
    let(:user_list) { FactoryGirl.create_list(:user, 2) }

    it "doesn't save messages if author and receiver are not friends" do
      message = Message.new(content: "my content", author_id: user_list[0].id, receiver_id: user_list[1].id)
      message.save
      expect(message.errors[:base]).to include("Author and receiver of the message must be friends or the same person")
      expect(Message.count).to eq(0)
    end

    it "doesn't save messages if author and receiver are pending friends" do
      Relationship.create(user: user_list[0], friend: user_list[1], accepted: false)
      message = Message.new(content: "my content", author_id: user_list[0].id, receiver_id: user_list[1].id)
      message.save
      expect(message.errors[:base]).to include("Author and receiver of the message must be friends or the same person")
      expect(Message.count).to eq(0)
    end

    it "saves messages if author and receiver are friends" do
      Relationship.create(user: user_list[0], friend: user_list[1], accepted: true)
      message = Message.new(content: "my content", author_id: user_list[0].id, receiver_id: user_list[1].id)
      message.save
      expect(Message.count).to eq(1)
    end

    it "saves messages if author and receiver are the same person" do
      message = Message.new(content: "my content", author_id: user_list[0].id, receiver_id: user_list[0].id)
      message.save
      expect(Message.count).to eq(1)
    end
  end
end
