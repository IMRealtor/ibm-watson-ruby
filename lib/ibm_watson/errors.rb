module IBMWatson
  module Errors
    class WatsonError < StandardError; end
    class WatsonRequestError < WatsonError; end
  end
end
