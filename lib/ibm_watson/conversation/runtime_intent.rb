module IBMWatson
  module Conversation
    class RuntimeIntent < IBMWatson::BaseModel
      attribute :intent, type: String
      attribute :confidence, type: Float
    end
  end
end
