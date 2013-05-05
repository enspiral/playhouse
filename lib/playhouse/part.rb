require 'playhouse/validation/required_actor_validator'

module Playhouse
  class Part
    attr_accessor :name, :repository, :role, :composer, :optional

    def initialize(name, options = {})
      @name = name

      options.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def cast(actor)
      @role ? @role.cast_actor(actor) : actor
    end

    def required
      !optional
    end

    def validators
      result = []
      result << RequiredActorValidator.new(name: name) if required
      result
    end
  end
end