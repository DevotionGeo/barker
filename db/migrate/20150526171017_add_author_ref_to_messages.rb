class AddAuthorRefToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :author, index: true
  end
end
