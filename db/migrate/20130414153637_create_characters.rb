class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :characters do |t|
      t.string      :nickname
      t.references  :scene

      t.timestamps
    end
  end
end
