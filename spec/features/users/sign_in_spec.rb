require 'rails_helper'

describe "sign in" do
  let!(:user) { FactoryGirl.create(:user) }

  context "with wrong credentials" do
    it "shows a error message if unknown email" do
      sign_in(User.new(email: "smonn@gmail.com", password: user.password))
      expect(page).to have_content("Invalid email or password.")
      within("h2") do
        expect(page).to have_content("Log in")
      end
    end

    it "shows a error message if wrong password" do
      sign_in(User.new(email: user.email, password: "passweird"))
      expect(page).to have_content("Invalid email or password.")
      within("h2") do
        expect(page).to have_content("Log in")
      end
    end
  end

  context "with good credentials" do
    it "redirects messages index page" do
      sign_in(User.new(email: user.email, password: user.password))
      expect(page.current_path).to eq(messages_path)
      expect(page).to have_content("Signed in successfully.")
    end
  end
end
