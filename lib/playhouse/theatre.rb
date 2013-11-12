require 'yaml'
require 'active_record'

module Playhouse
  class Theatre
    attr_reader :root_path

    def initialize(options)
      @root_path = options[:root] || Dir.pwd
      @environment = options[:environment] || (raise ArgumentError.new("environment option is required"))
    end

    def stage
      start_staging
      yield
      stop_staging
    end

    def start_staging
      Dir.chdir @root_path
      connect_to_database
    end

    def stop_staging
      nil
    end

    private

    def connect_to_database
      db_params = YAML.load(File.read(root_path + "/config/database.yml"))[@environment]
      ActiveRecord::Base.establish_connection db_params
    end
  end
end