require "rails_helper"

RSpec.describe "Merchant API", type: :request do
  before(:each) do
    create_list(:merchant, 5)
  end

  describe "GET /api/v1/merchants" do
    it "returns all merchants" do

      get "/api/v1/merchants"

      expect(response).to have_http_status(:success)
      
      merchant_data = JSON.parse(response.body)

      expect(merchant_data["data"][0]["attributes"]["name"]).to eq(merchant_data["data"][0]["attributes"]["name"])
      expect(merchant_data["data"][1]["attributes"]["name"]).to eq(merchant_data["data"][1]["attributes"]["name"])
    end
  end

  describe "GET /api/v1/merchants/:id" do
    it "when a valid id is passed, it returns a single merchant" do
      merchant = Merchant.first

      get "/api/v1/merchants/#{merchant.id}"

      expect(response).to have_http_status(:success)

      merchant_data = JSON.parse(response.body)

      expect(merchant_data["data"]["attributes"]["name"]).to eq(merchant.name)
      expect(merchant_data["data"]["attributes"]["name"]).to_not eq(Merchant.last.name)
    end

    it "gives a 404 when there is an invalid item ID input" do
      get "/api/v1/merchants/invalid_id"
  
      expect(response).to have_http_status(404)
  
      json_response = JSON.parse(response.body)
      
      expect(json_response["error"]).to eq("Couldn't find Merchant with 'id'=invalid_id")
    end
  end
end
