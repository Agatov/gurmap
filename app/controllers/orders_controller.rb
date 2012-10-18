class OrdersController < ApplicationController
  include ::HTTParty

  def create
    #@user = User.find(1)
    begin

      #order = @user.create_order(Place.find(params[:place_id]), params[:datetime], params[:persons_number])

      #aaa = self.class.get("http://api.sms24x7.ru", query: { 
      #  method: 'push_msg',
      #  email: 'agatovs@gmail.com',
      #  password: 'avv6rqE',
      #  phone: '79037928959',
      #  text: "#{@user.first_name} + #{order.persons_number - 1}, #{order.date.strftime('%d.%m %H:%M')}, #{@user.phone}",
      #  sender_name: 'GURMAP',
      #})

      render json: {status: :ok}
    rescue Exception => e
      render json: {status: :error}
    end
  end

  def destroy

  end
end