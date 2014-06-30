require 'vx/common'

module Vx
  module Builder
    class ScriptBuilder

      autoload :Base,         File.expand_path("../script_builder/base",      __FILE__)
      autoload :Env,          File.expand_path("../script_builder/env",       __FILE__)
      autoload :Ruby,         File.expand_path("../script_builder/ruby",      __FILE__)
      autoload :Java,         File.expand_path("../script_builder/java",      __FILE__)
      autoload :Scala,        File.expand_path("../script_builder/scala",     __FILE__)
      autoload :Clojure,      File.expand_path("../script_builder/clojure",   __FILE__)
      autoload :Script,       File.expand_path("../script_builder/script",    __FILE__)
      autoload :Prepare,      File.expand_path("../script_builder/prepare",   __FILE__)
      autoload :Databases,    File.expand_path("../script_builder/databases", __FILE__)
      autoload :Cache,        File.expand_path("../script_builder/cache",     __FILE__)
      autoload :Services,     File.expand_path("../script_builder/services",  __FILE__)
      autoload :Deploy,       File.expand_path("../script_builder/deploy",    __FILE__)
      autoload :Timeouts,     File.expand_path("../script_builder/timeouts",  __FILE__)

      include Common::Helper::Middlewares

      middlewares do
        use Builder::ScriptBuilder::Timeouts
        use Builder::ScriptBuilder::Cache
        use Builder::ScriptBuilder::Env
        use Builder::ScriptBuilder::Services
        use Builder::ScriptBuilder::Prepare
        use Builder::ScriptBuilder::Java
        use Builder::ScriptBuilder::Scala
        use Builder::ScriptBuilder::Clojure
        use Builder::ScriptBuilder::Ruby
        use Builder::ScriptBuilder::Deploy
        use Builder::ScriptBuilder::Script
      end

      attr_reader :source, :task

      def initialize(task, source)
        @source = source
        @task   = task
      end

      def image
        source.image.first
      end

      def to_before_script
        a = []
        a << "\n# init"
        a += env.init

        a << "\n# before install"
        a += env.before_install

        a << "\n# announce"
        a += env.announce

        a << "\n# install"
        a += env.install

        a << "\n# before script"
        a += env.before_script

        a.join("\n")
      end

      def to_after_script
        a = []
        a << "\n# after script init"
        a += env.after_script_init

        a << "\n# after script"
        a += env.after_script
        a.join("\n")
      end

      def to_script
        a = []

        a << "\n# script"
        a += env.script

        a << "\n# after success"
        a += env.after_success

        a.join("\n")
      end

      def vexor
        source.vexor
      end

      private

        def env
          @env ||= run_middlewares(default_env) {|_| _ }
        end

        def default_env
          OpenStruct.new(
            # initialization, repo does not exists
            init:               [],

            # before instalation, using for system setup
            before_install:     [],

            # instalation, using for application setup
            install:            [],

            # announce software and services version
            announce:           [],

            before_script:      [],
            script:             [],
            after_success:      [],

            after_script_init:  [],
            after_script:       [],

            before_deploy:      [],
            deploy:             [],

            source:             source,
            task:               task,
            cache_key:          [],
            cached_directories: []
          )
        end

    end
  end
end
