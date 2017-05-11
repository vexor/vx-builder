module Vx
  module Builder
    class ScriptBuilderV2

      class Services < Base

        ALIASES = {
          'rabbitmq' => 'rabbitmq-server'
        }

        def call(env)
          env.stage("init").tap do |e|
            srvs = env.source.services
                     .select{ |srv| legacy_service?(srv) }
                     .map{ |srv| srv = ALIASES[srv] || srv }
            e.add_task "services", srvs
          end

          app.call(env)
        end

        private

        # If service is array - it is new service, skip it
        def legacy_service?(service)
          case service
          when Array, Hash
            return false
          else
            return true
          end
        end

      end
    end
  end
end
