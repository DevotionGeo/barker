require 'rails_helper'

describe "create a message", js: true do
  let(:message_txt) { "A coeur vaillant, rien d'impossible. Woof! Woof!" }

  it "display the new message on the index page" do
    user = FactoryGirl.create(:user)
    sign_in(user)
    expect(Message.count).to eq(0)
    post(user, message_txt)

    within("#messages-list > ul") do
      expect(page).to have_content(message_txt)
    end

    expect(Message.count).to eq(1)
  end

  it "inserts the new message on top of the messages list" do
    user = FactoryGirl.create(:user_with_posts)
    sign_in(user)
    expect(Message.count).to eq(3)
    post(user, message_txt)

    within("#messages-list > ul :first-child") do
      expect(page).to have_content(message_txt)
    end

    expect(Message.count).to eq(4)
  end
end
