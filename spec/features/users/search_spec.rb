require 'rails_helper'

describe "search friends" do
  before(:each){
    sign_in(FactoryGirl.create(:user))
  }

  it "returns nothing if no match" do
    fill_in "search", with: "Batman"
    click_button "search-btn"
    expect(find('ul.search-list')).to have_selector('li', count: 0)

    within("h3") do
      expect(page).to have_content("0 results")
    end
  end

  it "returns a list of matching results" do
    results = FactoryGirl.create_list(:user, 3, first_name: "Smith" )
    results.concat(FactoryGirl.create_list(:user, 2, last_name: "Smith" ))
    results.concat(FactoryGirl.create_list(:user, 1, profile_name: "Smiters" ))
    FactoryGirl.create(:user, profile_name: "Superman" )
    FactoryGirl.create(:user, profile_name: "Sam" )

    fill_in "search", with: "Smi"
    click_button "search-btn"
    expect(find('ul.search-list')).to have_selector('li', count: 6)

    within("h3") do
      expect(page).to have_content("6 results")
    end

    within("ul.search-list") do
      expect(page).to have_content("Smith Monneger aka satch")
      expect(page).to have_content("Sacha Smith aka satch")
      expect(page).to have_content("Sacha Monneger aka Smiters")
    end
  end
end
