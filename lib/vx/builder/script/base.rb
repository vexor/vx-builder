module Vx
  module Builder
    class Script

      Base = Struct.new(:app) do

        include Helper::TraceShCommand

        def do_cache_key(env)
          yield env.cache_key
        end

        def do_script(env)
          if env.source.script.empty?
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
          yield env.install
        end
      end

    end
  end
end
