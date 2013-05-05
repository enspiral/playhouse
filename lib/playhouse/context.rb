require 'active_support/core_ext/string/inflections'
require 'playhouse/part'
require 'playhouse/validation/actors_validator'

module Playhouse
  class Context
    class << self
      def parts
        @actor_definitions ||= []
      end

      def actor(name, options = {})
        raise ArgumentError, "use a symbol for actor name" unless name.is_a?(Symbol)

        parts << Part.new(name, options)

        define_method name do
          @actors[name]
        end
      end

      def part_for(name)
        raise ArgumentError, "use a symbol for actor name" unless name.is_a?(Symbol)
        parts.detect {|definition| definition.name == name}
      end

      def method_name
        name.split('::').last.underscore.to_sym
      end
    end

    def initialize(actors = {})
      @actors = {}
      actors.each do |name, actor|
        part = self.class.part_for(name)
        if part
          @actors[name] = part.cast(actor)
        else
          raise ArgumentError, "Unknown actor #{name.inspect} for #{self.class.name}"
        end
      end
    end

    def call
      validate_actors
      perform
    end

    def perform
      raise NotImplementedError.new("Context #{self.class.name} needs to override the perform method")
    end

    def validate_actors
      validator.validate_actors(self.class.parts, @actors)
    end

    def validator
      ActorsValidator.new
    end
  end
end