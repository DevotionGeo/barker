require 'rails_helper'

describe "index page" do
  it "display user's posts sorted by creation date" do
    user = FactoryGirl.create(:user_with_posts);

    sign_in(user)
    messages = user.messages.all.sort { |a, b| b.created_at <=> a.created_at }

    messages.each_index do |i|
      within("#messages-list > ul :nth-child(#{ i + 1 })") do
        expect(page).to have_content(messages[i].content)
      end
    end
  end
end
