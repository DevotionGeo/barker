require 'rails_helper'

describe "Registration" do

  def register(user)
    visit "/"
    click_link "Sign up"
    fill_in "user_first_name", with: user.first_name
    fill_in "user_last_name", with: user.last_name
    fill_in "user_profile_name", with: user.profile_name
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password
    click_button "Sign up"
  end

  context "with a new email" do
    it "creates a new user if he doesn't exist" do
      expect(User.count).to eq(0)
      register(FactoryGirl.build(:user))
      expect(User.count).to eq(1)
    end

    it "shows messages index page" do
      expect(User.count).to eq(0)
      register(FactoryGirl.build(:user))
      expect(User.count).to eq(1)
      expect(page).to have_content("Welcome! You have signed up successfully.")
      expect(page).to have_content("index de message controller")
    end
  end

  context "with an existing email" do
    it "shows error message if user already exists with the same email" do
      FactoryGirl.create(:user)
      expect(User.count).to eq(1)
      register(FactoryGirl.build(:user))
      expect(User.count).to eq(1)
      expect(page).to have_content("Email has already been taken")
    end
  end
end
