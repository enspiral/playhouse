require 'playhouse/support/default_hash_values'

module Playhouse
  # A production is the complete collection of your application logic,
  # and is nearly an application ready to run. You just need to supply
  # a theatre and an interface and you can have a running app.
  class Production
    def initialize
      @plays = []
    end

    def run(options = {})
      options.extend Support::DefaultHashValues
      theatre = options.required_value :theatre
      interface = options.required_value :interface
      interface_instance = interface.build(self)

      theatre.while_open do
        interface_instance.run options[:interface_args]
      end
    end

    # Your production should inherit from this class and call this method
    # in it's initialize method. This method is public just in case you
    # want to build your production from the outside, but that's not really
    # necessary or recommended.
    def add_play(play_class)
      @plays << play_class.new
    end

    attr_reader :plays
  end
end
