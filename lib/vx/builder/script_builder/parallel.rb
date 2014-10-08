module Vx
  module Builder
    class ScriptBuilder

      class Parallel < Base

        def call(env)
          if enabled?(env)

            vxvm_install(env, 'nodejs', node_version(env))

          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.parallel_job_number?
          end

      end
    end
  end
end
