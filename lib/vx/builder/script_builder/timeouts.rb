module Vx
  module Builder
    class ScriptBuilder

      class Timeouts < Base

        def call(env)
          if tm = env.source.vexor.read_timeout
            env.init << "echo Vexor: set read timeout to #{tm} seconds"
          end
          if tm = env.source.vexor.timeout
            env.init << "echo Vexor: set timeout to #{tm} seconds"
          end

          app.call(env)
        end

      end
    end
  end
end
