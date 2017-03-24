module IBMWatson
  module Conversation
    class OutputResult < IBMWatson::BaseModel
      attribute :log_messages, type: Array
      attribute :text, type: Array
      attribute :nodes_visited, type: Array
      attribute :action, type: String
      attribute :template, type: String
      attribute :choices, type: Hash
      attribute :boolean, type: Hash
      attribute :repeat_input, type: String
    end
  end
end
