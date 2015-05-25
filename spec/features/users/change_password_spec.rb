require 'rails_helper'

describe "change password" do
  let!(:user) { FactoryGirl.create(:user) }

  it "updates user's password" do
    sign_in(user)
    click_link "My account"
    fill_in "user_password", with: "new_password"
    fill_in "user_password_confirmation", with: "new_password"
    fill_in "user_current_password", with: user.password
    click_button "Update"
    expect(page).to have_content("Your account has been updated successfully.")
  end
end
