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
      attribute :intents, type: [Intent]
      attribute :entities, type: [Hash]
      attribute :counterexamples, type: [Hash]
      attribute :dialog_nodes, type: [DialogNode]
    end
  end
end
