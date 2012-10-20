class AuthenticationsController < ApplicationController

  layout "authentication"

  def create
    @auth = request.env['omniauth.auth']
    @new_user = true

    authentication = Authentication.find_or_create_by_provider_and_uid(@auth['provider'], @auth['uid'])

    if authentication.user.present?
      @new_user = false
      login authentication.user
    else
      @user = User.new()

      # В начале у нас будет работа только с VK. Поэтому и код пишем соответственно

      @user.first_name = @auth['info']['name']
      @user.last_name = ''
      @user.remote_avatar_url = @auth.extra.raw_info.photo_big!

      authentication.user = @user
      authentication.save

      login @user
    end
  end
end