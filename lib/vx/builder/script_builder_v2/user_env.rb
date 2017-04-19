module Vx
  module Builder
    class ScriptBuilderV2
      class UserEnv < Base
        def call(env)
          env.stage("init").tap do |e|
            add_var = ->(var) {
              var = var.split("=")
              key = var.shift
              value = var.join("=").to_s
              e.add_env key, value
            }

            env.source.env.global.each &add_var
            env.source.env.matrix.each &add_var
          end

          app.call(env)
        end
      end
    end
  end
end
