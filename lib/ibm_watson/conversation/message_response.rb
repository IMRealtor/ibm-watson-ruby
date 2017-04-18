module IBMWatson
  module Conversation
    class MessageResponse < IBMWatson::BaseModel
      attribute :entities, type: [RuntimeEntity]
      attribute :input
      attribute :output
      attribute :context
      attribute :alternate_intents
      attribute :intents, type: [RuntimeIntent]
    end
  end
end
