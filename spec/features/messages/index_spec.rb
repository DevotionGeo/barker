require 'rails_helper'

describe "index page" do
  before(:each) do
    @user = FactoryGirl.create(:user_with_posts)
    sign_in(@user)
    @messages = @user.received_messages.all.sort { |a, b| b.created_at <=> a.created_at }
  end

  it "displays user's posts sorted by creation date" do
    @messages.each_index do |i|
      within("#messages-list ul li:nth-child(#{ i + 1 })") do
        expect(page).to have_content(@messages[i].content)
      end
    end
  end

  it "displays user's profile name for each message" do
    @messages.each_index do |i|
      within("#messages-list ul li:nth-child(#{ i + 1 })") do
        expect(page).to have_content(@user.profile_name)
      end
    end
  end

  it "displays passed time since the message has been posted" do
    @messages.each_index do |i|
      within("#messages-list ul li:nth-child(#{ i + 1 })") do
        expect(page).to have_content(time_ago_in_words((@messages[i].created_at)))
      end
    end
  end
end
