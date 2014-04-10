class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.text      :content
      t.string      :kind
      t.references  :character
      t.references  :scene
      t.string      :nickname

      t.timestamps
    end

    add_index :lines, :character_id
  end
end
