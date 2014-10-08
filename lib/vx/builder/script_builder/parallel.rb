module Vx
  module Builder
    class ScriptBuilder

      class Parallel < Base

        def call(env)
          if env.source.parallel?
            env.init << trace_sh_command("export CI_PARALLEL_JOBS=#{env.source.parallel}")
            env.init << trace_sh_command("export CI_PARALLEL_JOB_NUMBER=#{env.source.parallel_job_number}")
          end

          app.call(env)
        end

      end
    end
  end
end
