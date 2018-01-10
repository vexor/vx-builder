module Vx
  module Builder
    class ScriptBuilderV2

      class Services < Base

        ALIASES = {
          'rabbitmq' => 'rabbitmq-server'
        }

        def call(env)
          env.stage("init").tap do |e|
            raw_srvs = normalize(env.source.services)
            srvs = raw_srvs.select{ |srv| legacy_service?(srv) }
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

        def normalize(srvs)
          srvs.inject([]) do |b, element|
            case element
            when Hash
              element.each do |k, v|
                if v =~ /local/
                  b << k
                else
                  b << {k => v}
                end
              end
            else
              b << element
            end
            b
          end
        end

      end
    end
  end
end
