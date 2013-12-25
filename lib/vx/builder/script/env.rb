module Vx
  module Builder
    class Script

      Env = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.init << 'export LC_ALL=en_US.UTF8'
          env.source.global_env.each do |e|
            env.init << trace_sh_command("export #{e}")
          end
          env.announce << trace_sh_command("env")
          app.call(env)
        end

      end
    end
  end
end
