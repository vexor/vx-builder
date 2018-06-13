require 'erb'
require 'base64'
require 'vx/common'

module Vx
  module Builder
    class ScriptBuilderV2

      TEMPLATE_SOURCE = File.expand_path("../templates/script_builder_v2/to_script.erb", __FILE__)
      TEMPLATE = ::ERB.new(File.read(TEMPLATE_SOURCE))

      autoload :Base,         File.expand_path("../script_builder_v2/base",      __FILE__)
      autoload :Env,          File.expand_path("../script_builder_v2/env",       __FILE__)
      autoload :Ruby,         File.expand_path("../script_builder_v2/ruby",      __FILE__)
      autoload :Go,           File.expand_path("../script_builder_v2/go",        __FILE__)
      autoload :Nodejs,       File.expand_path("../script_builder_v2/nodejs",    __FILE__)
      autoload :Java,         File.expand_path("../script_builder_v2/java",      __FILE__)
      autoload :Scala,        File.expand_path("../script_builder_v2/scala",     __FILE__)
      autoload :Clojure,      File.expand_path("../script_builder_v2/clojure",   __FILE__)
      autoload :Rust,         File.expand_path("../script_builder_v2/rust",      __FILE__)
      autoload :Python,       File.expand_path("../script_builder_v2/python",    __FILE__)
      autoload :Php,          File.expand_path("../script_builder_v2/php",       __FILE__)
      autoload :Clone,        File.expand_path("../script_builder_v2/clone",     __FILE__)
      autoload :Databases,    File.expand_path("../script_builder_v2/databases", __FILE__)
      autoload :Cache,        File.expand_path("../script_builder_v2/cache",     __FILE__)
      autoload :Services,     File.expand_path("../script_builder_v2/services",  __FILE__)
      autoload :Deploy,       File.expand_path("../script_builder_v2/deploy",    __FILE__)
      autoload :Defaults,     File.expand_path("../script_builder_v2/defaults",  __FILE__)
      autoload :UserEnv,      File.expand_path("../script_builder_v2/user_env",  __FILE__)

      class Stage
        attr_reader :name, :environment, :tasks, :vars, :chdir
        def initialize(options = {})
          @name        = options[:name]
          @environment = options[:environment] || {}
          @tasks       = []
          @vars        = {}
          @chdir       = nil
        end

        def add_task(name, value)
          @tasks.push(name => value)
        end

        def clean_tasks!
          @tasks = []
        end

        def tasks?
          @tasks.any?
        end

        def add_env(name, value, options = {})
          if options[:hidden]
            @environment[name] = "!#{value}"
          else
            @environment[name] = value
          end
        end

        def clean_env!
          @environment = {}
        end

        def chdir!(dir)
          @chdir = dir
        end

        def add_var(name, value)
          @vars[name] = value
        end

        def clean_vars!
          @vars = {}
        end

        def to_hash
          h = { "name" => name }
          h.merge!("chdir" => chdir) if chdir
          h.merge!("vars" => vars) if vars.any?
          h.merge!( "environment" => environment ) if environment.any?
          h.merge!("tasks" => tasks) if tasks?
          h
        end

        def process_task(processor)
          processor.(self)
        end

      end

      include Common::Helper::Middlewares

      middlewares do
        use Builder::ScriptBuilderV2::Cache
        use Builder::ScriptBuilderV2::Env
        use Builder::ScriptBuilderV2::Services
        use Builder::ScriptBuilderV2::Clone

        use Builder::ScriptBuilderV2::Java
        use Builder::ScriptBuilderV2::Scala
        use Builder::ScriptBuilderV2::Clojure
        use Builder::ScriptBuilderV2::Ruby
        use Builder::ScriptBuilderV2::Go
        use Builder::ScriptBuilderV2::Nodejs
        use Builder::ScriptBuilderV2::Rust
        use Builder::ScriptBuilderV2::Python
        use Builder::ScriptBuilderV2::Php

        use Builder::ScriptBuilderV2::UserEnv

        use Builder::ScriptBuilderV2::Deploy
        use Builder::ScriptBuilderV2::Defaults
      end

      attr_reader :source, :task, :stages, :cache_key

      def initialize(task, source)
        @source    = source
        @task      = task
        @stages    = []
        @cache_key = []
      end

      def stage(name)
        found = find_stage(name)
        unless found
          found = Stage.new(name: name)
          @stages.push found
        end
        found
      end

      def find_stage(name)
        @stages.find{|i| i.name == name }
      end

      def to_script
        @script ||=
          begin
            TEMPLATE.result(binding)
          end
      end

      def to_hash
        @hash ||=
          begin
            call_env
            ordered = %w{
              clone init before_install install database
              before_script script after_success teardown
            }.inject([]) do |a, name|
              if found = find_stage(name)
                a << found
              end
              a
            end

            ordered.map(&:to_hash)
          end
      end

      def to_yaml
        to_hash.to_yaml
      end

      def vexor
        source.vexor
      end

      private

        def call_env
          @env ||= run_middlewares(self) {|_| _ }
        end

    end
  end
end
