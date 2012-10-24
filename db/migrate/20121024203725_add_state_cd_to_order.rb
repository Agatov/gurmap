class AddStateCdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :state_cd, :integer, default: 0
  end
end
