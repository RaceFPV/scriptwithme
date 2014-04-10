class MoveLinesToText < ActiveRecord::Migration
  def change
    change_column :lines, :content, :text
  end
end