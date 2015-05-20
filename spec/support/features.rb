module Features
  module SessionHelpers
    def sign_in(user)
      visit "/"
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "Log in"
    end

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

    def post(user, message_txt)
      fill_in "message_content", with: message_txt
      click_button "Post"
    end
  end
end
