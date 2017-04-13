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

    # By default add all collection attributes are considered as if they were associations
    # this will make sure that `as_json` is called on them properly
    def as_json(options = nil)
      options ||= {}
      options[:include] = self.class.collection_attribute_names
      super(options)
    end

    # All [BaseModel] typed attributes are considered here
    def self.collection_attribute_names
      attributes.select { |name, attribute|
        attribute[:type].present? && attribute[:type].is_a?(Array) && attribute[:type].first <= BaseModel
      }.map { |name, attribute| name }
    end
  end
end
