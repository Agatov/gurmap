class OrdersController < ApplicationController
  include ::HTTParty
  include ApplicationHelper

  berofe_filter :find_order, only: [:check, :destroy]

  def create
    #@user = User.find(1)
    begin

      @order = current_user.orders.create(params[:order])

      #aaa = self.class.get("http://api.sms24x7.ru", query: { 
      #  method: 'push_msg',
      #  email: 'agatovs@gmail.com',
      #  password: 'avv6rqE',
      #  phone: '79037928959',
      #  text: "#{@user.first_name} + #{order.persons_number - 1}, #{order.date.strftime('%d.%m %H:%M')}, #{@user.phone}",
      #  sender_name: 'GURMAP',
      #})

      render json: {status: :ok, vk_social_url: vk_social_url(@order)}
    rescue Exception => e
      render json: {status: :error}
    end
  end

  def check
    checker = SocialChecker.new({
      uid: current_user.authentication.uid,
      token: current_user.authentication.token,
      place_id: @order.place_id,
      order_id: @order.id,
    })


    respond_to do |format|
      format.json {
        if @checker.check.success?
          render json: {status: :success}
        else
          render json: {status: :error}
        end
      } 
    end
  end

  def destroy

  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end