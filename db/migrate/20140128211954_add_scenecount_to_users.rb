class AddScenecountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :scenecount, :integer
  end
end
