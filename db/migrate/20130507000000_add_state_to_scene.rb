class AddStateToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :state, :string, :limit => 10, :default => "waiting"
  end
end
