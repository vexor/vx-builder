require File.expand_path("../builder/version", __FILE__)

module Vx
  module Builder
    autoload :Source,        File.expand_path("../builder/source",        __FILE__)
    autoload :Script,        File.expand_path("../builder/script",        __FILE__)
    autoload :Task,          File.expand_path("../builder/task",          __FILE__)
    autoload :Configuration, File.expand_path("../builder/configuration", __FILE__)
    autoload :BuildConfiguration, File.expand_path("../builder/build_configuration", __FILE__)

    module Helper
      autoload :Config, File.expand_path("../builder/helper/config", __FILE__)
      autoload :TraceShCommand, File.expand_path("../builder/helper/trace_sh_command", __FILE__)
    end

    class MissingKeys < Exception ; end

    extend self

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
