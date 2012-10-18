class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :place_id
      t.datetime :date
      t.integer :persons_number
      t.text :comment

      t.timestamps
    end
  end
end
