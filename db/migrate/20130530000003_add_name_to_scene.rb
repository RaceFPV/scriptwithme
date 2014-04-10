class AddNameToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :name, :string, :limit => 100
  end
end
