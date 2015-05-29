require 'rails_helper'

describe "send friend request" do

  before(:each){
    @users_list = FactoryGirl.create_list(:user, 2)
    @users_list[1].received_messages.create(
      content: "I love RoR",
      author: @users_list[1],
      receiver: @users_list[1])
    sign_in(@users_list[0])
  }

  it "creates a pending relationship between current_user and selected user" do
    fill_in "search", with: @users_list[1].profile_name
    click_button "search-btn"
    click_link profile_header_name(@users_list[1])
    within("h4") do
      expect(page).to have_content(profile_header_name(@users_list[1]))
    end
    click_link "Send a friend request"
    within("#flash") do
      expect(page).to have_content("Friend request sent to #{@users_list[1].profile_name}")
    end
    within("#messages-list") do
      expect(page).not_to have_content("I love RoR")
    end
  end

  it "displays message saying 'already friend' if selected user is a pending friend" do
    FactoryGirl.create(:relationship, user: @users_list[0], friend: @users_list[1], accepted: false)
    fill_in "search", with: @users_list[1].profile_name
    click_button "search-btn"
    click_link profile_header_name(@users_list[1])
    expect(page).to have_content("You have already sent a friend request to #{@users_list[1].profile_name}")
    expect(page).not_to have_css("#messages-list")
  end

  it "displays selected user profile if he is a friend" do
    FactoryGirl.create(:relationship, user: @users_list[0], friend: @users_list[1], accepted: true)
    fill_in "search", with: @users_list[1].profile_name
    click_button "search-btn"
    click_link profile_header_name(@users_list[1])
    within("#messages-list") do
      expect(page).to have_content("I love RoR")
    end
  end

  def profile_header_name(user)
    user.first_name + " " + user.last_name + " aka " + user.profile_name
  end
end
