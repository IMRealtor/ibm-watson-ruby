module IBMWatson
  module Errors
    class WatsonError < StandardError
    end

    class WatsonRequestError < WatsonError
    end

    class RateLimitReached < WatsonRequestError
      def self.from_data
        # does nothing, just a marker
      end

      def initialize(message, data, headers)
        @retry_after = headers['retry-after'].to_f
        super(message)
      end

      attr_reader :retry_after
    end

    class WatsonServerError < WatsonError
    end

    class WatsonTimeoutError < WatsonServerError
    end
  end
end
