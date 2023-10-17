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

      expect(merchant_data["data"][0]["attributes"]["name"]).to eq("Gerlach-Kreiger")
      expect(merchant_data["data"][1]["attributes"]["name"]).to eq("Cummerata and Sons")
    end
  end
end
