module IBMWatson
  module Conversation
    class Workspace < IBMWatson::BaseModel
      attribute :name, type: String
      attribute :description, type: String
      attribute :language, type: String
      attribute :metadata, type: Hash
      attribute :created, type: String
      attribute :updated, type: String
      attribute :workspace_id, type: String
      attribute :status, type: String
      attribute :intents, type: ::IBMWatson::Conversation::Intent,
                typecaster: lambda { |values| values.map { |value| ::IBMWatson::Conversation::Intent.new(value) } }
      attribute :entities, type: Array
      attribute :counterexamples, type: Array
      attribute :dialog_nodes, type: ::IBMWatson::Conversation::DialogNode,
                typecaster: lambda { |values| values.map { |value| ::IBMWatson::Conversation::DialogNode.new(value) } }
    end
  end
end
