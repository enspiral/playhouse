require 'playhouse/scouts/can_construct_object'

module Playhouse
  module Scouts
    class BuildWithComposer
      def actor_for_part(part, params)
        if part.composer
          param_value = params[part.name]
          if param_value
            part.composer.compose(param_value)
          else
            nil
          end
        else
          nil
        end
      end

      private

      def object_builder(part)
      end

      def param_suffix
        "attributes"
      end

      def build_method
        :compose
      end
    end
  end
end