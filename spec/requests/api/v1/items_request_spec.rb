require 'rails_helper'

RSpec.describe 'Items API' do
    it "returns a list of items" do
        merchant = create(:merchant)
        create_list(:item, 5, merchant_id: merchant.id)

        get '/api/v1/items'

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        
        response_body = JSON.parse(response.body, symbolize_names: true)
        items = response_body[:data]

        expect(items.count).to eq(5) 
        items.each do |item|
            expect(item).to have_key(:id)
            expect(item).to have_key(:type)
            expect(item).to have_key(:attributes)
            expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
            expect(item[:attributes][:name]).to be_a String
            expect(item[:attributes][:description]).to be_a String
            expect(item[:attributes][:unit_price]).to be_a Float
            expect(item[:attributes][:merchant_id]).to be_a Integer
        end 
    end

    it "returns a single item" do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)

        get "/api/v1/items/#{item.id}"

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        
        response_body = JSON.parse(response.body, symbolize_names: true)
        item = response_body[:data]

        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
        expect(item[:attributes][:name]).to be_a String
        expect(item[:attributes][:description]).to be_a String
        expect(item[:attributes][:unit_price]).to be_a Float
        expect(item[:attributes][:merchant_id]).to be_a Integer
    end

    it "creates an items" do
        merchant = create(:merchant)
        item_params = ({
            name: 'Juice',
            description: 'lots of sugar',
            unit_price: 100,
            merchant_id: merchant.id
        })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last 

        expect(response).to be_successful
        expect(response).to have_http_status(201)
        expect(created_item.name).to eq('Juice')
        expect(created_item.description).to eq('lots of sugar')
        expect(created_item.unit_price).to eq(100)
        expect(created_item.merchant_id).to eq(merchant.id)
    end

    it "updates an item" do
        merchant = create(:merchant)
        id = create(:item, merchant_id: merchant.id).id

        previous_name = Item.find_by(id: id).name
        item_params = ({ name: "Koolaid", merchant_id: merchant.id })

        patch "/api/v1/items/#{id}", params: ({item: item_params})
        item = Item.find_by(id: id)

        expect(response).to be_successful
        expect(response).to have_http_status(200)
        expect(item.name).to_not eq(previous_name) 
        expect(item.name).to eq("Koolaid") 
    end

    it "can destroy an item" do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)

        expect(Item.count).to eq(1)
        delete "/api/v1/items/#{item.id}"

        expect(response).to  be_successful
        expect(response).to  have_http_status(204)
        expect(Item.count).to eq(0)
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "finds an items merchant" do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)

        get "/api/v1/items/#{item.id}/merchant"

        expect(response).to  be_successful
        expect(response).to  have_http_status(200)
        response_body = JSON.parse(response.body, symbolize_names: true)
        found_merchant = response_body[:data]

        expect(found_merchant[:attributes][:name]).to eq(merchant.name)
    end
    
    
    

    
    
end