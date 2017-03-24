module IBMWatson
  module Conversation
    class IntentResult < IBMWatson::BaseModel
      attribute :intent, type: String
      attribute :confidence, type: Float
    end
  end
end
