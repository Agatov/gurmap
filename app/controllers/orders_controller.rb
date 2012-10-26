class OrdersController < ApplicationController
  include ::HTTParty
  include ApplicationHelper

  before_filter :find_order, only: [:check, :destroy]

  def index
    render json: {status: :kokoko}
  end

  def create
    #begin

      @order = current_user.orders.create(params[:order])

      #aaa = self.class.get("http://api.sms24x7.ru", query: { 
      #  method: 'push_msg',
      #  email: 'agatovs@gmail.com',
      #  password: 'avv6rqE',
      #  phone: '79037928959',
      #  text: "#{@user.first_name} + #{order.persons_number - 1}, #{order.date.strftime('%d.%m %H:%M')}, #{@user.phone}",
      #  sender_name: 'GURMAP',
      #})

      render json: {status: :ok, order_id: @order.id, vk_social_url: vk_social_url(@order)}
    #rescue Exception => e
    #  render json: {status: :error}
    #end
  end

  def check

    # А лучше наверно чекать в модели, а возвращать статус ордера, а не сассесс еррор
    @checker = SocialChecker.new(@order)


    if @checker.check.success?
      # Меняем статус
      @order.confirm()

      respond_to do |format|
        format.json {
          render json: {status: :success}
        }
      end
    else
      respond_to do |format|
        format.json {
          render json: {status: :error}
        }
      end
    end
  end

  def destroy

  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end