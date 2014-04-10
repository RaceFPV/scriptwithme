class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.string :from
      t.string :title
      t.text :content
      t.boolean :read

      t.timestamps
    end
  end
end
