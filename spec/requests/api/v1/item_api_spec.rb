require "rails_helper"

RSpec.describe "Item API", type: :request do
  describe "GET /api/v1/items" do
    it "returns all items" do
      items = create_list(:item, 15)

      get "/api/v1/items"

      expect(response).to have_http_status(:success)

      item_data = JSON.parse(response.body)
      
      expect(item_data["data"][0]["attributes"]["name"]).to eq(items[0].name)
      expect(item_data["data"][0]["attributes"]["description"]).to eq(items[0].description)
      expect(item_data["data"][0]["attributes"]["unit_price"]).to eq(items[0].unit_price) # Convert to string
      expect(item_data["data"][0]["attributes"]["merchant_id"]).to eq(items[0].merchant_id)

      # sanity check
      expect(item_data["data"][14]["attributes"]["name"]).to eq(items[14].name)
      expect(item_data["data"][14]["attributes"]["merchant_id"]).to eq(items[14].merchant_id)

      expect(item_data["data"].count).to eq(15)
    end
  end

  describe "GET /api/v1/items/:id" do
    it "when a valid id is passed, it returns a single item" do
      item = create(:item, name: "Awesome Linen Plate", description: "This is a test description", unit_price: 1.5, merchant_id: 1)
      item2 = create(:item, name: "Boring Linen Plate", description: "This is a test description", unit_price: 1.5, merchant_id: 1)
      item_id = item.id

      get "/api/v1/items/#{item_id}"

      expect(response).to have_http_status(:success)

      item_data = JSON.parse(response.body)

      expect(item_data["data"]["attributes"]["name"]).to eq(item.name)
      expect(item_data["data"]["attributes"]["description"]).to eq(item.description)
      expect(item_data["data"]["attributes"]["unit_price"]).to eq(item.unit_price) 
      expect(item_data["data"]["attributes"]["merchant_id"]).to eq(item.merchant_id)
      expect(item_data["data"]["attributes"]["name"]).not_to eq(item2.name)
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
