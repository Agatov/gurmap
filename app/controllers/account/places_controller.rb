class Account::PlacesController < ApplicationController

  layout "account"

  before_filter :find_place, only: [:show, :schedule, :tags, :description, :edit, :update, :destroy]
  before_filter :has_access, only: [:show, :edit, :update, :destroy]
  before_filter :downcase_tags, only: [:update]

  before_filter :authenticate_account!

  def index
    @places = current_account.places
  end

  def show

  end

  def schedule
    @schedule = @place.schedule

    if request.xhr?
      render partial: 'account/places/schedule', locals: {schedule: @schedule}
    else
      render
    end
  end

  def tags
  end

  def description
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_account.places.build(params[:place])

    respond_to do |format|
      if @place.save
        format.html { redirect_to account_places_path }
      else
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to account_places_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @place.destroy

    respond_to do |format|
      format.html { redirect_to account_places_path }
    end
  end

  private

  def find_place
    @place = Place.find(params[:id])
  end

  def has_access
    true
  end

  def downcase_tags
    unless params[:place][:tags_list].nil?
      params[:place][:tags_list] = params[:place][:tags_list].mb_chars.downcase
    end
  end

end