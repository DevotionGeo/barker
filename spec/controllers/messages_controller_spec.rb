require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  it { should use_before_action(:authenticate_user!) }
  it { should use_before_action(:set_profile_user) }

  describe "GET #index" do
    context "with no user signed in" do
      it "redirects to sign in page" do
        get :index
        expect(response).to redirect_to(controller: "devise/sessions", action: "new")
      end
    end

    context "with a signed in user and no profile_id passed" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it "renders :index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns @profile_user with current_user" do
        get :index
        expect(assigns(:profile_user).id).to eq(@user.id)
      end

      it "assigns @message author_id with current user" do
        get :index
        expect(assigns(:message)).to be_a_new(Message)
        expect(assigns(:message).author_id).to eq(@user.id)
      end

      it "assigns @message receiver_id with current user" do
        get :index
        expect(assigns(:message)).to be_a_new(Message)
        expect(assigns(:message).receiver_id).to eq(@user.id)
      end

      it "assigns @messages with received messages of current_user" do
        messages = []
        messages.unshift(@user.received_messages.create(content: "il etait une fois", author_id: @user.id, receiver_id: @user.id))
        messages.unshift(@user.received_messages.create(content: "J'aime RoR", author_id: @user.id, receiver_id: @user.id))
        messages.unshift(@user.received_messages.create(content: "Steph Curry is the man!!!!!", author_id: @user.id, receiver_id: @user.id))
        get :index, profile_id: @user.id
        expect(assigns(:messages)).to eq(messages)
      end
    end

    shared_context "no/pending relationship" do
      it "renders :index template" do
        get :index, profile_id: @user2.id
        expect(response).to render_template(:index)
      end

      it "assigns @profile_user with the user having the passed profile_id" do
        get :index, profile_id: @user2.id
        expect(assigns(:profile_user).id).to eq(@user2.id)
      end

      it "doesn't assign @message" do
        get :index, profile_id: @user2.id
        expect(assigns(:message)).to be_nil
      end

      it "doesn't assign @messages" do
        messages = []
        messages.unshift(@user2.received_messages.create(content: "il etait une fois", author_id: @user2.id, receiver_id: @user2.id))
        messages.unshift(@user2.received_messages.create(content: "J'aime RoR", author_id: @user2.id, receiver_id: @user2.id))
        messages.unshift(@user2.received_messages.create(content: "Steph Curry is the man!!!!!", author_id: @user2.id, receiver_id: @user2.id))
        get :index, profile_id: @user2.id
        expect(assigns(:messages)).to be_nil
      end
    end

    context "with a signed in user and passed profile_id is not a friend" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it_behaves_like "no/pending relationship"
    end

    context "with a signed_in user and passed profile_id is a pending friend" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        FactoryGirl.create(:relationship, user: @user, friend: @user2, accepted: false)
        sign_in(@user)
      end

      it_behaves_like "no/pending relationship"
    end

    context "with a signed_in user and passed profile_id is a friend" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        FactoryGirl.create(:relationship, user: @user, friend: @user2, accepted: true)
        sign_in(@user)
      end

      it "renders :index template" do
        get :index, profile_id: @user2.id
        expect(response).to render_template(:index)
      end

      it "assigns @profile_user with the user having the passed profile_id" do
        get :index, profile_id: @user2.id
        expect(assigns(:profile_user).id).to eq(@user2.id)
      end

      it "assigns @message" do
        get :index, profile_id: @user2.id
        expect(assigns(:message).author_id).to eq(@user.id)
        expect(assigns(:message).receiver_id).to eq(@user2.id)
      end

      it "assigns @messages with received messages of @profile_user" do
        messages = []
        messages.unshift(@user2.received_messages.create(content: "il etait une fois", author_id: @user2.id, receiver_id: @user2.id))
        messages.unshift(@user2.received_messages.create(content: "J'aime RoR", author_id: @user2.id, receiver_id: @user2.id))
        messages.unshift(@user2.received_messages.create(content: "Steph Curry is the man!!!!!", author_id: @user2.id, receiver_id: @user2.id))
        get :index, profile_id: @user2.id
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
        @user2 = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it "creates a message if author and receiver are the same person" do
        expect {
          xhr :post, :create, { message: { content: "Le contenu de mon message.", author_id: @user.id, receiver_id: @user.id }}
        }.to change{ @user.received_messages.count }.by(1)
      end

      it "creates a message if author and receiver are friends" do
        FactoryGirl.create(:relationship, user: @user, friend: @user2, accepted: true)
        expect {
          xhr :post, :create, { message: { content: "Le contenu de mon message.", author_id: @user.id, receiver_id: @user2.id }}
        }.to change{ @user2.received_messages.count }.by(1)
      end

      it "doesn't create a message if author and receiver are not friends" do
        expect {
          xhr :post, :create, { message: { content: "Le contenu de mon message.", author_id: @user.id, receiver_id: @user2.id }}
        }.to change{ @user2.received_messages.count }.by(0)
      end

      it "doesn't create a message if author and receiver are pending friends" do
        FactoryGirl.create(:relationship, user: @user, friend: @user2, accepted: false)
        expect {
          xhr :post, :create, { message: { content: "Le contenu de mon message.", author_id: @user.id, receiver_id: @user2.id }}
        }.to change{ @user2.received_messages.count }.by(0)
      end
    end
  end
end
