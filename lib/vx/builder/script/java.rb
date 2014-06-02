module Vx
  module Builder
    class Script

      class Java < Base

        def call(env)
          if java(env)
            do_cache_key(env) do |i|
              i << "jdk-#{java env}"
            end

            do_before_install(env) do |i|
              i << "source $(which jdk_switcher.sh)"
              i << trace_sh_command("jdk_switcher use #{java env}")
            end
          end

          app.call(env)
        end

        private

          def java(env)
            env.source.jdk.first
          end

      end
    end
  end
end
