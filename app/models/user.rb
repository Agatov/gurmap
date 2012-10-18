class User < ActiveRecord::Base
  attr_accessible :avatar, :first_name, :last_name, :phone, :phone_confirmation_code, :phone_state

  has_one :authentication
end
