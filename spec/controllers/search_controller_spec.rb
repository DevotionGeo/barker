require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  describe "GET :index" do
    context "with no user signed in" do
      it "redirects to sign in page" do
        get :index, search: "Sacha"
        expect(response).to redirect_to(controller: "devise/sessions", action: "new")
      end
    end

    context "with signed in user" do
      before(:each){
        sign_in(FactoryGirl.create(:user))
      }

      it "renders :index template" do
        get :index, search: "Sacha"
        expect(response).to render_template(:index)
      end

      it "assigns @users with results of the search" do
        built_users_ok = FactoryGirl.create_list(:user, 4, first_name: "Eric")
        built_users_ko = FactoryGirl.create_list(:user, 3, first_name: "Vincent")
        get :index, search: "Eric"
        expect(assigns(:users)).to eq(built_users_ok)
      end
    end
  end
end
