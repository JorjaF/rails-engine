class Api::V1::MerchantController < ApplicationController
  def index
    if params[:item_id].present?
      item = Item.find_by(id: params[:item_id])
      if item
        merchant = Merchant.find_by(id: item.merchant_id)
        render json: MerchantSerializer.new(merchant)
      else
        render json: { error: "Item not found" }, status: :not_found
      end
    else
      merchants = Merchant.all
      render json: MerchantSerializer.new(merchants)
    end
  end
end 
