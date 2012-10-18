class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :place_id
      t.integer :day_of_week
      t.time :start_time
      t.time :end_time
      t.integer :sale

      t.timestamps
    end
  end
end
