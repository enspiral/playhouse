module Playhouse
  class API
    class << self
      def context(context_class)
        context_classes << context_class

        define_method context_class.method_name do |params|
          context_class.new(params).call
        end
      end

      def context_classes
        @context_classes ||= []
      end
    end

    def commands
      self.class.context_classes
    end
  end
end