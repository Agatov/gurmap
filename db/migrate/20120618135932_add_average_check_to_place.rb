class AddAverageCheckToPlace < ActiveRecord::Migration
  def change
    add_column :places, :average_check, :integer, default: 0
  end
end
