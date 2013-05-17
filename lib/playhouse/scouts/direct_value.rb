module Playhouse
  module Scouts
    class DirectValue
      def actor_for_part(part, params)
        params[part.name]
      end
    end
  end
end