class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.named_like(params[:s]).limit(7)
    render json: @tags.as_json(only: [:name])
  end
end