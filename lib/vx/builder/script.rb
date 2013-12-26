require 'vx/common'

module Vx
  module Builder
    class Script

      autoload :Env,          File.expand_path("../script/env",           __FILE__)
      autoload :Ruby,         File.expand_path("../script/ruby",          __FILE__)
      autoload :Script,       File.expand_path("../script/script",        __FILE__)
      autoload :Prepare,      File.expand_path("../script/prepare",       __FILE__)
      autoload :Databases,    File.expand_path("../script/databases",     __FILE__)
      autoload :WebdavCache,  File.expand_path("../script/webdav_cache",  __FILE__)
      autoload :Services,     File.expand_path("../script/services",      __FILE__)

      include Common::Helper::Middlewares

      middlewares do
        use Builder::Script::WebdavCache
        use Builder::Script::Services
        use Builder::Script::Env
        use Builder::Script::Prepare
        use Builder::Script::Ruby
        use Builder::Script::Script
      end

      attr_reader :source, :task

      def initialize(task, source)
        @source = source
        @task   = task
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
        a << "\n# after script"
        a += env.after_script
        a.join("\n")
      end

      def to_script
        a = []
        a << "\n# script"
        a += env.script
        a.join("\n")
      end

      private

        def env
          @env ||= run_middlewares(default_env) {|_| _ }
        end

        def default_env
          OpenStruct.new(
            # initialization, repo does not exists
            init:            [],

            # before instalation, using for system setup
            before_install:  [],

            # instalation, using for application setup
            install:         [],

            # announce software and services version
            announce:        [],

            before_script:   [],
            script:          [],
            after_script:    [],

            source:          source,
            task:            task,
            cache_key:       []
          )
        end

    end
  end
end
