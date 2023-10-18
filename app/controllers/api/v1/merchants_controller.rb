class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    begin 
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    rescue ActiveRecord::RecordNotFound
      error_message = "Couldn't find Merchant with 'id'=#{params[:id]}"
      render json: ErrorSerializer.serialize(error_message), status: 404
    end
  end
end
