require 'rails_helper'

RSpec.describe 'Merchant Items API', type: :request do
  describe "GET /api/v1/merchants/{{merchant_id}}/items" do
    let(:merchant) { create(:merchant) }
    let!(:items_merchant) { create_list(:item, 3, merchant: merchant) }

    context 'when the merchant exists' do
      before do
        get "/api/v1/merchants/#{merchant.id}/items"
      end

      it 'returns a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the items associated with the merchant' do
        json_response = JSON.parse(response.body)
        
        expect(json_response["data"].count).to eq(items_merchant.count)
        expect(json_response["data"].first["attributes"]["name"]).to eq(items_merchant.first.name)
        expect(json_response["data"].last["attributes"]["name"]).to eq(items_merchant.last.name)
      end
      #sanity check

      # it 'does not return items associated with other merchants' do
      #   get "/api/v1/merchants/#{merchant2.id}/items"
      #   json_response = JSON.parse(response.body)

      #   expect(json_response['data'].count).to eq(items_merchant2.count)
      #   expect(json_response['data'].first['attributes']['name']).to eq(items_merchant2.first.name)
      #   expect(json_response['data'].last['attributes']['name']).to eq(items_merchant2.last.name)
      # end
    end
  end
end


    # context 'when the merchant does not exist' do
    #   it 'returns a 404 status code' do
    #     get "/api/v1/merchants/999/items" # Assuming there is no merchant with ID 999
    #     expect(response).to have_http_status(:not_found)
    #   end
    # end
#   end
# end
