class MoveLinesToText < ActiveRecord::Migration[5.1]
  def change
    change_column :lines, :content, :text
  end
end