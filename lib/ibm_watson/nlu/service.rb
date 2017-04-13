module IBMWatson
  module NLU
    class Service < IBMWatson::BaseService
      version "v1"
      url "https://gateway.watsonplatform.net/natural-language-understanding/api"
      QUERY_VERSION = "2017-02-27"

      class FeatureDefinition

      end

      def analyze_text(text, language: 'en', keywords: false)
        # additional parameters not being implemented:
        #  - html (analyzing html)
        #  - url (analyzing urls)
        #  - clean (not sure what it does yet)

        features = {}
        features[:keywords] = {} if keywords
        # Features not implemented yet:
        # - concepts
        # - categories
        # - emotion
        # - entities
        # - metadata
        # - relations
        # - semantic_roles
        # - sentiment

        parameters = {
          text: text,
          language: language,
          # return_analyzed_text: true,
          features: features,
        }

        url = build_url('analyze', query: { version: QUERY_VERSION })
        result = accept_json(basic_auth).post(url, json: parameters)

        verify_http_result(result)

        IBMWatson::NLU::AnalyzeResult.new.tap do |result_object|
          result_object.from_json(result)
        end
      end

    end
  end
end
