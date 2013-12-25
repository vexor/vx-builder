module Vx
  module Builder
    class Script

      Script = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.source.before_script.each do |c|
            env.before_script << trace_sh_command(c)
          end
          env.source.script.each do |c|
            env.script << trace_sh_command(c)
          end
          app.call(env)
        end

      end
    end
  end
end
