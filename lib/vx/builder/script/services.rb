module Vx
  module Builder
    class Script

      Services = Struct.new(:app) do

        ALIASES = {
          'rabbitmq' => 'rabbitmq-server'
        }

        include Helper::TraceShCommand

        def call(env)
          env.source.services.each do |srv|
            srv = ALIASES[srv] || srv
            env.init << trace_sh_command("sudo service #{srv} start")
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
