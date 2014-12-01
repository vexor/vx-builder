module Vx
  module Builder
    class ScriptBuilderV2

      class Nodejs < Base

        DEFAULT_NODE = '0.10'
        NPM_PACKAGES = 'node_modules'
        BOWER_COMPONENTS = 'bower_components'

        def call(env)
          if enabled?(env)

            do_cache_key(env) do |i|
              i << "nodejs-#{node_version env}"
            end

            do_cached_directories(env) do |i|
              i << NPM_PACKAGES
              i << BOWER_COMPONENTS
            end

            env.stage("install").tap do |i|
              i.add_env 'PATH', "${PATH}:${PWD}/#{NPM_PACKAGES}/bin"
              i.add_task "vxvm", "nodejs #{node_version(env)}"
              i.add_task "shell", 'npm config set spin false'
              i.add_task 'shell', 'node --version'
              i.add_task 'shell', 'npm --version'

              do_install(env) do
                i.add_task 'shell', 'npm install'
              end
            end

            do_script(env) do
              env.stage("script").tap do |i|
                i.add_task 'shell', 'npm test'
              end
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
