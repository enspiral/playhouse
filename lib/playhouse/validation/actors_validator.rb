require 'playhouse/validation/validation_errors'

module Playhouse
  class ActorsValidator
    def validate_actors(parts, actors)
      error = ContextValidationError.new
      raise_error = false

      parts.each do |part|
        part.validators.each do |validator|
          begin
            validator.validate_actor(actors[part.name])
          rescue ActorValidationError => actor_error
            raise_error = true
            error.add_to_part(part.name, actor_error)
          end
        end
      end

      raise error if raise_error
    end
  end
end