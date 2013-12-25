require File.expand_path("../builder/version", __FILE__)

module Vx
  module Builder
    autoload :Source,        File.expand_path("../builder/source",        __FILE__)
    autoload :Configuration, File.expand_path("../builder/configuration", __FILE__)

    extend self

    def logger
      config.logger
    end

    def configure
      yield config if block_given?
      config
    end

    def config
      @config ||= Configuration.new
    end

    def reset_config!
      @config = nil
    end

  end
end
