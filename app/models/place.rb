class Place < ActiveRecord::Base
  attr_accessible :address, :avatar, :category_id, :description, :latitude, :longitude, :name, :state_cd, :type_cd
  attr_accessible :average_check, :tag_list, :min_sale, :max_sale, :phone
  attr_accessor :active_days_cached
  has_many :schedules
  has_many :orders
  has_many :photos
  belongs_to :account

  mount_uploader :avatar, PlaceAvatarUploader
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  acts_as_api
  include ApiV1::Place

  acts_as_taggable

  scope :with_latitude_in, lambda { |min, max| where(latitude: min..max)}
  scope :with_longitude_in, lambda { |min, max| where(longitude: min..max)}
  scope :with_min_sale_greater_than, lambda{|sale| where("min_sale >= ?", sale) unless sale.nil?}
  scope :with_max_sale_less_than, lambda{|sale| where("max_sale <= ?", sale) unless sale.nil?}

  scope :with_bounds_in, lambda {|top, bottom|
    unless top.nil? and bottom.nil?
      top = top.split(",")
      bottom = bottom.split(",")
      where(latitude: top.first..bottom.first, longitude: top.last..bottom.last)
    end
  }

  scope :with_average_check_in, lambda {|check|
    unless check.nil?
      check_array = check.split(",")
      from = check_array.first
      to = check_array.last

      where(average_check: from..to)
    end
  }

  scope :tagged_by, lambda {|tags|
    # match_all: true # Не работает с SQLITE? Ж)
    unless tags.nil?
      tagged_with(tags.mb_chars.downcase) if tags.length > 0
    end
  }

  def schedule
    self.schedules.order(:day_of_week).group_by {|s| s.day_of_week}
  end

  def active_days

    if self.active_days_cached.nil?
      self.active_days_cached = schedules.select(:day_of_week).group(:day_of_week).map {|s| s.day_of_week}
    end
    self.active_days_cached
  end

  def active_dates
    current_day = Time.now()
    dates = []

    return false if active_days.empty?

    while dates.size < 5
      if active_days.include? current_day.wday
        info = {
          wday: current_day.wday,
          dayname: I18n.localize(current_day, format: :wday),
          datename: I18n.localize(current_day, format: "%d %b"),
          value: current_day.strftime("%Y-%m-%d"),
          hours: []
        }
        dates.push info
      end
      
      current_day = current_day.tomorrow
    end

    schedules.each do |schedule|
      days = dates.select {|a| a[:wday] == schedule.day_of_week}
      days.each do |day|
        day[:hours] += schedule.to_times
        day[:hours].sort_by! {|d| d[:hour]}
      end
    end

    return dates
  end

  def avatar_preview
    self.avatar_url(:web_profile)
  end

  def update_sales_range
    self.max_sale = self.schedules.maximum(:sale)
    self.min_sale = self.schedules.minimum(:sale)
    self.save
  end


end
