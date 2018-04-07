class AddLikesToScenes < ActiveRecord::Migration[5.1]
  def change
    add_column :scenes, :likes, :integer
  end
end
