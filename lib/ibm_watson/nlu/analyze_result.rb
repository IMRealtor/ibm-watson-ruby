module IBMWatson
  module NLU
    class AnalyzeResult < IBMWatson::BaseModel
      class Keyword < IBMWatson::BaseModel
        attribute :text, type: String
        attribute :relevance, type: Float
      end

      attribute :language, type: String
      attribute :analyzed_text, type: String
      attribute :retrieved_url, type: String
      attribute :usage # no examples of this, so don't know type

      attribute :concepts, type: [Hash]
      attribute :categories, type: [Hash]
      attribute :emotion, type: Hash
      attribute :entities, type: [Hash]
      attribute :keywords, type: [Keyword]
      attribute :metadata, type: Hash
      attribute :relations, type: [Hash]
      attribute :semantic_roles, type: [Hash]
      attribute :sentiment, type: Hash
    end
  end
end
