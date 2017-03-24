module IBMWatson
  module Conversation
    class Result < IBMWatson::BaseModel
      attribute :intents,
                type: ::IBMWatson::Conversation::IntentResult,
                typecaster: lambda { |values|
                  values.map do |value|
                    ::IBMWatson::Conversation::IntentResult.new(value)
                  end
                }
      attribute :entities
      attribute :input
      attribute :output, type: Hash
      attribute :context, type: Hash
      attribute :alternate_intents
    end
  end
end
