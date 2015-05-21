require 'rails_helper'

describe "sign_out" do
  it "redirects to sign_in page" do
    sign_in(FactoryGirl.create(:user))
    click_link "Sign out"
    expect(page).to have_content("Signed out successfully.")
    within("h2") do
      expect(page).to have_content("Log in")
    end
  end
end
