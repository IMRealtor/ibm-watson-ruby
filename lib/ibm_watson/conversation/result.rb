module IBMWatson
  module Conversation
    class Result < IBMWatson::BaseModel
      attribute :entities
      attribute :input
      attribute :output
      attribute :context
      attribute :alternate_intents
      attribute :intents, type: [IntentResult]
    end
  end
end
