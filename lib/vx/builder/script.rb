require 'vx/common'

module Vx
  module Builder
    class Script

      autoload :Base,         File.expand_path("../script/base",          __FILE__)
      autoload :Env,          File.expand_path("../script/env",           __FILE__)
      autoload :Ruby,         File.expand_path("../script/ruby",          __FILE__)
      autoload :Java,         File.expand_path("../script/java",          __FILE__)
      autoload :Scala,        File.expand_path("../script/scala",         __FILE__)
      autoload :Clojure,      File.expand_path("../script/clojure",       __FILE__)
      autoload :Script,       File.expand_path("../script/script",        __FILE__)
      autoload :Prepare,      File.expand_path("../script/prepare",       __FILE__)
      autoload :Databases,    File.expand_path("../script/databases",     __FILE__)
      autoload :Cache,        File.expand_path("../script/cache",         __FILE__)
      autoload :Services,     File.expand_path("../script/services",      __FILE__)
      autoload :Artifacts,    File.expand_path("../script/artifacts",     __FILE__)
      autoload :Deploy,       File.expand_path("../script/deploy",        __FILE__)

      include Common::Helper::Middlewares

      middlewares do
        use Builder::Script::Cache
        use Builder::Script::Artifacts
        use Builder::Script::Env
        use Builder::Script::Services
        use Builder::Script::Prepare
        use Builder::Script::Java
        use Builder::Script::Scala
        use Builder::Script::Clojure
        use Builder::Script::Ruby
        use Builder::Script::Deploy
        use Builder::Script::Script
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

        if deploy?
          a << "\n# before deploy"
        else
          a << "\n# before script"
        end
        a += env.before_script

        a.join("\n")
      end

      def to_after_script
        a = []
        a << "\n# after script init"
        a += env.after_script_init

        if deploy?
          a << "\n# after deploy"
        else
          a << "\n# after script"
        end
        a += env.after_script
        a.join("\n")
      end

      def to_script
        a = []
        if deploy?
          a << "\n# deploy"
          a += env.deploy
        else
          a << "\n# script"
          a += env.script

          a << "\n# after success"
          a += env.after_success
        end

        a.join("\n")
      end

      def deploy?
        task.deploy?
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
