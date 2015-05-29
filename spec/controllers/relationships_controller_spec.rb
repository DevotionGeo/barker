require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  describe "GET #create" do
    before(:each) {
     @users_list = FactoryGirl.create_list(:user, 2)
     @params =
      { relationship:
        { user_id: @users_list[0],
          friend_id: @users_list[1],
          accepted: false }}
    }

    context "with no user signed in" do
      it "redirects to sign in page" do
        post :create, @params
        expect(response).to redirect_to(controller: "devise/sessions", action: "new")
      end
    end

    context "with user signed in" do
      it "creates a pending relationship" do
        sign_in(@users_list[0])
        expect { post :create, @params }.to change { @users_list[0].relationships.count }.from(0).to(1)
        expect(@users_list[0].relationships[0].accepted).to be(false)
      end

      it "redirects to root_path" do
        sign_in(@users_list[0])
        expect(post :create, @params).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Friend request sent to #{@users_list[1].profile_name}")
      end
    end
  end
end
