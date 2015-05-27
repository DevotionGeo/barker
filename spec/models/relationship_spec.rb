require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it { expect(Relationship.attribute_names.include? "accepted").to be true }

  it { should belong_to :user }
  it { should belong_to :friend }
end
