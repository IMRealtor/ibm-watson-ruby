module IBMWatson
  module Conversation
    extend ActiveSupport::Autoload

    autoload :Service
    autoload :MessageResponse
    autoload :CreateExampleResponse
    autoload :RuntimeIntent
    autoload :RuntimeEntity
    autoload :Intent
    autoload :DialogNode
    autoload :Workspace
  end
end
