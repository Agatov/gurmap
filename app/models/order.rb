class Order < ActiveRecord::Base
  attr_accessible :comment, :date, :persons_number, :place_id, :user_id, :state, :state_cd, :checks_count

  belongs_to :place
  belongs_to :user

  as_enum :state, [:fresh, :confirmed, :rejected], prefix: true

  after_create :withdraw_account_balance

  #@todo - Узнать, не генеряться ли эти скоупы по дефолту от simple_enum
  scope :fresh, where(state_cd: self.class.state_fresh)
  scope :confirmed, where(state_cd: self.class.state_confirmed)
  scope :rejected, where(state_cd: self.class.state_rejected)


  def confirm
    self.update_attributes(state: :confirmed)
    SmsService.send_order_confirmed(self)
  end

  def reject()
    self.update_attributes(state: :rejected)
    SmsService.send_order_rejected(self)
  end


  # @todo
  # => Вынести сумму в константу
  def withdraw_account_balance
    account = place.account
    account.balance -= 10
    account.save
  end
end
