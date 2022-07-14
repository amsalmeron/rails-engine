class Api::V1::SearchItemsController < ApplicationController 
    def index
        if params[:name]
            items = Item.where("name ILIKE ?", "%#{params[:name]}%")
            render json: ItemSerializer.new(items)
        else
            head :no_content
            render json: { data: { message: 'Items not found' } }
        end
    end

    def show
        if params[:name]
            item = Item.where("name ILIKE ?", "%#{params[:name]}%").order(:name).first
            render json: ItemSerializer.new(item)
        else
            head :no_content
            render json: { data: { message: 'Item not found' } }
        end
    end
    
end