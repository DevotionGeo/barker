require 'rails_helper'

describe "sign in" do
  let!(:user) { FactoryGirl.create(:user) }

  context "with wrong credentials" do
    it "shows a error message if unknown email" do
      sign_in(User.new(email: "smonn@gmail.com", password: "password"))
      expect(page).to have_content("Invalid email or password.")
      within("h2") do
        expect(page).to have_content("Log in")
      end
    end

    it "shows a error message if wrong password" do
      sign_in(User.new(email: "smonneger@gmail.com", password: "passweird"))
      expect(page).to have_content("Invalid email or password.")
      within("h2") do
        expect(page).to have_content("Log in")
      end
    end
  end

  context "with good credentials" do
    it "redirects messages index page" do
      sign_in(User.new(email: "smonneger@gmail.com", password: "password"))
      expect(page).to have_content("Signed in successfully.")
      expect(page).to have_selector("#message-form")
      expect(page).to have_selector("#message_content")
    end
  end
end
