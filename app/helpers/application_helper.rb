module ApplicationHelper
  # Авторизация
  
  # @param [User] user
  def login(user)
    session[:user_id] = user.id.to_s
  end

  def logout
    session[:user_id] = nil
  end

  def order_social_params(place_name, order_id)
    return {
      url: "http://#{request.host}##{order_id}",
      title: CGI.escape("I get 30% sale to #{place_name} with Gurmap"),
      description: CGI.escape("OLOLOLLO"),
      image: "http://#{request.host}/images/logo.png"
    }
  end

  def vk_social_url(params)
    "http://vk.com/share.php?url=#{params[:url]}&title=#{params[:title]}&image=#{params[:image]}&description=#{params[:description]}&noparse=true"
  end
end
