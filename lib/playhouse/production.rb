require 'playhouse/support/default_hash_values'

module Playhouse
  # A production is the complete collection of your application logic,
  # and is nearly an application ready to run. You just need to supply
  # a theatre and an interface and you can have a running app.
  class Production
    def run(options = {})
      options.extend Support::DefaultHashValues
      theatre = options.required_value :theatre
      interface = options.required_value :interface
      interface_instance = interface.build(self)

      theatre.while_open do
        interface_instance.run
      end
    end
  end
end
