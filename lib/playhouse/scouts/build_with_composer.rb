require 'playhouse/scouts/can_construct_object'

module Playhouse
  module Scouts
    class BuildWithComposer
      include CanConstructObject

      private

      def object_builder(part)
        part.composer
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