module IBMWatson
  module Errors
    class WatsonError < StandardError
    end

    class WatsonRequestError < WatsonError
    end

    class WatsonServerError < WatsonError
    end

    class WatsonTimeoutError < WatsonServerError
    end
  end
end
