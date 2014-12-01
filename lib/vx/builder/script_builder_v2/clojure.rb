module Vx
  module Builder
    class ScriptBuilderV2

      class Clojure < Base

        def call(env)
          if enabled?(env)

            env.stage("install").tap do |i|
              i.add_task "shell", "lein version"
              do_install(env) do
                i.add_task "shell", "lein deps"
              end
            end

            env.stage("script").tap do |i|
              do_script(env) do
                i.add_task "shell", "lein test"
              end
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.language == 'clojure'
          end

      end
    end
  end
end
