module IBMWatson
  class TimeoutConfig
    include ActiveAttr::Model
    include ActiveAttr::AttributeDefaults

    attribute :connect # connection open timeout in seconds
    attribute :read # open/read timeout in seconds
  end
end
