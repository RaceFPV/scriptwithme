class CreateQueueconnects < ActiveRecord::Migration
  def change
    create_table :queueconnects do |t|
      t.integer :userid
      t.text :name
      t.integer :userrating
      t.integer :desiredrating
      t.boolean :guest

      t.timestamps
    end
  end
end
