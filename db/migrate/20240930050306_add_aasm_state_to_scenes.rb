class AddAasmStateToScenes < ActiveRecord::Migration[7.2]
  def change
    add_column :scenes, :aasm_state, :string
  end
end
