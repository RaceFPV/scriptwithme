class CreateStarters < ActiveRecord::Migration[5.1]
  def change
    create_table :starters do |t|
      t.text        :content
      t.string      :title
      t.references  :scene

      t.timestamps
    end
  end
end
