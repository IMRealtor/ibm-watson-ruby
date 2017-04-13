module IBMWatson
  module NLU
    class AnalyzeResult < IBMWatson::BaseModel
      class Keyword < IBMWatson::BaseModel
        attribute :text
        attribute :relevance
      end

      attribute :language
      attribute :analyzed_text
      attribute :retrieved_url
      attribute :usage

      attribute :concepts
      attribute :categories
      attribute :emotion
      attribute :entities
      attribute :keywords, type: [Keyword]
      attribute :metadata
      attribute :relations
      attribute :semantic_roles
      attribute :sentiment
    end
  end
end
