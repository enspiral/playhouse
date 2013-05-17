require 'playhouse/scouts/build_with_composer'
require 'playhouse/scouts/direct_value'
require 'playhouse/scouts/entity_from_repository'

# Finds the actors for a context. The name of this class
# might be a bit creative since I felt the need to explain it.
module Playhouse
  class TalentScout
    def build_context(context_class, params)
      context_class.new(actors_for_params(context_class, params))
    end

    private

    def actors_for_params(context_class, params)
      actors = {}
      context_class.parts.each do |part|
        actor = actor_for_part(part, params)
        actors[part.name] = actor if actor
      end
      actors
    end

    def scouts
      [Scouts::DirectValue, Scouts::EntityFromRepository, Scouts::BuildWithComposer].map(&:new)
    end

    def actor_for_part(part, params)
      scouts.each do |scout|
        actor = scout.actor_for_part(part, params)
        return actor if actor
      end
      nil
    end
  end
end