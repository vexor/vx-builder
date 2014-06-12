module Vx
  module Builder
    class ScriptBuilder

      class Deploy < Base

        def call(env)
          do_before_deploy(env) do |e|
            env.source.before_deploy.each do |c|
              e << trace_sh_command(c)
            end
          end

          do_deploy_script(env) do |e|
            env.source.deploy_modules.each do |m|
              m.to_commands.each do |c|
                e << trace_sh_command(c)
              end
            end
          end

          do_after_deploy(env) do |e|
            env.source.after_deploy.each do |c|
              e << trace_sh_command(c)
            end
          end

          app.call(env)
        end

      end
    end
  end
end
