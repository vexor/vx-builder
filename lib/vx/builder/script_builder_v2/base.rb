module Vx
  module Builder
    class ScriptBuilderV2

      Base = Struct.new(:app) do

        def do_cache_key(env)
          yield env.cache_key
        end

        def do_cached_directories(env)
          if env.source.cached_directories != false
            yield env.source.cached_directories
          end
        end

        def do_script(env)
          if env.source.script.empty? && !env.source.deploy_modules?
            yield
          end
        end

        def do_install(env)
          if env.source.install.empty?
            yield
          end
        end

        def do_before_script(env)
          if env.source.before_script.empty? && !deploy?(env)
            yield
          end
        end

        def do_database(env)
          if env.source.database.empty? && env.source.database?
            yield
          end
        end

        def do_deploy_script(env)
          if deploy?(env)
            yield
          end
        end

        def do_before_deploy(env)
          if deploy?(env)
            yield
          end
        end

        def do_after_deploy(env)
          if deploy?(env)
            yield
          end
        end

        def deploy?(env)
          env.source.deploy_modules?
        end

      end

    end
  end
end
