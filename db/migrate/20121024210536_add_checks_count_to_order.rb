class AddChecksCountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :checks_count, :integer, default: 0
  end
end
