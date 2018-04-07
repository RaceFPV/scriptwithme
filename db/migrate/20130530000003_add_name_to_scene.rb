class AddNameToScene < ActiveRecord::Migration[5.1]
  def change
    add_column :scenes, :name, :string, :limit => 100
  end
end
