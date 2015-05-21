class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message = current_user.messages.new
    @messages = current_user.messages.all.sort { |a, b| b.created_at <=> a.created_at }
  end

  def create
    @message = current_user.messages.new(message_params)
    @has_errors = !@message.save

    respond_to do |format|
      format.js { flash.now[:error] = @message.errors.full_messages.to_sentence }
    end
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
