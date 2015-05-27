class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_user, only: :index

  def index
    @message = current_user.sent_messages.new(author_id: current_user.id, receiver_id: @profile_user.id)
    @messages = @profile_user.received_messages.all.sort { |a, b| b.created_at <=> a.created_at }
  end

  def create
    @message = current_user.sent_messages.new(message_params)
    @has_errors = !@message.save

    respond_to do |format|
      format.js { flash.now[:error] = @message.errors.full_messages.to_sentence }
    end
  end

  private
    def message_params
      params.require(:message).permit(:content, :author_id, :receiver_id)
    end

    def set_profile_user
      if params[:profile_id]
        @profile_user = User.find(params[:profile_id])
      else
        @profile_user = current_user
      end
    end
end
