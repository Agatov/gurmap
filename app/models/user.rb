class User < ActiveRecord::Base
  attr_accessible :avatar, :first_name, :last_name, :phone, :phone_confirmation_code, :phone_state

  has_one :authentication

  as_enum :phone_state, [:fresh, :confirmed], prefix: true

  mount_uploader :avatar, UserAvatarUploader

  validates :phone, length: {is: 10}

  acts_as_api
  include ApiV1::User

  before_validation :parse_phone
  before_save :check_phone

  def avatar_preview
    avatar_url(:preview)
  end

  def get_name
    "#{first_name} #{last_name}"
  end

  def confirm_phone(code)
    if code == phone_confirmation_code

      self.phone_state = :confirmed
      self.save!
      true
    else
      false
    end
  end

  def send_phone_confirmation_code
    self.phone_confirmation_code = code = "0981"
    self.phone_state = :fresh
    SmsService.send_phone_confirmation_code(phone, code)
  end

  private

  def parse_phone
    self.phone = phone.gsub(/[^0-9]/, "")
  end

  def check_phone
    if phone_changed?
      send_phone_confirmation_code

    end
  end

end
