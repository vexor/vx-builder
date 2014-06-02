module Vx
  module Builder
    class Script

      Script = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.source.before_install.each do |c|
            env.before_install << trace_sh_command(c)
          end

          if env.task.deploy?
            env.source.before_deploy.each do |c|
              env.before_script << trace_sh_command(c)
            end
            env.source.after_deploy.each do |c|
              env.after_success << trace_sh_command(c)
            end
          else
            env.source.before_script.each do |c|
              env.before_script << trace_sh_command(c)
            end
            env.source.script.each do |c|
              env.script << trace_sh_command(c)
            end
            env.source.after_success.each do |c|
              env.after_success << trace_sh_command(c)
            end
          end

          app.call(env)
        end

      end
    end
  end
end
