require 'active_support/core_ext/string/inflections'
require 'playhouse/talent_scout'

module Playhouse
  # A Play is a cohesive collection of application logic (in the form of Contexts).
  # Your production might just contain one play, or you might prefer to have several
  # plays each with their own theme. Contexts are typically called through a play rather
  # that directly, and the Play will use it's TalentScout to ensure that the correct
  # Actors are found.
  #
  # Contexts within your play can call each other, but should not call Contexts in other
  # Plays directly, but can do so be calling the public interface on another Play.
  class Play
    class << self
      def context(context_class)
        context_classes << context_class

        define_method context_class.method_name do |params|
          execute_context(context_class, params)
        end
      end

      def context_classes
        @context_classes ||= []
      end

      def contexts_for(resource_module)
        resource_module.constants.each do |constant|
          context resource_module.const_get(constant)
        end
      end
    end

    def initialize(talent_scout = TalentScout.new)
      @talent_scout = talent_scout
    end

    def commands
      self.class.context_classes
    end

    def execute_context(context_class, params)
      @talent_scout.build_context(context_class, params).call
    end

    def name
      self.class.name.split('::').last.underscore
    end
  end

end