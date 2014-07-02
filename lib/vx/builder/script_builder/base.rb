module Vx
  module Builder
    class ScriptBuilder

      Base = Struct.new(:app) do

        include Helper::TraceShCommand
        include Helper::VxvmInstall

        def do_cache_key(env)
          yield env.cache_key
        end

        def do_script(env)
          if env.source.script.empty? && !env.source.deploy_modules?
            yield env.script
          end
        end

        def do_cached_directories(env)
          if env.source.cached_directories != false
            yield env.cached_directories
          end
        end

        def do_announce(env)
          yield env.announce
        end

        def do_before_install(env)
          yield env.before_install
        end

        def do_install(env)
          if env.source.install.empty?
            yield env.install
          end
        end

        def do_deploy_script(env)
          if deploy?(env)
            yield env.script
          end
        end

        def do_before_deploy(env)
          if deploy?(env)
            yield env.before_script
          end
        end

        def do_after_deploy(env)
          if deploy?(env)
            yield env.after_success
          end
        end

        def deploy?(env)
          env.source.deploy_modules?
        end

      end

    end
  end
end
