module Vx
  module Builder
    class Script

      class Deploy < Base

        def call(env)
          if enabled?(env)
            env.source.deploy.providers.each do |provider|
              if provider.shell?
                deploy_using_shell(env, provider)
              end
            end
          end

          do_before_deploy(env) do |i|
            i += env.source.before_deploy
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.task.deploy? && env.source.deploy?
          end

          def deploy_using_shell(env, provider)
            do_deploy(env) do |i|
              provider.command.each do |cmd|
                i << trace_sh_command(cmd)
              end
            end
          end

      end
    end
  end
end
