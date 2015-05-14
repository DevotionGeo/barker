require 'rails_helper'

describe "Registration" do
  visit "/"
  fill_in "user_first_name", with: "Sacha"
  fill_in "user_last_name", with: "Monneger"
  fill_in "user_profile_name", with: "satch"
  fill_in "user_email", with: "smonneger@gmail.com"
  fill_in "user_password", with:"password"
  fill_in "user_password_confirmation", with: "password"
end
