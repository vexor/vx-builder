module Vx
  module Builder
    class Script

      Services = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.source.services.each do |srv|
            env.init << trace_sh_command(
              "sudo /usr/bin/env PATH=/sbin:/usr/sbin:$PATH service #{srv} start",
              trace: "sudo service #{srv} start")
          end
          unless env.source.services.empty?
            env.init << trace_sh_command("sleep 3")
          end

          app.call(env)
        end

      end
    end
  end
end
