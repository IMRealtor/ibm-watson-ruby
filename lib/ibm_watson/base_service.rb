require 'faraday'
require 'faraday/encoding'

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

    # @param [String] username
    # @param [String] password
    # @param [TimeoutConfig] timeouts
    def initialize(username:, password:, timeouts: default_timeouts)
      @username = username
      @password = password
      @timeouts = timeouts
    end

    private

    attr_reader :username, :password, :timeouts

    def default_timeouts
      TimeoutConfig.new(connect: 30, read: 30)
    end

    def connection
      Faraday.new(url: "#{service_url}/#{service_version}") do |faraday|
        faraday.response :encoding
        # faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        faraday.headers[:content_type] = 'application/json; charset=UTF-8'
        faraday.headers[:accept] = 'application/json'
        faraday.headers[:user_agent] = "IBM Watson Ruby #{IBMWatson::VERSION}"
        faraday.basic_auth(username, password)
        faraday.options.timeout = timeouts.read
        faraday.options.open_timeout = timeouts.connect
      end
    end

    def get(path, *args)
      retry_maybe do
        result = connection.get(path, *args)
        verify_http_result(result)
        JSON.parse(result.body)
      end
    end

    def delete(path, *args)
      retry_maybe do
        result = connection.delete(path, *args)
        verify_http_result(result)
        JSON.parse(result.body) if result.body.present?
      end
    end

    def post(path, body, *args)
      retry_maybe do
        body = JSON.generate(body) unless body.kind_of?(String)
        result = connection.post(path, body, *args)
        verify_http_result(result)
        JSON.parse(result.body)
      end
    end

    def parse_array(json_string, model_class, root_key)
      array = JSON.parse(json_string).fetch(root_key)
      array.map do |attributes|
        model_class.new attributes
      end
    end

    def collection_url(cluster_id, collection_name, resource)
      build_url('solr_clusters', cluster_id, 'solr', collection_name, resource)
    end

    def handle_timeout_error(timeout_error)
      raise IBMWatson::Errors::WatsonTimeoutError, timeout_error
    end

    def verify_http_result(result, verify_json: true)
      if result.status.between?(200, 299)
        if verify_json
          verify_no_json_failure(result)
        end
      elsif result.status == 429
        generic_error_handler(IBMWatson::Errors::RateLimitReached, result)
      elsif result.status.between?(400, 499)
        generic_error_handler(IBMWatson::Errors::WatsonRequestError, result)
      elsif result.status.between?(500, 599)
        generic_error_handler(IBMWatson::Errors::WatsonServerError, result)
      end
    end

    def generic_error_handler(error_klass, result)
      if result.headers[:content_type].split(';').first == 'application/json'
        json_data = JSON.parse(result.body)
        if error_klass.respond_to?(:from_data)
          raise error_klass.new("Server returned #{result.status} : #{json_data['error']}", json_data, result.headers)
        else
          raise error_klass, "Server returned #{result.status} : #{json_data['error']}"
        end
      else
        raise error_klass, "Server returned #{result.status} : #{result.reason}"
      end
    end

    def verify_no_json_failure(result)
      json_data = JSON.parse(result.body)
      if json_data['failure']
        raise IBMWatson::Errors::WatsonError, json_data['failure'].values.first
      end
    end

    def handle_timeout
      yield
    rescue Net::OpenTimeout => error
      handle_timeout_error(error)
    rescue Faraday::Error::TimeoutError => error
      handle_timeout_error(error)
    end

    def retry_maybe
      yield
    rescue Errors::RateLimitReached => e
      warn("Rate Limit Reached, waiting for #{e.retry_after} seconds ...")
      sleep e.retry_after
      retry
    end
  end
end
