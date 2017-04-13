module IBMWatson
  class BaseModel
    include ActiveAttr::Model
    include ActiveAttr::AttributeDefaults

    # Support "Collection" attributes, eg:
    #   attribute :foo, type: [String]
    def typecaster_for(type)
      if type.kind_of?(Array) && type.length == 1 && type.first.is_a?(Class)
        item_type = type.first
        lambda do |value|
          value.map { |item|
            unless item.is_a?(item_type)
              item = item_type.new(item)
            end
            item
          }
        end
      else
        super
      end
    end
  end
end
