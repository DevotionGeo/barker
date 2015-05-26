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
end
