class AddUserAndFriendRefToRelationships < ActiveRecord::Migration
  def change
    add_reference :relationships, :user, index: true
    add_reference :relationships, :friend, index: true
  end
end
