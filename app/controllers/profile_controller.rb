class ProfileController < ApplicationController

  include ApplicationHelper

  def index

  end

  def fake_login
    login User.first
    redirect_to root_path
  end
end