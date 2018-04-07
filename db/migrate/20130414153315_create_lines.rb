class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.text      :content
      t.string      :kind
      t.references  :character
      t.references  :scene
      t.string      :nickname

      t.timestamps
    end
  end
end
