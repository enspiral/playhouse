require 'yaml'
require 'active_record'
require 'playhouse/support/default_hash_values'

module Playhouse
  class Theatre
    class DoubleBookedError < Exception; end

    attr_reader :root_path

    class << self
      attr_reader :current

      def current=(value)
        if @current
          raise DoubleBookedError.new("You already have #{@current.inspect} staged")
        end
        @current = value
      end

      def clear_current
        @current = nil
      end
    end

    def initialize(options = {})
      options.extend Support::DefaultHashValues

      @environment = options.value_or_error :environment, ArgumentError.new("environment option is required")
      @root_path =   options.value_or_default :root, Dir.pwd
      @load_db =     options.value_or_default :load_db, true
    end

    def stage
      start_staging
      yield
      stop_staging
    end

    def start_staging
      Dir.chdir @root_path
      connect_to_database
      self.class.current = self
    end

    def stop_staging
      self.class.clear_current
    end

    private

    def connect_to_database
      if @load_db
        db_params = YAML.load(File.read(root_path + "/config/database.yml"))[@environment.to_s]
        ActiveRecord::Base.establish_connection db_params
      end
    end
  end
end