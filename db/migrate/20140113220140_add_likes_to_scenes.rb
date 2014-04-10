class AddLikesToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :likes, :integer
  end
end
