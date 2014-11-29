module Vx
  module Builder
    class ScriptBuilderV2

      class Deploy < Base

        def call(env)
          do_before_deploy(env) do
            env.stage("before_script").tap do |i|
              env.source.before_deploy.each do |c|
                i.add_task "shell", c
              end
            end
          end

          do_deploy_script(env) do
            env.stage("script").tap do |i|
              env.source.deploy_modules.each do |m|
                m.to_commands.each do |c|
                  i.add_task "shell", c
                end
              end
            end
          end

          do_after_deploy(env) do
            env.stage("after_success").tap do |i|
              env.source.after_deploy.each do |c|
                i.add_task "shell", c
              end
            end
          end

          app.call(env)
        end

      end
    end
  end
end
