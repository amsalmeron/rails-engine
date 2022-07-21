class Api::V1::MostItemMerchantsController < ApplicationController
    def index
        quantity = params[:quantity] ? params[:quantity] : 5
        merchants = Merchant.most_items_sold(quantity)
        render json: ItemsSoldSerializer.new(merchants)
    end
end