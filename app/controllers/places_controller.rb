class PlacesController < ApplicationController

  before_filter :find_place, only: [:show, :schedule, :preview, :menu, :contacts]

	def index

    @places = Place.with_bounds_in(params[:top], params[:bottom])
                  .with_min_sale_greater_than(params[:sale])
                  .with_average_check_in(params[:check])
                  .tagged_by(params[:tags])
                  .order(:id)
    
    respond_to do |format|
      format.html
      format.json {
        render_for_api :list, json: @places
      }
    end
	end
  
	def show

	end

  def preview
    
    render partial: 'places/preview', locals: {place: @place}
  end

  def menu
    render :show
  end

  def contacts
    render :show
  end

  def schedule
    if active_dates = @place.active_dates
      render json: active_dates
    else
      render json: {status: :empty}
    end 
  end

  private

  def find_place
    @place = Place.find(params[:id])
  end
end