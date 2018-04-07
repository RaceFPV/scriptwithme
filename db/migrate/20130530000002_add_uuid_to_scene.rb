class AddUuidToScene < ActiveRecord::Migration[5.1]
  def change
    add_column :scenes, :uuid, :string, :limit => 50
  end
end
