module Vx
  module Builder
    class Script

      Java = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          if java(env)
            env.cache_key << "jdk-#{java env}"

            env.before_install.tap do |i|
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
