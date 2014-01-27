module Vx
  module Builder
    class Script

      Env = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.init << "set -e"
          env.init << 'export LC_ALL=en_US.UTF8'
          env.source.global_env.each do |e|
            env.init << trace_sh_command("export #{e}")
          end
          app.call(env)
        end

      end
    end
  end
end
