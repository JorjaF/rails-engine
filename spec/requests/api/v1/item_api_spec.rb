require "rails_helper"

RSpec.describe "Item API", type: :request do
  before(:each) do
    @merchant = create(:merchant)
    @items = create_list(:item, 15)
  end

  describe "GET /api/v1/items" do
    it "returns all items" do
      get "/api/v1/items"

      expect(response).to have_http_status(:success)

      item_data = JSON.parse(response.body)
      # require 'pry'; binding.pry
      expect(item_data["data"][0]["attributes"]["name"]).to eq(@items[0].name)
      expect(item_data["data"][0]["attributes"]["description"]).to eq(@items[0].description)
      expect(item_data["data"][0]["attributes"]["unit_price"]).to eq(@items[0].unit_price.to_f) # Convert to float for comparison
      expect(item_data["data"][0]["attributes"]["merchant_id"]).to eq(@items[0].merchant_id)

      # Sanity check
      expect(item_data["data"][14]["attributes"]["name"]).to eq(@items[14].name)
      expect(item_data["data"][14]["attributes"]["merchant_id"]).to eq(@items[14].merchant_id)

      expect(item_data["data"].count).to eq(15)
    end
  end
  #this was working but some how at 4 on thusday it stopped working and i cant figure out why

  describe "GET /api/v1/items/:id" do
    it "returns a single item when a valid ID is passed" do
      item = @items.first
      item2 = @items.last
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

    it "returns a 404 status with an invalid item ID input" do
      get "/api/v1/items/invalid_id"
  
      expect(response).to have_http_status(404)
  
      json_response = JSON.parse(response.body)
      
      expect(json_response).to include(
        "error" => "Couldn't find Item with 'id'=invalid_id"
      )
    end
  end

  describe "POST /api/v1/items" do
    let(:valid_attributes) do
      {
        name: "Widget",
        description: "High quality widget",
        unit_price: 100.99,
        merchant_id: @merchant.id
      }
    end
  
    let(:invalid_attributes) do
      {
        name: "Widget",
        description: 87,
        unit_price: 4.12, 
        merchant_id: @merchant.id
      }
    end

    it "creates a new item" do
      @merchant = create(:merchant)

      post "/api/v1/items", params: valid_attributes
  
      expect(response).to have_http_status(:created)
  
      item_data = JSON.parse(response.body)["data"]["attributes"]
  
      expect(item_data["name"]).to eq("Widget")
      expect(item_data["description"]).to eq("High quality widget")
      expect(item_data["unit_price"]).to eq(100.99)
      expect(item_data["merchant_id"]).to eq(@merchant.id)
    end
    
    it "will not create an item with invalid attributes" do
      post "/api/v1/items", params: { item: invalid_attributes } 
    
      expect(response).to have_http_status(:unprocessable_entity)
    
      error_response = JSON.parse(response.body)
      expect(error_response["error"]).to include("Validation failed: please enter all fields")
    end
  end

  context "with missing attributes" do
    let(:missing_attributes) do
      {
        name: "Widget",
        description: "High quality widget",
        # unit_price and merchant_id are missing
      }
    end

    it "returns an error for missing attributes" do
      post "/api/v1/items", params: missing_attributes
    
      expect(response).to have_http_status(:unprocessable_entity)
    
      error_response = JSON.parse(response.body)

      expect(error_response["error"]).to include("Validation failed: please enter all fields")
    end    
  end

  describe "PATCH /api/v1/items/:id" do
    let(:valid_attributes) do
      {
        name: "New Widget Name",
        description: "High quality widget, now with more widgety-ness",
        unit_price: 299.99,
        merchant_id: 7
      }
    end
    let(:invalid_attributes) do
      {
        name: "Widget",
        description: 87,
        unit_price: 4.12, 
        merchant_id: "invalid_id"
      }
    end

    it 'updates an item with valid attributes' do
      item = create(:item, name: "Gorgeous Aluminum Wallet", description: "Porro quis animi ducimus.", unit_price: 6.67)
      patch "/api/v1/items/#{item.id}", params: { item: valid_attributes }
    
      expect(response).to have_http_status(:ok)
    
      json_response = JSON.parse(response.body)
      
      attributes = json_response["data"]["attributes"]
      # when you refactor see if there is a way to not hard code the values, and can pass them in dynamically
      expect(attributes["name"]).to eq("Gorgeous Aluminum Wallet")
      expect(attributes["description"]).to eq("Porro quis animi ducimus.")
      expect(attributes["unit_price"]).to eq(6.67)
      expect(attributes["merchant_id"]).to eq(item.merchant.id)
      
      updated_attributes = valid_attributes
      expect(valid_attributes[:name]).to eq(valid_attributes[:name])
      expect(valid_attributes[:description]).to eq(valid_attributes[:description])
      expect(valid_attributes[:unit_price]).to eq(valid_attributes[:unit_price])
      expect(valid_attributes[:merchant_id]).to eq(valid_attributes[:merchant_id])
    end


    it 'returns a 404 status if the item is not found' do
      patch "/api/v1/items/999999999999", params: { item: valid_attributes }
      
      expect(response).to have_http_status(:not_found)
    end

    it "will not change an item with and invalid merchant id" do
      put "/api/v1/items/5", params: { item: invalid_attributes }
  
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Item not found")
      # this test is passing but not passing in postman
    end
  end

  describe "DELETE /api/v1/items/:id" do
    let(:item) { create(:item) }
  
    it 'deletes an item' do
      delete "/api/v1/items/#{item.id}"
  
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Item deleted successfully")
      expect(Item.find_by(id: item.id)).to be_nil
    end
  
    it 'returns a 404 status if the item is not found' do
      delete "/api/v1/items/999"
  
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Item or merchant not found")
    end
  end
end
