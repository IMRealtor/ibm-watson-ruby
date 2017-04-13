module IBMWatson
  module Conversation
    class Result < IBMWatson::BaseModel
      attribute :entities
      attribute :input
      attribute :output
      attribute :context
      attribute :alternate_intents

      def intents=(values)
        @intents = values.map do |value|
          ::IBMWatson::Conversation::IntentResult.new(value)
        end
      end
      attr_reader :intents

      def as_json(*)
        super.merge({
                      "intents" => intents.as_json
                    })
      end
    end
  end
end
