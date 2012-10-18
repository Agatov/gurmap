class AddAccountIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :account_id, :integer
  end
end
