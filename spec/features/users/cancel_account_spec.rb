require 'rails_helper'

describe "cancel account" do
  before(:each) do
    sign_in(FactoryGirl.create(:user))
    click_link "My account"
  end

  it "deletes user" do
    expect{ click_button "Cancel my account" }.to change { User.count }.from(1).to(0)
  end

  it "redirects to login page" do
    click_button "Cancel my account"
    expect(page.current_path).to eq(root_path)
  end
end
