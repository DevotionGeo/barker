class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    relationship = Relationship.new(relationship_params)

    if relationship.save
      flash[:notice] = "Friend request sent to #{relationship.friend.profile_name}"
    else
      flash[:alert] = relationship.errors.full_messages.to_sentence
    end

    redirect_to root_path
  end

  private
  def relationship_params
    params.require(:relationship).permit(:user_id, :friend_id, :accepted)
  end
end
