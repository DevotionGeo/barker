class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.boolean :accepted

      t.timestamps
    end
  end
end
