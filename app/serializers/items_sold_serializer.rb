class ItemsSoldSerializer 
    include JSONAPI::Serializer
    attributes :name
    attributes :count do |merchant|
        merchant.total 
    end
end