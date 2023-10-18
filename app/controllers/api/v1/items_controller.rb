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

  def create
    item = Item.new(item_params)
    merchant = Merchant.new(merchant_params)

    if item.valid? && merchant.valid?
      item.save
      merchant.save
      render json: ItemSerializer.new(item), status: :created
    else
      if item.errors.any? && merchant.errors.any?
        error_message = "Validation failed: please enter valid attributes"
      elsif item.errors.any?
        error_message = "Validation failed: please enter all fields"
      else
        error_message = "Validation failed: please enter valid attributes"
      end

      render_error_response(error_message)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def merchant_params
    params.permit(:name)
  end

  def render_error_response(error_message)
    render json: ErrorSerializer.serialize(error_message), status: :unprocessable_entity
  end
end
