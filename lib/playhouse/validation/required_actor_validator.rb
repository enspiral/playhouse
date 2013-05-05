module Playhouse
  class ActorValidator
    def initialize(options)
      @part_name = options[:name]
    end

    private

      attr_accessor :part_name
  end

  class RequiredActorValidator < ActorValidator
    def validate_actor(actor)
      raise RequiredActorMissing.new(name: part_name) if actor.nil?
    end
  end
end