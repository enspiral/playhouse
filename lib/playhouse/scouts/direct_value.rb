module Playhouse
  module Scouts
    class DirectValue
      def actor_for_part(part, params)
        params[part.name.to_s]
      end
    end
  end
end