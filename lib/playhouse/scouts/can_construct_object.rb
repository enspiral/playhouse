module Playhouse
  module Scouts
    module CanConstructObject
      def actor_for_part(part, params)
        if object_builder(part)
          param_key = "#{part.name}_#{param_suffix}"
          param_value = params[param_key]
          object_builder(part).send(build_method, param_value) if param_value
        else
          nil
        end
      end
    end
  end
end