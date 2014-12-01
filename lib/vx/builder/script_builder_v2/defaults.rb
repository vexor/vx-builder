module Vx
  module Builder
    class ScriptBuilderV2

      class Defaults < Base

        def call(env)
          env.source.before_install.each do |c|
            env.stage("before_install").tap do |i|
              i.add_task "shell", c
            end
          end

          env.source.install.each do |c|
            env.stage("install").tap do |i|
              i.add_task "shell", c
            end
          end

          if env.source.database?
            env.source.database.each do |c|
              env.stage("database").tap do |i|
                i.add_task "shell", c
              end
            end
          end

          env.source.before_script.each do |c|
            env.stage("before_script").tap do |i|
              i.add_task "shell", c
            end
          end

          env.source.script.each do |c|
            env.stage("script").tap do |i|
              i.add_task "shell", c
            end
          end

          env.source.after_success.each do |c|
            env.stage("after_success").tap do |i|
              i.add_task "shell", c
            end
          end

          app.call env
        end

      end
    end
  end
end
