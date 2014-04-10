class CreateStarters < ActiveRecord::Migration
  def change
    create_table :starters do |t|
      t.text        :content
      t.string      :title
      t.references  :scene

      t.timestamps
    end

    add_index :starters, :scene_id
  end
end
