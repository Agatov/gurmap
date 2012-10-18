class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    if session[:user_id] and !session[:user_id].empty?
      @current_user ||= User.find(session[:user_id])
    end
  end

  def user_logged_in?
    return false if session[:user_id] and session[:user_id].empty?
    retrun session[:user_id] ? true : false
  end

  helper_method :current_user
  helper_method :user_logged_in?

  def after_sign_in_path_for(resource)
    return account_places_path if resource.instance_of? Account
    #return places_path if resource.instance_of? User
  end
end
