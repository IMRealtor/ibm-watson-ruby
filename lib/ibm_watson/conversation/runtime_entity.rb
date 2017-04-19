module IBMWatson
  module Conversation
    class RuntimeEntity < IBMWatson::BaseModel
      attribute :entity, type: String
      attribute :location, type: [Integer]
      attribute :value, type: String
      attribute :confidence, type: Float
      attribute :metadata, type: Hash
    end
  end
end
