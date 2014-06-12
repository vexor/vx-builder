module Vx
  module Builder
    class ScriptBuilder

      class Env < Base

        def call(env)
          env.init << "set -e"
          env.init << "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          env.init << 'export LC_ALL=en_US.UTF8'
          env.init << 'export DEBIAN_FRONTEND=noninteractive'

          export_vars(env, env.init)
          export_vars(env, env.after_script_init)

          env.source.env.global.each do |e|
            env.init << trace_sh_command("export #{e}")
          end
          env.source.env.matrix.each do |e|
            env.init << trace_sh_command("export #{e}")
          end
          app.call(env)
        end

        private

          def export_vars(env, collection)
            collection << "export CI_JOB_ID=#{env.task.job_id}"
            collection << "export CI_BUILD_ID=#{env.task.build_id}"

            if b = env.task.branch
              collection << "export CI_BRANCH=#{b}"
            end
          end

      end
    end
  end
end
