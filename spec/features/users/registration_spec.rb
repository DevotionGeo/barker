require 'rails_helper'

describe "Registration" do
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
      expect(page).to have_selector("#message-form")
      expect(page).to have_selector("#message_content")
    end
  end

  context "with an existing email" do
    it "shows error message if user already exists with the same email" do
      FactoryGirl.create(:user)
      expect(User.count).to eq(1)
      register(FactoryGirl.build(:user))
      expect(User.count).to eq(1)
      expect(page).to have_content("Email has already been taken")
      within("h2") do
        expect(page).to have_content("Sign up")
      end
    end
  end
end
