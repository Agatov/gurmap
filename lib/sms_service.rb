class SmsService
  include HTTParty


  def self.send_phone_confirmation_code(phone, code)
    SmsService.send(phone, "your confirmation code is #{code}")
  end

  # @param [Order] order
  # Отсылает смски пользователю и заведению об успешном проведении заказа
  def self.send_order_confirmed(order)
    
  end

  # @param [Order] order
  # Отсылает смски пользовтелю и заведению о том, что заказ отменен
  def self.send_order_rejected(order)

  end

  def self.send(phone, text)
    self.class.get("http://api.sms24x7.ru", query: {
      method: 'push_msg',
      email: 'agatovs@gmail.com',
      password: 'avv6rqE',
      phone: phone,
      text: text,
      sender_name: 'GURMAP',
    })
  end
end