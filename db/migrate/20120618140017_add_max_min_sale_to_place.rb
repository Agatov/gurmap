class AddMaxMinSaleToPlace < ActiveRecord::Migration
  def change
    add_column :places, :min_sale, :integer, default: 0
    add_column :places, :max_sale, :integer, default: 0
  end
end
