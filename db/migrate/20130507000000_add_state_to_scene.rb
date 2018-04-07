class AddStateToScene < ActiveRecord::Migration[5.1]
  def change
    add_column :scenes, :state, :string, :limit => 10, :default => "waiting"
  end
end
