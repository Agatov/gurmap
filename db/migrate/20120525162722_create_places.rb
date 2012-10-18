class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :category_id
      t.string :name
      t.string :avatar
      t.integer :type_cd
      t.integer :state_cd
      t.text :description
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
