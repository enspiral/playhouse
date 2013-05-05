module Playhouse
  class ContextValidationError < Exception; end

  class RequiredActorMissing < ContextValidationError
    def initialize(options)
      @name = options[:name]
    end

    def message
      "Missing actor #{@name}"
    end
  end
end