module Playhouse
  class Part
    attr_accessor :name, :repository, :role, :composer

    def initialize(name, options = {})
      @name = name

      options.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def cast(actor)
      @role ? @role.cast_actor(actor) : actor
    end
  end
end