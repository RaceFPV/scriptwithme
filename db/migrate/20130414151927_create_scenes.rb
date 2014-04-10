class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string :users
      t.timestamps
    end
  end
end
