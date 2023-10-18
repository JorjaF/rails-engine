require "rails_helper"

RSpec.describe "Item API", type: :request do
  before(:each) do
    @list = create_list(:item, 15)
  end

  describe "GET /api/v1/items" do
    it "returns all items" do
      get "/api/v1/items"

      expect(response).to have_http_status(:success)

      item_data = JSON.parse(response.body)

      expect(item_data["data"][0]["attributes"]["name"]).to eq(@list[0].name)
      expect(item_data["data"][0]["attributes"]["description"]).to eq(@list[0].description)
      expect(item_data["data"][0]["attributes"]["unit_price"]).to eq(@list[0].unit_price)
      expect(item_data["data"][0]["attributes"]["merchant_id"]).to eq(@list[0].merchant_id)

      # For the sanity check, access the attributes of the second item
      expect(item_data["data"][14]["attributes"]["name"]).to eq(@list[14].name)
      expect(item_data["data"][14]["attributes"]["merchant_id"]).to eq(@list[14].merchant_id)

      expect(item_data["data"].count).to eq(15)
    end
  end

  describe "GET /api/v1/items/:id" do
    it "when a valid id is passed, it returns a single item" do
      item_id = Item.first.id

      get "/api/v1/items/#{item_id}"

      expect(response).to have_http_status(:success)

      item_data = JSON.parse(response.body)

      expect(item_data["data"]["attributes"]["name"]).to eq(@list[0].name)
      expect(item_data["data"]["attributes"]["description"]).to eq(@list[0].description)
      expect(item_data["data"]["attributes"]["unit_price"]).to eq(@list[0].unit_price)
      expect(item_data["data"]["attributes"]["merchant_id"]).to eq(@list[0].merchant_id)
    end

    it "gives a 404 when there is an invalid item ID input" do
      get "/api/v1/items/invalid_id"
  
      expect(response).to have_http_status(404)
  
      json_response = JSON.parse(response.body)
      
      expect(json_response).to include(
        "error" => "Couldn't find Item with 'id'=invalid_id"
      )
    end
  end
end
