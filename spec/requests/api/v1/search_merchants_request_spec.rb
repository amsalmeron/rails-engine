require 'rails_helper'

RSpec.describe 'Search Merchants API' do
    it "returns a list of matching merchants after a search" do
        merchant_1 = Merchant.create!(name: 'Teddy')
        merchant_2 = Merchant.create!(name: 'Freddy')
        merchant_3 = Merchant.create!(name: 'Margie')
        merchant_4 = Merchant.create!(name: 'Alex')
        merchant_5 = Merchant.create!(name: 'Jeddi')

        get '/api/v1/merchants/find_all?name=dd'

        expect(response).to be_successful
        expect(response).to  have_http_status(200)

        response_body = JSON.parse(response.body, symbolize_names: true)
        found_merchants = response_body[:data]

        expect(found_merchants.count).to eq(3) 
        found_merchants.each do |merchant|
            expect(merchant).to have_key(:id)
            expect(merchant).to have_key(:type)
            expect(merchant).to have_key(:attributes)
            expect(merchant[:attributes][:name]).to be_a String
        end
    end


    it "finds one(first alphabetical) item that matches search description" do
        merchant_1 = Merchant.create!(name: 'Teddy')
        merchant_2 = Merchant.create!(name: 'Freddy')
        merchant_3 = Merchant.create!(name: 'Margie')
        merchant_4 = Merchant.create!(name: 'Alex')
        merchant_5 = Merchant.create!(name: 'Jeddi')

        get '/api/v1/merchants/find?name=dd'


        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response).to  be_successful
        expect(response).to  have_http_status(200)

        found_merchant = merchant[:data]

        expect(found_merchant[:attributes][:name]).to  eq('Freddy')
    end
end