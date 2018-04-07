class AddScenecountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :scenecount, :integer
  end
end
