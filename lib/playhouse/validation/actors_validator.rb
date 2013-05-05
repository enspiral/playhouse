require 'playhouse/validation/validation_errors'

module Playhouse
  class ActorsValidator
    def validate_actors(parts, actors)
      parts.each do |part|
        part.validators.each do |validator|
          validator.validate_actor(actors[part.name])
        end
      end
    end
  end
end