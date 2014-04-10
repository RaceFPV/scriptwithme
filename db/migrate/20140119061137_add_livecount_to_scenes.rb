class AddLivecountToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :livecount, :integer
  end
end
