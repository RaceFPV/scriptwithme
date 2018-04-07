class AddTitleAndStarterToScenes < ActiveRecord::Migration[5.1]
  def change
    add_column :scenes, :title, :string
    add_column :scenes, :starter, :text
  end
end
