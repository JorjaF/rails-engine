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

      expect(item_data["data"][0]["attributes"]["name"]).to eq(@items[0].name)
      expect(item_data["data"][0]["attributes"]["description"]).to eq(@items[0].description)
      expect(item_data["data"][0]["attributes"]["unit_price"]).to eq(@items[0].unit_price)
      expect(item_data["data"][0]["attributes"]["merchant_id"]).to eq(@items[0].merchant_id)

      # sanity check
      expect(item_data["data"][14]["attributes"]["name"]).to eq(@items[14].name)
      expect(item_data["data"][14]["attributes"]["merchant_id"]).to eq(@items[14].merchant_id)

      expect(item_data["data"].count).to eq(15)
    end
  end

  describe "GET /api/v1/items/:id" do
    it "when a valid id is passed, it returns a single item" do
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

    it "gives a 404 when there is an invalid item ID input" do
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
        name: 'Widget',
        description: 'High quality widget',
        unit_price: 100.99,
        merchant_id: @merchant.id
      }
    end
  
    let(:invalid_attributes) do
      {
        name: 'Widget',
        description: 87,
        unit_price: 4.12, 
        merchant_id: @merchant.id
      }
    end

    it 'creates a new item' do
      @merchant = create(:merchant)

      post '/api/v1/items', params: valid_attributes
  
      expect(response).to have_http_status(:created)
  
      item_data = JSON.parse(response.body)['data']['attributes']
  
      expect(item_data['name']).to eq('Widget')
      expect(item_data['description']).to eq('High quality widget')
      expect(item_data['unit_price']).to eq(100.99)
      expect(item_data['merchant_id']).to eq(@merchant.id)
    end
    
    it "will not create an item with invalid attributes" do
      post '/api/v1/items', params: { item: invalid_attributes } 
    
      expect(response).to have_http_status(:unprocessable_entity)
    
      error_response = JSON.parse(response.body)
      expect(error_response['error']).to include("Validation failed: please enter all fields")
    end
  end

  context 'with missing attributes' do
    let(:missing_attributes) do
      {
        name: 'Widget',
        description: 'High quality widget',
        # unit_price and merchant_id are missing
      }
    end

    it 'returns an error for missing attributes' do
      post '/api/v1/items', params: missing_attributes
    
      expect(response).to have_http_status(:unprocessable_entity)
    
      error_response = JSON.parse(response.body)

      expect(error_response['error']).to include("Validation failed: please enter all fields")
    end    
  end
end
