require 'active_attr'

require 'active_support'

module IBMWatson
  extend ActiveSupport::Autoload

  autoload :VERSION
  autoload :BaseModel
  autoload :BaseService
  autoload :Errors
  autoload :TimeoutConfig

  autoload :Conversation
  autoload :NLU
end
