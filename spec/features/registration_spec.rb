require 'rails_helper'

describe "Registration" do

  it "creates a new user if he doesn't exist" do
    expect(User.count).to eq(0)
    visit "/"
    click_link "Sign up"
    fill_in "user_first_name", with: "Sacha"
    fill_in "user_last_name", with: "Monneger"
    fill_in "user_profile_name", with: "satch"
    fill_in "user_email", with: "smonneger@gmail.com"
    fill_in "user_password", with:"password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"
    expect(User.count).to eq(1)
  end

  it "shows error message if user already exists with the same email" do
    User.create(
      first_name: "Omar",
      last_name: "Sy",
      profile_name: "omar",
      email:"smonneger@gmail.com",
      password: "password",
      password_confirmation: "password")
    expect(User.count).to eq(1)
    visit "/"
    click_link "Sign up"
    fill_in "user_first_name", with: "Sacha"
    fill_in "user_last_name", with: "Monneger"
    fill_in "user_profile_name", with: "satch"
    fill_in "user_email", with: "smonneger@gmail.com"
    fill_in "user_password", with:"password"
    fill_in "user_password_confirmation", with: "password"
    click_button "Sign up"
    expect(User.count).to eq(1)
    expect(page).to have_content("Email has already been taken")
  end
end
