require 'rails_helper'

describe "sign in" do
  def sign_in(user)
    visit "/"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Log in"
  end

  let!(:user) { FactoryGirl.create(:user) }

  context "with wrong credentials" do
    it "shows a error message if unknown email" do
      sign_in(User.new(email: "smonn@gmail.com", password: "password"))
      expect(page).to have_content("Invalid email or password.")
    end

    it "shows a error message if wrong password" do
      sign_in(User.new(email: "smonneger@gmail.com", password: "passweird"))
      expect(page).to have_content("Invalid email or password.")
    end
  end

  context "with good credentials" do
    it "displays messages index page" do
      sign_in(User.new(email: "smonneger@gmail.com", password: "password"))
      expect(page).to have_content("Signed in successfully.")
      expect(page).to have_content("index de message controller")
    end
  end
end
