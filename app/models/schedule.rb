class Schedule < ActiveRecord::Base
  attr_accessible :day_of_week, :end_time, :place_id, :sale, :start_time

  belongs_to :place

  after_create :update_place_sales_range
  after_update :update_place_sales_range

  def formatted_start_time
    start_time.strftime("%H:%M")
  end

  def formatted_end_time
    end_time.strftime("%H:%M")
  end

  def update_place_sales_range
    self.place.update_sales_range
  end

  def to_times
    since = self.start_time.hour.hours + self.start_time.min.minutes
    to = self.end_time.hour.hours + self.end_time.min.minute

    times = []
    since.step(to, 1800) do |t|
      s = {
        hour: Time.at(t).utc.strftime("%H:%M"),
        sale: sale
      }
      times.push s
    end

    times
  end
end
