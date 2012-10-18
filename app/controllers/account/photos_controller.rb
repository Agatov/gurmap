class Account::PhotosController < ApplicationController
  layout "account"

  before_filter :find_place
  before_filter :find_photo, only: [:destroy]

  # Список всех фотографий
  def index
    @photos = @place.photos
  end

  # Добавить фотографию
  def create
    photo = @place.photos.build(params[:photo])

    respond_to do |format|
      if photo.save

        format.js {
          render text: render_to_string(partial: 'account/photos/photo', locals: {photo: photo})
        }
      else
        format.js {
          render text: ' '
        }
      end
    end
  end

  # Удалить фотографию
  def destroy
    if @photo.destroy
      render json: {status: :ok, id: @photo.id}
    else
      render json: {status: :error}
    end
  end

  private

  def find_place
    @place = Place.find(params[:place_id])
  end

  def find_photo
    @photo = Photo.find(params[:id])
  end

end