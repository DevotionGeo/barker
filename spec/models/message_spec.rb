require 'rails_helper'

RSpec.describe Message, type: :model do
  it { expect(Message.attribute_names.include? "content").to be true }
  it { should validate_presence_of :content }
  it { should belong_to :user }
end
