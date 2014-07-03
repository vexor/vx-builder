module Vx
  module Builder
    class ScriptBuilder

      class Nodejs < Base

        DEFAULT_NODE = '0.10'

        def call(env)
          if enabled?(env)

            vxvm_install(env, 'nodejs', node_version(env))

            do_cache_key(env) do |i|
              i << "nodejs-#{node_version env}"
            end

            do_announce(env) do |i|
              i << trace_sh_command("node --version")
              i << trace_sh_command("npm --version")
            end

            do_install(env) do |i|
              i << trace_sh_command("npm install")
            end

            do_script(env) do |i|
              i << trace_sh_command("npm test")
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.node_js.first || env.source.language == 'node_js'
          end

          def node_version(env)
            env.source.node_js.first || DEFAULT_NODE
          end

      end
    end
  end
end
