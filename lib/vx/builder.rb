require File.expand_path("../builder/version", __FILE__)

module Vx
  module Builder
    autoload :Source,             File.expand_path("../builder/source",              __FILE__)
    autoload :Task,               File.expand_path("../builder/task",                __FILE__)
    autoload :Configuration,      File.expand_path("../builder/configuration",       __FILE__)
    autoload :BuildConfiguration, File.expand_path("../builder/build_configuration", __FILE__)
    autoload :MatrixBuilder,      File.expand_path("../builder/matrix_builder",      __FILE__)
    autoload :DeployBuilder,      File.expand_path("../builder/deploy_builder",      __FILE__)
    autoload :ScriptBuilderV2,    File.expand_path("../builder/script_builder_v2",   __FILE__)

    module Helper
      autoload :Config,         File.expand_path("../builder/helper/config",           __FILE__)
      autoload :TraceShCommand, File.expand_path("../builder/helper/trace_sh_command", __FILE__)
      autoload :VxvmInstall,    File.expand_path("../builder/helper/vxvm_install",     __FILE__)
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

    def matrix(build_configuration)
      MatrixBuilder.new(build_configuration)
    end

    def deploy(matrix_builder, options = {})
      DeployBuilder.new(matrix_builder, options)
    end

    def script_v2(task, build_configuration)
      ScriptBuilderV2.new task, build_configuration
    end

  end
end
