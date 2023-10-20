require "rails_helper"

RSpec.describe "Items Merchants API", type: :request do
  let(:merchant) { create(:merchant) }
  let(:merchant2) { create(:merchant) }
  let!(:item) { create_list(:item, 3, merchant: merchant) }
  let!(:items) { create_list(:item, 1, merchant: merchant2) }

  context "when the item exists" do
    before do
      get "/api/v1/items/#{Item.first.id}/merchant" # Use the first item from the list
    end

    it "returns a 200 status code" do
      expect(response).to have_http_status(200)
    end

    it "returns the merchant data for the item" do
      json_response = JSON.parse(response.body)["data"] 
      expect(json_response).not_to be_empty
      expect(json_response["id"]).to eq(merchant.id.to_s) #idk why this is a string
      expect(json_response["attributes"]["name"]).to eq(merchant.name)
    end
  end
end
# i would like to do more sad path but I ran out of time 
# i had no idea how to even approach section 2 of the project
