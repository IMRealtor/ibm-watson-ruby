module IBMWatson
  module Errors
    class WatsonError < StandardError; end
    class WatsonRequestError < WatsonError; end
    class WatsonServerError < WatsonError; end
  end
end
