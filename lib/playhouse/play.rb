require 'playhouse/talent_scout'

module Playhouse
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
      self.class.name.split('::')[1..-1].join('').underscore
    end
  end

end