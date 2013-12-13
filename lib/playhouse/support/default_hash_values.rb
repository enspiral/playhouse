module Playhouse
  module Support
    module DefaultHashValues
      def value_or_default(key, default)
        value_or_do(key) { default }
      end

      def value_or_error(key, error)
        value_or_do(key) { raise(error) }
      end

      private

        def value_or_do(key)
          self[key].nil? ? yield : self[key]
        end
    end
  end
end