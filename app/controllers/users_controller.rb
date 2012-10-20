class UsersController < ApplicationController

  before_filter :find_user, only: [:show, :edit, :update, :update_phone, :confirm_phone]
  before_filter :check_user, only: [:show, :edit, :update, :update_phone, :confirm_phone]

  def show
    respond_to do |format|
      format.html {
        render
      }

      format.json {
        render_for_api :list, json: @user
      }
    end
  end

  def edit

  end

  def update
  end

  # Это исключительно тестовый метод
  def set_phone
    render json: {status: :ok}
  end

  def update_phone
    @user.phone = params[:phone]

    respond_to do |format|
      format.json {
        begin
          @user.save
          render json: {status: :ok}
        rescue Exception => e
          render json: {status: :error, message: e.message}
        end
      }
    end
  end

  def confirm_phone
    respond_to do |format|
      format.json {
        if @user.confirm_phone(params[:code])
          render json: {status: :ok}
        else
          render json: {status: :bad_code}
        end
      }
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def check_user
    raise Exception, "Ololo, Panic on the Disco" if @user.id != params[:id]
  end
end