module IBMWatson
  module Conversation
    class DialogNode < IBMWatson::BaseModel
      attribute :go_to, type: Hash
      attribute :output, type: Hash
      attribute :parent, type: String
      attribute :context, type: Hash
      attribute :created, type: String
      attribute :updated, type: String
      attribute :metadata
      attribute :conditions, type: String
      attribute :description, type: String
      attribute :dialog_node, type: String
      attribute :previous_sibling, type: String
    end
  end
end
