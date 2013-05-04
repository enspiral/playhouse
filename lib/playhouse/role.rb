module Playhouse
  module Role
    class CastingException < Exception; end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def cast_actor(actor)
        check_depencies(actor)
        actor.extend(self)
      end

      private

      class Dependency
        def initialize(method_name, options)
          @method_name = method_name
          @default_role = options[:default_role]
        end

        def check(actor)
          unless actor.respond_to?(@method_name)
            if @default_role
              @default_role.cast_actor(actor)
            else
              raise CastingException.new("Trying to cast #{actor.class.name} but it doesn't support method #{@method_name}")
            end
          end
        end
      end

      def check_depencies(actor)
        dependencies.each do |dependency|
          dependency.check(actor)
        end
      end

      def dependencies
        @dependencies ||= []
      end

      def actor_dependency(method_name, options = {})
        dependencies << Dependency.new(method_name, options)
      end
    end
  end
end