module IBMWatson
  module Conversation
    class Intent < IBMWatson::BaseModel
      attribute :intent, type: String
      attribute :created, type: String
      attribute :updated, type: String
      attribute :examples, type: [Hash]
      attribute :description
    end
  end
end
