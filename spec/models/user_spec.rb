require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(User.attribute_names.include? "email").to be true }
  it { expect(User.attribute_names.include? "first_name").to be true }
  it { expect(User.attribute_names.include? "last_name").to be true }
  it { expect(User.attribute_names.include? "profile_name").to be true }
end
