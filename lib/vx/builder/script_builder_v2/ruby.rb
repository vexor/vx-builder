module Vx
  module Builder
    class ScriptBuilderV2

      class Ruby < Base

        DEFAULT_RUBY = '2.0.0'

        ALIASES = {
          'jruby-19mode' => 'jruby'
        }

        def call(env)
          if enabled?(env)

            do_cache_key(env) do |k|
              ruby_v = ruby_version(env) || DEFAULT_RUBY
              k << "rvm-#{ruby_v}"
              k << gemfile(env)
            end

            do_cached_directories(env) do |i|
              i << "~/.rubygems"
            end

            env.stage("init").tap do |i|
              if jruby?(env)
                i.add_env "JRUBY_OPTS", "\"-Xcext.enabled=true\""
              end
              i.add_env "RAILS_ENV", "test"
              i.add_env "RACK_ENV", "test"
              i.add_env "GEM_HOME", "~/.rubygems"
            end

            env.stage("install").tap do |i|
              i.add_task "ruby", "action" => "install", "ruby" => (ruby_version(env) || DEFAULT_RUBY)
              i.add_task "ruby", "announce"

              do_install(env) do
                i.add_env "BUNDLE_GEMFILE", "${PWD}/#{gemfile(env)}"
                if args = env.source.bundler_args.first
                  i.add_task "ruby", "action" => "bundle:install", "bundler_args" => args
                else
                  i.add_task "ruby", "bundle:install"
                end
              end
            end

            env.stage("database").tap do |i|
              do_database(env) do
                i.add_task "ruby", "rails:database"
              end
            end

            env.stage("script").tap do |i|
              do_script(env) do
                i.add_task "ruby", "script"
              end
            end

          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.rvm.first || env.source.language == 'ruby'
          end

          def ruby_version(env)
            v = env.source.rvm.first
            ALIASES[v] || v
          end

          def jruby?(env)
            ruby_version(env) =~ /jruby/
          end

          def gemfile(env)
            env.source.gemfile.first || "Gemfile"
          end

      end
    end
  end
end
