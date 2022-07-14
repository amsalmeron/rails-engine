class Api::V1::SearchMerchantsController < ApplicationController 
    def index
        if params[:name]
            merchants = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
            render json: MerchantSerializer.new(merchants)
        else
            head :no_content
            render json: { data: { message: 'Items not found' } }
        end
    end

    def show
        if params[:name]
            item = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
            render json: MerchantSerializer.new(item)
        else
            head :no_content
            render json: { data: { message: 'Item not found' } }
        end
    end
    
end