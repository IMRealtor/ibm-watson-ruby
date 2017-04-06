module IBMWatson
  class BaseService
    class << self
      def url(url)
        define_method :service_url do
          url
        end
      end

      def version(version)
        define_method :service_version do
          version
        end
      end
    end

    def initialize(username:, password:)
      @username = username
      @password = password
    end

    private

    attr_reader :username, :password

    def parse_array(json_string, model_class, root_key)
      array = JSON.parse(json_string).fetch(root_key)
      array.map do |attributes|
        model_class.new attributes
      end
    end

    def build_url(*paths, query: {})
      url = [service_url, service_version, paths.join('/')].join("/")
      if query.any?
        url += "?" + query.to_query
      end
      url
    end

    def collection_url(cluster_id, collection_name, resource)
      build_url('solr_clusters', cluster_id, 'solr', collection_name, resource)
    end

    def accept_json(http_chain)
      http_chain.headers(accept: "application/json")
    end

    def verify_http_result(result, verify_json: true)
      if result.status.between?(200, 299)
        if verify_json
          verify_no_json_failure(result)
        end
      elsif result.status.between?(400, 499)
        generic_error_handler(IBMWatson::Errors::WatsonRequestError, result)
      elsif result.status.between?(500, 599)
        generic_error_handler(IBMWatson::Errors::WatsonServerError, result)
      end
    end

    def generic_error_handler(erorr_klass, result)
      if result.content_type.mime_type == 'application/json'
        json_data = JSON.parse(result.body)
        raise erorr_klass, "Server returned #{result.status} : #{json_data['error']}"
      else
        raise erorr_klass, "Server returned #{result.status} : #{result.reason}"
      end
    end

    def verify_no_json_failure(result)
      json_data = JSON.parse(result.body)
      if json_data['failure']
        raise IBMWatson::Errors::WatsonError, json_data['failure'].values.first
      end
    end

    def basic_auth
      HTTP.basic_auth(user: username, pass: password)
    end
  end
end
