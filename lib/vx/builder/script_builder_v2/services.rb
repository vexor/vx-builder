module Vx
  module Builder
    class ScriptBuilderV2

      class Services < Base

        ALIASES = {
          'rabbitmq' => 'rabbitmq-server'
        }

        def call(env)
          env.stage("init").tap do |e|
            srvs = env.source.services.map do |srv|
              srv = ALIASES[srv] || srv
            end
            e.add_task "services", srvs
          end

          app.call(env)
        end

      end
    end
  end
end
