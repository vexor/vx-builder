module Vx
  module Builder
    class ScriptBuilder

      class Clojure < Base

        def call(env)
          if enabled?(env)
            do_announce(env) do |i|
              i << trace_sh_command("lein version")
            end

            do_install(env) do |i|
              i << trace_sh_command("lein deps")
            end

            do_script(env) do |i|
              i << trace_sh_command("lein test")
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
