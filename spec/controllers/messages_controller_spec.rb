require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }

  describe "GET #index" do
    context "with no user signed in" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to(controller: "devise/sessions", action: "new")
      end
    end

    context "with signed in user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it "renders :index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns @message for current user" do
        get :index
        expect(assigns(:message)).to be_a_new(Message)
        expect(assigns(:message).user.id).to eq(@user.id)
      end

      it "assigns @messages sorted by creation date for current user" do
        messages = []
        messages.unshift(@user.messages.create(content: "il etait une fois"))
        messages.unshift(@user.messages.create(content: "J'aime RoR"))
        messages.unshift(@user.messages.create(content: "Steph Curry is the man!!!!!"))
        get :index
        expect(assigns(:messages)).to eq(messages)
      end
    end
  end

  describe "POST #create" do
    context "with no user signed in" do
      it "sends an unauthorized response" do
        xhr :post, :create, { message: { content: "Le contenu de mon message." }}
        expect(Message.count).to eq(0)
        expect(response).to have_http_status(401) #Unauthorized
      end
    end

    context "with signed in user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it "creates a message for current user" do
        expect {
          xhr :post, :create, { message: { content: "Le contenu de mon message." }}
        }.to change{ @user.messages.count }.by(1)
      end
    end
  end
end
