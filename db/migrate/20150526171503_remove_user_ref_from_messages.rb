class RemoveUserRefFromMessages < ActiveRecord::Migration
  def change
    remove_reference :messages, :user, index: true
  end
end
