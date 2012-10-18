class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.string :phone
      t.integer :phone_state, default: 0
      t.string :phone_confirmation_code

      t.timestamps
    end
  end
end
