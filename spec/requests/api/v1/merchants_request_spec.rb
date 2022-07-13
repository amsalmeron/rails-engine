require 'rails_helper'

RSpec.describe 'Merchants API' do
    it "returns a list of merchants" do
        create_list(:merchant, 5)
        get '/api/v1/merchants'

        expect(response).to be_successful
        expect(response).to  have_http_status(200)

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchants = response_body[:data]

        expect(merchants.count).to eq(5) 
        merchants.each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant).to have_key(:type)
            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes][:name]).to be_a String
        end 
    end

    it "can return one merchants by its id" do
        id = create(:merchant).id
        get "/api/v1/merchants/#{id}"

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchant = response_body[:data]
        expect(response).to have_http_status(200)
        expect(merchant[:attributes][:name]).to be_a String 
    end
    
    it "can return a list of items for a specific merchant" do
        id = create(:merchant).id
        items = create_list(:item, 5, merchant_id: id)
        get "/api/v1/merchants/#{id}/items"

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchant_items = response_body[:data]
        
        expect(response).to have_http_status(200)
        expect(merchant_items.first[:type]).to eq('item')
        expect(merchant_items.first[:attributes][:name]).to be_a String 
        expect(merchant_items.first[:attributes][:description]).to be_a String 
        expect(merchant_items.first[:attributes][:unit_price]).to be_a Float 
    end
    
end