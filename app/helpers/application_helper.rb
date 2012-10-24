module ApplicationHelper
  # Авторизация
  
  # @param [User] user
  def login(user)
    session[:user_id] = user.id.to_s
  end

  def logout
    session[:user_id] = nil
  end

  def order_social_params(order)
    return {
      url: "http://#{request.host}/places/#{order.place.id}##{order_id}",
      title: CGI.escape("I get 30% sale to #{order.place.name} with Gurmap"),
      description: CGI.escape("OLOLOLLO"),
      image: "http://#{request.host}/images/logo.png"
    }
  end

  def vk_social_url(order)
    params = order_social_params(order)
    "http://vk.com/share.php?url=#{params[:url]}&title=#{params[:title]}&image=#{params[:image]}&description=#{params[:description]}&noparse=true"
  end
end
