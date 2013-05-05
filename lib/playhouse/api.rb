require 'active_support/core_ext/string/inflections'

module Playhouse
  class API
    class << self
      def context(context_class)
        context_classes << context_class

        method_name = context_class.name.split('::').last.underscore.to_sym

        define_method method_name do |params|
          context_class.new(params).call
        end
      end

      def context_classes
        @context_classes ||= []
      end
    end
  end
end