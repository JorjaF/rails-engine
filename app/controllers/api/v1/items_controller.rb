class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    begin 
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    rescue ActiveRecord::RecordNotFound
      error_message = "Couldn't find Item with 'id'=#{params[:id]}"
      render json: ErrorSerializer.serialize(error_message), status: 404
    end
  end
end
