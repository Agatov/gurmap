module ApplicationHelper
  # Авторизация
  
  # @param [User] user
  def login(user)
    session[:user_id] = user.id.to_s
  end

  def logout
    session[:user_id] = nil
  end
end
