namespace :order_checker do
  task check_fresh: :environment do
    orders = Order.fresh

    orders.each do |order|

    end
  end

  task check_confirmed: :environment do

  end
end