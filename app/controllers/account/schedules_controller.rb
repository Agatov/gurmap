class Account::SchedulesController < ApplicationController

  def index
    @schedule = Place.find(params[:place_id]).schedule

    render partial: '/account/schedules/schedule', locals: {schedule: @schedule}
  end

  def new
    @schedule = Place.find(params[:place_id]).schedules.build

    render partial: '/account/schedules/new_form', locals: {schedule: @schedule}
  end

  def create
    @schedule = Schedule.new(params[:schedule])
    @schedule.save

    render json: {status: :ok, place_id: @schedule.place_id}
  end

  def edit
    @schedule = Schedule.find(params[:id])

    render partial: '/account/schedules/edit_form', locals: {schedule: @schedule}
  end

  def update
    @schedule = Schedule.find(params[:id])

    if @schedule.update_attributes(params[:schedule])
      render json: {
        status: :ok, 
        schedule_id: @schedule.id, 
        start_time: @schedule.formatted_start_time, 
        end_time: @schedule.formatted_end_time,
        sale: @schedule.sale
      }
    else
      render json: {status: :error}
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])

    if @schedule.destroy
      redirect_to :back
    else
      redirect_to :back
    end
  end
end