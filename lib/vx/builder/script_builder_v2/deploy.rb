module Vx
  module Builder
    class ScriptBuilderV2

      # env.source.deploy - deploy tasks
      # env.taks.branch - current branch name
      class Deploy < Base

        def call(env)

          do_before_deploy(env) do
            env.stage("before_script").tap do |i|
              env.source.before_deploy.each do |c|
                i.add_task "shell", c
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

          do_deploy_script(env) do
            %w(install database script).each do |stage|
              env.stage(stage).tap do |i|
                env.source.deploy_modules.sort_by(&:rate).each do |m|
                  i.process_task(m)
                end
              end
            end
          end
        end

      end
    end
  end
end
