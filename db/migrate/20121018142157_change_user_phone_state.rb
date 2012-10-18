class ChangeUserPhoneState < ActiveRecord::Migration
  def change
    rename_column :users, :phone_state, :phone_state_cd
  end
end
