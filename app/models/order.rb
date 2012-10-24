class Order < ActiveRecord::Base
  attr_accessible :comment, :date, :persons_number, :place_id, :user_id

  belongs_to :place
  belongs_to :user

  as_enum :state, [:fresh, :confirmed, :rejected], prefix: true

  after_create :withdraw_account_balance


  # @todo
  # => Вынести сумму в константу
  def withdraw_account_balance
    account = place.account
    account.balance -= 10
    account.save
  end
end
