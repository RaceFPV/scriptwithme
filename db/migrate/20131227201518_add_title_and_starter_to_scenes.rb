class AddTitleAndStarterToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :title, :string
    add_column :scenes, :starter, :text
  end
end
