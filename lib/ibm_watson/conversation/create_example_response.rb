module IBMWatson
  module Conversation
    class CreateExampleResponse < IBMWatson::BaseModel
      attribute :text, type: String
      attribute :created, type: String
      attribute :updated, type: String
    end
  end
end
