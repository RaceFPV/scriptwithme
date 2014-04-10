class AddUuidToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :uuid, :string, :limit => 50
  end
end
